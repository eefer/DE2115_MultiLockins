
module qsys_system (
	clk_clk,
	gain_ctrl_export,
	phase_incr_1_export,
	phase_incr_2_export,
	phase_offs_1_export,
	phase_offs_2_export,
	reset_reset_n,
	resetrequest_reset);	

	input		clk_clk;
	output	[5:0]	gain_ctrl_export;
	output	[19:0]	phase_incr_1_export;
	output	[19:0]	phase_incr_2_export;
	output	[19:0]	phase_offs_1_export;
	output	[19:0]	phase_offs_2_export;
	input		reset_reset_n;
	output		resetrequest_reset;
endmodule
