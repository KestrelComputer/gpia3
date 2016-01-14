`timescale 1ns / 100ps

/* This module creates a byte-wide assembly of GPIA_BIT_INs.
 */

module GPIA_BYTE_IN(
	input [7:0] out_i,
	input [7:0] inp_i,
	input [7:0] ddr_i,
	input stb_i,

	output	[7:0] q_o
);


GPIA_BIT_IN bit0(
	.out_i(out_i[0]),
	.inp_i(inp_i[0]),
	.ddr_i(ddr_i[0]),
	.stb_i(stb_i),
	.q_o(q_o[0])
);

GPIA_BIT_IN bit1(
	.out_i(out_i[1]),
	.inp_i(inp_i[1]),
	.ddr_i(ddr_i[1]),
	.stb_i(stb_i),
	.q_o(q_o[1])
);

GPIA_BIT_IN bit2(
	.out_i(out_i[2]),
	.inp_i(inp_i[2]),
	.ddr_i(ddr_i[2]),
	.stb_i(stb_i),
	.q_o(q_o[2])
);

GPIA_BIT_IN bit3(
	.out_i(out_i[3]),
	.inp_i(inp_i[3]),
	.ddr_i(ddr_i[3]),
	.stb_i(stb_i),
	.q_o(q_o[3])
);

GPIA_BIT_IN bit4(
	.out_i(out_i[4]),
	.inp_i(inp_i[4]),
	.ddr_i(ddr_i[4]),
	.stb_i(stb_i),
	.q_o(q_o[4])
);

GPIA_BIT_IN bit5(
	.out_i(out_i[5]),
	.inp_i(inp_i[5]),
	.ddr_i(ddr_i[5]),
	.stb_i(stb_i),
	.q_o(q_o[5])
);

GPIA_BIT_IN bit6(
	.out_i(out_i[6]),
	.inp_i(inp_i[6]),
	.ddr_i(ddr_i[6]),
	.stb_i(stb_i),
	.q_o(q_o[6])
);

GPIA_BIT_IN bit7(
	.out_i(out_i[7]),
	.inp_i(inp_i[7]),
	.ddr_i(ddr_i[7]),
	.stb_i(stb_i),
	.q_o(q_o[7])
);


endmodule
