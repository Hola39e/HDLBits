/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-09-26 15:51:26
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 15:51:25
	FilePath     : \MIPS_32_bit\PC_Controller.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module PC_Controller (
    input           ZERO_FLAG,
    input           LARGE_FLAG,
    input           EQUAL_FLAG,
    input           SMALL_FLAG,
    input   [5:0]   CU_PC_WRITE_COND,
    input           CU_PC_WE,

    output          PC_LOAD
);
    assign PC_LOAD = (CU_PC_WRITE_COND[0] && ZERO_FLAG) || (CU_PC_WRITE_COND[1] && !ZERO_FLAG) || 
                    (CU_PC_WRITE_COND[2] && ZERO_FLAG && LARGE_FLAG) || (CU_PC_WRITE_COND[3] && LARGE_FLAG) ||
                    (CU_PC_WRITE_COND[4] && ZERO_FLAG && SMALL_FLAG) || (CU_PC_WRITE_COND[5] && SMALL_FLAG) ||
                    CU_PC_WE;

    
endmodule