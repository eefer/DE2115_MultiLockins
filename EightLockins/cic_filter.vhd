-- CIC filter
-- Jesse Wilson (2015) jesse.wilson@duke.edu
-- Warren Lab, Chemistry Dept, Duke University
--
-- Revised by Erin Flater (2017) flater01@luther.edu
--
-- Modified by Arya Chowdhury Mugdha (2017) (arya.mugdha@colostate.edu)
--
-- cascaded integrator comb filter for a lock-in amplifier
-- Initial implementation: 2-stage, 1000x decimator
-- should have about 26 dB nearest-sideband suppression
-- Intended to drop 1 MS/s to 1 kS/s sample rate. Effectively a ~0.5 kHz low-pass
--
-- for a N=2-stage, R=1000x decimating CIC with M=1,
-- the output gain is G=(RM)=1,000,000
-- an additional 20 bits are needed to accomodate this gain
-- input of 12 bits; output is 16 bits

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

ENTITY cic_filter IS
	PORT(
		clk_sys_in		: IN 	std_logic;														-- system clk		
		clk_in			: IN  std_logic;														-- input sample rate clock
		data_in			: IN  std_logic_vector(11 downto 0):= (others => '0');	-- sample data in.
		gain_ctrl_cic	: IN  std_logic_vector (5 downto 0);
		clk_out 			: OUT std_logic;														-- output clock (clk_in / 1000)
		data_out			: OUT std_logic_vector(15 downto 0);								-- data out
		overflow			: OUT std_logic
	);
END cic_filter;

ARCHITECTURE arch OF cic_filter IS 


	-- latched, 32-bit data in
	signal l_data_in											: signed(43 downto 0);
	signal data_in_gc											: std_logic_vector(43 downto 0);

	-- outputs for each integrator stage
	signal integrator_out_1, integrator_in_1, integrator_in_2,	integrator_out_2		: signed(43 downto 0) := (others => '0');
	
	-- delayed outputs for each integrator stage
	signal l_integrator_out_1, 	l_integrator_out_2 	: signed(43 downto 0) := (others => '0');
	
	-- inputs for each comb stage
	signal comb_in_1,		comb_out_1,		comb_in_2 				: signed(43 downto 0) := (others => '0');
	
	-- delayed inputs for each comb stage
	signal l_comb_in_1,			l_comb_in_2 			: signed(43 downto 0) := (others => '0');
	
	-- decimation clock
	signal clk_decimated										: std_logic;
	signal count												: natural range 1 to 50000 := 1;
	
	
	COMPONENT cic_gain_controller IS
		PORT(
			clk_in		: IN  std_logic;								-- input sample rate clock
			data_in		: IN  std_logic_vector(43 downto 0);	-- sample data in, Q12._
			gain			: IN  std_logic_vector (5 downto 0);
			data_out_g	: OUT std_logic_vector(15 downto 0);		-- data out
			ovrflw		: OUT std_logic
		);
		END COMPONENT;

	
begin


	
	l_data_in <= resize(signed(data_in),44);
	
		
	integrator : process( clk_in )
	begin	
		
		if ( rising_edge( clk_in) ) then
				
			-- sums
			integrator_in_1 		<= l_data_in;
			
			integrator_out_1 		<= (integrator_in_1) 	+ (integrator_out_1);
			
			integrator_in_2		<= integrator_out_1;
			integrator_out_2 		<= (integrator_in_2) 	+ (integrator_out_2);
			
			
		end if;
		end process;

	
	decimation_clock : process( clk_in )
	begin
		if( rising_edge(clk_in) ) then
			if( count = 50000 ) then				-- Change this value to change the decimation
				count <= 1;
				clk_decimated <= '1';
			else
				count <= count + 1;
				clk_decimated	<= '0';	
			end if;
		end if;
	end process decimation_clock;
	clk_out <= clk_decimated;
	
	combs : process( clk_decimated )
	begin
		if rising_edge( clk_decimated ) then
			-- decimation of integrator output
			comb_in_1	<= integrator_out_2;
			
			comb_out_1 <= comb_in_1 - integrator_out_2;
			-- sums
			comb_in_2	<= ( comb_out_1 );
			data_in_gc		<= std_logic_vector( (comb_in_2) - (comb_out_1) );
			
						
			
		end if;
	end process;
		
	
	
	cic_gain_ctrl_inst : cic_gain_controller
	port map
	(
		clk_in			=>		clk_decimated,
		data_in			=>		data_in_gc,
		gain				=>		gain_ctrl_cic,
		data_out_g		=>		data_out,
		ovrflw			=>		overflow
	);
	
		

end arch;