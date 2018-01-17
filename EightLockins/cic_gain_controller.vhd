--		Gain controller module for cic_filter: selects which 16 bits of the 44 bits of cic filter output is to be passed to the lia_core.vhd
--		Written by Arya Chowdhury Mugdha (arya.mugdha@colostate.edu)



LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
 

entity cic_gain_controller is
port(
  clk_in			: in  std_logic;		
  data_in: in std_logic_vector(58 downto 0);
  gain     : in std_logic_vector (5 downto 0);
  data_out_g: out std_logic_vector(15 downto 0);
  ovrflw: out std_logic 
  );
end cic_gain_controller;

architecture behavior of cic_gain_controller is

signal gain_s		:	signed(5 downto 0);
signal g  : integer range 0 to 32;
signal result: std_logic;  	 
signal overflow: std_logic;

  
  
  function reduct_or (inp : in std_logic_vector) return std_logic is
		
		variable result : std_logic := '0';
		
	begin
	
		for i in inp'range loop
		
			result := result or inp(i);
			
			exit when result = '1';
			
		end loop;
		
		return result;
		
	end function;
	
	
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

	process(clk_in) is
  
		begin
  	
			gain_s		<=		signed(gain);
				
			g		<= 	to_integer(gain_s);
	
			data_out_g <= data_in((58-g) downto (58-g-15)); 
	
	end process;
  
  
	process (data_in) is
  
		begin
  
			if (data_in(58) = '0') then
			
				case g is
			
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
		
				case g is
			
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
		
	end process;
  
  
end behavior;