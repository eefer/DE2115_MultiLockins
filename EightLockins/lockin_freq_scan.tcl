# single lockin frequency sweep for FPGA lock-in
# (Wilson lab, ECE Dept, Colorado State University)
# 
# qsys avalon memory addresses / registers
#
# address 		description
# 0x00000000	Lockin 1 freq control
# 0x20000000	post-CIC bit slice selection
# 0x30000000	Lockin 1 X output
# 0x31000000 	Lockin 1 Y output
#
#
# NOTES ON NCO FREQ CONTROL
# Final frequency is f0 / (2^20 / phase_incr)
# e.g., for a 50 MHz system clock, phase_incr of 5243 yields a 250 kHz output here


set masters [get_service_paths master]
puts "starting"

set master [lindex $masters 0]

open_service master $master

# post cic bit slice selection determined in the following line...this should be adjusted to make sure that the overflow light does not stay lit

master_write_32 $master 0x20000000 8


# the X and Y output results of the lockin would be saved on the following .txt file
set filename "test.txt"
set fileId [open $filename "w"]

# the lower and upper limits of the i in the following line determines the frequency scan range of the lockin
for {set i 17481} {$i < 25669} {incr i} {	
	master_write_32 $master 0x00000000 $i
	set data [master_read_32 $master 0x31000000 1]
	set data2 [format %X $data]
	puts $fileId $data2
}
puts "ended"
close $fileId

close_service master $master