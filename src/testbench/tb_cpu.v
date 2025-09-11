`timescale 1ns/1ps
module tb_cpu;
    logic clk;
    logic reset;

    // Test counters
    integer test_passed = 0;
    integer test_failed = 0;
    integer test_number = 0;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .reset(reset)
    );  

    // Clock generation
    always #5 clk = ~clk; // 10 time units clock period

    // Helper task for test verification
    task check_result(input [31:0] expected, input [31:0] actual, input string test_name);
        begin 
            test_number++;
            if (actual == expected) begin
                $display("Test %0d Passed: %s - Expected: 0x%h, Got: 0x%h", test_number, test_name, expected, actual);
                test_passed++;
            end else begin
                $display("Test %0d Failed: %s - Expected: 0x%h, Got: 0x%h", test_number, test_name, expected, actual);
                test_failed++;
            end 
        end 
    endtask

    // Helper task to execute one instruction and wait
    task execute_instruction();
        begin
            @(posedge clk); // Execute
            @(negedge clk); // Wait for completion
        end 
    endtask

    // Debug task to display internal signals
    task debug_cpu_state();
        begin
            $display("--- DEBUG INFO ---");
            $display("PC: 0x%h, Instruction: 0x%h", uut.pc, uut.instruction);
            $display("Opcode: 0b%b, rs1: %0d, rs2: %0d, rd: %0d", uut.opcode, uut.rs1_addr, uut.rs2_addr, uut.rd_addr);
            $display("ALU: a=0x%h, b=0x%h, control=0b%b, result=0x%h", uut.alu_a, uut.alu_b, uut.alu_control, uut.alu_result);
            $display("Control: reg_we=%b, mem_to_reg=%b, alu_src=%b", uut.reg_write_enable, uut.mem_to_reg, uut.alu_src);
            $display("Register data: rs1=0x%h, rs2=0x%h, rd_data=0x%h", uut.rs1_data, uut.rs2_data, uut.rd_data);
            $display("------------------");
        end
    endtask

    // Test sequence
    initial begin
        $display("------ Starting CPU Testbench ------");

        // Initialize signals
        clk = 0;
        reset = 1;

        // Wait for first clock edge and setup initial memory and register state 
        @(posedge clk);

        // ===== Test Case 1: Basic Load/Store Operations =====
        $display("\nTest Case 1: Basic Load/Store Operations");
        uut.instruction_memory.mem[0] = 32'b000000000000_00000_010_00001_0000011; // lw x1, 0(x0)
        uut.instruction_memory.mem[1] = 32'b0000000_00001_00000_010_00100_0100011; // sw x1, 4(x0)
        uut.data_memory.mem[0] = 32'hDEADBEEF; // Data at address 0

        // Release reset and test load
        //@(negedge clk);
        #1;
        reset = 0;

        execute_instruction();
        check_result(32'hDEADBEEF, uut.reg_file.registers[1], "Load Word (lw x1, 0(x0))");

        // Test store
        execute_instruction();  
        check_result(32'hDEADBEEF, uut.data_memory.mem[1], "Store Word (sw x1, 4(x0))");


        // ===== Test Case 2: Arithmetic Instructions (R-type) =====
        $display("\nTest Case 2: R-type Arithmetic Instructions");

        // Reset and setup for arithmetic tests
        reset = 1;
        @(posedge clk);

        // Pre-load registers for arithmetic tests
        uut.reg_file.registers[1] = 32'h0000000F; // x1 = 15
        uut.reg_file.registers[2] = 32'h00000005; // x2 = 5
        uut.reg_file.registers[3] = 32'h0000000A; // x3 = 10

        // Release reset
        //@(negedge clk);
        #1;
        reset = 0;

        // Test ADD instruction
        uut.instruction_memory.mem[0] = 32'b0000000_00010_00001_000_00100_0110011; // add x4, x1, x2 (15 + 5 = 20)
        execute_instruction();
        check_result(32'h00000014, uut.reg_file.registers[4], "ADD instruction (x4 = x1 + x2)");

        // Test SUB instruction  
        uut.instruction_memory.mem[1] = 32'b0100000_00010_00001_000_00101_0110011; // sub x5, x1, x2 (15 - 5 = 10)
        execute_instruction();
        check_result(32'h0000000A, uut.reg_file.registers[5], "SUB instruction (x5 = x1 - x2)");

        // Test AND instruction
        uut.instruction_memory.mem[2] = 32'b0000000_00010_00001_111_00110_0110011; // and x6, x1, x2 (15 & 5 = 5)
        execute_instruction();
        check_result(32'h00000005, uut.reg_file.registers[6], "AND instruction (x6 = x1 & x2)");

        // Test OR instruction
        uut.instruction_memory.mem[3] = 32'b0000000_00010_00001_110_00111_0110011; // or x7, x1, x2 (15 | 5 = 15)
        execute_instruction();
        check_result(32'h0000000F, uut.reg_file.registers[7], "OR instruction (x7 = x1 | x2)");

        // Test SLT instruction (Set Less Than)
        uut.instruction_memory.mem[4] = 32'b0000000_00001_00010_010_01000_0110011; // slt x8, x2, x1 (5 < 15 = 1)
        execute_instruction();
        check_result(32'h00000001, uut.reg_file.registers[8], "SLT instruction (x8 = x2 < x1)");

        // ===== Test Case 3: Immediate Arithmetic Instructions =====
        $display("\nTest Case 3: I-type Arithmetic Instructions");
        // Test ADDI instruction
        uut.instruction_memory.mem[5] = 32'b000000000001_00000_000_01001_0010011; // addi x9, x0, 1
        execute_instruction();
        check_result(32'h00000001, uut.reg_file.registers[9], "ADDI instruction (x9 = x0 + 1)");

        // Test ADDI with negative immediate  
        uut.instruction_memory.mem[6] = 32'b111111111111_01001_000_01010_0010011; // addi x10, x9, -1 (1 + (-1) = 0)
        execute_instruction();
        check_result(32'h00000000, uut.reg_file.registers[10], "ADDI with negative (x10 = x9 + (-1))");
        

        // ===== Test Case 4: Branch Instructions =====
        $display("\nTest Case 4: Branch Instructions");

        // Setup equal values for BEQ test
        uut.reg_file.registers[11] = 32'h00000007; // x11 = 7
        uut.reg_file.registers[12] = 32'h00000007; // x12 = 7

        // Test BEQ (Branch if Equal) - should branch
        uut.instruction_memory.mem[7] = 32'b0000000_01100_01011_000_01000_1100011; // beq x11, x12, +8
        uut.instruction_memory.mem[8] = 32'b000000000001_00000_000_01101_0010011; // addi x13, x0, 1 (should be skipped)
        uut.instruction_memory.mem[9] = 32'b000000000010_00000_000_01110_0010011; // addi x14, x0, 2 (target)
        
        execute_instruction();
        // Check if PC jumped correctly (should skip instruction at mem[8])
        check_result(32'h00000024, uut.pc, "BEQ branch taken (PC should jump)");
        
        execute_instruction(); // Execute the target instruction
        check_result(32'h00000002, uut.reg_file.registers[14], "BEQ target instruction executed");

        // Test BNE (Branch if Not Equal) - should not branch
        uut.reg_file.registers[15] = 32'h00000003; // x15 = 3
        uut.reg_file.registers[16] = 32'h00000003; // x16 = 3 (equal values)
        
        uut.instruction_memory.mem[10] = 32'b0000100_10000_01111_001_01001_1100011; // bne x15, x16, +8
        uut.instruction_memory.mem[11] = 32'b000000000011_00000_000_10001_0010011; // addi x17, x0, 3 (should execute)
        
        execute_instruction();
        check_result(32'h0000002C, uut.pc, "BNE no branch (PC should increment)");
        
        execute_instruction();
        check_result(32'h00000003, uut.reg_file.registers[17], "BNE no branch - next instruction executed");

        // ===== Test Case 5: Jump Instructions (JAL, JALR) =====
        $display("\nTest Case 5: Jump Instructions");
        // Test JAL (Jump and Link)
        uut.instruction_memory.mem[12] = 32'b000000001000_00000000_10010_1101111; // jal x18, +8
        uut.instruction_memory.mem[13] = 32'b000000000001_00000_000_10011_0010011; // addi x19, x0, 1 (should be skipped)
        uut.instruction_memory.mem[14] = 32'b000000000010_00000_000_10100_0010011; // addi x20, x0, 2 (target)
        
        execute_instruction();
        check_result(32'h00000034, uut.reg_file.registers[18], "JAL return address saved (PC+4)");
        check_result(32'h00000038, uut.pc, "JAL jump target reached");
        
        execute_instruction(); // Execute target instruction
        check_result(32'h00000002, uut.reg_file.registers[20], "JAL target instruction executed");

        // Test JALR (Jump and Link Register)
        uut.reg_file.registers[21] = 32'h00000040; // x21 = base address
        uut.instruction_memory.mem[15] = 32'b000000000100_10101_000_10110_1100111; // jalr x22, 4(x21) -> jump to 0x44
        uut.instruction_memory.mem[16] = 32'b000000000001_00000_000_10111_0010011; // addi x23, x0, 1 (should be skipped)
        uut.instruction_memory.mem[17] = 32'b000000000011_00000_000_11000_0010011; // addi x24, x0, 3 (target at 0x44)
        
        execute_instruction();

        check_result(32'h00000040, uut.reg_file.registers[22], "JALR return address saved");
        check_result(32'h00000044, uut.pc, "JALR jump to computed address");

        // ===== Test Case 6: Boundary Conditions =====
        $display("\nTest case 6: Boundary Conditions");
        // Setup for boundary tests
        @(posedge clk);
        reset = 1;

        // Test register x0 (should always be 0)
        uut.instruction_memory.mem[0] = 32'b111111111111_00000_000_00000_0010011; // addi x0, x0, -1 (try to write -1 to x0)

        // Release reset
        //@(negedge clk);
        #1;
        reset = 0;

        execute_instruction();
        check_result(32'h00000000, uut.reg_file.registers[0], "Register x0 always zero");

        // Test maximum positive immediate
        uut.instruction_memory.mem[1] = 32'b011111111111_00000_000_11001_0010011; // addi x25, x0, 2047
        execute_instruction();
        check_result(32'h000007FF, uut.reg_file.registers[25], "Maximum positive immediate (2047)");

        // Test maximum negative immediate  
        uut.instruction_memory.mem[2] = 32'b100000000000_00000_000_11010_0010011; // addi x26, x0, -2048
        execute_instruction();
        check_result(32'hFFFFF800, uut.reg_file.registers[26], "Maximum negative immediate (-2048)");

        // ===== Test Case 7: Memory Boundary Tests =====
        $display("\nTest Case 7: Memory Boundary Tests");
        
        // Test memory at boundary (word-aligned access)
        uut.instruction_memory.mem[3] = 32'b000000000000_00000_010_11011_0000011; // lw x27, 0(x0)
        uut.data_memory.mem[0] = 32'h12345678;
        execute_instruction();
        check_result(32'h12345678, uut.reg_file.registers[27], "Memory boundary load");

        // Test store at boundary
        uut.instruction_memory.mem[4] = 32'b0000011_11011_00000_010_11100_0100011; // sw x27, 124(x0) - near end
        execute_instruction();
        check_result(32'h12345678, uut.data_memory.mem[31], "Memory boundary store");

        // ===== Test Case 8: Complex Operation Sequences =====
        $display("\nTest Case 8: Complex Operation Sequences");
        
        // Test load-use sequence
        uut.data_memory.mem[10] = 32'h000000FF;
        uut.instruction_memory.mem[5] = 32'b000000101000_00000_010_11100_0000011; // lw x28, 40(x0)
        uut.instruction_memory.mem[6] = 32'b000000000001_11100_000_11101_0010011; // addi x29, x28, 1
        
        execute_instruction(); // Load
        check_result(32'h000000FF, uut.reg_file.registers[28], "Load in load-use sequence");
        
        execute_instruction(); // Use loaded value
        check_result(32'h00000100, uut.reg_file.registers[29], "Use in load-use sequence");
        
        // Final Results Summary
        $display("\n===============================================");
        $display("Test Summary");
        $display("===============================================");
        $display("Tests Passed: %0d", test_passed);
        $display("Tests Failed: %0d", test_failed);
        $display("Success Rate: %0.1f%%", (test_passed * 100.0) / (test_passed + test_failed));
        
        if (test_failed == 0) begin
            $display("ALL TESTS PASSED! CPU is working correctly.");
        end else begin
            $display("Some tests failed. Please check the implementation.");
        end
        $display("===============================================");
        $finish;
    end 



endmodule 