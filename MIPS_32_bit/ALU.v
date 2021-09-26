/****************************************************************************************

	File name    : ALU
	LastEditors  : H
	LastEditTime : 2021-09-26 16:31:31
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 16:31:29
	FilePath     : \MIPS_32_bit\ALU.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module ALU (
    input   [31:0]  RS_IN,
    input   [31:0]  RT_IN,

    input   [4:0]   SHAMT,
    input   [3:0]   ALU_CTRL,

    output reg [31:0]   ALU_OUT,
    output           ZERO_FLAG,
    output           OVF_FLAG,
    output           LARGE_FLAG,
    output           EQUAL_FLAG,
    output           SMALL_FLAG
);
    // wire define
    wire    [31:0]  ADD_RESULT,SUB_RESULT;
    wire    [31:0]  SHIFT_DOUT;
    wire            ADD_OVF_FLAG,SUB_OVF_FLAG;

    // reg define
    reg     [1:0]   SHIFT_FUNC;

    assign ADD_RESULT = RS_IN + RT_IN;
    assign SUB_RESULT = RS_IN - RT_IN;

    Barrel_Shifter u_Barrel_Shifter
    (
        .SHIFT_FUNC(SHIFT_FUNC),
        .SHIFT_TIMES(SHAMT),
        .SHIFT_DIN(RT_IN),
        .SHIFT_DOUT(SHIFT_DOUT)
    );

    always @(*) begin
        case (ALU_CTRL)
            4'b1011: ALU_OUT = ADD_RESULT;
            4'b1100: ALU_OUT = SUB_RESULT;
            4'b0010: ALU_OUT = RS_IN & RT_IN;
            4'b0110: ALU_OUT = RS_IN ^ RT_IN;
            4'b0111: ALU_OUT = ~(RS_IN | RT_IN);
            4'b0100: begin
                // SLL
                    SHIFT_FUNC = 2'b01;
                    ALU_OUT = SHIFT_DOUT;
                end
            4'b0101: begin
                // SRL
                    SHIFT_FUNC = 2'b00;
                    ALU_OUT = SHIFT_DOUT;
                end
            4'b0100: begin
                // SLL
                    SHIFT_FUNC = 2'b10;
                    ALU_OUT = SHIFT_DOUT;
                end
            default: ;
        endcase
    end

    assign LARGE_FLAG = RS_IN > RT_IN;
    assign EQUAL_FLAG = RS_IN == RT_IN;
    assign SMALL_FLAG = RS_IN < RT_IN;
    assign ZERO_FLAG = &(~ALU_OUT);

    assign ADD_OVF_FLAG = ((RS_IN[31] == RT_IN[31]) && (RS_IN[31] != ADD_RESULT[31])) ? 1'b1 : 1'b0;
    assign SUB_OVF_FLAG = ((RS_IN[31] == RT_IN[31]) && (RS_IN[31] != SUB_RESULT[31])) ? 1'b1 : 1'b0;
    assign OVF_FLAG     = ADD_OVF_FLAG | SUB_OVF_FLAG;

endmodule