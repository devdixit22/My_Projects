/* module ALU(a,b,c,sign,zero,carry,parity,overflow);
input [15:0]a,b;
output [15:0]c;
output sign,carry,parity,zero,overflow;

assign {carry,c} = a+b;  //16-bit addition 

assign sign = c[15];
assign zero = ~|c;
assign parity = ~^c;
assign overflow = (a[15]&b[15]&~c[15]) | (~a[15]&~b[15]&c[15]);


endmodule
*/


//16-bit adder using four 4-bit adders
`include "16bit_by_4bit.v"
module ALU(a,b,s,sign,zero,carry,parity,overflow);

input [15:0]a,b;    
output [15:0]s;   
output sign, zero, carry, parity, overflow;

wire c[2:0];

assign sign = s[15];
assign zero = ~|s;
assign parity = ~^s;
assign overflow = (a[15]&b[15]&~s[15]) | (~a[15]&~b[15]&s[15]);

adder4 a0(a[3:0], b[3:0], s[3:0], c[0], 1'b0);
adder4 a1(a[7:4], b[7:4], s[7:4], c[1], c[0]);
adder4 a2(a[11:8], b[11:8], s[11:8], c[2], c[1]);
adder4 a3(a[15:12], b[15:12], s[15:12], carry, c[2]);

endmodule
