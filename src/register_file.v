module register_file(
    input clk, // clock signal
    input we,  // write enable
    input [4:0] raddr1, // read register address 1
    input [4:0] raddr2, // read register address 2
    input [4:0] waddr,  // write register address
    input [31:0] wdata, // write data
    output [31:0] rdata1, // read data 1
    output [31:0] rdata2  // read data 2
);
    reg [31:0] registers [0:31]; // 32 registers of 32 bits each 

    // read operation 
    assign rdata1 = (raddr1 == 0) ? 32'b0 : registers[raddr1];
    assign rdata2 = (raddr2 == 0) ? 32'b0 : registers[raddr2];

    // write operation 
    // always_ff for sequential logic (flip-flops) only
    // always for combinational logic and sequential logic
    always_ff @(posedge clk) begin 
        if (we && waddr != 0) begin 
            registers[waddr] <= wdata; // write data to the register
        end
    end 

    // Initialize registers to zero
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0; // set all registers to zero
        end
        registers[2] = 32'h8000; // stack pointer x2(sp) initialized to 0x8000
    end
endmodule 
