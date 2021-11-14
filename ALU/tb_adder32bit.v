/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-14
>> Filename    : tb_adder32bit.v
>> Modulename  : tb_adder32bit
>> Description : 
>> Version  : 1.0
************************************************************/

`timescale 1ps/1ps
module tb_adder32bit();

reg [31:0]   A,B;
reg         Cin;
wire [31:0]  Sum;
wire        Cout;

initial begin
    $dumpfile("adder.vcd");
    $dumpvars(0, tb_adder32bit);
end

initial begin
    A <= 32'h0010;
    B <= 32'h0010;
    Cin <= 1'b0;
    #10
    A <= 32'h0011;
    B <= 32'h0110;
    Cin <= 1'b0;
    #10
    A <= 32'h0001;
    B <= 32'h0111;
    Cin <= 1'b1;
    #10
    A <= 32'h1000;
    B <= 32'h1111;
    Cin <= 1'b1;
    #10
    A <= 32'hF01E_F00F;
    B <= 32'h1111_1111;
    Cin <= 1'b1;
    #10
    $stop;
end

adder32bit u_adder4bit(A,B,Cin,Sum,Cout);
endmodule