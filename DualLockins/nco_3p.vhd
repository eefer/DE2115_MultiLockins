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

--	type rom_type is array(0 to 255) of integer range -1024 to 1024;
--
--	-- cosine lookup table; 8-bit address, 12-bit contents
--	constant cos_rom : rom_type := ( 1024,  1024,  1023,  1021,  1019,  1016,  1013,  1009,  1004,   999,   993,   987,   980,   972,   964,   955,   945,   935,   925,   914,   902,   890,   877,   864,   850,   836,   821,   806,   790,   774,   757,   740,   722,   704,   685,   666,   647,   627,   607,   586,   566,   544,   523,   501,   479,   456,   434,   411,   387,   364,   340,   316,   292,   268,   244,   219,   194,   170,   145,   120,    94,    69,    44,    19,    -6,   -32,   -57,   -82,  -107,  -132,  -157,  -182,  -207,  -231,  -256,  -280,  -304,  -328,  -352,  -376,  -399,  -422,  -445,  -468,  -490,  -512,  -534,  -555,  -576,  -597,  -617,  -637,  -657,  -676,  -695,  -713,  -731,  -748,  -765,  -782,  -798,  -813,  -828,  -843,  -857,  -871,  -884,  -896,  -908,  -919,  -930,  -941,  -950,  -959,  -968,  -976,  -983,  -990,  -996, -1002, -1007, -1011, -1015, -1018, -1020, -1022, -1023, -1024, -1024, -1023, -1022, -1020, -1018, -1015, -1011, -1007, -1002,  -996,  -990,  -983,  -976,  -968,  -959,  -950,  -941,  -930,  -919,  -908,  -896,  -884,  -871,  -857,  -843,  -828,  -813,  -798,  -782,  -765,  -748,  -731,  -713,  -695,  -676,  -657,  -637,  -617,  -597,  -576,  -555,  -534,  -512,  -490,  -468,  -445,  -422,  -399,  -376,  -352,  -328,  -304,  -280,  -256,  -231,  -207,  -182,  -157,  -132,  -107,   -82,   -57,   -32,    -6,    19,    44,    69,    94,   120,   145,   170,   194,   219,   244,   268,   292,   316,   340,   364,   387,   411,   434,   456,   479,   501,   523,   544,   566,   586,   607,   627,   647,   666,   685,   704,   722,   740,   757,   774,   790,   806,   821,   836,   850,   864,   877,   890,   902,   914,   925,   935,   945,   955,   964,   972,   980,   987,   993,   999,  1004,  1009,  1013,  1016,  1019,  1021,  1023,  1024,  1024 );

	type rom_type is array(0 to 255) of integer range -2048 to 2048;

	-- cosine lookup table; 8-bit address, 13-bit contents
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
		
