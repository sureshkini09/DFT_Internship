module mcrb (mc_rb_ef1_svld_i, gctl_rclk_orst_n_i, skew_addr_cntr_o, mc_rb_fuse_vld_i, mc_rb_ef1_sclk_i);

  input  mc_rb_ef1_svld_i, gctl_rclk_orst_n_i, mc_rb_fuse_vld_i, mc_rb_ef1_sclk_i;

  output [4:0] skew_addr_cntr_o; 

  reg mc_rb_fuse_vld_q;
  reg   [4:0]    skew_addr_cntr;

  wire  fuse_capture;
  wire  skew_write_incr;

  assign  skew_write_incr  = (skew_addr_cntr >= 5'b00001) & (skew_addr_cntr <= 5'b10011);
  assign fuse_capture = ~mc_rb_ef1_svld_i & mc_rb_fuse_vld_q;

  always @(posedge mc_rb_ef1_sclk_i or negedge gctl_rclk_orst_n_i)
  begin
    if (~gctl_rclk_orst_n_i)
      skew_addr_cntr <=  5'b0;
    else if (fuse_capture)
      skew_addr_cntr <= skew_addr_cntr + 1'b1;
    else if (skew_write_incr)
      skew_addr_cntr <= skew_addr_cntr + 1'b1;
    else
      skew_addr_cntr <= 5'b0;
  end

  always @(posedge mc_rb_ef1_sclk_i or negedge gctl_rclk_orst_n_i)
  begin 
     if (~gctl_rclk_orst_n_i) 
        mc_rb_fuse_vld_q <= 1'b0;
     else
        mc_rb_fuse_vld_q <= mc_rb_fuse_vld_i;
  end

  assign skew_addr_cntr_o = skew_addr_cntr;

endmodule 
