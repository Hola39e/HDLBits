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
    output      [15:0]  pixel_data
);
    // parameter define
    parameter H_DISP = 10'd640;
    parameter V_DISP = 10'd480;

    localparam POS_X = 10'd270;
    localparam POS_Y = 10'd190;
    localparam WIDTH = 10'd100;
    localparam HEIGHT = 10'd100;
    localparam TOTAL = 14'd10000;       // all pixels num of picture

    localparam WHITE = 16'b11111_111111_11111;
    localparam BLACK = 16'b00000_000000_00000;
    localparam RED   = 16'b11111_000000_00000;
    localparam GREEN = 16'b00000_111111_00000;
    localparam BLUE  = 16'b00000_000000_11111;

    // reg define
    reg [13:0]      rom_addr;
    reg             rom_valid;      // 读rom数据有效信号

    // wire define
    wire [15:0]     rom_data;
    wire            rom_rd_en;      // read rom enable signal
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    assign pixel_data = rom_valid ? rom_data : BLACK;
    
    assign rom_rd_en = (pixel_xpos >= POS_X) && (pixel_xpos < POS_X + WIDTH)
                        && (pixel_ypos >= POS_Y) && (pixel_ypos < POS_Y + HEIGHT)
                        ? 1'b1 : 1'b0;
    // 控制读地址
    always @(posedge vga_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            rom_addr <= 14'd0;
        end
        else if (rom_rd_en) begin
            if (rom_addr < TOTAL - 1'b1) begin      // TOTAL - 1'b1 is the last addr of rom
                rom_addr <= rom_addr + 1'b1;
            end
            else    
                rom_addr <= 14'b0;
        end
        else begin
            rom_addr <= rom_addr;
        end
    end

    // 从 rom_rd_en 拉高 然后读取地址 rom输出数据 经过了一个时钟周期， 所以rom_data 复制到 pixel_data
    // 需要经过 一个周期的延时
    always @(posedge vga_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            rom_valid <= 1'b0;
        end
        else begin
            rom_valid <= rom_rd_en;
        end
    end

    pic_rom pic_rom_inst(
        .clock      (vga_clk),
        .address    (rom_addr),
        .rden       (rom_rd_en),
        .q          (rom_data)
    );
endmodule