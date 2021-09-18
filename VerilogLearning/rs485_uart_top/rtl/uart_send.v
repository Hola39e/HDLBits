/*******************************************************************************

    @Author: H 
    @Associated Filename: uart_send
    @Purpose: low-level of uart
    @Device: All 
    @Version: 1.0
    @Date: 2021/09/12 20:17:10

*******************************************************************************/
module uart_send(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    input   [7:0]       uart_din,
    input               uart_en,

    output    reg       uart_txd,
    output    reg       tx_flag
);

    // parameter define
    parameter CLK_FREQ = 50_000_000;
    parameter UART_BPS = 115200;
    // BPS_CNT is send 1 bit need how many time cycles
    localparam BPS_CNT = CLK_FREQ/UART_BPS;
    
    // reg define
    reg                 uart_en_d0;
    reg                 uart_en_d1;
    reg         [15:0]  clk_cnt;
    reg         [3:0]   tx_cnt;
    reg         [7:0]   tx_data;

    // wire define
    wire                en_flag;
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    // posedge check
    assign en_flag = (!uart_en_d1)&uart_en_d0;
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            uart_en_d0 <= 1'b0;
            uart_en_d1 <= 1'b0;
        end
        else begin
            uart_en_d0 <= uart_en;
            uart_en_d1 <= uart_en_d0;
        end
    end
    // when en_flag is 1, start send
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            tx_flag <= 1'b0;
            tx_data <= 8'b0;
        end
        else if (en_flag) begin   // when receive en_flag
                tx_flag <= 1'b1;
                tx_data <= uart_din;
            end
            // when receive 10bit data and stop at the mid time of receiving stop bit
            //  (rx_cnt == 4'd9) 是目前接收到了9bit数据 第9位就是停止位 BPS_CNT/2 是接收完成后的中间时刻
            //  把 tx_flag 拉低
        else if ((tx_cnt == 4'd9)&&(clk_cnt == BPS_CNT/2)) begin
            tx_flag <= 1'b0;
            tx_data <= 8'b0;
        end
        else begin
            tx_flag <= tx_flag;
            tx_data <= tx_data;
        end
    end

    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            clk_cnt <= 16'b0;
            tx_cnt <= 4'b0;
        end
        else if (tx_flag) begin
            // here need to count, wait BPS_CNT clk cycles to rx_cnt+1
            if (clk_cnt < BPS_CNT -1'b1) begin
                tx_cnt <= tx_cnt;
                clk_cnt <= clk_cnt + 1'b1;
            end
            else begin
                tx_cnt <= tx_cnt + 1'b1;
                clk_cnt <= 16'b0;
            end
        end
        else begin
            clk_cnt <= 16'b0;
            tx_cnt <= 4'b0;
        end
    end
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            uart_txd <= 1'b1;
        end
        else if (tx_flag) begin
            case (tx_cnt)
                4'd0: uart_txd <= 1'b0;     // start bit
                4'd1: uart_txd <= tx_data[0];
                4'd2: uart_txd <= tx_data[1];
                4'd3: uart_txd <= tx_data[2];
                4'd4: uart_txd <= tx_data[3];
                4'd5: uart_txd <= tx_data[4];
                4'd6: uart_txd <= tx_data[5];
                4'd7: uart_txd <= tx_data[6];
                4'd8: uart_txd <= tx_data[7];
                4'd9: uart_txd <= 1'b1;     // stop bit
                default: ;
            endcase 
        end
        else begin
            uart_txd <= 1'b1;   // when is IDLE, keep high port
        end
    end
endmodule