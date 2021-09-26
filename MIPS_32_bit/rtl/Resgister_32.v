/****************************************************************************************

	File name    : Resgister_32
	LastEditors  : H
	LastEditTime : 2021-09-26 14:46:37
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 14:46:35
	FilePath     : \MIPS_32_bit\rtl\Resgister_32.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module Resgister_32(
    // System Clock
    input        clk,
    input        rst,

    // User Interface
    input               DIN,
    input   [31:0]      WEN,
	output	reg [31:0]		DO
);
	integer i;
	always @(posedge clk or negedge rst ) begin
		if(rst)begin
			DO <= 32'b0;
		end
		else begin
			for (i = 0; i < 32; i = i + 1) begin
				if (WEN[i]) begin
					DO[i] <= DIN;
				end
				else
					DO[i] <= DO[i];
			end
		end
	end
endmodule