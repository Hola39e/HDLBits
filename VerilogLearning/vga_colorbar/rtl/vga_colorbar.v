/*******************************************************************************

    @Author: H 
    @Associated Filename: vga_colorbar.v
    @Purpose: top level
    @Device: All 
    @Version: 1.0
    @Date: 2021/09/12 21:30:45

*******************************************************************************/

module vga_colorbar(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    output          vga_hs,
    output          vga_vs,
    output  [15:0]  vga_rgb
);

    // wire define
    wire            vga_clk_w;      // pll divide 25Mhz
    wire            locked_w;
    wire            rst_n_w;
    wire    [15:0]  pixel_data_w;
    wire    [9:0]   pixel_xpos_w;
    wire    [9:0]   pixel_ypos_w;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    assign rst_n_w = locked_w && sys_rst_n;

    vga_pll u_vga_pll(
        .inclk0(sys_clk),
        .areset(!sys_rst_n),

        .c0(vga_clk_w),
        .locked(locked_w)
    );

    vga_driver u_vga_driver(
        .vga_clk(vga_clk_w),
        .sys_rst_n(rst_n_w),

        .vga_hs(vga_hs),
        .vga_vs(vga_vs),
        .vga_rgb(vga_rgb),

        .pixel_data(pixel_data_w),
        .pixel_xpos(pixel_xpos_w),
        .pixel_ypos(pixel_ypos_w)
    );

    vga_display u_vga_display(
        .vga_clk(vga_clk_w),
        .sys_rst_n(rst_n_w),

        .pixel_data(pixel_data_w),
        .pixel_xpos(pixel_xpos_w),
        .pixel_ypos(pixel_ypos_w)
    );

endmodule