/****************************************************************************************

	File name    : Decoder_5_32
	LastEditors  : H
	LastEditTime : 2021-09-26 14:30:02
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 14:29:51
	FilePath     : \MIPS_32_bit\rtl\Decoder_5_32.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module Decoder_5_32(
	// System Clock
	input        			WREG_EN,
	input	[4:0]     		WREG_ADDR,

	output reg	[31:0]	DEC_OUT

	// User Interface
);
	integer i;

	always @(*) begin
		if (WREG_EN) begin
			for (i = 0; i < 32; i = i + 1) begin
				if (i == WREG_ADDR) begin
					DEC_OUT[i] = 1'b1;
				end
				else
					DEC_OUT[i] = 1'b0;
			end
		end
	end
endmodule