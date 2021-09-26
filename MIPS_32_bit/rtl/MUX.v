/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-09-26 15:28:09
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 15:28:08
	FilePath     : \MIPS_32_bit\rtl\MUX.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module MUX (
    input   [4:0]       ADDR,
    input   [31:0]      DO,

    output  reg [31:0]  DOUT
);
    integer i;
    always @(*) begin
        for (i = 0; i < 32; i = i + 1) begin
            if (i == ADDR) begin
                DOUT[i] = DO[i];
            end
                // ???
            else
                DOUT[i] = DOUT[i];
        end
    end
endmodule