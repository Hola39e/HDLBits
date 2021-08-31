module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//  

    parameter A=0, B=1; 
    reg state, next_state;

    always @(*) begin    
        next_state = ~(state^in);
        // This is a combinational always block
        // State transition logic
    end
    always @(posedge clk, posedge areset) begin    // This is a sequential always block
        if (areset) begin
            state <=1;
        end
        else begin
            state = next_state;
        end// State flip-flops with asynchronous reset
    end

    // Output logic
    assign out = state?1:0;// assign out = (state == ...);

endmodule
