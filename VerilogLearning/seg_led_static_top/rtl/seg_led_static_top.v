/*******************************************************************************
@Author: H 
@Associated Filename: seg_led_static_top.v
@Purpose: top module of seg_led_static
@Device: All 
@Version: 1.0
@Data: 2021/09/10 18:06:44

*******************************************************************************/
module seg_led_static_top (
    input sys_clk,
    input sys_rst_n,

    output [5:0] sel,
    output [7:0] seg_led
);
    parameter TIME_SHOW = 25'd25000_000;
    wire add_flag;
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    
    seg_led_static u_seg_led_static(
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),

        .sel(sel),
        .seg_led(seg_led),
        .add_flag(add_flag)
    );

    // #(.MAX_NUM(TIME_SHOW)) here is to initialize as TIME_SHOW
    time_count #(.MAX_NUM(TIME_SHOW))
        u_timecount(
            .sys_clk(sys_clk),
            .sys_rst_n(sys_rst_n),

            .add_flag(add_flag)
        );
endmodule