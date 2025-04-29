/*
----------------------------------------------------------------------------------
-                                                                                -
-  Unpublished work. Copyright 2022 Siemens                                      -
-                                                                                -
-  This material contains trade secrets or otherwise confidential                -
-  information owned by Siemens Industry Software Inc. or its affiliates         -
-  (collectively, SISW), or its licensors. Access to and use of this             -
-  information is strictly limited as set forth in the Customer's                -
-  applicable agreements with SISW.                                              -
-                                                                                -
----------------------------------------------------------------------------------
-  File created by: Tessent Shell                                                -
-          Version: 2022.4                                                       -
-       Created on: Mon Apr 28 14:46:49 IST 2025                                 -
----------------------------------------------------------------------------------


*/

/*------------------------------------------------------------------------------
     Module      :  memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_interface_m1
 
     Description :  This module contains the interface logic for the memory
                    module SPRAM_64x32
 
--------------------------------------------------------------------------------
     Interface Options in Effect
 
     BistDataPipelineStages        : 0;
     BitGrouping                   : 1;
     BitSliceWidth                 : 1;
     ConcurrentWrite               : OFF 
     ConcurrentRead                : OFF 
     ControllerType                : PROG;
     DataOutStage                  : NONE;
     DefaultAlgorithm              : SMARCH;
     DefaultOperationSet           : SYNC;
     InternalScanLogic             : OFF;
     LocalComparators              : ON;
     MemoryType                    : RAM;
     ObservationLogic              : ON;
     OutputEnableControl           : ALWAYSON;
     PipelineSerialDataOut         : OFF;
     ScanWriteThru                 : OFF;
     ShadowRead                    : OFF;
     ShadowWrite                   : OFF;
     Stop-On-Error Limit           : 4096;
     TransparentMode               : NONE;
 
---------------------------------------------------------------------------- */

module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_interface_m1 (
  input  wire        WEB_IN,
  input  wire        CSB_IN,
  input  wire [5:0]  A_IN,
  input  wire [31:0] I_IN,
  input  wire [31:0] O,
  input  wire        TCK,
  input  wire        BIST_CMP,
  input  wire        INCLUDE_MEM_RESULTS_REG,
  input  wire        BIST_WRITEENABLE,
  input  wire        BIST_OUTPUTENABLE,
  input  wire        BIST_SELECT,
  input  wire [2:0]  BIST_COL_ADD,
  input  wire [2:0]  BIST_ROW_ADD,
  input  wire [1:0]  BIST_WRITE_DATA,
  input  wire        BIST_TESTDATA_SELECT_TO_COLLAR,
  input  wire        MEM_BYPASS_EN,
  input  wire        SCAN_SHIFT_EN,
  input  wire        MCP_BOUNDING_EN,
  input  wire        BIST_ON,
  input  wire        BIST_RUN,
  input  wire        BIST_ASYNC_RESETN,
  input  wire        BIST_CLK,
  input  wire        BIST_SHIFT_COLLAR,
  input  wire [1:0]  BIST_EXPECT_DATA,
  input  wire        BIST_SI,
  input  wire        BIST_COLLAR_SETUP,
  input  wire        BIST_COLLAR_HOLD,
  input  wire        BIST_DIAG_EN,
  input  wire        BIST_CLEAR_DEFAULT,
  input  wire        BIST_CLEAR,
  input  wire        BIST_SETUP0,
  input  wire        LV_TM,
  input  wire        FREEZE_STOP_ERROR,
  input  wire        BIST_COLLAR_EN,
  input  wire        RESET_REG_SETUP2,
  input  wire        ERROR_CNT_ZERO,
  output wire        WEB,
  output wire        CSB,
  output reg  [5:0]  A,
  output reg  [31:0] I,
  output reg  [2:0]  SCAN_OBS_FLOPS,
  output wire        BIST_SO,
  output wire        BIST_GO
);


wire        CMP_EN;
wire [31:0] BIST_WRITE_DATA_REP;
wire [31:0] BIST_WRITE_DATA_INT;
reg         BIST_INPUT_SELECT;
wire        BIST_EN_RST;
wire        BIST_CLK_INT;
wire        BIST_CLK_OR_TCK;
wire [31:0] BIST_EXPECT_DATA_REP;
wire [31:0] BIST_EXPECT_DATA_INT;
wire        BIST_CLK_EN;
wire        GO_EN;
wire        COLLAR_STATUS_SO;
wire        STATUS_SO;
wire        COLLAR_STATUS_SI;
wire        BIST_INPUT_SELECT_INT;
wire [0:0]  ERROR;
wire [0:0]  ERROR_R;
wire [31:0] RAW_CMP_STAT;
wire [31:0] DATA_TO_MEM;
wire [31:0] DATA_FROM_MEM;
wire [31:0] DATA_FROM_MEM_EXP;
wire        WEB_TEST_IN;
reg         WEB_NOT_GATED;
wire        WEB_TO_MUX;
wire        CSB_TEST_IN;
reg         CSB_NOT_GATED;
wire        CSB_TO_MUX;
wire [5:0]  A_TEST_IN;
wire [31:0] I_TEST_IN;
wire        USE_DEFAULTS;
wire        BIST_COLLAR_HOLD_INT;
wire        FREEZE_STOP_ERROR_RST;
wire        FREEZE_STOP_ERROR_SI;
wire        HOLD_EN;
wire        BIST_SETUP0_SYNC;
wire        LOGIC_HIGH;

//---------------------------
// Memory Interface Main Code
//---------------------------
   assign LOGIC_HIGH = 1'b1;
//----------------------
//-- BIST_ON Sync-ing --
//----------------------
    memlibc_memory_bist_assembly_rtl_tessent_and2 tessent_persistent_cell_AND_BIST_SETUP0_SYNC (
        .a          ( BIST_SETUP0                                ),
        .b          ( BIST_ON                                    ),
        .y          ( BIST_SETUP0_SYNC                           )
    );

//----------------------
//-- BIST_EN Retiming --
//----------------------
    assign BIST_EN_RST              = ~BIST_ASYNC_RESETN;
    always @ (posedge BIST_CLK_INT or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
          BIST_INPUT_SELECT <= 1'b0;
       else
       if (~MCP_BOUNDING_EN) begin
          BIST_INPUT_SELECT <= BIST_RUN | BIST_TESTDATA_SELECT_TO_COLLAR;
       end
   end

    wire BIST_INPUT_SELECT_INT_BUF;
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_BIST_INPUT_SELECT_INT (
        .a                          (BIST_INPUT_SELECT & ((~LV_TM)|MEM_BYPASS_EN)),
        .y                          (BIST_INPUT_SELECT_INT_BUF)
    );
    assign BIST_INPUT_SELECT_INT = BIST_INPUT_SELECT_INT_BUF;
    assign USE_DEFAULTS = ~BIST_SETUP0_SYNC;
    assign BIST_COLLAR_HOLD_INT = HOLD_EN;
//-----------------------
//-- Observation Logic --
//-----------------------
  // synopsys async_set_reset "BIST_ASYNC_RESETN"
  always @ (posedge BIST_CLK_INT or negedge BIST_ASYNC_RESETN) begin
    if (~BIST_ASYNC_RESETN)
      SCAN_OBS_FLOPS    <= 3'b000;
    else
      SCAN_OBS_FLOPS    <= {3{MEM_BYPASS_EN} } & {
                          WEB_NOT_GATED        ^ CSB_NOT_GATED        ^ A[5]                 ,
                          A[4]                 ^ A[3]                 ^ A[2]                 ,
                          A[1]                 ^ A[0]                 
                           };
  end
 
//--------------------------
//-- Replicate Write Data --
//--------------------------
   assign BIST_WRITE_DATA_REP      = {
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA,
                                       BIST_WRITE_DATA
                                     };
 
//-----------------------
//-- Checkerboard Data --
//-----------------------
   assign BIST_WRITE_DATA_INT       = BIST_WRITE_DATA_REP;
   assign DATA_TO_MEM              = BIST_WRITE_DATA_INT;
 
 
 
 

//--------------------------
//-- Memory Control Ports --
//--------------------------

   // Port: WEB LogicalPort: ## Type: READWRITE {{{

   // Intercept functional signal with test mux
   always @( WEB_IN or WEB_TEST_IN or BIST_INPUT_SELECT_INT) begin
      case (BIST_INPUT_SELECT_INT) // synopsys infer_mux
      1'b0 : WEB_NOT_GATED = WEB_IN;
      1'b1 : WEB_NOT_GATED = WEB_TEST_IN;
      endcase
   end

   // Disable memory port during logic test
   assign WEB                       = WEB_NOT_GATED | (LV_TM & (MEM_BYPASS_EN | SCAN_SHIFT_EN));

   // Control logic during memory test
   assign WEB_TEST_IN               = ~(BIST_COLLAR_EN & WEB_TO_MUX);
   assign WEB_TO_MUX                = BIST_WRITEENABLE;

   // Port: WEB }}}

   // Port: CSB LogicalPort: ## Type: READWRITE {{{

   // Intercept functional signal with test mux
   always @( CSB_IN or CSB_TEST_IN or BIST_INPUT_SELECT_INT) begin
      case (BIST_INPUT_SELECT_INT) // synopsys infer_mux
      1'b0 : CSB_NOT_GATED = CSB_IN;
      1'b1 : CSB_NOT_GATED = CSB_TEST_IN;
      endcase
   end

   // Disable memory port during logic test
   assign CSB                       = CSB_NOT_GATED | (LV_TM & (MEM_BYPASS_EN | SCAN_SHIFT_EN));

   // Control logic during memory test
   assign CSB_TEST_IN               = ~(BIST_COLLAR_EN & CSB_TO_MUX);
   assign CSB_TO_MUX                = BIST_SELECT;

   // Port: CSB }}}

//--------------------------
//-- Memory Address Ports --
//--------------------------

   // Port: A LogicalPort: ## Type: READWRITE {{{

   // Intercept functional signal with test mux
   always @( A_IN or A_TEST_IN or BIST_INPUT_SELECT_INT) begin
      case (BIST_INPUT_SELECT_INT) // synopsys infer_mux
      1'b0 : A = A_IN;
      1'b1 : A = A_TEST_IN;
      endcase
   end
   // Address logic during memory test
   wire   [2:0]                     BIST_COL_ADD_SHADOW;
   wire   [2:0]                     BIST_ROW_ADD_SHADOW;
   assign BIST_ROW_ADD_SHADOW[2] = BIST_ROW_ADD[2];
   assign BIST_ROW_ADD_SHADOW[1] = BIST_ROW_ADD[1];
   assign BIST_ROW_ADD_SHADOW[0] = BIST_ROW_ADD[0];
   assign BIST_COL_ADD_SHADOW[2] = BIST_COL_ADD[2];
   assign BIST_COL_ADD_SHADOW[1] = BIST_COL_ADD[1];
   assign BIST_COL_ADD_SHADOW[0] = BIST_COL_ADD[0];
   assign A_TEST_IN                 = {
                                         BIST_ROW_ADD_SHADOW[2],
                                         BIST_ROW_ADD_SHADOW[1],
                                         BIST_ROW_ADD_SHADOW[0],
                                         BIST_COL_ADD_SHADOW[2],
                                         BIST_COL_ADD_SHADOW[1],
                                         BIST_COL_ADD_SHADOW[0] 
                                      };

   // Port: A }}}

//--------------------
//-- Data To Memory --
//--------------------


   // Intercept functional signal with test mux
   always @( I_IN or I_TEST_IN or BIST_INPUT_SELECT_INT ) begin
      case (BIST_INPUT_SELECT_INT) // synopsys infer_mux
      1'b0 : I = I_IN;
      1'b1 : I = I_TEST_IN;
      endcase
   end
   // Write data during memory test
   assign I_TEST_IN                 = {
                                        DATA_TO_MEM[31],
                                        DATA_TO_MEM[30],
                                        DATA_TO_MEM[29],
                                        DATA_TO_MEM[28],
                                        DATA_TO_MEM[27],
                                        DATA_TO_MEM[26],
                                        DATA_TO_MEM[25],
                                        DATA_TO_MEM[24],
                                        DATA_TO_MEM[23],
                                        DATA_TO_MEM[22],
                                        DATA_TO_MEM[21],
                                        DATA_TO_MEM[20],
                                        DATA_TO_MEM[19],
                                        DATA_TO_MEM[18],
                                        DATA_TO_MEM[17],
                                        DATA_TO_MEM[16],
                                        DATA_TO_MEM[15],
                                        DATA_TO_MEM[14],
                                        DATA_TO_MEM[13],
                                        DATA_TO_MEM[12],
                                        DATA_TO_MEM[11],
                                        DATA_TO_MEM[10],
                                        DATA_TO_MEM[9],
                                        DATA_TO_MEM[8],
                                        DATA_TO_MEM[7],
                                        DATA_TO_MEM[6],
                                        DATA_TO_MEM[5],
                                        DATA_TO_MEM[4],
                                        DATA_TO_MEM[3],
                                        DATA_TO_MEM[2],
                                        DATA_TO_MEM[1],
                                        DATA_TO_MEM[0] 
                                      };

//----------------------
//-- Data From Memory --
//----------------------
 
   assign DATA_FROM_MEM             = {
                                       O[31],
                                       O[30],
                                       O[29],
                                       O[28],
                                       O[27],
                                       O[26],
                                       O[25],
                                       O[24],
                                       O[23],
                                       O[22],
                                       O[21],
                                       O[20],
                                       O[19],
                                       O[18],
                                       O[17],
                                       O[16],
                                       O[15],
                                       O[14],
                                       O[13],
                                       O[12],
                                       O[11],
                                       O[10],
                                       O[9],
                                       O[8],
                                       O[7],
                                       O[6],
                                       O[5],
                                       O[4],
                                       O[3],
                                       O[2],
                                       O[1],
                                       O[0] 
                                      };
 
//---------------------------
//-- Replicate Expect Data --
//---------------------------
 
   assign BIST_EXPECT_DATA_REP      = { // 
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA,
                                      BIST_EXPECT_DATA
                                     };
//-----------------
//-- Expect Data --
//-----------------
   assign BIST_EXPECT_DATA_INT      = BIST_EXPECT_DATA_REP;
   assign DATA_FROM_MEM_EXP         = BIST_EXPECT_DATA_INT;
assign CMP_EN = BIST_CMP;

//-----------------------
//-- Local Comparators --
//-----------------------
 
   assign RAW_CMP_STAT[31]          = ~(DATA_FROM_MEM[31] == DATA_FROM_MEM_EXP[31]);
   assign RAW_CMP_STAT[30]          = ~(DATA_FROM_MEM[30] == DATA_FROM_MEM_EXP[30]);
   assign RAW_CMP_STAT[29]          = ~(DATA_FROM_MEM[29] == DATA_FROM_MEM_EXP[29]);
   assign RAW_CMP_STAT[28]          = ~(DATA_FROM_MEM[28] == DATA_FROM_MEM_EXP[28]);
   assign RAW_CMP_STAT[27]          = ~(DATA_FROM_MEM[27] == DATA_FROM_MEM_EXP[27]);
   assign RAW_CMP_STAT[26]          = ~(DATA_FROM_MEM[26] == DATA_FROM_MEM_EXP[26]);
   assign RAW_CMP_STAT[25]          = ~(DATA_FROM_MEM[25] == DATA_FROM_MEM_EXP[25]);
   assign RAW_CMP_STAT[24]          = ~(DATA_FROM_MEM[24] == DATA_FROM_MEM_EXP[24]);
   assign RAW_CMP_STAT[23]          = ~(DATA_FROM_MEM[23] == DATA_FROM_MEM_EXP[23]);
   assign RAW_CMP_STAT[22]          = ~(DATA_FROM_MEM[22] == DATA_FROM_MEM_EXP[22]);
   assign RAW_CMP_STAT[21]          = ~(DATA_FROM_MEM[21] == DATA_FROM_MEM_EXP[21]);
   assign RAW_CMP_STAT[20]          = ~(DATA_FROM_MEM[20] == DATA_FROM_MEM_EXP[20]);
   assign RAW_CMP_STAT[19]          = ~(DATA_FROM_MEM[19] == DATA_FROM_MEM_EXP[19]);
   assign RAW_CMP_STAT[18]          = ~(DATA_FROM_MEM[18] == DATA_FROM_MEM_EXP[18]);
   assign RAW_CMP_STAT[17]          = ~(DATA_FROM_MEM[17] == DATA_FROM_MEM_EXP[17]);
   assign RAW_CMP_STAT[16]          = ~(DATA_FROM_MEM[16] == DATA_FROM_MEM_EXP[16]);
   assign RAW_CMP_STAT[15]          = ~(DATA_FROM_MEM[15] == DATA_FROM_MEM_EXP[15]);
   assign RAW_CMP_STAT[14]          = ~(DATA_FROM_MEM[14] == DATA_FROM_MEM_EXP[14]);
   assign RAW_CMP_STAT[13]          = ~(DATA_FROM_MEM[13] == DATA_FROM_MEM_EXP[13]);
   assign RAW_CMP_STAT[12]          = ~(DATA_FROM_MEM[12] == DATA_FROM_MEM_EXP[12]);
   assign RAW_CMP_STAT[11]          = ~(DATA_FROM_MEM[11] == DATA_FROM_MEM_EXP[11]);
   assign RAW_CMP_STAT[10]          = ~(DATA_FROM_MEM[10] == DATA_FROM_MEM_EXP[10]);
   assign RAW_CMP_STAT[9]           = ~(DATA_FROM_MEM[9] == DATA_FROM_MEM_EXP[9]);
   assign RAW_CMP_STAT[8]           = ~(DATA_FROM_MEM[8] == DATA_FROM_MEM_EXP[8]);
   assign RAW_CMP_STAT[7]           = ~(DATA_FROM_MEM[7] == DATA_FROM_MEM_EXP[7]);
   assign RAW_CMP_STAT[6]           = ~(DATA_FROM_MEM[6] == DATA_FROM_MEM_EXP[6]);
   assign RAW_CMP_STAT[5]           = ~(DATA_FROM_MEM[5] == DATA_FROM_MEM_EXP[5]);
   assign RAW_CMP_STAT[4]           = ~(DATA_FROM_MEM[4] == DATA_FROM_MEM_EXP[4]);
   assign RAW_CMP_STAT[3]           = ~(DATA_FROM_MEM[3] == DATA_FROM_MEM_EXP[3]);
   assign RAW_CMP_STAT[2]           = ~(DATA_FROM_MEM[2] == DATA_FROM_MEM_EXP[2]);
   assign RAW_CMP_STAT[1]           = ~(DATA_FROM_MEM[1] == DATA_FROM_MEM_EXP[1]);
   assign RAW_CMP_STAT[0]           = ~(DATA_FROM_MEM[0] == DATA_FROM_MEM_EXP[0]);
  
wire                                FREEZE_GO_ID;
reg                                 FREEZE_STOP_ERROR_EARLY_R; 
assign FREEZE_GO_ID = BIST_SHIFT_COLLAR | (~(BIST_CMP & BIST_COLLAR_EN)) | FREEZE_STOP_ERROR_EARLY_R;
   
//----------------
// STOP_ON_ERROR  
//----------------
wire                                SOE_ERROR;
wire                                FREEZE_STOP_ERROR_CLEAR;
wire                                FREEZE_STOP_ERROR_EARLY;
assign SOE_ERROR = (|ERROR) & BIST_ON;
assign FREEZE_STOP_ERROR_EARLY = ERROR_CNT_ZERO & SOE_ERROR;
  
// synopsys sync_set_reset "FREEZE_STOP_ERROR_CLEAR"
assign FREEZE_STOP_ERROR_CLEAR = (~GO_EN) & (~(BIST_COLLAR_HOLD|FREEZE_STOP_ERROR)) & (~BIST_SHIFT_COLLAR);
 
// synopsys async_set_reset "BIST_ASYNC_RESETN"
always @(posedge BIST_CLK_OR_TCK or negedge BIST_ASYNC_RESETN) begin
  if (~BIST_ASYNC_RESETN) begin
    FREEZE_STOP_ERROR_EARLY_R <= 1'b0;
  end else 
  if (FREEZE_STOP_ERROR_CLEAR) begin
    FREEZE_STOP_ERROR_EARLY_R <= 1'b0;
  end else begin
    if (BIST_SHIFT_COLLAR) begin
      FREEZE_STOP_ERROR_EARLY_R <= FREEZE_STOP_ERROR_SI;
    end else 
    if ((~(BIST_COLLAR_HOLD|FREEZE_STOP_ERROR)) & GO_EN) begin
        FREEZE_STOP_ERROR_EARLY_R <= FREEZE_STOP_ERROR_EARLY | FREEZE_STOP_ERROR_EARLY_R;
    end
  end
end

assign HOLD_EN = BIST_COLLAR_HOLD | FREEZE_STOP_ERROR_EARLY_R | FREEZE_STOP_ERROR;
 
assign COLLAR_STATUS_SI = BIST_SI;
memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_interface_m1_STATUS MBISTPG_STATUS (
    .BIST_CLK                      ( BIST_CLK_OR_TCK              ),
    .BIST_ASYNC_RESETN             (BIST_ASYNC_RESETN           ),
    .MCP_BOUNDING_EN               (MCP_BOUNDING_EN      ), 
    .FREEZE_GO_ID                  (FREEZE_GO_ID                ),
    .CMP_EN                        (CMP_EN                      ),
    .FREEZE_STOP_ERROR_EARLY_R     (FREEZE_STOP_ERROR_EARLY_R   ),
   .GO_EN                          (GO_EN                      ),
   .BIST_COLLAR_SETUP              (BIST_COLLAR_SETUP          ),
   .BIST_COLLAR_HOLD               (BIST_COLLAR_HOLD_INT       ),
   .BIST_SHIFT_COLLAR              (BIST_SHIFT_COLLAR          ),
   .BIST_ON                        (BIST_ON                    ),
   .BIST_CLEAR                     (BIST_CLEAR                 ),
   .USE_DEFAULTS                   (USE_DEFAULTS               ),
   .SI                             (COLLAR_STATUS_SI           ),
   .ERROR                          ( ERROR               ),
   .ERROR_R                        ( ERROR_R             ),
   .BIST_DIAG_EN                   (BIST_DIAG_EN         ),
   .RAW_CMP_STAT                   (RAW_CMP_STAT               ),
   .BIST_GO                        (BIST_GO              ),
   .INCLUDE_MEM_RESULTS_REG        (INCLUDE_MEM_RESULTS_REG    ),
   .SO                             (COLLAR_STATUS_SO           )
);
assign FREEZE_STOP_ERROR_SI = COLLAR_STATUS_SO;
 
assign STATUS_SO = FREEZE_STOP_ERROR_EARLY_R;
    
assign BIST_SO                      = STATUS_SO;
 
 
    assign BIST_CLK_EN  = BIST_RUN | BIST_COLLAR_SETUP|BIST_CLEAR|BIST_CLEAR_DEFAULT|RESET_REG_SETUP2|(BIST_INPUT_SELECT ^ BIST_TESTDATA_SELECT_TO_COLLAR);
//---------------------
//-- BIST_CLK Gating --
//---------------------
wire   INJECT_TCK;      
    assign INJECT_TCK = BIST_SHIFT_COLLAR & ~LV_TM; 
    memlibc_memory_bist_assembly_rtl_tessent_clk_gate_and tessent_persistent_cell_GATING_BIST_CLK (
        .clk        ( BIST_CLK                    ),
        .te         ( 1'b0         ),
        .fe         ( BIST_CLK_EN  ),
        .clkg       ( BIST_CLK_INT                )
    );
        memlibc_memory_bist_assembly_rtl_tessent_clk_mux2 tessent_persistent_cell_BIST_CLK_OR_TCK (
        .s          ( INJECT_TCK                                 ),
        .a          ( BIST_CLK_INT                               ),
        .b          ( TCK                                        ),
        .y          ( BIST_CLK_OR_TCK                            )
    );

endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_interface_m1



    
module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_interface_m1_STATUS (
  input  wire        BIST_CLEAR,
  input  wire        FREEZE_STOP_ERROR_EARLY_R,
  input  wire        FREEZE_GO_ID,
  input  wire        CMP_EN,
  input  wire        BIST_ASYNC_RESETN,
  input  wire        BIST_CLK,
  input  wire        BIST_COLLAR_SETUP,
  input  wire        BIST_COLLAR_HOLD,
  input  wire        BIST_SHIFT_COLLAR,
  input  wire        BIST_ON,
  input  wire        USE_DEFAULTS,
  input  wire        SI,
  input  wire        BIST_DIAG_EN,
  input  wire [31:0] RAW_CMP_STAT,
  input  wire        MCP_BOUNDING_EN,
  input  wire        INCLUDE_MEM_RESULTS_REG,
  output reg         GO_EN,
  output wire [0:0]  ERROR,
  output wire [0:0]  ERROR_R,
  output wire        SO,
  output wire        BIST_GO
);
wire        GO_ID_REG_RST;
reg  [31:0] GO_ID_REG;
wire        BIST_GO_INT;
wire [31:0] ROW_DATA_MAP;
wire        GO_ID_FEEDBACK_EN;
wire [0:0]  IO_SEG_GLOBAL_GO_ID;
reg  [0:0]  ERROR_R1;

 
   //----------------
   // Row Data Map --
   //----------------
 assign ROW_DATA_MAP = RAW_CMP_STAT;
 
   //-----------
   //-- GO_EN --
   //-----------
   //synopsys sync_set_reset "BIST_ON"
   // synopsys async_set_reset "BIST_ASYNC_RESETN"
   always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
      if (~BIST_ASYNC_RESETN)
         GO_EN       <= 1'b0;
      else
      if (~BIST_ON) begin
         GO_EN       <= 1'b0;
      end else begin
         if (BIST_COLLAR_SETUP) begin
            GO_EN    <= 1'b1; 
         end
      end
   end
   assign GO_ID_FEEDBACK_EN         = ~(BIST_DIAG_EN) ;
   assign BIST_GO_INT               = ~|ERROR_R;
   assign BIST_GO    = BIST_GO_INT;
 
 
 
   //---------------
   //-- GO_ID_REG --
   //---------------
reg  CMP_EN_R;
  // synopsys async_set_reset "BIST_ASYNC_RESETN"
   always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
      if (~BIST_ASYNC_RESETN) begin
         CMP_EN_R    <= 1'b0;
      end else begin
         CMP_EN_R    <= (~FREEZE_GO_ID) & (~BIST_COLLAR_HOLD);
      end
   end

   assign GO_ID_REG_RST            = BIST_CLEAR | (~INCLUDE_MEM_RESULTS_REG & BIST_SHIFT_COLLAR);
   wire HOLD_OR_RESET;
    
wire [31:0] GO_ID_REG_MUX, BIST_SHIFT_COLLAR_MUX;
wire [31:0] GO_ID_REG_MUX_SEL ;
wire GO_ID_REG_CLR;
wire GO_ID_REG_BYPASS;
  // synopsys sync_set_reset "GO_ID_REG_RST"
   assign HOLD_OR_RESET = MCP_BOUNDING_EN | GO_ID_REG_RST | BIST_COLLAR_HOLD | ~GO_EN;
   assign GO_ID_REG_CLR = (~MCP_BOUNDING_EN) & (GO_ID_REG_RST | ((~BIST_COLLAR_HOLD) & (~GO_ID_FEEDBACK_EN) & CMP_EN) | (CMP_EN_R & BIST_COLLAR_HOLD & (~FREEZE_STOP_ERROR_EARLY_R)));
// Instantiate persistent GO_ID_REG_MUX cells {{{
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG0 (
            .s       ( GO_ID_REG_MUX_SEL[0]        ),
            .b       ( BIST_SHIFT_COLLAR_MUX[0] & ~GO_ID_REG_CLR  ),
            .a       ( ROW_DATA_MAP[0]             ),
            .y       ( GO_ID_REG_MUX[0]            )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG1 (
            .s       ( GO_ID_REG_MUX_SEL[1]        ),
            .b       ( BIST_SHIFT_COLLAR_MUX[1] & ~GO_ID_REG_CLR  ),
            .a       ( ROW_DATA_MAP[1]             ),
            .y       ( GO_ID_REG_MUX[1]            )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG2 (
            .s       ( GO_ID_REG_MUX_SEL[2]        ),
            .b       ( BIST_SHIFT_COLLAR_MUX[2] & ~GO_ID_REG_CLR  ),
            .a       ( ROW_DATA_MAP[2]             ),
            .y       ( GO_ID_REG_MUX[2]            )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG3 (
            .s       ( GO_ID_REG_MUX_SEL[3]        ),
            .b       ( BIST_SHIFT_COLLAR_MUX[3] & ~GO_ID_REG_CLR  ),
            .a       ( ROW_DATA_MAP[3]             ),
            .y       ( GO_ID_REG_MUX[3]            )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG4 (
            .s       ( GO_ID_REG_MUX_SEL[4]        ),
            .b       ( BIST_SHIFT_COLLAR_MUX[4] & ~GO_ID_REG_CLR  ),
            .a       ( ROW_DATA_MAP[4]             ),
            .y       ( GO_ID_REG_MUX[4]            )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG5 (
            .s       ( GO_ID_REG_MUX_SEL[5]        ),
            .b       ( BIST_SHIFT_COLLAR_MUX[5] & ~GO_ID_REG_CLR  ),
            .a       ( ROW_DATA_MAP[5]             ),
            .y       ( GO_ID_REG_MUX[5]            )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG6 (
            .s       ( GO_ID_REG_MUX_SEL[6]        ),
            .b       ( BIST_SHIFT_COLLAR_MUX[6] & ~GO_ID_REG_CLR  ),
            .a       ( ROW_DATA_MAP[6]             ),
            .y       ( GO_ID_REG_MUX[6]            )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG7 (
            .s       ( GO_ID_REG_MUX_SEL[7]        ),
            .b       ( BIST_SHIFT_COLLAR_MUX[7] & ~GO_ID_REG_CLR  ),
            .a       ( ROW_DATA_MAP[7]             ),
            .y       ( GO_ID_REG_MUX[7]            )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG8 (
            .s       ( GO_ID_REG_MUX_SEL[8]        ),
            .b       ( BIST_SHIFT_COLLAR_MUX[8] & ~GO_ID_REG_CLR  ),
            .a       ( ROW_DATA_MAP[8]             ),
            .y       ( GO_ID_REG_MUX[8]            )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG9 (
            .s       ( GO_ID_REG_MUX_SEL[9]        ),
            .b       ( BIST_SHIFT_COLLAR_MUX[9] & ~GO_ID_REG_CLR  ),
            .a       ( ROW_DATA_MAP[9]             ),
            .y       ( GO_ID_REG_MUX[9]            )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG10 (
            .s       ( GO_ID_REG_MUX_SEL[10]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[10] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[10]            ),
            .y       ( GO_ID_REG_MUX[10]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG11 (
            .s       ( GO_ID_REG_MUX_SEL[11]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[11] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[11]            ),
            .y       ( GO_ID_REG_MUX[11]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG12 (
            .s       ( GO_ID_REG_MUX_SEL[12]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[12] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[12]            ),
            .y       ( GO_ID_REG_MUX[12]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG13 (
            .s       ( GO_ID_REG_MUX_SEL[13]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[13] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[13]            ),
            .y       ( GO_ID_REG_MUX[13]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG14 (
            .s       ( GO_ID_REG_MUX_SEL[14]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[14] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[14]            ),
            .y       ( GO_ID_REG_MUX[14]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG15 (
            .s       ( GO_ID_REG_MUX_SEL[15]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[15] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[15]            ),
            .y       ( GO_ID_REG_MUX[15]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG16 (
            .s       ( GO_ID_REG_MUX_SEL[16]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[16] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[16]            ),
            .y       ( GO_ID_REG_MUX[16]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG17 (
            .s       ( GO_ID_REG_MUX_SEL[17]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[17] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[17]            ),
            .y       ( GO_ID_REG_MUX[17]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG18 (
            .s       ( GO_ID_REG_MUX_SEL[18]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[18] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[18]            ),
            .y       ( GO_ID_REG_MUX[18]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG19 (
            .s       ( GO_ID_REG_MUX_SEL[19]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[19] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[19]            ),
            .y       ( GO_ID_REG_MUX[19]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG20 (
            .s       ( GO_ID_REG_MUX_SEL[20]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[20] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[20]            ),
            .y       ( GO_ID_REG_MUX[20]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG21 (
            .s       ( GO_ID_REG_MUX_SEL[21]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[21] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[21]            ),
            .y       ( GO_ID_REG_MUX[21]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG22 (
            .s       ( GO_ID_REG_MUX_SEL[22]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[22] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[22]            ),
            .y       ( GO_ID_REG_MUX[22]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG23 (
            .s       ( GO_ID_REG_MUX_SEL[23]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[23] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[23]            ),
            .y       ( GO_ID_REG_MUX[23]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG24 (
            .s       ( GO_ID_REG_MUX_SEL[24]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[24] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[24]            ),
            .y       ( GO_ID_REG_MUX[24]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG25 (
            .s       ( GO_ID_REG_MUX_SEL[25]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[25] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[25]            ),
            .y       ( GO_ID_REG_MUX[25]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG26 (
            .s       ( GO_ID_REG_MUX_SEL[26]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[26] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[26]            ),
            .y       ( GO_ID_REG_MUX[26]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG27 (
            .s       ( GO_ID_REG_MUX_SEL[27]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[27] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[27]            ),
            .y       ( GO_ID_REG_MUX[27]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG28 (
            .s       ( GO_ID_REG_MUX_SEL[28]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[28] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[28]            ),
            .y       ( GO_ID_REG_MUX[28]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG29 (
            .s       ( GO_ID_REG_MUX_SEL[29]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[29] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[29]            ),
            .y       ( GO_ID_REG_MUX[29]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG30 (
            .s       ( GO_ID_REG_MUX_SEL[30]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[30] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[30]            ),
            .y       ( GO_ID_REG_MUX[30]           )
            );
    memlibc_memory_bist_assembly_rtl_tessent_mux2 tessent_persistent_cell_MUX_GO_ID_REG31 (
            .s       ( GO_ID_REG_MUX_SEL[31]       ),
            .b       ( BIST_SHIFT_COLLAR_MUX[31] & ~GO_ID_REG_CLR                ),
            .a       ( ROW_DATA_MAP[31]            ),
            .y       ( GO_ID_REG_MUX[31]           )
            );
// Instantiate persistent GO_ID_REG_MUX cells }}}
   assign GO_ID_REG_MUX_SEL = (GO_ID_REG & {32{GO_ID_FEEDBACK_EN}})  | {32 {HOLD_OR_RESET | FREEZE_GO_ID }};
   assign BIST_SHIFT_COLLAR_MUX = ((~MCP_BOUNDING_EN) & BIST_SHIFT_COLLAR) ? {SI,GO_ID_REG[31:1]} : GO_ID_REG;
 
   // synopsys async_set_reset "BIST_ASYNC_RESETN"
   always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
      if (~BIST_ASYNC_RESETN)
         GO_ID_REG   <= {32{1'b0}};
      else
         GO_ID_REG   <= GO_ID_REG_MUX;
   end
   assign GO_ID_REG_BYPASS = (INCLUDE_MEM_RESULTS_REG) ? GO_ID_REG[0] : SI;

    
  assign IO_SEG_GLOBAL_GO_ID[0] = |GO_ID_REG;
  assign ERROR[0] = GO_EN & IO_SEG_GLOBAL_GO_ID[0] & (CMP_EN_R | GO_ID_FEEDBACK_EN | BIST_COLLAR_HOLD);
  // synopsys async_set_reset "BIST_ASYNC_RESETN"
   always @ (posedge BIST_CLK  or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN) begin
         ERROR_R1    <= {1{1'b0}};
      end else 
      if ( BIST_CLEAR ) begin
         ERROR_R1    <= {1{1'b0}};
      end else begin
         ERROR_R1    <= ERROR;
      end
   end
  assign ERROR_R   = ERROR_R1;

                       
   //------
   // SO --
   //------
   assign SO         = GO_ID_REG_BYPASS;
endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_interface_m1_STATUS



