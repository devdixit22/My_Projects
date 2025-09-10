`timescale 1ns/1ps

module tb_alu16;

    reg [15:0] A, B;
    reg [3:0] ALU_Sel;
    wire [15:0] ALU_Out;
    wire Zero, Carry, Negative;

    // Instantiate ALU
    alu16 uut (
        .A(A), .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Out),
        .Zero(Zero),
        .Carry(Carry),
        .Negative(Negative)
    );

    initial begin
        $display("---- Starting 16-bit ALU Test ----");

        A = 16'h000A; B = 16'h0005;

        // ADD
        ALU_Sel = 4'b0000; #10;
        $display("ADD: %h + %h = %h, Carry=%b", A, B, ALU_Out, Carry);

        // SUB
        ALU_Sel = 4'b0001; #10;
        $display("SUB: %h - %h = %h", A, B, ALU_Out);

        // AND
        ALU_Sel = 4'b0010; #10;
        $display("AND: %h & %h = %h", A, B, ALU_Out);

        // OR
        ALU_Sel = 4'b0011; #10;
        $display("OR: %h | %h = %h", A, B, ALU_Out);

        // XOR
        ALU_Sel = 4'b0100; #10;
        $display("XOR: %h ^ %h = %h", A, B, ALU_Out);

        // NOT
        ALU_Sel = 4'b0101; #10;
        $display("NOT: ~%h = %h", A, ALU_Out);

        // Shift Left
        ALU_Sel = 4'b0110; #10;
        $display("Shift Left: %h << 1 = %h", A, ALU_Out);

        // Shift Right
        ALU_Sel = 4'b0111; #10;
        $display("Shift Right: %h >> 1 = %h", A, ALU_Out);

        // Compare Equal
        ALU_Sel = 4'b1000; #10;
        $display("Equal: %h == %h -> %h", A, B, ALU_Out);

        // Compare Greater
        ALU_Sel = 4'b1001; #10;
        $display("Greater: %h > %h -> %h", A, B, ALU_Out);

        $display("---- Test Completed ----");
        $stop;
    end

endmodule
