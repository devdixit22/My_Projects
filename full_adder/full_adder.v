module half_adder(a, b, s, c);
  input a;
  input b;
  output s;
  output c;
  
  assign s = a^b;
  assign c = a&b;
  
endmodule

module full_adder(a,b,Cin, s, Cout);
  input a;
  input b;
  input Cin;
  output s;
  output Cout;
  wire t1, t2, t3;
  
  half_adder M0(a, b, t1, t2);
  half_adder M1(t1, Cin, s, t3);
  assign Cout = t2 | t3;
    
endmodule
