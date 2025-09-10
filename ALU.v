module alu16 (
    input [15:0] A, B,          // Operands
    input [3:0] ALU_Sel,        // Operation select
    output reg [15:0] ALU_Out,  // Result
    output reg Zero,            // Zero flag
    output reg Carry,           // Carry flag
    output reg Negative         // Negative flag (sign bit)
);

    reg [16:0] tmp; // for operations with carry

    always @(*) begin
        Carry = 0;
        case (ALU_Sel)
            4'b0000: begin // ADD
                tmp = A + B;
                ALU_Out = tmp[15:0];
                Carry = tmp[16];
            end
            4'b0001: begin // SUB
                tmp = A - B;
                ALU_Out = tmp[15:0];
                Carry = tmp[16];
            end
            4'b0010: ALU_Out = A & B;     // AND
            4'b0011: ALU_Out = A | B;     // OR
            4'b0100: ALU_Out = A ^ B;     // XOR
            4'b0101: ALU_Out = ~A;        // NOT (on A)
            4'b0110: ALU_Out = A << 1;    // Shift Left
            4'b0111: ALU_Out = A >> 1;    // Shift Right
            4'b1000: ALU_Out = (A == B) ? 16'h0001 : 16'h0000; // Equal
            4'b1001: ALU_Out = (A > B) ? 16'h0001 : 16'h0000;  // Greater
            default: ALU_Out = 16'h0000;
        endcase

        // Flags
        Zero = (ALU_Out == 16'h0000) ? 1'b1 : 1'b0;
        Negative = ALU_Out[15]; // MSB as sign bit
    end

endmodule
