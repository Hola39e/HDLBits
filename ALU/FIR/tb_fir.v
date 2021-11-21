/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-21
>> Filename    : tb_fir.v
>> Modulename  : tb_fir
>> Description : 
>> Version  : 1.0
************************************************************/
`timescale 1ps/1ps

module tb_fir;

   //input
    reg          clk ;
    reg          rst_n ;
    reg          en ;
    reg [11:0]   xin ;
    //output
    wire         valid ;
    wire [28:0]  yout ;
 
    parameter    SIMU_CYCLE   = 64'd2000 ;  //50MHz 採樣頻率
    parameter    SIN_DATA_NUM = 200 ;      //仿真周期

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_fir);
    end

//=====================================
// 50MHz clk generating
    localparam   TCLK_HALF     = 10_000;
    initial begin
        clk = 1'b0 ;
        forever begin
            # TCLK_HALF ;
            clk = ~clk ;
        end
    end
 
//============================
//  reset and finish
    initial begin
        rst_n = 1'b0 ;
        # 30   rst_n = 1'b1 ;
        # (TCLK_HALF * 2 * SIMU_CYCLE) ;
        $finish ;
    end
 
//=======================================
// read signal data into register
    reg          [11:0] stimulus [0: SIN_DATA_NUM-1] ;
    integer      i ;
    initial begin
        $readmemh("./cosx0p25m7p5m12bit.txt", stimulus) ;
        i = 0 ;
        en = 0 ;
        xin = 0 ;
        # 200 ;
        forever begin
            @(negedge clk) begin
                en          = 1'b1 ;
                xin         = stimulus[i] ;
                if (i == SIN_DATA_NUM-1) begin  //周期送入數據控制
                    i = 0 ;
                end
                else begin
                    i = i + 1 ;
                end
            end
        end
    end
    
        fir_guide u_fir_paral (
        .xin         (xin),
        .clk         (clk),
        .en          (en),
        .rst_n        (rst_n),
        .valid       (valid),
        .yout        (yout));
    
endmodule