module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 
    
    reg [255:0] temp;
    wire [287:0] map = {temp[15:0],temp,temp[255:240]};
    int count;
    
    always@(posedge clk) begin
        if(load) begin
            q <= data;
        end
		else begin
            for (int i = 16; i < 272; i = i+1) begin
                if((i>=16)&&(i<=256)&&(i%16==0)) begin
                    count = map[i+1]+map[i+15]+map[i+16]+map[i+17]+map[i+31]+map[i-1]+map[i-15]+map[i-16];
                end
                else if ((i>=31)&&(i<=271)&&((i+1)%16==0)) begin
                    count = map[i-1]+map[i-15]+map[i-16]+map[i-17]+map[i-31]+map[i+1]+map[i+15]+map[i+16];
                end
                else begin
                    count = map[i+1]+map[i+15]+map[i+16]+map[i+17]+map[i-1]+map[i-15]+map[i-16]+map[i-17];
                end
                
                if(count == 2)
                    q[i-16] <= q[i-16];
                else if(count == 3)
                    q[i-16] <= 1'b1;
                else
                    q[i-16] <= 1'b0;
            end
        end
        
    end
    
    always@(negedge clk) begin
        temp <= q;
    end
endmodule