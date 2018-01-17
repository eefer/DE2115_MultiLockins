# frequency sweep for FPGA lock-in
# (Wilson lab, ECE Dept, Colorado State University)
# 
# qsys avalon memory addresses / registers
#
# address 		description
# 0x00000000	Lockin 1 freq control
# 0x20000000	post-CIC gain?
# 0x31000000 	Lockin 1 X/Y outputs
#
#
# NOTES ON NCO FREQ CONTROL
# Final frequency is f0 / (2^20 / phase_incr)
# e.g., for a 50 MHz system clock, phase_incr of 5243 yields a 250 kHz output here


set masters [get_service_paths master]
puts "starting"

set master [lindex $masters 0]

open_service master $master

master_write_32 $master 0x20000000 8

set filename "test.txt"
set fileId [open $filename "w"]
for {set i 17481} {$i < 25669} {incr i} {	
	master_write_32 $master 0x00000000 $i
	set data [master_read_32 $master 0x31000000 1]
	set data2 [format %X $data]
	puts $fileId $data2
}
puts "ended"
close $fileId

close_service master $master