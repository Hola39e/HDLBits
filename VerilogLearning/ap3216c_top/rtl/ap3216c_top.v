/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-09-22 12:37:48
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-22 12:37:46
	FilePath     : \rtl\ap3216c_top.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module ap3216c_top(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    output              ap_scl,
    inout               ap_sda,

    output  [3:0]       led,
    output  [5:0]       sel,
    output  [7:0]       seg_led
);

    // parameter define
    parameter SLAVE_ADDR = 7'h1e;
    parameter BIT_CTRL = 1'b0;
    parameter CLK_FREQ = 26'd50_000_000;
    parameter I2C_FREQ = 18'd250_000;

    // wire define
    wire            clk;        // i2c operate clock
    wire            i2c_exec;   // trig control
    wire    [15:0]  i2c_addr;
    wire    [7:0]   i2c_data_w; // data to write
    wire            i2c_done;   // operation finish flag 
    wire            i2c_ack;    // answer flag of i2c
    wire            i2c_rh_wl;
    wire    [7:0]   i2c_data_r; // data to read
    wire    [15:0]  als_data;
    wire		[9:0]		ps_data	;
    
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    
    // i2c _ dri
    i2c_dri #(
        .SLAVE_ADDR (SLAVE_ADDR),
        .CLK_FREQ   (CLK_FREQ),
        .I2C_FREQ   (I2C_FREQ)
    )
    u_i2c_dri(
        .clk        (sys_clk),
        .rst_n      (sys_rst_n),

        .i2c_exec   (i2c_exec),
        .bit_ctrl   (BIT_CTRL),
        .i2c_rh_wl  (i2c_rh_wl),
        .i2c_addr   (i2c_addr),
        .i2c_data_w (i2c_data_w),
        .i2c_data_r (i2c_data_r),
        .i2c_done   (i2c_done),
        .i2c_ack    (i2c_ack),
        .scl        (ap_scl),
        .sda        (ap_sda),

        .dri_clk    (clk)
    );

    ap3216c u_ap3216c(
        .clk        (clk),
        .rst_n      (sys_rst_n),

        .i2c_rh_wl  (i2c_rh_wl),
        .i2c_exec   (i2c_exec),
        .i2c_addr   (i2c_addr),
        .i2c_data_w (i2c_data_w),
        .i2c_data_r (i2c_data_r),
        .i2c_done   (i2c_done),

        .als_data   (als_data),
        .ps_data    (ps_data)
    );

    seg_led u_seg_led(
        .clk        (sys_clk),
        .rst_n      (sys_rst_n),

        .seg_sel    (sel),
        .seg_led    (seg_led),

        .data       (als_data),
        .point      (6'b0),
        .en         (1'b1),
        .sign       (1'b0)
    );

    led_disp u_led_disp(
        .clk        (clk),
        .rst_n      (sys_rst_n),

        .led        (led),
        .data       (ps_data)
    );
endmodule