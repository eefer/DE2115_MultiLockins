-- lia_core.vhd
-- Lock-in amplifier core
-- board-independent component
--
-- Jesse W. Wilson (2015) jesse.wilson@colostate.edu
-- 
-- Modified by Erin E. Flater (2017) flater01@luther.edu
--
-- Modified by Arya Chowdhury Mugdha (2017) (arya.mugdha@colostate.edu)


LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;


ENTITY lia_core IS 

	PORT(
		sys_clk_i	: IN STD_LOGIC;						-- system clock (assumed 50 MHz)
		areset_i 	: IN STD_LOGIC;						-- async reset in
			
		-- phase-locked loop signals
--		ref_i				: in std_logic;								-- reference square wave input. This is passed to the PLL
		phase_offs_i	: in	std_logic_vector(19 downto 0);	-- reference phase offset
		phase_incr_i	: in	std_logic_vector(19 downto 0);	-- phase increment for internal reference
		ref_cos_o		: out std_logic_vector(12 downto 0);	-- PLL-generated reference cosine (in-phase)
		ref_sin_o		: out std_logic_vector(12 downto 0);	-- PLL-generated reference sine (quadrature)
		dpll_ref		: out std_logic_vector(12 downto 0);	-- PLL-generated reference wave (used for debugging tracking)
		
		-- lock-in amplifier input and output signals
		samp_clk_i	: in std_logic;								-- sampling clock (1 MHz) from the ADC
		input			: in std_logic_vector( 13 downto 0);	-- input signal. This is mixed with the PLL-generated reference
		samp_clk_o	: out std_logic;								-- output sampling clock (1 kHz) from the CIC filters
		out_x			: out std_logic_vector(15 downto 0);	-- in-phase lock-in output signal
		out_y			: out std_logic_vector(15 downto 0);	-- quadrature lock-in output signal
		
		-- other options
		cic_x_in_sel_i	: in natural range 0 to 1 := 0;			-- CIC filter x input select
																				--  0: in-phase mixer (default)
																				--  1: input signal (bypass mixer to debug CIC filter behavior)		
		gain_ctrl	: IN  std_logic_vector (5 downto 0);	-- sets gain for the CIC output
		overflow_lia : OUT std_logic						-- indicates overflow at CIC output gain stage
	);
END lia_core;


ARCHITECTURE arch OF lia_core IS 
	
	--
	-- component declarations
	--
	
		COMPONENT mult_13x14
		PORT
		(
			clock		: IN STD_LOGIC ;
			dataa		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
			datab		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
			result	: OUT STD_LOGIC_VECTOR (26 DOWNTO 0)
		);
		END COMPONENT;
		
		COMPONENT dpll IS
		PORT( 
			clk				: IN  STD_LOGIC;	-- system clock
--			ref_i	 		: IN  STD_LOGIC; 	-- reference signal for PLL locking (disabled)
			phase_offs_i	: IN 	std_logic_vector(19 downto 0);	-- phase offset to add to cos_o
			phase_incr_i	: IN	std_logic_vector(19 downto 0);	-- phase increment for internal reference
			cos_o			: OUT  STD_LOGIC_VECTOR(12 downto 0);  -- phase-shifted cos out
			sin_o			: OUT  STD_LOGIC_VECTOR(12 downto 0);  -- quadrature sin out
			ref_o			: OUT  STD_LOGIC_VECTOR(12 downto 0);	-- nco reference wave out
			phase_lag_o 	: out std_logic;
			phase_lead_o 	: out std_logic
		);
		END COMPONENT;
		
		
		component cic_filter IS
		PORT(
			clk_sys_in		: IN 	std_logic;
			clk_in			: IN  std_logic;								-- input sample rate clock
			data_in			: IN  std_logic_vector(26 downto 0);	-- sample data in, Q12._
			gain_ctrl_cic	: IN  std_logic_vector (5 downto 0);
			clk_out 			: OUT std_logic;								-- output clock (clk_in / 1000)
			data_out			: OUT std_logic_vector(15 downto 0);		-- data out
			overflow			: OUT std_logic
		);
		END component;
		

	--
	-- signal declarations
	--
	
		attribute 	keep : boolean;	-- used to keep quartus from synthesizing away nodes I want to debug

			
		-- DPLL output waveforms
		signal		dpll_cos		: std_logic_vector(12 downto 0);
		attribute	keep of dpll_cos : signal is true;
			
		signal		dpll_sin		: std_logic_vector(12 downto 0);
		attribute	keep of dpll_sin : signal is true;
		
		-- Signals for PLL-generated reference wave (used for debugging tracking; disabled for now)
--		signal		dpll_ref		: std_logic_vector(12 downto 0);
--		attribute	keep of dpll_ref : signal is true;
		
		
		SIGNAL 		q27_mixer_i_product					  	: std_logic_vector(26 downto 0);
		SIGNAL		mixer_i_scaled								: std_logic_vector(26 downto 0);
		SIGNAL 		q27_mixer_q_product					  	: std_logic_vector(26 downto 0);
		SIGNAL		mixer_q_scaled								: std_logic_vector(26 downto 0);
		
			attribute 	keep of mixer_i_scaled: signal is true; 
			attribute 	keep of mixer_q_scaled: signal is true; 
		

		SIGNAL		cic_x_in				: std_logic_vector(26 downto 0);
		SIGNAL		cic_x_out_valid 	: std_logic := '0'; 						-- CIC out sample clock
		SIGNAL 		cic_x_out 			: STD_LOGIC_VECTOR(15 downto 0);
			attribute	keep of cic_x_out: signal is true;
			
		SIGNAL		cic_y_in				: std_logic_vector(26 downto 0);
		SIGNAL		cic_y_out_valid 	: std_logic := '0'; 						-- CIC out sample clock
		SIGNAL 		cic_y_out 			: STD_LOGIC_VECTOR(15 downto 0);
			attribute	keep of cic_y_out: signal is true;
	
		signal latch_cos					: std_logic_vector(12 downto 0);
		signal latch_sin					: std_logic_vector(12 downto 0);
		
		signal gain_ctrl_tx				: std_logic_vector(5 downto 0);
		signal overflow_x					: std_logic;
		signal overflow_y					: std_logic;

		
				
		

	--
	-- implementation details
	--
	
	BEGIN 
	
	
	
	-- digital PLL generates lock-in reference waveform
	dpll_inst : dpll
	PORT MAP(
		clk				=> sys_clk_i,
--		ref_i			=> ref_i,  			-- external reference for PLL tracking (disabled for now)
		phase_offs_i	=> phase_offs_i,	-- phase offset
		phase_incr_i	=> phase_incr_i,	-- phase increment for internal reference
		cos_o			=> dpll_cos,		-- phase-shifted cos
		sin_o			=> dpll_sin,		-- phase-shifted sin
		ref_o			=> dpll_ref			-- reference wave out instantiation for dpll
		--- latch cos and sine (edited version)
		
		
	);
	
	ref_cos_o <= latch_cos;			-- export reference cosine
	ref_sin_o <= latch_sin;			-- export reference sine
	gain_ctrl_tx <= gain_ctrl;
	
	overflow_lia <= overflow_x or overflow_y;
		
	-- in-phase mixer
	mixer_i: component mult_13x14
		PORT MAP (
		   clock		=> samp_clk_i,
			dataa		=>	latch_cos, 
			datab		=>	input,
			result	=> q27_mixer_i_product
		);
	
	-- i mixer output latch, with async reset
	process (sys_clk_i, areset_i) is
		begin
        if areset_i = '1' then
            mixer_i_scaled <= (others => '0');
        elsif rising_edge( sys_clk_i ) then			-- modified JWW 20180127
				mixer_i_scaled <= q27_mixer_i_product; -- tune for post-mixer gain
        end if;
	end process;	
	
	-- quadrature mixer
	mixer_q: component mult_13x14
		PORT MAP (
			clock		=> samp_clk_i,
			dataa		=>	latch_sin,
			datab		=>	input,
			result	=> q27_mixer_q_product
		);
	
	-- q mixer output latch, with async reset
	process (sys_clk_i, areset_i) is
		begin
        if areset_i = '1' then
            mixer_q_scaled <= (others => '0');
        elsif rising_edge( sys_clk_i ) then			-- modified JWW 20180127 
				mixer_q_scaled <= q27_mixer_q_product;  -- tune for post-mixer gain
        end if;
	end process;
	
	-- CIC x-channel input
	cic_x_in	<=	mixer_i_scaled;	-- feed mixer product to the CIC filter directly without any mux


	
	--
	
	-- latch
	nco_latch : process ( samp_clk_i )
	begin 
		if rising_edge( samp_clk_i ) then
			
				latch_cos <= dpll_cos;
				latch_sin <= dpll_sin;
				
		end if;
	end process;
	

	-- CIC low-pass filter, x-channel
	cic_x : cic_filter
	port map
	(	
		clk_sys_in		=> sys_clk_i,		-- system clock (50 MHz)
		clk_in			=> samp_clk_i,		-- input clock (1 MHz)
		data_in			=> cic_x_in,		-- input signal
		clk_out 		=> cic_x_out_valid,	-- output clock (1 kHz)
		data_out		=> cic_x_out,		-- output signal
		gain_ctrl_cic	=> gain_ctrl_tx,	-- controls scaling (gain) of CIC output
		overflow		=> overflow_x		-- indicates overflow at CIC output gain block
	);
	
	
	-- CIC y-channel input
	 cic_y_in	<= mixer_q_scaled;

	
	
	-- CIC low-pass filter, y-channel
	cic_y : cic_filter
	port map
	(
		clk_sys_in		=> sys_clk_i,		-- system clock (50 MHz)
		clk_in			=> samp_clk_i,		-- input clock
		data_in			=> cic_y_in,		-- input signal
		clk_out 		=> cic_y_out_valid,	-- output clock
		data_out		=> cic_y_out,		-- output signal
		gain_ctrl_cic	=> gain_ctrl_tx,	-- controls scaling (gain) of CIC output
		overflow		=> overflow_y		-- indicates overflow at CIC output gain block
	);
	
	-- export CIC outputs
	-- TODO: add output gain here
	out_x	<= cic_x_out; -- tune for post-lowpass gain
	out_y <= cic_y_out; -- tune for post-lowpass gain
	
	samp_clk_o	<= cic_x_out_valid;		-- this is a holdover; we should be loading both x and y channels
													-- into a FIFO and reading out on a common clock to avoid sync
													-- problems with the two CICs

	
--	
END arch;
