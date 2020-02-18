-- Numerically-controlled oscillator with 3-phase output
-- Jesse Wilson (2015) jesse.wilson@colostate.edu
--
-- Lookup table oscillator, designed for use with a phase-locked loop.
-- The sync output is for the PLL locking, the other 2 outputs
-- are in-phase and quadrature outputs for signal mixing.
-- 
--
-- 3 phases:
-- sync
-- sync + phase offset (cos)
-- sync + phase offset + 90 deg (sin)
--
--
-- Under the hood: a 20-bit phase accumulator, and an 8-bit lookup table (LUT)
-- LUT was generated with MATLAB
--
-- Final frequency is f0 / (2^20 / phase_incr)
-- e.g., for a 50 MHz system clock, phase_incr of 5243 yields a 250 kHz output here
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nco_3p is
	port( 
		clk_i 			: in std_logic;					-- clock
		phase_incr_i	: in unsigned( 19 downto 0 ) := to_unsigned(2098, 20); -- default to ~100 kHz
		phase_offs_i	: in unsigned( 19 downto 0 ) := to_unsigned(0, 20);	-- phase offset
		
		
		sync_o		: out std_logic_vector( 12 downto 0 );		-- sync waveform out
		cos_o			: out std_logic_vector( 12 downto 0 );		-- phase-shifted cosine out
		sin_o			: out std_logic_vector( 12 downto 0 )		-- phase-shifted sine out
	);
end nco_3p;

architecture behavior of nco_3p is

	-- cosine lookup table; 8-bit address, 13-bit contents
	-- these values were calculated by a MATLAB script
	type rom_type is array(0 to 255) of integer range -2048 to 2048;
	constant cos_rom : rom_type := (2048,	2047,	2046,	2042,	2038,	2033,	2026,	2018,	2009,	1998,	1987,	1974,	1960,	1945,	1928,	1911,	1892,	1872,	1851,	1829,	1806,	1782,	1757,	1730,	1703,	1674,	1645,	1615,	1583,	1551,	1517,	1483,	1448,	1412,	1375,	1338,	1299,	1260,	1220,	1179,	1138,	1096,	1053,	1009,	965,	921,	876,	830,	784,	737,	690,	642,	595,	546,	498,	449,	400,	350,	301,	251,	201,	151,	100,	50,	0,	-50,	-100,	-151,	-201,	-251,	-301,	-350,	-400,	-449,	-498,	-546,	-595,	-642,	-690,	-737,	-784,	-830,	-876,	-921,	-965,	-1009,	-1053,	-1096,	-1138,	-1179,	-1220,	-1260,	-1299,	-1338,	-1375,	-1412,	-1448,	-1483,	-1517,	-1551,	-1583,	-1615,	-1645,	-1674,	-1703,	-1730,	-1757,	-1782,	-1806,	-1829,	-1851,	-1872,	-1892,	-1911,	-1928,	-1945,	-1960,	-1974,	-1987,	-1998,	-2009,	-2018,	-2026,	-2033,	-2038,	-2042,	-2046,	-2047,	-2048,	-2047,	-2046,	-2042,	-2038,	-2033,	-2026,	-2018,	-2009,	-1998,	-1987,	-1974,	-1960,	-1945,	-1928,	-1911,	-1892,	-1872,	-1851,	-1829,	-1806,	-1782,	-1757,	-1730,	-1703,	-1674,	-1645,	-1615,	-1583,	-1551,	-1517,	-1483,	-1448,	-1412,	-1375,	-1338,	-1299,	-1260,	-1220,	-1179,	-1138,	-1096,	-1053,	-1009,	-965,	-921,	-876,	-830,	-784,	-737,	-690,	-642,	-595,	-546,	-498,	-449,	-400,	-350,	-301,	-251,	-201,	-151,	-100,	-50,	0,	50,	100,	151,	201,	251,	301,	350,	400,	449,	498,	546,	595,	642,	690,	737,	784,	830,	876,	921,	965,	1009,	1053,	1096,	1138,	1179,	1220,	1260,	1299,	1338,	1375,	1412,	1448,	1483,	1517,	1551,	1583,	1615,	1645,	1674,	1703,	1730,	1757,	1782,	1806,	1829,	1851,	1872,	1892,	1911,	1928,	1945,	1960,	1974,	1987,	1998,	2009,	2018,	2026,	2033,	2038,	2042,	2046,	2047 );
	
	
	-- previous value of offset
	signal phase_offs_prev	: unsigned( 19 downto 0 ) := to_unsigned(0, 20);
	
	-- phase accumulators, full range represents 0 to 2*pi
	signal phase_acc 		: unsigned( 19 downto 0 ) := to_unsigned(0,20);
	signal phase_acc_cos : unsigned( 19 downto 0 ) := to_unsigned(0,20);
	signal phase_acc_sin : unsigned( 19 downto 0 ) := to_unsigned(262144,20);
	
	-- value of PI/2
	signal HALFPI	: unsigned( 19 downto 0 ) := to_unsigned(262144,20);
	
	-- phase accumulators, most significant bits
	signal phase_acc_msbs 		: unsigned(7 downto 0);
	signal phase_acc_msbs_cos 	: unsigned(7 downto 0);
	signal phase_acc_msbs_sin 	: unsigned(7 downto 0);
		
	begin
	
	-- connect most significant bits of phase accumulator
	phase_acc_msbs 		<= phase_acc(		19 downto (19-7) );
	phase_acc_msbs_cos 	<= phase_acc_cos( 19 downto (19-7) );
	phase_acc_msbs_sin 	<= phase_acc_sin( 19 downto (19-7) );
	
	ncoproc : process( clk_i )
	begin
		if rising_edge( clk_i ) then
			
			-- handle a change in requested phase offset
			phase_offs_prev <= phase_offs_i;

			if( phase_offs_prev /= phase_offs_i ) then
				-- if phase offset changed, then use master phase acc + offset
				phase_acc_cos <= phase_acc + phase_offs_i;
				phase_acc_sin <= phase_acc + phase_offs_i + HALFPI;
			else
				-- otherwise, just increment
				phase_acc_cos <= phase_acc_cos + phase_incr_i;
				phase_acc_sin <= phase_acc_sin + phase_incr_i;
			end if;

		
			-- increment master phase accumulators
			phase_acc <= phase_acc + phase_incr_i;
			
			-- look up sine wave values for each output
			sync_o	<= std_logic_vector(to_signed(cos_rom( to_integer(phase_acc_msbs) ),13));
			cos_o		<= std_logic_vector(to_signed(cos_rom( to_integer(phase_acc_msbs_cos) ),13));
			sin_o		<= std_logic_vector(to_signed(cos_rom( to_integer(phase_acc_msbs_sin) ),13));
			
		end if;
	end process;
end behavior;
		
