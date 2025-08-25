`timescale 1ns/1ps

module tb_adder_pc_imm;
    reg [31:0] pc;
    reg [31:0] imm;
    wire [31:0] pc_next;
    adder_pc_imm uut (
        .pc(pc),
        .imm(imm),
        .pc_next(pc_next)
    );
    initial begin
        // Test case 1
        pc = 32'h00000000;
        imm = 32'h00000002; // 2 * 2 = 4
        #1;
        $display("PC: %h, IMM: %h, PC+IMM*2: %h", pc, imm, pc_next);  

        // Test case 2
        pc = 32'h00000004;
        imm = 32'h00000003; // 3 * 2 = 6
        #1;
        $display("PC: %h, IMM: %h, PC+IMM*2: %h", pc, imm, pc_next);         
    end 
endmodule 