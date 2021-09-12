/*******************************************************************************
@Author: H 
@Associated Filename: fifo_rd.v
@Purpose: low level module of fifo read
@Device: All 
@Version: 
@Date: 2021/09/12 15:01:39

*******************************************************************************/
module fifo_rd(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input       [7:0] data,
    input             rdfull,
    input             rdempty,
    output            rdreq
);

    // reg define
    reg rdreq_t;
    reg [7:0] data_fifo;
    reg [1:0] flow_cnt;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    assign rdreq = rdreq_t & !rdempty;

    // read data from fifo
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            rdreq_t <= 1'b0;
            flow_cnt <= 2'b0;
            data_fifo <= 8'b0;
        end
        else begin
            case (flow_cnt)
                2'd0: begin
                    if (rdfull) begin
                        flow_cnt <= flow_cnt + 1'b1;
                        rdreq_t <= 1'b1;
                    end
                    else
                        flow_cnt <= flow_cnt;
                end
                2'd1:begin
                    if (rdempty) begin
                        rdreq_t <= 1'b0;
                        data_fifo <= 8'b0;
                        flow_cnt <= 2'b0;
                    end
                    else begin
                        rdreq_t <= 1'b1;
                        data_fifo <= data;
                    end
                end
                default: flow_cnt <= 2'b0;
            endcase
        end
    end

endmodule
