module adder_pc_imm(
    input [31:0] pc,
    input [31:0] imm,
    output [31:0] pc_next
);
    assign pc_next = pc + (imm << 1);
    
endmodule