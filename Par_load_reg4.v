/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-10-26 12:22:01
	Last Version : 1.0
	Description  : this is the simplest parallel load reg 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-26 12:21:58
	FilePath     : \Verilog_HDL\Par_load_reg4
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module Par_load_reg4 #(parameter word_size = 4)(
	// System Clock


	// User Interface
	output	reg	[word_size - 1 : 0] 	Data_out,
	input		[word_size - 1 : 0] 	Data_in,
	input								load,clock,reset
);

	always @(posedge clock or posedge reset) begin
		if(reset)begin
			Data_out <= {word_size{1'b0}};
		end
		else if (load) begin
			Data_out <= Data_in;
		end
	end
endmodule
