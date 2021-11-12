module adder4bit(
    // System Clock
    input   [3:0] A,
    input   [3:0] B,
    input           Cin,

    output  [3:0]   Sum,
    output          Cout         

    // User Interface
);
    wire [3:0] G,P;
    wire [3:0]  C;
    fulladder   adder0(A[0],B[0],Cin,Sum[0],G[0],P[0]);
    fulladder   adder1(A[1],B[1],C[0],Sum[1],G[1],P[1]);
    fulladder   adder2(A[2],B[2],C[1],Sum[2],G[2],P[2]);
    fulladder   adder3(A[3],B[3],C[2],Sum[3],G[3],P[3]);

    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign Cout = C[3];
endmodule