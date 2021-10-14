/****************************************************************************************

	File name    : 
	LastEditors  : H
	LastEditTime : 2021-10-07 13:36:23
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-10-07 13:36:21
	FilePath     : \Verilog\Auto_LFSR_ALGO.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
// See in page 108
module Auto_LFSR_ALGO #(
    parameter Length = 8,initial_state = 8'b1001_0001,
    parameter [1:Length] Tap_Coefficient= 8'b1111_0011
) (
    input                   Clock,Reset,
    output  reg [1:Length]  Y
);
    integer Cell_ptr;

    always @(posedge Clock) begin
        if (!Reset) begin
            Y <= initial_state;
        end
        else begin
            // usually, if C(N-j+1)=1 then the input of j is Y[j-1]^Y[j]
            for (Cell_ptr = 2; Cell_ptr <= Length; Cell_ptr = Cell_ptr + 1) begin
                if (Tap_Coefficient[Length - Cell_ptr + 1]) begin
                    Y[Cell_ptr] <= Y[Cell_ptr - 1] ^ Y[Length];
                end
                else
                    Y[Cell_ptr] <= Y[Cell_ptr];
                Y[1] <= Y[Length];
            end
        end
    end
    // there are 3 keyword of loop stucture:
        // while, repeat, forever, for
        
endmodule
