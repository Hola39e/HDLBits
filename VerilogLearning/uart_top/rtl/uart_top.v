/*******************************************************************************

    @Author: H 
    @Associated Filename: uart_top.v
    @Purpose: top module of uart
    @Device: All 
    @Version: 1.0
    @Date: 2021/09/12 18:41:01

*******************************************************************************/
module uart_top(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    input       uart_rxd,
    output      uart_txd
);

    parameter CLK_FREQ = 50_000_000;
    parameter UART_BPS = 115200;

    // wire define 
    wire    uart_en_w; //send enable
    wire    [7:0] uart_data_w;
    wire    clk_lm_w;   // 1MHz clock used to Signal Tap test

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    // clock divide block, used to debug
    clk_div u_pll(
        .inclk0(sys_clk),
        .c0(clk_lm_w)
    );
    uart_recv #(
        .CLK_FREQ(CLK_FREQ),
        .UART_BPS(UART_BPS))
        u_uart_recv(
            .sys_clk(sys_clk),
            .sys_rst_n(sys_rst_n),

            .uart_rxd(uart_rxd),
            .uart_done(uart_en_w),
            .uart_data(uart_data_w)
        );
    uart_send #(
        .CLK_FREQ(CLK_FREQ),
        .UART_BPS(UART_BPS))
        u_uart_send(
            .sys_clk(sys_clk),
            .sys_rst_n(sys_rst_n),

            .uart_en(uart_en_w),
            .uart_din(uart_data_w),
            .uart_txd(uart_txd)
        );

endmodule