`include "full_adder.v"
`timescale 10ns/1ns
module F_A_test();

reg A; reg B; reg Ci; wire S; wire Co;

full_adder M(.a(A), .b(B), .Cin(Ci), .s(S), .Cout(Co));

initial begin
    $dumpfile("full_adder.vcd");
    $dumpvars(0, F_A_test);
    $monitor($time, "A=%b, B=%b, Ci=%b, S=%b, Co=%b", A,B,Ci,S,Co);
    #5 A = 1'b0; B=1'b0; Ci=1'b0;
    #5 A = 1'b0; B=1'b0; Ci=1'b1;
    #5 A = 1'b0; B=1'b1; Ci=1'b0;
    #5 A = 1'b0; B=1'b1; Ci=1'b1;
    #5 A = 1'b1; B=1'b0; Ci=1'b0;
    #5 A = 1'b1; B=1'b0; Ci=1'b1;
    #5 A = 1'b1; B=1'b1; Ci=1'b0;
    #5 A = 1'b1; B=1'b1; Ci=1'b1;
    #5 $finish;
end

endmodule