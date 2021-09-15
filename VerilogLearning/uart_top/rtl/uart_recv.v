/*******************************************************************************

    @Author: H 
    @Associated Filename: uart_recv.v
    @Purpose: low-level of uart
    @Device: All 
    @Version: 1.0
    @Date: 2021/09/12 18:41:32

*******************************************************************************/
module uart_recv(
    // System Clock
    input        sys_clk,
    input        sys_rst_n,

    // User Interface
    input               uart_rxd,
    output  reg [7:0]   uart_data,
    output  reg         uart_done
);
    // parameter define
    parameter CLK_FREQ = 50_000_000;
    parameter UART_BPS = 115200;
    // BPS_CNT is send 1 bit need how many time cycles
    localparam BPS_CNT = CLK_FREQ/UART_BPS;
    // reg define
    reg                 uart_rxd_d0;
    reg                 uart_rxd_d1;
    reg         [15:0]  clk_cnt;
    reg         [3:0]   rx_cnt;
    reg                 rx_flag;
    reg         [7:0]   rxdata;

    // wire define
    wire                start_flag;
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    // negedge check
    // because start bit is 0
    assign start_flag = (!uart_rxd_d0)&uart_rxd_d1;
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            uart_rxd_d0 <= 1'b0;
            uart_rxd_d1 <= 1'b0;
        end
        else begin
            uart_rxd_d0 <= uart_rxd;
            uart_rxd_d1 <= uart_rxd_d0;
        end
    end
    // when start_flag is 1, start receive
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            rx_flag <= 1'b0;
        end
        else if (start_flag) begin   // when receive start_flag
                rx_flag <= 1'b1;
            end
            // when receive 10bit data and stop at the mid time of receiving stop bit
            //  (rx_cnt == 4'd9) 是目前接收到了9bit数据 第9位就是停止位 BPS_CNT/2 是接收完成后的中间时刻
            //  把 rx_flag 拉低
            else if ((rx_cnt == 4'd9)&&(clk_cnt == BPS_CNT/2)) begin
                rx_flag <= 1'b0;
            end
            else 
                rx_flag <= rx_flag;
    end

    // when get in receiving process, start sys clk counter(clk_cnt) and recv data counter(rx_cnt)
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            clk_cnt <= 16'b0;
            rx_cnt <= 4'b0;
        end
        else if (rx_flag) begin
            // here need to count, wait BPS_CNT clk cycles to rx_cnt+1
            if (clk_cnt < BPS_CNT -1'b1) begin
                rx_cnt <= rx_cnt;
                clk_cnt <= clk_cnt + 1'b1;
            end
            else begin
                rx_cnt <= rx_cnt + 1'b1;
                clk_cnt <= 16'b0;
            end
        end
        else begin
            clk_cnt <= 16'b0;
            rx_cnt <= 4'b0;
        end
    end

    // according to the rx_cnt to regist the data from port
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            rxdata <= 8'b0;
        end
        else if (rx_flag) begin
            if (clk_cnt == BPS_CNT/2) begin         // this time is stable to acquisition data 
                case (rx_cnt)
                    4'd1:rxdata[0] <= uart_rxd_d1; 
                    4'd2:rxdata[1] <= uart_rxd_d1; 
                    4'd3:rxdata[2] <= uart_rxd_d1; 
                    4'd4:rxdata[3] <= uart_rxd_d1; 
                    4'd5:rxdata[4] <= uart_rxd_d1; 
                    4'd6:rxdata[5] <= uart_rxd_d1; 
                    4'd7:rxdata[6] <= uart_rxd_d1; 
                    4'd8:rxdata[7] <= uart_rxd_d1; 
                    default: ;
                endcase
            end
            else 
                rxdata <= rxdata;
        end
        else begin
            rxdata <= 8'b0;
        end
    end
    // when receiving done, output receive complete flag and output the receiving data
    always @(posedge sys_clk or negedge sys_rst_n ) begin
        if(!sys_rst_n)begin
            uart_data <= 8'b0;
            uart_done <= 1'b0;
        end
        else if (rx_cnt == 4'd9) begin
                uart_data <= rxdata;
                uart_done <= 1'b1;
        end
        else begin
            uart_data <= 8'b0;
            uart_done <= 1'b0;
        end
    end
endmodule