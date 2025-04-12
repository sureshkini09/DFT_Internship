# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Fri Mar 07 16:24:17 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design s298

create_clock -name "clk" -period 2.0 -waveform {0.0 1.0} [get_ports CK]
set_clock_transition 0.01 [get_clocks clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports G0]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports G1]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports G2]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports G117]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports G118]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports G132]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports G133]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports G66]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports G67]
set_clock_uncertainty -setup 0.05 [get_clocks clk]
set_clock_uncertainty -hold 0.05 [get_clocks clk]
