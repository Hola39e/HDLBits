/*******************************************************************************
@Author: H 
@Associated Filename: fifo_wr
@Purpose: low level module of fifo write
@Device: All 
@Version: 
@Date: 2021/09/12 14:47:41

*******************************************************************************/
module fifo_wr (
    // module clock
    input               clk,
    input               rst_n,

    // user interface
    input               wrempty,
    input               wrfull,
    output  reg [7:0]   data,
    output              wrreq
);
    //reg define
    reg     wrreq_t;
    reg [1:0] flow_cnt;
    //parameter IDLE = 2'b0;
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    assign wrreq = wrreq_t & ~wrfull;

    // write data to fifo
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            data <= 8'b0;
            wrreq_t <= 1'b0;
            flow_cnt <= 2'b0;
        end
        else begin
            case (flow_cnt)
                2'd0: begin
                    if(wrempty)begin
                        flow_cnt <= flow_cnt + 1'b1;
                        wrreq_t <= 1'b1;
                    end
                    else
                        flow_cnt <= flow_cnt;
                end
                2'd1:begin
                    if (wrfull) begin
                        wrreq_t <= 1'b0;
                        flow_cnt <= 2'b0;
                        data <= 8'b0;
                    end
                    else begin
                        wrreq_t <= 1'b1;
                        data <= data + 1'b1;
                    end
                end
                default: flow_cnt <= 2'b0;
            endcase
        end
    end
endmodule