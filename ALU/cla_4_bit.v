module cla_4_bit (
    input   [3:0]   A,
    input   [3:0]   B,
    input           Cin,

    output  [3:0]   Sum,
    output          Cout
);
    wire [3:0] G,P,C; 

    assign G = A & B;
    assign P = A ^ B;

    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[0] | (P[0] & Cin);

endmodule