/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-21
>> Filename    : fir_guide.v
>> Modulename  : fir_guide
>> Description : Fs: 50MHz fstop: 1MHz~6MHz order: 15
>> Version  : 1.0
************************************************************/
module fir_guide(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input       en,
    input       [11:0]  xin,
    output              valid,
    output      [28:0]  yout
);

    reg [3:0] en_r;

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            en_r <= 4'b0;
        end
        else begin
            en_r <= {en_r[2:0], en};
        end
    end

    reg [11:0] xin_reg [15:0];
    integer i;  

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            for (i = 0; i <= 15; i = i + 1) begin
                xin_reg[i] <= 12'b0;
            end
        end
        else if (en) begin
            xin_reg[0] <= xin;
            for (i = 0; i < 15; i = i + 1) begin
                xin_reg[i + 1] <= xin_reg[i];
            end
        end
    end

    reg [12:0] add_reg [7:0];
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            for (i = 0; i < 8; i = i + 1) begin
                add_reg[i] <= 13'b0;
            end
        end
        else if (en_r[0]) begin
            for (i = 0; i < 8; i = i + 1) begin
                add_reg[i] <= xin_reg[i] + xin_reg[15 - i];
            end
        end
    end

    // 8 mutipliers
    wire [11:0] coef [7:0];

    assign coef[0] = 12'd11;
    assign coef[1] = 12'd31;
    assign coef[2] = 12'd63;
    assign coef[3] = 12'd104;
    assign coef[4] = 12'd152;
    assign coef[5] = 12'd198;
    assign coef[6] = 12'd235;
    assign coef[7] = 12'd255;
    
    reg [24:0] mout [7:0];

    `ifdef SAFE_DESIGN

        wire [7:0] valid_mult;
        genvar k;
        generate
            for (k = 0; k < 8; k = k + 1) begin
                mult_man #(.N(13), .M(12))
                u_mult_paral
                (
                    .clk(clk),
                    .rst_n(rst_n),
                    .data_rdy(en_r[1]),
                    .mult1(add_reg[k]),
                    .mult2(coef[k]),
                    .res_rdy(valid_mult[k]),
                    .res(mout[k])
                );
            end
        endgenerate

        wire valid_mult7 = valid_mult[7];

    `else

        always @(posedge clk or negedge rst_n ) begin
            if(!rst_n)begin
                for (i = 0; i < 8; i = i + 1) begin
                    mout[i] <= 'b0;
                end
            end
            else if (en_r[1]) begin
                for (i = 0; i < 8; i = i + 1) begin
                    mout[i] <= coef[i] * add_reg[i];
                end
            end
        end

        wire valid_mult7 = en_r[2];

    `endif 

    reg [3:0] valid_mult_r;

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            valid_mult_r <= 'b0;
        end
        else begin
            valid_mult_r <= {valid_mult_r[2:0], valid_mult7};
        end
    end

    `ifdef SAFE_DESIGN
    // coef 12bit xin 12bit add_reg 13bit * 16 so 29 bit
        reg [28:0]  sum1;
        reg [28:0]  sum2;
        reg [28:0]  y_out_t;

        always @(posedge clk or negedge rst_n ) begin
            if(!rst_n)begin
                sum1 <= 'b0;
                sum2 <= 'b0;
            end
            else if (valid_mult7) begin
                sum1 <= mout[0] + mout[1] + mout[2] + mout[3];
                sum2 <= mout[4] + mout[5] + mout[6] + mout[7];
                y_out_t <= sum1 + sum2;
            end
        end

    `else
        reg signed  [28:0]   sum;
        reg signed  [28:0]   y_out_t;
        always @(posedge clk or negedge rst_n ) begin
            if(!rst_n)begin
                sum <= 29'b0;
                y_out_t <= 29'b0;
            end
            else if (valid_mult7) begin
                sum <= mout[0] + mout[1] + mout[2] + mout[3] + mout[4] + mout[5] + mout[6] + mout[7];
                y_out_t <= sum;
            end
        end
    `endif 

    assign yout = y_out_t;
    assign valid = valid_mult_r[0];

endmodule