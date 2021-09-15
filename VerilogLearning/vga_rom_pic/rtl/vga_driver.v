/*******************************************************************************

    @Author: H 
    @Associated Filename: vga_driver.v
    @Purpose: low-level module of vga_colorbar
    @Device: All 
    @Version: 1.0
    @Date: 2021/09/12 22:14:30

*******************************************************************************/

module vga_driver(
    // System Clock
    input        vga_clk,
    input        sys_rst_n,

    // User Interface
    output          vga_hs,
    output          vga_vs,
    output  [15:0]  vga_rgb,

    input   [15:0]  pixel_data,
    output   [9:0]   pixel_xpos,
    output   [9:0]   pixel_ypos
);
    // parameter define
    parameter  H_SYNC = 10'd96;
    parameter  H_BACK = 10'd48;
    parameter  H_DISP = 10'd640;
    parameter  H_FRONT = 10'd16;
    parameter  H_TOTAL = 10'd800;

    parameter  V_SYNC = 10'd2;
    parameter  V_BACK = 10'd33;
    parameter  V_DISP = 10'd480;
    parameter  V_FRONT = 10'd10;
    parameter  V_TOTAL = 10'd525;

    // reg define
    reg [9:0] cnt_h;
    reg [9:0] cnt_v;

    // wire define
    wire vga_en;
    wire data_req;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    // v sync and h sync
    assign vga_hs = (cnt_h <= H_SYNC - 1'b1)?1'b0:1'b1;
    assign vga_vs = (cnt_v <= V_SYNC - 1'b1)?1'b0:1'b1;

    assign vga_en = (((cnt_h >= H_SYNC + H_BACK) && (cnt_h < H_SYNC + H_BACK + H_DISP))
                    && ((cnt_v >= V_SYNC + V_BACK) && (cnt_v < V_SYNC + V_BACK + V_DISP)))
                    ? 1'b1:1'b0;

    assign vga_rgb = vga_en ? pixel_data : 16'b0;

    assign data_req = (((cnt_h >= H_SYNC + H_BACK - 1'b1) && (cnt_h < H_SYNC + H_BACK + H_DISP - 1'b1))
                    && ((cnt_v >= V_SYNC + V_BACK) && (cnt_v < V_SYNC + V_BACK + V_DISP)))
                    ? 1'b1:1'b0;

    assign pixel_xpos = data_req ? (cnt_h - (H_SYNC + H_BACK - 1'b1)):10'b0;
    assign pixel_ypos = data_req ? (cnt_v - (V_SYNC + V_BACK - 1'b1)):10'b0;

    // h sync counter to count the pixel clock
    // 行计数器对像素时钟计数
    always @(posedge vga_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            cnt_h <= 10'd0;
        end
        else if (cnt_h < H_TOTAL - 1'b1) begin
            cnt_h <= cnt_h + 1'b1;
        end
        else 
            cnt_h <= 10'b0;
    end

    // v sync counter
    // 场计数器对行计数
    always @(posedge vga_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            cnt_v <= 10'b0;
        end
        else if (cnt_h == H_TOTAL - 1'b1) begin
            if (cnt_v < V_TOTAL - 1'b1) begin
                cnt_v <= cnt_v + 1'b1;
            end
            else
                cnt_v <= 10'b0;
        end
    end
endmodule