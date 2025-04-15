set VERILOG "mcrb"
set TOP_MODULE "mcrb"
// set PATH /home/01fe21bee114/DFT/DFT
set PATH /home/01fe21bec255/DFT_Internship

set_context dft -scan -design_identifier gate

read_verilog ${PATH}/outputs/netlist/mcrb_nangate_syn.v
read_cell_library ${PATH}/inputs/mdt/test_Nangate.mdt 

set_current_design ${TOP_MODULE}
add_black_boxes -auto
set_design_level physical_block
analyze_control_signals -auto
check_design_rules
analyze_wrapper_cells
set_scan_insertion_options -single_class_chains on -single_wrapper_type_chains on -single_power_domain_chains on -single_cluster_chains on
add_scan_mode int_mode -type internal -chain_length 2  -chain_count 1 -single_power_domain_chains on
//add_scan_mode ext_mode -type external -chain_length 2  -chain_count 1 -single_power_domain_chains on
analyze_scan_chains 

report_scan_elements    > ${PATH}/reports/${TOP_MODULE}_REPORTS/tessent_${TOP_MODULE}_scan_elements.txt
report_scan_chains      > ${PATH}/reports/${TOP_MODULE}_REPORTS/tessent_${TOP_MODULE}_scan_chains.txt
report_scan_cells       > ${PATH}/reports/${TOP_MODULE}_REPORTS/tessent_${TOP_MODULE}_scan_cells.txt
report_scan_enable      > ${PATH}/reports/${TOP_MODULE}_REPORTS/tessent_${TOP_MODULE}_scan_enable.txt

insert_test_logic -verbose

write_design -output_file ${PATH}/outputs/netlist/tessent_${TOP_MODULE}_scan_netlist.v -replace

set_system_mode setup
open_visualizer
