/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-22
>> Filename    : tb_fir_serial.v
>> Modulename  : tb_fir_serial
>> Description : 
>> Version  : 1.0
************************************************************/
`timescale 1ps/1ps
module tb_fir_serial ;
    //input
    reg          clk ;
    reg          rst_n ;
    reg          en ;
    reg  [11:0]  xin ;
    //output
    wire [28:0]  yout ;
    wire         valid ;

    parameter    SIMU_CYCLE   = 64'd1000 ;
    parameter    SIN_DATA_NUM = 200 ;

//=====================================
// GTK WAVE
    initial begin
        $dumpfile("serial_wave.vcd");
        $dumpvars(0, tb_fir_serial);
    end

//=====================================
// 8*50MHz clk generating
    localparam   TCLK_HALF     = (10_000 >>3);
    initial begin
        clk = 1'b0 ;
        forever begin
            # TCLK_HALF clk = ~clk ;
        end
    end
    
//============================
//  reset and finish
    initial begin
        rst_n = 1'b0 ;
        # 30        rst_n = 1'b1 ;
        # (TCLK_HALF * 2 * 8  * SIMU_CYCLE) ;
        $finish ;
    end
//=======================================
// read cos data into register
    reg          [11:0] stimulus [0: SIN_DATA_NUM-1] ;
    integer      i ;
    initial begin
        $readmemh("./cosx0p25m7p5m12bit.txt", stimulus) ;
        en = 0 ;
        i = 0 ;
        xin = 0 ;
        # 200 ;
        forever begin
            repeat(7)  @(negedge clk) ; //空置7個周期，第8個周期給數據
            en          = 1 ;
            xin         = stimulus[i] ;
            @(negedge clk) ;
            en          = 0 ;         //輸入數據有效信號只持續一個周期即可
            if (i == SIN_DATA_NUM-1)  i = 0 ;
            else  i = i + 1 ;
        end
    end
    fir_serial_low       u_fir_serial (
        .clk         (clk),
        .rst_n       (rst_n),
        .en          (en),
        .xin         (xin),
        .valid       (valid),
        .yout        (yout));

endmodule