	component qsys_system is
		port (
			clk_clk             : in  std_logic                     := 'X';             -- clk
			gain_ctrl_export    : out std_logic_vector(5 downto 0);                     -- export
			lia_1_x_export      : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			lia_1_y_export      : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			phase_incr_1_export : out std_logic_vector(19 downto 0);                    -- export
			phase_incr_2_export : out std_logic_vector(19 downto 0);                    -- export
			phase_incr_3_export : out std_logic_vector(19 downto 0);                    -- export
			phase_incr_4_export : out std_logic_vector(19 downto 0);                    -- export
			phase_incr_5_export : out std_logic_vector(19 downto 0);                    -- export
			phase_incr_6_export : out std_logic_vector(19 downto 0);                    -- export
			phase_incr_7_export : out std_logic_vector(19 downto 0);                    -- export
			phase_incr_8_export : out std_logic_vector(19 downto 0);                    -- export
			phase_offs_1_export : out std_logic_vector(19 downto 0);                    -- export
			phase_offs_2_export : out std_logic_vector(19 downto 0);                    -- export
			phase_offs_3_export : out std_logic_vector(19 downto 0);                    -- export
			phase_offs_4_export : out std_logic_vector(19 downto 0);                    -- export
			phase_offs_5_export : out std_logic_vector(19 downto 0);                    -- export
			phase_offs_6_export : out std_logic_vector(19 downto 0);                    -- export
			phase_offs_7_export : out std_logic_vector(19 downto 0);                    -- export
			phase_offs_8_export : out std_logic_vector(19 downto 0);                    -- export
			reset_reset_n       : in  std_logic                     := 'X';             -- reset_n
			resetrequest_reset  : out std_logic                                         -- reset
		);
	end component qsys_system;

	u0 : component qsys_system
		port map (
			clk_clk             => CONNECTED_TO_clk_clk,             --          clk.clk
			gain_ctrl_export    => CONNECTED_TO_gain_ctrl_export,    --    gain_ctrl.export
			lia_1_x_export      => CONNECTED_TO_lia_1_x_export,      --      lia_1_x.export
			lia_1_y_export      => CONNECTED_TO_lia_1_y_export,      --      lia_1_y.export
			phase_incr_1_export => CONNECTED_TO_phase_incr_1_export, -- phase_incr_1.export
			phase_incr_2_export => CONNECTED_TO_phase_incr_2_export, -- phase_incr_2.export
			phase_incr_3_export => CONNECTED_TO_phase_incr_3_export, -- phase_incr_3.export
			phase_incr_4_export => CONNECTED_TO_phase_incr_4_export, -- phase_incr_4.export
			phase_incr_5_export => CONNECTED_TO_phase_incr_5_export, -- phase_incr_5.export
			phase_incr_6_export => CONNECTED_TO_phase_incr_6_export, -- phase_incr_6.export
			phase_incr_7_export => CONNECTED_TO_phase_incr_7_export, -- phase_incr_7.export
			phase_incr_8_export => CONNECTED_TO_phase_incr_8_export, -- phase_incr_8.export
			phase_offs_1_export => CONNECTED_TO_phase_offs_1_export, -- phase_offs_1.export
			phase_offs_2_export => CONNECTED_TO_phase_offs_2_export, -- phase_offs_2.export
			phase_offs_3_export => CONNECTED_TO_phase_offs_3_export, -- phase_offs_3.export
			phase_offs_4_export => CONNECTED_TO_phase_offs_4_export, -- phase_offs_4.export
			phase_offs_5_export => CONNECTED_TO_phase_offs_5_export, -- phase_offs_5.export
			phase_offs_6_export => CONNECTED_TO_phase_offs_6_export, -- phase_offs_6.export
			phase_offs_7_export => CONNECTED_TO_phase_offs_7_export, -- phase_offs_7.export
			phase_offs_8_export => CONNECTED_TO_phase_offs_8_export, -- phase_offs_8.export
			reset_reset_n       => CONNECTED_TO_reset_reset_n,       --        reset.reset_n
			resetrequest_reset  => CONNECTED_TO_resetrequest_reset   -- resetrequest.reset
		);

