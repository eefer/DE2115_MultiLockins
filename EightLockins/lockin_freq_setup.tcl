set masters [get_service_paths master]

set master [lindex $masters 0]

open_service master $master

master_write_32 $master 0x00000000 13946
#lockin 1 = 665 kHz

master_write_32 $master 0x00000010 14051
#lockin 2 = 670 kHz

master_write_32 $master 0x00000020 14156
#lockin 3 = 675 kHz

master_write_32 $master 0x00000030 14261
#lockin 4 = 680 kHz

master_write_32 $master 0x00000040 14365
#lockin 5 = 685 kHz

master_write_32 $master 0x00000050 14470
#lockin 6 = 690 kHz

master_write_32 $master 0x00000060 14575
#lockin 7 = 695 kHz

master_write_32 $master 0x00000070 14680
#lockin 8 = 700 kHz

master_write_32 $master 0x10000000 0

master_write_32 $master 0x10000010 0

master_write_32 $master 0x10000020 0

master_write_32 $master 0x10000030 0

master_write_32 $master 0x10000040 0

master_write_32 $master 0x10000050 0

master_write_32 $master 0x10000060 0

master_write_32 $master 0x10000070 0