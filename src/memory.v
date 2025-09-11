module memory(
    input clk,
    input mem_read,  // read enable
    input mem_write, // write enable
    input [31:0] addr, // address for read/write
    input [31:0] wdata, // data to write
    output[31:0] rdata // data to read
);
    reg [31:0] mem [0:2047]; // 8KB memory (2048 words of 32 bits each)

    // Read operation
    // The two least significant bits of addr indicates the byte's position within its word (byte offset)
    // The upper 11 bits [12:2] indicate which the word it belongs to (word address))
    assign rdata = (mem_read) ? mem[addr[12:2]] : 32'b0; // If read enabled, output the data at the address; else output 0

    // Write operation
    always_ff @(posedge clk) begin 
        if (mem_write) begin 
            mem[addr[12:2]] <= wdata;
        end 
    end 

    // Initialize memory to zero
    initial begin 
        // Initialize all memory to zero first
        for (integer i = 0; i < 2048; i = i + 1) begin
            mem[i] = 32'h00000000;
        end
        
        // Try to load from file, but don't fail if file doesn't exist
        $readmemh("bin/firmware.img", mem); // Load memory from a file
    end 

    // Handle unused address bits (word-aligned memory access)
    // We only use addr[12:2] for word addressing, bits [31:13,1:0] are unused
    wire _unused_ok = 1'b0 && &{1'b0,
                        addr[31:13],  // Upper address bits unused (8KB memory limit)
                        addr[1:0],    // Lower 2 bits unused (word-aligned access)
                        1'b0};
endmodule
