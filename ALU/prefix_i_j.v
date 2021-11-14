/**********************************************************
// Copyright @ 2021 H. All rights reserved
// Contact with e611hx@gmail.com
============================================================
>> Author   : H
>> Date     : 2021-11-14
>> Filename    : prefix_i_j.v
>> Modulename  : prefix_i_j
>> Description : 
>> Version  : 1.0
************************************************************/

module prefix_i_j(
    // System Clock
    input        P_ik,
    input        P_k1_j,

    input        G_ik,
    input        G_k1_j,

    output       P_ij,
    output       G_ij
    
);

/*******************************************************************************
 *                                 Main Code
*******************************************************************************/

    assign P_ij = P_ik & P_k1_j;
    assign G_ij = G_ik | (G_k1_j & P_ik);
    
endmodule