#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
# Modified by E. Flater (2017,2018)
# Modified by Saurabh Gupta, Wilson Lab, CSU
# 
# Modified by Arya Chowdhury Mugdha (2018),	arya.mugdha@colostate.edu
# Wilson Lab, ECE Dept., Colorado State University
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 [get_ports CLOCK_50]
create_clock -period 20 [get_ports CLOCK2_50]
create_clock -period 20 [get_ports CLOCK3_50]
create_clock -name altera_reserved_tck [get_ports {altera_reserved_tck}] -period 10MHz   

create_clock -period 20 [get_ports ADA_DCO]
create_clock -period 20 [get_ports FPGA_CLK_A_P]
create_clock -period 20 [get_ports FPGA_CLK_A_N]
create_clock -period 20 [get_ports FPGA_CLK_B_P]
create_clock -period 20 [get_ports FPGA_CLK_B_N]
create_clock -period 40 [get_nets ll_fifo_write]


create_clock -period 100 [get_ports {GPIO[8]}]
create_clock -period 1KHz [get_ports {GPIO[17]}]
create_clock -period 1KHz [get_ports {GPIO[14]}]
create_clock -period 1KHz [get_ports {GPIO[15]}]

create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_1|cic_x|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_1|cic_y|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_2|cic_x|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_2|cic_y|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_3|cic_x|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_3|cic_y|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_4|cic_x|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_4|cic_y|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_5|cic_x|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_5|cic_y|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_6|cic_x|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_6|cic_y|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_7|cic_x|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_7|cic_y|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_8|cic_x|clk_decimated}]
create_generated_clock -edges {1 3 100001} -source [get_ports ADA_DCO] [get_nets {eight_lia_pkg_merged_inst|lockin_8|cic_y|clk_decimated}]



#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks -create_base_clocks


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock ADA_DCO 1.000 {ADA_D[*] ADA_OR}

set_input_delay -add_delay -min -clock ADA_DCO -1.000 {ADA_D[*] ADA_OR}

set_input_delay -add_delay -max -clock CLOCK_50 1.000 {KEY[0] KEY[3]}

set_input_delay -add_delay -min -clock CLOCK_50 -1.000 {KEY[0] KEY[3]}

set_input_delay -add_delay -max -clock altera_reserved_tck 1.000 { altera_reserved_tdi }

set_input_delay -add_delay -min -clock altera_reserved_tck -1.000 { altera_reserved_tdi }

set_input_delay -add_delay -max -clock altera_reserved_tck 1.000 { altera_reserved_tms }

set_input_delay -add_delay -min -clock altera_reserved_tck -1.000 { altera_reserved_tms }



#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock CLOCK_50 1.000 {GPIO[*] LEDG[*] LEDR[*]}

set_output_delay -add_delay -min -clock CLOCK_50 -1.000 {GPIO[*] LEDG[*] LEDR[*]}


set_output_delay -add_delay -max -clock altera_reserved_tck 1.000 { altera_reserved_tdo }

set_output_delay -add_delay -min -clock altera_reserved_tck -1.000 { altera_reserved_tdo }

set_output_delay -add_delay -max -clock CLOCK_50 0.000 { FPGA_CLK_A_N FPGA_CLK_A_P }

set_output_delay -add_delay -min -clock CLOCK_50 -1.000 {FPGA_CLK_A_N FPGA_CLK_A_P }

set_output_delay -add_delay -max -clock CLOCK_50 0.000 { FPGA_CLK_B_N FPGA_CLK_B_P }

set_output_delay -add_delay -min -clock CLOCK_50 -1.000 {FPGA_CLK_B_N FPGA_CLK_B_P }

#set_output_delay -clock FPGA_CLK_A_P -max 0.0 {DA[*] DB[*]}
#set_output_delay -clock FPGA_CLK_A_P -min 0.0 {DA[*] DB[*]}

set_output_delay -clock FPGA_CLK_B_P -max 0.0 {DA[*] DB[*]}
set_output_delay -clock FPGA_CLK_B_P -min 0.0 {DA[*] DB[*]}


#**************************************************************
# Set Clock Groups
#**************************************************************
set_clock_groups -asynchronous -group {GPIO[8]}

set_clock_groups -asynchronous -group {GPIO[17]}
set_clock_groups -asynchronous -group {GPIO[14]}
set_clock_groups -asynchronous -group {GPIO[15]}


#**************************************************************
# Set False Path
#**************************************************************


set_false_path  -from  *  -to  [get_ports {LEDG[*] LEDR[*] SW[16] SW[17]} ]

set_false_path  -from  [get_ports {LEDG[*] LEDR[*] SW[16] SW[17]} ]  -to  *
#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



