`timescale 1ns / 100ps

/*
 * The GPIA_BYTE module describes an 8-bit collection of GPIA_BITs.  This
 * octet of bits allows the following operations:
 *
 * - Set all eight bits to an arbitrary state in a single cycle,
 * - Ensure an arbitrary set of bits are set true in a single cycle,
 * - Ensure an arbitrary set of bits are cleared false in a single cycle,
 *   and finally,
 * - Toggle an arbitrary set of bits truth value in a single cycle.
 */

module GPIA_BYTE(
	input	clk_i,
	input	res_i,
	input	[1:0] mode_i,
	input	[7:0] d_i,
	input	stb_i,

	output	[7:0] q_o
);

reg [7:0] q_d;

GPIA_BIT bit0(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[0]),
	.stb_i(stb_i),
	.q_o(q_o[0])
);

GPIA_BIT bit1(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[1]),
	.stb_i(stb_i),
	.q_o(q_o[1])
);

GPIA_BIT bit2(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[2]),
	.stb_i(stb_i),
	.q_o(q_o[2])
);

GPIA_BIT bit3(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[3]),
	.stb_i(stb_i),
	.q_o(q_o[3])
);

GPIA_BIT bit4(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[4]),
	.stb_i(stb_i),
	.q_o(q_o[4])
);

GPIA_BIT bit5(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[5]),
	.stb_i(stb_i),
	.q_o(q_o[5])
);

GPIA_BIT bit6(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[6]),
	.stb_i(stb_i),
	.q_o(q_o[6])
);

GPIA_BIT bit7(
	.clk_i(clk_i),
	.res_i(res_i),
	.mode_i(mode_i),
	.d_i(d_i[7]),
	.stb_i(stb_i),
	.q_o(q_o[7])
);

endmodule
