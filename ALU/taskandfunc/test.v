`timescale 1ns/1ns
 
module test ;
    reg          clk, rstn ;
 
    initial begin
        rstn      = 0 ;
        #8 rstn   = 1 ;
        forever begin
            clk = 0 ; # 5;
            clk = 1 ; # 5;
        end
    end
 
    reg  [3:0]   a, b;
    wire [3:0]   co ;
    initial begin
        a         = 0 ;
        b         = 0 ;
        sig_input(4'b1111, 4'b1001, a, b);
        sig_input(4'b0110, 4'b1001, a, b);
        sig_input(4'b1000, 4'b1001, a, b);
    end
 
    task sig_input ;
            input [3:0]       a ;
            input [3:0]       b ;
            output [3:0]      ao ;
            output [3:0]      bo ;
            begin
                @(posedge clk);
                ao = a ;
                bo = b ;
            end
    endtask// sig_input
 
    xor_oper         u_xor_oper
    (
      .clk              (clk  ),
      .rstn             (rstn ),
      .a                (a    ),
      .b                (b    ),
      .co               (co   ));
 
    initial begin
        forever begin
            #100;
            if ($time >= 1000)  $finish ;
        end
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
    end
 
endmodule // test