module reg_4bit(clk,clr,A,Y);
    input clk;
    input clr;
    input A;
    output reg Y;

reg B,C,D;
always @(posedge clk or negedge clr) 
 begin
    if(!clr) 
     begin 
        B <= 0; 
        C <= 0; 
        D <= 0; 
        Y <= 0; 
     end

    else 
     begin 
        Y <= D;
        D <= C;
        C <= B;
        B <= A;
     end
 end

endmodule