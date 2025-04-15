# ####################################################################

#  Created by Genus(TM) Synthesis Solution 20.11-s111_1 on Sat Apr 12 17:38:11 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design mcrb

create_clock -name "clk" -period 5.0 -waveform {0.0 2.5} [get_ports mc_rb_ef1_sclk_i]
set_clock_transition 0.01 [get_clocks clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports mc_rb_ef1_svld_i]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports gctl_rclk_orst_n_i]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports mc_rb_fuse_vld_i]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {skew_addr_cntr_o[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {skew_addr_cntr_o[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {skew_addr_cntr_o[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {skew_addr_cntr_o[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {skew_addr_cntr_o[0]}]
set_wire_load_mode "enclosed"
set_clock_uncertainty -setup 0.05 [get_clocks clk]
set_clock_uncertainty -hold 0.05 [get_clocks clk]
