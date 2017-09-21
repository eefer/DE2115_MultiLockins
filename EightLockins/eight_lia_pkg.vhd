-- dual_lia_pkg.vhd
-- Dual lock-in amplifier package
-- merges 2 lock-in amplifier and a qsys system to control lock-in variables
--
-- Erin E. Flater (2017) flater01@luther.edu
--
-- Based partially on m10_lia_pkg.vhd by Jesse W. Wilson jesse.wilson@colostate.edu
-- and based partially on duallockinv2_02_sys.v by Erin Flater
--
-- Modified by Arya Chowdhury Mugdha (2017) arya.mugdha@colostate.edu

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;


ENTITY eight_lia_pkg IS

	PORT(
		sys_clk_i	: IN STD_LOGIC;								-- system clock (assumes 50MHz clock)
		areset_i		: IN STD_LOGIC;								-- asyncronous reset
		
		-- phase-locked loop signals
--		ref_1_i		: in  std_logic;								-- reference square wave input for lockin_1. This is passed to the PLL
--		ref_2_i		: in  std_logic;								-- reference square wave input for lockin_2. This is passed to the PLL
		ref_o			: out std_logic;								-- PLL output, square wave derived from in-phase cosine
		
		-- lock-in amplifier input and output signals
		samp_clk_i	: in 	std_logic;								-- sampling clock (1 MHz), ADC sampling rate
		input			: in 	std_logic_vector( 13 downto 0);	-- input signal (from ADC)
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
		
		overflow_dlia: out std_logic
		
		-- control lines
--		out_sel_cycle_i	: in std_logic := '0';				-- rising edge causes output select to change
--		incr_phase_i		: in std_logic := '0';				-- rising edge causes phase to increment
	
--		lia_output_state  : out std_logic_vector(2 downto 0)
	);
END eight_lia_pkg;

ARCHITECTURE arch OF eight_lia_pkg IS

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
						reset_reset_n       : in  std_logic                     := 'X'; 	--        reset.reset_n
						resetrequest_reset  : out std_logic                             	-- resetrequest.reset
			);
			end component; -- qsys_system
			
			
	
	--
	-- signal declarations
	--
	
--		attribute 	keep : boolean;	-- used to keep quartus from synthesizing away nodes I want to debug
--
--		SIGNAL 	out_sel_cycle_prev		: STD_LOGIC := '0';	-- used to sense rising edge of out_sel_cycle_i
		

		
		-- push-button phase increment (22.5 deg, or 16 increments per 360-deg)
		signal	incr_phase_amount		: unsigned(19 downto 0) := to_unsigned(65536,20);
		
		signal 	incr_phase_prev		: std_logic := '0';	-- used to sense rising edge of incr_phase_i
		
		-- DPLL output waveforms
--		signal	dpll_cos_1		: std_logic_vector(11 downto 0);
--		attribute keep of dpll_cos_1 : signal is true;
--		
--		signal	dpll_cos_2		: std_logic_vector(11 downto 0);
--		attribute keep of dpll_cos_2 : signal is true;
--			
--		signal	dpll_sin_1		: std_logic_vector(11 downto 0);
--		attribute keep of dpll_sin_1 : signal is true;
--		
--		signal	dpll_sin_2		: std_logic_vector(11 downto 0);
--		attribute keep of dpll_sin_2 : signal is true;
		
		
--		SIGNAL 	out_sel 	: natural range 0 to 4 := 0; -- set to '0' for NCO sine, '1' for ADC pass-through
--		attribute keep of out_sel : signal is true;
--		--variable	prev_out_sel	: natural range 0 to 4 :=0;
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
		
		-- lock-in control lines
--		signal cic_x_in_sel		: natural range 0 to 1 := 0;	-- CIC filter x input select
																				--  0: in-phase mixer (default)
																				--  1: input signal (bypass mixer to debug CIC filter behavior)		
																				-- this is used to provide a filtered, unmixed version of the input signal
																					
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
		
		signal lia_out_x_1_tx: std_logic_vector(15 downto 0);
		signal lia_out_y_1_tx: std_logic_vector(15 downto 0);
	
BEGIN
	
	--	-- export signals
	--	dpll_cos_1 <= ref_cos_o_1;
	--	dpll_cos_2 <= ref_cos_o_2;
	--	ref_o <= ref_cos_o_1(12);	-- for synchronization (use last bit so 1 for half the cycle)	

	--this part has been commented out to allow the square wave reference from the nco_3p of dpll to be passed as reference instead of the cosines generated by the nco_3p; Modified by Arya 
	
	
	
	overflow_dlia	<=	overflow_lia_1 or overflow_lia_2 or overflow_lia_3 or overflow_lia_4 or overflow_lia_5 or overflow_lia_6 or overflow_lia_7 or overflow_lia_8;
	
	
	-- export signals
	dpll_cos_1 <= dpll_lia_ref_o_1;
	dpll_cos_2 <= dpll_lia_ref_o_2;
	dpll_cos_3 <= dpll_lia_ref_o_3;
	dpll_cos_4 <= dpll_lia_ref_o_4;
	dpll_cos_5 <= dpll_lia_ref_o_5;
	dpll_cos_6 <= dpll_lia_ref_o_6;
	dpll_cos_7 <= dpll_lia_ref_o_7;
	dpll_cos_8 <= dpll_lia_ref_o_8;
	ref_o <= dpll_lia_ref_o_1(12);	-- for synchronization (use last bit so 1 for half the cycle)	
	
--	lia_out_x_1 => lia_out_x_1_tx;
--	lia_out_y_1 => lia_out_y_1_tx;
	
-- sends the out_sel to the lia_output_state
--	lia_output_state <= std_logic_vector(to_unsigned(out_sel,3));

	-- phase increment pushbutton handler
--	incr_phase_proc : process( sys_clk_i )
--	begin
--		if rising_edge( sys_clk_i ) then
--			incr_phase_prev <= incr_phase_i;
--			
--			if incr_phase_prev = '0' and incr_phase_i = '1' then
--				dpll_phase_offs <= dpll_phase_offs + incr_phase_amount;
--			end if;
--			
--		end if;
--	end process;
	
	-- the lock-in core
	lockin_1 : lia_core
	port map (
		sys_clk_i		=> sys_clk_i,
		areset_i			=> areset_i,
		
--		ref_i				=> ref_1_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_1,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_1,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_1,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_1,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_1,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> samp_clk_i,				-- forward sample clock from ADC		
		input				=> input,					-- forward sampled data from the ADC
		samp_clk_o		=> samp_clk_o,				-- lock-in output sample clock
		out_x				=> lia_out_x_1_tx,			-- direct x output to internal signal line
		out_y			   => lia_out_y_1_tx,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_1
--		cic_x_in_sel_i	=> cic_x_in_sel

		
	);
	
		-- the lock-in core
	lockin_2 : lia_core
	port map (
		sys_clk_i		=> sys_clk_i,
		areset_i			=> areset_i,
		
--		ref_i				=> ref_2_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_2,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_2,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_2,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_2,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_2,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> samp_clk_i,				-- forward sample clock from ADC		
		input				=> input,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_2,	-- lock-in output sample clock
		out_x				=> lia_out_x_2,			-- direct x output to internal signal line
		out_y				=> lia_out_y_2,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_2
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_3 : lia_core
	port map (
		sys_clk_i		=> sys_clk_i,
		areset_i			=> areset_i,
		
--		ref_i				=> ref_3_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_3,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_3,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_3,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_3,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_3,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> samp_clk_i,				-- forward sample clock from ADC		
		input				=> input,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_3,	-- lock-in output sample clock
		out_x				=> lia_out_x_3,			-- direct x output to internal signal line
		out_y				=> lia_out_y_3,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_3
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_4 : lia_core
	port map (
		sys_clk_i		=> sys_clk_i,
		areset_i			=> areset_i,
		
--		ref_i				=> ref_4_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_4,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_4,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_4,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_4,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_4,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> samp_clk_i,				-- forward sample clock from ADC		
		input				=> input,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_4,	-- lock-in output sample clock
		out_x				=> lia_out_x_4,			-- direct x output to internal signal line
		out_y				=> lia_out_y_4,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_4
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_5 : lia_core
	port map (
		sys_clk_i		=> sys_clk_i,
		areset_i			=> areset_i,
		
--		ref_i				=> ref_5_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_5,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_5,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_5,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_5,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_5,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> samp_clk_i,				-- forward sample clock from ADC		
		input				=> input,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_5,	-- lock-in output sample clock
		out_x				=> lia_out_x_5,			-- direct x output to internal signal line
		out_y				=> lia_out_y_5,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_5
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_6 : lia_core
	port map (
		sys_clk_i		=> sys_clk_i,
		areset_i			=> areset_i,
		
--		ref_i				=> ref_6_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_6,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_6,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_6,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_6,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_6,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> samp_clk_i,				-- forward sample clock from ADC		
		input				=> input,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_6,	-- lock-in output sample clock
		out_x				=> lia_out_x_6,			-- direct x output to internal signal line
		out_y				=> lia_out_y_6,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_6
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_7 : lia_core
	port map (
		sys_clk_i		=> sys_clk_i,
		areset_i			=> areset_i,
		
--		ref_i				=> ref_7_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_7,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_7,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_7,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_7,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_7,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> samp_clk_i,				-- forward sample clock from ADC		
		input				=> input,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_7,	-- lock-in output sample clock
		out_x				=> lia_out_x_7,			-- direct x output to internal signal line
		out_y				=> lia_out_y_7,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_7
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	lockin_8 : lia_core
	port map (
		sys_clk_i		=> sys_clk_i,
		areset_i			=> areset_i,
		
--		ref_i				=> ref_8_i,					-- forward reference sq wave from input pin
		phase_offs_i	=> phase_offs_8,			-- get phase offset from control logic
		phase_incr_i	=> phase_incr_8,			-- phase increment for internal reference
		ref_cos_o		=> ref_cos_o_8,			-- forward ref cos to output pin
		ref_sin_o		=> ref_sin_o_8,			-- forward ref sin to output pin
		dpll_ref			=> dpll_lia_ref_o_8,		-- forward the reference signal generated by nco_3p inside the dpll component
		gain_ctrl		=> gain_ctrl_tx,
		samp_clk_i		=> samp_clk_i,				-- forward sample clock from ADC		
		input				=> input,					-- forward sampled data from the ADC
		samp_clk_o		=> lia_out_samp_clk_8,	-- lock-in output sample clock
		out_x				=> lia_out_x_8,			-- direct x output to internal signal line
		out_y				=> lia_out_y_8,			-- direct y output to internal signal line
		overflow_lia	=> overflow_lia_8
--		cic_x_in_sel_i	=> cic_x_in_sel
		
	);
	
	
	
	qsys : qsys_system
	port map(
		clk_clk             => sys_clk_i, 		--          clk.clk
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
		
		gain_ctrl_export	  => gain_ctrl_tx,
		reset_reset_n       => not areset_i,   --        reset.reset_n
		resetrequest_reset  => resetrequest    -- resetrequest.reset
	);

	
END arch;