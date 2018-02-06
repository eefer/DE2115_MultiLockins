# eight lockins frequency comb for FPGA lock-ins
# (Wilson lab, ECE Dept, Colorado State University)
# 

set masters [get_service_paths master]

set master [lindex $masters 0]

open_service master $master

# the following lines determine the frequencies of the 8 lockins respectively

#lockin 1
master_write_32 $master 0x00000000 13946

#lockin 2
master_write_32 $master 0x00000010 13946

#lockin 3
master_write_32 $master 0x00000020 13946

#lockin 4
master_write_32 $master 0x00000030 13946

#lockin 5
master_write_32 $master 0x00000040 13946

#lockin 6
master_write_32 $master 0x00000050 13946

#lockin 7
master_write_32 $master 0x00000060 13946

#lockin 8
master_write_32 $master 0x00000070 13946

# the following lines determine the phase offsets of the 8 lockins respectively

#lockin 1
master_write_32 $master 0x10000000 0

#lockin 2
master_write_32 $master 0x10000010 0

#lockin 3
master_write_32 $master 0x10000020 0

#lockin 4
master_write_32 $master 0x10000030 0

#lockin 5
master_write_32 $master 0x10000040 0

#lockin 6
master_write_32 $master 0x10000050 0

#lockin 7
master_write_32 $master 0x10000060 0

#lockin 8
master_write_32 $master 0x10000070 0


# the following line determines the post cic bit slice selection
# example: when selected 0, MSB downto (MSB - 16) output bits from the cic filter is selected and fed to the lockin outputs
#			  when selected 1, MSB-1 downto (MSB - 16) - 1 output bits from the cic filter is selected and fed to the lockin outputs
# increasing this value performs the operation of division by powers of 2

master_write_32 $master 0x20000000 0

# the following line determines the integer multiplier of the DAC output

master_write_32 $master 0x50000000 5

# the following line determines the bit slice selector (division by a factor of 2)

master_write_32 $master 0x51000000 2

# the following line determines which lockins are turned on or off


master_write_32 $master 0x52000000 255