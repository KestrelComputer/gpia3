`timescale 1ns / 100ps

/* This test module works by tickling various inputs over a sequence of time.
 * If the output waveforms graphically, each test scenario is uniquely
 * identified by a number on the `scenario_o` bus.
 *
 * From the module under test:
 *
 * The GPIA_DWORD module describes a 64-bit collection of GPIA_BITs.  Each
 * octet of bits is selectively masked with its own stb_i input.  This
 * allows, for example, individual bytes, hwords, and words to be updated
 * independently of each other despite having a wide bus.
 *
 * See GPIA_BYTE or GPIA_BIT for more details.
 *
 * This module does NOT test bit-level semantics.  Since we compose _DWORD
 * from eight _BYTEs, we rely on _BYTE's tests to ensure correctness at
 * that level.  Rather, this module aims to verify proper behavior of the
 * stb_i inputs.
 */

module test_dword();

reg clk_o;
reg rst_o;
reg [7:0] scenario_o;
reg [1:0] mode_o;
reg [63:0] d_o;
reg [7:0] stb_o;

wire [63:0] q_i;

/* Device Under Test */

GPIA_DWORD dut (
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
		$display("FAIL 01: Q not $00"); $finish;
	end

	/* Given a reset GPIA,
	 * writing byte 0 with $3C should yield $000000000000003C as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h10;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b00000001;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h000000000000003C) begin
		$display("FAIL %x: Q must equal $000000000000003C", scenario_o); $finish;
	end

	/* Given a reset GPIA,
	 * writing byte 1 with $3C should yield $0000000000003C00 as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h14;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b00000010;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h0000000000003C00) begin
		$display("FAIL %x: Q must equal $0000000000003C00", scenario_o); $finish;
	end

	/* Given a reset GPIA,
	 * writing byte 2 with $3C should yield $00000000003C0000 as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h18;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b00000100;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h00000000003C0000) begin
		$display("FAIL %x: Q must equal $00000000003C0000", scenario_o); $finish;
	end

	/* Given a reset GPIA,
	 * writing byte 3 with $3C should yield $000000003C000000 as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h1C;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b00001000;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h000000003C000000) begin
		$display("FAIL %x: Q must equal $000000003C000000", scenario_o); $finish;
	end

	/* Given a reset GPIA,
	 * writing byte 4 with $3C should yield $0000003C00000000 as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h20;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b00010000;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h0000003C00000000) begin
		$display("FAIL %x: Q must equal $0000003C00000000", scenario_o); $finish;
	end

	/* Given a reset GPIA,
	 * writing byte 5 with $3C should yield $000000000000003C as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h24;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b00100000;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h00003C0000000000) begin
		$display("FAIL %x: Q must equal $00003C0000000000"); $finish;
	end

	/* Given a reset GPIA,
	 * writing byte 6 with $3C should yield $000000000000003C as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h28;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b01000000;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h003C000000000000) begin
		$display("FAIL %x: Q must equal $003C000000000000", scenario_o); $finish;
	end

	/* Given a reset GPIA,
	 * writing byte 7 with $3C should yield $3C00000000000000 as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h2C;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b10000000;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h3C00000000000000) begin
		$display("FAIL %x: Q must equal $3C00000000000000", scenario_o); $finish;
	end


	/* Given a reset GPIA,
	 * writing hword 0 with $3C3C should yield $0000000000003C3C as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h30;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b00000011;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h0000000000003C3C) begin
		$display("FAIL %x: Q must equal $0000000000003C3C", scenario_o); $finish;
	end

	/* Given a reset GPIA,
	 * writing hword 1 with $3C3C should yield $000000003C3C0000 as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h34;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b00001100;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h000000003C3C0000) begin
		$display("FAIL %x: Q must equal $000000003C3C0000", scenario_o); $finish;
	end

	/* Given a reset GPIA,
	 * writing hword 2 with $3C3C should yield $00003C3C00000000 as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h38;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b00110000;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h00003C3C00000000) begin
		$display("FAIL %x: Q must equal $00003C3C00000000", scenario_o); $finish;
	end

	/* Given a reset GPIA,
	 * writing hword 3 with $3C3C should yield $3C3C000000000000 as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h3C;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b11000000;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h3C3C000000000000) begin
		$display("FAIL %x: Q must equal $3C3C000000000000", scenario_o); $finish;
	end


	/* Given a reset GPIA,
	 * writing word 0 with $3C3C3C3C should yield $000000003C3C3C3C as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h40;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b00001111;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h000000003C3C3C3C) begin
		$display("FAIL %x: Q must equal $000000003C3C3C3C", scenario_o); $finish;
	end

	/* Given a reset GPIA,
	 * writing word 1 with $3C3C3C3C should yield $3C3C3C3C00000000 as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h44;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b11110000;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h3C3C3C3C00000000) begin
		$display("FAIL %x: Q must equal $3C3C3C3C00000000", scenario_o); $finish;
	end


	/* Given a reset GPIA,
	 * writing the full dword with $3C3C3C3C should yield $3C3C3C3C3C3C3C3C as output.
	 */

	waitclk;
	rst_o <= 1;
	scenario_o <= 8'h48;
	waitclk;
	rst_o <= 0;
	mode_o <= 0;
	d_o <= 64'h3C3C3C3C3C3C3C3C;
	stb_o <= 8'b11111111;
	waitclk;
	#2;	/* let simulation catch up */
	if(q_i != 64'h3C3C3C3C3C3C3C3C) begin
		$display("FAIL %x: Q must equal $3C3C3C3C3C3C3C3C", scenario_o); $finish;
	end


	$display("PASS"); $finish;
end

endmodule
