/****************************************************************************************

	File name    : led_ctrl.v
	LastEditors  : H
	LastEditTime : 2021-09-18 16:45:43
	Last Version : 1.0
	Description  : led control, sub module of rs485
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-18 16:45:41
	FilePath     : led_ctrl.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/

module led_ctrl(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    input           led_en,
    input   [3:0]   led_data,

    output  reg [3:0] led
);
    // reg define
    reg led_en_d0;
    reg led_en_d1;

    // wire define
    wire led_en_flag;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    assign led_en_flag = (!led_en_d1) & led_en_d0;

    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            led_en_d1 <= 1'b0;
            led_en_d0 <= 1'b0;
        end
        else begin
            led_en_d0 <= led_en;
            led_en_d1 <= led_en_d0;
        end
    end

    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            led <= 4'b0000;
        end
        else if (led_en_flag) begin
            led <= !led_data;
        end
        else
            led <= led;
    end

endmodule