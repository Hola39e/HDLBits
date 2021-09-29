/****************************************************************************************
	File name    : 
	LastEditors  : H
	LastEditTime : 2021-09-29 12:45:00
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-29 12:44:58
	FilePath     : \top_sd_rw\rtl\sd_ctrl_top.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module sd_ctrl_top(
    // System Clock
    input           clk_ref,
    input           clk_ref_180deg,
    input           rst_n,

    // SD card interface
    input           sd_miso,
    output          sd_clk,
    output  reg     sd_cs,
    output  reg     sd_mosi,

    // user SD card write interface
    input           wr_start_en,
    input   [31:0]  wr_sec_addr,    // addr of sector which data to write
    input   [15:0]  wr_data,

    output           wr_busy,
    output           wr_req,

    // user SD card read interface
    input           rd_start_en,
    input   [31:0]  rd_sec_addr,

    output          rd_busy,
    output          rd_val_en,
    output  [15:0]  rd_val_data,

    output          sd_init_done
);

    // wire define
    wire            init_sd_clk;        // clk of SD card initialization 
    wire            init_sd_cs;         // cs signal
    wire            init_sd_mosi;       // init module of data out
    wire            wr_sd_cs;
    wire            wr_sd_mosi;
    wire            rd_sd_cs;
    wire            rd_sd_mosi;

    assign          sd_clk = (sd_init_done == 1'b0) ? init_sd_clk : clk_ref_180deg;

    always @(*) begin
        if (sd_init_done == 1'b0) begin
            sd_cs = init_sd_cs;
            sd_mosi = init_sd_mosi;
        end
        else if (wr_busy) begin
            sd_cs = wr_sd_cs;
            sd_mosi = wr_sd_mosi;
        end
        else if (rd_busy) begin
            sd_cs = rd_sd_cs;
            sd_mosi = rd_sd_mosi;
        end
        else begin
            sd_cs = 1'b1;
            sd_mosi = 1'b1;
        end
    end

    sd_init u_sd_init(
        .clk_ref        (clk_ref),
        .rst_n          (rst_n),

        .sd_miso        (sd_miso),
        .sd_clk         (init_sd_clk),
        .sd_cs          (init_sd_cs),
        .sd_mosi        (init_sd_mosi),

        .sd_init_done   (sd_init_done)
    );

    sd_write u_sd_write(
        .clk_ref        (clk_ref),
        .clk_ref_180deg (clk_ref_180deg),
        .rst_n          (rst_n),

        .sd_miso        (sd_miso),
        .sd_cs          (wr_sd_cs),
        .sd_mosi        (wr_sd_mosi),

        .wr_start_en    (wr_start_en & sd_init_done),
        .wr_sec_addr    (wr_sec_addr),
        .wr_data        (wr_data),
        .wr_busy        (wr_busy),
        .wr_req         (wr_req)
    );

    sd_read u_sd_read(
        .clk_ref        (clk_ref),
        .clk_ref_180deg (clk_ref_180deg),
        .rst_n          (rst_n),

        .sd_miso        (sd_miso),
        .sd_cs          (rd_sd_cs),
        .sd_mosi        (rd_sd_mosi),

        .rd_start_en    (rd_start_en & sd_init_done),
        .rd_sec_addr    (rd_sec_addr),
        .rd_busy        (rd_busy),
        .rd_val_en      (rd_val_en),
        .rd_val_data    (rd_val_data)
    );
endmodule
