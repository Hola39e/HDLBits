/****************************************************************************************

	File name    : Data_Memory.v
	LastEditors  : H
	LastEditTime : 2021-09-24 20:23:16
	Last Version : 1.0
	Description  : 
	
	----------------------------------------------------------------------------------------
	
	Author       : H
	Date         : 2021-09-24 20:23:11
	FilePath     : \RISCV_Project\rtl\Data_Memory.v
	Copyright 2021 H, All Rights Reserved. 

****************************************************************************************/
`include "Parameter.v"
module Data_Memory(
    // System Clock
    input        clk,

    // address input, shared by read and write port
    input   [15:0]  mem_access_addr,

    // write port
    input   [15:0]  mem_write_data,
    input           mem_write_en,
    input           mem_read,

    // read port
    output  [15:0]  mem_read_data
);

    // reg define
    reg [`col - 1:0] memory [`row_d - 1:0];

    // integer define
    integer f;

    // wire define
    wire    [2:0]   ram_addr = mem_access_addr[2:0];

    initial begin
        $readmemb("test.data",memory);

        f = $fopen("sim_result.txt","w");
        $fmonitor(f,"time = %d\n", $time,
        "\tmemory[0] = %b\n", memory[0],
        "\tmemory[1] = %b\n", memory[1],
        "\tmemory[2] = %b\n", memory[2],
        "\tmemory[3] = %b\n", memory[3],
        "\tmemory[4] = %b\n", memory[4],
        "\tmemory[5] = %b\n", memory[5],
        "\tmemory[6] = %b\n", memory[6],
        "\tmemory[7] = %b\n", memory[7]);
        $fdisplay(f,"time = %d\n", $time,
        "\tmemory[0] = %b\n", memory[0],
        "\tmemory[1] = %b\n", memory[1],
        "\tmemory[2] = %b\n", memory[2],
        "\tmemory[3] = %b\n", memory[3],
        "\tmemory[4] = %b\n", memory[4],
        "\tmemory[5] = %b\n", memory[5],
        "\tmemory[6] = %b\n", memory[6],
        "\tmemory[7] = %b\n", memory[7]);
        `simulation_time;
    end

    always @(posedge clk ) begin
        if(mem_write_en)begin
            memory[ram_addr] <= mem_write_data;
        end
    end

    assign mem_read_data = (mem_read == 1'b1) ? memory[ram_addr]:16'b0;
endmodule