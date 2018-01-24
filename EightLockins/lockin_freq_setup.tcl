set masters [get_service_paths master]

set master [lindex $masters 0]

open_service master $master

# the following lines determine the frequencies of the 8 lockins respectively

#lockin 1
master_write_32 $master 0x00000000 2500

#lockin 2
master_write_32 $master 0x00000010 2400

#lockin 3
master_write_32 $master 0x00000020 2300

#lockin 4
master_write_32 $master 0x00000030 2200

#lockin 5
master_write_32 $master 0x00000040 2600

#lockin 6
master_write_32 $master 0x00000050 2700

#lockin 7
master_write_32 $master 0x00000060 2800

#lockin 8
master_write_32 $master 0x00000070 2900

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