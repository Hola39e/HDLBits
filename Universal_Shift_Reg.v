/*

	File name    : Universal_Shift_Reg
	LastEditors  : H
	LastEditTime : 2021-10-26 17:23:15
	Last Version : 1.0
	Description  : Contains Parallel Shift, Msb and lsb shift
                    output also can be Serial or Parallel
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-26 17:21:11
	FilePath     : \Verilog_HDL\Universal_Shift_Reg.v
	Copyright 2021 H, All Rights Reserved. 

*/

module Universal_Shift_Reg 
#(parameter word_size = 8) 
(
    output  reg [word_size - 1 : 0] Data_out,
    output                          MSB_out,LSB_out,
    input       [word_size - 1 : 0] Data_in,
    input                           MSB_in,LSB_in,
    input                           s1,s0,clk,rst  
);
    assign MSB_out = Data_out[word_size - 1];
    assign LSB_out = Data_out[0];
    always @(posedge clk) begin
        if (rst) begin
            Data_out <= 0;
        end
        else case ({s1, s0})
            0 : Data_out <= Data_out;
            1 : Data_out <= {MSB_in, Data_out[word_size - 1 : 1]};
            2 : Data_out <= {Data_out[word_size - 2 : 0], LSB_in};
            3 : Data_out <= Data_in; 
        endcase
    end
endmodule

