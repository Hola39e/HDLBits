/****************************************************************************************

	File name    : ALU_control
	LastEditors  : H
	LastEditTime : 2021-09-26 17:29:05
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 17:29:04
	FilePath     : \MIPS_32_bit\ALU_control.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module ALU_control (
    input   [3:0]   ALU_OP,
    input   [5:0]   ALU_FUNC,

    output reg [3:0]   ALU_CTRL_OUT
);
    wire	[7:0]	ALU_CONTROLIN;
	reg		[3:0]	FUNC_CODE;
	//assign	ALU_CONTROLIN = {ALU_OP,ALU_FUNC};

	always @(*) begin
		case (ALU_OP)
			4'b0010: ALU_CTRL_OUT = FUNC_CODE;	// r type
			default: ALU_CTRL_OUT = 4'b0;
		endcase
	end

	always @(*) begin
		case (ALU_FUNC)
			6'b100000: FUNC_CODE = 4'b1011;//add
			6'b100010: FUNC_CODE = 4'b1100;//sub
			6'b100100: FUNC_CODE = 4'b0010;//and
			6'b100101: FUNC_CODE = 4'b0011;//or
			6'b100110: FUNC_CODE = 4'b0110;//xor
			6'b100111: FUNC_CODE = 4'b0111;//nor
			6'b000000: FUNC_CODE = 4'b0100;//sll
			6'b000010: FUNC_CODE = 4'b0101;//srl
			6'b000011: FUNC_CODE = 4'b1000;//sra
			default: ;
		endcase
	end
endmodule