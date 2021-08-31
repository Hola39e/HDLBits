// Note the Verilog-1995 module declaration syntax here:
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;//  
    reg out;

    parameter A = 1'b0,B = 1'b1;// Fill in state name declarations

    reg present_state, next_state;

    always @(posedge clk) begin
        if (reset) begin  
            present_state <= B;// Fill in reset logic
        end else begin
            // State flip-flops

            present_state <= next_state;   
        end
    end
    always @(*) begin
                case (present_state)
                A:next_state <= ~(A^in);
                B:next_state <= ~(B^in);
                endcase
            case (present_state)
                A: out<= 1'b0;// Fill in output logic
                B: out<= 1'b1;// Fill in output logic
            endcase
    end
// Fill in state transition logic
            

endmodule
