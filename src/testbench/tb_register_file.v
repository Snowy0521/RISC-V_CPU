// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_register_file;
    reg clk;
    reg we; 
    reg [4:0] raddr1, raddr2, waddr;
    reg [31:0] wdata;
    wire [31:0] rdata1, rdata2;

    // Instantiate the register file
    register_file uut (
        .clk(clk),
        .we(we),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation
    always #5 clk = ~clk; // 10 ns clock period


    // Testbench stimulus
    initial begin
        // Initialize signals
        clk = 0;
        we = 0;
        raddr1 = 0;
        raddr2 = 0;
        waddr = 0;
        wdata = 0;


        // Start of test 
        $display("-------------------------------");
        $display("Starting register file test...");
    

        // Wait for global reset
        #20;

        // Test writing to register 1 (x1)
        $display("Test1: Writing 0x12345678 to register x1");
        we = 1;
        waddr = 5'b00001; // x1
        wdata = 32'h12345678; // data to write
        #10; // wait for clock edge
        we = 0; // disable write enable

        // Read from register 1 (x1)
        $display("Test2: Reading from register x1");
        raddr1 = 5'b00001; // x1
        #10;
        if (rdata1 == 32'h12345678) begin
            $display("Read successful: rdata1 = 0x%h", rdata1);
        end else begin
            $display("Read failed: expected 0x12345678, got 0x%h", rdata1);
        end 

        // Write and read from different registers 
        $display("Test3: Writing 0xdeadbeef to register x2 (stack pointer), reading from x1 and x2");
        we = 1;
        waddr = 5'b00010; // x2 (stack pointer)
        wdata = 32'hdeadbeef; // data to write
        #10; // wait for clock edge
        we = 0; // disable write enable

        // Read from register 2 (x2)
      	raddr2 = 5'b00010;
      	#10;
        if (rdata1 == 32'h12345678 && rdata2 == 32'hdeadbeef) begin
            $display("Simultaneous read successful: rdata1 = 0x%h, rdata2 = 0x%h", rdata1, rdata2);
        end else begin
            $display("Simultaneous read failed: expected rdata1 = 0x12345678, rdata2 = 0xdeadbeef, got rdata1 = 0x%h, rdata2 = 0x%h", rdata1, rdata2);
        end

        // Test writing to register 0 (should not change)
        $display("Test4: Writing to register x0 (should not change)");
        we = 1;
        waddr = 5'b00000; // x0
        wdata = 32'hffffffff; // data to write (should not change x0)
        #10; // wait for clock edge
        we = 0; // disable write enable


        // Read from register 0 (x0)
        raddr1 = 5'b00000; // x0
        #10; // wait for read
        if(rdata1 == 32'b0) begin
            $display("Read from x0 successful: rdata1 = 0x%h", rdata1);
        end else begin
            $display("Read from x0 failed: expected 0x0, got 0x%h", rdata1);
        end
      	$display("--------------------------------------------------");
    	$display("Testbench finished.");
    	$finish;
    end 
	
endmodule