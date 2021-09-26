/****************************************************************************************

	File name    : Register_mux
	LastEditors  : H
	LastEditTime : 2021-09-26 15:23:33
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 15:23:32
	FilePath     : \MIPS_32_bit\rtl\Register_mux.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module Register_mux (
    input   [4:0]       REGA_ADDR,
    input   [4:0]       REGB_ADDR,
    input   [4:0]       REG_SEL,
    input   [31:0]      DO,

    output   [31:0]  REGA_DOUT,
    output   [31:0]  REGB_DOUT,
    output   [31:0]  REG_DOUT
);
    MUX REGA_MUX
    (
        .ADDR(REGA_ADDR),
        .DO(DO),
        .DOUT(REGA_DOUT)
    );

    MUX REGB_MUX
    (
        .ADDR(REGB_ADDR),
        .DO(DO),
        .DOUT(REGB_DOUT)
    );

    MUX SEL_MUX
    (
        .ADDR(REG_SEL),
        .DO(DO),
        .DOUT(REG_DOUT)
    );
endmodule