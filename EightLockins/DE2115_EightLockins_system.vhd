-- DE2115_DualLockins_system.vhd
-- Sends drive signal to DAC, receives signals from ADC, 
--		and connects the rest of the design together
--
-- Erin E. Flater (2017) flater01@luther.edu
--
-- Based partially on max10_top.vhd by Jesse W. Wilson jesse.wilson@colostate.edu
-- and based partially on duallockinv2_02_sys.v by Erin Flater
--
-- Modified by Arya Chowdhury Mugdha (2017) (arya.mugdha@colostate.edu)

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;



ENTITY DE2115_EightLockins_system IS

	port(
		-- Reset and Clocks
      clock_50				:	IN 	STD_LOGIC;
		fpga_resetn			:	IN		STD_LOGIC;
		
		-- ADC signals
		adc_data				:	IN		std_logic_vector(13 downto 0);	-- 14 bit data from the ADC
		adc_clk				:	IN		STD_LOGIC;								-- ADC clock
		
		-- DAC signals
		reg_p_cosines		:	OUT 	std_logic_vector(13 downto 0);	-- sum of cosines to be sent to the DAC
	 	reg_n_cosines		:	OUT 	std_logic_vector(13 downto 0);	-- inverted sum of cosines to be sent to the DAC
		
		-- LIA signals
		lia_out_x_1 		: 	out 	std_logic_vector(15 downto 0);	-- lock-in x output signal for lockin_1
		lia_out_y_1 		: 	out 	std_logic_vector(15 downto 0);	-- lock-in y output signal for lockin_1
		lia_out_x_2 		: 	out 	std_logic_vector(15 downto 0);	-- lock-in x output signal for lockin_2
		lia_out_y_2 		: 	out 	std_logic_vector(15 downto 0);	-- lock-in y output signal for lockin_2
		lia_out_x_3 		: 	out 	std_logic_vector(15 downto 0);	-- lock-in x output signal for lockin_2
		lia_out_y_3 		: 	out 	std_logic_vector(15 downto 0);
		lia_out_x_4 		: 	out 	std_logic_vector(15 downto 0);	-- lock-in x output signal for lockin_2
		lia_out_y_4 		: 	out 	std_logic_vector(15 downto 0);
		lia_out_x_5 		: 	out 	std_logic_vector(15 downto 0);	-- lock-in x output signal for lockin_2
		lia_out_y_5 		: 	out 	std_logic_vector(15 downto 0);
		lia_out_x_6 		: 	out 	std_logic_vector(15 downto 0);	-- lock-in x output signal for lockin_2
		lia_out_y_6 		: 	out 	std_logic_vector(15 downto 0);
		lia_out_x_7 		: 	out 	std_logic_vector(15 downto 0);	-- lock-in x output signal for lockin_2
		lia_out_y_7 		: 	out 	std_logic_vector(15 downto 0);
		lia_out_x_8 		: 	out 	std_logic_vector(15 downto 0);	-- lock-in x output signal for lockin_2
		lia_out_y_8 		: 	out 	std_logic_vector(15 downto 0);
		
		lia_out_valid 		: 	out 	std_logic;
			
		heartbeat_led		:	OUT	std_logic;
		
		overflow				: 	out 	std_logic
		

	);

end DE2115_EightLockins_system;

architecture arch of DE2115_EightLockins_system is

--
-- component declarations
--

	
	
	COMPONENT eight_lia_pkg IS
	PORT(
		sys_clk_i	: IN STD_LOGIC;								-- system clock (assumes 50MHz clock)
		areset_i		: IN STD_LOGIC;								-- asyncronous reset
		
		-- phase-locked loop signals
--		ref_1_i		: in  std_logic;		-- reference square wave input for lockin_1. This is passed to the PLL
--		ref_2_i		: in  std_logic;		-- reference square wave input for lockin_2. This is passed to the PLL
		ref_o			: out std_logic;		-- PLL output, square wave derived from in-phase cosine
		
		-- lock-in amplifier input and output signals
		samp_clk_i	: in std_logic;								-- sampling clock (1 MHz), ADC sampling rate
		input			: in std_logic_vector( 13 downto 0);	-- input signal (from ADC)
		samp_clk_o	: out std_logic;								-- output sampling clock (default 1 kHz) from the CIC filters
		
		lia_out_x_1 : out std_logic_vector(15 downto 0);	-- lock-in output signal for lockin_1
		lia_out_x_2 : out std_logic_vector(15 downto 0);	-- lock-in output signal for lockin_2
		lia_out_x_3 : out std_logic_vector(15 downto 0);
		lia_out_x_4 : out std_logic_vector(15 downto 0);
		lia_out_x_5 : out std_logic_vector(15 downto 0);
		lia_out_x_6 : out std_logic_vector(15 downto 0);
		lia_out_x_7 : out std_logic_vector(15 downto 0);
		lia_out_x_8 : out std_logic_vector(15 downto 0);
		
		lia_out_y_1 : out std_logic_vector(15 downto 0);	-- lock-in output signal for lockin_1
		lia_out_y_2 : out std_logic_vector(15 downto 0);	-- lock-in output signal for lockin_2
		lia_out_y_3 : out std_logic_vector(15 downto 0);
		lia_out_y_4 : out std_logic_vector(15 downto 0);
		lia_out_y_5 : out std_logic_vector(15 downto 0);
		lia_out_y_6 : out std_logic_vector(15 downto 0);
		lia_out_y_7 : out std_logic_vector(15 downto 0);
		lia_out_y_8 : out std_logic_vector(15 downto 0);
		-- cos drive signals to be sent to DAC
		dpll_cos_1	: out std_logic_vector(12 downto 0);	-- cosine reference signal for lockin_1
		dpll_cos_2	: out std_logic_vector(12 downto 0);	-- cosine reference signal for lockin_2
		dpll_cos_3	: out std_logic_vector(12 downto 0);
		dpll_cos_4	: out std_logic_vector(12 downto 0);
		dpll_cos_5	: out std_logic_vector(12 downto 0);
		dpll_cos_6	: out std_logic_vector(12 downto 0);
		dpll_cos_7	: out std_logic_vector(12 downto 0);
		dpll_cos_8	: out std_logic_vector(12 downto 0);
		
		-- TODO: EXPORT DAC GAIN CONTROL HERE
		dac_gain		: out std_logic_vector(7 downto 0);
		-- control lines
--		out_sel_cycle_i	: in std_logic := '0';				-- rising edge causes output select to change
--		incr_phase_i		: in std_logic := '0';				-- rising edge causes phase to increment
	
--		lia_output_state  : out std_logic_vector(2 downto 0)

		overflow_dlia: out std_logic

	);
	END COMPONENT; -- dual_lia_pkg
	
	

	
	
	COMPONENT eight_add IS
	PORT
	(
		data0x		: IN 	STD_LOGIC_VECTOR (12 DOWNTO 0);
		data1x		: IN 	STD_LOGIC_VECTOR (12 DOWNTO 0);
		data2x		: IN 	STD_LOGIC_VECTOR (12 DOWNTO 0);
		data3x		: IN 	STD_LOGIC_VECTOR (12 DOWNTO 0);
		data4x		: IN 	STD_LOGIC_VECTOR (12 DOWNTO 0);
		data5x		: IN 	STD_LOGIC_VECTOR (12 DOWNTO 0);
		data6x		: IN 	STD_LOGIC_VECTOR (12 DOWNTO 0);
		data7x		: IN 	STD_LOGIC_VECTOR (12 DOWNTO 0);
		result	   : OUT STD_LOGIC_VECTOR (20 DOWNTO 0)
	);
	END COMPONENT; 
	

	
--
-- signal declarations
--
	
	
--	signal	lia_ref_1_in			: std_logic;		-- reference wave input for lockin_1
--	signal	lia_ref_2_in			: std_logic;		-- reference wave input for lockin_2
	signal	lia_ref_out				: std_logic;		-- PLL in-phase reference out


--	signal	llia_out_valid			: std_logic := '0';	-- Latched version of lock-in output clock, compatible with 30 MHz DAC serial clock
	

	signal 	cosine_1					:std_logic_vector(12 downto 0);	-- cosine reference signal for lockin_1
	signal 	cosine_2					:std_logic_vector(12 downto 0);	-- cosine reference signal for lockin_2
	signal 	cosine_3					:std_logic_vector(12 downto 0);
	signal 	cosine_4					:std_logic_vector(12 downto 0);
	signal 	cosine_5					:std_logic_vector(12 downto 0);
	signal 	cosine_6					:std_logic_vector(12 downto 0);
	signal 	cosine_7					:std_logic_vector(12 downto 0);
	signal 	cosine_8					:std_logic_vector(12 downto 0);
	
	
	signal 	i_cosine_1				:std_logic;								-- sign of cosine reference signal for lockin_1
	signal 	i_cosine_2				:std_logic;								-- sign of cosine reference signal for lockin_2
	signal 	i_cosine_3				:std_logic;
	signal 	i_cosine_4				:std_logic;
	signal 	i_cosine_5				:std_logic;
	signal 	i_cosine_6				:std_logic;
	signal 	i_cosine_7				:std_logic;
	signal 	i_cosine_8				:std_logic;
	
	
	signal 	s_cosine_1				:std_logic_vector(12 downto 0);	-- registered cosine reference signal from lockin_1
	signal 	s_cosine_2				:std_logic_vector(12 downto 0);	-- registered cosine reference signal from lockin_2
	signal 	s_cosine_3				:std_logic_vector(12 downto 0);
	signal 	s_cosine_4				:std_logic_vector(12 downto 0);
	signal 	s_cosine_5				:std_logic_vector(12 downto 0);
	signal 	s_cosine_6				:std_logic_vector(12 downto 0);
	signal 	s_cosine_7				:std_logic_vector(12 downto 0);
	signal 	s_cosine_8				:std_logic_vector(12 downto 0);
	
	signal 	u_cosine_1				:std_logic_vector(12 downto 0);	-- registered unsigned cosine reference signal from lockin_1
	signal 	u_cosine_2				:std_logic_vector(12 downto 0);	-- registered unsigned cosine reference signal from lockin_2
	signal 	u_cosine_3				:std_logic_vector(12 downto 0);
	signal 	u_cosine_4				:std_logic_vector(12 downto 0);
	signal 	u_cosine_5				:std_logic_vector(12 downto 0);
	signal 	u_cosine_6				:std_logic_vector(12 downto 0);
	signal 	u_cosine_7				:std_logic_vector(12 downto 0);
	signal 	u_cosine_8				:std_logic_vector(12 downto 0);
		
	signal 	reg_u_cosine_1			:std_logic_vector(13 downto 0);	-- registered unsigned cosine reference signal from lockin_1
	signal 	reg_u_cosine_2			:std_logic_vector(12 downto 0);	-- registered unsigned cosine reference signal from lockin_2
	signal 	reg_u_cosine_3			:std_logic_vector(12 downto 0);
	signal 	reg_u_cosine_4			:std_logic_vector(12 downto 0);
	signal 	reg_u_cosine_5			:std_logic_vector(12 downto 0);
	signal 	reg_u_cosine_6			:std_logic_vector(12 downto 0);
	signal 	reg_u_cosine_7			:std_logic_vector(12 downto 0);
	signal 	reg_u_cosine_8			:std_logic_vector(12 downto 0);
	
	
	signal 	add_u_cosine_1			:std_logic_vector(13 downto 0);	-- 14 bit unsigned cosine reference signal from lockin_1
	signal 	add_u_cosine_2			:std_logic_vector(13 downto 0);	-- 14 bit unsigned cosine reference signal from lockin_2
	signal 	add_u_cosine_3			:std_logic_vector(13 downto 0);
	signal 	add_u_cosine_4			:std_logic_vector(13 downto 0);
	signal 	add_u_cosine_5			:std_logic_vector(13 downto 0);
	signal 	add_u_cosine_6			:std_logic_vector(13 downto 0);
	signal 	add_u_cosine_7			:std_logic_vector(13 downto 0);
	signal 	add_u_cosine_8			:std_logic_vector(13 downto 0);
	
	-- CHANGE 20171220 
	signal 	s_summed_cosines				: std_logic_vector(20 downto 0);	-- sum of signed cosine values, before gain block
	signal   dac_gain							: std_logic_vector(7 downto 0); 	-- DAC gain multiplier
	signal 	s_summed_cosines_gained		: signed(28 downto 0 );	-- summed cosines after gain block
	signal 	s_summed_cosines_gained_14	: signed(12 downto 0 );	-- summed cosines after gain block, 14-bit
	
	signal 	i_s_summed_cosines_gained_14	: std_logic;
	
	signal 	u_summed_cosines_gained_14	: std_logic_vector(13 downto 0 );
	
	signal 	p_cosines				:std_logic_vector(13 downto 0);	-- registered sum of cosines 
	signal 	n_cosines				:std_logic_vector(13 downto 0);	-- inverted registered sum of cosines 
	
	signal 	reg_adc_data			:std_logic_vector(13 downto 0);
	
	signal	adc_d						:std_logic_vector(13 downto 0);		-- ADC data
	
	signal	analog_to_digital_over_run :	std_logic;
	

	--signal output

	signal clk_1kHz					: std_logic;
	
	-- decimation clock
	signal clk_decimated				: std_logic;
	signal count_clk					: natural range 1 to 1000 := 1;
	signal heartbeat_1Hz				: std_logic;
	signal clk_100_dac_90			: std_logic;
	
begin

	-- blinking light (heartbeat)
	blinker : process( clock_50 )
		variable count : integer := 0;
		--variable led_on : std_logic := '0';
	begin
		if rising_edge( clock_50 ) then
			count := count + 1;
			if count > 25000000 then -- once every 1/4 second, on a 100 MHz clock
				count := 0;
				heartbeat_1Hz <= not heartbeat_1Hz;
				heartbeat_led <= heartbeat_1Hz;
			end if;
			
		end if;
	end process;



	--
	-- The lock-in amplifier!
	--
	
	eight_lia_inst : eight_lia_pkg
	port map (
		sys_clk_i			=> clock_50,			-- 50 MHz system clock
		areset_i				=> not fpga_resetn,		-- asynchronous reset line
		
--		ref_1_i				=> lia_ref_1_in,		-- reference wave in (to PLL)
--		ref_2_i				=> lia_ref_2_in,		-- reference wave in (to PLL)
		ref_o					=> lia_ref_out,		-- locked reference wave out (from PLL)
		
		samp_clk_i			=> adc_clk,				-- ADC sample clock (1 MHz)
		input					=> adc_d,				-- ADC output --> LIA input
		samp_clk_o			=> lia_out_valid,		-- LIA output sample clock (1 MHz or 1 kHz, depending on operating mode)
		
		lia_out_x_1 		=>	lia_out_x_1,		-- lock-in output signal for lockin_1
		lia_out_y_1 		=>	lia_out_y_1,		-- lock-in output signal for lockin_1
		lia_out_x_2 		=>	lia_out_x_2,		-- lock-in output signal for lockin_2
		lia_out_y_2 		=>	lia_out_y_2,		-- lock-in output signal for lockin_2
		lia_out_x_3 		=>	lia_out_x_3,		-- lock-in output signal for lockin_2
		lia_out_y_3 		=>	lia_out_y_3,	
		lia_out_x_4 		=>	lia_out_x_4,		-- lock-in output signal for lockin_2
		lia_out_y_4 		=>	lia_out_y_4,	
		lia_out_x_5 		=>	lia_out_x_5,		-- lock-in output signal for lockin_2
		lia_out_y_5 		=>	lia_out_y_5,	
		lia_out_x_6 		=>	lia_out_x_6,		-- lock-in output signal for lockin_2
		lia_out_y_6 		=>	lia_out_y_6,	
		lia_out_x_7 		=>	lia_out_x_7,		-- lock-in output signal for lockin_2
		lia_out_y_7 		=>	lia_out_y_7,	
		lia_out_x_8 		=>	lia_out_x_8,		-- lock-in output signal for lockin_2
		lia_out_y_8 		=>	lia_out_y_8,	
		
		
		
		dpll_cos_1			=> cosine_1,			-- cosine reference signal for lockin_1
		dpll_cos_2			=> cosine_2,				-- cosine reference signal for lockin_2
		dpll_cos_3			=> cosine_3,
		dpll_cos_4			=> cosine_4,
		dpll_cos_5			=> cosine_5,
		dpll_cos_6			=> cosine_6,
		dpll_cos_7			=> cosine_7,
		dpll_cos_8			=> cosine_8,
		
		overflow_dlia		=> overflow
		
--		out_sel_cycle_i	=> toggle_dac_out_sel,	-- cycles through output modes
--		incr_phase_i		=> do_phase_incr,			-- increments phase by 22.5 deg
--		ref_src_toggle_i	=> '0'	,					-- toggle reference source select
--		
--		lia_output_state	=> wavecap_ctl_to_cpu(8 downto 6)
	
	);
	
	--- register the 2 cosine signals coming out of dual_lia_pkg
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			-- CHANGE 20171220 
			-- s_cosine_1 <= 15 * signed(cosine_1);
			-- s_cosine_1_shifted <= std_logic_vector(s_cosine_1(15 downto 2) );
			s_cosine_1 <= cosine_1;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			s_cosine_2 <= cosine_2;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			s_cosine_3 <= cosine_3;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			s_cosine_4 <= cosine_4;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			s_cosine_5 <= cosine_5;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			s_cosine_6 <= cosine_6;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			s_cosine_7 <= cosine_7;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			s_cosine_8 <= cosine_8;
		end if;
	end process;
	
	-- CHANGE 20171220
	
	-- sum of cosines
	
		sum_cosines : eight_add
	port map(
		data0x	=>	s_cosine_1,
		data1x	=>	s_cosine_2,
		data2x	=>	s_cosine_3,
		data3x	=>	s_cosine_4,
		data4x	=>	s_cosine_5,
		data5x	=>	s_cosine_6,
		data6x	=>	s_cosine_7,
		data7x	=>	s_cosine_8,
	   result	=>	s_summed_cosines
		);
	
--	process( clock_50 )
--	begin	
--		if rising_edge(clock_50) then
--			s_summed_cosines <= signed(s_cosine_1) + signed(s_cosine_2) + signed(s_cosine_3) + signed(s_cosine_4) + signed(s_cosine_5) + signed(s_cosine_6) + signed(s_cosine_7) + signed(s_cosine_8);
--		end if;
--	end process;
	
	-- gain block
	-- WARNING: NO OVERFLOW INDICATOR
	process( clock_50 )
	begin	
		if rising_edge(clock_50) then
			s_summed_cosines_gained  <= signed(dac_gain) * signed(s_summed_cosines);
			s_summed_cosines_gained_14  <=  s_summed_cosines_gained(23 downto 11);
		end if;
	end process;
	
	-- TODO: convert s_summed_cosines_gained_15 to signed-offset format
	-- then pass to DAC
	
	i_s_summed_cosines_gained_14 <= not s_summed_cosines_gained_14(12);
	
--	
--	i_cosine_1 <= not s_cosine_1_shifted(13);
--	i_cosine_2 <= not s_cosine_2(12);
--	i_cosine_3 <= not s_cosine_3(12);
--	i_cosine_4 <= not s_cosine_4(12);
--	i_cosine_5 <= not s_cosine_5(12);
--	i_cosine_6 <= not s_cosine_6(12);
--	i_cosine_7 <= not s_cosine_7(12);
--	i_cosine_8 <= not s_cosine_8(12);
	
	u_summed_cosines_gained_14 <= i_s_summed_cosines_gained_14 & std_logic_vector(s_summed_cosines_gained_14);
	
--	u_cosine_1 <= i_cosine_1 & s_cosine_1(11 downto 0);	--Create unsigned cosine 1
--	u_cosine_2 <= i_cosine_2 & s_cosine_2(11 downto 0);	--Create unsigned cosine 2
--	u_cosine_3 <= i_cosine_3 & s_cosine_3(11 downto 0);
--	u_cosine_4 <= i_cosine_4 & s_cosine_4(11 downto 0);
--	u_cosine_5 <= i_cosine_5 & s_cosine_5(11 downto 0);
--	u_cosine_6 <= i_cosine_6 & s_cosine_6(11 downto 0);
--	u_cosine_7 <= i_cosine_7 & s_cosine_7(11 downto 0);
--	u_cosine_8 <= i_cosine_8 & s_cosine_8(11 downto 0);

	
--	process(clock_50)
--	begin	
--		if rising_edge(clock_50) then
--			reg_u_cosine_1 <= u_cosine_1 ;
--		end if;
--	end process;
--	
--		
--	process(clock_50)
--	begin	
--		if rising_edge(clock_50) then
--			reg_u_cosine_2 <= u_cosine_2;
--		end if;
--	end process;
--	
--	process(clock_50)
--	begin	
--		if rising_edge(clock_50) then
--			reg_u_cosine_3 <= u_cosine_3;
--		end if;
--	end process;
--	
--	process(clock_50)
--	begin	
--		if rising_edge(clock_50) then
--			reg_u_cosine_4 <= u_cosine_4;
--		end if;
--	end process;
--	
--	process(clock_50)
--	begin	
--		if rising_edge(clock_50) then
--			reg_u_cosine_5 <= u_cosine_5;
--		end if;
--	end process;
--	
--	process(clock_50)
--	begin	
--		if rising_edge(clock_50) then
--			reg_u_cosine_6 <= u_cosine_6;
--		end if;
--	end process;
--	
--	process(clock_50)
--	begin	
--		if rising_edge(clock_50) then
--			reg_u_cosine_7 <= u_cosine_7;
--		end if;
--	end process;
--	
--	process(clock_50)
--	begin	
--		if rising_edge(clock_50) then
--			reg_u_cosine_8 <= u_cosine_8;
--		end if;
--	end process;

--	add_u_cosine_1 <=  reg_u_cosine_1 & '00';
--	add_u_cosine_1 <=  reg_u_cosine_1;		--Unsigned cosine 1 ready for addition
--	add_u_cosine_2 <= '0' & reg_u_cosine_2;		--Unsigned cosine 2 ready for addition 
--	add_u_cosine_3 <= '0' & reg_u_cosine_3;
--	add_u_cosine_4 <= '0' & reg_u_cosine_4;
--	add_u_cosine_5 <= '0' & reg_u_cosine_5;
--	add_u_cosine_6 <= '0' & reg_u_cosine_6;
--	add_u_cosine_7 <= '0' & reg_u_cosine_7;
--	add_u_cosine_8 <= '0' & reg_u_cosine_8;
	
--	
--	sum_cosines : lpm_add
--	port map(
--		dataa		=>		add_u_cosine_1,
--		datab		=>		add_u_cosine_2,
--		result	=>		p_cosines
--		
--	);
	
--	sum_cosines : eight_add
--	port map(
--		data0x	=>	add_u_cosine_1,
--		data1x	=>	add_u_cosine_2,
--		data2x	=>	add_u_cosine_3,
--		data3x	=>	add_u_cosine_4,
--		data4x	=>	add_u_cosine_5,
--		data5x	=>	add_u_cosine_6,
--		data6x	=>	add_u_cosine_7,
--		data7x	=>	add_u_cosine_8,
--	--   result	=>		p_cosines
--		);
	
	
	p_cosines  <= u_summed_cosines_gained_14;
	
	n_cosines <= not p_cosines;

		
--	process(clock_50)
--	begin	
--		if rising_edge(clock_50) then
--			reg_p_cosines <= p_cosines(16 downto 3); 
--		end if;
--	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			reg_p_cosines <=  p_cosines ; 
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			reg_n_cosines <=  n_cosines;
		end if;
	end process;
	
	process(adc_clk)
	begin	
		if rising_edge(adc_clk) then
			reg_adc_data <= adc_data;
		end if;
	end process;	

	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			adc_d <= reg_adc_data;
		end if;
	end process;
	
	
	
	
	--- 1kHz clock
--	
--	clock_process : process( adc_clk )
--	
--	begin 
--		
--		if( rising_edge( adc_clk ) ) then
--		
--			if( count_clk = 10 ) then
--			
--				count_clk <= 1;
--				clk_decimated <= '1';
--				
--			else
--			
--				count_clk <= count_clk + 1;
--				clk_decimated	<= '0';	
--				
--			end if;
--		end if;
--	end process;
--	
--	clk_1kHz <= clk_decimated;

	
--NOTE: lia_out_x_1 	and lia_out_x_2 and lia_out_y_1 	and lia_out_y_2 eventually can get sent to the niosii processor to be processed
--	MAKE NIOS II PROCESSOR HERE
	
	
	
	

end arch;