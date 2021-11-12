`timescale 1ns/1ps
module tb_adder4bit();

reg [3:0]   A,B;
reg         Cin;
wire [3:0]  Sum;
wire        Cout;

initial begin
    $dumpfile("adder.vcd");
    $dumpvars(0, tb_adder4bit);
end

initial begin
    A <= 4'b0010;
    B <= 4'b0010;
    Cin <= 1'b0;
    #10
    A <= 4'b0011;
    B <= 4'b0110;
    Cin <= 1'b0;
    #10
    A <= 4'b0001;
    B <= 4'b0111;
    Cin <= 1'b1;
    #10
    A <= 4'b1000;
    B <= 4'b1111;
    Cin <= 1'b1;
    #10
    $stop;
end

adder4bit u_adder4bit(A,B,Cin,Sum,Cout);
endmodule