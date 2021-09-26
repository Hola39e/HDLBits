/****************************************************************************************

	File name    : CLA_full_1_bit_adder
	LastEditors  : H
	LastEditTime : 2021-09-26 18:27:04
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 18:27:03
	FilePath     : \MIPS_32_bit\CLA_full_1_bit_adder.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
`ifndef _CLA_full_1_bit_adder
`define _CLA_full_1_bit_adder

module CLA_full_1_bit_adder (
    input       A,
    input       B,
    input       Cin,
    output      Gi,
    output      Pi,
    output      S
);
    assign      Gi = A & B;
    assign      Pi = A ^ B;
    assign      S  = A ^ B ^ Cin;

`endif 
endmodule