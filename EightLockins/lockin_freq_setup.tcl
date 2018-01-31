# eight lockins frequency comb for FPGA lock-ins
# (Wilson lab, ECE Dept, Colorado State University)
# 

set masters [get_service_paths master]

set master [lindex $masters 0]

open_service master $master

# the following lines determine the frequencies of the 8 lockins respectively

#lockin 1
master_write_32 $master 0x00000000 10000

#lockin 2
master_write_32 $master 0x00000010 10000

#lockin 3
master_write_32 $master 0x00000020 10000

#lockin 4
master_write_32 $master 0x00000030 10000

#lockin 5
master_write_32 $master 0x00000040 10000

#lockin 6
master_write_32 $master 0x00000050 10000

#lockin 7
master_write_32 $master 0x00000060 10000

#lockin 8
master_write_32 $master 0x00000070 10000

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

master_write_32 $master 0x20000000 0