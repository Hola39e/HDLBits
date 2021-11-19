/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-19
>> Filename    : divider_cell.v
>> Modulename  : divider_cell
>> Description : 
>> Version  : 1.0
************************************************************/
module divider_cell
#(
    parameter N = 5,
    parameter M = 3
)
(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input                   en,
    input   [M:0]           dividend,
    input   [M-1:0]         divisor,
    input   [N-M:0]         merchant_ci,
    input   [N-M-1:0]       dividend_ci,

    output  reg [N-M-1:0]   dividend_kp,
    output  reg [M-1:0]     divisor_kp,
    output  reg             rdy,
    output  reg [N-M:0]     merchant,
    output  reg [M-1:0]     remainder
);

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            divisor_kp  <= 'b0;
            dividend_kp <= 'b0;
            merchant    <= 'b0;
            remainder   <= 'b0;
            rdy         <= 1'b0;
        end
        else if (en) begin
            rdy         <= 1'b1;
            remainder   <= (dividend >= {1'b0, divisor}) ? (dividend - {1'b0, divisor}) : dividend;
            merchant    <= (merchant_ci << 1) + (dividend > {1'b0, divisor}) ? 1'b1 : 1'b0;
            dividend_kp <= dividend_ci;
            divisor_kp  <= divisor;
        end
        else begin
            divisor_kp  <= 'b0;
            dividend_kp <= 'b0;
            merchant    <= 'b0;
            remainder   <= 'b0;
            rdy         <= 1'b0;
        end
    end

endmodule