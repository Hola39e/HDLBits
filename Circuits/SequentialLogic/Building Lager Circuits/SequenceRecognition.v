module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    parameter s0 = 0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6,s7=7,s8=8;
    reg [8:0] state,next_state;
    always @(*) begin
        case(state)
        s0:next_state = in?s0:s1;
        s1:next_state = in?s2:s1;
        s2:next_state = in?s3:s1;
        s3:next_state = in?s4:s1;
        s4:next_state = in?s5:s1;
        s5:next_state = in?s6:s1;
        s6:next_state = in?s7:s1; //0111110 
        s7:next_state = in?s8:s1; //01111110
        s8:next_state = in?s8:s1;
        endcase
    end
    always @(posedge clk ) begin
        if(reset)begin
            state <= s1;
        end else begin
            state <= next_state;
        end
    end
    always @(posedge clk ) begin
        if(reset)begin
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            err <= (next_state == s8)||((state==s7)&in);
            disc <= (state == s6)&&~in;
            flag <= (state == s7)&&~in;
        end
    end
endmodule
