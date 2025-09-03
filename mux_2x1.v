//pure behavioural modelling of 2x1 mux


/*module mux_2x1(in, sel, out);

input [1:0]in, sel;
output out;

assign out = in[sel];

endmodule*/


//structural modelling of 2x1 mux


module mux_2x1(in,sel,out);

input [1:0]in; 
input sel;
output out;
wire t1, t2, t3;

not G1(t1, sel);
and G2(t2, in[0], t1);
and G3(t3, in[1], sel);
or G4(out, t2, t3);

endmodule