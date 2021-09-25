/****************************************************************************************

	File name    : Datapath_Unit.v
	LastEditors  : H
	LastEditTime : 2021-09-24 22:26:26
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-24 22:26:24
	FilePath     : \RISCV_Project\rtl\Datapath_Unit.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module Datapath_Unit (
    input           clk,
    input           jump,beq,mem_read,mem_write,alu_src,reg_dst,mem_to_reg,reg_write,bne,
    input   [1:0]   alu_op,
    output  [3:0]   opcode
);
    // reg define
    reg     [15:0]  pc_currrent;

    // wire define
    wire    [15:0]  pc_next,pc2;
    wire    [15:0]  instr;
    wire    [2:0]   reg_write_dest;
    wire    [15:0]  reg_write_data;
    wire    [2:0]   reg_read_addr_1;
    wire    [15:0]  reg_read_data_1;
    wire    [2:0]   reg_read_addr_2;
    wire    [15:0]  reg_read_data_2;
    wire    [15:0]  ext_im,read_data2;
    wire    [2:0]   ALU_Control;
    wire    [15:0]  ALU_out;
    wire            zero_flag;
    wire    [15:0]  PC_j, PC_beq, PC_2beq,PC_2bne,PC_bne;
    wire            beq_control;
    // addon this
    wire            bne_control;

    wire    [12:0]  jump_shift;
    wire    [15:0]  mem_read_data; 

    // pc 
    initial begin
        pc_currrent <= 16'b0;
    end

    always @(posedge clk ) begin
        pc_currrent <= pc_next;
    end

    assign pc2 = pc_currrent + 16'd2;

    // instuction memory
    Instruction_Memory  im
    (
        .pc(pc_currrent),
        .instuction(instr)
    );

    // jump shift left 2
    assign jump_shift = {instr[11:0],1'b0};

    // multiplexer regdest  ¶àÂ·¸´ÓÃÆ÷¼Ä´æÆ÷
    assign reg_write_dest = (reg_dst == 1'b1) ? instr[5:3] : instr[8:6];

    // register file
    assign reg_read_addr_1 = instr[11:9];
    assign reg_read_addr_2 = instr[8:6];

    // general purpose registers
    GPRs    reg_file
    (
        .clk(clk),
        .reg_write_en(reg_write),
        .reg_write_dest(reg_write_dest),
        .reg_write_data(reg_write_data),
        .reg_read_addr_1(reg_read_addr_1),
        .reg_read_data_1(reg_read_data_1),
        .reg_read_addr_2(reg_read_addr_2),
        .reg_read_data_2(reg_read_data_2)
    );

    // immediate extend
    assign ext_im = {{10{instr[5]}} , instr[5:0]};

    // alu control unit
    alu_control ALU_Control_unit
    (
        .ALUOp(alu_op),
        .Opcode(instr[15:12]),
        .ALU_Cnt(ALU_Control)
    );

    // multiplexer alu_src
    assign read_data2 = (alu_src == 1'b1) ? ext_im : reg_read_data_2;

    // alu
    ALU alu_unit
    (
        .a(reg_read_data_1),
        .b(reg_read_data_2),
        .alu_control(ALU_Control),
        .result(ALU_out),
        .zero(zero_flag)
    );

    // PC beq add
    assign PC_beq = pc2 + {ext_im[14:0],1'b0};
    assign PC_bne = pc2 + {ext_im[14:0],1'b0};

    // beq control
    assign beq_control = beq & zero_flag;
    assign bne_control = bne & (~zero_flag);

    // pc_beq
    assign  PC_2beq = (beq_control == 1'b1) ? PC_beq : pc2;

    // pc_bne
    assign  PC_2bne = (bne_control == 1'b1) ? PC_bne : PC_2beq;

    // pc_j
    assign  PC_j = {pc2[15:13],jump_shift};

    // pc_next
    assign  pc_next = (jump == 1'b1) ? PC_j : PC_2bne;

    // data memory
    Data_Memory dm
    (
        .clk(clk),
        .mem_access_addr(ALU_out),
        .mem_write_data(reg_read_data_2),
        .mem_write_en(mem_write),
        .mem_read(mem_read),
        .mem_read_data(mem_read_data)
    );

    // write back
    assign reg_write_data = (mem_to_reg == 1'b1) ? mem_read_data : ALU_out;

    // output to control unit
    assign opcode = instr[15:12];

endmodule