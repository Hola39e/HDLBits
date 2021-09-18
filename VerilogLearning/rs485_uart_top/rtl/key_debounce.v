/****************************************************************************************

	File name    : key_debounce.v
	LastEditors  : H
	LastEditTime : 2021-09-18 14:57:13
	Last Version : 1.0
	Description  : sub module of rs485, to ket debounce
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-18 14:57:11
	FilePath     : key_debounce.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/

module key_debounce(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    input   [3:0]       key,

    output  reg [3:0]   key_value,      // 按键消抖后的数据
    output  reg         key_flag        // 按键数据有效信号
);

    // reg define
    reg [31:0]      delay_cnt;
    reg [3:0]       key_reg;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            key_reg <= 4'b1111;
            delay_cnt <= 32'd0;
        end
        else begin
            key_reg <= key;
            // 如果新时刻的键值不等于前一时刻键值 那么延时计数器重载初始值
            if (key != key_reg) begin
                delay_cnt <= 32'd1_000_000;
            end
            else if (key == key_reg) begin
                if (delay_cnt > 32'd0) begin
                    delay_cnt <= delay_cnt - 1'b1;
                end
                else
                    delay_cnt <= delay_cnt;
            end
        end
    end

    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            key_flag <= 1'b0;
            key_value <= 4'b1111;
        end
        else begin
            if (delay_cnt == 1'b1) begin
                key_flag <= 1'b1;       // 此时消抖过程阶数， 给出一个时钟周期的标志信号
                key_value <= key;
            end
            else begin
                key_flag <= 1'b0;
                key_value <= key_value;
            end
        end
    end


endmodule