`timescale 1ns/1ps

module tb_adder_pc4;
    reg [31:0] pc;
    wire [31:0] pc_next;
    adder_pc4 uut (
        .pc(pc),
        .pc_next(pc_next)
    );
    initial begin
        // Test case 1
        pc = 32'h00000000;
        #1;
        $display("PC: %h, PC+4: %h", pc, pc_next);
        
        // Test case 2
        pc = 32'h00000004;
        #1;
        $display("PC: %h, PC+4: %h", pc, pc_next);
        
        // Test case 3
        pc = 32'h0000000A;
        #1;
        $display("PC: %h, PC+4: %h", pc, pc_next);
    
        // Test case 4
        pc = 32'hFFFFFFFB;
        #1;
        $display("PC: %h, PC+4: %h", pc, pc_next);
        
        $finish;
    end
endmodule