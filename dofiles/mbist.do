set_context dft -rtl
read_cell_library ../library/adk.tcelllib
set_design_sources -format verilog -y {../library/mem ../design/rtl} \ -extension v
set_design_sources -format tcd_memory -y ../library/mem -extension lib
read_verilog ../design/rtl/blockA.v
set_current_design blockA

#Specify and Verify DFT Requirements
set_design_level physical_block
set_dft_specification_requirements -memory_test on
add_clocks CLK -period 12ns -label clka
check_design_rules

#Create DFT Specification
set spec [create_dft_specification]
report_config_data $spec

#Process DFT Specification
process_dft_specification

#Extract ICL
extract_icl

#Create Patterns Specification
create_patterns_specification

#Process Patterns Specification
process_patterns_specification

#Run and Check Test Bench Simulations
run_testbench_simulations
check_testbench_simulations

#Test Logic Synthesis
run_synthesis
