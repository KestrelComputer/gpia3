`timescale 1ns / 100ps

/* The GPIA bit input mux is used when a processing element reads from I/O
 * space.  Some bits may be configured to sample actual signals outside the
 * GPIA ("inputs").  Some pins will be configured to drive signals outside the
 * GPIA ("outputs").  If a particular I/O bit is configured as an output, we
 * want to read back the last value we wrote to it.  Otherwise, we want to
 * read the current state of the external signal attached to it.
 */

module test();

reg out_o;
reg inp_o;
reg ddr_o;
reg stb_o;

wire q_i;

/* We have a clock, but the mux doesn't use it.  I use it for test
 * synchronization only.
 */
reg clk_o;

/* Scenario tag for knowing which test is running when viewing waveforms. */
reg [7:0] scenario_o;

/* Device Under Test */

GPIA_BIT_IN dut (
	.out_i(out_o),
	.inp_i(inp_o),
	.ddr_i(ddr_o),
	.stb_i(stb_o),
	.q_o(q_i)
);

always begin
	#20 clk_o <= ~clk_o;
end

task waitclk;
begin @(negedge clk_o); @(posedge clk_o);
end
endtask

/* The scenario tests commence here. */

initial begin
	scenario_o <= 8'h00;
	out_o <= 0;
	inp_o <= 0;
	ddr_o <= 0;
	stb_o <= 0;
	clk_o <= 0;

	$dumpfile("test.vcd");
	$dumpvars;

	/* With stb_o low, we expect a zero result, regardless of the state
	 * of the inputs.  This allows an implementation to logically-OR
	 * buses together.
	 */

	@(posedge clk_o);
	scenario_o <= 8'h10;
	waitclk;
	if(q_i != 0) begin
		$display("FAIL 10: Q not 0"); $finish;
	end

	$display("PASS"); $finish;
end

endmodule
