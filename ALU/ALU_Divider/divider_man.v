/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-19
>> Filename    : divider_man.v
>> Modulename  : divider_man
>> Description : 
>> Version  : 1.0
************************************************************/
module divider_man
#(
    parameter N = 5,
    parameter M = 3,
    parameter N_ACT = M+N-1
)
(
    // System Clock
    input               clk,
    input               rst_n,

    // User Interface
    input               data_rdy,
    input   [N-1:0]     dividend,
    input   [M-1:0]     divisor,

    output              res_rdy,
    output  [N_ACT-M:0] merchant, // the length of merchant is N
    output  [M-1:0]     remainder
);

    wire [N_ACT-M-1:0]  dividend_t  [N_ACT-M:0];
    wire [M-1:0]        divisor_t   [N_ACT-M:0];
    wire [M-1:0]        remainder_t [N_ACT-M:0];
    wire [N_ACT-M:0]    rdy_t;
    wire [N_ACT-M:0]    merchant_t  [N_ACT-M:0];

    divider_cell #(.N(N_ACT), .M(M))
    u_divider_step0
    (
        .clk(clk),
        .rst_n(rst_n),
        .en(data_rdy),

        .dividend({{(M){1'b0}}, dividend[N-1]}),
        .divisor(divisor),
        .merchant_ci({(N_ACT-M+1){1'b0}}),
        .dividend_ci(dividend[N_ACT-M-1:0]),    // origin diviend transfer

        .dividend_kp(dividend_t[N_ACT-M]),
        .divisor_kp(divisor_t[N_ACT-M]),
        .rdy(rdy_t[N_ACT-M]),
        .merchant(merchant_t[N_ACT-M]),
        .remainder(remainder_t[N_ACT-M])
    );

    genvar i;
    generate
        for (i = 1; i <= N_ACT-M; i = i + 1) begin
            divider_cell #(.N(N_ACT), .M(M))
            u_divider_stepi
            (
                .clk(clk),
                .rst_n(rst_n),
                .en(rdy_t[N_ACT-M-i+1]),

                .dividend({remainder_t[N_ACT-M-i+1], dividend_t[N_ACT-M-i+1][N_ACT-M-i]}),
                .divisor(divisor_t[N_ACT-M-i+1]),
                .merchant_ci(merchant_t[N_ACT-M-i+1]),
                .dividend_ci(dividend_t[N_ACT-M-i+1]),
                
                .divisor_kp(divisor_t[N_ACT-M-i]),
                .dividend_kp(dividend_t[N_ACT-M-i]),
                .rdy(rdy_t[N_ACT-M-i]),
                .merchant(merchant_t[N_ACT-M-i]),
                .remainder(remainder_t[N_ACT-M-i])
            );
        end
    endgenerate

    assign res_rdy = rdy_t[0];
    assign merchant = merchant_t[0];
    assign remainder = remainder_t[0];


endmodule