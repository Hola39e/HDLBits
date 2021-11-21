module adder32bit(
    // System Clock
    input   [31:0] A,
    input   [31:0] B,

    input           Cin,

    output  [31:0]  Sum,
    output          Cout
    // User Interface
    
);

    wire [7:0] C;
    adder4bit adder4bit0(A[3:0],    B[3:0],     Cin,    Sum[3:0], C[0]);
    adder4bit adder4bit1(A[7:4],    B[7:4],     C[0],   Sum[7:4], C[1]);
    adder4bit adder4bit2(A[11:8],   B[11:8],    C[1],   Sum[11:8], C[2]);
    adder4bit adder4bit3(A[15:12],  B[15:12],   C[2],   Sum[15:12], C[3]);
    adder4bit adder4bit4(A[19:16],  B[19:16],   C[3],   Sum[19:16], C[4]);
    adder4bit adder4bit5(A[23:20],  B[23:20],   C[4],   Sum[23:20], C[5]);
    adder4bit adder4bit6(A[27:24],  B[27:24],   C[5],   Sum[27:24], C[6]);
    adder4bit adder4bit7(A[31:28],  B[31:28],   C[6],   Sum[31:28], C[7]);

    assign Cout = C[7];


endmodule