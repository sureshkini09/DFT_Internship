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

Module SPRAM_64x32 {
  DataInPort                             A[5:0] { 
    Attribute connection_rule_option = "allowed_no_source"; 
    Attribute tessent_memory_bist_function = "address";
  }
  ClockPort                              CE;
  Attribute tessent_use_in_dft_specification = "false"; 
  Attribute keep_active_during_scan_test     = "false"; 
  Attribute tessent_memory_module            = "without_internal_scan_logic";
}
