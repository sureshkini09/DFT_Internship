set VERILOG s298_Modified
set TOP_MODULE s298
set LIB_PATH
set LEF_PATH

read_libs ../RAK_180/LIB/slow.lib
read_physical -lef ../RAK_180/LEF/all.lef

read_hdl netlist/${VERILOG}.v

elaborate ${TOP_MODULE}
#write_hdl > OUTPUTS/elaborate.v
read_sdc netlist/constraints.sdc

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium


syn_generic
#write_hdl > OUTPUTS/gen.v
syn_map
#write_hdl > OUTPUTS/map.v
syn_opt
#write_hdl > OUTPUTS/opt.v

report_area > REPORTS/${TOP_MODULE}_area.rep
report_power > REPORTS/${TOP_MODULE}_power.rep
report_gates > REPORTS/${TOP_MODULE}_gates.rep
report_timing > REPORTS/${TOP_MODULE}_timing.rep
report_qor -levels_of_logic -power -exclude_constant_nets > REPORTS/${TOP_MODULE}_qor_all.rep


write_hdl > OUTPUTS/${TOP_MODULE}_netlist.v
write_sdc > OUTPUTS/${TOP_MODULE}_sdc_dft.sdc
write_sdf -nonegchecks -edges check_edge -timescale ns -recrem split -setuphold split > OUTPUTS/delays.sdf
gui_show
