module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    parameter set_as_AM = 1'b0;
    reg [2:0] ena_temp;
    bcd_cnt60 cnt1st(clk,reset,ena,ena_temp[0],ss);
    bcd_cnt60 cnt2nd(clk,reset,ena_temp[0],ena_temp[1],mm);
    bcd_cnt12 cnt3rd(clk,reset,ena_temp[1],ena_temp[2],hh);
    always @(posedge clk ) begin
        if(reset)begin
            pm <= set_as_AM;
        end 
        else if(ena) begin
            if ((hh==8'h11)&(mm==8'h59)&(ss==8'h59)) begin
                pm <= ~pm;
            end
            
        end
    end
endmodule

module bcd_cnt60(input clk, reset, eni, output eno, output [7:0]q);

assign eno = (q ==8'h59) & eni;
always @(posedge clk) begin
    if(reset) q <= 8'h0;
    else if(eni) begin
        q[3:0] <= (q[3:0] == 4'h9) ? 4'h0 : q[3:0]+4'h1;
        q[7:4] <= (q[3:0] == 4'h9) ? q[7:4]+4'h1: q[7:4];
        if (q==8'h59) begin
            q <= 8'd0;
        end
    end
end
endmodule

module bcd_cnt12(input clk, reset, eni, output eno, output [7:0]q);

//assign eno = (q == 4'h12) & eni;
always @(posedge clk) begin
    if(reset) q <= 8'h12;       
    else if(eni) begin
        q[3:0] <= (q[3:0] == 4'h9) ? 4'h0 : q[3:0]+4'h1;
        q[7:4] <= (q[3:0] == 4'h9) ? q[7:4]+4'h1: q[7:4];
        if (q==8'h12) begin
            q <= 8'd1;
            eno <= ~eno;
        end
    end
end
endmodule
