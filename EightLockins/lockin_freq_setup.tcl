# eight lockins frequency comb for FPGA lock-ins
# (Wilson lab, ECE Dept, Colorado State University)
# 

set masters [get_service_paths master]

set master [lindex $masters 0]

open_service master $master

# the following codes determine the frequencies of the 8 lockins respectively

#lockin 1
master_write_32 $master 0x00000000 13946

#lockin 2
master_write_32 $master 0x00000010 14051

#lockin 3
master_write_32 $master 0x00000020 14156

#lockin 4
master_write_32 $master 0x00000030 14261

#lockin 5
master_write_32 $master 0x00000040 14365

#lockin 6
master_write_32 $master 0x00000050 14470

#lockin 7
master_write_32 $master 0x00000060 14575

#lockin 8
master_write_32 $master 0x00000070 14680

# the following codes determine the phase offsets of the 8 lockins respectively

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


# the following code determines the post cic bit slice selection
# example: when selected 0, MSB downto (MSB - 16) output bits from the cic filter is selected and fed to the lockin outputs
#			  when selected 1, MSB-1 downto (MSB - 16) - 1 output bits from the cic filter is selected and fed to the lockin outputs
# increasing this value performs the operation of division by powers of 2

master_write_32 $master 0x20000000 0


# the following code determines the integer multiplier of the DAC output (range 0 to 255)

master_write_32 $master 0x50000000 2


# the following code determines the bit slice selector (division by a factor of 2)
# the integer multiplier and bit slice selector need to be adjusted together to obtain the suitable amount of output dynamic range from the DAC

master_write_32 $master 0x51000000 2


# the following code determines which lockins are turned on or off (MSB => lockin 8, LSB => lockin 1)
# example: putting in 255 decimal = 11111111 binary, means all the 8 lockins are active
#			  putting in 15 decimal = 00001111 binary, means lockins 1 to 4 out of the 8 lockins are active
# 			  putting in 17 decimal = 00010001 binary, means lockins 1 and 5 are active

master_write_32 $master 0x52000000 255