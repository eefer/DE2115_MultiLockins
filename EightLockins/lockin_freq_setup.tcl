set masters [get_service_paths master]

set master [lindex $masters 0]

open_service master $master

master_write_32 $master 0x00000000 1310

master_write_32 $master 0x00000010 1250

master_write_32 $master 0x00000020 1150

master_write_32 $master 0x00000030 1080

master_write_32 $master 0x00000040 1000

master_write_32 $master 0x00000050 920

master_write_32 $master 0x00000060 840

master_write_32 $master 0x00000070 700

master_write_32 $master 0x10000000 524288

master_write_32 $master 0x10000010 524288

master_write_32 $master 0x10000020 524288

master_write_32 $master 0x10000030 524288

master_write_32 $master 0x10000040 524288

master_write_32 $master 0x10000050 524288

master_write_32 $master 0x10000060 524288

master_write_32 $master 0x10000070 524288