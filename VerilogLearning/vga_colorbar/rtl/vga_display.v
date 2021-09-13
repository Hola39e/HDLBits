/*******************************************************************************

    @Author: H 
    @Associated Filename: vga_display.v
    @Purpose: low_level module of vga_colorbar
    @Device: All 
    @Version: 1.0
    @Date: 2021/09/13 14:12:09

*******************************************************************************/
module vga_display(
    // System Clock
    input        vga_clk,
    input        sys_rst_n,

    // User Interface
    input       [9:0]   pixel_xpos,
    input       [9:0]   pixel_ypos,
    output  reg [15:0]  pixel_data
);
    // parameter define
    parameter H_DISP = 10'd640;
    parameter  V_DISP = 10'd480;

    localparam WHITE = 16'b11111_111111_11111;
    localparam BLACK = 16'b00000_000000_00000;
    localparam RED   = 16'b11111_000000_00000;
    localparam GREEN = 16'b00000_111111_00000;
    localparam BLUE  = 16'b00000_000000_11111;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    // 根据当前像素点坐标指定当前像素点颜色数据，在屏幕上显示彩条
    always @(posedge vga_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            pixel_data <= 16'b0;
        end
        else begin
            if ((pixel_xpos >= 0)&&(pixel_xpos < (H_DISP / 5) * 1)) begin
                pixel_data <= WHITE;
            end
            else if ((pixel_xpos >= (H_DISP / 5) * 1)&&(pixel_xpos < (H_DISP / 5) * 2)) begin
                pixel_data <= BLACK;
            end
            else if ((pixel_xpos >= (H_DISP / 5) * 2)&&(pixel_xpos < (H_DISP / 5) * 3)) begin
                pixel_data <= RED;
            end
            else if ((pixel_xpos >= (H_DISP / 5) * 3)&&(pixel_xpos < (H_DISP / 5) * 4)) begin
                pixel_data <= GREEN;
            end
            else begin
                pixel_data <= BLUE;
            end
        end
    end

endmodule