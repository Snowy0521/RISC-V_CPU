module adder_pc4(
    input [31:0] pc,
    output [31:0] pc_next
);
    assign pc_next = pc + 32'd4;
endmodule