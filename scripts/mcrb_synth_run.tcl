set_db init_lib_search_path {/home/01fe21bec255/DFT_Internship/inputs/lib}
set_db init_hdl_search_path {/home/01fe21bec255/DFT_Internship/inputs/rtl}
read_libs NangateOpenCellLibrary_slow_conditional_ccs.lib
read_hdl mcrb.v
elaborate
read_sdc /home/01fe21bec255/DFT_Internship/inputs/sdc/mcrb_constraints.sdc


#slow,medium,high,express
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

#report
report_timing > ../outputs/reports/mcrb_nangate_timing_report.rpt
report_power > ../outputs/reports/mcrb_nangate_power_report.rpt
report_area > ../outputs/reports/mcrb_nangate_area_report.rpt
report_gates > ../outputs/reports/mcrb_nangate_gate_report.rpt

write_hdl > ../outputs/netlist/mcrb_syn_nangate.v
write_sdc > ../outputs/sdc/mcrb_sdc.sdc

gui_show
