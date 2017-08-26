-- DE2115_DualLockins_system.vhd
-- Sends drive signal to DAC, receives signals from ADC, 
--		and connects the rest of the design together
--
-- Erin E. Flater (2017) flater01@luther.edu
--
-- Based partially on max10_top.vhd by Jesse W. Wilson jesse.wilson@colostate.edu
-- and based partially on duallockinv2_02_sys.v by Erin Flater


LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;


ENTITY DE2115_DualLockins_system IS

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
		
		lia_out_valid 		: 	out 	std_logic;
			
		heartbeat_led		:	OUT	std_logic;
		
		overflow				: 	out 	std_logic
		

	);

end DE2115_DualLockins_system;

architecture arch of DE2115_DualLockins_system is

--
-- component declarations
--

	
	
	COMPONENT dual_lia_pkg IS
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
		lia_out_y_1 : out std_logic_vector(15 downto 0);	-- lock-in output signal for lockin_1
		lia_out_x_2 : out std_logic_vector(15 downto 0);	-- lock-in output signal for lockin_2
		lia_out_y_2 : out std_logic_vector(15 downto 0);	-- lock-in output signal for lockin_2
		
		-- cos drive signals to be sent to DAC
		dpll_cos_1	: out std_logic_vector(12 downto 0);	-- cosine reference signal for lockin_1
		dpll_cos_2	: out std_logic_vector(12 downto 0);	-- cosine reference signal for lockin_2
		
		-- control lines
--		out_sel_cycle_i	: in std_logic := '0';				-- rising edge causes output select to change
--		incr_phase_i		: in std_logic := '0';				-- rising edge causes phase to increment
	
--		lia_output_state  : out std_logic_vector(2 downto 0)

		overflow_dlia: out std_logic

	);
	END COMPONENT; -- dual_lia_pkg
	
	

	COMPONENT lpm_add IS
	PORT
	(
		dataa		: IN 	STD_LOGIC_VECTOR (13 DOWNTO 0);
		datab		: IN 	STD_LOGIC_VECTOR (13 DOWNTO 0);
		result	: OUT STD_LOGIC_VECTOR (13 DOWNTO 0)
	);
	END COMPONENT; -- lpm_add;
	

	
--
-- signal declarations
--
	
	
--	signal	lia_ref_1_in			: std_logic;		-- reference wave input for lockin_1
--	signal	lia_ref_2_in			: std_logic;		-- reference wave input for lockin_2
	signal	lia_ref_out				: std_logic;		-- PLL in-phase reference out


--	signal	llia_out_valid			: std_logic := '0';	-- Latched version of lock-in output clock, compatible with 30 MHz DAC serial clock
	

	signal 	cosine_1					:std_logic_vector(12 downto 0);	-- cosine reference signal for lockin_1
	signal 	cosine_2					:std_logic_vector(12 downto 0);	-- cosine reference signal for lockin_2
	
	signal 	i_cosine_1				:std_logic;								-- sign of cosine reference signal for lockin_1
	signal 	i_cosine_2				:std_logic;								-- sign of cosine reference signal for lockin_2
	
	signal 	s_cosine_1				:std_logic_vector(12 downto 0);	-- registered cosine reference signal from lockin_1
	signal 	s_cosine_2				:std_logic_vector(12 downto 0);	-- registered cosine reference signal from lockin_2

	signal 	u_cosine_1				:std_logic_vector(12 downto 0);	-- registered unsigned cosine reference signal from lockin_1
	signal 	u_cosine_2				:std_logic_vector(12 downto 0);	-- registered unsigned cosine reference signal from lockin_2
	
	signal 	reg_u_cosine_1			:std_logic_vector(12 downto 0);	-- registered unsigned cosine reference signal from lockin_1
	signal 	reg_u_cosine_2			:std_logic_vector(12 downto 0);	-- registered unsigned cosine reference signal from lockin_2
	
	signal 	add_u_cosine_1			:std_logic_vector(13 downto 0);	-- 14 bit unsigned cosine reference signal from lockin_1
	signal 	add_u_cosine_2			:std_logic_vector(13 downto 0);	-- 14 bit unsigned cosine reference signal from lockin_2
	
	signal 	p_cosines				:std_logic_vector(13 downto 0);	-- registered sum of cosines 
	signal 	n_cosines				:std_logic_vector(13 downto 0);	-- inverted registered sum of cosines 
	
	signal 	reg_adc_data			:std_logic_vector(13 downto 0);
	
	signal	adc_d						: std_logic_vector(13 downto 0);		-- ADC data
	
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
	
	dual_lia_inst : dual_lia_pkg
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
		
		dpll_cos_1			=> cosine_1,			-- cosine reference signal for lockin_1
		dpll_cos_2			=> cosine_2,				-- cosine reference signal for lockin_2
		
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
			s_cosine_1 <= cosine_1;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			s_cosine_2 <= cosine_2;
		end if;
	end process;
	

	i_cosine_1 <= not s_cosine_1(12);
	i_cosine_2 <= not s_cosine_2(12);
	
	u_cosine_1 <= i_cosine_1 & s_cosine_1(11 downto 0);	--Create unsigned cosine 1
	u_cosine_2 <= i_cosine_2 & s_cosine_2(11 downto 0);	--Create unsigned cosine 2
	

	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			reg_u_cosine_1 <= u_cosine_1;
		end if;
	end process;
	
		
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			reg_u_cosine_2 <= u_cosine_2;
		end if;
	end process;

	add_u_cosine_1 <= '0' & reg_u_cosine_1;		--Unsigned cosine 1 ready for addition
	add_u_cosine_2 <= '0' & reg_u_cosine_2;		--Unsigned cosine 2 ready for addition 
	
	sum_cosines : lpm_add
	port map(
		dataa		=>		add_u_cosine_1,
		datab		=>		add_u_cosine_2,
		result	=>		p_cosines
		
	);
	
	n_cosines <= not p_cosines;

		
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			reg_p_cosines <= p_cosines;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			reg_n_cosines <= n_cosines;
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