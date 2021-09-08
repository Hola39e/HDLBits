module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

    // State transition logic (combinational)
    reg [3:0] next_state,state ;
    parameter s0 = 3'd1,s1=3'd2,s2=3'd4;
    always @(*) begin
        case(state)
        s0:begin
            next_state = in[3]?s1:s0;
            
        end
        s1:begin
            next_state = s2;
            
        end
        s2:begin
            next_state = s0;
            
        end
        endcase
    end
    // State flip-flops (sequential)
    always @(posedge clk ) begin
        if(reset)begin
            state <= s0;
        end
        else begin
            state <= next_state;
        end
    end
    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
            out_bytes = 24'b0;
        end
        else begin
            done <= (state==s2);
            case (state)
                s0: out_bytes[23:16] = in[7:0];
                s1: out_bytes[15:8] = in[7:0];
                s2: out_bytes[7:0] = in[7:0];
                default: out_bytes = 24'b0;
            endcase
        end
        
    end
endmodule
