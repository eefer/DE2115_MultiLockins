set filename "test.txt"
set fileId [open $filename "w"]
for {set i 12163} {$i < 16357} {incr i} {master_write_32 $master 0x00000000 $i
after 10
set data [master_read_32 $master 0x30000000 1]
set data2 [format %X $data]
puts $fileId $data2
}
close $fileId