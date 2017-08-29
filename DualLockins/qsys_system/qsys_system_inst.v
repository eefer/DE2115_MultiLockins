	qsys_system u0 (
		.clk_clk             (<connected-to-clk_clk>),             //          clk.clk
		.gain_ctrl_export    (<connected-to-gain_ctrl_export>),    //    gain_ctrl.export
		.phase_incr_1_export (<connected-to-phase_incr_1_export>), // phase_incr_1.export
		.phase_incr_2_export (<connected-to-phase_incr_2_export>), // phase_incr_2.export
		.phase_offs_1_export (<connected-to-phase_offs_1_export>), // phase_offs_1.export
		.phase_offs_2_export (<connected-to-phase_offs_2_export>), // phase_offs_2.export
		.reset_reset_n       (<connected-to-reset_reset_n>),       //        reset.reset_n
		.resetrequest_reset  (<connected-to-resetrequest_reset>)   // resetrequest.reset
	);

