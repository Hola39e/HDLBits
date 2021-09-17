/****************************************************************************************
	
	File name    : lcd_rgb_char.v
	LastEditors  : H
	LastEditTime : 2021-09-14 20:54:43
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-14 20:54:40
	FilePath     : lcd_rgb_char.v
	Copyright 2021 H, All Rights Reserved. 
	
 ****************************************************************************************/

module lcd_rgb_char(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    output              lcd_de,
    output              lcd_hs,
    output              lcd_vs,
    output              lcd_clk,

    inout   [15:0]     lcd_rgb,
    output              lcd_rst,
    output              lcd_bl
);
    // wire define
    wire    [15:0]      lcd_id;
    wire                lcd_pclk;
    wire    [10:0]      pixel_xpos;
    wire    [10:0]      pixel_ypos;
    wire    [10:0]      h_disp;
    wire    [10:0]      v_disp;
    wire    [15:0]      pixel_data;
    wire    [15:0]      lcd_rgb_o;
    wire    [15:0]      lcd_rgb_i;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    // 像素数据方向切换
    assign lcd_rgb = lcd_de ? lcd_rgb_o : {16{1'bz}};
    assign lcd_rgb_i = lcd_rgb;

    rd_id   u_rd_id(
        .clk    (sys_clk),
        .rst_n  (sys_rst_n),
        .lcd_rgb(lcd_rgb_i),
        .lcd_id (lcd_id)
    );
    
    clk_div u_clk_div(
        .clk    (sys_clk),
        .rst_n  (sys_rst_n),
        .lcd_id (lcd_id),
        .lcd_pclk(lcd_pclk)
    );

    lcd_display u_lcd_display(
        .lcd_pclk       (lcd_pclk),
        .rst_n          (sys_rst_n),
        .pixel_xpos     (pixel_xpos),
        .pixel_ypos     (pixel_ypos),
        .h_disp         (h_disp),
        .v_disp         (v_disp),
        .pixel_data     (pixel_data)
    );

    lcd_driver  u_lcd_driver(
        .lcd_pclk        (lcd_pclk),
        .rst_n          (sys_rst_n),
        .lcd_id         (lcd_id),
        .pixel_data     (pixel_data),
        .pixel_xpos     (pixel_xpos),
        .pixel_ypos     (pixel_ypos),
        .h_disp         (h_disp),
        .v_disp         (v_disp),

        .lcd_de         (lcd_de),
        .lcd_hs         (lcd_hs),
        .lcd_vs         (lcd_vs),
        .lcd_clk        (lcd_clk),
        .lcd_rgb        (lcd_rgb_o),
        .lcd_rst        (lcd_rst),
        .lcd_bl         (lcd_bl)
    );
endmodule