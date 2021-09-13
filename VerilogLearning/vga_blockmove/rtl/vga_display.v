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

    localparam SIDE_W = 10'd40;
    localparam BLOCK_W = 10'd40;
    localparam WHITE = 16'b11111_111111_11111;
    localparam BLACK = 16'b00000_000000_00000;
    localparam RED   = 16'b11111_000000_00000;
    localparam GREEN = 16'b00000_111111_00000;
    localparam BLUE  = 16'b00000_000000_11111;

    // reg define
    reg [9:0]       block_x; 
    reg [9:0]       block_y;
    reg [21:0]      div_cnt;
    reg             h_direct;    
    reg             v_direct;    

    // wire define
    wire            move_en;        // 移动使能信号 频率为100Hz

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    assign  move_en = (div_cnt == 22'd250_000 - 1'b1)?1'b1:1'b0;
                                    // vga_clk is 25Mhz, so div_cnt count 250_000 get 100Hz
    always @(posedge vga_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            div_cnt <= 22'b0;
        end
        else begin
            if (div_cnt == 22'd250_000 - 1'b1) begin
                div_cnt <= 22'b0;
            end
            else 
                div_cnt <= div_cnt + 1'b1;
        end
    end

    always @(posedge vga_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            h_direct <= 1'b1;       // default direct right
            v_direct <= 1'b1;       // default direct down
        end
        else begin
            case (block_x)
                SIDE_W - 1'b1 : h_direct <= 1'b1; 
                H_DISP - SIDE_W - BLOCK_W : h_direct <= 1'b0;
                default: h_direct <= h_direct;
            endcase 
            case (block_y)
                SIDE_W - 1'b1 : v_direct <= 1'b1; 
                V_DISP - SIDE_W - BLOCK_W : v_direct <= 1'b0;
                default: v_direct <= v_direct;
            endcase 
        end
    end

    // according to the cube moving direction, change its posx and posy
    always @(posedge vga_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            block_x <= 10'd100;
            block_y <= 10'd100;
        end
        else if (move_en) begin
            // h_direct = 1, then move right
            block_x <= h_direct ? (block_x + 1'b1):(block_x - 1'b1);
            block_y <= v_direct ? (block_y + 1'b1):(block_y - 1'b1);
        end
        else begin
            block_x <= block_x;
            block_y <= block_y;
        end
    end

    // 为不同区域绘制不同颜色
    always @(posedge vga_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            pixel_data <= BLACK;
        end
        else begin
            if ((pixel_xpos < SIDE_W) || (pixel_xpos >= H_DISP - SIDE_W) 
            || (pixel_ypos < SIDE_W) || (pixel_ypos >= V_DISP - SIDE_W)) begin
                pixel_data <= BLUE;
            end
            else 
            if ((pixel_xpos >= block_x) && (pixel_xpos < block_x + BLOCK_W) 
            && (pixel_ypos >= block_y) && (pixel_ypos < block_y + BLOCK_W)) begin
                pixel_data <= BLACK;
            end
            else
                pixel_data <= WHITE;
        end
    end
endmodule