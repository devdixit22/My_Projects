`timescale 1ns / 1ps
// control_hazard.v: Definitive version with fully corrected control words.

module control_unit (
    input [6:0] opcode,
    output reg branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write,
    output reg [1:0] alu_op
);
    always @(*) begin
        // Format: {branch, mem_read, mem_to_reg, alu_op[1:0], mem_write, alu_src, reg_write}
        case (opcode)
            7'b0110011: {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b00010001; // R-type
            7'b0010011: {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b00011011; // I-type (addi)
            7'b0000011: {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b01100111; // lw
            7'b0100011: {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b00000110; // sw
            7'b1100011: {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b10001000; // beq
            default:    {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = 8'b00000000; // NOP
        endcase
    end
endmodule

module forwarding_unit (
    input ex_mem_reg_write, mem_wb_reg_write,
    input [4:0] ex_mem_rd, mem_wb_rd, id_ex_rs1, id_ex_rs2,
    output reg [1:0] forward_a, forward_b
);
    always @(*) begin
        if (ex_mem_reg_write && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs1)) forward_a = 2'b01;
        else if (mem_wb_reg_write && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs1)) forward_a = 2'b10;
        else forward_a = 2'b00;

        if (ex_mem_reg_write && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs2)) forward_b = 2'b01;
        else if (mem_wb_reg_write && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs2)) forward_b = 2'b10;
        else forward_b = 2'b00;
    end
endmodule

module hazard_detection_unit (
    input id_ex_mem_read,
    input [4:0] id_ex_rd, if_id_rs1, if_id_rs2,
    output reg stall
);
    always @(*) begin
        if (id_ex_mem_read && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2)))
            stall = 1'b1;
        else
            stall = 1'b0;
    end
endmodule