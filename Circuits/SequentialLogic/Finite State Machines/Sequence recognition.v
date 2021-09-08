module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    parameter s0 = 0,s1=1,s2=2,s3=3;
    reg [3:0] state,next_state;
    parameter x0 = 3'b000,x1 = 3'b001,x2 = 3'b011,x3 = 3'b111;
    always @(*) begin
        next_state = 4'b0000;
        case(1'b1)
            state[s0]:begin
                next_state[s0] = (s==x0)?1:0;
                next_state[s1] = (s==x1)?1:0;
                next_state[s2] = (s==x2)?1:0;
                next_state[s3] = (s==x3)?1:0;
                //dfr = (s==x0)?1'b1:1'b0; 
                fr3 = 1;fr2 = 1;fr1=1;
            end
            state[s1]:begin
                next_state[s0] = (s==x0)?1:0;
                next_state[s1] = (s==x1)?1:0;
                next_state[s2] = (s==x2)?1:0;
                next_state[s3] = (s==x3)?1:0;
                //dfr = (s==x0|s==x1)?1'b1:1'b0; 
                fr3 = 0;fr2 = 1;fr1=1;
            end
            state[s2]:begin
                next_state[s0] = (s==x0)?1:0;
                next_state[s1] = (s==x1)?1:0;
                next_state[s2] = (s==x2)?1:0;
                next_state[s3] = (s==x3)?1:0;
                //dfr = (s==x0|s==x1|s==x2)?1'b1:1'b0; 
                fr3 = 0;fr2 = 0;fr1=1;
            end
            state[s3]:begin
                next_state[s0] = (s==x0)?1:0;
                next_state[s1] = (s==x1)?1:0;
                next_state[s2] = (s==x2)?1:0;
                next_state[s3] = (s==x3)?1:0;
                //dfr = (s==x0|s==x1|s==x2)?1'b1:1'b0;
                fr3 = 0;fr2 = 0;fr1=0;
            end
            default:begin
                next_state[s0] = (s==x0)?1:0;
                next_state[s1] = (s==x1)?1:0;
                next_state[s2] = (s==x2)?1:0;
                next_state[s3] = (s==x3)?1:0;
                //dfr = 0;
                fr3 = 1;fr2 = 1;fr1=1;
            end
        endcase
    end
    always @(posedge clk ) begin
        if(reset)begin
            state <= 4'b0001;
            //next_state <= 4'b0001;
            //dfr <= 1'b1;
        end
        else begin
            state <= next_state;
            //dfr <= ((next_state<state)|((next_state==state)&~next_state[3]))?1:0;
        end
    end
    //assign dfr = ((next_state<state)|((next_state==state)&~next_state[3])|state==4'b0000)?1:0;
    always @(*) begin
        case(state)
        4'd1:dfr = 1;
        4'd2:dfr = (next_state<=state)?1:0;
        4'd4:dfr = (next_state<=state)?1:0;
        4'd8:dfr = 0;
        4'd0:dfr =
        endcase
    end
endmodule
