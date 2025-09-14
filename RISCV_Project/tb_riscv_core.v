`timescale 1ns / 1ps
// tb_riscv_core.v: Definitive testbench with correct reset timing.

module tb_riscv_core;

    reg clk;
    reg rst;

    riscv_core uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Reset and simulation control
    initial begin
        rst = 1;
        #14;      // De-assert reset BETWEEN clock edges
        rst = 0;
        #200;    // Run simulation for 200ns
        $finish;
    end

endmodule