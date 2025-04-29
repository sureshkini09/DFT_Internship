#python script to convert verilog view to memlib view
python3 convert.py <path-to-verilog-file> file.memlib

#verilog options

+define+nobanner
+pulse_x/0
+pulse_r/0
+pathpulse
+define+verbose_0

#memlib
memlibc -memLib ../SPRAM_16x4.memlib -extension v:vg -simModelDir ../memory/spram/6M1L/SPRAM_16x4/ -tshell -verilogOptionFile VerilogOptions 

#simModelDir -> location to memory .v file

#make gen
#make testbench
#make sin_rtl

make all
