module universal_shift_reg16 (
    input clk,                  // Clock
    input rst,                  // Reset (active high)
    input [1:0] mode,           // Mode select
                                // 00 = Hold
                                // 01 = Shift Right
                                // 10 = Shift Left
                                // 11 = Parallel Load
    input [15:0] d,             // Parallel Data Input
    input sin_left,             // Serial Input for Left Shift
    input sin_right,            // Serial Input for Right Shift
    output reg [15:0] q         // Register Output
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 16'b0; // Reset to 0
        else begin
            case (mode)
                2'b00: q <= q;                         // Hold
                2'b01: q <= {sin_left, q[15:1]};       // Shift Right
                2'b10: q <= {q[14:0], sin_right};      // Shift Left
                2'b11: q <= d;                         // Parallel Load
                default: q <= q;
            endcase
        end
    end

endmodule
