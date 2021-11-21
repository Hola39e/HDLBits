/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-18
>> Filename    : mult_man.v
>> Modulename  : mult_man
>> Description : 
>> Version  : 1.0
************************************************************/
module mult_man
#(
    parameter N = 4,
    parameter M = 4
)
(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input       data_rdy,
    input   [N-1:0] mult1,
    input   [M-1:0] mult2,

    output      res_rdy,
    output  [N+M-1:0]   res
);

    wire [N+M-1:0]  mult1_t  [M-1:0];
    wire [N+M-1:0]  mult1_acc_t  [M-1:0];
    wire [M-1:0]    mult2_t  [M-1:0];
    wire [M-1:0]    rdy_t;

    mult_cell #(.N(N), .M(M))
    u_mult_step0 
    (
        .clk(clk),
        .rst_n(rst_n),
        .en(data_rdy),
        .mult1({{M{1'b0}},mult1}),
        .mult2(mult2),
        .mult_acci({(N+M){1'b0}}),

        .mult_acco(mult1_acc_t[0]),
        .mult2_shift(mult2_t[0]),
        .mult1_o(mult1_t[0]),
        .rdy(rdy_t[0])
    );

    genvar i;
    generate
        for (i = 1; i < M; i = i + 1) begin
            mult_cell #(.N(N), .M(M))
            u_mult_step
            (
                .clk(clk),
                .rst_n(rst_n),
                .en(rdy_t[i-1]),
                .mult1(mult1_t[i-1]),
                .mult2(mult2_t[i-1]),
                .mult_acci(mult1_acc_t[i-1]),

                .mult_acco(mult1_acc_t[i]),
                .mult2_shift(mult2_t[i]),
                .mult1_o(mult1_t[i]),
                .rdy(rdy_t[i])
            );
        end
    endgenerate

    assign res_rdy = rdy_t[M-1];
    assign res = mult1_acc_t[M-1];
endmodule