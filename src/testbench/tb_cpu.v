`timescale 1ns/1ps
module tb_cpu;
    logic clk;
    logic reset;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .reset(reset)
    );  

    // Clock generation
    always #5 clk = ~clk; // 10 time units clock period

    // Test sequence
    initial begin
        $display("------ Starting CPU Testbench ------");

        // Initialize signals
        clk = 0;
        reset = 1;

        // Wait for first clock edge and setup
        @(posedge clk);
        uut.instruction_memory.mem[0] = 32'b000000000000_00000_010_00001_0000011; // lw x1, 0(x0)
        uut.instruction_memory.mem[1] = 32'b0000000_00001_00000_010_00100_0100011; // sw x1, 4(x0)
        uut.instruction_memory.mem[2] = 32'b000000000001_00000_000_00010_0010011; // addi x2, x0, 1
        uut.instruction_memory.mem[3] = 32'b0000000_00010_00001_000_00011_0110011; // add x3, x1, x2
        uut.instruction_memory.mem[4] = 32'b1111111_00010_00001_000_00100_1100011; // beq x1, x2, -4
        uut.data_memory.mem[0] = 32'hDEADBEEF; // Data at address 0, pc = 0

        // Test case 1: Load Word instruction
        $display("@(T=%0t)[TEST] Testing 'lw x1, 0(x0)'", $time);
        $display("@(T=%0t)[INFO] Instruction Memory[0] = 0x%h", $time, uut.instruction_memory.mem[0]);
        $display("@(T=%0t)[INFO] Data Memory[0] = 0x%h", $time, uut.data_memory.mem[0]);

        // Release reset
        @(negedge clk);
        reset = 0;
        $display("@(T=%0t)[INFO] Released reset", $time);
        $display("  PC = 0x%h", uut.pc);
        $display("  PC Next = 0x%h", uut.pc_next);

        @(posedge clk);
        $display("@(T=%0t)[INFO] Executing load instruction", $time);

        @(negedge clk);
        $display("@(T=%0t)[INFO] Instruction completed", $time);
        $display("  PC = 0x%h", uut.pc);
        $display("  PC Next = 0x%h", uut.pc_next);
        $display("  Instruction = 0x%h", uut.instruction_memory.mem[0]);
        $display("  Register x1 = 0x%h (expected 0xdeadbeef)", uut.reg_file.registers[1]);
        if (uut.reg_file.registers[1] !== 32'hDEADBEEF) begin
            $display("@(T=%0t) Test Failed!", $time);
        end else begin
            $display("@(T=%0t) Test Passed!", $time);
        end

        // Test case 2: Store Word instruction
        $display("@(T=%0t)[TEST] Testing 'sw x1, 4(x0)'", $time);   
        $display("@(T=%0t)[INFO] Instruction Memory[1] = 0x%h", $time, uut.instruction_memory.mem[1]);
        $display("@(T=%0t)[INFO] Register x1 = 0x%h", $time, uut.reg_file.registers[1]);

        // Execute store instruction
        @(posedge clk);
        $display("@(T=%0t)[INFO] Executing store instruction", $time);

        @(negedge clk);
        $display("@(T=%0t)[INFO] Instruction completed", $time);
        $display("  PC = 0x%h", uut.pc);
        $display("  PC Next = 0x%h", uut.pc_next);
        $display("  Instruction = 0x%h", uut.instruction_memory.mem[1]);
        $display("  Data Memory[1] = 0x%h (expected 0xdeadbeef)", uut.data_memory.mem[1]);  
        if (uut.data_memory.mem[1] !== 32'hDEADBEEF) begin
            $display("@(T=%0t) Test Failed!", $time);
        end else begin
            $display("@(T=%0t) Test Passed!", $time);
        end

        // Test case 3: Add Immediate instruction
        $display("@(T=%0t)[TEST] Testing 'addi x2, x0, 1'", $time);   
        $display("@(T=%0t)[INFO] Instruction Memory[2] = 0x%h", $time, uut.instruction_memory.mem[2]);
        
        // Execute addi instruction
        @(posedge clk);
        $display("@(T=%0t)[INFO] Executing addi instruction", $time);
    
        @(negedge clk);
        $display("@(T=%0t)[INFO] Instruction completed", $time);
        $display("  PC = 0x%h", uut.pc);
        $display("  PC Next = 0x%h", uut.pc_next);
        $display("  Instruction = 0x%h", uut.instruction_memory.mem[2]);
        $display("  Register x2 = 0x%h (expected 0x1)", uut.reg_file.registers[2]);  
        if (uut.reg_file.registers[2] !== 32'h1) begin
            $display("@(T=%0t) Test Failed!", $time);
        end else begin
            $display("@(T=%0t) Test Passed!", $time);
        end

        // Test case 4: Add instruction
        $display("@(T=%0t)[TEST] Testing 'add x3, x1, x2'", $time);   
        $display("@(T=%0t)[INFO] Instruction Memory[3] = 0x%h", $time, uut.instruction_memory.mem[3]);
        $display("@(T=%0t)[INFO] Register x1 = 0x%h", $time, uut.reg_file.registers[1]);
        $display("@(T=%0t)[INFO] Register x2 = 0x%h", $time, uut.reg_file.registers[2]);    

        // Execute add instruction
        @(posedge clk);
        $display("@(T=%0t)[INFO] Executing add instruction", $time);
        
        @(negedge clk);
        $display("@(T=%0t)[INFO] Instruction completed", $time);
        $display("  PC = 0x%h", uut.pc);
        $display("  PC Next = 0x%h", uut.pc_next);
        $display("  Instruction = 0x%h", uut.instruction_memory.mem[3]);
        $display("  Register x3 = 0x%h (expected 0xdeadbeef + 0x1 = 0xdeadbef0)", uut.reg_file.registers[3]);  
        if (uut.reg_file.registers[3] !== 32'hDEADBEEF + 32'h1) begin
            $display("@(T=%0t) Test Failed!", $time);
        end else begin
            $display("@(T=%0t) Test Passed!", $time);
        end

        // Test case 5: Branch if Equal instruction
        $display("@(T=%0t)[TEST] Testing 'beq x1, x2, -4'", $time);   
        $display("@(T=%0t)[INFO] Instruction Memory[4] = 0x%h", $time, uut.instruction_memory.mem[4]);
        $display("@(T=%0t)[INFO] Register x1 = 0x%h", $time, uut.reg_file.registers[1]);
        $display("@(T=%0t)[INFO] Register x2 = 0x%h", $time, uut.reg_file.registers[2]);

        // Execute beq instruction
        @(posedge clk);
        $display("@(T=%0t)[INFO] Executing beq instruction", $time);

        // Wait for one clock cycle to complete the instruction
        @(negedge clk);
        $display("@(T=%0t)[INFO] Instruction completed", $time);    
        $display("  PC = 0x%h", uut.pc);
        $display("  PC Next = 0x%h", uut.pc_next);
        $display("  Instruction = 0x%h", uut.instruction_memory.mem[4]);
        $display("  Branch taken? (expected no branch since x1 != x2)");  
        if (uut.pc_next !== uut.pc + 4) begin
            $display("@(T=%0t) Test Failed!", $time);
        end else begin
            $display("@(T=%0t) Test Passed!", $time);
        end

        // End of test
        $display("@(T=%0t) CPU test completed", $time);
        $display("Total execution time: %0t ps", $time);
        $display("-------------------------------");
        $finish;
    end 



endmodule 