module ram_rw (
    input clk,
    input rst_n,

    output ram_wr_en,
    output ram_rd_en,
    output reg [4:0] ram_addr,
    output reg [7:0] ram_wr_data,

    input [7:0] ram_rd_data
);
    // reg define 
    reg [5:0] rw_cnt; // read and write control counter
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    assign ram_wr_en = (rw_cnt<=6'd31)&&(rw_cnt>=6'd0)?1'b1:1'b0;
    assign ram_rd_en = (rw_cnt<=6'd63)&&(rw_cnt>=6'd32)?1'b1:1'b0;

    // create a counter to 0~63
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            rw_cnt <= 6'b0;
        end
        else if (rw_cnt == 6'd63) begin
            rw_cnt <= 6'd0;
        end
        else begin
            rw_cnt <= rw_cnt + 1'b1;
        end
    end

    // create data signal to write
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            ram_wr_data <= 8'b0;
        end
        else if ((rw_cnt<=6'd31)&&(rw_cnt>=6'd0)) begin
            ram_wr_data <= ram_wr_data + 1'b1;
        end
        else begin
            ram_wr_data <= 8'b0;
        end
    end

    // read addr create
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            ram_addr <= 5'b0;
        end
        else if (ram_addr == 5'd31) begin
            ram_addr <= 5'b0;
        end
        else begin
            ram_addr <= ram_addr + 1'b1;
        end
    end
endmodule