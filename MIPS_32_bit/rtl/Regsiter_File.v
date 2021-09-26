/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-09-26 15:35:50
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 15:35:49
	FilePath     : \MIPS_32_bit\rtl\Regsiter_File.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module Regsiter_File(
    // System Clock
    input        clk,
    input        rst,

    // User Interface
    input   [4:0]       REGA_ADDR,
    input   [4:0]       REGB_ADDR,
    input   [4:0]       REG_SEL,

    input        		WREG_EN,
	input	[4:0]     	WREG_ADDR,

    input               WREG_DIN,

    output  [31:0]      REGA_DOUT,
    output  [31:0]      REGB_DOUT,
    output  [31:0]      REG_DOUT
);
    // wire define
    wire    [31:0]      DEC_OUT,DO;

    Decoder_5_32 u_Decoder_5_32
    (
        .WREG_EN(WREG_EN),
        .WREG_ADDR(WREG_ADDR),
        .DEC_OUT(DEC_OUT)
    );

    Resgister_32 u_Resgister_32
    (
        .clk(clk),
        .rst(rst),

        .DIN(WREG_DIN),
        .WEN(DEC_OUT),
        .DO(DO)
    );

    Register_mux u_Register_mux
    (
        .REGA_ADDR(REGA_ADDR),
        .REGB_ADDR(REGB_ADDR),
        .REG_SEL(REG_SEL),
        .DO(DO),

        .REGA_DOUT(REGA_DOUT),
        .REGB_DOUT(REGB_DOUT),
        .REG_DOUT(REG_DOUT)
    );

endmodule