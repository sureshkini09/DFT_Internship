#-----------------------------------------------------------
# This file created by : memlibCertify
#     Software version : 2022.4
#           Created on : 04/28/25 14:29:13
#-----------------------------------------------------------

# --
# -- Simulation 
# --
set_context patterns -ijtag
set design_name memlibc_memory_bist_assembly
set_simulation_library_sources -y /jk/SCLPDK_V3.0_KIT/scl180/memory/spram/6M1L/SPRAM_32x8 -extension {vb v vg} -f VerilogOptions 
# Add the following run_testbench_simulations option(s) to capture
# the simulation waveforms:
#  -store_simulation_waveforms on
# If using the Questa simulator, the debug database can be
# generated using the following option:
#  -simulator_options -debugDB


set sim_options ""
if { [file exists SimOptions] } {
  if { [file readable SimOptions] } {
    set f [open SimOptions r]
    set sim_options [read $f]
    close $f
  }
}
run_testbench_simulations -design_name ${design_name} -design_id rtl {*}$sim_options
check_testbench_simulations -report -design_name ${design_name} -design_id rtl 
exit
