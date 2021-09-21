/****************************************************************************************

	File name    : led_alarm
	LastEditors  : H
	LastEditTime : 2021-09-21 16:37:43
	Last Version : 1.0
	Description  : submodule of led_alarm
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-21 16:37:41
	FilePath     : \e2prom_top\rtl\led_alarm.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module led_alarm
    #(parameter L_TIME = 25'd25_000_000
    )
    (
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input       rw_done,
    input       rw_result,
    output  reg led
);

    // reg define
    reg rw_done_flag;
    reg [24:0]  led_cnt;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            rw_done_flag <= 1'b0;
        end
        else if (rw_done) begin
            rw_done_flag <= 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            led_cnt <= 25'b0;
            led <= 1'b0;
        end
        else begin
            if (rw_done_flag) begin
                if (rw_result) begin
                    led <= 1'b1;
                end
                else begin
                    led_cnt <= led_cnt + 1'b1;
                    if (led_cnt == L_TIME - 1'b1) begin
                        led_cnt <= 25'b0;
                        led <= !led;
                    end
                end
            end
            else
                led <= 1'b0;
        end
    end

endmodule