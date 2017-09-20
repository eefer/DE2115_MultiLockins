
module qsys_system (
	clk_clk,
	gain_ctrl_export,
	lia_1_x_export,
	lia_1_y_export,
	phase_incr_1_export,
	phase_incr_2_export,
	phase_incr_3_export,
	phase_incr_4_export,
	phase_incr_5_export,
	phase_incr_6_export,
	phase_incr_7_export,
	phase_incr_8_export,
	phase_offs_1_export,
	phase_offs_2_export,
	phase_offs_3_export,
	phase_offs_4_export,
	phase_offs_5_export,
	phase_offs_6_export,
	phase_offs_7_export,
	phase_offs_8_export,
	reset_reset_n,
	resetrequest_reset);	

	input		clk_clk;
	output	[5:0]	gain_ctrl_export;
	input	[15:0]	lia_1_x_export;
	input	[15:0]	lia_1_y_export;
	output	[19:0]	phase_incr_1_export;
	output	[19:0]	phase_incr_2_export;
	output	[19:0]	phase_incr_3_export;
	output	[19:0]	phase_incr_4_export;
	output	[19:0]	phase_incr_5_export;
	output	[19:0]	phase_incr_6_export;
	output	[19:0]	phase_incr_7_export;
	output	[19:0]	phase_incr_8_export;
	output	[19:0]	phase_offs_1_export;
	output	[19:0]	phase_offs_2_export;
	output	[19:0]	phase_offs_3_export;
	output	[19:0]	phase_offs_4_export;
	output	[19:0]	phase_offs_5_export;
	output	[19:0]	phase_offs_6_export;
	output	[19:0]	phase_offs_7_export;
	output	[19:0]	phase_offs_8_export;
	input		reset_reset_n;
	output		resetrequest_reset;
endmodule
