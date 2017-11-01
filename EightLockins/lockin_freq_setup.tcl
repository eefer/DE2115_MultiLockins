set masters [get_service_paths master]

set master [lindex $masters 0]

open_service master $master

master_write_32 $master 0x00000000 13946
#lockin 1 = 665 kHz

master_write_32 $master 0x00000010 12500
#lockin 2 = 670 kHz

master_write_32 $master 0x00000020 12500
#lockin 3 = 675 kHz

master_write_32 $master 0x00000030 0
#lockin 4 = 680 kHz

master_write_32 $master 0x00000040 0
#lockin 5 = 685 kHz

master_write_32 $master 0x00000050 0
#lockin 6 = 690 kHz

master_write_32 $master 0x00000060 0
#lockin 7 = 695 kHz

master_write_32 $master 0x00000070 0
#lockin 8 = 700 kHz

master_write_32 $master 0x10000000 0

master_write_32 $master 0x10000010 0

master_write_32 $master 0x10000020 0

master_write_32 $master 0x10000030 0

master_write_32 $master 0x10000040 0

master_write_32 $master 0x10000050 0

master_write_32 $master 0x10000060 0

master_write_32 $master 0x10000070 0

master_write_32 $master 0x20000000 8