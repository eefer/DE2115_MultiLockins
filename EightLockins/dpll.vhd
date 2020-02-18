-- dpll.vhd
-- digital phase-locked loop
-- Jesse Wilson (2015) jesse.wilson@colostate.edu
--
-- Modified by Erin E. Flater (2017) flater01@luther.edu
--
-- (JWW 2020-02-17): Feedback loop disabled. For now this doesn't operate as a 
-- phase-locked loop, rather it serves as a 3-phase frequency synthesizer. To 
-- re-enable, need to uncomment ref_i lines, the phase detector, the error signal
-- generator, and feedback loop filter. WARNING: phase-locked loop tracking has
-- not been tested since 2015, and will need tuning / debugging before it works!
-- 

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

ENTITY dpll IS
	PORT( 
		clk				: IN  STD_LOGIC;								-- system clock
		ref_src_sel_i	: in std_logic := '0';							-- reference source select 0=internal 1=external
		
--		ref_i	 			: IN  STD_LOGIC;  							-- external reference wave input (disabled for now)
		phase_offs_i	: IN 	std_logic_vector(19 downto 0);			-- phase offset to add to cos_o
		
		phase_incr_i 	: in std_logic_vector(19 downto 0)  			-- phase increment for internal reference
							:= std_logic_vector(to_unsigned(4196,20));	-- defaults to 250 kHz (need to double check)
		
		cos_o				: OUT STD_LOGIC_VECTOR(12 downto 0); 		-- signal wave, in-phase (cos)
		sin_o				: OUT STD_LOGIC_VECTOR(12 downto 0);		-- signal wave, quadrature (sin)
		ref_o				: OUT STD_LOGIC_VECTOR(12 downto 0);         -- signal wave, reference out wave from the nco
		
		phase_lag_o 	: OUT STD_LOGIC;		-- diagnostic, =1 when PLL lags ref_i
		phase_lead_o 	: OUT STD_LOGIC			-- diagnostic, =1 when PLL leads ref_i
	);
END dpll;
	
ARCHITECTURE behavior of dpll IS
	SIGNAL err_phase_lead 	: STD_LOGIC := '0';
	SIGNAL err_phase_lag  	: STD_LOGIC := '0';
	SIGNAL ersig			 	: SIGNED(19 downto 0) := to_signed(0, 20);
	SIGNAL filtered_ersig	: SIGNED(19 downto 0) := to_signed(0, 20);
	SIGNAL outwave_ttl	 	: STD_LOGIC := '0';
	SIGNAL nco_phaseinc 		: UNSIGNED(19 downto 0) := to_unsigned(1048, 20);
	SIGNAL nco_sync			: STD_LOGIC_VECTOR(12 downto 0);	-- NCO output that we'll sync to the reference wave input
	SIGNAL nco_sin				: STD_LOGIC_VECTOR(12 downto 0);	-- NCO phase-shifted cos output
	SIGNAL nco_cos				: STD_LOGIC_VECTOR(12 downto 0);	-- NCO phase-shifted sine output
	
	-- loop filter signals
	signal lersig 						: signed(19 downto 0) := to_signed(0,20);
	signal deriv						: signed(19 downto 0) := to_signed(0,20);
	signal scaled_deriv 				: signed(19 downto 0) := to_signed(0,20);
	signal scaled_filtered_ersig	: signed(19 downto 0) := to_signed(0,20);
	
	
	-- components
	
	-- phase detector
--	COMPONENT phasedet IS
--		PORT( 
--			clk	: IN  STD_LOGIC;	-- system clock
--			A	 	: IN  STD_LOGIC;  -- reference wave
--			B		: IN  STD_LOGIC;  -- signal wave
--			Ea		: OUT STD_LOGIC;	-- error signal, =1 when A leads B
--			Eb    : OUT STD_LOGIC	-- error signal, =1 when B leads A
--		);
--	END COMPONENT;
	
	-- numerically-controlled oscillator
	component nco_3p is
	port (
		clk_i       	: in  std_logic;             				-- clock
		phase_incr_i 	: in  unsigned(19 downto 0); 				-- phase increment
		phase_offs_i  	: in	unsigned(19 downto 0);				-- phase offset
		sync_o			: out	std_logic_vector( 12 downto 0 );	-- sync waveform out
		cos_o				: out std_logic_vector( 12 downto 0 );	-- phase-shifted cosine out
		sin_o				: out std_logic_vector( 12 downto 0 )	-- phase-shifted sine out
		
	);
	end component nco_3p;
	
	
	-- implementation
	BEGIN
	
	-- export signals to DPLL's output pins
	phase_lag_o 	<= err_phase_lag;
	phase_lead_o 	<= err_phase_lead;
	cos_o				<= nco_cos;
	sin_o				<= nco_sin;
	ref_o				<= nco_sync;
	
	-- Numerically-controlled oscillator
	nco_inst : nco_3p
	PORT MAP(
		clk_i				=> clk,
		phase_offs_i 	=> unsigned(phase_offs_i),
		phase_incr_i	=> nco_phaseinc,
		sync_o			=> nco_sync,
		cos_o				=> nco_cos,
		sin_o				=> nco_sin
	);
	-- use the sign bit for output wave TTL approximation
	outwave_ttl <= nco_sync(12);
	
	
--	-- phase detector
--	-- compare phase of ref_i (the input) to outwave_ttl (derived from the NCO)
--	phasedet_inst : phasedet
--	PORT MAP(
--		clk => clk,
--		A 	 => ref_i,
--		B   => outwave_ttl,
--		Ea  => err_phase_lag,
--		Eb	 => err_phase_lead
--	);
--	
--	-- generate error signal
--	-- -1 when NCO phase lags
--	-- +1 when NCO phase leads
--	-- 0 if NCO in-sync with reference
--	-- TODO: roll this up into phasedet
--	ersig <=	to_signed(-1, 20) when err_phase_lag  = '1' else
--				to_signed( 1, 20) when err_phase_lead = '1' else
--				to_signed( 0, 20);
--				
--				
--	-- feedback loop filter
--	deriv <= ersig - lersig;
--	scaled_deriv <= deriv sll 9;
--	filtered_ersig <= ersig + scaled_deriv;
--	scaled_filtered_ersig <= filtered_ersig sll 1;
--	
--	loopfilt_ersig_latch : process( clk )
--	begin
--		if rising_edge( clk ) then
--			lersig <= ersig;	-- remember previous ersig, for the purpose of calculating derivative
--		end if;
--	end process;
--	
--		
--	-- make corrections to the NCO based on loop filter's output
	phaseinc_corrector : process( clk )
	BEGIN
		if rising_edge(clk) then
			if ref_src_sel_i = '0' then
				nco_phaseinc <= unsigned(phase_incr_i);
			else
				nco_phaseinc <= unsigned( signed(nco_phaseinc) - scaled_filtered_ersig );
			end if;
		end if;
	END process;
	
END behavior;