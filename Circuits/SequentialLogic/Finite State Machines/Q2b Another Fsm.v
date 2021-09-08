module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
    parameter s0 = 9'd1,s1=9'd2,s2=9'd4,s3=9'd8,s4=9'd16,s5=9'd32,s6=9'd64,s7=9'd128,s8=9'd256;
    reg [8:0] state,next_state;

    always @(*) begin
        // 注意这里状态机转换 检测101序列的时候 FSM图要画对 s3 s4 易出错
        case(state)
        s0:next_state = s1;
        s1:next_state = s2;
        s2:next_state = x?s3:s2;
        s3:next_state = x?s3:s4;
        s4:next_state = x?s5:s2;
        s5:next_state = y?s6:s7;
        s7:next_state = y?s6:s8;
        endcase
    end
    always @(posedge clk ) begin
        if(~resetn)begin
            state <= s0;
        end
        else begin
            state <= next_state;
        end
    end
    always @(posedge clk ) begin
        if (~resetn) begin
            f <= 1'b0;
            g <= 1'b0;
        end
        else begin
            f <= (next_state == s1);
            //g <= (state == s3);
            g <= (next_state == s5)||(next_state == s6)||(next_state == s7);
        end
    end
endmodule
