`timescale 1ns / 1ps
// cpu_components.v: Definitive version with corrected ALU logic.

module pc_register (
    input clk, rst, pc_write,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) pc_out <= 32'b0;
        else if (pc_write) pc_out <= pc_in;
    end
endmodule

module instruction_memory (
    input [31:0] addr,
    output reg [31:0] data
);
    reg [31:0] mem [0:1023];
    initial begin $readmemh("program.hex", mem); end
    always @(*) data = mem[addr[31:2]];
endmodule

module data_memory (
    input clk, mem_write, mem_read,
    input [31:0] addr, write_data,
    output reg [31:0] read_data
);
    reg [31:0] mem [0:1023];
    always @(posedge clk) if (mem_write) mem[addr[31:2]] <= write_data;
    always @(*) read_data = (mem_read) ? mem[addr[31:2]] : 32'b0;
endmodule

module register_file (
    input clk, rst, reg_write,
    input [4:0] read_addr1, read_addr2, write_addr,
    input [31:0] write_data,
    output [31:0] read_data1, read_data2
);
    reg [31:0] registers [0:31];
    integer i;
    initial begin for (i=0; i<32; i=i+1) registers[i] = 32'b0; end
    assign read_data1 = (read_addr1 == 5'b0) ? 32'b0 : registers[read_addr1];
    assign read_data2 = (read_addr2 == 5'b0) ? 32'b0 : registers[read_addr2];
    always @(posedge clk) if (reg_write && (write_addr != 5'b0)) registers[write_addr] <= write_data;
endmodule

module alu (
    input [31:0] a, b,
    input [1:0] alu_op,
    input [2:0] funct3, input funct7,
    output reg [31:0] result,
    output reg zero
);
    always @(*) begin
        case (alu_op)
            2'b00: result = a + b; // For LW/SW address calculation
            2'b01: result = a - b; // For Branches
            2'b10: // For R-type instructions ONLY
                case (funct3)
                    3'b000: result = funct7 ? (a - b) : (a + b); // ADD vs SUB
                    3'b111: result = a & b; // AND
                    3'b110: result = a | b; // OR
                    default: result = 32'b0;
                endcase
            2'b11: result = a + b; // For I-type (ADDI)
            default: result = 32'b0;
        endcase
        zero = (result == 32'b0);
    end
endmodule

module immediate_generator (
    input [31:0] instruction,
    output reg [31:0] immediate
);
    always @(*) begin
        case(instruction[6:0])
            7'b0010011, 7'b0000011: immediate = {{20{instruction[31]}}, instruction[31:20]}; // I-type
            7'b0100011: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type
            7'b1100011: immediate = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-type
            default: immediate = 32'b0;
        endcase
    end
endmodule