/****************************************************************************************

	File name    : flow_led
	LastEditors  : H
	LastEditTime : 2021-10-18 22:11:30
	Last Version : 1.0
	Description  : flow_led
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-09 22:24:03
	FilePath     : \undefinedf:\JavaProject\DATACODE\NewProject\Verilog\flow_led.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module flow_led(
	input sys_clk,
	input sys_clk_n,
	
	output reg [3:0] led
	);
	
	reg[23:0] counter;
	
	always @(posedge sys_clk or negedge sys_clk_n)begin
		if(!sys_clk_n)
			led <= 4'b0001;
		else if(counter == 24'd10)
			led[3:0] <= {led[2:0],led[3]};
		else
			led <= led;
	end
	always @(posedge sys_clk or negedge sys_clk_n)begin
		if(!sys_clk_n)
			counter <= 24'b0;
		else if(counter < 24'd10)
			counter <= counter + 1'b1;
		else 
			counter <= 24'b0;
	end
endmodule
