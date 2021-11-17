/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-16
>> Filename    : mult.v
>> Modulename  : mult
>> Description : 
>> Version  : 1.0
************************************************************/

module mult
#(
    parameter N = 4,
    parameter M = 4
)
(
    input   clk,
    input   rst_n,
    input   data_rdy,
    input  [N-1:0] mult1,
    input  [M-1:0] mult2,

    output      res_rdy,
    output  [N+M-1:0]   result
);
    // calculate counter
    reg [31:0]  cnt;

    wire [31:0]     cnt_temp = (cnt == M) ? 32'b0 : cnt + 1'b1;

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            cnt <= 32'b0;
        end
        else if (data_rdy) begin
            cnt <= cnt_temp;
        end
        // input enable only keep a while and the result still not be
        // computed, so keep cnt counting
        else if (cnt != 0 ) begin  //防止輸入使能端持續時間過短
            cnt    <= cnt_temp ;
        end
        else begin
            cnt <= 32'b0;
        end
    end

    //multiply
    reg [M+N-1:0]   mult1_shift;
    reg [M-1:0]     mult2_shift;
    reg [M+N-1:0]   mult_acc;

    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            mult1_shift <= 'b0;
            mult2_shift <= 'b0;
            mult_acc <= 'b0;
        end
        else if (data_rdy && cnt == 'b0) begin
            mult1_shift <= {{M{1'b0}}, mult1} << 1;
            mult2_shift <= mult2 >> 1;
            mult_acc <= mult2[0] ? {{M{1'b0}}, mult1} : 'b0;
        end
        else if (cnt != M) begin
            mult1_shift <= mult1_shift << 1;
            mult2_shift <= mult2_shift >> 1;
            mult_acc    <= mult2_shift[0] ? mult_acc + mult1_shift : mult_acc;
        end
        else begin
            mult1_shift <= 'b0;
            mult2_shift <= 'b0;
        end
    end

    wire checkpoint;
    assign checkpoint = data_rdy && cnt;

        // result
    reg [M+N-1:0] res_r;
    reg            res_rdy_r;
    always @(posedge clk or negedge rst_n ) begin
            if(!rst_n)begin
                res_r <= 'b0;
                res_rdy_r <= 'b0;
            end
            else if (cnt == M) begin
                res_r <= mult_acc;
                res_rdy_r <= 1'b1;
            end
            else begin
                res_r <= 'b0;
                res_rdy_r <= 'b0;
            end
        end
    
    assign res_rdy = res_rdy_r;
    assign result = res_r;


endmodule