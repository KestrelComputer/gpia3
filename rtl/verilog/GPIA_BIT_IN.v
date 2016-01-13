`timescale 1ns / 100ps

/* The GPIA bit input mux is used when a processing element reads from I/O
 * space.  Some bits may be configured to sample actual signals outside the
 * GPIA ("inputs").  Some pins will be configured to drive signals outside the
 * GPIA ("outputs").  If a particular I/O bit is configured as an output, we
 * want to read back the last value we wrote to it.  Otherwise, we want to
 * read the current state of the external signal attached to it.
 */

module GPIA_BIT_IN(
	input out_i,
	input inp_i,
	input ddr_i,
	input stb_i,

	output q_o
);

assign q_o = 0;

endmodule
