create_clock -name clk -period 5 [get_ports "mc_rb_ef1_sclk_i"]
set_clock_transition -rise 0.01 [get_clocks "clk"]
set_clock_transition -fall 0.01 [get_clocks "clk"]
set_clock_uncertainty 0.05 [get_clocks "clk"]

set_input_delay -max 1.0 [get_ports "mc_rb_ef1_svld_i"] -clock [get_clocks "clk"]
set_input_delay -max 1.0 [get_ports "gctl_rclk_orst_n_i"] -clock [get_clocks "clk"]
set_input_delay -max 1.0 [get_ports "mc_rb_fuse_vld_i"] -clock [get_clocks "clk"]

set_output_delay -max 1.0 [get_ports "skew_addr_cntr_o"] -clock [get_clocks "clk"]

