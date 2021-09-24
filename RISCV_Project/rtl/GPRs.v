/****************************************************************************************

	File name    : GPRs.v
	LastEditors  : H
	LastEditTime : 2021-09-24 18:18:31
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-24 18:17:35
	FilePath     : \RISCV_Project\rtl\GPRs.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
`timescale 1ns/1ps

module GPRs (
	input	clk,
	// write port
	input	reg_write_en,
	input	[2:0]	reg_write_dest,
	input	[15:0]	reg_write_data,

	// read port 1
	input	[2:0]	reg_read_addr_1,
	output	[15:0]	reg_read_data_1,

	// read port 2
	input	[2:0]	reg_read_addr_2,
	output	[15:0]	reg_read_data_2
);
	
	// reg define
	reg [15:0] reg_array [7:0];

	// integer define
	integer i;

	// write port
	initial begin
		for (i = 0; i<8; i = i + 1) begin
			reg_array[i] <= 16'b0;
		end
	end

	always @(posedge clk ) begin
		if (reg_write_en) begin
			reg_array[reg_write_dest] <= reg_write_data; 
		end
	end

	assign reg_read_data_1 = reg_array[reg_read_addr_1];
	assign reg_read_data_2 = reg_array[reg_read_addr_2];
endmodule
