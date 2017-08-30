set masters [get_service_paths master]

set master [lindex $masters 0]

open_service master $master

master_write_32 $master 0x00000000 1310

master_write_32 $master 0x00000010 0

master_write_32 $master 0x10000000 0

master_write_32 $master 0x10000010 0

