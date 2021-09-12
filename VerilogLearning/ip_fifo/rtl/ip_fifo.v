/*******************************************************************************

    @Author: H 
    @Associated Filename: ip_fifo
    @Purpose: top level of fifo (which low level are fifo_wr.v and fifo_rd.v)
    @Device: All 
    @Version: 1.0
    @Date: 2021/09/12 15:20:39

*******************************************************************************/
module ip_fifo(
    // System Clock
    input        sys_clk,
    input        sys_rst_n

    // User Interface
    
);
    // wire define
    wire    wrreq;
    wire    wrempty;
    wire [7:0] data;
    wire    wrfull;
    wire    wrusedw;

    wire    rdreq;
    wire    rdempty;
    wire [7:0] q;
    wire    rdfull;
    wire    rdusedw;

    /*******************************************************************************
     *                                 Main Code
    *******************************************************************************/
    fifo	u_fifo (
	.data ( data ),
	.rdclk ( sys_clk ),
	.rdreq ( rdreq ),
	.wrclk ( sys_clk ),
	.wrreq ( wrreq ),
	.q ( q ),
	.rdempty ( rdempty ),
	.rdfull ( rdfull ),
	.rdusedw ( rdusedw ),
	.wrempty ( wrempty ),
	.wrfull ( wrfull ),
	.wrusedw ( wrusedw )
	);

    fifo_wr u_fifo_wr(
        .clk(sys_clk),
        .rst_n(sys_rst_n),

        .wrempty(wrempty),
        .wrfull(wrfull),
        .data(data),
        .wrreq(wrreq)
    );
    fifo_rd u_fifo_rd(
        .clk(sys_clk),
        .rst_n(sys_rst_n),

        .rdempty(rdempty),
        .rdfull(rdfull),
        .data(q),
        .rdreq(rdreq)
    );
endmodule