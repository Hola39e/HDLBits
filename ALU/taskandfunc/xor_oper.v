module xor_oper
    #(parameter         N = 4)
     (
      input             clk ,
      input             rstn ,
      input [N-1:0]     a ,
      input [N-1:0]     b ,
      output [N-1:0]    co  );
 
    reg [N-1:0]          co_t ;
    always @(*) begin          //任务调用
        xor_oper_iner(a, b, co_t);
    end
 
    reg [N-1:0]          co_r ;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            co_r   <= 'b0 ;
        end
        else begin
            co_r   <= co_t ;         //数据缓存
        end
    end
    assign       co = co_r ;
 
   /*------------ task -------*/
    task xor_oper_iner;
        input [N-1:0]   numa;
        input [N-1:0]   numb;
        output [N-1:0]  numco ;
        #3  numco       = numa ^ numb ;   //阻塞赋值，易于控制时序
    endtask
 
endmodule