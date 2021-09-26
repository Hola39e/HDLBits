/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-09-26 21:01:45
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 21:01:42
	FilePath     : \MIPS_32_bit\Data_Path.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module Data_Path (
    input           clk,
    input           rst,
    input   [4:0]   REG_SEL,        // Rigister file choose
    input           CU_IORD,        // Instruction or Data
    input           CU_IR_WE,       // en signal : write to memory
    input           CU_REG_DST,     // when run R type code: Rt reg is seen as Source Reg and
                                    // Rd is regarded as Destination Reg CU_REG_DST = 1
                                    // when run I type code: Rt reg is seen as Destination Reg and
                                    // CU_REG_DST = 0
    input           CU_MEM_TO_REG,
    input           CU_REG_WE,
    input           CU_ALU_SRCA,
    input   [1:0]   CU_ALI_SRCB,
    input   [3:0]   CU_ALU_OP,
    input   [1:0]   CU_PC_SRC,
    input   [5:0]   CU_PC_WE_COND,
    input           CU_PC_WE,

    output  [5:0]   OP_CODE,
    output  [4:0]   RT_ADDR,
    output  [31:0]  ALU_OUT,
    output  [31:0]  REG_DOUT,
    output          ZERO_FLAG,
    output          OVF_FLAG,
    output          LARGE_FLAG,
    output          EQUAL_FLAG,
    output          SMALL_FLAG
);
    
endmodule