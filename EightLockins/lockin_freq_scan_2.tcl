set masters [get_service_paths master]

set master [lindex $masters 0]

open_service master $master

master_write_32 $master 0x20000000 4

set filename "results.csv"
set fileId [open $filename "w"]

# write header
set outstr [format "freq(phsincr),xunsigned,yunsigned"]
puts $fileId $outstr

puts "program started"

for {set i 104} {$i < 2104} {incr i} {

	# change lock-in frequency
	master_write_32 $master 0x00000000 $i
	
	# wait 10 ms settling time
	after 10

	# read data from FPGA
	set datax [master_read_32 $master 0x30000000 1]
	set datay [master_read_32 $master 0x31000000 1]

	# write data to file
	set outstr [format "%d,%d,%d" $i $datax $datay]
	puts $fileId $outstr
}

close $fileId

close_service master $master

puts "program ended"