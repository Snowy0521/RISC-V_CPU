`timescale 1ns / 1ps

module tb_memory;
    reg clk;
    reg mem_read;
    reg mem_write;
    reg [31:0] addr;
    reg [31:0] wdata;
    wire [31:0] rdata;


    // Instantiate the memory module 
    memory uut(
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata)
    );

    // Clock generation 
    always #5 clk = ~clk; // 10 ns clock period

    // Testbench stimulus
    initial begin
        $display("-------------------------------");
        $display("Starting memory test...");


        // Initialize signals
        clk = 0;
        mem_read = 0;
        mem_write = 0;
        addr = 0;
        wdata = 0;

        // Test Case 1: Write to memory
        $display("@(T=%0t)[TEST] Writing to memory...", $time);

        // Wait for the first rising edge of the clock to start the test 
        @(posedge clk);

        // Set up the write operation 
        mem_write = 1;
        addr = 32'h0000_0004; // Address to write to 
        wdata = 32'hDEAD_BEEF; // Data to write
        $display("@(T=%0t)    -> Asserting we = 0b%b, addr = 0x%h, wdata = 0x%h", $time, mem_write, addr, wdata);

        // Wait for the next clock edge to complete the write operation
        @(posedge clk);
        $display("@(T=%0t)    -> Write operation completed", $time);

        // Disable write enable
        mem_write = 0;

        // Test Case 2: Read from memory to verify write
        $display("@(T=%0t)[TEST] Reading from memory ro verify write ...", $time);

        #1; // wait for signal propagation
        mem_read = 1; // Enable read
        addr = 32'h0000_0004; // Address to read from
        $display("@(T=%0t)    -> Reading from addr = 0x%h", $time, addr);

        #1; // wait for signal propagation
        $display("@(T=%0t)    -> Read data = 0x%h", $time, rdata);

        if (rdata !== 32'hDEAD_BEEF) begin
            $display("Test Failed: Expected 0xDEAD_BEEF, got 0x%h", rdata);
        end else begin
            $display("Test Passed: Memory read matches expected value");
        end
    
        // End of test
        $display("@(T=%0t) [TEST] Memory test completed", $time);
        $display("Final Memory State:");
        $display("Address 0x%h: Data = 0x%h", addr, rdata);
        $display("Memory test finished successfully");
        $display("Exiting testbench...");
        $display("-------------------------------");
        $finish;

    end 
endmodule 