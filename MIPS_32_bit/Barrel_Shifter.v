/****************************************************************************************

	File name    : Barrel_Shifter
	LastEditors  : H
	LastEditTime : 2021-09-26 16:21:04
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 16:21:03
	FilePath     : \MIPS_32_bit\Barrel_Shifter.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module Barrel_Shifter (
    input   [1:0]   SHIFT_FUNC,
    input   [4:0]   SHIFT_TIMES,
    input   [31:0]  SHIFT_DIN,
    output reg [31:0]  SHIFT_DOUT
);
    always @(*) begin
        case (SHIFT_FUNC)
            2'b00:begin
                // shift right logical
                SHIFT_DOUT = SHIFT_DIN >> SHIFT_TIMES;
            end 
            2'b01:begin
                // shift left logical
                SHIFT_DOUT = SHIFT_DIN << SHIFT_TIMES;
            end
            2'b10,2'b11:
                // shift right Arithmetic
                SHIFT_DOUT = SHIFT_DIN >>> SHIFT_TIMES;
            default: ;
        endcase
    end
endmodule