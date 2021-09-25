/****************************************************************************************

	File name    : Risc_16_bit
	LastEditors  : H
	LastEditTime : 2021-09-25 15:43:55
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-25 15:43:48
	FilePath     : \RISCV_Project\rtl\Risc_16_bit.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module Risc_16_bit (
    input       clk
);
    
    // wire define
    wire    jump,bne,beq,mem_read,mem_write,alu_src,reg_dst,mem_to_reg,reg_write;
    wire    [1:0]   alu_op;
    wire    [3:0]   opcode;

    // datapath
    Datapath_Unit DU
    (
        .clk(clk),
        .jump(jump),
        .beq(beq),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .bne(bne),
        .alu_op(alu_op),
        .opcode(opcode)
    );

    Control_Unit    conctrol
    (
        .opcode(opcode),
        .reg_dst(reg_dst),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .jump(jump),
        .bne(bne),
        .beq(beq),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );
endmodule