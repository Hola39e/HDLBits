/****************************************************************************************
	
	File name    : lcd_display.v
	LastEditors  : H
	LastEditTime : 2021-09-14 19:45:16
	Last Version : 1.0
	Description  : lcd display low-level module
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-14 19:45:14
	FilePath     : lcd_display.v
	Copyright 2021 H, All Rights Reserved. 
	
 ****************************************************************************************/
module lcd_display(
    // System Clock
    input        lcd_pclk,
    input        rst_n,

    // User Interface
    input   [10:0]      pixel_xpos,
    input   [10:0]      pixel_ypos,
    input   [10:0]      h_disp,
    input   [10:0]      v_disp,
    output  reg [15:0]  pixel_data
);
    // parameter define
    parameter WHITE = 16'b11111_111111_11111;
    parameter BLACK = 16'b00000_000000_00000;
    parameter RED   = 16'b11111_000000_00000;
    parameter GREEN = 16'b00000_111111_00000;
    parameter BLUE  = 16'b00000_000000_11111;

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    always @(posedge lcd_pclk or negedge rst_n ) begin
        if(!rst_n)begin
            pixel_data <= BLACK;
        end
        else begin
            if ((pixel_xpos >= 11'b0) && (pixel_xpos < h_disp / 5 * 1)) begin
                pixel_data <= WHITE;
            end
            else if ((pixel_xpos >= h_disp / 5 * 1) && (pixel_xpos < h_disp / 5 * 2)) begin
                pixel_data <= BLACK;
            end
            else if ((pixel_xpos >= h_disp / 5 * 2) && (pixel_xpos < h_disp / 5 * 3)) begin
                pixel_data <= RED;
            end
            else if ((pixel_xpos >= h_disp / 5 * 3) && (pixel_xpos < h_disp / 5 * 4)) begin
                pixel_data <= GREEN;
            end
            else
                pixel_data <= BLUE;
        end
    end
    
endmodule