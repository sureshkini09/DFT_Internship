set_context dft -scan
read_verilog ../../OUTPUTS/s298_syn_nangate.v
read_cell_library ../../nangate/test_Nangate.mdt 
set_current_design s298
analyze_control_signals -auto
check_design_rules
analyze_scan_chains 
insert_test_logic

report_scan_elements > ./OUTPUTS/mcrb_scan_elements.txt
report_scan_chains > ./OUTPUTS/mcrb_scan_chains.txt
report_scan_cells > ./OUTPUTS/mcrb_scan_cells.txt
report_scan_enable > ./OUTPUTS/mcrb_scan_enable.txt

write_design -output_file ../../OUTPUTS/mcrb_tessent_scan_net.v -replace
set_system_mode setup
open_visualizer
