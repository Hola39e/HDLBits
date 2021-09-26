/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-09-26 19:03:25
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 19:03:22
	FilePath     : \MIPS_32_bit\CLA_adder\tb_cla_4bits.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
`timescale 1ns/1ps

module tb_cla_4bits ();
    
    // reg define
    reg [3:0] A;
    reg [3:0] B;

    // wire define
    reg Cin;
    wire [3:0]  S;
    wire        Cout;

    initial begin            
        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0, tb_cla_4bits);    //tb模块名称
    end

    initial begin
        A = 4'b0010;
        B = 4'b1010;
        Cin = 1'b1;
        #20
        A = 4'b0010;
        B = 4'b1010;
        Cin = 1'b0;
        #20
        A = 4'b1111;
        B = 4'b1010;
        Cin = 1'b0;
        #20
        A = 4'b1010;
        B = 4'b1010;
        Cin = 1'b1;
        #20
        A = 4'b0110;
        B = 4'b0010;
        Cin = 1'b1;
    end

    CLA_4bits_adder u_CLA_4bits_adder
    (
        .A(A),
        .B(B),
        .Cin(Cin),

        .Cout(Cout),
        .S(S)
    );
endmodule