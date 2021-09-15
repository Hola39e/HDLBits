/****************************************************************************************
	
	File name    : lcd_driver.v
	LastEditors  : H
	LastEditTime : 2021-09-14 17:16:38
	Last Version : 1.0
	Description  : lcd driver, low level module
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-14 16:11:24
	FilePath     : lcd_driver.v
	Copyright 2021 H, All Rights Reserved. 
	
 ****************************************************************************************/
module lcd_driver(
    // System Clock
    input        lcd_pclk,
    input        rst_n,

    // User Interface
    input       [15:0]      lcd_id,
    input       [15:0]      pixel_data,

    output      [10:0]      pixel_xpos,
    output      [10:0]      pixel_ypos,
    output  reg [10:0]      h_disp,
    output  reg [10:0]      v_disp,
    // rgb lcd port
    output                  lcd_de,
    output                  lcd_hs,
    output                  lcd_vs,
    output  reg             lcd_bl,
    output                  lcd_clk,
    output      [15:0]      lcd_rgb,
    output  reg             lcd_rst
);

//parameter define  
// 4.3' 480*272
parameter  H_SYNC_4342   =  11'd41;     //行同步
parameter  H_BACK_4342   =  11'd2;      //行显示后沿
parameter  H_DISP_4342   =  11'd480;    //行有效数据
parameter  H_FRONT_4342  =  11'd2;      //行显示前沿
parameter  H_TOTAL_4342  =  11'd525;    //行扫描周期
   
parameter  V_SYNC_4342   =  11'd10;     //场同步
parameter  V_BACK_4342   =  11'd2;      //场显示后沿
parameter  V_DISP_4342   =  11'd272;    //场有效数据
parameter  V_FRONT_4342  =  11'd2;      //场显示前沿
parameter  V_TOTAL_4342  =  11'd286;    //场扫描周期
   
// 7' 800*480   
parameter  H_SYNC_7084   =  11'd128;    //行同步
parameter  H_BACK_7084   =  11'd88;     //行显示后沿
parameter  H_DISP_7084   =  11'd800;    //行有效数据
parameter  H_FRONT_7084  =  11'd40;     //行显示前沿
parameter  H_TOTAL_7084  =  11'd1056;   //行扫描周期
   
parameter  V_SYNC_7084   =  11'd2;      //场同步
parameter  V_BACK_7084   =  11'd33;     //场显示后沿
parameter  V_DISP_7084   =  11'd480;    //场有效数据
parameter  V_FRONT_7084  =  11'd10;     //场显示前沿
parameter  V_TOTAL_7084  =  11'd525;    //场扫描周期       
   
// 7' 1024*600   
parameter  H_SYNC_7016   =  11'd20;     //行同步
parameter  H_BACK_7016   =  11'd140;    //行显示后沿
parameter  H_DISP_7016   =  11'd1024;   //行有效数据
parameter  H_FRONT_7016  =  11'd160;    //行显示前沿
parameter  H_TOTAL_7016  =  11'd1344;   //行扫描周期
   
parameter  V_SYNC_7016   =  11'd3;      //场同步
parameter  V_BACK_7016   =  11'd20;     //场显示后沿
parameter  V_DISP_7016   =  11'd600;    //场有效数据
parameter  V_FRONT_7016  =  11'd12;     //场显示前沿
parameter  V_TOTAL_7016  =  11'd635;    //场扫描周期
   
// 10.1' 1280*800   
parameter  H_SYNC_1018   =  11'd10;     //行同步
parameter  H_BACK_1018   =  11'd80;     //行显示后沿
parameter  H_DISP_1018   =  11'd1280;   //行有效数据
parameter  H_FRONT_1018  =  11'd70;     //行显示前沿
parameter  H_TOTAL_1018  =  11'd1440;   //行扫描周期
   
parameter  V_SYNC_1018   =  11'd3;      //场同步
parameter  V_BACK_1018   =  11'd10;     //场显示后沿
parameter  V_DISP_1018   =  11'd800;    //场有效数据
parameter  V_FRONT_1018  =  11'd10;     //场显示前沿
parameter  V_TOTAL_1018  =  11'd823;    //场扫描周期

// 4.3' 800*480   
parameter  H_SYNC_4384   =  11'd128;    //行同步
parameter  H_BACK_4384   =  11'd88;     //行显示后沿
parameter  H_DISP_4384   =  11'd800;    //行有效数据
parameter  H_FRONT_4384  =  11'd40;     //行显示前沿
parameter  H_TOTAL_4384  =  11'd1056;   //行扫描周期
   
parameter  V_SYNC_4384   =  11'd2;      //场同步
parameter  V_BACK_4384   =  11'd33;     //场显示后沿
parameter  V_DISP_4384   =  11'd480;    //场有效数据
parameter  V_FRONT_4384  =  11'd10;     //场显示前沿
parameter  V_TOTAL_4384  =  11'd525;    //场扫描周期   

// reg define
reg [10:0] h_sync;
reg [10:0] h_back;
reg [10:0] h_total;
reg [10:0] v_sync;
reg [10:0] v_back;
reg [10:0] v_total;
reg [10:0] h_cnt;
reg [10:0] v_cnt;

// wire define
wire lcd_en;
wire data_req;

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/
assign lcd_hs = 1'b1;
assign lcd_vs = 1'b1;

assign lcd_clk = lcd_pclk;
assign lcd_de = lcd_en;

// 使能RGB565数据输出
assign lcd_en = ((h_cnt >= h_sync + h_back) && (h_cnt < h_sync + h_back + h_disp)
                &&(v_cnt >= v_sync + v_back) && (v_cnt < v_sync + v_back + v_disp))
                ? 1'b1 : 1'b0;

// 请求像素点颜色数据输入
assign data_req = ((h_cnt >= h_sync + h_back - 1'b1) && (h_cnt < h_sync + h_back + h_disp - 1'b1)
                &&(v_cnt >= v_sync + v_back) && (v_cnt < v_sync + v_back + v_disp))
                ? 1'b1 : 1'b0;

// 像素点坐标
assign pixel_xpos = data_req ? (h_cnt - (h_sync + h_back - 1'b1)) : 11'b0;
assign pixel_ypos = data_req ? (v_cnt - (v_sync + v_back - 1'b1)) : 11'b0;

// RGB565数据输出
assign lcd_rgb = lcd_en ? pixel_data : 16'b0;

always @(posedge lcd_pclk) begin
    case(lcd_id)
        16'h4342 : begin
            h_sync  <= H_SYNC_4342; 
            h_back  <= H_BACK_4342; 
            h_disp  <= H_DISP_4342; 
            h_total <= H_TOTAL_4342;
            v_sync  <= V_SYNC_4342; 
            v_back  <= V_BACK_4342; 
            v_disp  <= V_DISP_4342; 
            v_total <= V_TOTAL_4342;            
        end
        16'h7084 : begin
            h_sync  <= H_SYNC_7084; 
            h_back  <= H_BACK_7084; 
            h_disp  <= H_DISP_7084; 
            h_total <= H_TOTAL_7084;
            v_sync  <= V_SYNC_7084; 
            v_back  <= V_BACK_7084; 
            v_disp  <= V_DISP_7084; 
            v_total <= V_TOTAL_7084;        
        end
        16'h7016 : begin
            h_sync  <= H_SYNC_7016; 
            h_back  <= H_BACK_7016; 
            h_disp  <= H_DISP_7016; 
            h_total <= H_TOTAL_7016;
            v_sync  <= V_SYNC_7016; 
            v_back  <= V_BACK_7016; 
            v_disp  <= V_DISP_7016; 
            v_total <= V_TOTAL_7016;            
        end
        16'h4384 : begin
            h_sync  <= H_SYNC_4384; 
            h_back  <= H_BACK_4384; 
            h_disp  <= H_DISP_4384; 
            h_total <= H_TOTAL_4384;
            v_sync  <= V_SYNC_4384; 
            v_back  <= V_BACK_4384; 
            v_disp  <= V_DISP_4384; 
            v_total <= V_TOTAL_4384;             
        end        
        16'h1018 : begin
            h_sync  <= H_SYNC_1018; 
            h_back  <= H_BACK_1018; 
            h_disp  <= H_DISP_1018; 
            h_total <= H_TOTAL_1018;
            v_sync  <= V_SYNC_1018; 
            v_back  <= V_BACK_1018; 
            v_disp  <= V_DISP_1018; 
            v_total <= V_TOTAL_1018;        
        end
        default : begin
            h_sync  <= H_SYNC_4342; 
            h_back  <= H_BACK_4342; 
            h_disp  <= H_DISP_4342; 
            h_total <= H_TOTAL_4342;
            v_sync  <= V_SYNC_4342; 
            v_back  <= V_BACK_4342; 
            v_disp  <= V_DISP_4342; 
            v_total <= V_TOTAL_4342;          
        end
    endcase
end

// 行计数器对像素时钟计数
always @(posedge lcd_clk or negedge rst_n ) begin
    if(!rst_n)begin
        h_cnt <= 11'b0;
    end
    else if (h_cnt == h_total - 1'b1) begin
        h_cnt <= 11'b0;
    end
    else
        h_cnt <= h_cnt + 1'b1;
end

// 场计数器对行计数
always @(posedge lcd_clk or negedge rst_n ) begin
    if(!rst_n)begin
        v_cnt <= 11'b0;
    end
    else begin
        if (h_cnt == h_total - 1'b1) begin
            if (v_cnt == v_total - 1'b1) begin
            v_cnt <= 11'b0;
            end
            else
            v_cnt <= v_cnt + 1'b1;
        end
    end
end
always @(posedge lcd_clk or negedge rst_n ) begin
    if(!rst_n)begin
        lcd_rst <= 1'b0;
        lcd_bl <= 1'b0;
    end
    else begin
        lcd_rst <= 1'b1;
        lcd_bl <= 1'b1;
    end
end
endmodule