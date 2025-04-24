set_context patterns -scan
read_verilog c1.v
set_current_design c1
set_system_mode analysis

// run test pattern generation
add_faults -all
create_patterns
report_faults -class DS
exit -d
