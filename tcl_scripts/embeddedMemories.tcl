# i. instance count of memories in the netlist
set sram_inst [sizeof_collection [get_cells -of_objects sram_sp_*]]
set rf_inst [sizeof_collection [get_cells -of_objects rf_2p_*]]
puts "Total memory cells = [expr {$sram_inst + $rf_inst}]"

# Output : 
# Total memory cells = 28

# ii. list of memory configurations (i.e., type of memories) that have been instantiated
# There are 6 different configuration memories,
# sram_sp_32768d_33w_16m_8b :  6 instances
# sram_sp_16384d_36w_16m_8b : 4 instances
# rf_2p_136d_74w_1m_4b : 8 instances
# rf_2p_256d_76w_1m_4b : 4 instances
# rf_2p_512d_76w_2m_4b : 4 instances
# sram_sp_512d_32w_4m_2b : 2 instances


# iii. count of flip-flops in the netlist
set ff_count [sizeof_collection [all_registers -flops]]
puts "FF count : $ff_count"
# Outputs : 
# FF count : 61161

# iV. total number of instances in the netlist
reportVtInstCount
# Instances in design      = 303355

# V. list of all clocks in the netlist and their sources
sizeof_collection [all_clocks]
report_clocks -generated >> clock_sources.rpt

