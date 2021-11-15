/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-14
>> Filename    : prefix_adder16.v
>> Modulename  : prefix_adder16
>> Description : 
>> Version  : 1.0
************************************************************/

module prefix_adder16(
    input   [15:0]  A,
    input   [15:0]  B,
    input           Cin,

    output  [15:0]  Sum,
    output          Cout
);

    wire [15:0] P,G;
    wire [7:0]  PP,PG,PP1,PG1,PP2,PG2,PP3,PG3;
    wire [15:0] Gi_n1;

    assign P = A ^ B;
    assign G = A & B;

    prefix_i_j prefix0(P[0],    1'b0,   G[0],   Cin,    PP[0], PG[0]);
    prefix_i_j prefix1(P[2],    P[1],   G[2],   G[1],   PP[1], PG[1]);
    prefix_i_j prefix2(P[4],    P[3],   G[4],   G[3],   PP[2], PG[2]);
    prefix_i_j prefix3(P[6],    P[5],   G[6],   G[5],   PP[3], PG[3]);
    prefix_i_j prefix4(P[8],    P[7],   G[8],   G[7],   PP[4], PG[4]);
    prefix_i_j prefix5(P[10],   P[9],   G[10],  G[9],   PP[5], PG[5]);
    prefix_i_j prefix6(P[12],   P[11],  G[12],  G[11],  PP[6], PG[6]);
    prefix_i_j prefix7(P[14],   P[13],  G[14],  G[13],  PP[7], PG[7]);

    prefix_i_j prefix8(P[1],    PP[0],   G[1],   PG[0],   PP1[0], PG1[0]);
    prefix_i_j prefix9(PP[1],   PP[0],   PG[1],  PG[0],   PP1[1], PG1[1]);
    prefix_i_j prefix10(P[5],   PP[2],   G[5],   PG[2],   PP1[2], PG1[2]);
    prefix_i_j prefix11(PP[3],  PP[2],   PG[3],  PG[2],   PP1[3], PG1[3]);
    prefix_i_j prefix12(P[9],   PP[4],   G[9],   PG[4],   PP1[4], PG1[4]);
    prefix_i_j prefix13(PP[5],  PP[4],   PG[5],  PG[4],   PP1[5], PG1[5]);
    prefix_i_j prefix14(P[13],  PP[6],   G[13],  PG[6],   PP1[6], PG1[6]);
    prefix_i_j prefix15(PP[7],  PP[6],   PG[7],  PG[6],   PP1[7], PG1[7]);

    prefix_i_j prefix16(P[3],   PP1[1],  G[3],   PG1[1],  PP2[0], PG2[0]);
    prefix_i_j prefix17(PP[2],  PP1[1],  PG[2],  PG1[1],  PP2[1], PG2[1]);
    prefix_i_j prefix18(PP1[2], PP1[1],  PG1[2], PG1[1],  PP2[2], PG2[2]);
    prefix_i_j prefix19(PP1[3], PP1[1],  PG1[3], PG1[1],  PP2[3], PG2[3]);

    prefix_i_j prefix20(P[11],  PP1[5],  G[11],  PG1[5],  PP2[4], PG2[4]);
    prefix_i_j prefix21(PP[6],  PP1[5],  PG[6],  PG1[5],  PP2[5], PG2[5]);
    prefix_i_j prefix22(PP1[6], PP1[5],  PG1[6], PG1[5],  PP2[6], PG2[6]);
    prefix_i_j prefix23(PP1[7], PP1[5],  PG1[7], PG1[5],  PP2[7], PG2[7]);

    prefix_i_j prefix24(P[7],   PP2[3],  G[7],   PG2[3],  PP3[0], PG3[0]);
    prefix_i_j prefix25(PP[4],  PP2[3],  PG[4],  PG2[3],  PP3[1], PG3[1]);
    prefix_i_j prefix26(PP1[4], PP2[3],  PG1[4], PG2[3],  PP3[2], PG3[2]);
    prefix_i_j prefix27(PP1[5], PP2[3],  PG1[5], PG2[3],  PP3[3], PG3[3]);
    prefix_i_j prefix28(PP2[4], PP2[3],  PG2[4], PG2[3],  PP3[4], PG3[4]);
    prefix_i_j prefix29(PP2[5], PP2[3],  PG2[5], PG2[3],  PP3[5], PG3[5]);
    prefix_i_j prefix30(PP2[6], PP2[3],  PG2[6], PG2[3],  PP3[6], PG3[6]);
    prefix_i_j prefix31(PP2[7], PP2[3],  PG2[7], PG2[3],  PP3[7], PG3[7]);

    assign Gi_n1[0] = Cin;
    assign Gi_n1[1] = PG[0];
    assign Gi_n1[2] = PG1[0];
    assign Gi_n1[3] = PG1[1];
    assign Gi_n1[4] = PG2[0];
    assign Gi_n1[5] = PG2[1];
    assign Gi_n1[6] = PG2[2];
    assign Gi_n1[7] = PG2[3];

    assign Gi_n1[8] = PG3[0];
    assign Gi_n1[9] = PG3[1];
    assign Gi_n1[10] = PG3[2];
    assign Gi_n1[11] = PG3[3];
    assign Gi_n1[12] = PG3[4];
    assign Gi_n1[13] = PG3[5];
    assign Gi_n1[14] = PG3[6];
    assign Gi_n1[15] = PG3[7];

    assign Sum = Gi_n1 ^ P;
    assign Cout = G[15] | (P[15] & Gi_n1[15]);

    
endmodule