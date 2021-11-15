/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-15
>> Filename    : tb_prefix_adder16.v
>> Modulename  : tb_prefix_adder16
>> Description : 
>> Version  : 1.0
************************************************************/
`timescale 1ps/1ps
module tb_prefix_adder16();


    reg [15:0] A,B;
    reg Cin;
    wire [15:0] Sum;
    wire Cout;

    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0,tb_prefix_adder16);
    end

    initial begin
        A <= 16'h0010;
        B <= 16'h0010;
        Cin <= 1'b0;
        #10
        A <= 16'h0011;
        B <= 16'h0110;
        Cin <= 1'b0;
        #10
        A <= 16'h0001;
        B <= 16'h0111;
        Cin <= 1'b1;
        #10
        A <= 16'h1000;
        B <= 16'h1111;
        Cin <= 1'b1;
        #10
        A <= 16'hF00F;
        B <= 16'h1111;
        Cin <= 1'b1;
        #10
        $stop;
    end

    prefix_adder16 u_prefix_adder16(A, B, Cin, Sum, Cout);
endmodule