`include "4_bit_series_register.v"
module reg_4bit_test;
    reg clk, clr, in; wire out;
    reg_4bit SR(.clk(clk), .clr(clr), .A(in), .Y(out));
    initial
     begin
        clk = 1'b0; #2 clr = 1'b0; #5 clr =1'b1; 
     end
    always #5 clk = ~clk;
    initial
     begin #2
        repeat (4)
         begin 
            #10 in=0;
            #10 in=0;
            #10 in=1;
            #10 in=1;
         end
     end    
    initial
     begin
        $dumpfile("4_bit_series_register.vcd");
        $dumpvars(0, reg_4bit_test);
        #200 $finish;
     end

endmodule
