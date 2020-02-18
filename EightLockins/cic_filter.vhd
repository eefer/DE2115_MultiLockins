-- CIC filter
-- Jesse Wilson (2015) jesse.wilson@duke.edu
-- Warren Lab, Chemistry Dept, Duke University
--
-- Revised by Erin Flater (2017) flater01@luther.edu
--
-- Modified by Arya Chowdhury Mugdha (2017) (arya.mugdha@colostate.edu)
--
-- cascaded integrator comb filter for a lock-in amplifier
-- Initial implementation: 2-stage, 50,000x decimator
-- should have about 26 dB nearest-sideband suppression
-- Intended to drop 50 MS/s to 1 kS/s sample rate. Effectively a ?? kHz low-pass
--
-- for a N=2-stage, R=50,000x decimating CIC with M=1,
-- the output gain is G=(RM)=??
-- an additional 20 bits are needed to accomodate this gain

-- note on gain control:
-- Input of 12 bits; raw output of the CIC is 59 bits wide.
-- We only keep 16 bits. That 16-bit slice is selected from the 59-bit
-- CIC result by the gain controller. The position of the 16-bit slice
-- effectively results in a gain factor. Sliding the window 1 position towards the 
-- MSB decreases gain by 2x, while sliding 1 position towards the LSB
-- increases gain by 2x. If the gain is set too high, overflow will result.
-- If gain is too low, there is risk of losing precision.

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

ENTITY cic_filter IS
	PORT(
		clk_sys_in		: IN 	std_logic;										-- system clk		
		clk_in			: IN  std_logic;										-- input sample rate clock
		data_in			: IN  std_logic_vector(26 downto 0):= (others => '0');	-- sample data in.
		gain_ctrl_cic	: IN  std_logic_vector (5 downto 0);					-- gain factor at output (bit slice selection)
		clk_out 		: OUT std_logic;										-- output clock (clk_in / 50,000)
		data_out		: OUT std_logic_vector(15 downto 0);					-- data out
		overflow		: OUT std_logic											-- indicates overflow at output gain stage
	);
END cic_filter;

ARCHITECTURE arch OF cic_filter IS 


	-- latched, 32-bit data in
	signal l_data_in											: signed(58 downto 0);
	signal data_in_gc											: std_logic_vector(58 downto 0);

	-- outputs for each integrator stage
	signal integrator_out_1, integrator_in_1, integrator_in_2,	integrator_out_2		: signed(58 downto 0) := (others => '0');
	
	-- delayed outputs for each integrator stage
	signal l_integrator_out_1, 	l_integrator_out_2 	: signed(58 downto 0) := (others => '0');
	
	-- inputs for each comb stage
	signal comb_in_1,		comb_out_1,		comb_in_2 				: signed(58 downto 0) := (others => '0');
	
	-- delayed inputs for each comb stage
	signal l_comb_in_1,			l_comb_in_2 			: signed(58 downto 0) := (others => '0');
	
	-- decimation clock
	signal clk_decimated										: std_logic;
	signal count												: natural range 1 to 50000 := 1;
	
	
	COMPONENT cic_gain_controller IS
		PORT(
			clk_in		: IN  std_logic;						-- input sample rate clock
			data_in		: IN  std_logic_vector(58 downto 0);	-- sample data in, Q58._
			gain		: IN  std_logic_vector (5 downto 0);	-- gain factor (bit slice selection)
			data_out_g	: OUT std_logic_vector(15 downto 0);	-- data out
			ovrflw		: OUT std_logic							-- indicates overflow
		);
		END COMPONENT;

	
begin


	-- sign extend input to final output bit width
	l_data_in <= resize(signed(data_in),59);
	
	-- STEP 1: integrators
	integrator : process( clk_in )
	begin	
		if ( rising_edge( clk_in) ) then
				
			-- integrator stage 1
			integrator_in_1 	<= l_data_in;
			integrator_out_1 	<= (integrator_in_1) + (integrator_out_1);
			
			-- integrator stage 2
			integrator_in_2		<= integrator_out_1;
			integrator_out_2 	<= (integrator_in_2) + (integrator_out_2);
			
		end if;
		end process;

	-- STEP 2: generate reduced sample rate using a counter that outputs
	--         a '1' every time the counter wraps around
	decimation_clock : process( clk_in )
	begin
		if( rising_edge(clk_in) ) then
			if( count = 50000 ) then	-- This value to sets output clock rate
				count <= 1;
				clk_decimated <= '1';
			else
				count <= count + 1;
				clk_decimated	<= '0';	
			end if;
		end if;
	end process decimation_clock;
	clk_out <= clk_decimated; 		-- forward decimated clk to module output pin
	
	-- STEP 3: comb filters
	--         The integrator output is decimated (sample rate reduced)
	--         by running this process at the lower clock rate.
	combs : process( clk_decimated )
	begin
		if rising_edge( clk_decimated ) then
			-- comb stage 1
			comb_in_1	<= integrator_out_2;
			comb_out_1 	<= comb_in_1 - integrator_out_2;
			
			-- comb stage 2
			comb_in_2	<= ( comb_out_1 );
			data_in_gc	<= std_logic_vector( (comb_in_2) - (comb_out_1) );			
			
		end if;
	end process;
		
	-- CIC output gain stage
	-- selects a 16-bit slice from the 59-bit CIC output
	cic_gain_ctrl_inst : cic_gain_controller
	port map
	(
		clk_in			=>		clk_decimated,	-- output clock
		data_in			=>		data_in_gc,		-- input to gain stage
		gain			=>		gain_ctrl_cic,	-- gain factor
		data_out_g		=>		data_out,		-- output from gain stage
		ovrflw			=>		overflow		-- indicates overflow
	);

end arch;