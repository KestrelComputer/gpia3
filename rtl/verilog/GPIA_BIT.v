`timescale 1ns / 100ps

/* This test module works by tickling various inputs over a sequence of time.
 * Each test scenario is uniquely identified by a number on the `scenario_o`
 * bus.
 */

module GPIA_BIT(
	input	clk_i,
	input	res_i,
	input	[1:0] mode_i,
	input	d_i,
	input	stb_i,

	output	q_o
);

reg q_d;
assign q_o = q_d;

always @(posedge clk_i) begin
	if(res_i) begin
		q_d <= 0;
	end
	else begin
		if(stb_i) begin
			if(mode_i == 0) begin
				q_d <= d_i;
			end
			else if(mode_i == 1) begin
				q_d <= d_i ? 1 : q_d;
			end
			else if(mode_i == 2) begin
				q_d <= d_i ? 0 : q_d;
			end
			else if(mode_i == 3) begin
				q_d <= d_i ^ q_d;
			end
		end
	end
end
endmodule
