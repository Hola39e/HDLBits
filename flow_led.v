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
