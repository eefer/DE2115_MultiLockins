-- phasedet.vhd
-- detect relative phase between two square waves
LIBRARY ieee;
USE ieee.std_logic_1164.all; 

ENTITY phasedet IS
	PORT( 
		clk		: IN  STD_LOGIC;	-- system clock
		A	 		: IN  STD_LOGIC;  -- reference wave
		B			: IN  STD_LOGIC;  -- signal wave
		Ea			: OUT STD_LOGIC;	-- error signal, =1 when A leads B
		Eb		   : OUT STD_LOGIC  	-- error signal, =1 when B leads A
	);
END phasedet;
	
ARCHITECTURE behavior of phasedet IS
	SIGNAL	Qa	: STD_LOGIC := '0';
	SIGNAL 	Qb : STD_LOGIC	:= '0';
	SIGNAL 	A0: STD_LOGIC := '0';
	SIGNAL	B0: STD_LOGIC := '0';
	SIGNAL	lA : STD_LOGIC := '0';
	SIGNAL	lB : STD_LOGIC := '0';
	SIGNAL 	rising_edge_A : STD_LOGIC	:= '0';
	SIGNAL	rising_edge_B : STD_LOGIC	:= '0';
	
	BEGIN
	
	inputlatch : process( clk )
	begin
		if rising_edge( clk ) then
			A0 <= A;
			B0 <= B;
		end if;
	end process;
	
	p : PROCESS( clk, Qa, Qb, A0, B0 )
	BEGIN	
		if( rising_edge( clk )) then
		
			if A0 = '1' and lA = '0' then
				rising_edge_A <= '1';
			else
				rising_edge_A <= '0';
			end if;
			
			if B0 = '1' and lB = '0' then
				rising_edge_B <= '1';
			else
				rising_edge_B <= '0';
			end if;
			
			
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

	outputlatch : process (clk)
	BEGIN
		if( rising_edge(clk )) then
			Ea <= Qa;
			Eb <= Qb;
		end if;
	end process;
	
END behavior;
	
	