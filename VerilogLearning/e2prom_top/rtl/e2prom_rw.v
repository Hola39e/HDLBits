/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-09-21 15:42:33
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-21 15:42:31
	FilePath     : \e2prom_top\rtl\e2prom_rw.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module e2prom_rw(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    output  reg         i2c_rh_wl,
    output  reg         i2c_exec,
    output  reg [15:0]  i2c_addr,
    output  reg [7:0]   i2c_data_w,
    input       [7:0]   i2c_data_r,
    input               i2c_done,
    input               i2c_ack,

    output reg          rw_done,        // e2prom 读写测试完成
    output reg          rw_result       // 读写测试结果
);

    // parameter define
    // e2prom 写数据需要添加间隔时间，读数据不需要
    parameter WR_WAIT_TIME  = 14'd5000;
    parameter MAX_BYTE      = 16'd256;

    // reg define
    reg [1:0] flow_cnt; //  状态流控制
    reg [13:0] wait_cnt;// 延时计数器

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    
    // EEPROM 读写测试 先写后读 并比较读出和写入的值是否一致
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            flow_cnt <= 2'b0;
            i2c_rh_wl <= 1'b0;
            i2c_exec <= 1'b0;
            i2c_addr <= 16'b0;
            i2c_data_w <= 8'b0;
            wait_cnt <= 14'b0;
            rw_done <= 1'b0;
            rw_result <= 1'b0;
        end
        else begin
            i2c_exec <= 1'b0;
            rw_done <= 1'b0;
            case (flow_cnt)
                2'd0: begin
                    wait_cnt <= wait_cnt + 1'b1;
                    if (wait_cnt == WR_WAIT_TIME - 1'b1) begin
                        wait_cnt <= 1'b0;
                        if (i2c_addr == MAX_BYTE) begin
                            i2c_addr <= 16'b0;
                            i2c_rh_wl <= 1'b1;
                            flow_cnt <= 2'd2;
                        end
                        else begin
                            flow_cnt <= flow_cnt + 1'b1;
                            i2c_exec <= 1'b1;
                        end
                    end
                end 
                2'd1: begin
                    if (i2c_done) begin
                        flow_cnt <= 2'd0;
                        i2c_addr <= i2c_addr + 1'b1;
                        i2c_data_w <= i2c_data_w + 1'b1;
                    end
                end
                2'd2: begin
                    flow_cnt <= flow_cnt + 1'b1;
                    i2c_exec <= 1'b1;
                end
                2'd3: begin
                    if (i2c_done == 1'b1) begin
                        if ((i2c_addr[7:0] != i2c_data_r) || (i2c_ack == 1'b1)) begin
                            rw_done <= 1'b1;
                            rw_result <= 1'b1;
                        end
                        else if (i2c_addr == MAX_BYTE - 1'b1) begin
                            rw_done <= 1'b1;
                            rw_result <= 1'b1;
                        end
                        else begin
                            flow_cnt <= 2'd2;
                            i2c_addr <= i2c_addr + 1'b1;
                        end
                    end
                end
                default: ;
            endcase
        end
    end
endmodule