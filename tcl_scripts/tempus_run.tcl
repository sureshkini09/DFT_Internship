#Setting Top module
set TOP_MODULE "mcrb"


#Creating report directory
mkdir reports


#Reading of libraries
read_lib /home/01fe21bec255/DFT/MCRB/nangate/NangateOpenCellLibrary_slow_conditional_ccs.lib


#Don't put input delay for all the ports
set_global timing_apply_default_primary_input_assertion false


#Reading of netlist
read_verilog /home/01fe21bec255/DFT/MCRB/OUTPUT/mcrb_nangate_syn.v
 
set_top_module $TOP_MODULE 


#Reading constraints
Read_sdc /home/01fe21bec255/DFT/MCRB/Constraints/mcrb.sdc


#Reporting 
report_clock_timing -type summary > ./reports/clock_summary.rpt

set_global report_timing_format {hpin cell arc slew load delay arrival}

check_timing -verbose -type {loops inputs endpoints clocks constant_collision clock_gating_inferred clock_clipping} -include_warning clocks_masked_by_another_clock > ./reports/check_timing_verbose.rpt

check_timing -check_only {clock_crossing} -verbose > ./reports/clock_crossings.rpt

report_clocks -groups > ./reports/report_clock_groups.rpt

report_constraint -all_violators > ./reports/report_allViolators.rpt 

report_timing -max_path 20 > timing_report_setup_check.rpt

report_timing -early -max_path 20 > timing_report_hold_check.rpt

