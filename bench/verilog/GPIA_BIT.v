`timescale 1ns / 100ps

/* This test module works by tickling various inputs over a sequence of time.
 * If the output waveforms graphically, each test scenario is uniquely
 * identified by a number on the `scenario_o` bus.
 */

module test_bit();

reg clk_o;
reg rst_o;
reg [7:0] scenario_o;
reg [1:0] mode_o;
reg d_o;
reg stb_o;

wire q_i;

/* Device Under Test */

GPIA_BIT dut (
	.clk_i(clk_o),
	.res_i(rst_o),
	.mode_i(mode_o),
	.d_i(d_o),
	.stb_i(stb_o),
	.q_o(q_i)
);

/* Initial models will correspond to a 12.5MHz system clock, to make it as
 * close to the Kestrel-3's initial hardware configuration as possible.
 * Alternative synthesis targets may want to adjust this setting if it affects
 * how the circuit is synthesized.  I have no experience with ASICs or large,
 * mega-FPGAs, so I'm ignorant of its effects in those contexts.
 */

always begin
	#20 clk_o <= ~clk_o;
end

/* Everything on the Wishbone bus happens on the rising edge of the clock.
 * I'm not personally a fan of this approach, but it works well in an FPGA
 * context.  This task is responsible for synchronizing these unit tests
 * against Wishbone's expectations of when a new cycle starts.
 */

task waitclk;
begin @(negedge clk_o); @(posedge clk_o);
end
endtask

/* About half of the test cases cover a reset bit, and the other half when
 * the bit is set.  This task fakes a Wishbone bus transaction which sets
 * the bit.
 */

task setq;
begin
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 1;
	stb_o <= 1;
	waitclk;
end
endtask

/* The scenario tests commence here. */

initial begin
	clk_o <= 0;
	rst_o <= 0;
	scenario_o <= 8'h00;
	mode_o <= 0;
	d_o <= 0;
	stb_o <= 0;

	$dumpfile("test.vcd");
	$dumpvars;

	/* Given a reset GPIA, all outputs MUST be low. */

	@(posedge clk_o);
	scenario_o <= 8'h01;
	rst_o <= 1;
	waitclk;
	rst_o <= 0;
	waitclk;
	if(q_i == 1) begin
		$display("FAIL 01: Q not 0"); $finish;
	end

	/* Given a reset GPIA, followed by a write of '0', q_i MUST
 	 * become '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h10;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 0;
	stb_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 10: Q must remain 0"); $finish;
	end

	/* Given a reset GPIA, followed by a set-bit of '0', q_i MUST
 	 * remain '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h14;
	waitclk;
	rst_o <= 0;
	mode_o <= 1;
	d_o <= 0;
	stb_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 14: Q must remain 0"); $finish;
	end

	/* Given a reset GPIA, followed by a clr-bit of '0', q_i MUST
 	 * remain '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h18;
	waitclk;
	rst_o <= 0;
	mode_o <= 2;
	d_o <= 0;
	stb_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 18: Q must remain 0"); $finish;
	end

	/* Given a reset GPIA, followed by a tgl-bit of '0', q_i MUST
 	 * remain '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h1C;
	waitclk;
	rst_o <= 0;
	mode_o <= 3;
	d_o <= 0;
	stb_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 1C: Q must remain 0"); $finish;
	end

	/* Given a reset GPIA, followed by a write of '1', q_i MUST
 	 * become '1'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h20;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 1;
	stb_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i == 0) begin
		$display("FAIL 20: Q not 1 on write"); $finish;
	end

	/* Given a reset GPIA, followed by a set-bit of '1', q_i MUST
 	 * become '1'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h24;
	waitclk;
	rst_o <= 0;
	mode_o <= 1;
	d_o <= 1;
	stb_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i == 0) begin
		$display("FAIL 24: Q not 1 on set-bit"); $finish;
	end

	/* Given a reset GPIA, followed by a clr-bit of '1', q_i MUST
 	 * remain '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h28;
	waitclk;
	rst_o <= 0;
	mode_o <= 2;
	d_o <= 1;
	stb_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i == 1) begin
		$display("FAIL 28: a cleared Q must remain 0"); $finish;
	end

	/* Given a reset GPIA, followed by a tgl-bit of '1', q_i MUST
 	 * become '1'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h2C;
	waitclk;
	rst_o <= 0;
	mode_o <= 3;
	d_o <= 1;
	stb_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 1) begin
		$display("FAIL 2C: a cleared Q must toggle to 1"); $finish;
	end

	/* Given a reset GPIA with a set output bit,
	 * and followed by a write of '0', q_i MUST
 	 * reset to '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h30;
	waitclk;
	setq;
	d_o <= 0;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 30: Q must reset to 0"); $finish;
	end

	/* Given a reset GPIA with set output bit,
	 * followed by a set-bit of '0', q_i MUST
 	 * remain '1'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h34;
	waitclk;
	setq;
	d_o <= 0;
	mode_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 1) begin
		$display("FAIL 34: Q must remain 0"); $finish;
	end

	/* Given a reset GPIA with set output bit,
	 * followed by a clr-bit of '0', q_i MUST
 	 * remain '1'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h38;
	waitclk;
	setq;
	mode_o <= 2;
	d_o <= 0;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 1) begin
		$display("FAIL 38: Q must remain 1"); $finish;
	end

	/* Given a reset GPIA with set output bit,
	 * followed by a tgl-bit of '0', q_i MUST
 	 * remain '1'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h3C;
	waitclk;
	setq;
	mode_o <= 3;
	d_o <= 0;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 1) begin
		$display("FAIL 3C: Q must remain 1"); $finish;
	end

	/* Given a reset GPIA with set output bit,
	 * followed by a write of '1', q_i MUST
 	 * remain '1'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h40;
	waitclk;
	setq;
	mode_o <= 0;
	d_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i == 0) begin
		$display("FAIL 40: Q not 1 on write"); $finish;
	end

	/* Given a reset GPIA with set output bit,
	 * followed by a set-bit of '1', q_i MUST
 	 * remain '1'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h44;
	waitclk;
	setq;
	mode_o <= 1;
	d_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 1) begin
		$display("FAIL 44: Q not 1 on set-bit"); $finish;
	end

	/* Given a reset GPIA with set output bit,
	 * followed by a clr-bit of '1', q_i MUST
 	 * become '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h48;
	waitclk;
	setq;
	mode_o <= 2;
	d_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 48: a set Q must become 0"); $finish;
	end

	/* Given a reset GPIA with a set output bit,
	 * followed by a tgl-bit of '1', q_i MUST
 	 * become '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h4C;
	waitclk;
	setq;
	mode_o <= 3;
	d_o <= 1;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 4C: a set Q must toggle to 0"); $finish;
	end

	/* Given a reset GPIA with clear output bit,
	 * a reset STB input,
	 * followed by a write of '1', q_i MUST
 	 * remain '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h50;
	waitclk;
	mode_o <= 0;
	d_o <= 1;
	stb_o <= 0;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 50: Q shouldn't be affected on masked write"); $finish;
	end

	/* Given a reset GPIA with clear output bit,
	 * a reset STB input,
	 * followed by a set-bit of '1', q_i MUST
 	 * remain '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h54;
	waitclk;
	mode_o <= 1;
	d_o <= 1;
	stb_o <= 0;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 54: Q shouldn't be affected on masked write"); $finish;
	end

	/* Given a reset GPIA with clear output bit,
	 * a reset STB input,
	 * followed by a clear-bit of '1', q_i MUST
 	 * remain '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h58;
	waitclk;
	mode_o <= 2;
	d_o <= 1;
	stb_o <= 0;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 58: Q shouldn't be affected on masked write"); $finish;
	end

	/* Given a reset GPIA with clear output bit,
	 * a reset STB input,
	 * followed by a toggle of '1', q_i MUST
 	 * remain '0'.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h5C;
	waitclk;
	mode_o <= 0;
	d_o <= 1;
	stb_o <= 0;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 0) begin
		$display("FAIL 5C: Q shouldn't be affected on masked write"); $finish;
	end

	$display("PASS"); $finish;
end

endmodule
