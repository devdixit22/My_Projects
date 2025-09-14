`timescale 1ns / 1ps
// riscv_core.v: Definitive version with all fixes including branch flush.

module riscv_core(
    input clk,
    input rst
);

    //================================================================
    // Signal Declarations
    //================================================================
    wire flush_if_id; // Signal to flush the IF/ID register on a taken branch

    // Stage 1: IF
    wire [31:0] pc_current, pc_next, pc_plus_4_if, instruction_if;
    wire pc_write, pc_src;

    // IF/ID Register Outputs
    wire [31:0] pc_plus_4_id, instruction_id;
    wire if_id_write;
    
    // Stage 2: ID
    wire [31:0] rs1_data_id, rs2_data_id, immediate_id;
    wire branch_id, mem_read_id, mem_to_reg_id, mem_write_id, alu_src_id, reg_write_id;
    wire [1:0] alu_op_id;
    wire stall;

    // ID/EX Register Outputs
    wire [31:0] pc_plus_4_ex, rs1_data_ex, rs2_data_ex, immediate_ex;
    wire [4:0] rs1_addr_ex, rs2_addr_ex, rd_addr_ex;
    wire [2:0] funct3_ex;
    wire funct7_ex;
    wire branch_ex, mem_read_ex, mem_to_reg_ex, mem_write_ex, alu_src_ex, reg_write_ex;
    wire [1:0] alu_op_ex;

    // Stage 3: EX
    wire [31:0] alu_input_a, alu_input_b, alu_result_ex, branch_target_ex;
    wire [1:0] forward_a_ex, forward_b_ex;
    wire zero_ex;
    
    // EX/MEM Register Outputs
    wire [31:0] alu_result_mem, rs2_data_mem;
    wire [4:0] rd_addr_mem;
    wire zero_mem;
    wire mem_read_mem, mem_to_reg_mem, mem_write_mem, reg_write_mem;

    // Stage 4: MEM
    wire [31:0] mem_read_data_mem;
    
    // MEM/WB Register Outputs
    wire [31:0] mem_read_data_wb, alu_result_wb;
    wire [4:0] rd_addr_wb;
    wire mem_to_reg_wb, reg_write_wb;

    // Stage 5: WB
    wire [31:0] write_back_data_wb;

    //================================================================
    // Program Counter & Flush Logic
    //================================================================
    assign pc_write = ~stall;
    assign pc_src = zero_ex & branch_ex; 
    assign pc_next = pc_src ? branch_target_ex : pc_plus_4_if;
    assign flush_if_id = pc_src;
    
    pc_register pc_reg (.clk(clk), .rst(rst), .pc_write(pc_write), .pc_in(pc_next), .pc_out(pc_current));

    //================================================================
    // IF Stage
    //================================================================
    assign pc_plus_4_if = pc_current + 4;
    instruction_memory inst_mem (.addr(pc_current), .data(instruction_if));
    
    //================================================================
    // IF/ID Pipeline Register
    //================================================================
    assign if_id_write = ~stall;
    if_id_register if_id_reg (
        .clk(clk), .rst(rst), .if_id_write(if_id_write), .flush(flush_if_id),
        .pc_plus_4_in(pc_plus_4_if), .instruction_in(instruction_if), 
        .pc_plus_4_out(pc_plus_4_id), .instruction_out(instruction_id)
    );

    //================================================================
    // ID Stage
    //================================================================
    register_file reg_file (.clk(clk), .rst(rst), .reg_write(reg_write_wb), .read_addr1(instruction_id[19:15]), .read_addr2(instruction_id[24:20]), .write_addr(rd_addr_wb), .write_data(write_back_data_wb), .read_data1(rs1_data_id), .read_data2(rs2_data_id));
    immediate_generator imm_gen (.instruction(instruction_id), .immediate(immediate_id));
    control_unit control (.opcode(instruction_id[6:0]), .branch(branch_id), .mem_read(mem_read_id), .mem_to_reg(mem_to_reg_id), .alu_op(alu_op_id), .mem_write(mem_write_id), .alu_src(alu_src_id), .reg_write(reg_write_id));
    hazard_detection_unit hazard_unit (.id_ex_mem_read(mem_read_ex), .id_ex_rd(rd_addr_ex), .if_id_rs1(instruction_id[19:15]), .if_id_rs2(instruction_id[24:20]), .stall(stall));

    //================================================================
    // ID/EX Pipeline Register
    //================================================================
    id_ex_register id_ex_reg (.clk(clk), .rst(rst), .stall(stall), .pc_plus_4_in(pc_plus_4_id), .rs1_data_in(rs1_data_id), .rs2_data_in(rs2_data_id), .immediate_in(immediate_id), .rs1_addr_in(instruction_id[19:15]), .rs2_addr_in(instruction_id[24:20]), .rd_addr_in(instruction_id[11:7]), .funct3_in(instruction_id[14:12]), .funct7_in(instruction_id[30]), .branch_in(branch_id), .mem_read_in(mem_read_id), .mem_to_reg_in(mem_to_reg_id), .alu_op_in(alu_op_id), .mem_write_in(mem_write_id), .alu_src_in(alu_src_id), .reg_write_in(reg_write_id), .pc_plus_4_out(pc_plus_4_ex), .rs1_data_out(rs1_data_ex), .rs2_data_out(rs2_data_ex), .immediate_out(immediate_ex), .rs1_addr_out(rs1_addr_ex), .rs2_addr_out(rs2_addr_ex), .rd_addr_out(rd_addr_ex), .funct3_out(funct3_ex), .funct7_out(funct7_ex), .branch_out(branch_ex), .mem_read_out(mem_read_ex), .mem_to_reg_out(mem_to_reg_ex), .alu_op_out(alu_op_ex), .mem_write_out(mem_write_ex), .alu_src_out(alu_src_ex), .reg_write_out(reg_write_ex));

    //================================================================
    // EX Stage
    //================================================================
    assign branch_target_ex = (pc_plus_4_ex - 4) + immediate_ex;
    forwarding_unit fwd_unit (.ex_mem_reg_write(reg_write_mem), .mem_wb_reg_write(reg_write_wb), .ex_mem_rd(rd_addr_mem), .mem_wb_rd(rd_addr_wb), .id_ex_rs1(rs1_addr_ex), .id_ex_rs2(rs2_addr_ex), .forward_a(forward_a_ex), .forward_b(forward_b_ex));
    assign alu_input_a = (forward_a_ex == 2'b01) ? alu_result_mem : (forward_a_ex == 2'b10) ? write_back_data_wb : rs1_data_ex;
    wire [31:0] forward_b_data = (forward_b_ex == 2'b01) ? alu_result_mem : (forward_b_ex == 2'b10) ? write_back_data_wb : rs2_data_ex;
    assign alu_input_b = alu_src_ex ? immediate_ex : forward_b_data;
    alu alu_inst (.a(alu_input_a), .b(alu_input_b), .alu_op(alu_op_ex), .funct3(funct3_ex), .funct7(funct7_ex), .result(alu_result_ex), .zero(zero_ex));

    //================================================================
    // EX/MEM Pipeline Register and subsequent stages...
    //================================================================
    ex_mem_register ex_mem_reg (.clk(clk), .rst(rst), .alu_result_in(alu_result_ex), .rs2_data_in(forward_b_data), .rd_addr_in(rd_addr_ex), .zero_in(zero_ex), .mem_read_in(mem_read_ex), .mem_to_reg_in(mem_to_reg_ex), .mem_write_in(mem_write_ex), .reg_write_in(reg_write_ex), .alu_result_out(alu_result_mem), .rs2_data_out(rs2_data_mem), .rd_addr_out(rd_addr_mem), .zero_out(zero_mem), .mem_read_out(mem_read_mem), .mem_to_reg_out(mem_to_reg_mem), .mem_write_out(mem_write_mem), .reg_write_out(reg_write_mem));
    data_memory data_mem (.clk(clk), .mem_write(mem_write_mem), .mem_read(mem_read_mem), .addr(alu_result_mem), .write_data(rs2_data_mem), .read_data(mem_read_data_mem));
    mem_wb_register mem_wb_reg (.clk(clk), .rst(rst), .mem_read_data_in(mem_read_data_mem), .alu_result_in(alu_result_mem), .rd_addr_in(rd_addr_mem), .mem_to_reg_in(mem_to_reg_mem), .reg_write_in(reg_write_mem), .mem_read_data_out(mem_read_data_wb), .alu_result_out(alu_result_wb), .rd_addr_out(rd_addr_wb), .mem_to_reg_out(mem_to_reg_wb), .reg_write_out(reg_write_wb));
    assign write_back_data_wb = mem_to_reg_wb ? mem_read_data_wb : alu_result_wb;

endmodule