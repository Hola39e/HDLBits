/*******************************************************************************
@Author: H 
@Associated Filename: seg_led_static.v
@Purpose: Low-level module
@Device: All 
@Version: 1.0
@Date: 2021/09/10 18:07:13

*******************************************************************************/
module seg_led_static (
    input sys_clk,
    input sys_rst_n,

    input  add_flag,
    output reg [5:0]  sel,
    output reg [7:0] seg_led
);
    // here need to notice sel and seg_led must be reg or cannot be nonblocking assignment 
    reg [3:0] num;  
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    // Strobe the 6 Digital tube
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if (!sys_rst_n) begin
            sel <= 6'b111_111;
        end
        else    
            sel <= 6'b000_000;
    end
    // the num show an the tube is added by timing 
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            num <= 4'b0;
        end
        else if (add_flag) begin
            if (num < 4'hf) begin
                num <= num + 1'b1;
            end
            else 
                num <= 4'h0;
        end
        else begin
            num <= num;
        end
    end
    // num - digital tube
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            seg_led <= 8'b0;
        end
        else begin
            case (num)
                4'h0: seg_led <= 8'b1100_0000;
                4'h1: seg_led <= 8'b1111_1001;
                4'h2: seg_led <= 8'b1010_0100;
                4'h3: seg_led <= 8'b1011_0000;
                4'h4: seg_led <= 8'b1001_1001;
                4'h5: seg_led <= 8'b1001_0010;
                4'h6: seg_led <= 8'b1000_0010;
                4'h7: seg_led <= 8'b1111_1000;
                4'h8: seg_led <= 8'b1000_0000;
                4'h9: seg_led <= 8'b1001_0000;
                4'ha: seg_led <= 8'b1000_1000;
                4'hb: seg_led <= 8'b1000_0011;
                4'hc: seg_led <= 8'b1100_0110;
                4'hd: seg_led <= 8'b1010_0001;
                4'he: seg_led <= 8'b1000_0110;
                4'hf: seg_led <= 8'b1000_1110;
                default: seg_led <= 8'b1100_0000;
            endcase     
        end
    end
endmodule