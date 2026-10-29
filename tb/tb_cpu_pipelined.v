`timescale 1ns/1ns

// Directed tests for the 5-stage pipelined CPU.
// Optional plusargs:
//   +trace   print the full pipeline state every cycle
//   +events  print one line per forward / stall / flush
//   +vcd     dump waveforms to tb_cpu_pipelined.vcd
module tb_cpu_pipelined;
    localparam int MAX_CYCLES = 1000; // Timeout in case the halt loop is never reached

    logic clk = 0;
    logic reset = 1;

    int test_passed = 0;
    int test_failed = 0;
    int cycles = 0; // Cycles since reset was released

    // Instantiate CPU
    cpu_pipelined uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    // ================================ Instruction Encoders ================================
    // Arguments follow assembly order, e.g. ADDI(rd, rs1, imm) for `addi rd, rs1, imm`
    function automatic logic [31:0] r_type(input logic [6:0] funct7, input logic [4:0] rs2, rs1,
                                           input logic [2:0] funct3, input logic [4:0] rd);
        return {funct7, rs2, rs1, funct3, rd, 7'b0110011};
    endfunction

    function automatic logic [31:0] ADD(input logic [4:0] rd, rs1, rs2); return r_type(7'b0000000, rs2, rs1, 3'b000, rd); endfunction
    function automatic logic [31:0] SUB(input logic [4:0] rd, rs1, rs2); return r_type(7'b0100000, rs2, rs1, 3'b000, rd); endfunction
    function automatic logic [31:0] AND(input logic [4:0] rd, rs1, rs2); return r_type(7'b0000000, rs2, rs1, 3'b111, rd); endfunction
    function automatic logic [31:0] OR (input logic [4:0] rd, rs1, rs2); return r_type(7'b0000000, rs2, rs1, 3'b110, rd); endfunction

    function automatic logic [31:0] ADDI(input logic [4:0] rd, rs1, input int imm);
        logic [31:0] i;
        i = imm;
        return {i[11:0], rs1, 3'b000, rd, 7'b0010011};
    endfunction

    function automatic logic [31:0] NOP(); return ADDI(0, 0, 0); endfunction

    // lw rd, offset(rs1)
    function automatic logic [31:0] LW(input logic [4:0] rd, input int offset, input logic [4:0] rs1);
        logic [31:0] i;
        i = offset;
        return {i[11:0], rs1, 3'b010, rd, 7'b0000011};
    endfunction

    // sw rs2, offset(rs1)
    function automatic logic [31:0] SW(input logic [4:0] rs2, input int offset, input logic [4:0] rs1);
        logic [31:0] i;
        i = offset;
        return {i[11:5], rs2, rs1, 3'b010, i[4:0], 7'b0100011};
    endfunction

    // beq rs1, rs2, offset (offset in bytes, relative to this instruction)
    function automatic logic [31:0] BEQ(input logic [4:0] rs1, rs2, input int offset);
        logic [31:0] i;
        i = offset;
        return {i[12], i[10:5], rs2, rs1, 3'b000, i[4:1], i[11], 7'b1100011};
    endfunction

    // jal rd, offset (offset in bytes, relative to this instruction)
    function automatic logic [31:0] JAL(input logic [4:0] rd, input int offset);
        logic [31:0] i;
        i = offset;
        return {i[20], i[10:1], i[11], i[19:12], rd, 7'b1101111};
    endfunction

    // ==================================== Helpers ====================================
    int n_inst = 0; // Number of instructions emitted so far

    // Append an instruction to instruction memory
    task automatic emit(input logic [31:0] inst);
        uut.instruction_memory.mem[n_inst] = inst;
        n_inst++;
    endtask

    task automatic check(input logic [31:0] actual, expected, input string name);
        if (actual === expected) begin
            $display("[PASS] %-36s 0x%h", name, actual);
            test_passed++;
        end else begin
            $display("[FAIL] %-36s 0x%h (expected 0x%h)", name, actual, expected);
            test_failed++;
        end
    endtask

    task automatic check_reg(input logic [4:0] r, input logic [31:0] expected, input string name);
        check(uut.register_file_init.registers[r], expected, $sformatf("x%0d %s", r, name));
    endtask

    // addr is a byte address
    task automatic check_mem(input logic [31:0] addr, input logic [31:0] expected, input string name);
        check(uut.data_memory.mem[addr[12:2]], expected, $sformatf("mem[0x%0h] %s", addr, name));
    endtask

    task automatic display_pipeline_state();
        $display("\n--- Cycle %0d ---", cycles);
        $display("IF : PC=0x%h inst=0x%h", uut.pc, uut.instruction);
        $display("ID : PC=0x%h inst=0x%h rs1=x%0d rs2=x%0d rd=x%0d",
                 uut.if_id_pc, uut.if_id_instruction, uut.rs1_addr, uut.rs2_addr, uut.rd_addr);
        $display("EX : opcode=0b%b A=0x%h B=0x%h result=0x%h",
                 uut.id_ex_opcode, uut.alu_a, uut.alu_b, uut.alu_result);
        $display("MEM: addr=0x%h wdata=0x%h rdata=0x%h rd=x%0d",
                 uut.ex_mem_alu_result, uut.ex_mem_rs2_data, uut.mem_rdata, uut.ex_mem_rd_addr);
        $display("WB : wdata=0x%h rd=x%0d we=%b",
                 uut.rd_data_wb, uut.mem_wb_rd_addr, uut.mem_wb_reg_write_enable);
        if (uut.stall)             $display("STALL");
        if (uut.flush)             $display("FLUSH");
        if (uut.forward_a != 2'b00) $display("Forward A: %0d", uut.forward_a);
        if (uut.forward_b != 2'b00) $display("Forward B: %0d", uut.forward_b);
    endtask

    function automatic string fwd_source(input logic [1:0] sel);
        return (sel == 2'b10) ? "EX/MEM" : "MEM/WB";
    endfunction

    // One line per hazard event, PCs are those of the instructions involved
    task automatic display_events();
        if (uut.forward_a != 2'b00)
            $display("[cyc %3d] FORWARD  EX  pc=0x%h rs1=x%0d <- %s",
                     cycles, uut.id_ex_pc, uut.id_ex_rs1_addr, fwd_source(uut.forward_a));
        if (uut.forward_b != 2'b00)
            $display("[cyc %3d] FORWARD  EX  pc=0x%h rs2=x%0d <- %s",
                     cycles, uut.id_ex_pc, uut.id_ex_rs2_addr, fwd_source(uut.forward_b));
        if (uut.stall)
            $display("[cyc %3d] STALL    ID  pc=0x%h waits for load x%0d in EX",
                     cycles, uut.if_id_pc, uut.id_ex_rd_addr);
        if (uut.branch_condition_met)
            $display("[cyc %3d] FLUSH    MEM pc=0x%h branch taken -> 0x%h",
                     cycles, uut.ex_mem_pc_plus4 - 4, uut.pc_next);
        else if (uut.jump_taken_ex)
            $display("[cyc %3d] FLUSH    EX  pc=0x%h jump -> 0x%h",
                     cycles, uut.id_ex_pc, uut.pc_next);
    endtask

    // ================================ Performance Counters ================================
    // The program ends with `jal x0, 0` at halt_pc; it is done once that jump reaches WB
    logic [31:0] halt_pc;
    logic        halted = 0;
    int          retired = 0; // Instructions that reached WB, excluding the halt jump
    int          stall_cycles = 0;
    int          flush_cycles = 0;
    logic        trace;
    logic        events;

    initial begin
        trace  = $test$plusargs("trace");
        events = $test$plusargs("events");
        if ($test$plusargs("vcd")) begin
            $dumpfile("tb_cpu_pipelined.vcd");
            $dumpvars(0, tb_cpu_pipelined);
        end
    end

    // Sample on negedge so the pipeline registers have settled after posedge
    always @(negedge clk) begin
        if (!reset && !halted) begin
            cycles++;
            if (trace) display_pipeline_state();
            if (events) display_events();
            if (uut.stall) stall_cycles++;
            if (uut.flush) flush_cycles++;
            if (uut.mem_wb_valid) begin
                if (uut.mem_wb_pc_plus4 == halt_pc + 4) halted = 1;
                else retired++;
            end
        end
    end

    // ==================================== Test Program ====================================
    task automatic load_program();
        // Start from empty memories so bin/firmware.img doesn't leak into the test
        for (int i = 0; i < 2048; i++) begin
            uut.instruction_memory.mem[i] = 32'b0;
            uut.data_memory.mem[i] = 32'b0;
        end

        // Test 1: Basic ALU operations (no hazards)
        emit(ADDI(1, 0, 1));          // x1 = 1
        emit(ADDI(2, 0, 2));          // x2 = 2
        emit(ADDI(3, 0, 3));          // x3 = 3
        emit(ADDI(4, 0, 4));          // x4 = 4

        // Test 2: EX/MEM -> EX forwarding
        emit(ADD(5, 1, 2));           // x5 = x1 + x2 = 3
        emit(ADD(6, 3, 5));           // x6 = x3 + x5 = 6, x5 forwarded from EX/MEM

        // Test 3: MEM/WB -> EX forwarding
        emit(ADD(7, 0, 4));           // x7 = x4 = 4
        emit(NOP());
        emit(ADD(8, 1, 7));           // x8 = x1 + x7 = 5, x7 forwarded from MEM/WB

        // Test 4: Load-use hazard (1 stall)
        emit(LW(9, 0, 0));            // x9 = mem[0x0] = 4
        emit(ADDI(10, 9, 0));         // x10 = x9 = 4

        // Test 5: Store
        emit(SW(5, 4, 10));           // mem[0x8] = x5 = 3

        // Test 6: Branch not taken
        emit(BEQ(1, 2, 8));           // x1 != x2, falls through
        emit(ADDI(12, 0, -5));        // x12 = -5, must execute

        // Test 7: Branch taken
        emit(ADDI(13, 1, 1));         // x13 = 2
        emit(BEQ(2, 13, 8));          // x2 == x13, skip next
        emit(ADDI(14, 0, -1));        // skipped
        emit(ADDI(15, 0, 6));         // branch target: x15 = 6

        // Test 8: JAL (at PC 0x48)
        emit(JAL(16, 8));             // x16 = 0x4C, skip next
        emit(ADDI(17, 0, -1));        // skipped
        emit(ADDI(18, 0, 7));         // jump target: x18 = 7

        // Test 9: More ALU operations
        emit(SUB(19, 1, 2));          // x19 = 1 - 2 = -1
        emit(AND(20, 1, 2));          // x20 = 1 & 2 = 0
        emit(OR(21, 1, 2));           // x21 = 1 | 2 = 3

        // Test 10: Two loads feeding one add
        emit(LW(22, 4, 20));          // x22 = mem[0x4] = 8
        emit(LW(23, 12, 20));         // x23 = mem[0xC] = 8
        emit(ADD(24, 22, 23));        // x24 = 16

        // Test 11: Store data forwarding (sw right after the write to rs2)
        emit(ADDI(25, 0, 'h77));      // x25 = 0x77
        emit(SW(25, 16, 0));          // mem[0x10] = 0x77

        // Halt: jump to self
        halt_pc = n_inst * 4;
        emit(JAL(0, 0));

        // Data memory
        uut.data_memory.mem[0] = 32'h4;
        uut.data_memory.mem[1] = 32'h8;
        uut.data_memory.mem[3] = 32'h8;
    endtask

    task automatic check_results();
        // Test 1
        check_reg(1,  32'h1, "addi");
        check_reg(2,  32'h2, "addi");
        check_reg(3,  32'h3, "addi");
        check_reg(4,  32'h4, "addi");
        // Test 2
        check_reg(5,  32'h3, "add");
        check_reg(6,  32'h6, "EX/MEM forward");
        // Test 3
        check_reg(7,  32'h4, "add");
        check_reg(8,  32'h5, "MEM/WB forward");
        // Test 4
        check_reg(9,  32'h4, "lw");
        check_reg(10, 32'h4, "load-use stall");
        // Test 5
        check_mem(32'h8, 32'h3, "sw");
        // Test 6 & 7
        check_reg(12, 32'hFFFF_FFFB, "branch not taken");
        check_reg(13, 32'h2, "branch setup");
        check_reg(14, 32'h0, "skipped by branch");
        check_reg(15, 32'h6, "branch target");
        // Test 8
        check_reg(16, 32'h4C, "jal return address");
        check_reg(17, 32'h0, "skipped by jal");
        check_reg(18, 32'h7, "jal target");
        // Test 9
        check_reg(19, 32'hFFFF_FFFF, "sub");
        check_reg(20, 32'h0, "and");
        check_reg(21, 32'h3, "or");
        // Test 10
        check_reg(22, 32'h8, "lw");
        check_reg(23, 32'h8, "lw");
        check_reg(24, 32'h10, "add after two loads");
        // Test 11
        check_reg(25, 32'h77, "addi");
        check_mem(32'h10, 32'h77, "store data forward");
    endtask

    // ==================================== Main ====================================
    initial begin
        $display("================= 5-Stage Pipelined CPU Testbench ==================");

        // Hold reset for a few cycles, then load after the memories' own initial blocks
        repeat (2) @(posedge clk);
        load_program();
        $display("[INFO] Loaded %0d instructions, halt at PC 0x%h", n_inst, halt_pc);

        @(negedge clk);
        reset = 0;

        wait (halted || cycles >= MAX_CYCLES);
        if (!halted) begin
            $display("[FAIL] Timeout: halt not reached after %0d cycles", MAX_CYCLES);
            test_failed++;
        end

        $display("\n=== Results ===");
        check_results();

        $display("\n=== Performance ===");
        $display("Cycles       : %0d (includes 4-cycle pipeline fill)", cycles);
        $display("Retired      : %0d", retired);
        $display("CPI          : %0.2f", real'(cycles) / retired);
        $display("Stall cycles : %0d", stall_cycles);
        $display("Flush cycles : %0d", flush_cycles);

        $display("\n=== Summary: %0d passed, %0d failed ===", test_passed, test_failed);
        if (test_failed != 0) $fatal(1, "Pipelined CPU tests failed");
        $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
