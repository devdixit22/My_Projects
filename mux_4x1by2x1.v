//pure behaviour modeling of 4x1 mux

/*module mux_4x1(in, sel, out):

input [3:0]in;
input [1:0]sel;
output out;

assign out = in[sel];

endmodule*/

//implementing 4x1 mux using 3 2x1 mux

`include"mux_2x1.v"
module mux_4x1(in, sel, out);

input [3:0]in; 
input [1:0]sel;
output out;
wire [1:0]t;

mux_2x1 M0(in[1:0], sel[0], t[0]); 
mux_2x1 M1(in[3:2], sel[0], t[1]); 
mux_2x1 M3(t, sel[1], out); 

endmodule