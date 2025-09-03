`include "16_bit_adder.v"
module ALU_test;

reg [15:0]a,b;
wire [15:0]s;  
wire sn, ZR, carry, P, V;

ALU M (a,b,s,sn,ZR,carry,P,V);

initial begin
    $dumpfile("16_bit_adder.vcd"); 
    $dumpvars(0, ALU_test);
    $monitor ($time, "a=%h, b=%h, s=%h, sn=%b, ZR=%b, CY=%b, P=%b, V=%b", a,b,s,sn,ZR,carry,P,V);
    #5 a=16'h8fff; b=16'h8000;
    #5 a=16'hfffe; b=16'h0002;
    #5 a=16'haaaa; b=16'h5555;
    #5 $finish;
end

endmodule