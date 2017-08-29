	component qsys_system is
		port (
			clk_clk             : in  std_logic                     := 'X'; -- clk
			gain_ctrl_export    : out std_logic_vector(5 downto 0);         -- export
			phase_incr_1_export : out std_logic_vector(19 downto 0);        -- export
			phase_incr_2_export : out std_logic_vector(19 downto 0);        -- export
			phase_offs_1_export : out std_logic_vector(19 downto 0);        -- export
			phase_offs_2_export : out std_logic_vector(19 downto 0);        -- export
			reset_reset_n       : in  std_logic                     := 'X'; -- reset_n
			resetrequest_reset  : out std_logic                             -- reset
		);
	end component qsys_system;

	u0 : component qsys_system
		port map (
			clk_clk             => CONNECTED_TO_clk_clk,             --          clk.clk
			gain_ctrl_export    => CONNECTED_TO_gain_ctrl_export,    --    gain_ctrl.export
			phase_incr_1_export => CONNECTED_TO_phase_incr_1_export, -- phase_incr_1.export
			phase_incr_2_export => CONNECTED_TO_phase_incr_2_export, -- phase_incr_2.export
			phase_offs_1_export => CONNECTED_TO_phase_offs_1_export, -- phase_offs_1.export
			phase_offs_2_export => CONNECTED_TO_phase_offs_2_export, -- phase_offs_2.export
			reset_reset_n       => CONNECTED_TO_reset_reset_n,       --        reset.reset_n
			resetrequest_reset  => CONNECTED_TO_resetrequest_reset   -- resetrequest.reset
		);

