`include "16x16_memory.v"
`timescale 1ns/1ps

module tb_sync_ram_16x16;

    reg clk, we, re;
    reg [3:0] addr;
    reg [15:0] din;
    wire [15:0] dout;

    // Instantiate the RAM
    sync_ram_16x16 uut (
        .clk(clk),
        .we(we),
        .re(re),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("---- Starting 16x16 Synchronous RAM Test ----");
        clk = 0; we = 0; re = 0; addr = 0; din = 0;

        // Write to address 0
        #10 we = 1; re = 0; addr = 4'h0; din = 16'hA5A5;
        #10 we = 0;

        // Write to address 1
        #10 we = 1; addr = 4'h1; din = 16'h1234;
        #10 we = 0;

        // Write to address 2
        #10 we = 1; addr = 4'h2; din = 16'hFFFF;
        #10 we = 0;

        // Read from address 0
        #10 re = 1; addr = 4'h0;
        #10 $display("Read from addr 0: %h (Expected: A5A5)", dout);

        // Read from address 1
        #10 addr = 4'h1;
        #10 $display("Read from addr 1: %h (Expected: 1234)", dout);

        // Read from address 2
        #10 addr = 4'h2;
        #10 $display("Read from addr 2: %h (Expected: FFFF)", dout);

        // Write to address 15
        #10 re = 0; we = 1; addr = 4'hF; din = 16'h0F0F;
        #10 we = 0;

        // Read from address 15
        #10 re = 1; addr = 4'hF;
        #10 $display("Read from addr 15: %h (Expected: 0F0F)", dout);

        // End simulation
        #20 $display("---- Test Completed ----");
        $stop;
    end

endmodule
