set_db init_lib_search_path {/home/01fe21bec255/DFT/S298_Traffic_light_controller/nangate}
set_db init_hdl_search_path {/home/01fe21bec255/DFT/S298_Traffic_light_controller/netlist}
read_libs NangateOpenCellLibrary_slow_conditional_ccs.lib
read_hdl s298_Modified.v
elaborate
read_sdc /home/01fe21bec255/DFT/S298_Traffic_light_controller/netlist/constraints.sdc

#slow,medium,high,express
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

syn_gen
syn_map
syn_opt

#report
#report_timing > reports/timing_report.rpt
#report_power > reports/power_report.rpt
#report_area > reports/area_report.rpt
#report_gates > report/gate_report.rpt

#outputs
write_hdl > ../OUTPUTS/s298_syn_nangate.v
#write_sdc > outputs/sdc.sdc
#write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > output/delay.sdf

#set_db / .library  /cad_area/install/FOUNDRY/digital/180nm/dig/lib/slow.lib;
#set_db / .lef_library /cad_area/install/FOUNDRY/digital/180nm/dig/lef/all.lef;
#read_hdl filename.v;
#laborate topmodule_name;
#ead_sdc  filename.sdc;
#et_db / .syn_generic_effort medium;
#yn_gen;
#et_db / .syn_map_effort medium;
#yn_map;
#et_db / .syn_opt_effort medium;
#yn_opt;
#eport area;
#eport power;;
#report timing -unconstrained;
#write_hdl > design_syn_.v;
#write_sdc > design_syn_.sdc;
#gui_show;


#cad_area/install/FOUNDRY/digital/180nm/dig/lib


