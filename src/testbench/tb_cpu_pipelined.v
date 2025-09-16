`timescale 1ns/1ps

module tb_cpu_pipelined;
    reg clk;
    reg reset;

    // Test program counter 
    integer cycle_count;
    integer test_passed;
    integer test_failed;

    // Instantiate CPU
    cpu_pipelined uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation 
    always #5 clk = ~clk;

    // Task for testing
    task check_register (input [4:0] reg_addr, input [31:0] expected, input string test_name);
        begin 
            if (uut.register_file_init.registers[reg_addr] == expected) begin 
                $display("[PASS] %s: x%0d = 0x%h (Expected: 0x%h)", 
                        test_name, reg_addr, uut.register_file_init.registers[reg_addr], expected);
                test_passed++;
            end else begin 
                $display("[FAIL] %s: x%0d = 0x%h (Expected: 0x%h)", 
                        test_name, reg_addr, uut.register_file_init.registers[reg_addr], expected);
                test_failed++;
            end 
        end 
    endtask

    task wait_cycles(input integer cycles);
        begin
            repeat(cycles) @(posedge clk);
        end
    endtask

    // Task to display current pipeline state 
    task display_pipeline_state();
        begin
            $display("\n--- Cycle %0d Pipeline Status ---", cycle_count);
            $display("IF : PC=%0d, Inst=0b%b", uut.pc, uut.instruction);
            $display("ID : PC=%0d, Inst=0b%b, rs1=%0d, rs2=%0d, rd=%0d", 
                    uut.if_id_pc, uut.if_id_instruction, 
                    uut.rs1_addr, uut.rs2_addr, uut.rd_addr);
            $display("EX : Opcode=0b%b, ALU_A=0x%h, ALU_B=0x%h, Result=0x%h", 
                    uut.id_ex_opcode, uut.alu_a, uut.alu_b, uut.alu_result);
            $display("MEM: Addr=0x%h, WData=0x%h, RData=0x%h, rd=%0d", 
                    uut.ex_mem_alu_result, uut.ex_mem_rs2_data, uut.mem_rdata, uut.ex_mem_rd_addr);
            $display("WB : WData=0x%h, rd=%0d, WE=%b", 
                    uut.rd_data_wb, uut.mem_wb_rd_addr, uut.mem_wb_reg_write_enable);
            
            if (uut.stall) $display("STALL detected!");
            if (uut.flush) $display("FLUSH detected!");
            if (uut.forward_a != 2'b00) $display("Forward A: %0d", uut.forward_a);
            if (uut.forward_b != 2'b00) $display("Forward B: %0d", uut.forward_b);
        end
    endtask

    // Test sequence 
    initial begin 
        $display("================= 5-Stage Pipelined CPU Testbench ==================");

        // Initialize signals 
        clk = 0;
        reset = 1;
        cycle_count = 0;
        test_passed = 0;
        test_failed = 0;

        // Wait for a few clock cycles before releasing reset
        wait_cycles(2);

        $display("\n[INFO] Loading test program into instruction memory...");

        // Initialize instruction memory with a test program

        // Test Case 1: Basic ALU operations (no hazards)
        uut.instruction_memory.mem[0] = 32'b000000000001_00000_000_00001_0010011; // addi x1, x0, 1    # x1 = 1
        uut.instruction_memory.mem[1] = 32'b000000000010_00000_000_00010_0010011; // addi x2, x0, 2    # x2 = 2  
        uut.instruction_memory.mem[2] = 32'b000000000011_00000_000_00011_0010011; // addi x3, x0, 3    # x3 = 3
        uut.instruction_memory.mem[3] = 32'b000000000100_00000_000_00100_0010011; // addi x4, x0, 4    # x4 = 4

        // Test Case 2: Data hazard with forwarding (EX/MEM->EX forwarding)
        uut.instruction_memory.mem[4] = 32'b0000000_00010_00001_000_00101_0110011; // add x5, x1, x2   # x5 = x1 + x2 = 3
        uut.instruction_memory.mem[5] = 32'b0000000_00101_00011_000_00110_0110011; // add x6, x3, x5   # x6 = x3 + x5 = 6 (EX forwarding)

        // Test Case 3: Data hazard with forwarding (MEM/WB->MEM forwarding)
        uut.instruction_memory.mem[6] = 32'b0000000_00100_00000_000_00111_0110011; // add x7, x0, x4   # x7 = x4 = 4
        uut.instruction_memory.mem[7] = 32'b000000000000_00000_000_00000_0010011;  // nop (addi x0, x0, 0)
        uut.instruction_memory.mem[8] = 32'b0000000_00111_00001_000_01000_0110011; // add x8, x1, x7   # x8 = x1 + x7 = 5 (MEM forwarding)

        // Test Case 4: Load-use hazard (should cause stall)
        uut.instruction_memory.mem[9] = 32'b000000000000_00000_010_01001_0000011;  // lw x9, 0(x0)     # Load from memory[0]
        uut.instruction_memory.mem[10] = 32'b000000000000_01001_000_01010_0010011;// addi x10, x9, 0  # Use loaded value (stall required)

        // Test Case 5: Store operation 
        uut.instruction_memory.mem[11] = 32'b0000000_00101_01010_010_00100_0100011;// sw x5, 4(x10)     # Store x5 to memory[1]

        // Test Case 6: Branch instruction (Branch not taken)
        uut.instruction_memory.mem[12] = 32'b0000000_00010_00001_000_01011_1100011;// beq x1, x2, 0    # x1 != x2
        uut.instruction_memory.mem[13] = 32'b111111111011_00000_000_01100_0010011; // addi x12, x0, -5     

        // Test Case 7: Branch instruction (Branch taken)
        uut.instruction_memory.mem[14] = 32'b000000000001_00001_000_01101_0010011;  // addi x13, x1, 1     # x13 = 2
        uut.instruction_memory.mem[15] = 32'b0000000_01101_00010_000_01000_1100011; // beq x2, x13, +8     # x2==x13
        uut.instruction_memory.mem[16] = 32'b111111111111_00000_000_01110_0010011;  // addi x14, x0, -1    # Skip 
        uut.instruction_memory.mem[17] = 32'b000000000110_00000_000_01111_0010011;  // addi x15, x0, 6     # Target for branch

        // Test Case 8: JAL 
        uut.instruction_memory.mem[18] = 32'b000000001000_00000000_10000_1101111;   // jal x16, +8         # Jump and store pc+4
        uut.instruction_memory.mem[19] = 32'b111111111111_00000_000_10001_0010011;  // addi x17, x0, -1    # Skip
        uut.instruction_memory.mem[20] = 32'b000000000111_00000_000_10010_0010011;  // addi x18, x0, 7     # Target for jumping

        // Test Case 9: Several ALU oprations
        uut.instruction_memory.mem[21] = 32'b0100000_00010_00001_000_10011_0110011; // sub x19, x1, x2     # x19 = x1 - x2 = -1
        uut.instruction_memory.mem[22] = 32'b0000000_00010_00001_111_10100_0110011; // and x20, x1, x2     # x20 = x1 & x2 = 0
        uut.instruction_memory.mem[23] = 32'b0000000_00010_00001_110_10101_0110011; // or x21, x1, x2      # x21 = x1 | x2 = 3

        // Initialize data memory
        uut.data_memory.mem[0] = 32'h00000004; // 0 in decimal
        uut.data_memory.mem[2] = 32'h00000000; // Will be written to store x5

        $display("[INFO] Test program loaded. Starting execution...");
        $display("[INFO] Data memory[0] = 0x%h", uut.data_memory.mem[0]);

        // Release reset
        reset = 0;
        $display("[INFO] Reset released. Starting execution...");

        // Monitor pipeline for several cycles
        repeat(34) begin // 24 cc for instruction + 4 overhead + 1 stall + 1 JAL flush + 3 BEQ flush
            @(posedge clk);
            cycle_count++;
            //if (cycle_count <= 20 || (cycle_count % 5 == 0)) begin
                display_pipeline_state();
            //end
        end 

        $display("\n=== Pipeline Execution Complete ===\n");
        $display("=== Verifying Results ===");
        
        // Test Case 1: Basic ALU operations (no hazards)
        check_register(1, 32'h00000001, "Basic ADDI x1");
        check_register(2, 32'h00000002, "Basic ADDI x2");
        check_register(3, 32'h00000003, "Basic ADDI x3");
        check_register(4, 32'h00000004, "Basic ADDI x4");

        // Test Case 2: Data hazard with forwarding (EX/MEM->EX forwarding)
        check_register(5, 32'h00000003, "EX/MEM Setup x5");
        check_register(6, 32'h00000006, "EX/MEM Forward x6 = x3 + x5");

        // Test Case 3: Data hazard with forwarding (MEM/WB->MEM forwarding)
        check_register(7, 32'h00000004, "MEM/WB Setup x7");
        check_register(8, 32'h00000005, "MEM/WB Forward x8 = x1 + x7");

        // Test Case 4: Load-use hazard (should cause stall)
        check_register(9, 32'h00000004, "Load-Use x9 from memory[0]");
        check_register(10, 32'h00000004, "ADDI x10 = x9 + 0");

        // Test Case 5: Store operation 
        if (uut.data_memory.mem[2] == 32'h00000003) begin
            $display("[PASS] Store operation: mem[2] = 0x%h", uut.data_memory.mem[2]);
            test_passed++;
        end else begin
            $display("[FAIL] Store operation: mem[2] = 0x%h (Expected: 0x00000003)", uut.data_memory.mem[2]);
            test_failed++;
        end

        // Test Case 6 & 7: Branch instruction
        check_register(12, 32'hFFFFFFFB, "Branch not taken x12");
        check_register(13, 32'h00000002, "Branch setup x13");
        check_register(15, 32'h00000006, "Branch taken x15");

        // Test Case 8: JAL 
        if (uut.register_file_init.registers[16] != 32'h00000000) begin
            $display("[PASS] JAL x16 return address: 0x%h", uut.register_file_init.registers[16]);
            test_passed++;
        end else begin
            $display("[FAIL] JAL x16 return address should not be 0");
            test_failed++;
        end
        check_register(18, 32'h00000007, "JAL target x18");

        // Test Case 9: Several ALU oprations
        check_register(19, 32'hFFFFFFFF, "SUB x19 = x1 - x2");
        check_register(20, 32'h00000000, "AND x20 = x1 & x2");
        check_register(21, 32'h00000003, "OR x21 = x1 | x2");



        // Summary
        $display("\n======== Test Summary =======");
        $display("Tests Passed: %0d", test_passed);
        $display("Tests Failed: %0d", test_failed);
        $display("Success Rate: %0.1f%%", (test_passed * 100.0) / (test_passed + test_failed));
        
        if (test_failed == 0) begin
            $display("ALL TESTS PASSED! Pipelined CPU is working correctly!");
        end else begin
            $display("Some tests failed. Please check the implementation.");
        end

        // Performance 
        $display("\n=== Performance Analysis ===");
        $display("Total Cycles: %0d", cycle_count);
        $display("Instructions: ~24");
        $display("Estimated CPI: ~%0.2f", cycle_count / 24.0);
        $display("Note: Lower CPI indicates better pipeline efficiency");

        $display("=========================================");

        $finish;
    end 
    
endmodule