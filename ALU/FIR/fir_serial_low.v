/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-22
>> Filename    : fir_serial_low.v
>> Modulename  : fir_serial_low
>> Description : 
>> Version  : 1.0
************************************************************/

// the serial fir implemention only excute one multiply once time in 1 clk
// so the clk speed need to be 8 times of fs
`define SAFE_DESIGN
module fir_serial_low(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input       en,
    input   [11:0]  xin,
    output      valid,
    output  [28:0]  yout
);

    // delay of input data enable
    reg [11:0]  en_r;
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            en_r <= 12'b0;
        end
        else begin
            en_r <= {en_r[10:0], en};
        end
    end

    wire        [11:0]   coe[7:0] ;
    assign coe[0]        = 12'd11 ;
    assign coe[1]        = 12'd31 ;
    assign coe[2]        = 12'd63 ;
    assign coe[3]        = 12'd104 ;
    assign coe[4]        = 12'd152 ;
    assign coe[5]        = 12'd198 ;
    assign coe[6]        = 12'd235 ;
    assign coe[7]        = 12'd255 ;

    reg [2:0]   cnt;
    integer i;
    reg [11:0] xin_reg [15:0];

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            cnt <= 3'b0;
        end
        else if(en || cnt != 'b0) begin
            cnt <= cnt + 1'b1;
        end
    end
    
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            for (i = 0; i <= 15; i = i + 1) begin
                xin_reg[i] <= 12'b0;
            end
        end
        else if (cnt == 3'b0 && en) begin
            xin_reg[0] <= xin;
            for (i = 1; i <= 15; i = i + 1) begin
                xin_reg[i] = xin_reg[i - 1];
            end
        end
    end

    reg [11:0] add_a, add_b;
    reg [11:0] coe_s;
    wire [12:0] add_s;
    wire [2:0] xin_index;

    assign xin_index = (cnt >= 1) ? (cnt - 1) : 3'd7;

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            add_a <= 12'b0;
            add_b <= 12'b0;
            coe_s <= 12'b0;
        end
        else if (en_r[xin_index]) begin
            add_a <= xin_reg[xin_index];
            add_b <= xin_reg[15-xin_index];
            coe_s <= coe[xin_index];
        end
    end

    assign add_s = add_a + add_b;

    reg [24:0] mout;

`ifdef SAFE_DESIGN
    wire en_mult;
    wire [3:0] index_mult;

    assign index_mult = (cnt >= 2) ? (cnt - 1) : 4'd7 + cnt[0];

    mult_man    #(.N(13), .M(12)) 
    u_mult_single
    (
        .clk(clk),
        .rst_n(rst_n),
        .data_rdy(en_r[index_mult]),
        .mult1(add_s),
        .mult2(coe_s),
        .res_rdy(en_mult),
        .res(mout)
    );

`else
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            mout <= 25'b0;
        end
        else if (| en_r[8:1]) begin // ? what the meaning?
            mout <= coe_s * add_s;
        end
    end

    wire en_mult;
    assign en_mult = en_r[2];
`endif 

    reg [28:0] sum;
    reg         valid_r;
    reg [4:0]   cnt_acc_r;
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            cnt_acc_r <= 'b0;
        end
        else if (cnt_acc_r == 5'd7) begin
            cnt_acc_r <= 'b0;
        end
        else if (en_mult || cnt_acc_r != 0) begin
            cnt_acc_r <= cnt_acc_r + 1'b1;
        end
        else begin
            cnt_acc_r <= cnt_acc_r;
        end
    end

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            sum <= 'b0;
        end
        else if (cnt_acc_r == 5'd7) begin
            sum <= sum + mout;
            valid_r <= 1'b1;
        end
        else if (en_mult && (cnt_acc_r == 0)) begin // inital, the first time cal sum
            sum <= mout;
            valid_r <= 1'b0;
        end
        else if (cnt_acc_r != 0)begin
            sum <= sum + mout;
            valid_r <= 1'b0;
        end
    end

    reg [28:0]  yout_r;
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            yout_r <= 'b0;
        end
        else if (valid_r) begin
            yout_r <= sum;
        end
    end

    assign yout = yout_r;

    reg [4:0] cnt_valid;
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            cnt_valid <= 'b0;
        end
        else if (valid_r && cnt_valid != 5'd16) begin
            cnt_valid <= cnt_valid + 1'b1;
        end
    end

    assign valid = (cnt_valid == 5'd16) && valid_r;
endmodule