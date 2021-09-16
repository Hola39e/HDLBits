/****************************************************************************************
	File name    : led_ctrl.v
	LastEditors  : H
	LastEditTime : 2021-09-15 21:38:22
	Last Version : 1.0
	Description  : sub module of top remote rcv
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-15 21:38:18
	FilePath     : led_ctrl.v
	Copyright 2021 H, All Rights Reserved. 
 ****************************************************************************************/

module led_ctrl(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    input           repeat_en,
    output  reg     led
);

    // reg define
    reg     repeat_en_d0;
    reg     repeat_en_d1;
    reg [22:0] led_cnt;

    // wire define
    wire    pos_repeat_en;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    assign pos_repeat_en = (!repeat_en_d1) & repeat_en_d0;

    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            repeat_en_d0 <= 1'b0;
            repeat_en_d1 <= 1'b0;
        end
        else begin
            repeat_en_d0 <= repeat_en;
            repeat_en_d1 <= repeat_en_d0;
        end
    end

    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            led_cnt <= 23'd0;
            led <= 1'b0;
        end
        else begin
            if (pos_repeat_en) begin
                led_cnt <= 23'd5_000_000;
                led     <= 1'b1;
            end
            else if (led_cnt != 23'b0) begin
                led_cnt <= led_cnt - 1'b1;
                if (led_cnt <= 23'd1_000_000) begin
                    led <= 1'b0;
                end
            end
        end
    end

endmodule