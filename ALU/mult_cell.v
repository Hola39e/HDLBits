/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-17
>> Filename    : mult_cell.v
>> Modulename  : mult_cell
>> Description : 
>> Version  : 1.0
************************************************************/
module mult_cell
#(
    parameter N = 4,
    parameter M = 4
)
(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input       en,
    input   [M + N - 1:0]   mult1,
    input   [M - 1:0]       mult2,
    input   [M + N - 1:0]   mult_acci,

    output   reg [M + N - 1:0]  mult1_o,
    output   reg [M - 1:0]      mult2_shift,
    output   reg [M + N - 1:0]  mult_acco,

    output   reg               rdy  
);

always @(posedge clk or negedge rst_n ) begin
    if(!rst_n)begin
        mult1_o     <= 'b0;
        mult2_shift <= 'b0;
        mult_acco   <= 'b0;
        rdy         <= 1'b0;
    end
    else if (en) begin
        mult2_shift <= mult2 >> 1;
        mult_acco   <= mult2[0] ? (mult_acci + mult1) : mult_acci;
        mult1_o     <= mult1 << 1;
    end
    else begin
        mult1_o     <= 'b0;
        mult2_shift <= 'b0;
        mult_acco   <= 'b0;
        rdy         <= 1'b0;
    end
end

endmodule