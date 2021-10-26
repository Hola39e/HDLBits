/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-10-26 16:15:08
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-26 16:15:06
	FilePath     : \Verilog_HDL\tb_Par_load_reg4.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
`timescale 1ps/1ps
module tb_Par_load_reg4(
    // System Clock    
);

    reg clk,reset,load;
    reg     [3:0]   Data_in;
    reg     [6:0]   cnt;   
    wire    [3:0]   Data_out;

    initial begin
        clk <= 1;
        reset <= 1;
        cnt <= 6'b0;
        #20
        clk <= 0;
        reset <= 0;

        forever begin
            #10 clk <= ~clk;
        end
    end

    initial
    begin            
        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0, tb_Par_load_reg4);    //tb模块名称
    end


    always @(negedge clk) begin
        load <= 1'b1;
        Data_in <= 4'd10;
        #11
        load <= 1'b0;
        Data_in <= 4'd11;
        cnt <= cnt + 1;
        if (cnt >= 20) begin
            $stop;
        end
    end

    Par_load_reg4 u_Par_load_reg4(
        .Data_out   (Data_out),
        .Data_in    (Data_in),
        .clock        (clk),
        .reset      (reset),
        .load       (load)
    );
endmodule
