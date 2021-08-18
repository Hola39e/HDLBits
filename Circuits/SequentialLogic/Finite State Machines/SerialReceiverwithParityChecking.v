module top_module(  
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); 
    parameter  s0=11'd1,s1=11'd2,s2=11'd4,s3=11'd8,t1=11'd16,t2=11'd32,t3=11'd64,t4=11'd128,t5=11'd256,t6=11'd512,t7=11'd1024;
    parameter s4 = 12'd2048;
    reg [11:0] state,next_state;
    reg parityOfByte;
    genvar x ;
    wire ena;
    always @(*) begin
        case(state)
        s0:next_state = in ? s0 : s1;
        s1:next_state = t1;
        t1:next_state = t2;
        t2:next_state = t3;
        t3:next_state = t4;
        t4:next_state = t5;
        t5:next_state = t6;
        t6:next_state = t7;
        t7:next_state = s4;
        s4:next_state = s2;//这里应该是第九位 即奇偶校验位 与parity计算出的相等便跳至s2
        s2:next_state = in?s0:s3;
        s3:next_state = in?s0:s3;
        endcase
    end
    assign ena = (reset==1'b1)|(state==s0);
        parity u_parity(clk,ena,in,parityOfByte);
always @(posedge clk ) begin
    if(reset)begin
        state <= s0;
    end
    else begin
        state <= next_state;
    end
end
always @(posedge clk ) begin
    if (reset) begin
        done <= 1'b0;
        out_byte <= 8'b0;
    end
    else begin
        done <= (state == s2)&in&parityOfByte;
        if (state==s0) begin
            out_byte <= 8'b0;
        end
        case (state)
            s1: out_byte[0] <= in; 
            t1: out_byte[1] <= in; 
            t2: out_byte[2] <= in; 
            t3: out_byte[3] <= in; 
            t4: out_byte[4] <= in; 
            t5: out_byte[5] <= in; 
            t6: out_byte[6] <= in; 
            t7: out_byte[7] <= in; 
            //s4: re_parityOfByte <= in;
            //default: out_byte <= 8'b0;
        endcase
    end
end
endmodule


