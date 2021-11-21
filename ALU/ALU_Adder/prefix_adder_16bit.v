/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-14
>> Filename    : prefix_adder_16bit.v
>> Modulename  : prefix_adder_16bit
>> Description : 
>> Version  : 1.0
************************************************************/

module prefix_adder_16bit(
    // User Interface
    input   [15:0]  A,
    input   [15:0]  B,
    input           Cin,

    output  [15:0]  Sum,
    output          Cout
);

    wire [15:0] P,G;
    wire [7:0]  Prefix_1G,Prefix_1P;
    integer i = 0;
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/
    assign G = A & B;
    assign P = A ^ B;

    assign Prefix_1G[0] = Cin;
    assign Prefix_1P[0] = 1'b0;
    always @(*) begin
        for (i = 1; i <= 13; i = i + 2) begin
            Prefix_1P[(i + 1)/2] = P[i] & P[i + 1];
            Prefix_1G[(i + 1)/2] = G[i] | (G[i - 1] & P[i]);
        end
    end


endmodule