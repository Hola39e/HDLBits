
module fulladder(


    // System Clock
    input        Ai,
    input        Bi,
    input       Cin,

    output      Sum,
    output      Gi,
    output      Pi
    // User Interface
    // Pi = A ^ B;
    // Gi = A & B;
);
/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    assign Pi = Ai ^ Bi;
    assign Gi = Ai & Bi;
    assign Sum = Pi ^ Cin;

endmodule