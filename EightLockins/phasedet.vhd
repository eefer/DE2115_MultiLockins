-- phasedet.vhd
-- detect relative phase between two square waves
-- used by the digital PLL frequency tracking loop
--
-- This module currently not used by MAFLIA.
-- But is left a part of the project because an external reference
-- is standard for lock-in amplifiers, and may be needed in the future.
--
-- Jesse Wilson (2015) jesse.wilson@colostate.edu
-- (initially developed at Duke, Warren Lab, Chem Dept)
LIBRARY ieee;
USE ieee.std_logic_1164.all; 

ENTITY phasedet IS
	PORT( 
		clk		: IN  STD_LOGIC;	-- system clock
		A	 	: IN  STD_LOGIC;	-- reference wave
		B		: IN  STD_LOGIC;  	-- signal wave
		Ea		: OUT STD_LOGIC;	-- error signal, =1 when A leads B
		Eb		: OUT STD_LOGIC  	-- error signal, =1 when B leads A
	);
END phasedet;
	
ARCHITECTURE behavior of phasedet IS
	SIGNAL	Qa	: STD_LOGIC := '0';		-- =1 when A leads B
	SIGNAL 	Qb : STD_LOGIC	:= '0';		-- =1 when A lags B
	SIGNAL 	A0: STD_LOGIC := '0';		-- registered value of A
	SIGNAL	B0: STD_LOGIC := '0';		-- registered value of B
	SIGNAL	lA : STD_LOGIC := '0';		-- delayed value of A
	SIGNAL	lB : STD_LOGIC := '0';		-- delayed value of B
	SIGNAL 	rising_edge_A : STD_LOGIC	:= '0';	-- edge on A
	SIGNAL	rising_edge_B : STD_LOGIC	:= '0';	-- edge on B
	
	BEGIN
	
	-- register inputs (two different clocks to compare)
	inputlatch : process( clk )
	begin
		if rising_edge( clk ) then
			A0 <= A;
			B0 <= B;
		end if;
	end process;
	
	
	-- compare phase of two clock signals
	-- design is different standard phase compare circuit consisting of two
	-- D-type flip-flops (See Xilinx DSP Primer).
	-- Should probably revise this design to use the standard detector.
	-- but I wanted a positive (lead) and negative (lag) feedback for the DPLL,
	-- whereas the standard design only reports absolute phase difference.
	-- When I wrote this, it was unclear how to decide from the phase difference
	-- how to decide whether to increase or decrease NCO frequency.	
	-- 
	--
	p : PROCESS( clk, Qa, Qb, A0, B0 )
	BEGIN	
		if( rising_edge( clk )) then
		
			-- edge detector on clock signal A
			if A0 = '1' and lA = '0' then
				rising_edge_A <= '1';
			else
				rising_edge_A <= '0';
			end if;
			
			-- edge detector on clock signal B
			if B0 = '1' and lB = '0' then
				rising_edge_B <= '1';
			else
				rising_edge_B <= '0';
			end if;
			
			-- decision tree follows.
			-- by default report that the clocks are in phase
			-- if we thought the clocks were in phase and sense rising edge on only clock 'A'
			--    then report that 'A' is leading
			-- if we thought the clocks were in phase and sense rising edge on only clock 'B'
			--    then report that 'A' is lagging
			if rising_edge_A = '1' and rising_edge_B = '1' then
				Qa <= '0';
				Qb <= '0';
			elsif rising_edge_A = '1' and rising_edge_B = '0' then -- rising edge of A
				if Qb = '1' then
					Qa <= '0';
					Qb <= '0';
				else
					Qa <= '1';
				end if;
			elsif rising_edge_A = '0' and rising_edge_B = '1' then -- rising edge of B
				if Qa = '1' then
					Qa <= '0';
					Qb <= '0';
				else
					Qb <= '1';
				end if;
			end if;
			
			lA <= A0;
			lB <= B0;
			
		end if;
			
	END PROCESS;

	-- latch the results and pass to output
	outputlatch : process (clk)
	BEGIN
		if( rising_edge(clk )) then
			Ea <= Qa;
			Eb <= Qb;
		end if;
	end process;
	
END behavior;
	
	