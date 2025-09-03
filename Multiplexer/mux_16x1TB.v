`include "mux_16x1by4x1.v"
module mux_16x1_test;

reg [15:0]A; reg [3:0]S; wire F;

mux_16x1  M(.in(A),.sel(S),.out(F));

initial begin
    $dumpfile("mux_16x1by4x1.vcd");
    $dumpvars(0,mux_16x1_test);
    $monitor ($time, "A=%h, S=%h, F=%b", A,S,F);
    #5 A=16'h3fac; S=4'ha;
    #5 S=4'h1;
    #5 S=4'hc;
    #5 S=4'h5;
    #5 S=4'h3;
    #5 S=4'hb;
    #5 S=4'he;
    #5 $finish;
end

endmodule
