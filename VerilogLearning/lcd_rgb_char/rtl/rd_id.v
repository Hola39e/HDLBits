/*******************************************************************************

    @Author: H 
    @Associated Filename: rd_id.v
    @Purpose: read lcd screen id and type, (low level module)
    @Device: All 
    @Version: 1.0
    @Date: 2021/09/14 15:53:20

*******************************************************************************/

module rd_id(
    // System Clock
    input        clk,
    input        rst_n,

    // User Interface
    input       [15:0]      lcd_rgb,
    output reg  [15:0]      lcd_id
);
    // reg define
    reg     rd_flag;
    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    
    // read LCD id, M2: B4 M1: G5 M0: R4
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)begin
            rd_flag <= 1'b0;
            lcd_id <= 16'b0;
        end
        else begin
            if (!rd_flag) begin
                rd_flag <= 1'b1;
                case ({lcd_rgb[4],lcd_rgb[10],lcd_rgb[15]})
                    3'b000: lcd_id <= 16'h4342;
                    3'b001: lcd_id <= 16'h7084;
                    3'b010: lcd_id <= 16'h7016;
                    3'b100: lcd_id <= 16'h4384;
                    3'b101: lcd_id <= 16'h1018;
                    default: lcd_id <= 16'b0;
                endcase 
            end
        end
    end
endmodule