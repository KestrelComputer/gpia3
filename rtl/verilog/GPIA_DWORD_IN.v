`timescale 1ns / 100ps

/* This module creates a byte-wide assembly of GPIA_BIT_INs.
 */

module GPIA_DWORD_IN(
	input [63:0] out_i,
	input [63:0] inp_i,
	input [63:0] ddr_i,
	input [7:0] stb_i,

	output	[63:0] q_o
);


GPIA_BYTE_IN byte0(
	.out_i(out_i[7:0]),
	.inp_i(inp_i[7:0]),
	.ddr_i(ddr_i[7:0]),
	.stb_i(stb_i[0]),
	.q_o(q_o[7:0])
);

GPIA_BYTE_IN byte1(
	.out_i(out_i[15:8]),
	.inp_i(inp_i[15:8]),
	.ddr_i(ddr_i[15:8]),
	.stb_i(stb_i[1]),
	.q_o(q_o[15:8])
);

GPIA_BYTE_IN byte2(
	.out_i(out_i[23:16]),
	.inp_i(inp_i[23:16]),
	.ddr_i(ddr_i[23:16]),
	.stb_i(stb_i[2]),
	.q_o(q_o[23:16])
);

GPIA_BYTE_IN byte3(
	.out_i(out_i[31:24]),
	.inp_i(inp_i[31:24]),
	.ddr_i(ddr_i[31:24]),
	.stb_i(stb_i[3]),
	.q_o(q_o[31:24])
);

GPIA_BYTE_IN byte4(
	.out_i(out_i[39:32]),
	.inp_i(inp_i[39:32]),
	.ddr_i(ddr_i[39:32]),
	.stb_i(stb_i[4]),
	.q_o(q_o[39:32])
);

GPIA_BYTE_IN byte5(
	.out_i(out_i[47:40]),
	.inp_i(inp_i[47:40]),
	.ddr_i(ddr_i[47:40]),
	.stb_i(stb_i[5]),
	.q_o(q_o[47:40])
);

GPIA_BYTE_IN byte6(
	.out_i(out_i[55:48]),
	.inp_i(inp_i[55:48]),
	.ddr_i(ddr_i[55:48]),
	.stb_i(stb_i[6]),
	.q_o(q_o[55:48])
);

GPIA_BYTE_IN byte7(
	.out_i(out_i[63:56]),
	.inp_i(inp_i[63:56]),
	.ddr_i(ddr_i[63:56]),
	.stb_i(stb_i[7]),
	.q_o(q_o[63:56])
);


endmodule
