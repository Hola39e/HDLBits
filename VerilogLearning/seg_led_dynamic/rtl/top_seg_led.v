/*******************************************************************************
@Author: H 
@Associated Filename: top_seg_led.v
@Purpose: top module of top_seg_led
@Device: All 
@Version: 1.0
@Data: 2021/09/10 18:06:44

*******************************************************************************/
module top_seg_led (
    input sys_clk,
    input sys_rst_n,

    output [5:0] sel,
    output [7:0] seg_led
);
    parameter TIME_SHOW = 25'd25000_000;
    wire [19:0] data;   // digital tube show up num
    wire [5:0] point;   // the Decimal point of num
    wire en;            // enable
    wire sign;          // num of Sign bit
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    
    seg_led u_seg_led(
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),

        .seg_sel(sel),
        .seg_led(seg_led),
        // user interface
        .data(data),
        .point(point),
        .en(en),
        .sign(sign)
    );

    // #(.MAX_NUM(TIME_SHOW)) here is to initialize as TIME_SHOW
    count u_count(
        // module block
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        // user interface
        .data(data),
        .point(point),
        .en(en),
        .sign(sign)
        );
endmodule