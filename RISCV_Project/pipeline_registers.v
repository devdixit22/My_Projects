`timescale 1ns / 1ps
// pipeline_registers.v: Definitive version with flush logic in IF/ID register.

// IF/ID Register
module if_id_register (
    input clk, rst, if_id_write,
    input flush,
    input [31:0] pc_plus_4_in, instruction_in,
    output reg [31:0] pc_plus_4_out, instruction_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_plus_4_out <= 32'b0;
            instruction_out <= 32'h00000013; // NOP on reset
        end else if (flush) begin
            pc_plus_4_out <= 32'b0;
            instruction_out <= 32'h00000013; // NOP instruction (addi x0, x0, 0)
        end else if (if_id_write) begin
            pc_plus_4_out <= pc_plus_4_in;
            instruction_out <= instruction_in;
        end
    end
endmodule

// ID/EX Register
module id_ex_register (
    input clk, rst, stall,
    input [31:0] pc_plus_4_in, rs1_data_in, rs2_data_in, immediate_in,
    input [4:0] rs1_addr_in, rs2_addr_in, rd_addr_in,
    input [2:0] funct3_in,
    input funct7_in,
    input branch_in, mem_read_in, mem_to_reg_in, mem_write_in, alu_src_in, reg_write_in,
    input [1:0] alu_op_in,
    output reg [31:0] pc_plus_4_out, rs1_data_out, rs2_data_out, immediate_out,
    output reg [4:0] rs1_addr_out, rs2_addr_out, rd_addr_out,
    output reg [2:0] funct3_out,
    output reg funct7_out,
    output reg branch_out, mem_read_out, mem_to_reg_out, mem_write_out, alu_src_out, reg_write_out,
    output reg [1:0] alu_op_out
);
    always @(posedge clk or posedge rst) begin
        if (rst || stall) begin
            pc_plus_4_out <= 32'b0; rs1_data_out <= 32'b0; rs2_data_out <= 32'b0;
            immediate_out <= 32'b0; rs1_addr_out <= 5'b0; rs2_addr_out <= 5'b0;
            rd_addr_out <= 5'b0; funct3_out <= 3'b0; funct7_out <= 1'b0;
            branch_out <= 1'b0; mem_read_out <= 1'b0;
            mem_to_reg_out <= 1'b0; alu_op_out <= 2'b0; mem_write_out <= 1'b0;
            alu_src_out <= 1'b0; reg_write_out <= 1'b0;
        end else begin
            pc_plus_4_out <= pc_plus_4_in; rs1_data_out <= rs1_data_in; rs2_data_out <= rs2_data_in;
            immediate_out <= immediate_in; rs1_addr_out <= rs1_addr_in; rs2_addr_out <= rs2_addr_in;
            rd_addr_out <= rd_addr_in; funct3_out <= funct3_in; funct7_out <= funct7_in;
            branch_out <= branch_in; mem_read_out <= mem_read_in;
            mem_to_reg_out <= mem_to_reg_in; alu_op_out <= alu_op_in; mem_write_out <= mem_write_in;
            alu_src_out <= alu_src_in; reg_write_out <= reg_write_in;
        end
    end
endmodule

// EX/MEM Register
module ex_mem_register (
    input clk, rst,
    input [31:0] alu_result_in, rs2_data_in,
    input [4:0] rd_addr_in,
    input zero_in,
    input mem_read_in, mem_to_reg_in, mem_write_in, reg_write_in,
    output reg [31:0] alu_result_out, rs2_data_out,
    output reg [4:0] rd_addr_out,
    output reg zero_out,
    output reg mem_read_out, mem_to_reg_out, mem_write_out, reg_write_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alu_result_out <= 32'b0; rs2_data_out <= 32'b0; rd_addr_out <= 5'b0;
            zero_out <= 1'b0; mem_read_out <= 1'b0; mem_to_reg_out <= 1'b0;
            mem_write_out <= 1'b0; reg_write_out <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in; rs2_data_out <= rs2_data_in; rd_addr_out <= rd_addr_in;
            zero_out <= zero_in; mem_read_out <= mem_read_in; mem_to_reg_out <= mem_to_reg_in;
            mem_write_out <= mem_write_in; reg_write_out <= reg_write_in;
        end
    end
endmodule

// MEM/WB Register
module mem_wb_register (
    input clk, rst,
    input [31:0] mem_read_data_in, alu_result_in,
    input [4:0] rd_addr_in,
    input mem_to_reg_in, reg_write_in,
    output reg [31:0] mem_read_data_out, alu_result_out,
    output reg [4:0] rd_addr_out,
    output reg mem_to_reg_out, reg_write_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_read_data_out <= 32'b0; alu_result_out <= 32'b0; rd_addr_out <= 5'b0;
            mem_to_reg_out <= 1'b0; reg_write_out <= 1'b0;
        end else begin
            mem_read_data_out <= mem_read_data_in; alu_result_out <= alu_result_in;
            rd_addr_out <= rd_addr_in; mem_to_reg_out <= mem_to_reg_in;
            reg_write_out <= reg_write_in;
        end
    end
endmodule