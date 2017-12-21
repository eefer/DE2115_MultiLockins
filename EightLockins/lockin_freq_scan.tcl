set masters [get_service_paths master]

set master [lindex $masters 0]

open_service master $master

master_write_32 $master 0x20000000 6

set filename "test.txt"
set fileId [open $filename "w"]
for {set i 17481} {$i < 25669} {incr i} {master_write_32 $master 0x00000000 $i
after 10
set data [master_read_32 $master 0x31000000 1]
set data2 [format %X $data]
puts $fileId $data2
}
close $fileId

close_service master $master