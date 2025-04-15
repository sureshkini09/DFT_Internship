set_context dft -scan
read_verilog ../inputs/rtl/mcrb.v
read_cell_library ../inputs/mdt/test_Nangate.mdt 
set_current_design mcrb
analyze_control_signals -auto
check_design_rules
analyze_scan_chains 
insert_test_logic

report_scan_elements > ../outputs/mcrb_scan_elements.txt
report_scan_chains > ../outputs/mcrb_scan_chains.txt
report_scan_cells > ../outputs/mcrb_scan_cells.txt
report_scan_enable > ../outputs/mcrb_scan_enable.txt

write_design -output_file ./outputs/mcrb_scan.v -replace
set_system_mode setup
open_visualizer
