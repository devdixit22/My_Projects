module sync_ram_16x16 (
    input clk,               // Clock
    input we,                // Write Enable
    input re,                // Read Enable
    input [3:0] addr,        // 4-bit Address (16 locations)
    input [15:0] din,        // Data Input (16-bit word)
    output reg [15:0] dout   // Data Output (16-bit word)
);

    // Memory array: 16 locations, each 16 bits wide
    reg [15:0] mem [15:0];

    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= din;    // Write data to memory
        end
        if (re) begin
            dout <= mem[addr];   // Read data from memory
        end
    end

endmodule
