module alu (
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_control,
    output reg [31:0] result,
    output zero
);
    // Zero flag
    assign zero = (result == 32'b0);

    // ALU control signals
    parameter ALU_AND = 4'b0000;
    parameter ALU_OR  = 4'b0001;
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_SLT = 4'b0111;
    parameter ALU_NOR = 4'b1100;
    //parameter ALU_NAND = 4'b1101; // Uncomment if NAND is needed
    
    // ALU operations
    always_comb begin
        case (alu_control)
            ALU_AND: result = a & b; // AND
            ALU_OR:  result = a | b; // OR
            ALU_ADD: result = a + b; // ADD
            ALU_SUB: result = a - b; // SUBTRACT
            ALU_SLT: result = (a < b) ? 32'b1 : 32'b0; // SLT (Set Less Than)
            ALU_NOR: result = ~(a | b); // NOR

            default: result = 32'b0; // Default case
        endcase
    end

endmodule