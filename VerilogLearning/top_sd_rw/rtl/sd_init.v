/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-09-29 16:36:57
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-29 16:36:55
	FilePath     : \top_sd_rw\rtl\sd_init.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module sd_init(
    // System Clock
    input        clk_ref,
    input        rst_n,

    input               sd_miso,
    output              sd_clk,
    output reg          sd_cs,
    output reg          sd_mosi,

    output reg          sd_init_done
);

    // parameter define
    parameter  CMD0  = {8'h40,8'h00,8'h00,8'h00,8'h00,8'h95};
    parameter  CMD8  = {8'h48,8'h00,8'h00,8'h01,8'haa,8'h87};
    parameter  CMD55 = {8'h77,8'h00,8'h00,8'h00,8'h00,8'hff};
    parameter  ACMD41= {8'h69,8'h40,8'h00,8'h00,8'h00,8'hff};

    parameter st_idle = 3'd0, st_send_cmd0 = 3'd1, st_wait_cmd0 = 3'd2,st_send_cmd8 = 3'd3;
    parameter st_send_cmd55  = 3'd4, st_send_acmd41 = 3'd5, st_init_done = 3'd6;

    // reg define
    reg [2:0] next_state, current_state;
    reg [6:0] clk_delay_cnt;

    always @(*) begin
        case (current_state)
            st_idle: next_state = (clk_delay_cnt == 7'd74) ? st_send_cmd0 : st_idle;
            default: ;
        endcase
    end

    always @(posedge sd_clk or negedge rst_n ) begin
        if(!rst_n)begin
            clk_delay_cnt <= 7'b0;
        end
        else if (current_state == st_idle)begin
            if (clk_delay_cnt == 7'd74) begin
                clk_delay_cnt <= 7'b0;
            end
            else    
                clk_delay_cnt <= clk_delay_cnt + 1'b1;
        end
        else
            clk_delay_cnt <= clk_delay_cnt;
    end
endmodule