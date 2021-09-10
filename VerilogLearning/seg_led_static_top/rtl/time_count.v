/*******************************************************************************
@Author: H 
@Associated Filename: time_count.v
@Purpose: Low-level module
@Device: All 
@Version: 
@Date: 2021/09/10 18:38:17

*******************************************************************************/
module time_count (
    input sys_clk,
    input sys_rst_n,

    output reg add_flag
);
    parameter MAX_NUM = 25000_000;
    reg [24:0] cnt;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            cnt <= 25'b0;
        end
        else if(cnt < MAX_NUM - 1'b1)begin
            add_flag <= 1'b0;
            cnt <= cnt + 1'b1;
        end 
        else begin
            cnt <= 25'b0;
            add_flag <= 1'b1;
        end
    end
endmodule