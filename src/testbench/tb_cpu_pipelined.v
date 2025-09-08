`timescale 1ns/1ps

module tb_cpu_pipelined;
    reg clk;
    reg reset;

    // Expected results for verification
    logic [31:0] expected_results [0:15];

    // Test program counter 
    integer cycle_count;
    integer instruction_count;

    // Instantiate CPU
    cpu_pipelined uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation 
    always #5 clk = ~clk;

    // Test sequence 
    initial begin 
        $display("================= Pipelined CPU Testbench ==================");

        // Initialize signals 
        clk = 0;
        reset = 1;

        // Wait for a few clock cycles before releasing reset
        repeat(5) @(posedge clk);

        $display("@(T=%0t) [INFO] Initializing memory with test program...", $time);

        // Initialize instruction memory with a test program

        // Test Case 1: Basic ALU operations (no hazards)
        uut.instruction_memory.mem[0] = 32'b000000000001_00000_000_00001_0010011; // addi x1, x0, 1    # x1 = 1
        uut.instruction_memory.mem[1] = 32'b000000000010_00000_000_00010_0010011; // addi x2, x0, 2    # x2 = 2  
        uut.instruction_memory.mem[2] = 32'b000000000011_00000_000_00011_0010011; // addi x3, x0, 3    # x3 = 3

        // Test Case 2: Data hazard with forwarding (EX/MEM->EX forwarding)
        uut.instruction_memory.mem[3] = 32'b0000000_00010_00001_000_00100_0110011; // add x4, x1, x2    # x4 = x1 + x2 = 3
        uut.instruction_memory.mem[4] = 32'b0000000_00100_00011_000_00101_0110011; // add x5, x3, x4    # x5 = x3 + x4 = 6 (needs forwarding)

        // Test Case 3: Load-use hazard (should cause stall)
        uut.instruction_memory.mem[5] = 32'b000000000000_00000_010_00110_0000011; // lw x6, 0(x0)     # Load from memory
        uut.instruction_memory.mem[6] = 32'b0000000_00110_00001_000_00111_0110011; // add x7, x1, x6   # Use loaded value (stall required)

        // Test Case 4: Store operation 
        uut.instruction_memory.mem[7] = 32'b0000000_00101_00000_010_00100_0100011; // sw x5, 4(x0)     # Store x5 to memory[1]

        // Test Case 5: Branch instruction (control hazard)
        uut.instruction_memory.mem[8] = 32'b0000000_00010_00001_000_01000_0110011; // add x8, x1, x2    # x8 = 3
        uut.instruction_memory.mem[9] = 32'b000000000000_01000_000_01001_0010011;  // addi x9, x8, 0    # x9 = x8 = 3
        uut.instruction_memory.mem[10] = 32'b0000000_00010_00001_000_01000_1100011; // beq x1, x2, 0    # Branch if x1 == x2 (false, no branch)
        uut.instruction_memory.mem[11] = 32'b000000000001_01001_000_01010_0010011;  // addi x10, x9, 1   # x10 = x9 + 1 = 4
        
        // Test Case 6: MEM/WB->EX forwarding
        uut.instruction_memory.mem[12] = 32'b000000000100_00000_010_01011_0000011; // lw x11, 4(x0)    # Load from memory[1] 
        uut.instruction_memory.mem[13] = 32'b000000000000_00000_000_00000_0010011; // nop (addi x0, x0, 0)
        uut.instruction_memory.mem[14] = 32'b0000000_01011_00001_000_01100_0110011; // add x12, x1, x11  # MEM->EX forwarding

        // Test Case 7: JAL 
        uut.instruction_memory.mem[15] = 32'b000000000000_00000_000_01101_1101111; // jal x13, +0 (next instruction)
        // PC+4 should be saved in x13

        // Test Case 8: JALR (Jump and Link Register) - Jump to absolute address
        uut.instruction_memory.mem[16] = 32'b000000001000_00000_000_01110_1100111; // jalr x14, 8(x0) => jump to 0x8
        // Should jump to PC=8, save return in x14 (but we jump to existing instruction for safety)

        // Test Case 9: SLT (Set if Less Than) - x15 = (x2 < x1) ? 1 : 0 => 2>1 => 0
        uut.instruction_memory.mem[17] = 32'b0000000_00001_00010_010_01111_0110011; // slt x15, x2, x1

        // Test Case 10: Load-Use Stall Chain 
        uut.instruction_memory.mem[18] = 32'b000000001010_00000_010_10000_0000011; // lw x16, 10(x0)     # x16 = 10
        uut.instruction_memory.mem[19] = 32'b0000000_00100_10000_000_10001_0110011; // add x17, x16, x4  # x17 = 10 + 4 = 14 (stall here)

        // Initialize data memory
        uut.data_memory.mem[0] = 32'h0000000A; // 10 in decimal
        uut.data_memory.mem[1] = 32'h00000000; // Will be written to store x5

        // Set expected results for verification
        expected_results[1]  = 32'h00000001; // x1 = 1
        expected_results[2]  = 32'h00000002; // x2 = 2
        expected_results[3]  = 32'h00000003; // x3 = 3
        expected_results[4]  = 32'h00000003; // x4 = x1 + x2 = 3
        expected_results[5]  = 32'h00000006; // x5 = x3 + x4 = 6
        expected_results[6]  = 32'h0000000A; // x6 = loaded value = 10
        expected_results[7]  = 32'h0000000B; // x7 = x1 + x6 = 11
        expected_results[8]  = 32'h00000003; // x8 = x1 + x2 = 3
        expected_results[9]  = 32'h00000003; // x9 = x8 + 0 = 3
        expected_results[10] = 32'h00000004; // x10 = x9 + 1 = 4
        expected_results[11] = 32'h00000006; // x11 = mem[1] = x5 = 6
        expected_results[12] = 32'h00000007; // x12 = x1 + x11 = 7
        expected_results[13] = 32'h00000040; // x13 = return address of jal (PC+4 of instruction 15 = 0x3C + 4 = 0x40)
        expected_results[14] = 32'h00000044; // x14 = return address of jalr (PC+4 of instruction 16 = 0x40 + 4 = 0x44)
        expected_results[15] = 32'h00000000; // x15 = (x2 < x1) = 0
        expected_results[16] = 32'h0000000A; // x16 = 10
        expected_results[17] = 32'h0000000D; // x17 = 14
        
        
        $display("@(T=%0t) [INFO] Test program loaded. Releasing reset...", $time);

        // Release reset
        reset = 0;
        $display("@(T=%0t) [INFO] Reset released. Starting execution...", $time);

        // Monitor pipeline for several cycles
        cycle_count = 0;
        repeat(23) begin // 18 cc for instruction + 4 overhead + 1 stall 
            @(posedge clk)
            cycle_count++;

            $display("\n@(T=%0t) ========== CYCLE %0d ==========", $time, cycle_count);
            $display("PC = 0x%h", uut.pc);

            // Display pipeline stages
            display_pipeline_state();

            // Display hazard detection
            display_hazard_state();

            // Display forwarding state
            display_forwarding_state();
        end 

        
        verify_results();
        $finish;
    end 
    // Task to display current pipeline state 
    task display_pipeline_state();
        begin
            $display("--- Pipeline State ---");
            $display("IF : PC=0x%h, Inst=0b%b", uut.pc, uut.instruction);
            $display("ID : PC=0x%h, Inst=0b%b", uut.if_id_pc, uut.if_id_instruction);
            $display("EX : PC=0x%h, Opcode=0b%b, rd=%d, alu.a=%0d, alu.b=%0d", uut.id_ex_pc, uut.id_ex_opcode, 
                uut.id_ex_rd_addr, uut.alu_a, uut.alu_b);
            $display("MEM: ALUresult=0x%h, rd=%d, Mem_read_enable=0b%b, Mem_write_enable=0b%b", uut.ex_mem_alu_result, 
                uut.ex_mem_rd_addr, uut.ex_mem_mem_read_enable, uut.ex_mem_mem_write_enable);
            $display("WB: Data to write back=0x%h, rd=%d, reg_write_enable=0b%b", uut.rd_data_wb, 
                uut.mem_wb_rd_addr, uut.mem_wb_reg_write_enable);
        end
    endtask

    // Task to display hazard detection state
    task display_hazard_state();
        begin
            $display("--- Hazard Detection ---");
            $display("Stall=%b, Flush=%b", uut.stall, uut.flush);
            if(uut.flush) begin
                $display("Next pc=0x%h", uut.pc_next);
            end 
        end
    endtask

    // Task to display forwarding state
    task display_forwarding_state();
        $display("--- Forwarding Unit ---");
        $display("Forward A=%b, Forward B=%b", uut.forward_a, uut.forward_b);
        if (uut.forward_a != 2'b00 || uut.forward_b != 2'b00) begin
                $display("ALU Input A=0x%h (forwarded=%b)", uut.alu_a_fwd, uut.forward_a != 2'b00);
                $display("ALU Input B=0x%h (forwarded=%b)", uut.alu_b_fwd, uut.forward_b != 2'b00);
        end
    endtask

    // Task to verify results
    task verify_results();
        integer i;
        integer passed_tests = 0;
        integer total_tests = 15;
        begin 
            $display("Verifying register values...");

            for (i = 1; i <= total_tests; i++) begin
                if(uut.register_file_init.registers[i] == expected_results[i]) begin
                    $display("Register x%0d: Expected=0x%h, Actual=0x%h [PASS]",
                    i, expected_results[i], uut.register_file_init.registers[i]);
                    passed_tests++;
                end else begin
                    $display("Register x%0d: Expected=0x%h, Actual=0x%h [FAIL]",
                    i, expected_results[i], uut.register_file_init.registers[i]);
                end 
            end 

            $display("\nTest Summary: %0d/%0d tests passed", passed_tests, total_tests);
        end 
    endtask
endmodule