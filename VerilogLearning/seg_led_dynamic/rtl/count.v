/*******************************************************************************
@Author: H 
@Associated Filename: count.v
@Purpose: Low-level module count
@Device: All 
@Version: 
@Date: 2021/09/10 18:38:17

*******************************************************************************/
module count (
    input sys_clk,
    input sys_rst_n,

    // user interface
    output reg [19:0] data,
    output reg [5:0] point,
    output reg en,
    output reg sign
);
    parameter MAX_NUM = 23'd5000_000;
    reg [22:0] cnt;
    reg flag;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            cnt <= 23'b0;
        end
        else if(cnt < MAX_NUM - 1'b1)begin
            flag <= 1'b0;
            cnt <= cnt + 1'b1;
        end 
        else begin
            cnt <= 23'b0;
            flag <= 1'b1;
        end
    end

    // the num of the digital cube need to display
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            data <= 20'b0;
            point <= 6'b0;
            en <= 1'b0;
            sign <= 1'b0;
        end
        else begin
            point <= 6'b0;
            en <= 1'b1;
            sign <= 1'b0;
            if (flag) begin
                if (data < 20'd999_999) begin
                    data <= data + 1'b1;
                end
                else begin
                    data <= 20'b0;
                end
            end
        end
    end
endmodule