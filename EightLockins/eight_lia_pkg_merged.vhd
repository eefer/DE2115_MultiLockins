-- eight_lia_pkg_merged.vhd
-- 
--	Sends drive signal to DAC, receives signals from ADC, and
--		merges 8 lock-in amplifiers and a qsys system to control lock-in variables
--	
--
-- Erin E. Flater (2017,2018) flater01@luther.edu
--
-- Based partially on max10_top.vhd and m10_lia_pkg.vhd by Jesse W. Wilson jesse.wilson@colostate.edu
-- and based partially on duallockinv2_02_sys.v by Erin Flater
--
-- Modified by Arya Chowdhury Mugdha (2017) (arya.mugdha@colostate.edu)
--
--		This file is a merge of eight_lia_pkg.vhd and DE2115_EightLockins_system.vhd on 1/26/18 by E. Flater.

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;



ENTITY eight_lia_pkg_merged IS

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
		
		overflow				: 	out 	std_logic								-- indicates overflow of any of the lock-ins
		

	);

end eight_lia_pkg_merged;

architecture arch of eight_lia_pkg_merged is

--
-- component declarations
--

	
			component lia_core is
			PORT(
						sys_clk_i		: IN STD_LOGIC;								-- system clock (assumed 50 MHz)
						areset_i 		: IN STD_LOGIC;								-- asyncronous reset in
						
						-- phase-locked loop signals
						
--						ref_i				: in std_logic;								-- reference square wave input, which is passed to the PLL
						phase_offs_i	: in std_logic_vector(19 downto 0);		-- reference phase offset
						phase_incr_i	: in	std_logic_vector(19 downto 0);	-- phase increment for internal reference
						ref_cos_o		: out std_logic_vector(12 downto 0);	-- PLL-generated reference cosine (in-phase)
						ref_sin_o		: out std_logic_vector(12 downto 0);	-- PLL-generated reference sine (quadrature)
						dpll_ref			: out std_logic_vector(12 downto 0);	-- PLL-generated reference waveform
						
						-- lock-in amplifier input and output signals
						samp_clk_i		: in std_logic;								-- sampling clock (1 MHz) from the ADC
						input				: in std_logic_vector( 13 downto 0);	-- input signal. This is mixed with the PLL-generated reference
						samp_clk_o		: out std_logic;								-- output sampling clock (100 kHz?) from the CIC filters
						out_x				: out std_logic_vector(15 downto 0);	-- in-phase lock-in output signal
						out_y				: out std_logic_vector(15 downto 0);	-- quadrature lock-in output signal
						
						-- other options
--						cic_x_in_sel_i	: in natural range 0 to 1 := 0		-- CIC filter x input select
																							--  0: in-phase mixer (default)
																							--  1: input
						gain_ctrl		: in std_logic_vector (5 downto 0);
						overflow_lia	: out std_logic
			); 
			end component; -- lia_core
			
			
			
					
			component qsys_system is
			port (
						clk_clk             : in  std_logic                     := 'X'; 	--          clk.clk
						phase_incr_1_export : out std_logic_vector(19 downto 0);        	-- phase_incr_1.export
						phase_incr_2_export : out std_logic_vector(19 downto 0);        	-- phase_incr_2.export
						phase_incr_3_export : out std_logic_vector(19 downto 0);
						phase_incr_4_export : out std_logic_vector(19 downto 0);
						phase_incr_5_export : out std_logic_vector(19 downto 0);
						phase_incr_6_export : out std_logic_vector(19 downto 0);
						phase_incr_7_export : out std_logic_vector(19 downto 0);
						phase_incr_8_export : out std_logic_vector(19 downto 0);
						
						phase_offs_1_export : out std_logic_vector(19 downto 0);				-- phase_offs_1.export
						phase_offs_2_export : out std_logic_vector(19 downto 0);				-- phase_offs_2.export
						phase_offs_3_export : out std_logic_vector(19 downto 0);
						phase_offs_4_export : out std_logic_vector(19 downto 0);
						phase_offs_5_export : out std_logic_vector(19 downto 0);
						phase_offs_6_export : out std_logic_vector(19 downto 0);
						phase_offs_7_export : out std_logic_vector(19 downto 0);
						phase_offs_8_export : out std_logic_vector(19 downto 0);
						
						lia_1_x_export		  : in std_logic_vector(15 downto 0);
						lia_1_y_export		  : in std_logic_vector(15 downto 0);
						gain_ctrl_export	  : out std_logic_vector (5 downto 0);
						dac_gain_export	  : out std_logic_vector (7 downto 0);
						dac_div_export		  : out std_logic_vector (7 downto 0);
						-- TODO: NEED TO ADD DAC GAIN CONTROL EXPORT
						
						reset_reset_n       : in  std_logic                     := 'X'; 	--        reset.reset_n
						resetrequest_reset  : out std_logic                             	-- resetrequest.reset
			);
			end component; -- qsys_system
			
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
-- signal declarations (from DE2115_EightLockins_system.vhd before merge)
--

	signal	lia_ref_out				: std_logic;		-- PLL in-phase reference out
	

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
	
	attribute 	keep : boolean;  -- used to keep quartus from synthesizing away nodes I want to debug

	
	signal 	s_summed_cosines				: std_logic_vector(20 downto 0);	-- sum of signed cosine values, before gain block
	attribute keep  of s_summed_cosines : signal is true;
	
	
	signal	signed_res_cosines			: signed(20 downto 0);
	
	signal   dac_mult_in_integer			: natural range 1 to 128; 	-- DAC gain multiplier
	
	signal   div								: natural range 1 to 128;  -- DAC gain divider 
	
	signal 	s_summed_cosines_gained		: signed(41 downto 0 );	-- summed cosines after gain block
	attribute keep  of s_summed_cosines_gained : signal is true;
	
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
			
	
	--
	-- signal declarations (from eight_lia_pkg.vhd before merge)
	--
	
		
		-- push-button phase increment (22.5 deg, or 16 increments per 360-deg)
		signal	incr_phase_amount		: unsigned(19 downto 0) := to_unsigned(65536,20);
		
		signal 	incr_phase_prev		: std_logic := '0';	-- used to sense rising edge of incr_phase_i
		
--				
		-- lock-in outputs
		signal lia_out_samp_clk_1	: std_logic;							-- output sample clock
		signal lia_out_samp_clk_2	: std_logic;							-- output sample clock
		signal lia_out_samp_clk_3	: std_logic;
		signal lia_out_samp_clk_4	: std_logic;
		signal lia_out_samp_clk_5	: std_logic;
		signal lia_out_samp_clk_6	: std_logic;
		signal lia_out_samp_clk_7	: std_logic;
		signal lia_out_samp_clk_8	: std_logic;

		signal ref_cos_o_1			: std_logic_vector(12 downto 0);
		signal ref_sin_o_1			: std_logic_vector(12 downto 0);
		signal ref_cos_o_2			: std_logic_vector(12 downto 0);
		signal ref_sin_o_2			: std_logic_vector(12 downto 0);
		signal ref_cos_o_3			: std_logic_vector(12 downto 0);
		signal ref_sin_o_3			: std_logic_vector(12 downto 0);
		signal ref_cos_o_4			: std_logic_vector(12 downto 0);
		signal ref_sin_o_4			: std_logic_vector(12 downto 0);
		signal ref_cos_o_5			: std_logic_vector(12 downto 0);
		signal ref_sin_o_5			: std_logic_vector(12 downto 0);
		signal ref_cos_o_6			: std_logic_vector(12 downto 0);
		signal ref_sin_o_6			: std_logic_vector(12 downto 0);
		signal ref_cos_o_7			: std_logic_vector(12 downto 0);
		signal ref_sin_o_7			: std_logic_vector(12 downto 0);
		signal ref_cos_o_8			: std_logic_vector(12 downto 0);
		signal ref_sin_o_8			: std_logic_vector(12 downto 0);
		
		signal dpll_lia_ref_o_1		: std_logic_vector(12 downto 0);
		signal dpll_lia_ref_o_2		: std_logic_vector(12 downto 0);
		signal dpll_lia_ref_o_3		: std_logic_vector(12 downto 0);
		signal dpll_lia_ref_o_4		: std_logic_vector(12 downto 0);
		signal dpll_lia_ref_o_5		: std_logic_vector(12 downto 0);
		signal dpll_lia_ref_o_6		: std_logic_vector(12 downto 0);
		signal dpll_lia_ref_o_7		: std_logic_vector(12 downto 0);
		signal dpll_lia_ref_o_8		: std_logic_vector(12 downto 0);
		
		-- user-specified phase incr value (sets the frequency) for digital PLL signals sent to the IQ mixers. Set in qsys_system.
		signal phase_incr_1			: std_logic_vector(19 downto 0);
		signal phase_incr_2			: std_logic_vector(19 downto 0);
		signal phase_incr_3			: std_logic_vector(19 downto 0);
		signal phase_incr_4			: std_logic_vector(19 downto 0);
		signal phase_incr_5			: std_logic_vector(19 downto 0);
		signal phase_incr_6			: std_logic_vector(19 downto 0);
		signal phase_incr_7			: std_logic_vector(19 downto 0);
		signal phase_incr_8			: std_logic_vector(19 downto 0);
		
		-- user-specified phase offset between digital PLL and waveforms sent to the IQ mixers. Set in qsys_system.
		signal phase_offs_1			: std_logic_vector(19 downto 0);
		signal phase_offs_2			: std_logic_vector(19 downto 0);
		signal phase_offs_3			: std_logic_vector(19 downto 0);
		signal phase_offs_4			: std_logic_vector(19 downto 0);
		signal phase_offs_5			: std_logic_vector(19 downto 0);
		signal phase_offs_6			: std_logic_vector(19 downto 0);
		signal phase_offs_7			: std_logic_vector(19 downto 0);
		signal phase_offs_8			: std_logic_vector(19 downto 0);
		
																					
		signal resetrequest	: std_logic;		-- qsys output that indicates if system needs to be reset
		
		signal gain_ctrl_tx	:	std_logic_vector(5 downto 0);
		
		signal overflow_lia_1: std_logic;
		signal overflow_lia_2: std_logic;
		signal overflow_lia_3: std_logic;
		signal overflow_lia_4: std_logic;
		signal overflow_lia_5: std_logic;
		signal overflow_lia_6: std_logic;
		signal overflow_lia_7: std_logic;
		signal overflow_lia_8: std_logic;
		
		signal lia_out_x_1_tx: 		std_logic_vector(15 downto 0);
		signal lia_out_y_1_tx: 		std_logic_vector(15 downto 0);
		signal dac_mult_in	:	  	std_logic_vector(7 downto 0);
		signal dac_mult_in_signed	:	  	signed(7 downto 0);
		
		attribute keep  of dac_mult_in : signal is true;
		attribute keep  of dac_mult_in_signed : signal is true;
		
		signal dac_div_in	:	  	std_logic_vector(7 downto 0);
		signal dac_div_in_signed	:	  	signed(7 downto 0);
		
		attribute keep  of dac_div_in : signal is true;
		attribute keep  of dac_div_in_signed : signal is true;
		
		signal control_bits	:	std_logic_vector(7 downto 0) := (others => '0');
	
	
BEGIN
	

	overflow	<=	overflow_lia_1 or overflow_lia_2 or overflow_lia_3 or overflow_lia_4 or overflow_lia_5 or overflow_lia_6 or overflow_lia_7 or overflow_lia_8;
	
	
	-- export signals
	cosine_1 <= dpll_lia_ref_o_1;
	cosine_2 <= dpll_lia_ref_o_2;
	cosine_3 <= dpll_lia_ref_o_3;
	cosine_4 <= dpll_lia_ref_o_4;
	cosine_5 <= dpll_lia_ref_o_5;
	cosine_6 <= dpll_lia_ref_o_6;
	cosine_7 <= dpll_lia_ref_o_7;
	cosine_8 <= dpll_lia_ref_o_8;
--	ref_o <= dpll_lia_ref_o_1(12);	-- for synchronization (use last bit so 1 for half the cycle)	
	


	

	
	-- the lock-in core
	lockin_1 : lia_core
	port map (
		sys_clk_i		=> clock_50,
		areset_i			=> not fpga_resetn,
		
--		ref_i				=> ref_1_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_1,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_1,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_1,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_1,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_1,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> adc_clk,				-- forward sample clock from ADC		
		input				=> adc_d,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_valid,				-- lock-in output sample clock
		out_x				=> lia_out_x_1,			-- direct x output to internal signal line
		out_y			   => lia_out_y_1,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_1
--		cic_x_in_sel_i	=> cic_x_in_sel

		
	);
	
		-- the lock-in core
	lockin_2 : lia_core
	port map (
		sys_clk_i		=> clock_50,
		areset_i			=> not fpga_resetn,
		
--		ref_i				=> ref_2_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_2,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_2,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_2,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_2,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_2,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> adc_clk,				-- forward sample clock from ADC		
		input				=> adc_d,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_2,	-- lock-in output sample clock
		out_x				=> lia_out_x_2,			-- direct x output to internal signal line
		out_y				=> lia_out_y_2,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_2
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_3 : lia_core
	port map (
		sys_clk_i		=> clock_50,
		areset_i			=> not fpga_resetn,
		
--		ref_i				=> ref_3_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_3,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_3,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_3,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_3,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_3,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> adc_clk,				-- forward sample clock from ADC		
		input				=> adc_d,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_3,	-- lock-in output sample clock
		out_x				=> lia_out_x_3,			-- direct x output to internal signal line
		out_y				=> lia_out_y_3,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_3
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_4 : lia_core
	port map (
		sys_clk_i		=> clock_50,
		areset_i			=> not fpga_resetn,
		
--		ref_i				=> ref_4_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_4,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_4,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_4,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_4,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_4,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> adc_clk,				-- forward sample clock from ADC		
		input				=> adc_d,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_4,	-- lock-in output sample clock
		out_x				=> lia_out_x_4,			-- direct x output to internal signal line
		out_y				=> lia_out_y_4,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_4
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_5 : lia_core
	port map (
		sys_clk_i		=> clock_50,
		areset_i			=> not fpga_resetn,
		
--		ref_i				=> ref_5_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_5,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_5,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_5,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_5,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_5,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> adc_clk,				-- forward sample clock from ADC		
		input				=> adc_d,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_5,	-- lock-in output sample clock
		out_x				=> lia_out_x_5,			-- direct x output to internal signal line
		out_y				=> lia_out_y_5,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_5
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_6 : lia_core
	port map (
		sys_clk_i		=> clock_50,
		areset_i			=> not fpga_resetn,
		
--		ref_i				=> ref_6_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_6,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_6,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_6,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_6,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_6,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> adc_clk,				-- forward sample clock from ADC		
		input				=> adc_d,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_6,	-- lock-in output sample clock
		out_x				=> lia_out_x_6,			-- direct x output to internal signal line
		out_y				=> lia_out_y_6,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_6
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_7 : lia_core
	port map (
		sys_clk_i		=> clock_50,
		areset_i			=> not fpga_resetn,
		
--		ref_i				=> ref_7_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_7,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_7,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_7,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_7,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_7,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> adc_clk,				-- forward sample clock from ADC		
		input				=> adc_d,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_7,	-- lock-in output sample clock
		out_x				=> lia_out_x_7,			-- direct x output to internal signal line
		out_y				=> lia_out_y_7,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_7
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_8 : lia_core
	port map (
		sys_clk_i		=> clock_50,
		areset_i			=> not fpga_resetn,
		
--		ref_i				=> ref_8_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_8,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_8,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_8,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_8,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_8,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> adc_clk,				-- forward sample clock from ADC		
		input				=> adc_d,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_8,	-- lock-in output sample clock
		out_x				=> lia_out_x_8,			-- direct x output to internal signal line
		out_y				=> lia_out_y_8,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_8
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	
	qsys : qsys_system
	port map(
		clk_clk             => clock_50, 		--          clk.clk
		phase_incr_1_export => phase_incr_1,   -- phase_incr_1.export
		phase_incr_2_export => phase_incr_2,	-- phase_incr_2.export
		phase_incr_3_export => phase_incr_3,
		phase_incr_4_export => phase_incr_4,
		phase_incr_5_export => phase_incr_5,
		phase_incr_6_export => phase_incr_6,
		phase_incr_7_export => phase_incr_7,
		phase_incr_8_export => phase_incr_8,
		
		
		phase_offs_1_export => phase_offs_1,	-- phase_offs_1.export
		phase_offs_2_export => phase_offs_2,	-- phase_offs_2.export
		phase_offs_3_export => phase_offs_3,
		phase_offs_4_export => phase_offs_4,
		phase_offs_5_export => phase_offs_5,
		phase_offs_6_export => phase_offs_6,
		phase_offs_7_export => phase_offs_7,
		phase_offs_8_export => phase_offs_8,
		
		lia_1_x_export		  => lia_out_x_1_tx,
		lia_1_y_export		  => lia_out_y_1_tx,
		
		dac_gain_export	  => dac_mult_in,
		dac_div_export		  => dac_div_in,
		gain_ctrl_export	  => gain_ctrl_tx,
		reset_reset_n       => fpga_resetn,   	--        reset.reset_n
		resetrequest_reset  => resetrequest    -- resetrequest.reset
	);



	
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



	--- register the 8 cosine signals coming out of eight_lia_pkg
	
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
			if (control_bits(5) = '1') then
				s_cosine_6 <= cosine_6;
			
			else 
				s_cosine_6 <= (others => '0');
				
			end if;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			if (control_bits(6) = '1') then
				s_cosine_7 <= cosine_7;
			
			else 
				s_cosine_7 <= (others => '0');
				
			end if;
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
			if (control_bits(7) = '1') then
				s_cosine_8 <= cosine_8;
			
			else 
				s_cosine_8 <= (others => '0');
				
			end if;
				
		end if;
	end process;
	
	-- CHANGE 20171220
	
	-- sum of cosines
	
		sum_cosines : eight_add
	port map(
		data0x	=>	s_cosine_1 ,
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
	
	
	process(clock_50)
	
	begin	
		
		if rising_edge(clock_50) then
	
			dac_mult_in_signed		<=		signed(dac_mult_in);
			
			dac_mult_in_integer		<= 	to_integer(dac_mult_in_signed);
			
			dac_div_in_signed		   <=		signed(dac_div_in);
			
			div		<= 	to_integer(dac_div_in_signed);
			
	
		end if;
	end process;
	
	process(clock_50)
	begin	
		if rising_edge(clock_50) then
		
	signed_res_cosines <= signed(s_summed_cosines);

	s_summed_cosines_gained  <=  dac_mult_in_integer * signed_res_cosines;  -- multiply with variable gain
	
	s_summed_cosines_gained_14  <=  signed(s_summed_cosines_gained((41-29+div) downto div));  -- choose the variable bit slice that performs the operation of multiplying of dividing by a factor of 2
	

		end if;
	end process;
	
		i_s_summed_cosines_gained_14 <= not s_summed_cosines_gained_14(12);
	
	u_summed_cosines_gained_14 <= i_s_summed_cosines_gained_14 & std_logic_vector(s_summed_cosines_gained_14);
	

	
	
	p_cosines  <= u_summed_cosines_gained_14;
	
	n_cosines <= not p_cosines;

		
	
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
	
	
	
	
--NOTE: lia_out_x_1 	and lia_out_x_2 and lia_out_y_1 	and lia_out_y_2 eventually can get sent to the niosii processor to be processed
--	MAKE NIOS II PROCESSOR HERE
	
	
	
	

end arch;