onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Maintenence /FIR_Filter_testbench/clk
add wave -noupdate -expand -group Maintenence /FIR_Filter_testbench/reset
add wave -noupdate -expand -group Input /FIR_Filter_testbench/en
add wave -noupdate -expand -group Input -radix decimal /FIR_Filter_testbench/dataIn
add wave -noupdate -expand -group Wires -radix decimal /FIR_Filter_testbench/dut/divIn
add wave -noupdate -expand -group Wires -radix decimal /FIR_Filter_testbench/dut/fifoOut
add wave -noupdate -expand -group Wires -radix decimal /FIR_Filter_testbench/dut/negFifoOut
add wave -noupdate -expand -group Wires -radix decimal /FIR_Filter_testbench/dut/divInFifoSum
add wave -noupdate -expand -group Output /FIR_Filter_testbench/dataOut
add wave -noupdate -expand -group Fifo -radix decimal /FIR_Filter_testbench/dut/BUFFER/w_data
add wave -noupdate -expand -group Fifo -radix decimal /FIR_Filter_testbench/dut/BUFFER/r_data
add wave -noupdate -expand -group Fifo -radix unsigned /FIR_Filter_testbench/dut/BUFFER/w_addr
add wave -noupdate -expand -group Fifo -radix unsigned /FIR_Filter_testbench/dut/BUFFER/r_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
