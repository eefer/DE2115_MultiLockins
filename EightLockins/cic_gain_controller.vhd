-- Gain controller module for cic_filter: 
-- bit slice selection
-- selects which 16 bits of the 59 bits of cic filter output is to be passed to the lia_core.vhd
-- Sliding the window to the MSB by one position decreases gain by 2x.
-- Sliding the window to the LSB by one position increases gain by 2x.
--		Written by Arya Chowdhury Mugdha (arya.mugdha@colostate.edu)
--
-- (2020-02-18 JWW) Added comments / documentation


LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
 

entity cic_gain_controller is
port(
  clk_in		: in  std_logic;						-- input clock
  data_in		: in std_logic_vector(58 downto 0);		-- 59-bit input
  gain     		: in std_logic_vector (5 downto 0);		-- gain factor (position of 16-bit slice)
  data_out_g	: out std_logic_vector(15 downto 0);	-- 16-bit output
  ovrflw		: out std_logic 						-- indicate overflow (gain too high)
  );
end cic_gain_controller;

architecture behavior of cic_gain_controller is

signal gain_s		:	signed(5 downto 0);
signal g  			: integer range 0 to 32;
signal result		: std_logic;  	 
signal overflow	: std_logic;

  -- reducing OR operator
  -- produces a logical OR of all the bits in a vector
  -- e.g. reduct_or('001010011') = '1'
  --      reduct_or('00000') = '0'
  -- 	  reduct_or('0100000000000') = '1'
  --	  reduct_or('1111') = '1'
  function reduct_or (inp : in std_logic_vector) return std_logic is
		variable result : std_logic := '0';
		
	begin
		for i in inp'range loop
			result := result or inp(i);
			exit when result = '1';
		end loop;
		return result;
	end function;
	
	-- reducing NAND operator
	-- produces a logical NAND of all the bits in a vector
	-- e.g. reduct_nand('001010011') = '1'
	--      reduct_nand('00000') = '1'
	-- 	    reduct_nand('0100000000000') = '1'
	--		reduct_nand('1111') = '0'
	function reduct_nand (inp : in std_logic_vector) return std_logic is
		variable result : std_logic := '0';
		
	begin
		for i in inp'range loop
			result := '1' nand inp(i);
			exit when result = '1';
		end loop;
		return result;
	end function;

begin

	-- programmable gain process
	process(clk_in) is
		begin
	
		if rising_edge( clk_in ) then
			-- convert gain factor to an integer
			gain_s		<=	signed(gain);
			g			<= 	to_integer(gain_s);
			
			-- perform 2^g gain by selecting a bit slice from data_in
			data_out_g 	<= data_in((58-g) downto (58-g-15)); 
		end if;
	end process;
  
	-- overflow calculation process
	-- Bit slice selection discards MSBs and LSBs.
	-- If the discarded MSBs are all the same as the MSB of the 16-bit slice,
	-- then they were sign bits, and it is safe to discard them.
	-- But if any of the discarded MSBs are different from the MSB of the 16-bit slice,
	-- then the number was out of range for the selected slice,
	-- and an overflow has occurred.
	process (clk_in) is -- modified JWW 20180127
		begin
		
		if rising_edge( clk_in ) then
  
			if (data_in(58) = '0') then
				-- if sign is positive, examine discarded MSBs for any '1's
				-- by using a reducing OR operator
				case g is
					-- which bits were discarded depends on the gain factor
					when 0 => overflow <= '0';
					when 1 => overflow <= reduct_or(data_in(58 downto 57));
					when 2 => overflow <= reduct_or(data_in(58 downto 56));
					when 3 => overflow <= reduct_or(data_in(58 downto 55));
					when 4 => overflow <= reduct_or(data_in(58 downto 54));
					when 5 => overflow <= reduct_or(data_in(58 downto 53));
					when 6 => overflow <= reduct_or(data_in(58 downto 52));
					when 7 => overflow <= reduct_or(data_in(58 downto 51));
					when 8 => overflow <= reduct_or(data_in(58 downto 50));
					when 9 => overflow <= reduct_or(data_in(58 downto 49));
					when 10 => overflow <= reduct_or(data_in(58 downto 48));
					when 11 => overflow <= reduct_or(data_in(58 downto 47));
					when 12 => overflow <= reduct_or(data_in(58 downto 46));
					when 13 => overflow <= reduct_or(data_in(58 downto 45));
					when 14 => overflow <= reduct_or(data_in(58 downto 44));
					when 15 => overflow <= reduct_or(data_in(58 downto 43));
					when 16 => overflow <= reduct_or(data_in(58 downto 42));
					when 17 => overflow <= reduct_or(data_in(58 downto 41));
					when 18 => overflow <= reduct_or(data_in(58 downto 40));
					when 19 => overflow <= reduct_or(data_in(58 downto 39));
					when 20 => overflow <= reduct_or(data_in(58 downto 38));
					when 21 => overflow <= reduct_or(data_in(58 downto 37));
					when 22 => overflow <= reduct_or(data_in(58 downto 36));
					when 23 => overflow <= reduct_or(data_in(58 downto 35));
					when 24 => overflow <= reduct_or(data_in(58 downto 34));
					when 25 => overflow <= reduct_or(data_in(58 downto 33));
					when 26 => overflow <= reduct_or(data_in(58 downto 32));
					when 27 => overflow <= reduct_or(data_in(58 downto 31));
					when 28 => overflow <= reduct_or(data_in(58 downto 30));
					when 29 => overflow <= reduct_or(data_in(58 downto 29));
					when 30 => overflow <= reduct_or(data_in(58 downto 28));
					when 31 => overflow <= reduct_or(data_in(58 downto 27));
					when 32 => overflow <= reduct_or(data_in(58 downto 26));

				end case;
			
			ovrflw <= overflow;
			
			else
				-- if sign is negative, examine discarded MSBs for any '0's
				-- by using a reducing NAND operator
				case g is
					-- which bits were discarded depends on the gain factor
					when 0 => overflow <= '0';
					when 1 => overflow <= reduct_nand(data_in(58 downto 57));
					when 2 => overflow <= reduct_nand(data_in(58 downto 56));
					when 3 => overflow <= reduct_nand(data_in(58 downto 55));
					when 4 => overflow <= reduct_nand(data_in(58 downto 54));
					when 5 => overflow <= reduct_nand(data_in(58 downto 53));
					when 6 => overflow <= reduct_nand(data_in(58 downto 52));
					when 7 => overflow <= reduct_nand(data_in(58 downto 51));
					when 8 => overflow <= reduct_nand(data_in(58 downto 50));
					when 9 => overflow <= reduct_nand(data_in(58 downto 49));
					when 10 => overflow <= reduct_nand(data_in(58 downto 48));
					when 11 => overflow <= reduct_nand(data_in(58 downto 47));
					when 12 => overflow <= reduct_nand(data_in(58 downto 46));
					when 13 => overflow <= reduct_nand(data_in(58 downto 45));
					when 14 => overflow <= reduct_nand(data_in(58 downto 44));
					when 15 => overflow <= reduct_nand(data_in(58 downto 43));
					when 16 => overflow <= reduct_nand(data_in(58 downto 42));
					when 17 => overflow <= reduct_nand(data_in(58 downto 41));
					when 18 => overflow <= reduct_nand(data_in(58 downto 40));
					when 19 => overflow <= reduct_nand(data_in(58 downto 39));
					when 20 => overflow <= reduct_nand(data_in(58 downto 38));
					when 21 => overflow <= reduct_nand(data_in(58 downto 37));
					when 22 => overflow <= reduct_nand(data_in(58 downto 36));
					when 23 => overflow <= reduct_nand(data_in(58 downto 35));
					when 24 => overflow <= reduct_nand(data_in(58 downto 34));
					when 25 => overflow <= reduct_nand(data_in(58 downto 33));
					when 26 => overflow <= reduct_nand(data_in(58 downto 32));
					when 27 => overflow <= reduct_nand(data_in(58 downto 31));
					when 28 => overflow <= reduct_nand(data_in(58 downto 30));
					when 29 => overflow <= reduct_nand(data_in(58 downto 29));
					when 30 => overflow <= reduct_nand(data_in(58 downto 28));
					when 31 => overflow <= reduct_nand(data_in(58 downto 27));
					when 32 => overflow <= reduct_nand(data_in(58 downto 26));
				
				end case;
			
			ovrflw <= overflow;
			
		end if;
		
	end if;
		
	end process;
  
  
end behavior;