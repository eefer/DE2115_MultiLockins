
module qsys_system (
	clk_clk,
	dac_gain_export,
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
	resetrequest_reset,
	sram_conduit_DQ,
	sram_conduit_ADDR,
	sram_conduit_LB_N,
	sram_conduit_UB_N,
	sram_conduit_CE_N,
	sram_conduit_OE_N,
	sram_conduit_WE_N);	

	input		clk_clk;
	output	[7:0]	dac_gain_export;
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
	inout	[15:0]	sram_conduit_DQ;
	output	[19:0]	sram_conduit_ADDR;
	output		sram_conduit_LB_N;
	output		sram_conduit_UB_N;
	output		sram_conduit_CE_N;
	output		sram_conduit_OE_N;
	output		sram_conduit_WE_N;
endmodule
