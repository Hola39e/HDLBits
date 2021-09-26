/****************************************************************************************

	File name    : CLA_4bits_adder
	LastEditors  : H
	LastEditTime : 2021-09-26 18:29:49
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 18:29:30
	FilePath     : \MIPS_32_bit\CLA_4bits_adder.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
`ifndef _CLA_4bits_adder
`define _CLA_4bits_adder

module CLA_4bits_adder (
    input   [3:0]   A,
    input   [3:0]   B,
    input           Cin,

    output          Cout,
    output  [3:0]   S
);
    wire [3:0]  P,G,C;

    CLA_full_1_bit_adder add0(.A(A[0]), .B(B[0]), .Cin(Cin), .Gi(G[0]), .Pi(P[0]), .S(S[0]));
    CLA_full_1_bit_adder add1(.A(A[1]), .B(B[1]), .Cin(C[0]), .Gi(G[1]), .Pi(P[1]), .S(S[1]));
    CLA_full_1_bit_adder add2(.A(A[2]), .B(B[2]), .Cin(C[1]), .Gi(G[2]), .Pi(P[2]), .S(S[2]));
    CLA_full_1_bit_adder add3(.A(A[3]), .B(B[3]), .Cin(C[2]), .Gi(G[3]), .Pi(P[3]), .S(S[3]));

    assign C[0] = G[0] | P[0] & Cin;
    assign C[1] = G[1] | P[1] & C[0];
    assign C[2] = G[2] | P[2] & C[1];
    assign C[3] = G[3] | P[3] & C[2];

    assign Cout = C[3];

`endif 
endmodule