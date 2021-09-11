/*******************************************************************************
@Author: H 
@Associated Filename: seg_led.v
@Purpose: Low-level module of seg_led
@Device: All 
@Version: 1.0
@Date: 2021/09/10 18:07:13

*******************************************************************************/
module seg_led (
    input sys_clk,
    input sys_rst_n,

    input  [19:0] data,
    input  [5:0] point,
    input   en,
    input   sign,

    // here what need to notice is sel and seg_led must be reg or cannot be nonblocking assignment 
    output reg [5:0]  seg_sel,
    output reg [7:0] seg_led
);
    // the difference between localparam and parameter is 
    // localparam cannot do Parameter passing! only effect in this module
    localparam CLK_DIVIDE = 4'd10;
    localparam MAX_NUM = 13'd5000;

    // reg define
    reg [3:0] clk_cnt;  //  Clock divide counter
    reg dri_clk;        // the clock drive digital tube
    reg [23:0] num;
    reg [12:0] cnt0;
    reg flag;
    reg [2:0] cnt_sel;
    reg [3:0] num_disp;
    reg dot_disp;

    // wire define
    wire [3:0] data0;
    wire [3:0] data1;
    wire [3:0] data2;
    wire [3:0] data3;
    wire [3:0] data4;
    wire [3:0] data5;
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    assign data0 = data % 4'd10;
    assign data1 = data /4'd10 % 4'd10;
    assign data2 = data /7'd100 % 4'd10;
    assign data3 = data /10'd1000 % 4'd10;
    assign data4 = data /14'd10000 % 4'd10;
    assign data5 = data /17'd100_000 % 4'd10;

    // divide the sys_clk by 10, use 5Mhz to drive digital tube
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            clk_cnt <= 4'b0;
            dri_clk <= 1'b1;
        end
        // why here is clk_cnt == CLK_DIVIDE/2 - 1
        // because the dri_clk keep and flip after T/2, so T/2 equals to (CLK_DIVIDE/2 - 1)*To
        else if (clk_cnt == CLK_DIVIDE/2 - 1) begin
            clk_cnt <= 4'b0;
            dri_clk <= !dri_clk;
        end
        else begin
            clk_cnt <= clk_cnt + 1'b1;
            dri_clk <= dri_clk;
        end
    end
        // transfer the 20bit Binary num to 4 bit Decimal num
        always @(posedge dri_clk or negedge sys_rst_n ) begin
            if(!sys_rst_n)begin
                num <= 24'b0;
            end
            else if (data5||point[5]) begin
                    num[23:20] <= data5;
                    num[19:16] <= data4;
                    num[15:12] <= data3;
                    num[11:8] <= data2;
                    num[7:4] <= data1;
                    num[3:0] <= data0;
            end
            else if (data4||point[4]) begin
                num[19:0] <= {data4,data3,data2,data1,data0};
                if (sign) begin
                    num[23:20] <= 4'd11;
                end
                else begin
                    num[23:20] <= 4'd10;
                end
            end
            else if (data3||point[3]) begin
                num[15:0] <= {data3,data2,data1,data0};
                num[23:20] <= 4'd10;
                if (sign) begin
                    num[19:16] <= 4'd11;
                end
                else begin
                    num[19:16] <= 4'd10;
                end
            end
            else if (data2||point[2]) begin
                num[11:0] <= {data2,data1,data0};
                num[23:20] <= 4'd10;
                num[19:16] <= 4'd10;
                if (sign) begin
                    num[15:12] <= 4'd11;
                end
                else begin
                    num[15:12] <= 4'd10;
                end
            end
            else if (data1||point[1]) begin
                num[7:0] <= {data1,data0};
                num[23:20] <= 4'd10;
                num[19:16] <= 4'd10;
                num[15:12] <= 4'd10;
                if (sign) begin
                    num[11:8] <= 4'd11;
                end
                else begin
                    num[11:8] <= 4'd10;
                end
            end
            else begin
                num[3:0] <= data0;
                num[23:20] <= 4'd10;
                num[19:16] <= 4'd10;
                num[15:12] <= 4'd10;
                num[11:8] <= 4'd10;
                if (sign) begin
                    num[7:4] <= 4'd11;
                end
                else begin
                    num[7:4] <= 4'd10;
                end
            end
        end

    // flag for when 5Mhz clock timing for 1ms 
    always @(posedge dri_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            cnt0 <= 13'b0;
            flag <= 1'b0;
        end
        else if (cnt0 < MAX_NUM -1 ) begin
            cnt0 <= cnt0 + 1'b1;
            flag <= 1'b0;
        end
        else begin
            cnt0 <= 13'b0;
            flag <= 1'b1;
        end
    end

    // dynamic enable/choose the digital tube
    always @(posedge dri_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            cnt_sel <= 3'b0;
        end
        else if (flag) begin
            if (cnt_sel < 3'd5) begin
                cnt_sel <= cnt_sel + 1'b1;
            end
            else begin
                cnt_sel <= 3'b0;
            end
        end
        else begin
            cnt_sel <= cnt_sel;
        end
    end

    always @(posedge dri_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            seg_sel <= 6'b111_111;
            num_disp <= 4'b0;
            dot_disp <= 1'b1;
        end
        else begin
            if (en) begin
                case (cnt_sel)
                    3'd0: begin
                        seg_sel <= 6'b111_110;
                        num_disp <= num[3:0];
                        dot_disp <= ~point[0];
                    end
                    3'd1: begin
                        seg_sel <= 6'b111_101;
                        num_disp <= num[7:4];
                        dot_disp <= ~point[1];
                    end
                    3'd2: begin
                        seg_sel <= 6'b111_011;
                        num_disp <= num[11:8];
                        dot_disp <= ~point[2];
                    end
                    3'd3: begin
                        seg_sel <= 6'b110_111;
                        num_disp <= num[15:12];
                        dot_disp <= ~point[3];
                    end
                    3'd4: begin
                        seg_sel <= 6'b101_111;
                        num_disp <= num[19:16];
                        dot_disp <= ~point[4];
                    end
                    3'd5: begin
                        seg_sel <= 6'b011_111;
                        num_disp <= num[23:20];
                        dot_disp <= ~point[5];
                    end
                    default: begin
                        seg_sel <= 6'b111_111;
                        num_disp <= 4'b0;
                        dot_disp <= 1'b1;
                    end
                endcase     
            end
            else begin
                seg_sel <= 6'b111_111;
                num_disp <= 4'b0;
                dot_disp <= 1'b1;
            end
        end
    end
    always @(posedge dri_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            seg_led <= 8'hc0;
        end
        else begin
            case (num_disp)
                4'd0: seg_led <= {dot_disp,7'b1000_000};
                4'd1: seg_led <= {dot_disp,7'b1111_001};
                4'd2: seg_led <= {dot_disp,7'b0100_100};
                4'd3: seg_led <= {dot_disp,7'b0110_000};
                4'd4: seg_led <= {dot_disp,7'b0011_001};
                4'd5: seg_led <= {dot_disp,7'b0010_010};
                4'd6: seg_led <= {dot_disp,7'b0000_010};
                4'd7: seg_led <= {dot_disp,7'b1111_000};
                4'd8: seg_led <= {dot_disp,7'b0000_000};
                4'd9: seg_led <= {dot_disp,7'b0010_000};
                4'd10: seg_led <= 8'b1111_1111;
                4'd11: seg_led <= 8'b1011_1111;
                default: seg_led <= {dot_disp,7'b1000_000};
            endcase
        end
    end
endmodule