/****************************************************************************************/
/****************************************************************************************
	File name    : top_remote_rcv
	LastEditors  : H
	LastEditTime : 2021-09-15 15:59:05
	Last Version : 1.0
	Description  : top module
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-15 15:58:18
	FilePath     : top_remote_rcv.v
	Copyright 2021 H, All Rights Reserved. 
 ****************************************************************************************/
/****************************************************************************************/

module top_remote_rcv(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    input           remote_in,
    output  [5:0]   sel,
    output  [7:0]   seg_led,
    output          led
);
    // wire define
    wire [7:0]      data;
    wire            repeat_en;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    seg_led u_seg_led(
        .sys_clk        (sys_clk),
        .sys_rst_n      (sys_rst_n),
        .seg_sel        (sel),
        .seg_led    (seg_led),
        .data       (data),
        .point      (6'b0),
        .en         (1'b1),
        .sign       (1'b0)
    );

    // HS0038B module
    remote_rcv u_remote_rcv(
        .sys_clk    (sys_clk),
        .sys_rst_n  (sys_rst_n),
        .remote_in  (remote_in),
        .repeat_en  (repeat_en),
        .data_en    (),
        .data       (data)
    );

    led_ctrl u_led_ctrl(
        .sys_clk    (sys_clk),
        .sys_rst_n  (sys_rst_n),
        .repeat_en  (repeat_en),
        .led        (led)
    );
endmodule