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
    parameter V_DISP = 10'd480;

    localparam POS_X = 10'd272;
    localparam POS_Y = 10'd224;
    localparam WIDTH = 10'd96;
    localparam HEIGHT = 10'd32;
    localparam XFRAME = 10'd96;
    localparam YFRAME = 10'd32;

    localparam WHITE = 16'b11111_111111_11111;
    localparam BLACK = 16'b00000_000000_00000;
    localparam RED   = 16'b11111_000000_00000;
    localparam GREEN = 16'b00000_111111_00000;
    localparam BLUE  = 16'b00000_000000_11111;

    // reg define
    reg [95:0]      char[31:0];

    // wire define
    wire [9:0]      x_cnt;
    wire [9:0]      y_cnt;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    assign x_cnt = pixel_xpos - POS_X;
    assign y_cnt = pixel_ypos - POS_Y;
    always @(posedge vga_clk ) begin
        char[0] <= 96'h000000000000000000000000;
        char[1] <= 96'h000000000000000000000000;
        char[2] <= 96'h000000000000000000000000;
        char[3] <= 96'h000000000000000000000000;
        char[4] <= 96'h000000000000000000000000;
        char[5] <= 96'h000000000000000000000000;
        char[6] <= 96'h000000000000000000000000;
        char[7] <= 96'h000000000000000000000000;
        char[8] <= 96'h000000000000000000000000;
        char[9] <= 96'h000000000000000001800000;
        char[10] <= 96'h000000000000000003C00000;
        char[11] <= 96'h3FE000000000000003C00000;
        char[12] <= 96'h30F800000000000000000000;
        char[13] <= 96'h303C00000000000000000000;
        char[14] <= 96'h301C0FE007F807E01FC031F0;
        char[15] <= 96'h300E1FF80FF80FF81FC03FF8;
        char[16] <= 96'h300E00381C001C1C01C03E18;
        char[17] <= 96'h300E001C1800381C01C0381C;
        char[18] <= 96'h300E001C1C00300C01C0381C;
        char[19] <= 96'h300E07FC0FC03FFC01C0381C;
        char[20] <= 96'h300E1FFC03F03FFC01C0381C;
        char[21] <= 96'h300C381C0078300001C0381C;
        char[22] <= 96'h301C381C001C380001C0381C;
        char[23] <= 96'h3038383C0018380001C0381C;
        char[24] <= 96'h3FF03DFC1FF81F3C3FFC381C;
        char[25] <= 96'h3FC01FDC1FE007FC3FFC381C;
        char[26] <= 96'h000000000000000000000000;
        char[27] <= 96'h000000000000000000000000;
        char[28] <= 96'h000000000000000000000000;
        char[29] <= 96'h000000000000000000000000;
        char[30] <= 96'h000000000000000000000000;
        char[31] <= 96'h000000000000000000000000;
    end
    // 为不同区域绘制不同颜色
    always @(posedge vga_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            pixel_data <= BLACK;
        end
        else begin
            if ((pixel_xpos >= POS_X - XFRAME) && (pixel_xpos < POS_X + WIDTH + XFRAME)
                && (pixel_ypos >= POS_Y - YFRAME) && (pixel_ypos < POS_Y + HEIGHT + YFRAME)) begin
                    if ((pixel_xpos >= POS_X) && (pixel_xpos < POS_X + WIDTH) 
                        && (pixel_ypos >= POS_Y) && (pixel_ypos < POS_Y + HEIGHT)) begin
                        if (char[y_cnt][WIDTH - 1'b1 - x_cnt]) begin
                            pixel_data <= RED;
                        end
                        else
                            pixel_data <= BLACK;
                end
                    else 
                        pixel_data <= BLACK;
            end
            else
                pixel_data <= WHITE;
        end
    end
endmodule