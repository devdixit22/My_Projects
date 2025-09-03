//behavioural description of 4-bit ripple caary adder
/*
module adder4(a,b,s,cout,cin);

input [3:0]a,b; input cin;
output [3:0]s; output cout;

assign {cout,s} = a + b + cin;

endmodule
*/

// structural description of a 4-bit ripple carry adder using 4 full adders
/*
`include "full_adder.v"
module adder4(a,b,s,cout,cin);

input [3:0]a,b; input cin;
output [3:0]s; output cout;
wire [2:0]c;

full_adder F0(a[0], b[0], cin, s[0], c[0]);
full_adder F1(a[1], b[1], c[0], s[1], c[1]);
full_adder F2(a[2], b[2], c[1], s[2], c[2]);
full_adder F3(a[3], b[3], c[2], s[3], cout);

endmodule
*/
//4-bit adder using carry look ahead adder

module adder4(a,b,s,cout,cin);

input [3:0]a,b; input cin;
output [3:0]s; output cout;
wire p0, p1, p2, p3, g0, g1, g2, g3;
wire c1,c2,c3;

assign p0 = a[0]^b[0],
       p1 = a[1]^b[1],
       p2 = a[2]^b[2],
       p3 = a[3]^b[3];

assign g0 = a[0]&b[0],
       g1 = a[1]&b[1],
       g2 = a[2]&b[2],
       g3 = a[3]&b[3];

assign c1 = g0|(p0&cin),
       c2 = g1|(p1&g0)|(p1&p0&cin),
       c3 = g2|(p2&g1)|(p2&p1&g0)|(p2&p1&p0&cin),
       cout = g3|(p3&g2)|(p3&p2&g1)|(p3&p2&p1&g0)|(p3&p2&p1&p0&cin);

assign s[0] = p0^cin,
       s[1] = p1^c1,
       s[2] = p2^c2,
       s[3] = p3^c3;

endmodule
