module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    parameter LEFT = 4'd0,RIGHT = 4'd1,GROUND_LEFT = 4'd2,GROUND_RIGHT = 4'd3,DIGGING_LEFT=4'd4;
    parameter DIGGING_RIGHT = 4'd5,SPLATTER = 4'd6,AAAH_END = 4'd7;
    reg [3:0] current_state,next_state;
    reg[4:0] cnt;
    always @(*) begin
        case (current_state)
            LEFT: next_state = ground?(dig?DIGGING_LEFT:(bump_left?RIGHT:LEFT)):GROUND_LEFT;
            RIGHT: next_state = ground?(dig?DIGGING_RIGHT:(bump_right?LEFT:RIGHT)):GROUND_RIGHT;
            GROUND_LEFT: next_state = ground?LEFT:((cnt==5'd20)?SPLATTER:GROUND_LEFT);
            GROUND_RIGHT: next_state = ground?RIGHT:((cnt==5'd20)?SPLATTER:GROUND_RIGHT);
            DIGGING_LEFT: next_state = ground?DIGGING_LEFT:GROUND_LEFT;
            DIGGING_RIGHT: next_state = ground?DIGGING_RIGHT:GROUND_RIGHT;
            SPLATTER: next_state = ground?AAAH_END:SPLATTER;
            AAAH_END: next_state = AAAH_END;
            default: next_state = LEFT;
        endcase
    end
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= LEFT;
        end
        else begin
            current_state <= next_state;
            end
    end
    always @(posedge clk or posedge areset) begin
        if(areset)begin
            cnt <= 5'b0;
        end
        else if ((next_state == GROUND_LEFT)||(next_state == GROUND_RIGHT)) begin
            cnt <= cnt + 1;
        end
        else begin
            cnt <= 5'b0;
        end
    end
    assign walk_left = (current_state == LEFT);
    assign walk_right = (current_state == RIGHT);
    assign aaah = (current_state == GROUND_LEFT)||(current_state == GROUND_RIGHT)||(current_state == SPLATTER);
    assign digging = (current_state == DIGGING_LEFT)||(current_state == DIGGING_RIGHT);
endmodule
