/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-16
>> Filename    : tb_mult.v
>> Modulename  : tb_mult
>> Description : 
>> Version  : 1.0
************************************************************/
`timescale 1ns/1ps

module tb_mult ;
    parameter    N = 8 ;
    parameter    M = 4 ;
    reg          clk, rstn;
 
   //clock
    always begin
        clk = 0 ; #5 ;
        clk = 1 ; #5 ;
    end

   //reset
    initial begin
        rstn      = 1'b0 ;
        #8 ;      rstn      = 1'b1 ;
    end


    //no pipeline
    reg                  data_rdy_low ;
    reg [N-1:0]          mult1_low ;
    reg [M-1:0]          mult2_low ;
    wire [M+N-1:0]       res_low ;
    wire                 res_rdy_low ;

    //使用任務周期激勵
    task mult_data_in ;  
        input [M+N-1:0]   mult1_task, mult2_task ;
        begin
            wait(!tb_mult.u_mult_low.res_rdy) ;  //not output state
            @(negedge clk ) ;
            data_rdy_low = 1'b1 ;
            mult1_low = mult1_task ;
            mult2_low = mult2_task ;
            @(negedge clk ) ;
            data_rdy_low = 1'b0 ;
            wait(tb_mult.u_mult_low.res_rdy) ; //test the output state
        end 
    endtask

    //driver
    initial begin
        #55 ;
        mult_data_in(25, 5 ) ;
        mult_data_in(16, 10 ) ;
        mult_data_in(10, 4 ) ;
        mult_data_in(15, 7) ;
        mult_data_in(215, 9) ;
    end

    mult  #(.N(N), .M(M))
    u_mult_low
    (
      .clk              (clk),
      .rst_n             (rstn),
      .data_rdy         (data_rdy_low),
      .mult1            (mult1_low),
      .mult2            (mult2_low),
      .res_rdy          (res_rdy_low),
      .result              (res_low));

   //simulation finish
   initial begin
      forever begin
         #100;
         if ($time >= 10000)  $finish ;
      end
   end

   initial begin
       $dumpfile("mult.vcd");
       $dumpvars(0, tb_mult);
   end

       reg          data_rdy ;
    reg [N-1:0]  mult1 ;
    reg [M-1:0]  mult2 ;
    wire                 res_rdy ;
    wire [N+M-1:0]       res ;

    //driver
    initial begin
        #55 ;
        @(negedge clk ) ;
        data_rdy  = 1'b1 ;
        mult1  = 25;      mult2      = 5;
        #10 ;      mult1  = 16;      mult2      = 10;
        #10 ;      mult1  = 10;      mult2      = 4;
        #10 ;      mult1  = 15;      mult2      = 7;
        mult2      = 7;   repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 1;   repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 15;  repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 3;   repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 11;  repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 4;   repeat(32)    #10   mult1   = mult1 + 1 ;
        mult2      = 9;   repeat(32)    #10   mult1   = mult1 + 1 ;
    end

    //對輸入數據進行移位，方便後續校驗
    reg  [N-1:0]   mult1_ref [M-1:0];
    reg  [M-1:0]   mult2_ref [M-1:0];
    always @(posedge clk) begin
        mult1_ref[0] <= mult1 ;
        mult2_ref[0] <= mult2 ;
    end

    genvar         i ;
    generate
        for(i=1; i<=M-1; i=i+1) begin
            always @(posedge clk) begin
            mult1_ref[i] <= mult1_ref[i-1];
            mult2_ref[i] <= mult2_ref[i-1];
            end
        end
    endgenerate
   
    //自校驗
    reg  error_flag ;
    always @(posedge clk) begin
        # 1 ;
        if (mult1_ref[M-1] * mult2_ref[M-1] != res && res_rdy) begin
            error_flag <= 1'b1 ;
        end
        else begin
            error_flag <= 1'b0 ;
        end
    end

    //module instantiation
    mult_man  #(.N(N), .M(M))
        u_mult
        (
        .clk              (clk),
        .rst_n             (rst_n),
        .data_rdy         (data_rdy),
        .mult1            (mult1),
        .mult2            (mult2),
        .res_rdy          (res_rdy),
        .res              (res));

endmodule // test