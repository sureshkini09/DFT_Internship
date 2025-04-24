set_context patterns -scan
read_verilog c1.v
set_current_design c1
set_system_mode analysis

// run fault simulation for f/1
set_pattern_source external c1_pat_f1.ascii
add_faults -All
simulate_patterns
report_statistics
report_faults -class DS
reset state

// run fault simulation for h/1
set_pattern_source external c1_pat_h1.ascii
add_faults -All
simulate_patterns
report_statistics
report_faults -class DS
reset state

exit -d
