/****************************************************************************************

	File name    : rs485_uart_top.v
	LastEditors  : H
	LastEditTime : 2021-09-18 17:16:47
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-18 17:12:09
	FilePath     : rs485_uart_top.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module rs485_uart_top(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    input   [3:0]       key,
    input   [3:0]       led,
    // uart interface
    input               rs485_uart_rxd,
    output              rs485_uart_txd,
    output              rs485_tx_en
);

    parameter CLK_FREQ = 50_000_000;
    parameter UART_BPS = 115200;

    // wire define
    wire                tx_en_w;
    wire                rx_done_w;
    wire [7:0]          tx_data_w;
    wire [7:0]          rx_data_w;
    wire [3:0]          key_value_w;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    // 将按键消抖后的值发送到模块，（要写入的值）
    assign tx_data_w = {4'd0,key_value_w};

    uart_recv #(
        .CLK_FREQ       (CLK_FREQ),
        .UART_BPS       (UART_BPS)
    )
    u_uart_recv(
        .sys_clk        (sys_clk),
        .sys_rst_n      (sys_rst_n),

        .uart_rxd       (rs485_uart_rxd),
        .uart_done      (rx_done_w),
        .uart_data      (rx_data_w)
    );

    uart_send #(
        .CLK_FREQ       (CLK_FREQ),
        .UART_BPS       (UART_BPS)
    )
    u_uart_send(
        .sys_clk        (sys_clk),
        .sys_rst_n      (sys_rst_n),

        .uart_din       (tx_data_w),
        .uart_en        (tx_en_w),
        .uart_txd       (rs485_uart_txd),
        .tx_flag        (rs485_tx_en)
    );

    key_debounce    u_key_debounce(
        .sys_clk        (sys_clk),
        .sys_rst_n      (sys_rst_n),

        .key            (key),
        // 按键有效 此时 使能串口发送 可以发送键值
        .key_flag       (tx_en_w),
        .key_value      (key_value_w)
    );

    led_ctrl    u_led_ctrl(
        .sys_clk        (sys_clk),
        .sys_rst_n      (sys_rst_n),

        .led_en         (rx_done_w),
        .led_data       (rx_data_w[3:0]),
        .led            (led)
    );
endmodule