set_context patterns -scan
read_verilog c2.v
set_current_design c2
set_system_mode analysis

// run fault simulation
set_pattern_source external c2_01010_1.pat
add_faults -all
simulate_patterns
report_statistics
report_faults -class DS
reset_state

// run fault simulation
set_pattern_source external c2_11011_2.pat 
add_faults -all
simulate_patterns
report_statistics
report_faults -class DS
reset_state

// run fault simulation 
set_pattern_source external c2_00110_3.pat
add_faults -all
simulate_patterns
report_statistics
report_faults -class DS

exit -d
