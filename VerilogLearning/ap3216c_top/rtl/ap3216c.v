/****************************************************************************************

	File name    : ap3216c.v
	LastEditors  : H
	LastEditTime : 2021-09-22 14:39:13
	Last Version : 1.0
	Description  : submodule
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-22 14:39:08
	FilePath     : \rtl\ap3216c.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module ap3216c(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    // i2c interface
    output  reg     i2c_rh_wl,      // read and write control signal
    output  reg     i2c_exec,
    output  reg [15:0]  i2c_addr,   // the slave device id address
    output  reg [7:0]   i2c_data_w,
    input       [7:0]   i2c_data_r,
    input               i2c_done,

    output  reg [15:0]  als_data,
    output  reg [9:0]   ps_data
);

    // parameter define
    parameter TIME_PS = 14'd12_500;     // PS 转换时间为12.5ms
    parameter TIME_ALS = 17'd100_000;   // ALS 转换时间为100ms clk = 1MHZ
    parameter TIME_REST = 8'd2;         // 停止后重新开始的时间间隔控制

    // reg define
    reg     [3:0]   flow_cnt;
    reg     [18:0]   wait_cnt;
    reg     [15:0]   als_data_t;
    
    reg             als_done;
    reg     [9:0]   ps_data_t;      // ps的临时数据
    reg             ir_of;          // 溢出标志 判断ps_data是否有效
    reg             obj;            // 物体状态标志

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    
    // 配置ap3216c并读取数据
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            i2c_exec   <=  1'b0;
            i2c_addr   <=  8'd0;
            i2c_rh_wl  <=  1'b0;
            i2c_data_w <=  8'h0;
            flow_cnt   <=  4'd0;
            wait_cnt   <= 18'd0;
            ps_data    <= 10'd0;
            ps_data_t  <= 10'd0;
            ir_of      <=  1'b0;
            obj        <=  1'b0;
            als_done   <=  1'b0;
            als_data_t <= 16'd0;
        end
        else begin
            i2c_exec <= 1'b0;
            case (flow_cnt)
                //初始化AP3216C
            4'd0: begin
                if(wait_cnt == 18'd100) begin
                    wait_cnt <= 18'd0;
                    flow_cnt <= flow_cnt + 1'b1;
                end
                else
                    wait_cnt <= wait_cnt +1'b1;
            end
            4'd1: begin
                i2c_exec   <= 1'b1 ;
                i2c_rh_wl  <= 1'b0 ;
                i2c_addr   <= 8'h00;               // 配置系统寄存器
                i2c_data_w <= 8'h03;               // 激活ALS+PS+IR 功能
                flow_cnt   <= flow_cnt + 1'b1;
            end
            //配置完成
            4'd2: begin
                if(i2c_done)
                    flow_cnt <= flow_cnt + 1'b1;
            end
            //等待PS转换完成（12.5ms）
            4'd3: begin
                if(wait_cnt  == TIME_PS) begin
                    wait_cnt <= 18'd0;
                    flow_cnt <= flow_cnt + 1'd1;
                end
                else
                    wait_cnt <= wait_cnt + 1'b1;
            end
            //预读PS Data Register(0x0E）
            4'd4: begin
                i2c_exec <= 1'b1;
                i2c_rh_wl<= 1'b1;
                i2c_addr <= 8'h0E;
                flow_cnt <= flow_cnt + 1'b1;
            end
            //读PS Data Register(0x0E）
            4'd5: begin
                if(i2c_done) begin
                    flow_cnt     <= flow_cnt + 1'b1;
                    ps_data_t[3:0] <= i2c_data_r[3:0];
                    ir_of        <= i2c_data_r[6]  ;
                    obj          <= i2c_data_r[7]  ;
                end
            end
            //等待一段时间以进行下一次读写
            4'd6: begin
                if(wait_cnt == TIME_REST) begin//TIME_REST
                    wait_cnt <= 18'd0;
                    flow_cnt <= flow_cnt + 1'b1;
                end
                else
                    wait_cnt <= wait_cnt +1'b1;
            end
            //预读PS Data Register(0x0F）
            4'd7: begin
                i2c_exec <= 1'b1;
                i2c_rh_wl<= 1'b1;
                i2c_addr <= 8'h0F;
                flow_cnt <= flow_cnt + 1'b1;
            end
            //读PS Data Register(0x0F）
            4'd8: begin
                if(i2c_done) begin
                    flow_cnt     <= flow_cnt + 1'b1;
                    ps_data_t[9:4] <= i2c_data_r[5:0];
                    ir_of        <= i2c_data_r[6]  ;
                    obj          <= i2c_data_r[7]  ;
                end
            end
            //等待ALS转换完成（100ms）
            4'd9: begin
                if(wait_cnt  ==  TIME_ALS) begin
                    wait_cnt <= 18'd0;
                    flow_cnt <= flow_cnt + 1'd1;
                    ps_data  <= ps_data_t;
                end
                else
                    wait_cnt <= wait_cnt + 1'b1;
            end
            //预读ALS Data Register(0x0C）
            4'd10: begin
                i2c_exec <= 1'b1;
                i2c_rh_wl<= 1'b1;
                i2c_addr <= 8'h0C;
                flow_cnt <= flow_cnt + 1'b1;
            end
            //读ALS Data Register(0x0C）
            4'd11: begin
                if(i2c_done) begin
                    als_done        <= 1'b0;
                    als_data_t[7:0] <= i2c_data_r;
                    flow_cnt        <= flow_cnt + 1'b1;
                end
            end
            //等待一段时间以进行下一次读写
            4'd12: begin
                if(wait_cnt == TIME_REST) begin
                    wait_cnt <= 18'd0;
                    flow_cnt <= flow_cnt + 1'b1;
                end
                else
                    wait_cnt <= wait_cnt +1'b1;
            end
            //预读ALS Data Register(0x0D）
            4'd13: begin
                i2c_exec <= 1'b1;
                i2c_rh_wl<= 1'b1;
                i2c_addr <= 8'h0D;
                flow_cnt <= flow_cnt + 1'b1;
            end
            //读ALS Data Register(0x0D）
            4'd14: begin
                if(i2c_done) begin
                    als_done         <= 1'b1;
                    als_data_t[15:8] <= i2c_data_r;
                    flow_cnt         <= 4'd3;             //跳转到状态3重新读取数据
                end
            end
        endcase
    end
end

//当采集的环境光转换成光照强度(单位:lux)
always @ (*) begin
    if(als_done)
	 als_data = als_data_t * 6'd35 / 7'd100;
end
endmodule