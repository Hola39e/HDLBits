/****************************************************************************************

	File name    : Instruction_Register.v
	LastEditors  : H
	LastEditTime : 2021-09-26 14:07:54
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-26 14:07:52
	FilePath     : \MIPS_32_bit\rtl\Instruction_Register.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
module module_name(
    // System Clock
    input        clk,
    input        rst,

    // User Interface
    input   [31:0]      INST_IN,
    input               INST_REG_WE,

    output  reg [5:0]       OP_CODE,
    output  reg [4:0]       RS_ADDR,
    output  reg [4:0]       RT_ADDR,
    output  reg [4:0]       RD_ADDR,
    output  reg [5:0]       ALU_FUNC,
    output  reg [4:0]       SHAMT,
    output  reg [15:0]      IMMED,
    output  reg [25:0]      JUMP_ADDR
);

    // wire define

    always @(posedge clk or negedge rst ) begin
        if(rst)begin
            OP_CODE     <= 6'b0;
        end
        else begin
            if (INST_REG_WE) begin
                OP_CODE <= INST_IN[31:26];

                RS_ADDR     <= INST_IN[25:21];
                RT_ADDR     <= INST_IN[20:16];
                RD_ADDR     <= INST_IN[15:11];
                ALU_FUNC    <= INST_IN[5:0]; 
                SHAMT       <= INST_IN[10:6];
                IMMED       <= INST_IN[15:0];
                JUMP_ADDR   <= INST_IN[25:0];
            end
            else
                OP_CODE     <= 6'b0;
        end
    end

    always @(posedge clk or negedge rst ) begin
        if(rst)begin
            RS_ADDR     <= 5'b0;
            RT_ADDR     <= 5'b0;
            RD_ADDR     <= 5'b0;
            ALU_FUNC    <= 6'b0; 
            SHAMT       <= 5'b0;
            IMMED       <= 16'b0;
            JUMP_ADDR   <= 26'b0;
        end
        else begin
            if (INST_REG_WE) begin
                case (OP_CODE)
                    6'b0: ;
                    default: ;
                endcase
            end
        end
    end

endmodule