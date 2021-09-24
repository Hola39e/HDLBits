/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-09-24 18:11:22
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-24 18:05:40
	FilePath     : \RISCV_Project\rtl\Instruction_Memory.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
`include "Parameter.v"

module Instruction_Memory (
	input	[15:0]	pc,
	output	[15:0]	instuction
);

	// reg define
	reg [`col - 1:0] memory [`row_i - 1:0];

	// wire define
	wire	[3:0]	rom_addr = pc[4:1];

	initial begin
		$readmemb("./test/test.prog",memory,0,14);
	end

	assign instuction = memory[rom_addr];

endmodule