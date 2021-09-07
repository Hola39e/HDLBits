module endian_rvs (
    #(parameter N = 4)
        (
            input en,
            input [N-1:0] a,

            output [N-1:0] b
        )
);
    reg [N-1:0] b_temp;
    always @(*) begin
        if (en) begin    
            b_temp = data_rvs(a);
        end
        else begin
            b_temp = 0;
        end
    end
    assign b = b_temp;

    // function entity
    function [N-1:0] data_rvs;
        input [N-1:0] data_in;
        parameter MASK = 32'h3;
        integer k;
        begin
            for(k=0;k<N;k++)begin
                data_rvs[N-k-1] = data_in[k];
            end
        end
    endfunction
endmodule