`include "Universal_shift_register.v"
`timescale 1ns/1ps

module tb_universal_shift_reg16;

    reg clk, rst;
    reg [1:0] mode;
    reg [15:0] d;
    reg sin_left, sin_right;
    wire [15:0] q;

    // Instantiate the Universal Shift Register
    universal_shift_reg16 uut (
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .d(d),
        .sin_left(sin_left),
        .sin_right(sin_right),
        .q(q)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("---- Starting 16-bit Universal Shift Register Test ----");
        clk = 0; rst = 0; mode = 2'b00; d = 0; sin_left = 0; sin_right = 0;

        // Reset
        #10 rst = 1;
        #10 rst = 0;
        $display("After Reset, q = %h (Expected: 0000)", q);

        // Parallel Load
        #10 mode = 2'b11; d = 16'hA5A5;
        #10 mode = 2'b00; // Hold
        $display("Parallel Load: q = %h (Expected: A5A5)", q);

        // Shift Right with sin_left = 1
        #10 mode = 2'b01; sin_left = 1;
        #10 mode = 2'b01;
        $display("After 2 Right Shifts, q = %h", q);

        // Shift Left with sin_right = 1
        #10 mode = 2'b10; sin_right = 1;
        #10 mode = 2'b10;
        $display("After 2 Left Shifts, q = %h", q);

        // Hold state
        #10 mode = 2'b00;
        $display("Hold: q = %h", q);

        // End simulation
        #20 $display("---- Test Completed ----");
        $stop;
    end

endmodule
