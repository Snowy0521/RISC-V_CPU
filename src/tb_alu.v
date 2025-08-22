// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_alu;
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_control;
    wire [31:0] result;
    wire zero;

    // Instantiate the ALU
    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    // Redeclare the ALU control signals
    localparam ALU_AND = 4'b0000; // localparam for not be configurable from outside 
    localparam ALU_OR  = 4'b0001; 
    localparam ALU_ADD = 4'b0010;
    localparam ALU_SUB = 4'b0110;
    localparam ALU_SLT = 4'b0111;
    localparam ALU_NOR = 4'b1100;

    // Stimulus block 
    initial begin 
        $display("---------- ALU Testbench ----------");

        // Test Case 1: AND operation
        $display("\n[TEST] AND operation");
        a = 32'h10101010;
        b = 32'h11001100;
        alu_control = ALU_AND;
        #1; // wait for signal propagation 
      	$display(" Input A: 32'h%h, Input B: 32'h%h, ALU Control: 4'b%h", a, b, alu_control);
      	$display (" Expected Result: 32'h%h", a & b);
      	$display (" Actual Result: 32'h%h", result);
      
        if (result !== (a & b)) begin
            $display(" Test Failed: Result mismatch");
        end else begin
            $display(" Test Passed");
        end     

        // Test Case 2: OR operation
        $display("\n[TEST] OR operation");
        a = 32'h10101010;
        b = 32'h11001100;
        alu_control = ALU_OR;
        #1; // wait for signal propagation
        $display(" Input A: 32'h%h, Input B: 32'h%h, ALU Control: 4'b%b", a, b, alu_control);
        $display (" Expected Result: 32'h%h", a | b);
        $display (" Actual Result: 32'h%h", result);   
        if (result !== (a | b)) begin
            $display(" Test Failed: Result mismatch");
        end else begin
            $display(" Test Passed");
        end

        // Test Case 3: ADD operation
        $display("\n[TEST] ADD operation");
        a = 32'h00000001;
        b = 32'h00000002;
        alu_control = ALU_ADD;
        #1; // wait for signal propagation
        $display(" Input A: 32'h%h, Input B: 32'h%h, ALU Control: 4'b%b", a, b, alu_control);
        $display (" Expected Result: 32'h%h", a + b);
        $display (" Actual Result: 32'h%h", result);
        if (result !== (a + b)) begin
            $display(" Test Failed: Result mismatch");
        end else begin
            $display(" Test Passed");      
        end 

        // Test Case 4: SUB operation
        $display("\n[TEST] SUB operation");
        a = 32'h00000003;
        b = 32'h00000001;
        alu_control = ALU_SUB;
        #1; // wait for signal propagation
        $display(" Input A: 32'h%h, Input B: 32'h%h, ALU Control: 4'b%b", a, b, alu_control);
        $display (" Expected Result: 32'h%h", a - b);
        $display (" Actual Result: 32'h%h", result);
        if (result !== (a - b)) begin
            $display(" Test Failed: Result mismatch");
        end else begin
            $display(" Test Passed");   
        end 

        // Test Case 5: SLT operation
        $display("\n[TEST] SLT operation");
        a = 32'h00000001;
        b = 32'h00000002;
        alu_control = ALU_SLT;
        #1; // wait for signal propagation
        $display(" Input A: 32'h%h, Input B: 32'h%h, ALU Control: 4'b%b", a, b, alu_control);
        $display (" Expected Result: 32'b%b", (a < b) ? 32'b1 : 32'b0);
        $display (" Actual Result: 32'b%b", result);
        if (result !== ((a < b) ? 32'b1 : 32'b0)) begin
            $display(" Test Failed: Result mismatch");
        end else begin
            $display(" Test Passed"); 
        end           

        // Test Case 6: NOR operation
        $display("\n[TEST] NOR operation");
        a = 32'h00000001;
        b = 32'h00000002;
        alu_control = ALU_NOR;
        #1; // wait for signal propagation
        $display(" Input A: 32'h%h, Input B: 32'h%h, ALU Control: 4'b%b", a, b, alu_control);
        $display (" Expected Result: 32'h%h", ~(a | b));
        $display (" Actual Result: 32'h%h", result);
        if (result !== ~(a | b)) begin
            $display(" Test Failed: Result mismatch");
        end else begin
            $display(" Test Passed");  
        end 

        // Test Case 7: Zero flag
        $display("\n[TEST] Zero flag");
        a = 32'h00000002;
        b = 32'hfffffffe;
        alu_control = ALU_ADD; // Using ADD operation to check zero flag
        #1; // wait for signal propagation
        $display(" Input A: 32'h%h, Input B: 32'h%h, ALU Control: 4'b%b", a, b, alu_control);
        $display (" Expected Result: 32'h%h", a + b);
        $display (" Actual Result: 32'h%h", result);
        $display (" Zero Flag: 1'b%b", zero);
        if (result !== (a + b) || zero !== 1'b1) begin
            $display(" Test Failed: Result or Zero flag mismatch");
        end else begin
            $display(" Test Passed");   
        end 

        $display("---------- ALU Testbench Completed ----------");
        $finish; // End the simulation        
    end 

endmodule 