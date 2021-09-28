/****************************************************************************************

	File name    : alu_control.v
	LastEditors  : H
	LastEditTime : 2021-09-24 21:44:46
	Last Version : 1.0
	Description  : control unit of ALU
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-24 21:44:40
	FilePath     : \RISCV_Project\rtl\alu_control.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module alu_control (
    output  reg [2:0]   ALU_Cnt,
    input       [1:0]   ALUOp,
    input       [3:0]   Opcode
);
    // wire define
    wire        [5:0]   ALUControlIn;
    assign              ALUControlIn = {ALUOp,Opcode};
    always @(ALUControlIn) begin
        casex (ALUControlIn)
            6'b10xxxx:  ALU_Cnt = 3'b000; 
            6'b01xxxx:  ALU_Cnt = 3'b001; 
            6'b000010:  ALU_Cnt = 3'b000; 
            6'b000011:  ALU_Cnt = 3'b001; 
            6'b000100:  ALU_Cnt = 3'b010;
            6'b000101:  ALU_Cnt = 3'b011;
            6'b000110:  ALU_Cnt = 3'b100;
            6'b000111:  ALU_Cnt = 3'b101;
            6'b001000:  ALU_Cnt = 3'b110;
            6'b001001:  ALU_Cnt = 3'b111;
            default: ALU_Cnt = 3'b000;
        endcase
    end
endmodule