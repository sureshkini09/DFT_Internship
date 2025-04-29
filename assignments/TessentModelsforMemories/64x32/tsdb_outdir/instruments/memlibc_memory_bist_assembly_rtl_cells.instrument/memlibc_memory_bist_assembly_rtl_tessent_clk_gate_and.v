//--------------------------------------------------------------------------
//
//  Unpublished work. Copyright 2022 Siemens
//
//  This material contains trade secrets or otherwise confidential 
//  information owned by Siemens Industry Software Inc. or its affiliates 
//  (collectively, SISW), or its licensors. Access to and use of this 
//  information is strictly limited as set forth in the Customer's 
//  applicable agreements with SISW.
//
//--------------------------------------------------------------------------
//  File created by: Tessent Shell
//          Version: 2022.4
//       Created on: Mon Apr 28 14:46:47 IST 2025
//--------------------------------------------------------------------------

     
module memlibc_memory_bist_assembly_rtl_tessent_clk_gate_and (
  input wire clk,
  input wire fe,
  input wire te,
  output wire clkg
);
 
wire fe_te;
reg latch;
 
assign fe_te = fe | te;
always @ (clk or fe_te) begin
  if (~clk) latch <= fe_te;
end
assign clkg = clk & latch;
    
endmodule
  
