`timescale 1ns / 100ps

/*
 * The GPIA_DWORD module describes a 64-bit collection of GPIA_BITs.  Each
 * octet of bits can be independently masked by its own stb_i input.
 */

module GPIA_DWORD(
	input	clk_i,
	input	res_i,
	input	[1:0] mode_i,
	input	[63:0] d_i,
	input	[7:0] stb_i,

	output	[63:0] q_o
);

GPIA_BYTE byte0(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[7:0]),
	.stb_i(stb_i[0]),
	.q_o(q_o[7:0])
);

GPIA_BYTE byte1(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[15:8]),
	.stb_i(stb_i[1]),
	.q_o(q_o[15:8])
);

GPIA_BYTE byte2(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[23:16]),
	.stb_i(stb_i[2]),
	.q_o(q_o[23:16])
);

GPIA_BYTE byte3(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[31:24]),
	.stb_i(stb_i[3]),
	.q_o(q_o[31:24])
);

GPIA_BYTE byte4(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[39:32]),
	.stb_i(stb_i[4]),
	.q_o(q_o[39:32])
);

GPIA_BYTE byte5(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[47:40]),
	.stb_i(stb_i[5]),
	.q_o(q_o[47:40])
);

GPIA_BYTE byte6(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[55:48]),
	.stb_i(stb_i[6]),
	.q_o(q_o[55:48])
);

GPIA_BYTE byte7(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[63:56]),
	.stb_i(stb_i[7]),
	.q_o(q_o[63:56])
);

endmodule
