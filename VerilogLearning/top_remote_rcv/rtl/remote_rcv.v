/****************************************************************************************/
/****************************************************************************************
	File name    : remote_rcv.v
	LastEditors  : H
	LastEditTime : 2021-09-15 18:52:38
	Last Version : 1.0
	Description  : sub module of top_remote_rcv 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-15 18:52:36
	FilePath     : remote_rcv.v
	Copyright 2021 H, All Rights Reserved. 
 ****************************************************************************************/
/****************************************************************************************/

module remote_rcv(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    input           remote_in,
    output  reg     repeat_en,
    output  reg     data_en,
    output  reg[7:0]data
);

    // parameter define
    parameter   st_idle             = 5'b0_0001;
    parameter   st_start_low_9ms    = 5'b0_0010;
    parameter   st_start_judge      = 5'b0_0100;
    parameter   st_rec_data         = 5'b0_1000;
    parameter   st_repeat_code      = 5'b1_0000;

    // reg define
    reg [4:0] cur_state;
    reg [4:0] next_state;

    reg     [11:0]      div_cnt;
    reg                 div_clk;
    reg                 remote_in_d0;
    reg                 remote_in_d1;
    reg     [7:0]       time_cnt;

    reg                 time_cnt_clr;   // 计数器清零信号
    reg                 time_done;      // 计时完成信号
    reg                 error_en;
    reg                 judge_flag;     // 0 为同步码高电平 对应空闲 1对应同步码低电平重复码
    reg     [15:0]      data_temp;
    reg     [5:0]       data_cnt;

    // wire define
    wire                pos_remote_in;
    wire                neg_remote_in;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    // 重复码： 9ms AGC + 2.25ms 空闲
    assign pos_remote_in = (!remote_in_d1) & remote_in_d0;
    assign neg_remote_in = remote_in_d1 & (!remote_in_d0);

    // clock divide, 50Mhz/(2*(3124 + 1)) = 8KHz, T = 0.125ms
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            div_cnt <= 12'b0;
            div_clk <= 1'b0;
        end
        else if (div_cnt == 12'd3124) begin
                div_cnt <= 12'b0;
                div_clk <= !div_clk;
        end
        else begin
                div_clk <= div_clk;
                div_cnt <= div_cnt + 1'b1;
        end
    end

    always @(posedge div_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            time_cnt <= 8'b0;
        end
        else if (time_cnt_clr) begin
            time_cnt <= 8'b0;
        end
        else
            time_cnt <= time_cnt + 8'b1;
    end

    always @(posedge div_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            remote_in_d0 <= 1'b0;
            remote_in_d1 <= 1'b0;
        end
        else begin
            remote_in_d0 <= remote_in;
            remote_in_d1 <= remote_in_d0;
        end
    end 

    always @(posedge div_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            cur_state <= st_idle;
        end
        else begin
            cur_state <= next_state;
        end
    end

    always @(*) begin
        next_state = st_idle;
        case (cur_state)
            st_idle:            next_state = remote_in_d0 ? st_idle : st_start_low_9ms; 
            st_start_low_9ms:   next_state = time_done ? st_start_judge : (error_en ? st_idle : st_start_low_9ms);
            st_start_judge:     next_state = time_done ? (judge_flag ? st_repeat_code : st_rec_data) : (error_en ? st_idle : st_start_judge);
            st_rec_data:        next_state = (pos_remote_in && (data_cnt == 6'd32)) ? st_idle : st_rec_data; 
            st_repeat_code:     next_state = pos_remote_in ? st_idle : st_repeat_code;
            default:            next_state = st_idle;
        endcase
    end

    always @(posedge div_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            time_cnt_clr    <= 1'b0;
            time_done       <= 1'b0;
            error_en        <= 1'b0;
            judge_flag      <= 1'b0;
            data_en         <= 1'b0;
            data            <= 8'b0;
            repeat_en       <= 1'b0;
            data_cnt        <= 6'b0;
            data_temp       <= 32'd0;
        end
        else begin
            time_cnt_clr    <= 1'b0;
            time_done       <= 1'b0;
            error_en        <= 1'b0;
            repeat_en       <= 1'b0;
            data_en         <= 1'b0;
            // time_cnt_clr = 1 will clear time_cnt
            case (cur_state)
                st_idle :   time_cnt_clr <=  remote_in_d0 ? 1'b1 : 1'b0;
                st_start_low_9ms : begin
                    if (pos_remote_in) begin
                        time_cnt_clr <= 1'b1;
                        if (time_cnt >= 8'd69 && time_cnt <= 8'd75) begin
                        time_done <= 1'b1;
                        end
                        else
                        error_en <= 1'b1;       // error_en <= 1'b1;  was in if (pos_remote_in) block
                        // pos_remote_in is check posedge and means AGC period is over
                        end
                end
                st_start_judge : begin
                    if (neg_remote_in) begin
                        time_cnt_clr <= 1'b1;
                        if (time_cnt >= 15 && time_cnt <= 20) begin
                            time_done <= 1'b1;
                            judge_flag <= 1'b1;
                        end
                        if (time_cnt >= 33 && time_cnt <= 38) begin
                            time_done <= 1'b1;
                            judge_flag <= 1'b0;
                        end
                        else
                            error_en <= 1'b1;
                    end
                end
                st_rec_data : begin
                    if (pos_remote_in) begin
                        time_cnt_clr <= 1'b1;
                        if (data_cnt == 6'd32) begin
                            data_en <= 1'b1;
                            data_cnt <= 6'b0;
                            data_temp <= 16'b0;
                            // what significant is ~ is Bitwise negation!
                            //                     ! is Logic negation!
                            if (data_temp [7:0] == ~data_temp[15:8]) begin
                                data <= data_temp[7:0];
                            end
                        end
                    end
                    if (neg_remote_in) begin
                        time_cnt_clr <= 1'b1;
                        data_cnt <= data_cnt + 1'b1;
                        // 解析控制码和控制反码
                        if (data_cnt >= 6'd16 && data_cnt <= 6'd31) begin
                            if (time_cnt >= 8'd2 && time_cnt <= 8'd6) begin
                                data_temp <= {1'b0,data_temp[15:1]};    // 数据右移一位 新数据填充在最高位
                            end
                            else if (time_cnt >= 8'd10 && time_cnt <= 8'd15) begin
                                data_temp <= {1'b1,data_temp[15:1]};
                            end
                        end
                    end
                end
                st_repeat_code : begin
                    if (pos_remote_in) begin
                        time_cnt_clr <= 1'b1;
                        repeat_en <= 1'b1;
                    end
                end
                default: ;
            endcase
        end
    end
endmodule