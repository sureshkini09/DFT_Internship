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
     Module      :  memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller
 
     Description :  Microprogrammable BIST Controller
--------------------------------------------------------------------------------
     Language               : Verilog
     Controller Type        : HardProgrammable
---------------------------------------------------------------------------- */


module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller (
  input  wire [1:0] MBISTPG_ALGO_MODE,
  input  wire       MBISTPG_MEM_RST,
  input  wire       MBISTPG_REDUCED_ADDR_CNT_EN,
  input  wire       MEM_BYPASS_EN,
  input  wire       MCP_BOUNDING_EN,
  input  wire       MEM0_BIST_COLLAR_SO,
  input  wire [1:0] FL_CNT_MODE,
  input  wire       BIST_COLLAR_GO, // Status bit from collars with local comparators
  input  wire       MBISTPG_DIAG_EN, // Diagnostic mode enable
  input  wire       BIST_CLK,
  input  wire       BIST_SI, // toIscan wire from TAP
  input  wire       BIST_HOLD, // holdBist wire from TAP
  input  wire       BIST_SETUP2, // setupMode wires from TAP
  input  wire [1:0] BIST_SETUP, // setupMode wires from TAP
  input  wire       MBISTPG_TESTDATA_SELECT,
  input  wire       TCK, // tck wire from TAP
  input  wire       MBISTPG_EN, // bistEn wire from TAP
  input  wire       MBISTPG_ASYNC_RESETN, // Asynchronous reset enable (active low)
  input  wire       LV_TM, // testMode wire from Tap
  output wire       MBISTPG_RESET_REG_SETUP2,
  output wire [2:0] BIST_COL_ADD, // column address
  output wire [2:0] BIST_ROW_ADD, // row address
  output wire [1:0] BIST_WRITE_DATA, // write data
  output wire [1:0] BIST_EXPECT_DATA, // expect data
  output wire       BIST_SHIFT_COLLAR, // internal scan chain shift enable to Memory collar
  output wire       BIST_TESTDATA_SELECT_TO_COLLAR,
  output wire       MEM0_BIST_COLLAR_SI,
  output wire       BIST_COLLAR_SETUP,
  output wire       BIST_COLLAR_HOLD,
  output wire       FREEZE_STOP_ERROR,
  output wire       ERROR_CNT_ZERO,
  output wire       BIST_COLLAR_DIAG_EN,
  output wire       BIST_CLEAR_DEFAULT,
  output wire       BIST_CLEAR,
  output wire       MBISTPG_SO, // fromBist wire to TAP
  output wire       BIST_WRITEENABLE,
  output wire       BIST_OUTPUTENABLE,
  output wire       BIST_SELECT,
  output wire       BIST_CMP,
  output wire       BIST_COLLAR_EN0, // Enable for interface m1
  output wire       BIST_RUN_TO_COLLAR0,
  output wire       MBISTPG_GO, // Status bit indicating BIST is Pass when high and DONE is High
  output wire       MBISTPG_DONE, // Status bit indicating BIST is done when high
  output wire       BIST_ON_TO_COLLAR
);
wire       BYPASS_RUN_STATE_INT;
reg        ALGO_SEL_CNT_REG;
wire       ALGO_SEL_CNT_RST;
wire       ALGO_SEL_CNT_SI;
wire       ALGO_SEL_CNT_SO;
reg        SELECT_COMMON_OPSET_REG;
wire       SELECT_COMMON_OPSET_RST;
wire       SELECT_COMMON_OPSET_SI;
wire       SELECT_COMMON_OPSET_SO;
reg        SELECT_COMMON_DATA_PAT_REG;
wire       SELECT_COMMON_DATA_PAT_RST;
wire       SELECT_COMMON_DATA_PAT_SI;
wire       SELECT_COMMON_DATA_PAT_SO;
reg        MICROCODE_EN_REG;
wire       MICROCODE_EN_RST;
wire       MICROCODE_EN_SI;
wire       MICROCODE_EN_SO;
wire       STEP_ALGO_SELECT;
wire [1:0] MBISTPG_ALGO_MODE_SYNC;
wire [1:0] MBISTPG_ALGO_MODE_INT;
wire       PAUSETOEND_ALGO_MODE;
wire       MBISTPG_MEM_RST_SYNC;
wire       MBISTPG_REDUCED_ADDR_CNT_EN_SYNC;
wire       MBISTPG_REDUCED_ADDR_CNT_EN_INT;
reg        REDUCED_ADDR_CNT_EN_REG;
wire       REDUCED_ADDR_CNT_EN_SI;
wire       REDUCED_ADDR_CNT_EN_SO;
wire       INIT_SIGNAL_GEN_REGS;
wire       INIT_DATA_GEN_REGS;
reg        MEM0_BIST_COLLAR_SI_RetimeOut;
reg        MEM0_BIST_COLLAR_SO_RetimeIn;
wire       FREEZE_GO_ID;
reg  [0:0] MEM_SELECT_REG;
wire [0:0] MEM_SELECT_REG_INT;
wire       MEM_SELECT_REG_SI;
wire       MEM_SELECT_REG_SO;
wire       BIST_CLK_INT;
wire       BIST_EN_INT;
wire       BIST_CLK_GATED;
wire       INJECT_TCK;
wire       BIST_DONE_INT;
wire       BIST_EN_RST;
wire       BIST_EN_RETIME1_IN;
wire       BIST_EN_RETIME1;
wire       BIST_EN_RETIME2_IN;
reg        BIST_EN_RETIME2;
wire       BIST_HOLD_INT;
wire [2:0] BIST_SETUP_INT2;
wire       MBISTPG_EN_INT;
wire       BIST_CMP_INT;
wire       BIST_CMP_FROM_SIGNAL_GEN;
wire       BIST_RUN_TO_COLLAR0_INT;
wire       BIST_RUN_TO_COLLAR0_PRE;
wire       BIST_COLLAR_EN0_PRE;
wire       BIST_COLLAR_EN0_INT;
wire       POINTER_CNTRL_SI;
wire       POINTER_CNTRL_SO;
wire       ADD_GEN_SI;
wire       ADD_GEN_SO;
wire       SIGNAL_GEN_SI;
wire       SIGNAL_GEN_SO;
wire       REPEAT_LOOP_CNTRL_SI;
wire       REPEAT_LOOP_CNTRL_SO;
wire       DATA_GEN_SI;
wire       DATA_GEN_SO;
wire       COUNTERA_SI;
wire       COUNTERA_SO;
wire       COLLAR_GO;
wire       MBISTPG_GO_INT;
wire       BIST_SI_SYNC;
wire       BIST_SHIFT_SYNC;
wire       BIST_SHIFT_SHORT;
wire [2:0] BIST_SETUP_INT;
wire       MBISTPG_TESTDATA_SELECT_INT;
wire       SHORT_SETUP_SYNC;
reg        TO_COLLAR_SI;
wire       TO_COLLAR_SI_MUX_INPUT0;
wire       TO_COLLAR_SI_MUX_INPUT1;
wire       BIST_HOLD_R;
wire       BIST_HOLD_R_INT;
wire       LAST_STATE_DONE;
wire       BIST_ON_TO_BUF;
wire       BIST_ON;
wire       BIST_DONE;
wire       BIST_IDLE;
wire       LAST_TICK;
wire       LAST_STATE;
wire       SETUP_PULSE1;
wire       SETUP_PULSE2;
wire [2:0] OP_SELECT_CMD;
wire [1:0] A_EQUALS_B_INVERT_DATA;
wire [2:0] ADD_Y1_CMD;
wire [2:0] ADD_X1_CMD;
wire [2:0] ADD_REG_SELECT;
wire [3:0] WDATA_CMD;
wire [3:0] EDATA_CMD;
wire [1:0] LOOP_CMD;
wire       COUNTERA_CMD;
wire       INH_LAST_ADDR_CNT;
wire       INH_DATA_CMP;
wire [2:0] ADD_Y1_CMD_MODIFIED;
wire [2:0] ADD_X1_CMD_MODIFIED;
wire [3:0] WDATA_CMD_MODIFIED;
wire [3:0] EDATA_CMD_MODIFIED;
wire       INH_LAST_ADDR_CNT_MODIFIED;
wire       INH_LAST_ADDR_CNT_MODIFIED_INT;
wire       INH_DATA_CMP_MODIFIED;
wire        LOOP_STATE_TRUE;
wire [3:0] LOOP_POINTER;
wire [2:0] ROW_ADDRESS;
wire [2:0] COLUMN_ADDRESS;
wire [2:0] X_ADDRESS;
wire [2:0] Y_ADDRESS;
wire [1:0] WRITE_DATA;
wire [1:0] EXPECT_DATA;
wire       A_EQUALS_B_TRIGGER;
wire       Y1_MINMAX_TRIGGER;
wire       Y1_MINMAX_TRIGGER_OUT;
wire       X1_MINMAX_TRIGGER;
wire       X1_MINMAX_TRIGGER_OUT;
wire       COUNTERA_ENDCOUNT_TRIGGER;
wire       COUNTERA_ENDCOUNT_TRIGGER_INT;
wire       LOOPCOUNTMAX_TRIGGER;
wire       LOOPCOUNTMAX_TRIGGER_INT;
wire       BIST_INIT;
wire       RESET_REG_SETUP1;
wire       RESET_REG_SETUP2;
wire       BIST_RUN;
wire       BIST_RUN_INT;
wire       BIST_RUN_PIPE;
wire       DEFAULT_MODE;
wire       RESET_REG_DEFAULT_MODE;
wire       CLEAR_DEFAULT;
wire       CLEAR;
wire       BIST_DIAG_EN;
wire       ESOE_RESET;
wire       FL_CNT_MODE0_SYNC;
wire       BIST_IDLE_PULSE;
wire       MBISTPG_DIAG_EN_GATED;
wire       MBISTPG_DIAG_EN_SYNC;
reg        DIAG_EN_R;
wire       DIAG_EN_SI;
wire       DIAG_EN_SO;
reg        GO_EN;
wire       CTL_COMP_SI;
wire       CTL_COMP_SO;
wire       HOLD_EN;
wire       BIST_STOP_ON_ERROR_EN_INT;



//----------------------------------
//-----  Controller Main Code  -----
//----------------------------------
    assign BIST_ON_TO_COLLAR  = BIST_ON_TO_BUF;
 
    assign INJECT_TCK = MBISTPG_EN_INT & BIST_HOLD_INT & (~LV_TM); 


//------------------------
//-- BIST_EN Retiming --
//------------------------
    assign BIST_EN_RST              = ~MBISTPG_ASYNC_RESETN;
    assign BIST_EN_RETIME1_IN       = MBISTPG_EN_INT & BIST_SETUP[1];
    // Posedge retiming cell
    memlibc_memory_bist_assembly_rtl_tessent_posedge_synchronizer_reset tessent_persistent_cell_MBIST_NTC_RETIMING_CELL_CLK_EN ( 
        .rn          (MBISTPG_ASYNC_RESETN         ), // i
        .clk        ( BIST_CLK     ), // i
        .d          ( BIST_EN_RETIME1_IN          ), // i
        .q          ( BIST_EN_RETIME1             )  // o
    ); 
    assign BIST_EN_RETIME2_IN       = BIST_EN_RETIME1;
 
    // Posedge stage
    // synopsys async_set_reset "BIST_EN_RST"
    always @ (posedge BIST_CLK or posedge BIST_EN_RST) begin
        if (BIST_EN_RST)
            BIST_EN_RETIME2         <= 1'b0;
        else
            BIST_EN_RETIME2         <= BIST_EN_RETIME2_IN;
    end
    assign BIST_EN_INT              = BIST_ON_TO_BUF ? ((~BIST_DONE_INT) & (~FREEZE_STOP_ERROR)) : BIST_DONE_INT;
    memlibc_memory_bist_assembly_rtl_tessent_clk_gate_and tessent_persistent_cell_GATING_BIST_CLK (
        .clk        ( BIST_CLK                    ),
        .te         ( 1'b0         ),
        .fe         ( BIST_EN_INT & (~MCP_BOUNDING_EN)           ),
        .clkg       ( BIST_CLK_GATED              )
    );
    memlibc_memory_bist_assembly_rtl_tessent_clk_mux2 tessent_persistent_cell_BIST_CLK_INT (
        .s          ( INJECT_TCK                                 ),
        .a          ( BIST_CLK_GATED                             ),
        .b          ( TCK                                        ),
        .y          ( BIST_CLK_INT                               )
    );

 
    memlibc_memory_bist_assembly_rtl_tessent_and2 tessent_persistent_cell_AND_MBISTPG_MEM_RST_SYNC (
        .a          ( MBISTPG_MEM_RST                            ),
        .b          ( BIST_ON                                    ),
        .y          ( MBISTPG_MEM_RST_SYNC                       )
    );

    memlibc_memory_bist_assembly_rtl_tessent_and2 tessent_persistent_cell_AND_FL_CNT_MODE0_SYNC (
        .a          ( FL_CNT_MODE[0]                             ),
        .b          ( BIST_ON                                    ),
        .y          ( FL_CNT_MODE0_SYNC                          )
    );

 
    assign INIT_SIGNAL_GEN_REGS     = ~(SELECT_COMMON_OPSET_REG);
    assign INIT_DATA_GEN_REGS       = ~(SELECT_COMMON_DATA_PAT_REG);
    memlibc_memory_bist_assembly_rtl_tessent_posedge_synchronizer_reset tessent_persistent_cell_MBIST_NTC_RETIMING_CELL_TESTDATA_SELECT ( 
        .rn                         (MBISTPG_ASYNC_RESETN         ), // i
        .clk        ( BIST_CLK     ), // i
        .d          ( MBISTPG_TESTDATA_SELECT     ), // i
        .q          ( BIST_TESTDATA_SELECT_TO_COLLAR             )  // o
    ); 
    assign RESET_REG_SETUP1         = SETUP_PULSE1;
    assign RESET_REG_SETUP2         = SETUP_PULSE2;
    assign RESET_REG_DEFAULT_MODE   = (SETUP_PULSE1 & (DEFAULT_MODE | (~MICROCODE_EN_REG)));
    assign CLEAR_DEFAULT            = (BIST_INIT & DEFAULT_MODE & (~GO_EN));
    assign CLEAR                    = (BIST_INIT & (~GO_EN));
    assign BIST_CLEAR_DEFAULT       = CLEAR_DEFAULT & (~MBISTPG_ALGO_MODE_INT[1]);
    assign BIST_CLEAR               = CLEAR & (~MBISTPG_ALGO_MODE_INT[1]);
    assign BIST_COL_ADD             = COLUMN_ADDRESS;
    assign BIST_ROW_ADD             = ROW_ADDRESS;
    assign BIST_WRITE_DATA          = WRITE_DATA;
    assign BIST_EXPECT_DATA         = EXPECT_DATA;
    assign BIST_SHIFT_COLLAR        = BIST_SHIFT_SHORT;
    assign BIST_COLLAR_SETUP        = (SETUP_PULSE1 & (~BIST_HOLD_R_INT));
    assign BIST_COLLAR_DIAG_EN      = DIAG_EN_R;
    //----------------------
    //-- Collar BIST_HOLD --
    //----------------------
    assign BIST_COLLAR_HOLD         = BIST_HOLD_R;
    //--------------------------
    //-- Controller BIST_HOLD --
    //--------------------------
    assign BIST_HOLD_R_INT          = HOLD_EN;
     
    memlibc_memory_bist_assembly_rtl_tessent_and2 tessent_persistent_cell_AND_BIST_SI_SYNC (
        .a          ( BIST_SI                                    ),
        .b          ( BIST_SHIFT_SYNC                            ),
        .y          ( BIST_SI_SYNC                               )
    );
 
    assign BIST_SETUP_INT2          = {BIST_SETUP2, BIST_SETUP[1:0]};    

    assign BIST_SETUP_INT           = BIST_SETUP_INT2;
 
    memlibc_memory_bist_assembly_rtl_tessent_and2 tessent_persistent_cell_AND_SHORT_SETUP_SYNC (
        .a          ( (~BIST_SETUP_INT[2]) & (~BIST_SETUP_INT[1]) & (~BIST_SETUP_INT[0])       ),
        .b          ( BIST_SHIFT_SYNC                            ),
        .y          ( SHORT_SETUP_SYNC                           )
    );

    wire  BIST_DONE_PIPE0;
    assign BIST_DONE_PIPE0 = BIST_DONE;

    reg  BIST_DONE_PIPE1;
    reg  BIST_DONE_PIPE2;

    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @(posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
      if ( ~ MBISTPG_ASYNC_RESETN ) begin
        BIST_DONE_PIPE1 <= 1'b0;
        BIST_DONE_PIPE2 <= 1'b0;
      end else begin
        BIST_DONE_PIPE1 <= BIST_DONE_PIPE0;
        BIST_DONE_PIPE2 <= BIST_DONE_PIPE1;
      end
    end

    assign BIST_DONE_INT = BIST_DONE_PIPE2;

    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_MBISTPG_DONE (
        .a           (BIST_DONE_PIPE2),
        .y           (MBISTPG_DONE)
    );
    assign MBISTPG_RESET_REG_SETUP2 = RESET_REG_SETUP2;
 
    assign MBISTPG_EN_INT = MBISTPG_EN;
    //-------------------
    //-- Collar Enable --
    //-------------------
    assign BIST_COLLAR_EN0          = BIST_COLLAR_EN0_INT; // Memory ID: m1
    assign BIST_RUN_TO_COLLAR0      = BIST_RUN_TO_COLLAR0_INT; // Memory ID: m1
    assign BIST_COLLAR_EN0_INT      = BIST_COLLAR_EN0_PRE;
    assign BIST_RUN_TO_COLLAR0_INT                 = BIST_RUN_TO_COLLAR0_PRE;
    assign BIST_RUN_TO_COLLAR0_PRE                 = (BIST_RUN_INT|BIST_RUN_PIPE) & MEM_SELECT_REG_INT[0];
    assign BIST_COLLAR_EN0_PRE      = BIST_RUN_INT & MEM_SELECT_REG_INT[0] ;
 
 
    assign BIST_SHIFT_SHORT  = BIST_HOLD_INT & MBISTPG_EN_INT & (~BIST_SETUP2) & (~BIST_SETUP[1]);  
    assign BIST_SHIFT_SYNC   = BIST_HOLD_INT & MBISTPG_EN_INT;
    assign BIST_HOLD_INT = BIST_HOLD;
    
  assign BIST_ON_TO_BUF           = BIST_EN_RETIME2;  
    memlibc_memory_bist_assembly_rtl_tessent_and2 tessent_persistent_cell_AND_DEFAULT_MODE (
        .a          ( ~BIST_SETUP[0]                             ),
        .b          ( BIST_ON_TO_BUF                             ),
        .y          ( DEFAULT_MODE                               )
    );
 
  assign BIST_HOLD_R              = BIST_HOLD_INT;            
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_BIST_ON (
        .a           (BIST_ON_TO_BUF),
        .y           (BIST_ON)
    );    
 
 
    assign BYPASS_RUN_STATE_INT     = (MBISTPG_MEM_RST_SYNC & (MBISTPG_ALGO_MODE_INT != 2'b00));
    memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_fsm MBISTPG_FSM (
       .BIST_CLK                    (BIST_CLK_INT                ), 
       .BIST_ON                     (BIST_ON_TO_BUF              ),
       .BIST_HOLD_R                 (BIST_HOLD_R                 ),
       .BYPASS_RUN_STATE            (BYPASS_RUN_STATE_INT        ),
       .BIST_ASYNC_RESETN           (MBISTPG_ASYNC_RESETN        ),
       .PAUSETOEND_ALGO_MODE        (PAUSETOEND_ALGO_MODE                       ),
       .LAST_STATE_DONE             (LAST_STATE_DONE             ),
       .SETUP_PULSE1                (SETUP_PULSE1                ),
       .SETUP_PULSE2                (SETUP_PULSE2                ),
       .BIST_RUN                    (BIST_RUN_INT                ),
       .BIST_RUN_PIPE               (BIST_RUN_PIPE               ),
       .BIST_INIT                   (BIST_INIT                   ),
       .BIST_DONE                   (BIST_DONE                   ),
       .BIST_IDLE_PULSE             (BIST_IDLE_PULSE             ),
       .BIST_IDLE                   (BIST_IDLE                   )
    );                     
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_BIST_RUN (
        .a           (BIST_RUN_INT),
        .y           (BIST_RUN)
    );    
 
  reg BIST_SI_PIPELINE;
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
       if (~MBISTPG_ASYNC_RESETN)
          BIST_SI_PIPELINE <= 1'b0;
       else
          BIST_SI_PIPELINE <= BIST_SI_SYNC;
    end

    //----------------
    // DIAGNOSIS MODE
    //----------------
    memlibc_memory_bist_assembly_rtl_tessent_and2 tessent_persistent_cell_AND_MBISTPG_DIAG_EN_GATED (
        .a          ( MBISTPG_DIAG_EN                            ),
        .b          ( BIST_ON                                    ),
        .y          ( MBISTPG_DIAG_EN_GATED                      )
    );

    assign MBISTPG_DIAG_EN_SYNC = MBISTPG_DIAG_EN_GATED;
    assign DIAG_EN_SI = BIST_SI_PIPELINE;
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
       if (~MBISTPG_ASYNC_RESETN)
          DIAG_EN_R <= 1'b0;
       else     
       if (BIST_SHIFT_SHORT) begin
          DIAG_EN_R <= DIAG_EN_SI;
       end else begin
          if ((~BIST_HOLD_R_INT) & CLEAR_DEFAULT) begin
             DIAG_EN_R <= MBISTPG_DIAG_EN_SYNC;
          end
       end
    end
    assign DIAG_EN_SO = DIAG_EN_R;
    assign BIST_DIAG_EN = DIAG_EN_R;

wire CMP_EN;
wire CMP_EN_IN;
assign CMP_EN_IN = BIST_CMP;

 
reg CMP_EN_MASK_EN,CMP_EN_MASK;
wire CMP_EN_INT;
 
// synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
always @(posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
  if ( ~MBISTPG_ASYNC_RESETN ) begin
    CMP_EN_MASK_EN <= 1'b0;
    CMP_EN_MASK    <= 1'b0;
  end else
  if ( BIST_SHIFT_SHORT ) begin
    CMP_EN_MASK_EN <= DIAG_EN_SO;
    CMP_EN_MASK    <= CMP_EN_MASK_EN;
  end else begin
    if ( CLEAR_DEFAULT ) begin
      CMP_EN_MASK_EN <= 1'b0;
      CMP_EN_MASK    <= 1'b0;
    end else begin
      if ( (~BIST_HOLD_R_INT) & GO_EN ) begin
          CMP_EN_MASK    <= ~CMP_EN_MASK;
      end
    end
  end
end
assign CMP_EN_INT = CMP_EN_IN; 
reg  CMP_EN_R;
  // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
   always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
      if (~MBISTPG_ASYNC_RESETN) begin
         CMP_EN_R    <= 1'b0;
      end else begin
         CMP_EN_R    <= (~FREEZE_GO_ID) & (~HOLD_EN);
      end
   end
assign BIST_CMP      = BIST_CMP_INT;
assign BIST_CMP_INT                 = BIST_CMP_FROM_SIGNAL_GEN & (~BIST_HOLD_R_INT) & (~INH_DATA_CMP_MODIFIED) & ((~CMP_EN_MASK_EN) | CMP_EN_MASK); 
assign CMP_EN = CMP_EN_INT;

    //-------------------------------
    // SELECTIVE PARALLEL MEMORY TEST
    //-------------------------------
    // Step 0  
    //     MemoryInstance M1 enabled by register MEM_SELECT_REG[0]  
    assign MEM_SELECT_REG_SI = CMP_EN_MASK;
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
        if (~MBISTPG_ASYNC_RESETN)
            MEM_SELECT_REG          <= {1{1'b1}};
        else 
        if (BIST_SHIFT_SHORT)
            MEM_SELECT_REG          <= MEM_SELECT_REG_SI;
        else
        if ((~BIST_HOLD_R_INT) & CLEAR_DEFAULT)
            MEM_SELECT_REG          <= {1{1'b1}};
    end
    assign MEM_SELECT_REG_SO = MEM_SELECT_REG[0];
    assign MEM_SELECT_REG_INT = MEM_SELECT_REG;

    //------------------------
    // REDUCED ADDRESS COUNT
    //------------------------
    memlibc_memory_bist_assembly_rtl_tessent_and2 tessent_persistent_cell_AND_MBISTPG_REDUCED_ADDR_CNT_EN_SYNC (
        .a          ( MBISTPG_REDUCED_ADDR_CNT_EN                ),
        .b          ( BIST_ON                                    ),
        .y          ( MBISTPG_REDUCED_ADDR_CNT_EN_SYNC           )
    );

    assign REDUCED_ADDR_CNT_EN_SI = MEM_SELECT_REG_SO;
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
       if (~MBISTPG_ASYNC_RESETN)
          REDUCED_ADDR_CNT_EN_REG   <= 1'b0;
       else
       if (BIST_SHIFT_SHORT) begin
          REDUCED_ADDR_CNT_EN_REG                  <= REDUCED_ADDR_CNT_EN_SI;
       end else begin
          if ((~BIST_HOLD_R_INT) & CLEAR_DEFAULT) begin
             REDUCED_ADDR_CNT_EN_REG               <= MBISTPG_REDUCED_ADDR_CNT_EN_SYNC; 
          end
       end
    end
    assign REDUCED_ADDR_CNT_EN_SO = REDUCED_ADDR_CNT_EN_REG;
    assign MBISTPG_REDUCED_ADDR_CNT_EN_INT = REDUCED_ADDR_CNT_EN_REG ;

    //------------------------
    // PARALLEL RETENTION TEST
    //------------------------
    memlibc_memory_bist_assembly_rtl_tessent_and2 tessent_persistent_cell_AND_MBISTPG_ALGO_MODE_SYNC0 (
        .a          ( MBISTPG_ALGO_MODE[0]                       ),
        .b          ( BIST_ON                                    ),
        .y          ( MBISTPG_ALGO_MODE_SYNC[0]                  )
    );

    memlibc_memory_bist_assembly_rtl_tessent_and2 tessent_persistent_cell_AND_MBISTPG_ALGO_MODE_SYNC1 (
        .a          ( MBISTPG_ALGO_MODE[1]                       ),
        .b          ( BIST_ON                                    ),
        .y          ( MBISTPG_ALGO_MODE_SYNC[1]                  )
    );

    assign MBISTPG_ALGO_MODE_INT = MBISTPG_ALGO_MODE_SYNC;
    assign PAUSETOEND_ALGO_MODE     = (MBISTPG_ALGO_MODE_INT == 2'b11);

    //------------------------
    // HARDCODED ALGO SELECT
    //------------------------
    assign ALGO_SEL_CNT_SI = REDUCED_ADDR_CNT_EN_SO;
    // synopsys sync_set_reset "ALGO_SEL_CNT_RST"
    assign ALGO_SEL_CNT_RST = (~BIST_HOLD_R_INT) & CLEAR_DEFAULT;
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
       if (~MBISTPG_ASYNC_RESETN)
          ALGO_SEL_CNT_REG          <= 1'b0;
       else
       if (ALGO_SEL_CNT_RST) begin
          ALGO_SEL_CNT_REG          <= 1'b0;
       end else begin
          if (BIST_SHIFT_SHORT) begin
             ALGO_SEL_CNT_REG       <= ALGO_SEL_CNT_SI;
          end
       end
    end
    assign ALGO_SEL_CNT_SO = ALGO_SEL_CNT_REG;

    //------------------------
    // COMMON OPSET SELECT
    //------------------------
    assign SELECT_COMMON_OPSET_SI = ALGO_SEL_CNT_SO;
    // synopsys sync_set_reset "SELECT_COMMON_OPSET_RST"
    assign SELECT_COMMON_OPSET_RST = (~BIST_HOLD_R_INT) & CLEAR_DEFAULT;
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
       if (~MBISTPG_ASYNC_RESETN)
          SELECT_COMMON_OPSET_REG   <= 1'b0;
       else
       if (SELECT_COMMON_OPSET_RST) begin
          SELECT_COMMON_OPSET_REG   <= 1'b0;
       end else begin
          if (BIST_SHIFT_SHORT) begin
             SELECT_COMMON_OPSET_REG               <= SELECT_COMMON_OPSET_SI;
          end
       end
    end
    assign SELECT_COMMON_OPSET_SO = SELECT_COMMON_OPSET_REG;

    //------------------------
    // COMMON DATA PATTERN SELECT
    //------------------------
    assign SELECT_COMMON_DATA_PAT_SI = SELECT_COMMON_OPSET_SO;
    // synopsys sync_set_reset "SELECT_COMMON_DATA_PAT_RST"
    assign SELECT_COMMON_DATA_PAT_RST = (~BIST_HOLD_R_INT) & CLEAR_DEFAULT;
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
       if (~MBISTPG_ASYNC_RESETN)
          SELECT_COMMON_DATA_PAT_REG               <= 1'b0;
       else
       if (SELECT_COMMON_DATA_PAT_RST) begin
          SELECT_COMMON_DATA_PAT_REG               <= 1'b0;
       end else begin
          if (BIST_SHIFT_SHORT) begin
             SELECT_COMMON_DATA_PAT_REG            <= SELECT_COMMON_DATA_PAT_SI;
          end
       end
    end
    assign SELECT_COMMON_DATA_PAT_SO = SELECT_COMMON_DATA_PAT_REG;

    //------------------------
    // MICROCODE ARRAY ENABLE
    //------------------------
    assign MICROCODE_EN_SI = SELECT_COMMON_DATA_PAT_SO;
    // synopsys sync_set_reset "MICROCODE_EN_RST"
    assign MICROCODE_EN_RST = (~BIST_HOLD_R_INT) & CLEAR_DEFAULT;
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
       if (~MBISTPG_ASYNC_RESETN)
          MICROCODE_EN_REG          <= 1'b0;
       else
       if (MICROCODE_EN_RST) begin
          MICROCODE_EN_REG          <= 1'b0; 
       end else begin
          if (BIST_SHIFT_SHORT) begin
             MICROCODE_EN_REG       <= MICROCODE_EN_SI;
          end
       end
    end
    assign MICROCODE_EN_SO = MICROCODE_EN_REG;

    assign POINTER_CNTRL_SI         = MICROCODE_EN_SO;
    memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_pointer_cntrl MBISTPG_POINTER_CNTRL ( 
       .BIST_CLK                                   ( BIST_CLK_INT                              ),
       .RESET_REG_SETUP1                           (RESET_REG_SETUP1                           ),
       .RESET_REG_DEFAULT_MODE                     (RESET_REG_DEFAULT_MODE                     ),
       .DEFAULT_MODE                               (DEFAULT_MODE                               ),
       .BIST_MICROCODE_EN                          (MICROCODE_EN_REG                           ),
       .RESET_REG_SETUP2                           (RESET_REG_SETUP2                           ),
       .BIST_RUN                                   (BIST_RUN                                   ),
       .BIST_ON                                    (BIST_ON_TO_BUF              ),
       .LAST_TICK                                  (LAST_TICK                                  ),
       .BIST_ASYNC_RESETN                          (MBISTPG_ASYNC_RESETN        ),
       .ALGO_MODE                                  (MBISTPG_ALGO_MODE_INT       ),
       .MEM_RST                                    (MBISTPG_MEM_RST_SYNC        ),
       .ESOE_RESET                                 (ESOE_RESET                                 ),
       .OP_SELECT_CMD                              (OP_SELECT_CMD                              ),
       .A_EQUALS_B_INVERT_DATA                     (A_EQUALS_B_INVERT_DATA                     ),
       .ADD_Y1_CMD                                 (ADD_Y1_CMD                                 ),
       .ADD_X1_CMD                                 (ADD_X1_CMD                                 ),
       .ADD_REG_SELECT                             (ADD_REG_SELECT                             ),
       .WDATA_CMD                                  (WDATA_CMD                                  ),
       .EDATA_CMD                                  (EDATA_CMD                                  ),
       .LOOP_CMD                                   (LOOP_CMD                                   ),
       .COUNTERA_CMD                               (COUNTERA_CMD                               ),
       .INH_LAST_ADDR_CNT                          (INH_LAST_ADDR_CNT                          ),
       .INH_DATA_CMP                               (INH_DATA_CMP                               ),
       .Y1_MINMAX_TRIGGER                          (Y1_MINMAX_TRIGGER                          ),
       .X1_MINMAX_TRIGGER                          (X1_MINMAX_TRIGGER                          ),
       .COUNTERA_ENDCOUNT_TRIGGER                  (COUNTERA_ENDCOUNT_TRIGGER                  ),
       .LOOPCOUNTMAX_TRIGGER                       (LOOPCOUNTMAX_TRIGGER                       ),
       .LOOP_POINTER                               (LOOP_POINTER                               ),
       .BIST_HOLD                                  (BIST_HOLD_R_INT                            ),
       .BIST_SHIFT_SHORT                           (BIST_SHIFT_SHORT                           ),
       .SI                                         (POINTER_CNTRL_SI                           ),
       .SHORT_SETUP                                (SHORT_SETUP_SYNC                           ),
       .SO                                         (POINTER_CNTRL_SO                           ),
       .LAST_STATE                                 (LAST_STATE                                 ),
       .LAST_STATE_DONE                            (LAST_STATE_DONE                            ),
       .LOOP_STATE_TRUE                            (LOOP_STATE_TRUE                            )
    );

    assign ADD_GEN_SI               = POINTER_CNTRL_SO;
    memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_add_gen MBISTPG_ADD_GEN (
       .BIST_CLK                    (BIST_CLK_INT                ),
       .BIST_RUN                    (BIST_RUN                    ),
       .RESET_REG_DEFAULT_MODE      (RESET_REG_DEFAULT_MODE      ),
       .BIST_ASYNC_RESETN           (MBISTPG_ASYNC_RESETN        ),
       .SI                          (ADD_GEN_SI                  ),
       .SO                          (ADD_GEN_SO                  ),
       .BIST_SHIFT_SHORT            (BIST_SHIFT_SHORT            ),
       .BIST_HOLD                   (BIST_HOLD_R_INT             ),
       .LAST_TICK                   (LAST_TICK                   ),
       .MBISTPG_REDUCED_ADDR_CNT_EN (MBISTPG_REDUCED_ADDR_CNT_EN_INT            ),
       .ESOE_RESET                  (ESOE_RESET                  ), 
       .ADD_Y1_CMD                  (ADD_Y1_CMD_MODIFIED         ),
       .ADD_X1_CMD                  (ADD_X1_CMD_MODIFIED         ),
       .ADD_REG_SELECT              (ADD_REG_SELECT              ),
       .Y1_MINMAX_TRIGGER           (Y1_MINMAX_TRIGGER_OUT       ),
       .X1_MINMAX_TRIGGER           (X1_MINMAX_TRIGGER_OUT       ),
       .INH_LAST_ADDR_CNT           (INH_LAST_ADDR_CNT_MODIFIED  ),
       .X_ADDRESS                   (X_ADDRESS                   ),
       .Y_ADDRESS                   (Y_ADDRESS                   ),
       .A_EQUALS_B_TRIGGER          (A_EQUALS_B_TRIGGER          )
    );
 
    memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_add_format MBISTPG_ADD_FORMAT (
       .Y_ADDRESS                   (Y_ADDRESS                   ),
       .X_ADDRESS                   (X_ADDRESS                   ),
       .COLUMN_ADDRESS              (COLUMN_ADDRESS              ), 
       .ROW_ADDRESS                 (ROW_ADDRESS                 ) 
    );

    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_Y1_MINMAX_TRIGGER(
        .a           (Y1_MINMAX_TRIGGER_OUT),
        .y           (Y1_MINMAX_TRIGGER)
    );    
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_X1_MINMAX_TRIGGER(
        .a           (X1_MINMAX_TRIGGER_OUT),
        .y           (X1_MINMAX_TRIGGER)
    );    

    assign SIGNAL_GEN_SI            = ADD_GEN_SO;
    memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_signal_gen MBISTPG_SIGNAL_GEN (       
       .BIST_CLK                                   ( BIST_CLK_INT                              ),
       .BIST_ASYNC_RESETN                          ( MBISTPG_ASYNC_RESETN       ),
       .SI                                         (SIGNAL_GEN_SI                              ),
       .BIST_SHIFT_SHORT                           (BIST_SHIFT_SHORT                           ),
       .BIST_HOLD_R_INT                            (BIST_HOLD_R_INT                            ),
       .RESET_REG_DEFAULT_MODE                     (RESET_REG_DEFAULT_MODE      ),
       .OP_SELECT_CMD                              (OP_SELECT_CMD                              ),
       .BIST_RUN                                   (BIST_RUN_PIPE                              ),
       .BIST_RUN_TO_BUF                            (BIST_RUN_INT                               ),
       .BIST_RUN_BUF                               (BIST_RUN                                   ),
       .LAST_STATE_DONE                            (LAST_STATE_DONE                            ),
       .BIST_ALGO_SEL_CNT                          (INIT_SIGNAL_GEN_REGS        ), 
       .MEM_BYPASS_EN                              (MEM_BYPASS_EN               ),
       .LV_TM                                      (LV_TM        ),
       .BIST_CMP                                   (BIST_CMP_FROM_SIGNAL_GEN                   ),
       .BIST_WRITEENABLE            (BIST_WRITEENABLE                           ),
       .BIST_OUTPUTENABLE           (BIST_OUTPUTENABLE                          ),
       .BIST_SELECT                 (BIST_SELECT                                ),
       .SO                                         (SIGNAL_GEN_SO                              ),
       .LAST_TICK                                  (LAST_TICK                                  )
    );                                                     
    assign DATA_GEN_SI              = SIGNAL_GEN_SO;

    memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_data_gen MBISTPG_DATA_GEN (
       //inputs
       .BIST_CLK                    (BIST_CLK_INT                ),
       .BIST_HOLD                   (BIST_HOLD_R_INT             ),
       .BIST_ASYNC_RESETN           (MBISTPG_ASYNC_RESETN        ), 
       .RESET_REG_DEFAULT_MODE      (RESET_REG_DEFAULT_MODE      ),
       .WDATA_CMD                   (WDATA_CMD_MODIFIED          ),
       .EDATA_CMD                   (EDATA_CMD_MODIFIED          ),
       .ROW_ADDRESS                 (ROW_ADDRESS                 ),
       .COLUMN_ADDRESS              (COLUMN_ADDRESS              ),
       .BIST_ALGO_SEL_CNT           (INIT_DATA_GEN_REGS          ),
 
       .LAST_TICK                   (LAST_TICK                   ),
       .BIST_RUN                    (BIST_RUN                    ),
       .BIST_SHIFT_SHORT            (BIST_SHIFT_SHORT            ),
       .SI                          (DATA_GEN_SI                 ),
       .BIST_WRITEENABLE            (BIST_WRITEENABLE            ),
       //outputs
       .SO                          (DATA_GEN_SO                 ),
       .EXPECT_DATA                 (EXPECT_DATA                 ),
       .WRITE_DATA                  (WRITE_DATA                  )
    );
 

    assign REPEAT_LOOP_CNTRL_SI     = DATA_GEN_SO;
    memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_repeat_loop_cntrl MBISTPG_REPEAT_LOOP_CNTRL (
       .BIST_CLK                                   ( BIST_CLK_INT               ),
       .RESET_REG_SETUP1                           (RESET_REG_SETUP1            ),
       .RESET_REG_DEFAULT_MODE                     (RESET_REG_DEFAULT_MODE      ),
       .LOOP_CMD                                   (LOOP_CMD                    ),
       .BIST_ASYNC_RESETN                          (MBISTPG_ASYNC_RESETN        ),
       .ADD_Y1_CMD                                 (ADD_Y1_CMD                  ),
       .ADD_X1_CMD                                 (ADD_X1_CMD                  ),
 
       .WDATA_CMD                                  (WDATA_CMD                   ),
       .EDATA_CMD                                  (EDATA_CMD                   ),
       .INH_LAST_ADDR_CNT                          (INH_LAST_ADDR_CNT           ),
       .INH_DATA_CMP                               (INH_DATA_CMP                ),
       .LOOP_STATE_TRUE                            (LOOP_STATE_TRUE             ),
       .A_EQUALS_B_TRIGGER                         (A_EQUALS_B_TRIGGER          ),
       .A_EQUALS_B_INVERT_DATA                     (A_EQUALS_B_INVERT_DATA      ),
       .SI                                         (REPEAT_LOOP_CNTRL_SI        ),
       .BIST_HOLD                                  (BIST_HOLD_R_INT             ),
       .LAST_TICK                                  (LAST_TICK                   ),
       .BIST_SHIFT_SHORT                           (BIST_SHIFT_SHORT            ),
       .BIST_RUN                                   (BIST_RUN                    ),
       .LOOPCOUNTMAX_TRIGGER                       (LOOPCOUNTMAX_TRIGGER_INT    ),
       .LOOP_POINTER                               (LOOP_POINTER                ),
       .ADD_Y1_CMD_MODIFIED                        (ADD_Y1_CMD_MODIFIED         ),
       .ADD_X1_CMD_MODIFIED                        (ADD_X1_CMD_MODIFIED         ),
       .SO                                         (REPEAT_LOOP_CNTRL_SO        ),
       .ESOE_RESET                                 (ESOE_RESET                                 ),
       .WDATA_CMD_MODIFIED                         (WDATA_CMD_MODIFIED          ),
       .EDATA_CMD_MODIFIED                         (EDATA_CMD_MODIFIED          ),
       .INH_LAST_ADDR_CNT_MODIFIED                 (INH_LAST_ADDR_CNT_MODIFIED_INT             ),
       .INH_DATA_CMP_MODIFIED                      (INH_DATA_CMP_MODIFIED       )
    );
 
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_LOOPCOUNTMAX_TRIGGER (
        .a           (LOOPCOUNTMAX_TRIGGER_INT),
        .y           (LOOPCOUNTMAX_TRIGGER)
    );    
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_INH_LAST_ADDR_CNT (
        .a           (INH_LAST_ADDR_CNT_MODIFIED_INT),
        .y           (INH_LAST_ADDR_CNT_MODIFIED)
    );    
    assign COUNTERA_ENDCOUNT_TRIGGER               = 1'b0;
    
    //---------------------
    // GO ENABLE
    //---------------------
    //synopsys sync_set_reset "BIST_ON"
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
       if (~MBISTPG_ASYNC_RESETN)
          GO_EN <= 1'b0;
       else
       if (~BIST_ON_TO_BUF) begin
          GO_EN <= 1'b0;
       end else begin
          if (RESET_REG_SETUP1) begin
             GO_EN <= 1'b1;
          end
       end
    end
    //---------------------
    // MBISTPG_GO MUXING
    //---------------------
    // BIST_COLLAR_GO[0] connects to MemoryInstance: m1
    assign COLLAR_GO                = BIST_COLLAR_GO;
    assign MBISTPG_GO_INT = GO_EN & (COLLAR_GO);
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_MBISTPG_GO (
        .a           ( MBISTPG_GO_INT              ),
        .y           ( MBISTPG_GO   )
    );
 
 
    //---------------------------------------
    // Setup chain muxing to first collar
    //---------------------------------------
    assign TO_COLLAR_SI_MUX_INPUT0 = REPEAT_LOOP_CNTRL_SO;
    assign TO_COLLAR_SI_MUX_INPUT1 = REPEAT_LOOP_CNTRL_SO;
    always @ (TO_COLLAR_SI_MUX_INPUT0 ) begin
        TO_COLLAR_SI = TO_COLLAR_SI_MUX_INPUT0;
    end
    //----------------------
    // Collar SI/SO chaining
    //----------------------
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (negedge TCK or negedge MBISTPG_ASYNC_RESETN) begin
       if (~MBISTPG_ASYNC_RESETN) begin
          MEM0_BIST_COLLAR_SI_RetimeOut <= 1'b0;
          MEM0_BIST_COLLAR_SO_RetimeIn  <= 1'b0;
       end else begin
          MEM0_BIST_COLLAR_SI_RetimeOut <= TO_COLLAR_SI;
          MEM0_BIST_COLLAR_SO_RetimeIn <= MEM0_BIST_COLLAR_SO;
       end
    end
    assign MEM0_BIST_COLLAR_SI = MEM0_BIST_COLLAR_SI_RetimeOut;
    //------------------------------
    // Setup chain after last collar
    //------------------------------
    assign CTL_COMP_SI              = MEM0_BIST_COLLAR_SO_RetimeIn;
    reg BIST_SO_PIPELINE;
    // synopsys async_set_reset "MBISTPG_ASYNC_RESETN"
    always @ (posedge BIST_CLK_INT or negedge MBISTPG_ASYNC_RESETN) begin
       if (~MBISTPG_ASYNC_RESETN)
          BIST_SO_PIPELINE <= 1'b0;
       else
          BIST_SO_PIPELINE <= CTL_COMP_SO;
    end
    assign MBISTPG_SO               = BIST_SO_PIPELINE;
        
 
 
    memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_ctl_comp MBISTPG_CTL_COMP (
       .BIST_CLK                    ( BIST_CLK_INT                              ), // i
       .BIST_CLK_NG                 ( BIST_CLK                   ), // i
       .BIST_EN                     ( MBISTPG_EN_INT             ), // i
       .BIST_ON                     ( BIST_ON                                   ), // i
       .BIST_ASYNC_RESETN           ( MBISTPG_ASYNC_RESETN       ), // i
       .BIST_IDLE_PULSE             ( BIST_IDLE_PULSE                           ), // i
       .CLEAR_DEFAULT               ( BIST_CLEAR_DEFAULT                        ), // i
       .BIST_HOLD_R                 ( BIST_HOLD_R                               ), // i
       .BIST_SHIFT_SHORT            ( BIST_SHIFT_SHORT                          ), // i
       .FREEZE_STOP_ERROR           ( FREEZE_STOP_ERROR                         ), // o
       .SI                          ( CTL_COMP_SI                               ), // i
       .SO                          ( CTL_COMP_SO                               ), // o
       .GO                          ( MBISTPG_GO                 ), // o
       .GO_EN                       ( GO_EN                                     ), // i
       .FREEZE_GO_ID                ( FREEZE_GO_ID                              ), // o
       .CMP_EN_R                    ( CMP_EN_R                                  ), // i
       .CMP_EN                      ( CMP_EN_INT                 ), // i
       .BIST_COLLAR_GO              ( BIST_COLLAR_GO                            ), // i
       .HOLD_EN                     ( HOLD_EN                                   ), // o
       .ERROR_CNT_ZERO              ( ERROR_CNT_ZERO                            ), // o
       .BIST_STOP_ON_ERROR_EN       ( BIST_STOP_ON_ERROR_EN_INT                 ), // o
       .BIST_DONE                   ( BIST_DONE                                 ), // i
       .FL1                         ( FL_CNT_MODE[1]                            ), // i
       .RESET_REG_SETUP1            ( RESET_REG_SETUP2                          ), // i
       .FL_CNT_MODE0_SYNC           ( FL_CNT_MODE0_SYNC                         ), // i
       .ESOE_RESET                  ( ESOE_RESET                                ), // o
       .TM                          ( LV_TM                                     )  // i
    );                       


endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller


/*------------------------------------------------------------------------------
     Module      :  memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_ctl_comp
 
     Description :  Module containing the controller comparators and the 
                    stop-on-error circuitry. 
---------------------------------------------------------------------------- */
 
module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_ctl_comp (
  input  wire BIST_CLK,
  input  wire BIST_CLK_NG,
  input  wire BIST_EN,
  input  wire BIST_ON,
  input  wire BIST_ASYNC_RESETN,
  input  wire BIST_IDLE_PULSE,
  input  wire CLEAR_DEFAULT,
  input  wire BIST_HOLD_R,
  input  wire BIST_SHIFT_SHORT,
  input  wire SI,
  input  wire GO,
  input  wire GO_EN,
  input  wire CMP_EN,
  input  wire CMP_EN_R,
  input  wire BIST_COLLAR_GO,
  input  wire BIST_DONE,
  input  wire FL1,
  input  wire RESET_REG_SETUP1,
  input  wire FL_CNT_MODE0_SYNC,
  input  wire TM,
  output reg  FREEZE_STOP_ERROR,
  output wire SO,
  output wire FREEZE_GO_ID,
  output wire HOLD_EN,
  output wire BIST_STOP_ON_ERROR_EN,
  output wire ERROR_CNT_ZERO,
  output reg  ESOE_RESET
 );
// Internal signals

wire                 ERROR_CNT_EN;
wire                 ERROR_CNT_REG_RST;
wire                 FREEZE_STOP_ERROR_IN;
wire                 FREEZE_STOP_ERROR_RST;
wire                 STOP_ON_ERROR_RST; 
reg                  STOP_ON_ERROR;
reg  [1:0]           PHASE_START_REG;
reg  [11:0]          ERROR_CNT_REG;
wire                 ERROR_CNT_LAST;
wire                 FL_CNT_MODE1_PULSE;  
reg  [11:0]          FL_CNT_REG;
reg                  ERROR_CNT_LT2_REG;
wire                 SOE_COLLAR_CMP_STAT;
wire ERROR;    
reg  ERROR_R;
    //-----------------------
    //-- Stop-on-Nth-Error --
    //-----------------------
assign HOLD_EN                = FREEZE_STOP_ERROR | BIST_HOLD_R;
 
assign BIST_STOP_ON_ERROR_EN  = STOP_ON_ERROR;
 
// synopsys sync_set_reset "STOP_ON_ERROR_RST"
assign STOP_ON_ERROR_RST = CLEAR_DEFAULT & (~HOLD_EN) & (~BIST_SHIFT_SHORT);
// synopsys sync_set_reset "FREEZE_STOP_ERROR_RST"
assign FREEZE_STOP_ERROR_RST = BIST_IDLE_PULSE;
assign SOE_COLLAR_CMP_STAT = BIST_STOP_ON_ERROR_EN ? (~BIST_COLLAR_GO) : CMP_EN;
assign ERROR_CNT_EN = (GO_EN & BIST_ON) & (SOE_COLLAR_CMP_STAT);
assign FREEZE_STOP_ERROR_IN = FREEZE_STOP_ERROR | (ERROR_CNT_EN & STOP_ON_ERROR & ERROR_CNT_ZERO);
assign ERROR_CNT_ZERO = ERROR_CNT_LT2_REG & (~ERROR_CNT_REG[0]) & BIST_STOP_ON_ERROR_EN;
assign ERROR_CNT_LAST       = ERROR_CNT_ZERO & ERROR_CNT_EN;

// synopsys sync_set_reset "ERROR_CNT_REG_RST"
assign ERROR_CNT_REG_RST = (CLEAR_DEFAULT & (~HOLD_EN) & (~BIST_SHIFT_SHORT)) | ESOE_RESET;
// synopsys async_set_reset "BIST_ASYNC_RESETN"
always @ (posedge BIST_CLK  or negedge BIST_ASYNC_RESETN) begin
    if (~BIST_ASYNC_RESETN)
        STOP_ON_ERROR <= 1'b0;
    else
    if (STOP_ON_ERROR_RST) begin
        STOP_ON_ERROR <= 1'b0;
    end else begin
        if (BIST_SHIFT_SHORT) begin
            STOP_ON_ERROR <= SI;
        end
    end
end    

    reg BIST_DONE_R;
    // synopsys async_set_reset BIST_ASYNC_RESETN
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
          BIST_DONE_R  <= 1'b0;
       else
          BIST_DONE_R  <= BIST_DONE;
   end
    // synopsys async_set_reset BIST_ASYNC_RESETN
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
          ESOE_RESET  <= 1'b0;
       else
          ESOE_RESET  <= (BIST_DONE & STOP_ON_ERROR & FL_CNT_MODE0_SYNC) & (~BIST_DONE_R);
   end

// synopsys async_set_reset "BIST_ASYNC_RESETN"
always @ (posedge BIST_CLK  or negedge BIST_ASYNC_RESETN) begin
    if (~BIST_ASYNC_RESETN)
        FREEZE_STOP_ERROR <= 1'b0;
    else 
    if (FREEZE_STOP_ERROR_RST) begin
        FREEZE_STOP_ERROR <= 1'b0;
    end else begin
        if (BIST_SHIFT_SHORT) begin
            FREEZE_STOP_ERROR <= STOP_ON_ERROR;
        end else begin
            if (~BIST_HOLD_R) begin
                if (GO_EN) begin
                    FREEZE_STOP_ERROR <= FREEZE_STOP_ERROR_IN;
                end
            end
        end
    end
end

// synopsys async_set_reset "BIST_ASYNC_RESETN"
always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
    if (~BIST_ASYNC_RESETN) 
        ERROR_CNT_REG <= 12'd0;
    else 
    if (ERROR_CNT_REG_RST) begin
        ERROR_CNT_REG <= 12'd0; 
    end else begin
        if (BIST_SHIFT_SHORT) begin
            ERROR_CNT_REG <= {ERROR_CNT_REG[10:0], FREEZE_STOP_ERROR};
        end else begin
            if (~HOLD_EN) begin
                if (~CLEAR_DEFAULT) begin
                    if (RESET_REG_SETUP1 & STOP_ON_ERROR & FL_CNT_MODE0_SYNC) begin
                         ERROR_CNT_REG <= FL_CNT_REG;
                    end else 
                        if ((ERROR_CNT_EN && (~ERROR_CNT_ZERO)) | (ERROR_CNT_LAST & (~((~CMP_EN_R) | FREEZE_STOP_ERROR)))) begin
                            ERROR_CNT_REG <= ERROR_CNT_DEC(ERROR_CNT_REG);
                        end
                end
            end
        end
    end
end  

// synopsys async_set_reset "BIST_ASYNC_RESETN"
always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
    if (~BIST_ASYNC_RESETN)
        ERROR_CNT_LT2_REG <= 1'b0;
    else
    if (ERROR_CNT_REG_RST)
        ERROR_CNT_LT2_REG <= 1'b0;
    else
        ERROR_CNT_LT2_REG <= ERROR_CNT_REG < 12'd2;
end

wire                 FL1_RETIME1_IN;
wire                 FL1_RETIME1;
wire                 FL1_SYNC_IN;
reg                  FL1_SYNC;

    // Posedge retiming cell
assign FL1_RETIME1_IN = FL1; 
    memlibc_memory_bist_assembly_rtl_tessent_posedge_synchronizer_reset tessent_persistent_cell_MBIST_NTC_RETIMING_CELL_FL1 ( 
        .rn                         (BIST_ASYNC_RESETN            ), // i
        .clk        ( BIST_CLK_NG  ),       // i
        .d          ( FL1_RETIME1_IN              ), // i
        .q          ( FL1_RETIME1  )     // o
    ); 

    assign FL1_SYNC_IN        =   FL1_RETIME1 ;
reg FL1_STICKY_R;
// synopsys async_set_reset "BIST_ASYNC_RESETN"
   always @ (posedge BIST_CLK_NG or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
         FL1_STICKY_R <= 1'b0;
       else
         FL1_STICKY_R <= (~RESET_REG_SETUP1) & (FL1_SYNC_IN | FL1_STICKY_R);
    end
// synopsys async_set_reset "BIST_ASYNC_RESETN"
   always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
           FL1_SYNC          <= 1'b0;
       else
           FL1_SYNC          <= FL1_STICKY_R;
   end
assign FL_CNT_MODE1_PULSE                = (FL1_STICKY_R & (~FL1_SYNC));

// synopsys async_set_reset "BIST_ASYNC_RESETN"
always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
    if (~BIST_ASYNC_RESETN) 
        FL_CNT_REG <= 12'd0;
    else 
       if (RESET_REG_SETUP1 & STOP_ON_ERROR & ((~FL_CNT_MODE0_SYNC))) begin
          FL_CNT_REG  <= ERROR_CNT_REG; 
       end else begin
          if (FL_CNT_MODE1_PULSE) 
             FL_CNT_REG  <= FL_CNT_INC(FL_CNT_REG);
       end
end

function automatic [11:0] FL_CNT_INC;
input [11:0] FL_CNT;
reg TOGGLE; 
integer i;
begin
   FL_CNT_INC[0] = ~FL_CNT[0];
   TOGGLE = 1;
   for (i=1;i<=11;i=i+1) begin
       TOGGLE = FL_CNT[i-1] & TOGGLE;
       FL_CNT_INC[i] = FL_CNT[i] ^ TOGGLE;
   end
end
endfunction

function automatic [11:0] ERROR_CNT_DEC;
input [11:0] ERROR_CNT;
reg TOGGLE;
integer i;
begin
   ERROR_CNT_DEC[0] = ~ERROR_CNT[0];
   TOGGLE = 1;
   for (i=1;i<=11;i=i+1) begin
       TOGGLE = (~ERROR_CNT[i-1]) & TOGGLE;
       ERROR_CNT_DEC[i] = ERROR_CNT[i] ^ TOGGLE;
   end
end
endfunction

    assign FREEZE_GO_ID = BIST_SHIFT_SHORT | (~GO_EN) | (~CMP_EN) ;
 
    assign SO        = ERROR_CNT_REG[11];
 
endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_ctl_comp
 
/*------------------------------------------------------------------------------
     Module      :  memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_pointer_cntrl
 
     Description :  This module contains the microcode register array as well as 
                    the pointer control logic for selecting the instruction to
                    be executed.
                    
                    To advance the pointer to the next instruction to be executed 
                    the NextState Conditions and the JumpState 
                    conditions for the selected instruction are tested. The 
                    testing of these conditions are prioritized and there are 
                    four possible states which may be selected next as follows:
                      1) NEXTSTATE - test the  NextState Conditions for a TRUE 
                                     and advance the instruction pointer by 1
                      2) LOOPSTATE - test the reduced NextState Conditions 
                                     (NextState conditions without the 
                                     LOOPCOUNTMAX trigger) for a TRUE and
                                     branch to the address provided by the 
                                     LOOPPOINTER register.
                      3) BRANCHSTATE - test the Branch Conditions for a TRUE
                                     and branch to the address in the BRANCHPOINTER
                                     field of the selected instruction.
                      4) ELSE -  do not change the intsruction pointer.
                    To end the test the LAST_STATE_DONE flag is set on a TRUE
                    NextState Condition when the instruction pointer is at the 
                    last available instruction of the microprogram array.
                    The instruction pointer remains at the LAST_STATE address
                    until reset by the SETUP_PULSE from the BIST_FSM module.
---------------------------------------------------------------------------- */
 
module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_pointer_cntrl (
  input wire BIST_CLK,
  input wire RESET_REG_SETUP1,
  input wire RESET_REG_DEFAULT_MODE,
  input wire RESET_REG_SETUP2,
  input wire BIST_RUN,
  input wire BIST_ON,
  input wire LAST_TICK,
  input wire [1:0] ALGO_MODE,
  input wire MEM_RST,
  input wire Y1_MINMAX_TRIGGER,
  input wire X1_MINMAX_TRIGGER,
  input wire COUNTERA_ENDCOUNT_TRIGGER,
  input wire LOOPCOUNTMAX_TRIGGER,
  input wire [3:0] LOOP_POINTER,
  input wire BIST_HOLD,
  input wire BIST_SHIFT_SHORT,
  input wire SI,
  input wire DEFAULT_MODE,
  input wire BIST_MICROCODE_EN,
  input wire BIST_ASYNC_RESETN,
  input wire ESOE_RESET,
  output wire SO,
  input wire SHORT_SETUP,
  output wire [2:0] OP_SELECT_CMD,
  output wire [1:0] A_EQUALS_B_INVERT_DATA,
  output wire [2:0] ADD_Y1_CMD,
  output wire [2:0] ADD_X1_CMD,
  output wire [2:0] ADD_REG_SELECT,
  output wire [3:0] WDATA_CMD,
  output wire [3:0] EDATA_CMD,
  output wire [1:0] LOOP_CMD,
  output wire COUNTERA_CMD,
  output wire INH_LAST_ADDR_CNT,
  output wire INH_DATA_CMP,
  output wire LOOP_STATE_TRUE,
  output wire LAST_STATE_DONE,
  output wire LAST_STATE
);
    reg              LAST_STATE_INT;
    wire   [3:0]     NEXT_POINTER;
    wire   [3:0]     NEXT_POINTER_TO_BUF;
    wire   [3:0]     NEXT_POINTER_INT;
    wire   [3:0]     BRANCH_POINTER;
    reg              EXECUTE_BRANCH_POINTER_REG3;
    reg              EXECUTE_BRANCH_POINTER_REG2;
    reg              EXECUTE_BRANCH_POINTER_REG1;
    reg              EXECUTE_BRANCH_POINTER_REG0;
    wire   [3:0]     NEXT_BRANCH_POINTER;
    wire             LOOP_STATE_TRUE_INT;
    wire             NEXT_STATE_TRUE;
    wire   [3:0]     NEXT_TRIGGERS;
    wire   [3:0]     NEXT_CONDITIONS;
    reg              EXECUTE_NEXT_CONDITIONS_REG3;
    reg              EXECUTE_NEXT_CONDITIONS_REG1;
    reg              EXECUTE_NEXT_CONDITIONS_REG0;
    wire   [3:0]     NEXT_CONDITIONS_FIELD;
    wire   [2:0]     LOOP_TRIGGERS;
    wire   [2:0]     LOOP_CONDITIONS;
    reg              EXECUTE_OP_SELECT_CMD_REG1;
    reg              EXECUTE_OP_SELECT_CMD_REG0;
    wire   [2:0]     NEXT_OP_SELECT_CMD;
    wire   [1:0]     NEXT_A_EQUALS_B_INVERT_DATA;
    reg              EXECUTE_ADD_Y1_CMD_REG1;
    reg              EXECUTE_ADD_Y1_CMD_REG0;
    wire   [2:0]     NEXT_ADD_Y1_CMD;
    reg              EXECUTE_ADD_X1_CMD_REG1;
    reg              EXECUTE_ADD_X1_CMD_REG0;
    wire   [2:0]     NEXT_ADD_X1_CMD;
    wire   [2:0]     NEXT_ADD_REG_SELECT;
    reg              EXECUTE_WDATA_CMD_REG3;
    reg              EXECUTE_WDATA_CMD_REG0;
    wire   [3:0]     NEXT_WDATA_CMD;
    reg              EXECUTE_EDATA_CMD_REG3;
    reg              EXECUTE_EDATA_CMD_REG0;
    wire   [3:0]     NEXT_EDATA_CMD;
    reg              EXECUTE_LOOP_CMD_REG0;
    wire   [1:0]     NEXT_LOOP_CMD;
    wire             NEXT_COUNTERA_CMD;
    reg              EXECUTE_INH_LAST_ADDR_CNT_REG0;
    wire             NEXT_INH_LAST_ADDR_CNT;
    reg              EXECUTE_INH_DATA_CMP_REG0;
    wire             NEXT_INH_DATA_CMP;
// [start] : Hard algo wires {{{
    wire   [34:0]    INSTRUCTION0_WIRE;
    wire   [34:0]    INSTRUCTION1_WIRE;
    wire   [34:0]    INSTRUCTION2_WIRE;
    wire   [34:0]    INSTRUCTION3_WIRE;
    wire   [34:0]    INSTRUCTION4_WIRE;
    wire   [34:0]    INSTRUCTION5_WIRE;
    wire   [34:0]    INSTRUCTION6_WIRE;
    wire   [34:0]    INSTRUCTION7_WIRE;
    wire   [34:0]    INSTRUCTION8_WIRE;
    wire   [34:0]    INSTRUCTION9_WIRE;
    wire   [34:0]    INSTRUCTION10_WIRE;
    wire   [34:0]    INSTRUCTION11_WIRE;
    wire   [34:0]    INSTRUCTION12_WIRE;
    wire   [34:0]    INSTRUCTION13_WIRE;
// [end]   : Hard algo wires }}}
// [start] : Final instruction assignment {{{
    wire   [34:0]    INSTRUCTION0;
    wire   [34:0]    INSTRUCTION1;
    wire   [34:0]    INSTRUCTION2;
    wire   [34:0]    INSTRUCTION3;
    wire   [34:0]    INSTRUCTION4;
    wire   [34:0]    INSTRUCTION5;
    wire   [34:0]    INSTRUCTION6;
    wire   [34:0]    INSTRUCTION7;
    wire   [34:0]    INSTRUCTION8;
    wire   [34:0]    INSTRUCTION9;
    wire   [34:0]    INSTRUCTION10;
    wire   [34:0]    INSTRUCTION11;
    wire   [34:0]    INSTRUCTION12;
    wire   [34:0]    INSTRUCTION13;
// [end]   : Final instruction assignment }}}
    reg [3:0] INST_POINTER;
    wire             INST_POINTER_SI;
    wire             INST_POINTER_SO;
    reg              LAST_STATE_DONE_REG;

//---------------------
//-- OperationSelect --
//---------------------
// [start] : OperationSelect {{{
    assign OP_SELECT_CMD            = {
                                        1'b0,
                                        EXECUTE_OP_SELECT_CMD_REG1,
                                        EXECUTE_OP_SELECT_CMD_REG0 
                                      };
 
    // [start] : instruction field {{{
    assign NEXT_OP_SELECT_CMD       = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[2:0]            :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[2:0]            :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[2:0]            :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[2:0]            :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[2:0]            :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[2:0]            :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[2:0]            :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[2:0]            :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[2:0]            :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[2:0]            :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[2:0]           :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[2:0]           :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[2:0]           :
                                                                  INSTRUCTION13[2:0]            ;
    // [end]   : instruction field }}}
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN) begin
            EXECUTE_OP_SELECT_CMD_REG1             <= 1'b0;
            EXECUTE_OP_SELECT_CMD_REG0             <= 1'b0;
        end else
        if (RESET_REG_SETUP2) begin
            EXECUTE_OP_SELECT_CMD_REG1             <= INSTRUCTION0[1];
            EXECUTE_OP_SELECT_CMD_REG0             <= INSTRUCTION0[0];
        end else
        if (LAST_TICK & (~BIST_HOLD)) begin
            EXECUTE_OP_SELECT_CMD_REG1            <= NEXT_OP_SELECT_CMD[1];
            EXECUTE_OP_SELECT_CMD_REG0            <= NEXT_OP_SELECT_CMD[0];
        end
    end
// [end]   : OperationSelect }}}


//------------------------
//-- Add_Reg_A_Equals_B --
//------------------------
// [start] : Add_Reg_A_Equals_B {{{
    assign A_EQUALS_B_INVERT_DATA   = {
                                        1'b0,
                                        1'b0 
                                      };
 
    // [start] : instruction field {{{
    assign NEXT_A_EQUALS_B_INVERT_DATA             = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[4:3]            :
                                                     (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[4:3]            :
                                                     (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[4:3]            :
                                                     (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[4:3]            :
                                                     (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[4:3]            :
                                                     (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[4:3]            :
                                                     (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[4:3]            :
                                                     (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[4:3]            :
                                                     (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[4:3]            :
                                                     (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[4:3]            :
                                                     (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[4:3]           :
                                                     (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[4:3]           :
                                                     (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[4:3]           :
                                                                                 INSTRUCTION13[4:3]            ;
    // [end]   : instruction field }}}
 
// [end]   : Add_Reg_A_Equals_B }}}


//------------------
//-- Y1AddressCmd --
//------------------
// [start] : Y1AddressCmd {{{
    assign ADD_Y1_CMD               = {
                                        1'b0,
                                        EXECUTE_ADD_Y1_CMD_REG1,
                                        EXECUTE_ADD_Y1_CMD_REG0 
                                      };
 
    // [start] : instruction field {{{
    assign NEXT_ADD_Y1_CMD          = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[7:5]            :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[7:5]            :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[7:5]            :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[7:5]            :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[7:5]            :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[7:5]            :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[7:5]            :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[7:5]            :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[7:5]            :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[7:5]            :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[7:5]           :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[7:5]           :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[7:5]           :
                                                                  INSTRUCTION13[7:5]            ;
    // [end]   : instruction field }}}
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN) begin
        EXECUTE_ADD_Y1_CMD_REG1     <= 1'b0;
        EXECUTE_ADD_Y1_CMD_REG0     <= 1'b0;
       end else
       if (RESET_REG_SETUP2) begin
          EXECUTE_ADD_Y1_CMD_REG1   <= INSTRUCTION0[6];
          EXECUTE_ADD_Y1_CMD_REG0   <= INSTRUCTION0[5];
       end else begin 
          if (LAST_TICK & (~BIST_HOLD)) begin
             EXECUTE_ADD_Y1_CMD_REG1              <= NEXT_ADD_Y1_CMD[1];
             EXECUTE_ADD_Y1_CMD_REG0              <= NEXT_ADD_Y1_CMD[0];
          end
       end
    end
// [end]   : Y1AddressCmd }}}


//------------------
//-- X1AddressCmd --
//------------------
// [start] : X1AddressCmd {{{
    assign ADD_X1_CMD               = {
                                        1'b0,
                                        EXECUTE_ADD_X1_CMD_REG1,
                                        EXECUTE_ADD_X1_CMD_REG0 
                                      };
 
    // [start] : instruction field {{{
    assign NEXT_ADD_X1_CMD          = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[10:8]           :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[10:8]           :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[10:8]           :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[10:8]           :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[10:8]           :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[10:8]           :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[10:8]           :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[10:8]           :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[10:8]           :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[10:8]           :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[10:8]          :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[10:8]          :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[10:8]          :
                                                                  INSTRUCTION13[10:8]           ;
    // [end]   : instruction field }}}
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN) begin
        EXECUTE_ADD_X1_CMD_REG1     <= 1'b0;
        EXECUTE_ADD_X1_CMD_REG0     <= 1'b0;
       end else 
       if (RESET_REG_SETUP2) begin
          EXECUTE_ADD_X1_CMD_REG1   <= INSTRUCTION0[9];
          EXECUTE_ADD_X1_CMD_REG0   <= INSTRUCTION0[8];
       end else begin 
          if (LAST_TICK & (~BIST_HOLD)) begin
             EXECUTE_ADD_X1_CMD_REG1              <= NEXT_ADD_X1_CMD[1];
             EXECUTE_ADD_X1_CMD_REG0              <= NEXT_ADD_X1_CMD[0];
          end
       end
    end
// [end]   : X1AddressCmd }}}


//----------------------
//-- AddressSelectCmd --
//----------------------
// [start] : AddressSelectCmd {{{
    assign ADD_REG_SELECT           = {
                                        1'b0,
                                        1'b0,
                                        1'b0 
                                      };
 
    // [start] : instruction field {{{
    assign NEXT_ADD_REG_SELECT      = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[13:11]          :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[13:11]          :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[13:11]          :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[13:11]          :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[13:11]          :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[13:11]          :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[13:11]          :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[13:11]          :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[13:11]          :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[13:11]          :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[13:11]         :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[13:11]         :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[13:11]         :
                                                                  INSTRUCTION13[13:11]          ;
    // [end]   : instruction field }}}
 
// [end]   : AddressSelectCmd }}}


//------------------
//-- WriteDataCmd --
//------------------
// [start] : WriteDataCmd {{{
    assign WDATA_CMD                = {
                                        EXECUTE_WDATA_CMD_REG3,
                                        1'b0,
                                        1'b1,
                                        EXECUTE_WDATA_CMD_REG0 
                                      };
 
    // [start] : instruction field {{{
    assign NEXT_WDATA_CMD           = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[17:14]          :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[17:14]          :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[17:14]          :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[17:14]          :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[17:14]          :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[17:14]          :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[17:14]          :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[17:14]          :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[17:14]          :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[17:14]          :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[17:14]         :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[17:14]         :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[17:14]         :
                                                                  INSTRUCTION13[17:14]          ;
    // [end]   : instruction field }}}
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN) begin
        EXECUTE_WDATA_CMD_REG3      <= 1'b0;
        EXECUTE_WDATA_CMD_REG0      <= 1'b0;
       end else
       if (RESET_REG_SETUP2) begin
          EXECUTE_WDATA_CMD_REG3    <= INSTRUCTION0[17];
          EXECUTE_WDATA_CMD_REG0    <= INSTRUCTION0[14];
       end else begin 
          if (LAST_TICK & (~BIST_HOLD)) begin
             EXECUTE_WDATA_CMD_REG3               <= NEXT_WDATA_CMD[3];
             EXECUTE_WDATA_CMD_REG0               <= NEXT_WDATA_CMD[0];
          end
       end
    end
// [end]   : WriteDataCmd }}}


//-------------------
//-- ExpectDataCmd --
//-------------------
// [start] : ExpectDataCmd {{{
    assign EDATA_CMD                = {
                                        EXECUTE_EDATA_CMD_REG3,
                                        1'b0,
                                        1'b1,
                                        EXECUTE_EDATA_CMD_REG0 
                                      };
 
    // [start] : instruction field {{{
    assign NEXT_EDATA_CMD           = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[21:18]          :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[21:18]          :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[21:18]          :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[21:18]          :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[21:18]          :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[21:18]          :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[21:18]          :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[21:18]          :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[21:18]          :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[21:18]          :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[21:18]         :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[21:18]         :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[21:18]         :
                                                                  INSTRUCTION13[21:18]          ;
    // [end]   : instruction field }}}
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN) begin
        EXECUTE_EDATA_CMD_REG3      <= 1'b0;
        EXECUTE_EDATA_CMD_REG0      <= 1'b0;
       end else
       if (RESET_REG_SETUP2) begin
          EXECUTE_EDATA_CMD_REG3    <= INSTRUCTION0[21];
          EXECUTE_EDATA_CMD_REG0    <= INSTRUCTION0[18];
       end else begin 
          if (LAST_TICK & (~BIST_HOLD)) begin
             EXECUTE_EDATA_CMD_REG3               <= NEXT_EDATA_CMD[3];
             EXECUTE_EDATA_CMD_REG0               <= NEXT_EDATA_CMD[0];
          end
       end
    end
// [end]   : ExpectDataCmd }}}


//-------------
//-- LoopCmd --
//-------------
// [start] : LoopCmd {{{
    assign LOOP_CMD                 = {
                                        1'b0,
                                        EXECUTE_LOOP_CMD_REG0 
                                      };
 
    // [start] : instruction field {{{
    assign NEXT_LOOP_CMD            = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[23:22]          :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[23:22]          :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[23:22]          :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[23:22]          :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[23:22]          :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[23:22]          :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[23:22]          :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[23:22]          :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[23:22]          :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[23:22]          :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[23:22]         :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[23:22]         :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[23:22]         :
                                                                  INSTRUCTION13[23:22]          ;
    // [end]   : instruction field }}}
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN) begin
        EXECUTE_LOOP_CMD_REG0       <= 1'b0;
       end else
       if (RESET_REG_SETUP2) begin
          EXECUTE_LOOP_CMD_REG0     <= INSTRUCTION0[22];
       end else begin 
          if (LAST_TICK & (~BIST_HOLD)) begin
             EXECUTE_LOOP_CMD_REG0                <= NEXT_LOOP_CMD[0];
          end
       end
    end
// [end]   : LoopCmd }}}


//------------------------
//-- InhibitDataCompare --
//------------------------
// [start] : InhibitDataCompare {{{
    assign INH_DATA_CMP             = EXECUTE_INH_DATA_CMP_REG0;
 
    // [start] : instruction field {{{
    assign NEXT_INH_DATA_CMP        = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[25:25]          :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[25:25]          :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[25:25]          :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[25:25]          :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[25:25]          :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[25:25]          :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[25:25]          :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[25:25]          :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[25:25]          :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[25:25]          :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[25:25]         :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[25:25]         :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[25:25]         :
                                                                  INSTRUCTION13[25:25]          ;
    // [end]   : instruction field }}}
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN) begin
        EXECUTE_INH_DATA_CMP_REG0   <= 1'b0;
       end else
       if (RESET_REG_SETUP2) begin
          EXECUTE_INH_DATA_CMP_REG0                <= INSTRUCTION0[25];
       end else begin 
          if (LAST_TICK & (~BIST_HOLD)) begin
             EXECUTE_INH_DATA_CMP_REG0            <= NEXT_INH_DATA_CMP;
          end
       end
    end
// [end]   : InhibitDataCompare }}}


//-----------------
//-- CounterACmd --
//-----------------
// [start] : CounterACmd {{{
    assign COUNTERA_CMD             = 1'b0;
 
    // [start] : instruction field {{{
    assign NEXT_COUNTERA_CMD        = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[26:26]          :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[26:26]          :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[26:26]          :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[26:26]          :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[26:26]          :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[26:26]          :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[26:26]          :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[26:26]          :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[26:26]          :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[26:26]          :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[26:26]         :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[26:26]         :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[26:26]         :
                                                                  INSTRUCTION13[26:26]          ;
    // [end]   : instruction field }}}
 
// [end]   : CounterACmd }}}


//-------------------------
//-- BranchToInstruction --
//-------------------------
// [start] : BranchToInstruction {{{
    assign BRANCH_POINTER           = {
                                        EXECUTE_BRANCH_POINTER_REG3,
                                        EXECUTE_BRANCH_POINTER_REG2,
                                        EXECUTE_BRANCH_POINTER_REG1,
                                        EXECUTE_BRANCH_POINTER_REG0 
                                      };
 
    // [start] : instruction field {{{
    assign NEXT_BRANCH_POINTER      = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[30:27]          :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[30:27]          :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[30:27]          :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[30:27]          :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[30:27]          :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[30:27]          :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[30:27]          :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[30:27]          :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[30:27]          :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[30:27]          :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[30:27]         :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[30:27]         :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[30:27]         :
                                                                  INSTRUCTION13[30:27]          ;
    // [end]   : instruction field }}}
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN) begin
        EXECUTE_BRANCH_POINTER_REG3                <= 1'b0;
        EXECUTE_BRANCH_POINTER_REG2                <= 1'b0;
        EXECUTE_BRANCH_POINTER_REG1                <= 1'b0;
        EXECUTE_BRANCH_POINTER_REG0                <= 1'b0;
       end else
       if (RESET_REG_SETUP2) begin
          EXECUTE_BRANCH_POINTER_REG3              <= INSTRUCTION0[30];
          EXECUTE_BRANCH_POINTER_REG2              <= INSTRUCTION0[29];
          EXECUTE_BRANCH_POINTER_REG1              <= INSTRUCTION0[28];
          EXECUTE_BRANCH_POINTER_REG0              <= INSTRUCTION0[27];
       end else begin 
          if (LAST_TICK & (~BIST_HOLD)) begin
             EXECUTE_BRANCH_POINTER_REG3          <= NEXT_BRANCH_POINTER[3];
             EXECUTE_BRANCH_POINTER_REG2          <= NEXT_BRANCH_POINTER[2];
             EXECUTE_BRANCH_POINTER_REG1          <= NEXT_BRANCH_POINTER[1];
             EXECUTE_BRANCH_POINTER_REG0          <= NEXT_BRANCH_POINTER[0];
          end
       end
    end
// [end]   : BranchToInstruction }}}


//--------------------
//-- NextConditions --
//--------------------
// [start] : NextConditions {{{
    assign NEXT_CONDITIONS          = {
                                        EXECUTE_NEXT_CONDITIONS_REG3, // NC0_REPEATLOOP_ENDCOUNT
                                        1'b0, // NC0_COUNTERA_ENDCOUNT
                                        EXECUTE_NEXT_CONDITIONS_REG1, // NC0_X1_ENDCOUNT
                                        EXECUTE_NEXT_CONDITIONS_REG0  // NC0_Y1_ENDCOUNT
                                      };
 
    // [start] : instruction field {{{
    assign NEXT_CONDITIONS_FIELD    = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[34:31]          :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[34:31]          :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[34:31]          :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[34:31]          :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[34:31]          :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[34:31]          :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[34:31]          :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[34:31]          :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[34:31]          :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[34:31]          :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[34:31]         :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[34:31]         :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[34:31]         :
                                                                  INSTRUCTION13[34:31]          ;
    // [end]   : instruction field }}}
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN) begin
        EXECUTE_NEXT_CONDITIONS_REG3               <= 1'b0;
        EXECUTE_NEXT_CONDITIONS_REG1               <= 1'b0;
        EXECUTE_NEXT_CONDITIONS_REG0               <= 1'b0;
       end else        
       if (RESET_REG_SETUP2) begin
          EXECUTE_NEXT_CONDITIONS_REG3             <= INSTRUCTION0[34];
          EXECUTE_NEXT_CONDITIONS_REG1             <= INSTRUCTION0[32];
          EXECUTE_NEXT_CONDITIONS_REG0             <= INSTRUCTION0[31];
       end else begin 
          if (LAST_TICK & (~BIST_HOLD)) begin
             EXECUTE_NEXT_CONDITIONS_REG3         <= NEXT_CONDITIONS_FIELD[3];
             EXECUTE_NEXT_CONDITIONS_REG1         <= NEXT_CONDITIONS_FIELD[1];
             EXECUTE_NEXT_CONDITIONS_REG0         <= NEXT_CONDITIONS_FIELD[0];
          end
       end
    end
// [end]   : NextConditions }}}


//-----------------------------
//-- InhibitLastAddressCount --
//-----------------------------
// [start] : InhibitLastAddressCount {{{
    assign INH_LAST_ADDR_CNT        = (LOOP_STATE_TRUE_INT | NEXT_STATE_TRUE) & EXECUTE_INH_LAST_ADDR_CNT_REG0;
 
    // [start] : instruction field {{{
    assign NEXT_INH_LAST_ADDR_CNT   = (NEXT_POINTER == 4'b0000)  ? INSTRUCTION0[24:24]          :
                                      (NEXT_POINTER == 4'b0001)  ? INSTRUCTION1[24:24]          :
                                      (NEXT_POINTER == 4'b0010)  ? INSTRUCTION2[24:24]          :
                                      (NEXT_POINTER == 4'b0011)  ? INSTRUCTION3[24:24]          :
                                      (NEXT_POINTER == 4'b0100)  ? INSTRUCTION4[24:24]          :
                                      (NEXT_POINTER == 4'b0101)  ? INSTRUCTION5[24:24]          :
                                      (NEXT_POINTER == 4'b0110)  ? INSTRUCTION6[24:24]          :
                                      (NEXT_POINTER == 4'b0111)  ? INSTRUCTION7[24:24]          :
                                      (NEXT_POINTER == 4'b1000)  ? INSTRUCTION8[24:24]          :
                                      (NEXT_POINTER == 4'b1001)  ? INSTRUCTION9[24:24]          :
                                      (NEXT_POINTER == 4'b1010)  ? INSTRUCTION10[24:24]         :
                                      (NEXT_POINTER == 4'b1011)  ? INSTRUCTION11[24:24]         :
                                      (NEXT_POINTER == 4'b1100)  ? INSTRUCTION12[24:24]         :
                                                                  INSTRUCTION13[24:24]          ;
    // [end]   : instruction field }}}
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN) begin
        EXECUTE_INH_LAST_ADDR_CNT_REG0             <= 1'b0;
       end else
       if (RESET_REG_SETUP2) begin
          EXECUTE_INH_LAST_ADDR_CNT_REG0           <= INSTRUCTION0[24];
       end else begin 
          if (LAST_TICK & (~BIST_HOLD)) begin
             EXECUTE_INH_LAST_ADDR_CNT_REG0       <= NEXT_INH_LAST_ADDR_CNT;
          end
       end
    end
// [end]   : InhibitLastAddressCount }}}

    assign LOOP_STATE_TRUE          = LOOP_STATE_TRUE_INT;

//--------------------
//-- LoopConditions --
//--------------------
// [start] : LoopConditions {{{
    assign LOOP_CONDITIONS          = {
                                        1'b0, // NC0_COUNTERA_ENDCOUNT
                                        EXECUTE_NEXT_CONDITIONS_REG1, // NC0_X1_ENDCOUNT
                                        EXECUTE_NEXT_CONDITIONS_REG0  // NC0_Y1_ENDCOUNT
                                      };
 
 
// [end]   : LoopConditions }}}


    assign SO        = INST_POINTER_SO;
 

// NEXT_POINTER persistent buffers {{{
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_NEXT_POINTER0 (
        .a           (NEXT_POINTER_TO_BUF[0]      ),
        .y           (NEXT_POINTER[0]             )
    );    
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_NEXT_POINTER1 (
        .a           (NEXT_POINTER_TO_BUF[1]      ),
        .y           (NEXT_POINTER[1]             )
    );    
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_NEXT_POINTER2 (
        .a           (NEXT_POINTER_TO_BUF[2]      ),
        .y           (NEXT_POINTER[2]             )
    );    
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_NEXT_POINTER3 (
        .a           (NEXT_POINTER_TO_BUF[3]      ),
        .y           (NEXT_POINTER[3]             )
    );    
// NEXT_POINTER persistent buffers }}}
 

 
    assign NEXT_POINTER_TO_BUF = ((ALGO_MODE == 2'b10) & (INST_POINTER == 4'b0000)) ? 4'b0110 :
                          ((ALGO_MODE == 2'b11) & (INST_POINTER == 4'b0000)) ? 4'b1000 :
                          NEXT_POINTER_INT ;
 
    assign NEXT_POINTER_INT         = (NEXT_STATE_TRUE)     ? INC_POINTER(INST_POINTER)         :
                                      (LOOP_STATE_TRUE_INT) ? LOOP_POINTER                      :
                                                              BRANCH_POINTER                    ;
     
    assign NEXT_STATE_TRUE          = (NEXT_CONDITIONS == (NEXT_TRIGGERS & NEXT_CONDITIONS))    ;
     
    assign NEXT_TRIGGERS            = {LOOPCOUNTMAX_TRIGGER,
                                       COUNTERA_ENDCOUNT_TRIGGER,
                                       X1_MINMAX_TRIGGER,
                                       Y1_MINMAX_TRIGGER};   
     
    assign LOOP_STATE_TRUE_INT      = ((NEXT_CONDITIONS[3] == 1'b1)              &&
                                       (LOOP_CONDITIONS == (LOOP_TRIGGERS & LOOP_CONDITIONS)))  ;
     
    assign LOOP_TRIGGERS            = {COUNTERA_ENDCOUNT_TRIGGER,
                                       X1_MINMAX_TRIGGER,
                                       Y1_MINMAX_TRIGGER};   
     
      always @(INST_POINTER or ALGO_MODE or NEXT_STATE_TRUE or BIST_RUN or MEM_RST) begin
          case (ALGO_MODE)
             2'b00: LAST_STATE_INT                 = (MEM_RST) ? BIST_RUN && NEXT_STATE_TRUE && (INST_POINTER == 4'b0101) : BIST_RUN && NEXT_STATE_TRUE && (INST_POINTER == 4'b1101);
             2'b01: LAST_STATE_INT                 = BIST_RUN && NEXT_STATE_TRUE && (INST_POINTER == 4'b0101); 
             2'b10: LAST_STATE_INT                 = BIST_RUN && NEXT_STATE_TRUE && (INST_POINTER == 4'b0111); 
             2'b11: LAST_STATE_INT                 = BIST_RUN && NEXT_STATE_TRUE && (INST_POINTER == 4'b1001); 
          endcase
      end
   
    assign    LAST_STATE =  LAST_STATE_INT;
   
    assign LAST_STATE_DONE          = LAST_STATE_DONE_REG;

//--------------------------
//-- Hardcoded algorithms (1)
//--------------------------
     // Algorithm: SMARCH Instructions: 14 {{{
         // Instruction: INST0_IDLE_PH_1 INST_POINTER: 0 {{{
     assign     INSTRUCTION0_WIRE   = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b0      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b0      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b0000   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0011   ,              // [21:18] ExpectDataCmd
                                        4'b0011   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b000    ,              // [10:8] X1AddressCmd
                                        3'b000    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b000    };             // [2:0] OperationSelect
         // Instruction: INST0_IDLE_PH_1 }}}
         // Instruction: INS1_PH_2 INST_POINTER: 1 {{{
     assign     INSTRUCTION1_WIRE   = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b0      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b0      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b0001   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b1      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0011   ,              // [21:18] ExpectDataCmd
                                        4'b0011   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b000    ,              // [10:8] X1AddressCmd
                                        3'b000    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b011    };             // [2:0] OperationSelect
         // Instruction: INS1_PH_2 }}}
         // Instruction: INS2_PH_2 INST_POINTER: 2 {{{
     assign     INSTRUCTION2_WIRE   = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b0      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b0      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b0010   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0011   ,              // [21:18] ExpectDataCmd
                                        4'b0011   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b000    ,              // [10:8] X1AddressCmd
                                        3'b000    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b011    };             // [2:0] OperationSelect
         // Instruction: INS2_PH_2 }}}
         // Instruction: INS3_PH_3 INST_POINTER: 3 {{{
     assign     INSTRUCTION3_WIRE   = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b0      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b0      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b0011   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0011   ,              // [21:18] ExpectDataCmd
                                        4'b0010   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b000    ,              // [10:8] X1AddressCmd
                                        3'b000    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b011    };             // [2:0] OperationSelect
         // Instruction: INS3_PH_3 }}}
         // Instruction: INS4_PH_3 INST_POINTER: 4 {{{
     assign     INSTRUCTION4_WIRE   = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b0      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b0      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b0100   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0010   ,              // [21:18] ExpectDataCmd
                                        4'b0010   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b010    ,              // [10:8] X1AddressCmd
                                        3'b000    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b010    };             // [2:0] OperationSelect
         // Instruction: INS4_PH_3 }}}
         // Instruction: INS5_PH_4 INST_POINTER: 5 {{{
     assign     INSTRUCTION5_WIRE   = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b1      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b1      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b0101   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0010   ,              // [21:18] ExpectDataCmd
                                        4'b0010   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b010    ,              // [10:8] X1AddressCmd
                                        3'b010    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b001    };             // [2:0] OperationSelect
         // Instruction: INS5_PH_4 }}}
         // Instruction: INS6_PH_5 INST_POINTER: 6 {{{
     assign     INSTRUCTION6_WIRE   = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b0      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b0      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b0110   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0010   ,              // [21:18] ExpectDataCmd
                                        4'b0011   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b000    ,              // [10:8] X1AddressCmd
                                        3'b000    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b011    };             // [2:0] OperationSelect
         // Instruction: INS6_PH_5 }}}
         // Instruction: INS7_PH_5 INST_POINTER: 7 {{{
     assign     INSTRUCTION7_WIRE   = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b1      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b1      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b0110   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0011   ,              // [21:18] ExpectDataCmd
                                        4'b0011   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b010    ,              // [10:8] X1AddressCmd
                                        3'b010    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b011    };             // [2:0] OperationSelect
         // Instruction: INS7_PH_5 }}}
         // Instruction: INS8_PH_6 INST_POINTER: 8 {{{
     assign     INSTRUCTION8_WIRE   = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b0      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b0      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b1000   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0011   ,              // [21:18] ExpectDataCmd
                                        4'b0010   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b000    ,              // [10:8] X1AddressCmd
                                        3'b000    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b011    };             // [2:0] OperationSelect
         // Instruction: INS8_PH_6 }}}
         // Instruction: INS9_PH_6 INST_POINTER: 9 {{{
     assign     INSTRUCTION9_WIRE   = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b1      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b1      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b1000   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b1      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0010   ,              // [21:18] ExpectDataCmd
                                        4'b0010   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b010    ,              // [10:8] X1AddressCmd
                                        3'b010    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b011    };             // [2:0] OperationSelect
         // Instruction: INS9_PH_6 }}}
         // Instruction: INS10_PH_7 INST_POINTER: 10 {{{
     assign     INSTRUCTION10_WIRE                 = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b0      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b0      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b1010   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0010   ,              // [21:18] ExpectDataCmd
                                        4'b0011   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b000    ,              // [10:8] X1AddressCmd
                                        3'b000    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b011    };             // [2:0] OperationSelect
         // Instruction: INS10_PH_7 }}}
         // Instruction: INS11_PH_7 INST_POINTER: 11 {{{
     assign     INSTRUCTION11_WIRE                 = { 1'b1      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b1      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b1      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b1010   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b01     ,              // [23:22] RepeatLoop
                                        4'b0011   ,              // [21:18] ExpectDataCmd
                                        4'b0011   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b011    ,              // [10:8] X1AddressCmd
                                        3'b011    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b010    };             // [2:0] OperationSelect
         // Instruction: INS11_PH_7 }}}
         // Instruction: INS12_PH_9 INST_POINTER: 12 {{{
     assign     INSTRUCTION12_WIRE                 = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b0      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b0      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b1100   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b0010   ,              // [21:18] ExpectDataCmd
                                        4'b1010   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b000    ,              // [10:8] X1AddressCmd
                                        3'b000    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b011    };             // [2:0] OperationSelect
         // Instruction: INS12_PH_9 }}}
         // Instruction: INS13_PH_9 INST_POINTER: 13 {{{
     assign     INSTRUCTION13_WIRE                 = { 1'b0      ,              // [34:34] NextConditions: RepeatLoopEndCount
                                        1'b0      ,              // [33:33] NextConditions: CounterAEndCount
                                        1'b1      ,              // [32:32] NextConditions: X1_EndCount
                                        1'b1      ,              // [31:31] NextConditions: Y1_EndCount
                                        4'b1100   ,              // [30:27] BranchToInstruction
                                        1'b0      ,              // [26:26] CounterACmd
                                        1'b0      ,              // [25:25] InhibitDataCompare
                                        1'b0      ,              // [24:24] InhibitLastAddressCount
                                        2'b00     ,              // [23:22] RepeatLoop
                                        4'b1010   ,              // [21:18] ExpectDataCmd
                                        4'b1010   ,              // [17:14] WriteDataCmd
                                        3'b000    ,              // [13:11] AddressSelectCmd
                                        3'b010    ,              // [10:8] X1AddressCmd
                                        3'b010    ,              // [7:5] Y1AddressCmd
                                        2'b00     ,              // [4:3] Add_Reg_A_Equals_B
                                        3'b010    };             // [2:0] OperationSelect
         // Instruction: INS13_PH_9 }}}
     // Algorithm: SMARCH }}}

//------------------------------------------------
//-- Select hardcoded or softcoded instructions --
//------------------------------------------------
// [start] : hard vs soft code {{{
    assign INSTRUCTION0             =  INSTRUCTION0_WIRE ;           
    assign INSTRUCTION1             =  INSTRUCTION1_WIRE ;           
    assign INSTRUCTION2             =  INSTRUCTION2_WIRE ;           
    assign INSTRUCTION3             =  INSTRUCTION3_WIRE ;           
    assign INSTRUCTION4             =  INSTRUCTION4_WIRE ;           
    assign INSTRUCTION5             =  INSTRUCTION5_WIRE ;           
    assign INSTRUCTION6             =  INSTRUCTION6_WIRE ;           
    assign INSTRUCTION7             =  INSTRUCTION7_WIRE ;           
    assign INSTRUCTION8             =  INSTRUCTION8_WIRE ;           
    assign INSTRUCTION9             =  INSTRUCTION9_WIRE ;           
    assign INSTRUCTION10            =  INSTRUCTION10_WIRE ;           
    assign INSTRUCTION11            =  INSTRUCTION11_WIRE ;           
    assign INSTRUCTION12            =  INSTRUCTION12_WIRE ;           
    assign INSTRUCTION13            =  INSTRUCTION13_WIRE ;           
// [end]   : hard vs soft code }}}

    wire             RESET_REG_SETUP1_BISTON;
    assign RESET_REG_SETUP1_BISTON = RESET_REG_SETUP1|(~BIST_ON);
//synopsys sync_set_reset "RESET_REG_SETUP1_BISTON"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
        LAST_STATE_DONE_REG         <= 1'b0;
       else
       if (RESET_REG_SETUP1_BISTON) begin
          LAST_STATE_DONE_REG       <= 1'b0;
       end else begin 
          if (LAST_TICK & (~BIST_HOLD) & (~LAST_STATE_DONE_REG)) begin
             LAST_STATE_DONE_REG    <= LAST_STATE;
          end
       end
    end
 

    assign INST_POINTER_SI = SI;
    wire INST_POINTER_SYNC_RESET;
    assign INST_POINTER_SYNC_RESET = RESET_REG_SETUP1 | ESOE_RESET;
    // synopsys sync_set_reset "INST_POINTER_SYNC_RESET"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
        INST_POINTER                <= 4'b0000;
       else
       if (INST_POINTER_SYNC_RESET) begin
           INST_POINTER             <= 4'b0000; 
       end else begin
          if (BIST_SHIFT_SHORT) begin
             INST_POINTER           <= {INST_POINTER[2:0], INST_POINTER_SI};
          end else begin
             if (LAST_TICK & (~BIST_HOLD)) begin
                INST_POINTER        <= NEXT_POINTER;
             end
          end
       end
    end

    assign INST_POINTER_SO          = INST_POINTER[3];
 
    function automatic [3:0] INC_POINTER;
    input            [3:0] INST_POINTER;
    reg              TOGGLE;
    integer i;
       begin
          INC_POINTER[0]            = ~INST_POINTER[0];
          TOGGLE     = 1;
          for (i=1; i<=3; i=i+1) begin
             TOGGLE                 = INST_POINTER[i-1] & TOGGLE;
             INC_POINTER[i]         = INST_POINTER[i] ^ TOGGLE;
          end
       end
    endfunction
    
endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_pointer_cntrl
 
/*------------------------------------------------------------------------------
     Module      :  memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_add_format
 
     Description :  This module formats the logical address generated by the  
                    address generator. The address formater currently performs
        only two functions. The first is to drive any padding values
        for multiplexed addresses with unequal row and column 
        address buses.  The second function is to drive forced
        address values.
---------------------------------------------------------------------------- */
 

module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_add_format (
  input  wire [2:0] Y_ADDRESS,
  input  wire [2:0] X_ADDRESS,
  output wire [2:0] COLUMN_ADDRESS,
  output wire [2:0] ROW_ADDRESS
);
 
 
 
 
    assign ROW_ADDRESS             = X_ADDRESS;
 
    assign COLUMN_ADDRESS          = Y_ADDRESS;
 
 
endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_add_format
 
/*------------------------------------------------------------------------------
     Module      :  memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_add_gen
 
     Description :  This module generates the logical address to be applied to  
                    the memory under test.
                    
                    Two address registers are implemented in this architecture.
                    Each of the address registers consists of an X and a Y
                    component (Row and Column component).  Each of the X or Y
                    addresses can be segmented into an X1 and X0 component for
                    the X address or a Y1 and Y0 component for the Y address.
                  
---------------------------------------------------------------------------- */
 
module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_add_gen (
  input wire BIST_CLK,
  input wire BIST_RUN,
  input wire RESET_REG_DEFAULT_MODE,
  input wire BIST_ASYNC_RESETN,
  input wire SI,
  input wire BIST_SHIFT_SHORT,
  input wire BIST_HOLD,
  input wire LAST_TICK,
  input wire MBISTPG_REDUCED_ADDR_CNT_EN,
  input wire  ESOE_RESET,
  input wire  [2:0] ADD_Y1_CMD,
  input wire  [2:0] ADD_X1_CMD,
  input wire  [2:0] ADD_REG_SELECT,
  input wire INH_LAST_ADDR_CNT,
  output wire SO,
  output wire Y1_MINMAX_TRIGGER,
  output wire X1_MINMAX_TRIGGER,
  output wire [2:0] X_ADDRESS,
  output wire [2:0] Y_ADDRESS,
  output wire A_EQUALS_B_TRIGGER
);
    wire    [2:0]    AX_ADD_WIRE, BX_ADD_WIRE;
    reg     [2:0]    AX_ADD_REG;
    reg     [2:0]    BX_ADD_REG;
    wire    [2:0]    AY_ADD_WIRE, BY_ADD_WIRE;
    reg     [2:0]    AY_ADD_REG;
    reg     [2:0]    BY_ADD_REG;
    wire    [2:0]    AX_MASK;   
    wire    [2:0]    BX_MASK;
    wire    [2:0]    AY_MASK;   
    wire    [2:0]    BY_MASK;
    wire   [1:0]     A_SCAN_REGISTER, B_SCAN_REGISTER;
    wire   [1:0]     A_SCAN_WIRE, B_SCAN_WIRE;
    wire   [1:0]     SELECT_REG;
    wire             ENABLE_A_ADD_REG, ENABLE_B_ADD_REG;
    wire             A_ADD_REG_SI, B_ADD_REG_SI;
 
 
    wire             INCY1, DECY1, SETY1MAX, SETY1MIN ;
    wire             INCX1, DECX1, SETX1MAX, SETX1MIN;
 
    wire             ROT_LF_A_ADD_REG, ROT_RT_A_ADD_REG;
    wire             ROT_LF_B_ADD_REG;
 
    wire   [2:0]     Y_R, Y_RP, Y_RCO, Y_RCI;
    reg    [2:0]     NEXT_Y_ADD_COUNT;
    wire   [2:0]     Y_ADD_CNT;
    wire   [2:0]     Y_ADD_CNT_TO_BUF;
    wire   [2:0]     Y_ADD_CNT_MAX, Y_ADD_CNT_MIN;
    wire   [1:0]     Y_ADD_ROT_OUT;
    wire   [1:0]     Y_ADD_ROT_IN_REG;
    wire   [2:0]     X_R, X_RP, X_RCO, X_RCI;
    reg   [2:0]      NEXT_X_ADD_COUNT;
    wire   [2:0]     X_ADD_CNT_TO_BUF;
    wire   [2:0]     X_ADD_CNT;
    wire   [2:0]     X_ADD_CNT_MAX, X_ADD_CNT_MIN;
    wire   [1:0]     X_ADD_ROT_OUT;
    wire   [1:0]     X_ADD_ROT_IN_REG;
    
    wire             Y1_MIN, Y1_MAX;
    wire             Y1_SET_MIN, Y1_SET_MAX;
    wire             Y1_MAX_TRIGGER, Y1_MIN_TRIGGER;
    wire             Y1_MINMAX_TRIGGER_INT;
    wire             Y1_CNT_EN;
 
    wire             X1_MIN, X1_MAX;
    wire             X1_SET_MIN, X1_SET_MAX;
    wire             X1_MAX_TRIGGER, X1_MIN_TRIGGER;
    wire             X1_MINMAX_TRIGGER_INT;
    wire             X1_CNT_EN;
 
 
    wire             Y1_ADD_SEGMENT_LINK;
    wire             Y1_CNT_EN_CONDITIONS;
    wire             Y1_CNT_EN_TRIGGER;
    wire             A_Y1_ADD_SEGMENT_LINK_REG, B_Y1_ADD_SEGMENT_LINK_REG;
    wire             X1_ADD_SEGMENT_LINK;
    wire             X1_CNT_EN_CONDITIONS;
    wire             X1_CNT_EN_TRIGGER;
    wire             A_X1_ADD_SEGMENT_LINK_REG, B_X1_ADD_SEGMENT_LINK_REG;
              
 
    wire             A_SCAN_REGISTER_SI;
    wire             B_SCAN_REGISTER_SI;
    wire             A_SCAN_REGISTER_SO;
    wire             B_SCAN_REGISTER_SO;
 
    wire             AX_ROT_RT_OUT_SELECTED;
    wire             AX_ROT_RT_IN_SELECTED;
    reg              AX_ROT_IN_SELECTED;
    reg              BX_ROT_IN_SELECTED;    
    wire   [1:0]     X_ADD_ROT_IN_SELECTED;   
    reg              AX_ROT_OUT_SELECTED;
    reg              BX_ROT_OUT_SELECTED;
    wire   [2:0]     X_ADD_REG_MIN_DEFAULT;
    wire   [2:0]     X_ADD_REG_MAX_DEFAULT;
    wire   [1:0]     X_ADD_ROT_OUT_DEFAULT;  
    wire   [1:0]     X_ADD_ROT_IN_DEFAULT;
    wire             AY_ROT_RT_OUT_SELECTED;
    wire             AY_ROT_RT_IN_SELECTED;
    wire   [1:0]     Y_ADD_ROT_IN_SELECTED; 
    reg              AY_ROT_IN_SELECTED;
    reg              BY_ROT_IN_SELECTED;
    reg              AY_ROT_OUT_SELECTED;
    reg              BY_ROT_OUT_SELECTED;       
    wire   [2:0]     Y_ADD_REG_MIN_DEFAULT;
    wire   [2:0]     Y_ADD_REG_MAX_DEFAULT;
    wire   [1:0]     Y_ADD_ROT_OUT_DEFAULT;
    wire   [1:0]     Y_ADD_ROT_IN_DEFAULT; 
    assign A_ADD_REG_SI             =  (BIST_SHIFT_SHORT) ? SI :
                                                            AX_ADD_REG[2];
    assign B_ADD_REG_SI             =  (BIST_SHIFT_SHORT) ? A_SCAN_REGISTER_SO :
                                                            BX_ADD_REG[2];

    assign SO        = B_SCAN_REGISTER_SO;

    assign X_ADDRESS = (SELECT_REG[1] == 1'b1) ? BX_ADD_REG ^ AX_ADD_REG : X_ADD_CNT_TO_BUF;
    assign Y_ADDRESS = (SELECT_REG[1] == 1'b1) ? BY_ADD_REG ^ AY_ADD_REG : Y_ADD_CNT_TO_BUF;
 
    assign Y1_MINMAX_TRIGGER        = Y1_MINMAX_TRIGGER_INT;
    assign X1_MINMAX_TRIGGER        = X1_MINMAX_TRIGGER_INT;
 
    assign A_EQUALS_B_TRIGGER       = 1'b0;
 
    assign Y1_CNT_EN_CONDITIONS     =Y1_ADD_SEGMENT_LINK;
    assign X1_CNT_EN_CONDITIONS     =X1_ADD_SEGMENT_LINK;
 
    //
    // AddressSelectCmd           Decode
    // ----------------           ------
    // Select_A                   3'b000
    // Select_A_Copy_To_B         3'b001
    // Select_B                   3'b010
    // Select_B_Copy_To_A         3'b011
    // A_Xor_B                    3'b100
    // Select_A_Rotate_B          3'b101
    // Select_B_Rotate_A          3'b110
    // Select_B_RotateRight_A     3'b111
    //
    // 1 enables A xor B
    assign SELECT_REG[1]            = (ADD_REG_SELECT == 3'b100  );
    // 0 selects A; 1 selects B
    assign SELECT_REG[0]            = (ADD_REG_SELECT == 3'b010  ) || 
                                      (ADD_REG_SELECT == 3'b011  ) || 
                                      (ADD_REG_SELECT == 3'b110  ) ||
                                      (ADD_REG_SELECT == 3'b111  ) ;
    assign ENABLE_A_ADD_REG         = (ADD_REG_SELECT == 3'b000  ) || 
                                      (ADD_REG_SELECT == 3'b001  ) || 
                                      (ADD_REG_SELECT == 3'b011  ) || 
                                      (ADD_REG_SELECT == 3'b101  ) || 
                                      (ADD_REG_SELECT == 3'b110  ) ||
                                      (ADD_REG_SELECT == 3'b111  ) ||
                                      (ADD_REG_SELECT == 3'b100  ) ;
    assign ENABLE_B_ADD_REG         = (ADD_REG_SELECT == 3'b001  ) || 
                                      (ADD_REG_SELECT == 3'b010  ) || 
                                      (ADD_REG_SELECT == 3'b011  ) || 
                                      (ADD_REG_SELECT == 3'b101  ) || 
                                      (ADD_REG_SELECT == 3'b110  ) ||
                                      (ADD_REG_SELECT == 3'b111  ) ;
    // Rotate left from LSB to MSB
    assign ROT_LF_A_ADD_REG         = (ADD_REG_SELECT == 3'b110  ) ;
    assign ROT_LF_B_ADD_REG         = (ADD_REG_SELECT == 3'b101  ) ;
    // Rotate right from MSB to LSB
    assign ROT_RT_A_ADD_REG         = (ADD_REG_SELECT == 3'b111  ) ;
    //
    // AddressSegmentCmd          Decode
    // ----------------           ------
    // Hold                       3'b000
    // Increment                  3'b010
    // Decrement                  3'b011
    // LoadMin                    3'b100
    // LoadMax                    3'b101
    //
    assign INCY1     = (ADD_Y1_CMD == 3'b010);
    assign DECY1     = (ADD_Y1_CMD == 3'b011);
    assign SETY1MIN                 = (MBISTPG_REDUCED_ADDR_CNT_EN & Y1_CNT_EN & Y1_MAX) | (ADD_Y1_CMD == 3'b100);
    assign SETY1MAX                 = (MBISTPG_REDUCED_ADDR_CNT_EN & Y1_CNT_EN & Y1_MIN) | (ADD_Y1_CMD == 3'b101); 
    assign INCX1     = (ADD_X1_CMD == 3'b010);
    assign DECX1     = (ADD_X1_CMD == 3'b011);
    assign SETX1MIN                 = (MBISTPG_REDUCED_ADDR_CNT_EN & X1_CNT_EN & X1_MAX) | (ADD_X1_CMD == 3'b100);
    assign SETX1MAX                 = (MBISTPG_REDUCED_ADDR_CNT_EN & X1_CNT_EN & X1_MIN) | (ADD_X1_CMD == 3'b101);
  
//------------------------------
//-- Calculate next Y address --
//------------------------------
    assign Y_R       = Y_ADD_CNT;
 
    assign Y_RP      = (({3{INCY1}} & (~Y_R)) | ({3{DECY1}} & Y_R));
 
    assign Y_RCO     = (Y_RCI | Y_RP) ;
 
    assign Y_RCI     = (~Y1_CNT_EN) ? {3{1'b1}}                                                                :
                                      ({Y_RCO[1:0], 1'b0 })                                     ;
 
    always @ (Y1_SET_MAX or Y1_SET_MIN or Y_ADD_CNT_MAX or Y_ADD_CNT_MIN or Y_ADD_CNT or Y_RCI) begin
        case ({Y1_SET_MAX, Y1_SET_MIN})
        2'b10, 2'b11 : NEXT_Y_ADD_COUNT = Y_ADD_CNT_MAX;
        2'b01        : NEXT_Y_ADD_COUNT = Y_ADD_CNT_MIN; 
        default      : NEXT_Y_ADD_COUNT = (Y_ADD_CNT ^ (~Y_RCI));
        endcase
    end  
//------------------------------
//-- Calculate next X address --
//------------------------------
    assign X_R       = X_ADD_CNT;
 
    assign X_RP      = (({3{INCX1}} & (~X_R)) | ({3{DECX1}} & X_R));
 
    assign X_RCO     = (X_RCI | X_RP) ;
 
    assign X_RCI     = (~X1_CNT_EN) ? {3{1'b1}}                                                                :
                                      ({X_RCO[1:0], 1'b0 })                                     ;
 
    always @ (X1_SET_MAX or X1_SET_MIN or X_ADD_CNT_MAX or X_ADD_CNT_MIN or X_ADD_CNT or X_RCI) begin
        case ({X1_SET_MAX, X1_SET_MIN})
        2'b10, 2'b11 : NEXT_X_ADD_COUNT = X_ADD_CNT_MAX;
        2'b01        : NEXT_X_ADD_COUNT = X_ADD_CNT_MIN; 
        default      : NEXT_X_ADD_COUNT = (X_ADD_CNT ^ (~X_RCI));
        endcase
    end   
 
//---------------------------------
//-- Select the address register --
//---------------------------------
    assign X_ADD_CNT_TO_BUF         =    (SELECT_REG[0] == 1'b1)                 ? BX_ADD_REG                 :
                                                                                   AX_ADD_REG                 ;
  // Instantiate X_ADD_CNT persistent buffers {{{
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_X_ADD_CNT_0 (
        .a           (X_ADD_CNT_TO_BUF[0]),
        .y           (X_ADD_CNT[0])
    );    
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_X_ADD_CNT_1 (
        .a           (X_ADD_CNT_TO_BUF[1]),
        .y           (X_ADD_CNT[1])
    );    
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_X_ADD_CNT_2 (
        .a           (X_ADD_CNT_TO_BUF[2]),
        .y           (X_ADD_CNT[2])
    );    
  // Instantiate X_ADD_CNT persistent buffers }}}
 
    assign Y_ADD_CNT_TO_BUF         =    (SELECT_REG[0] == 1'b1)                 ? BY_ADD_REG                 :
                                                                                   AY_ADD_REG                 ;
  // Instantiate Y_ADD_CNT persistent buffers {{{
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_Y_ADD_CNT_0 (
        .a           (Y_ADD_CNT_TO_BUF[0]),
        .y           (Y_ADD_CNT[0])
    );    
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_Y_ADD_CNT_1 (
        .a           (Y_ADD_CNT_TO_BUF[1]),
        .y           (Y_ADD_CNT[1])
    );    
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_Y_ADD_CNT_2 (
        .a           (Y_ADD_CNT_TO_BUF[2]),
        .y           (Y_ADD_CNT[2])
    );    
  // Instantiate Y_ADD_CNT persistent buffers }}}
 
//--------------------------------------
//-- Select the carry-in & X0Y0 setup --
//--------------------------------------
    assign X1_ADD_SEGMENT_LINK      = (SELECT_REG[0] == 1'b1)     ? B_X1_ADD_SEGMENT_LINK_REG  :
                                                                    A_X1_ADD_SEGMENT_LINK_REG  ;
    assign Y1_ADD_SEGMENT_LINK      = (SELECT_REG[0] == 1'b1)     ? B_Y1_ADD_SEGMENT_LINK_REG  :
                                                                    A_Y1_ADD_SEGMENT_LINK_REG  ;

//----------------------------------------------
// X Address min and max address count values --
//----------------------------------------------
    // Algorithm: SMARCH Type: IC
    assign X_ADD_REG_MIN_DEFAULT    = 3'b000;
      
    assign X_ADD_CNT_MIN            = X_ADD_REG_MIN_DEFAULT;
 
    // Algorithm: SMARCH Type: IC
    assign X_ADD_REG_MAX_DEFAULT    = MBISTPG_REDUCED_ADDR_CNT_EN ? 3'b111 : 3'b111;
 
    assign X_ADD_CNT_MAX            = X_ADD_REG_MAX_DEFAULT;
//----------------------------------------
// Select out bit X register            --
//----------------------------------------
    assign X_ADD_ROT_OUT_DEFAULT    = 2'b10;
   
    assign X_ADD_ROT_OUT            = X_ADD_ROT_OUT_DEFAULT; 
     
//------------------------------------------------
// Mux controlled by the X_ADD_ROT_OUT register --
//------------------------------------------------
    always @(X_ADD_ROT_OUT or AX_ADD_REG or BX_ADD_REG ) begin
    case (X_ADD_ROT_OUT) 
     2'b00 : begin
                     AX_ROT_OUT_SELECTED = AX_ADD_REG[0:0];
                     BX_ROT_OUT_SELECTED = BX_ADD_REG[0:0];
              end
     2'b01 : begin
                     AX_ROT_OUT_SELECTED = AX_ADD_REG[1:1];
                     BX_ROT_OUT_SELECTED = BX_ADD_REG[1:1];
              end
     2'b10 : begin
                     AX_ROT_OUT_SELECTED = AX_ADD_REG[2:2];
                     BX_ROT_OUT_SELECTED = BX_ADD_REG[2:2];
              end
    default : begin 
                     AX_ROT_OUT_SELECTED = 1'b0;
                     BX_ROT_OUT_SELECTED = 1'b0;
              end
    endcase
    end   
  
//----------------------------------------
// Select shift in bit X register       --
//----------------------------------------
    assign X_ADD_ROT_IN_DEFAULT     = 2'b00;
   
    assign X_ADD_ROT_IN_REG         = X_ADD_ROT_IN_DEFAULT; 

//-----------------------------------------------------------------
// Mux for AX and BX controlled by the X_ADD_ROT_IN_REG register --
//-----------------------------------------------------------------
    assign X_ADD_ROT_IN_SELECTED = (BIST_RUN) ? X_ADD_ROT_IN_REG : 2'b00 ;
             
    always @(X_ADD_ROT_IN_SELECTED or AX_ROT_OUT_SELECTED    or AY_ROT_OUT_SELECTED     or AY_ADD_REG     ) begin
    case (X_ADD_ROT_IN_SELECTED) 
     2'b00 : begin
                     AX_ROT_IN_SELECTED =     AY_ADD_REG[2] ;
     end
     2'b01 : begin
                     AX_ROT_IN_SELECTED = 1'b0 ;
              end
      2'b10 : begin
                     AX_ROT_IN_SELECTED = AY_ROT_OUT_SELECTED ;
              end        
     2'b11 : begin
                     AX_ROT_IN_SELECTED = AX_ROT_OUT_SELECTED ;
              end
       endcase
    end   
 
    always @(X_ADD_ROT_IN_SELECTED or BX_ROT_OUT_SELECTED    or BY_ROT_OUT_SELECTED     or BY_ADD_REG     ) begin
    case (X_ADD_ROT_IN_SELECTED) 
     2'b00 : begin
                     BX_ROT_IN_SELECTED =     BY_ADD_REG[2] ;
           end
     2'b01 : begin
                     BX_ROT_IN_SELECTED = 1'b0 ;
              end
      2'b10 : begin
                     BX_ROT_IN_SELECTED = BY_ROT_OUT_SELECTED ;
              end        
     2'b11 : begin
                     BX_ROT_IN_SELECTED = BX_ROT_OUT_SELECTED ;
              end
       endcase
    end   
 
//-----------------------------
// Right rotation on AX only --
//-----------------------------
    assign AX_ROT_RT_IN_SELECTED    = AY_ROT_RT_OUT_SELECTED;
 
    assign AX_ROT_RT_OUT_SELECTED   = AX_ADD_REG[0];

//----------------------------------------------
// Y Address min and max address count values --
//----------------------------------------------
    // Algorithm: SMARCH Type: IC
    assign Y_ADD_REG_MIN_DEFAULT    = 3'b000;
 
    assign Y_ADD_CNT_MIN            = Y_ADD_REG_MIN_DEFAULT;
 
    // Algorithm: SMARCH Type: IC
    assign Y_ADD_REG_MAX_DEFAULT    = MBISTPG_REDUCED_ADDR_CNT_EN ? 3'b111 : 3'b111;
 
    assign Y_ADD_CNT_MAX            = Y_ADD_REG_MAX_DEFAULT;
   
//----------------------------------------
// Select out bit Y register            --
//----------------------------------------
    assign Y_ADD_ROT_OUT_DEFAULT    = 2'b10;
   
    assign Y_ADD_ROT_OUT            = Y_ADD_ROT_OUT_DEFAULT; 
     
//------------------------------------------------
// Mux controlled by the Y_ADD_ROT_OUT register --
//------------------------------------------------
    always @(Y_ADD_ROT_OUT or AY_ADD_REG or BY_ADD_REG ) begin
    case (Y_ADD_ROT_OUT)
     2'b00 : begin
                     AY_ROT_OUT_SELECTED = AY_ADD_REG[0:0];
                     BY_ROT_OUT_SELECTED = BY_ADD_REG[0:0];
              end
     2'b01 : begin
                     AY_ROT_OUT_SELECTED = AY_ADD_REG[1:1];
                     BY_ROT_OUT_SELECTED = BY_ADD_REG[1:1];
              end
     2'b10 : begin
                     AY_ROT_OUT_SELECTED = AY_ADD_REG[2:2];
                     BY_ROT_OUT_SELECTED = BY_ADD_REG[2:2];
              end
    default : begin 
                     AY_ROT_OUT_SELECTED = 1'b0;
                     BY_ROT_OUT_SELECTED = 1'b0;
              end
    endcase
    end   
  
//----------------------------------------
// Select shift in bit Y register       --
//----------------------------------------
    assign Y_ADD_ROT_IN_DEFAULT     = 2'b00;
   
    assign Y_ADD_ROT_IN_REG         = Y_ADD_ROT_IN_DEFAULT; 

//-----------------------------------------------------------------
// Mux for AY and BY controlled by the Y_ADD_ROT_IN_REG register --
//-----------------------------------------------------------------
    assign Y_ADD_ROT_IN_SELECTED = (BIST_RUN) ? Y_ADD_ROT_IN_REG : 2'b00 ;
             
    always @(Y_ADD_ROT_IN_SELECTED or AY_ROT_OUT_SELECTED    or AX_ROT_OUT_SELECTED     or A_ADD_REG_SI     ) begin
    case (Y_ADD_ROT_IN_SELECTED) 
     2'b00 : begin
                     AY_ROT_IN_SELECTED = A_ADD_REG_SI;
              end
     2'b01 : begin
                     AY_ROT_IN_SELECTED = 1'b0 ;
              end
      2'b10 : begin
                     AY_ROT_IN_SELECTED = AY_ROT_OUT_SELECTED ;
              end        
     2'b11 : begin
                     AY_ROT_IN_SELECTED = AX_ROT_OUT_SELECTED ;
              end
       endcase
    end   
 
    always @(Y_ADD_ROT_IN_SELECTED or BY_ROT_OUT_SELECTED    or BX_ROT_OUT_SELECTED     or B_ADD_REG_SI     ) begin
    case (Y_ADD_ROT_IN_SELECTED) 
     2'b00 : begin
                     BY_ROT_IN_SELECTED =     B_ADD_REG_SI;
           end
     2'b01 : begin
                     BY_ROT_IN_SELECTED = 1'b0 ;
              end
      2'b10 : begin
                     BY_ROT_IN_SELECTED = BY_ROT_OUT_SELECTED ;
              end        
     2'b11 : begin
                     BY_ROT_IN_SELECTED = BX_ROT_OUT_SELECTED ;
              end
       endcase
    end   
 
//-----------------------------
// Right rotation on AY only --
//-----------------------------
    assign AY_ROT_RT_IN_SELECTED    = AX_ROT_RT_OUT_SELECTED;
 
    assign AY_ROT_RT_OUT_SELECTED   = AY_ADD_REG[0];
  
//------------------------------------------------
// Address end count triggers and count enables --
//------------------------------------------------
    assign Y1_MIN    = (Y_ADD_CNT == Y_ADD_CNT_MIN);
    assign Y1_MAX    = (Y_ADD_CNT == Y_ADD_CNT_MAX);
 
    assign X1_MIN    = (X_ADD_CNT == X_ADD_CNT_MIN);
    assign X1_MAX    = (X_ADD_CNT == X_ADD_CNT_MAX);
 
    assign Y1_MAX_TRIGGER           = Y1_MAX;
    assign Y1_MIN_TRIGGER           = Y1_MIN;
 
    assign X1_MAX_TRIGGER           = X1_MAX;
    assign X1_MIN_TRIGGER           = X1_MIN;
 
    assign Y1_MINMAX_TRIGGER_INT    = (INCY1 & Y1_MAX_TRIGGER) | (DECY1 & Y1_MIN_TRIGGER);
    assign X1_MINMAX_TRIGGER_INT    = (INCX1 & X1_MAX_TRIGGER) | (DECX1 & X1_MIN_TRIGGER);
 
    assign Y1_CNT_EN_TRIGGER        = {X1_MINMAX_TRIGGER_INT };
    assign X1_CNT_EN_TRIGGER        = {Y1_MINMAX_TRIGGER_INT };
    
    assign Y1_CNT_EN                = (INCY1 | DECY1) & ((Y1_CNT_EN_CONDITIONS & Y1_CNT_EN_TRIGGER) == Y1_CNT_EN_CONDITIONS);
    assign X1_CNT_EN                = (INCX1 | DECX1) & ((X1_CNT_EN_CONDITIONS & X1_CNT_EN_TRIGGER) == X1_CNT_EN_CONDITIONS);
 
//------------------------------------------
// Address set min and set max conditions --
//------------------------------------------
    assign Y1_SET_MIN               = (Y1_CNT_EN & Y1_MAX_TRIGGER & INCY1) | SETY1MIN;
    assign Y1_SET_MAX               = (Y1_CNT_EN & Y1_MIN_TRIGGER & DECY1) | SETY1MAX;
 
    assign X1_SET_MIN               = (X1_CNT_EN & X1_MAX_TRIGGER & INCX1) | SETX1MIN;
    assign X1_SET_MAX               = (X1_CNT_EN & X1_MIN_TRIGGER & DECX1) | SETX1MAX;
 

//------------------------------------
//-- ADDRESS REGISTER A : X SEGMENT --
//------------------------------------
    assign           AX_ADD_WIRE    = 3'b000; // Algorithm: SMARCH
 
    assign AX_MASK   =                      (BIST_SHIFT_SHORT)    ? 3'b111 :
                      (X_ADD_ROT_OUT == 2'b10)     ? 3'b111 :
                      (X_ADD_ROT_OUT == 2'b01)     ? 3'b011 :
                                                                    3'b001; 
 

    // synopsys sync_set_reset "ESOE_RESET"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN)
            AX_ADD_REG              <= 3'b000;
        else
        if (RESET_REG_DEFAULT_MODE)
            AX_ADD_REG              <= AX_ADD_WIRE; 
        else
        if (ESOE_RESET)
            AX_ADD_REG              <= 3'b000;
        else
        if (BIST_SHIFT_SHORT | (LAST_TICK & (~BIST_HOLD) & ROT_LF_A_ADD_REG & BIST_RUN))
            AX_ADD_REG              <= (AX_MASK & {AX_ADD_REG[1:0], AX_ROT_IN_SELECTED}) | ((~AX_MASK) & AX_ADD_REG);
        else
        if (LAST_TICK & (~BIST_HOLD) & ROT_RT_A_ADD_REG & BIST_RUN)
            AX_ADD_REG              <= {AX_ROT_RT_IN_SELECTED, AX_ADD_REG[2:1]};
        else begin
          if ( ENABLE_A_ADD_REG & BIST_RUN & (~BIST_HOLD)) 
              if (LAST_TICK & (~INH_LAST_ADDR_CNT)) begin
                AX_ADD_REG    <= NEXT_X_ADD_COUNT;
              end 
        end
    end 

//------------------------------------
//-- ADDRESS REGISTER A : Y SEGMENT --
//------------------------------------
    assign           AY_ADD_WIRE    = 3'b000; // Algorithm: SMARCH
 
    assign AY_MASK   =                      (BIST_SHIFT_SHORT)    ? 3'b111 :
                      (Y_ADD_ROT_OUT == 2'b10)     ? 3'b111 :
                      (Y_ADD_ROT_OUT == 2'b01)     ? 3'b011 :
                                                                    3'b001;
     

    // synopsys sync_set_reset "ESOE_RESET"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN)
            AY_ADD_REG              <= 3'b000;
        else
        if (RESET_REG_DEFAULT_MODE)
            AY_ADD_REG              <= AY_ADD_WIRE; 
        else
        if (ESOE_RESET)
            AY_ADD_REG              <= 3'b000;
        else
        if (BIST_SHIFT_SHORT | (LAST_TICK & (~BIST_HOLD) & ROT_LF_A_ADD_REG & BIST_RUN))
            AY_ADD_REG              <= (AY_MASK & {AY_ADD_REG[1:0], AY_ROT_IN_SELECTED}) | ((~AY_MASK) & AY_ADD_REG);
        else
        if (LAST_TICK & (~BIST_HOLD) & ROT_RT_A_ADD_REG & BIST_RUN)
            AY_ADD_REG              <= {AY_ROT_RT_IN_SELECTED, AY_ADD_REG[2:1]};
        else begin
          if ( ENABLE_A_ADD_REG & BIST_RUN & (~BIST_HOLD))
              if (LAST_TICK & (~INH_LAST_ADDR_CNT)) begin
                AY_ADD_REG    <= NEXT_Y_ADD_COUNT;
              end 
        end
    end 

//------------------------------------
//-- ADDRESS REGISTER B : X SEGMENT --
//------------------------------------
    assign           BX_ADD_WIRE    = 3'b000; // Algorithm: SMARCH
 
    assign BX_MASK   =                      (BIST_SHIFT_SHORT)    ? 3'b111 :
                      (X_ADD_ROT_OUT == 2'b10)     ? 3'b111 :
                      (X_ADD_ROT_OUT == 2'b01)     ? 3'b011 :
                                                                    3'b001; 
     

    // synopsys sync_set_reset "ESOE_RESET"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN)
            BX_ADD_REG              <= 3'b000;
        else
        if (RESET_REG_DEFAULT_MODE)
            BX_ADD_REG              <= BX_ADD_WIRE; 
        else
        if (ESOE_RESET)
            BX_ADD_REG              <= 3'b000;
        else
        if (BIST_SHIFT_SHORT | (LAST_TICK & (~BIST_HOLD) & ROT_LF_B_ADD_REG & BIST_RUN))
            BX_ADD_REG              <= (BX_MASK & {BX_ADD_REG[1:0], BX_ROT_IN_SELECTED}) | ((~BX_MASK) & BX_ADD_REG);
        else begin
          if ( ENABLE_B_ADD_REG & BIST_RUN & (~BIST_HOLD)) 
              if (LAST_TICK & (~INH_LAST_ADDR_CNT)) begin
                BX_ADD_REG    <= NEXT_X_ADD_COUNT;
              end 
        end
    end 

//------------------------------------
//-- ADDRESS REGISTER B : Y SEGMENT --
//------------------------------------
    assign           BY_ADD_WIRE    = 3'b000; // Algorithm: SMARCH
 
    assign BY_MASK   =                      (BIST_SHIFT_SHORT)    ? 3'b111 :
                      (Y_ADD_ROT_OUT == 2'b10)     ? 3'b111 :
                      (Y_ADD_ROT_OUT == 2'b01)     ? 3'b011 :
                                                                    3'b001;
      

    // synopsys sync_set_reset "ESOE_RESET"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN)
            BY_ADD_REG              <= 3'b000;
        else
        if (RESET_REG_DEFAULT_MODE)
            BY_ADD_REG              <= BY_ADD_WIRE; 
        else
        if (ESOE_RESET)
            BY_ADD_REG              <= 3'b000;
        else
        if (BIST_SHIFT_SHORT | (LAST_TICK & (~BIST_HOLD) & ROT_LF_B_ADD_REG & BIST_RUN))
            BY_ADD_REG              <= (BY_MASK & {BY_ADD_REG[1:0], BY_ROT_IN_SELECTED}) | ((~BY_MASK) & BY_ADD_REG);
        else begin
          if ( ENABLE_B_ADD_REG & BIST_RUN & (~BIST_HOLD))
              if (LAST_TICK & (~INH_LAST_ADDR_CNT)) begin
                BY_ADD_REG    <= NEXT_Y_ADD_COUNT;
              end 
        end 
    end 

//------------------------------------------------
//-- ADDRESS REGISTER A : CARRY-IN & X0Y0 SETUP --
//------------------------------------------------
    assign A_X1_ADD_SEGMENT_LINK_REG               = A_SCAN_REGISTER[0:0];
    assign A_Y1_ADD_SEGMENT_LINK_REG               = A_SCAN_REGISTER[1:1];
    assign A_SCAN_REGISTER_SI       = AX_ADD_REG[2];
    assign A_SCAN_REGISTER_SO       = A_SCAN_REGISTER_SI; 

    assign A_SCAN_WIRE              = {1'b1, 1'b0};

    assign A_SCAN_REGISTER          = A_SCAN_WIRE;         

//------------------------------------------------
//-- ADDRESS REGISTER B : CARRY-IN & X0Y0 SETUP --
//------------------------------------------------
    assign B_X1_ADD_SEGMENT_LINK_REG               = B_SCAN_REGISTER[0:0];
    assign B_Y1_ADD_SEGMENT_LINK_REG               = B_SCAN_REGISTER[1:1];
    assign B_SCAN_REGISTER_SI       = BX_ADD_REG[2];
    assign B_SCAN_REGISTER_SO       = B_SCAN_REGISTER_SI;

    assign B_SCAN_WIRE              = {1'b1, 1'b0};

    assign B_SCAN_REGISTER          = B_SCAN_WIRE;       
endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_add_gen
  
 
/*------------------------------------------------------------------------------
     Module      :  memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_fsm
 
     Description :  This module is a finite state machine used to control the 
                    initialization, setup, and execution of the test. 
---------------------------------------------------------------------------- */
 
module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_fsm (
  input wire BIST_CLK,
  input wire BIST_ON,
  input wire BIST_HOLD_R,
  input wire BYPASS_RUN_STATE,
  input wire BIST_ASYNC_RESETN,
  input wire LAST_STATE_DONE,
  input wire PAUSETOEND_ALGO_MODE,
 
  output wire SETUP_PULSE1,
  output wire SETUP_PULSE2,
  output wire BIST_INIT,
  output wire BIST_RUN,
  output wire BIST_RUN_PIPE,
  output wire BIST_DONE,
  output wire BIST_IDLE_PULSE,
  output wire BIST_IDLE
);

    localparam MAIN_STATE_IDLE                  = 3'b000; // 0
    localparam MAIN_STATE_INIT                  = 3'b001; // 1
    localparam MAIN_STATE_IDLE2                 = 3'b011; // 3
    localparam MAIN_STATE_IDLE3                 = 3'b010; // 2
    localparam MAIN_STATE_SETUP1                = 3'b110; // 6
    localparam MAIN_STATE_SETUP2                = 3'b111; // 7
    localparam MAIN_STATE_RUN                   = 3'b101; // 5
    localparam MAIN_STATE_DONE                  = 3'b100; // 4
    reg    [2:0]     STATE;
    reg    [2:0]     NEXT_STATE;
    reg              RUNTEST_EN;
    reg    [3:0]     RUNTEST_EN_REG;
    reg              INIT;
    reg              SETUP1;
    reg              SETUP2;
    reg              PAUSETOEND_ALGO_MODE_REG;
    wire             RESET;

    //-------------------
    // Main State Machine
    //-------------------

    assign RESET     = ((~BIST_ON) | BIST_HOLD_R) & (~PAUSETOEND_ALGO_MODE_REG);
 
    assign BIST_IDLE                = (STATE == MAIN_STATE_IDLE);
    assign BIST_IDLE_PULSE          = (~RESET) & BIST_IDLE;
 
    assign BIST_INIT                = INIT;
 
    assign SETUP_PULSE1             = SETUP1;
 
    assign SETUP_PULSE2             = SETUP2;
 
    assign BIST_RUN                 = RUNTEST_EN;
 
    assign BIST_RUN_PIPE            = RUNTEST_EN_REG[3];
 
    assign BIST_DONE                = (STATE == MAIN_STATE_DONE) & (~BIST_RUN_PIPE);

    // synopsys sync_set_reset "RESET"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN)
            STATE    <= MAIN_STATE_IDLE;
        else
        if (RESET)
            STATE    <= MAIN_STATE_IDLE;
        else
        if (~BIST_HOLD_R)
            STATE    <= NEXT_STATE;
    end
  
    always @ (STATE or BYPASS_RUN_STATE or LAST_STATE_DONE ) begin
       case (STATE)
          MAIN_STATE_IDLE:
             begin
                NEXT_STATE                         = MAIN_STATE_INIT;
                INIT                               = 1'b0;
                SETUP1                             = 1'b0;
                SETUP2                             = 1'b0;
                RUNTEST_EN                         = 1'b0;
             end
          MAIN_STATE_INIT:
             begin
                NEXT_STATE                         = MAIN_STATE_IDLE2;
                INIT                               = 1'b1;
                SETUP1                             = 1'b0;
                SETUP2                             = 1'b0;
                RUNTEST_EN                         = 1'b0;
             end
          MAIN_STATE_IDLE2:
              begin
                NEXT_STATE                         = MAIN_STATE_IDLE3;
                INIT                               = 1'b0;
                SETUP1                             = 1'b0;
                SETUP2                             = 1'b0;
                RUNTEST_EN                         = 1'b0;
              end
          MAIN_STATE_IDLE3:
              begin
                NEXT_STATE                         = MAIN_STATE_SETUP1;
                INIT                               = 1'b0;
                SETUP1                             = 1'b0;
                SETUP2                             = 1'b0;
                RUNTEST_EN                         = 1'b0;
              end
          MAIN_STATE_SETUP1:
             begin
                NEXT_STATE                         = MAIN_STATE_SETUP2;
                INIT                               = 1'b0;
                SETUP1                             = 1'b1;
                SETUP2                             = 1'b0;
                RUNTEST_EN                         = 1'b0;
             end
          MAIN_STATE_SETUP2:
             begin
                if (BYPASS_RUN_STATE) begin
                   NEXT_STATE                      = MAIN_STATE_DONE;
                end else begin
                   NEXT_STATE                      = MAIN_STATE_RUN;
                end
                INIT                               = 1'b0;
                SETUP1                             = 1'b0;
                SETUP2                             = 1'b1;
                RUNTEST_EN                         = 1'b0;
             end
          MAIN_STATE_RUN:
             begin
                INIT                               = 1'b0;
                SETUP1                             = 1'b0;
                SETUP2                             = 1'b0;
                RUNTEST_EN                         = 1'b1;
                if (LAST_STATE_DONE) begin
                   NEXT_STATE                      = MAIN_STATE_DONE;
                end
                else begin
                   NEXT_STATE = MAIN_STATE_RUN;
                end
             end
          MAIN_STATE_DONE:
             begin
                NEXT_STATE                         = MAIN_STATE_DONE;
                INIT                               = 1'b0;
                SETUP1                             = 1'b0;
                SETUP2                             = 1'b0;
                RUNTEST_EN                         = 1'b0;
             end
       endcase
    end
 
    // synopsys sync_set_reset "RESET"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN)
            RUNTEST_EN_REG          <= 4'd0;
        else
        if (RESET)
            RUNTEST_EN_REG          <= 4'd0;
        else
        if (~BIST_HOLD_R)
            RUNTEST_EN_REG          <= {RUNTEST_EN_REG[2:0], RUNTEST_EN};
    end
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
        PAUSETOEND_ALGO_MODE_REG <= 1'b0;
        else
       if ((~BIST_ON) & (~BIST_DONE)) begin
          PAUSETOEND_ALGO_MODE_REG <= 1'b0;
       end else begin
          PAUSETOEND_ALGO_MODE_REG <= PAUSETOEND_ALGO_MODE;
       end  
    end 
 
endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_fsm
 
/*------------------------------------------------------------------------------
     Module      :  memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_signal_gen
 
     Description :  
---------------------------------------------------------------------------- */
 
module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_signal_gen (
  input wire  BIST_CLK,
  input wire  BIST_ASYNC_RESETN,
  input wire  LV_TM,
  input wire  MEM_BYPASS_EN,
  input wire  SI,
  input wire  BIST_SHIFT_SHORT,
  input wire  BIST_HOLD_R_INT,
  input wire  RESET_REG_DEFAULT_MODE,
  input wire [2:0] OP_SELECT_CMD,
     
  input wire  BIST_RUN,
  input wire  BIST_RUN_TO_BUF,
  input wire  BIST_RUN_BUF,
  input wire  LAST_STATE_DONE,
 
  input wire BIST_ALGO_SEL_CNT, 
  output wire  LAST_TICK,
  output wire  BIST_CMP,
  output wire  BIST_WRITEENABLE,
  output wire  BIST_OUTPUTENABLE,
  output wire  BIST_SELECT,
  output wire SO
);
    reg              LAST_TICK_REG;
    wire             OPERATION_LAST_TICK_REG;
 
    reg  [2:0]       JCNT;
 
    wire  [5:0]      JCNT_FROM, JCNT_TO;
    wire             JCNT_SI;
    wire             JCNT_SO;
    wire              RESET_JCNT;
    wire              RESET_LAST_TICK_REG;
 
    wire              LAST_TICK_D;
    wire              LAST_OPERATION_DONE;

    //----------------
    // Last cycle flag
    //----------------
    // Last cycle flag {{{
    wire              DEFAULT_LAST_TICK;
    wire              DEFAULT_SYNC_LAST_TICK;
    // Last cycle flag }}}


    //-----------------------------
    // WRITEENABLE waveform
    //-----------------------------
    wire              DEFAULT_WRITEENABLE;
    wire              DEFAULT_WRITEENABLE_SELECTED;
    // OperationSet: SYNC {{{
    wire              DEFAULT_SYNC_NOOPERATION_WRITEENABLE;
    wire              DEFAULT_SYNC_WRITE_WRITEENABLE;
    wire              DEFAULT_SYNC_READ_WRITEENABLE;
    wire              DEFAULT_SYNC_READMODIFYWRITE_WRITEENABLE;
    wire              DEFAULT_SYNC_WRITEREAD_WRITEENABLE;
    // OperationSet: SYNC }}}

    //-----------------------------
    // OUTPUTENABLE waveform
    //-----------------------------
    wire              DEFAULT_OUTPUTENABLE;
    wire              DEFAULT_OUTPUTENABLE_SELECTED;
    // OperationSet: SYNC {{{
    wire              DEFAULT_SYNC_NOOPERATION_OUTPUTENABLE;
    wire              DEFAULT_SYNC_WRITE_OUTPUTENABLE;
    wire              DEFAULT_SYNC_READ_OUTPUTENABLE;
    wire              DEFAULT_SYNC_READMODIFYWRITE_OUTPUTENABLE;
    wire              DEFAULT_SYNC_WRITEREAD_OUTPUTENABLE;
    // OperationSet: SYNC }}}

    //-----------------------------
    // SELECT waveform
    //-----------------------------
    wire              DEFAULT_SELECT;
    wire              DEFAULT_SELECT_SELECTED;
    // OperationSet: SYNC {{{
    wire              DEFAULT_SYNC_NOOPERATION_SELECT;
    wire              DEFAULT_SYNC_WRITE_SELECT;
    wire              DEFAULT_SYNC_READ_SELECT;
    wire              DEFAULT_SYNC_READMODIFYWRITE_SELECT;
    wire              DEFAULT_SYNC_WRITEREAD_SELECT;
    // OperationSet: SYNC }}}

    //-----------------
    // Compare waveform
    //-----------------
    wire              DEFAULT_STROBEDATAOUT;
    wire              DEFAULT_STROBEDATAOUT_SELECTED;
    // OperationSet: SYNC {{{
    wire              DEFAULT_SYNC_NOOPERATION_STROBEDATAOUT;
    wire              DEFAULT_SYNC_NOOPERATION_STROBEDATAOUT0;
    wire              DEFAULT_SYNC_WRITE_STROBEDATAOUT;
    wire              DEFAULT_SYNC_WRITE_STROBEDATAOUT0;
    wire              DEFAULT_SYNC_READ_STROBEDATAOUT;
    wire              DEFAULT_SYNC_READ_STROBEDATAOUT0;
    wire              DEFAULT_SYNC_READMODIFYWRITE_STROBEDATAOUT;
    wire              DEFAULT_SYNC_READMODIFYWRITE_STROBEDATAOUT0;
    wire              DEFAULT_SYNC_WRITEREAD_STROBEDATAOUT;
    wire              DEFAULT_SYNC_WRITEREAD_STROBEDATAOUT0;
    // OperationSet: SYNC }}}

    wire             BIST_WRITEENABLE_BIT0_EN;
    wire             BIST_OUTPUTENABLE_BIT0_EN;
    wire             BIST_SELECT_BIT0_EN;
    
    wire [4:0]       OP_SELECT_DECODED_INT;
    
    wire             SIGNAL_GEN_ENABLE;
    wire             SIGNAL_GEN_HOLD;
    wire             OPSET_SELECT_REG_SI;
   
    reg              OPSET_SELECT_REG;
    wire              OPSET_SELECT_WIRE;     
 
     

    //----------
    // Main Code
    //----------
        
    assign LAST_TICK                = (LAST_TICK_REG);
 
 
    assign SO                       = OPSET_SELECT_REG;

    assign SIGNAL_GEN_ENABLE        = BIST_RUN;
    assign SIGNAL_GEN_HOLD          = BIST_HOLD_R_INT;
    assign LAST_OPERATION_DONE      = LAST_STATE_DONE;

    //----------------
    // Johnson Counter
    //----------------
    assign RESET_JCNT               = (OPERATION_LAST_TICK_REG | LAST_OPERATION_DONE | (~SIGNAL_GEN_ENABLE)) & (~BIST_HOLD_R_INT);
    assign JCNT_SI   = SI;
    //synopsys sync_set_reset "RESET_JCNT"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN)
            JCNT     <= 3'b000;
        else
        if (BIST_SHIFT_SHORT) begin 
            JCNT     <= {JCNT[1:0], JCNT_SI};
        end else
        if (RESET_JCNT) begin
            JCNT     <= 3'b000;
        end
        else if ((~SIGNAL_GEN_HOLD) ) begin
            JCNT     <= {JCNT[1:0],~JCNT[2]};
        end
    end
    assign JCNT_SO   = JCNT[2];
 
    assign JCNT_FROM                = {~JCNT[1:0], JCNT, ~JCNT[2]};
    assign JCNT_TO                  = {JCNT, ~JCNT};
    
    //------------------
    // Johnson Counter_B
    //------------------
 
       assign OP_SELECT_DECODED_INT[4]            = (OP_SELECT_CMD == 3'b100);
       assign OP_SELECT_DECODED_INT[3]            = (OP_SELECT_CMD == 3'b011);
       assign OP_SELECT_DECODED_INT[2]            = (OP_SELECT_CMD == 3'b010);
       assign OP_SELECT_DECODED_INT[1]            = (OP_SELECT_CMD == 3'b001);
       assign OP_SELECT_DECODED_INT[0]            = (OP_SELECT_CMD == 3'b000);

    //---------------------------------------------
    // Generate Signal WRITEENABLE
    //---------------------------------------------
    // OperationSet: SYNC {{{
    assign DEFAULT_SYNC_NOOPERATION_WRITEENABLE = 1'b0;
    assign DEFAULT_SYNC_WRITE_WRITEENABLE = 1'b1;
    assign DEFAULT_SYNC_READ_WRITEENABLE = 1'b0;
    assign DEFAULT_SYNC_READMODIFYWRITE_WRITEENABLE =
                     (JCNT_FROM[1] & JCNT_TO[1]);
    assign DEFAULT_SYNC_WRITEREAD_WRITEENABLE =
                     (JCNT_FROM[0] & JCNT_TO[0]);
    // OperationSet: SYNC }}}
 
    assign DEFAULT_WRITEENABLE = ((~LAST_STATE_DONE) & BIST_RUN) & (
                                        (DEFAULT_SYNC_NOOPERATION_WRITEENABLE   & OP_SELECT_DECODED_INT[0] ) |
                                        (DEFAULT_SYNC_WRITE_WRITEENABLE         & OP_SELECT_DECODED_INT[1] ) |
                                        (DEFAULT_SYNC_READ_WRITEENABLE          & OP_SELECT_DECODED_INT[2] ) |
                                        (DEFAULT_SYNC_READMODIFYWRITE_WRITEENABLE              & OP_SELECT_DECODED_INT[3] ) |
                                        (DEFAULT_SYNC_WRITEREAD_WRITEENABLE     & OP_SELECT_DECODED_INT[4] ));
    assign DEFAULT_WRITEENABLE_SELECTED = DEFAULT_WRITEENABLE;
 

    //---------------------------------------------
    // Generate Signal OUTPUTENABLE
    //---------------------------------------------
    // OperationSet: SYNC {{{
    assign DEFAULT_SYNC_NOOPERATION_OUTPUTENABLE = 1'b1;
    assign DEFAULT_SYNC_WRITE_OUTPUTENABLE = 1'b1;
    assign DEFAULT_SYNC_READ_OUTPUTENABLE = 1'b1;
    assign DEFAULT_SYNC_READMODIFYWRITE_OUTPUTENABLE = 1'b1;
    assign DEFAULT_SYNC_WRITEREAD_OUTPUTENABLE = 1'b1;
    // OperationSet: SYNC }}}
 
    assign DEFAULT_OUTPUTENABLE = ((~LAST_STATE_DONE) & BIST_RUN) & (
                                        (DEFAULT_SYNC_NOOPERATION_OUTPUTENABLE  & OP_SELECT_DECODED_INT[0] ) |
                                        (DEFAULT_SYNC_WRITE_OUTPUTENABLE        & OP_SELECT_DECODED_INT[1] ) |
                                        (DEFAULT_SYNC_READ_OUTPUTENABLE         & OP_SELECT_DECODED_INT[2] ) |
                                        (DEFAULT_SYNC_READMODIFYWRITE_OUTPUTENABLE             & OP_SELECT_DECODED_INT[3] ) |
                                        (DEFAULT_SYNC_WRITEREAD_OUTPUTENABLE    & OP_SELECT_DECODED_INT[4] ));
    assign DEFAULT_OUTPUTENABLE_SELECTED = DEFAULT_OUTPUTENABLE;
 

    //---------------------------------------------
    // Generate Signal SELECT
    //---------------------------------------------
    // OperationSet: SYNC {{{
    assign DEFAULT_SYNC_NOOPERATION_SELECT = 1'b1;
    assign DEFAULT_SYNC_WRITE_SELECT = 1'b1;
    assign DEFAULT_SYNC_READ_SELECT = 1'b1;
    assign DEFAULT_SYNC_READMODIFYWRITE_SELECT = 1'b1;
    assign DEFAULT_SYNC_WRITEREAD_SELECT = 1'b1;
    // OperationSet: SYNC }}}
 
    assign DEFAULT_SELECT = ((~LAST_STATE_DONE) & BIST_RUN_TO_BUF) & (
                                        (DEFAULT_SYNC_NOOPERATION_SELECT        & OP_SELECT_DECODED_INT[0] ) |
                                        (DEFAULT_SYNC_WRITE_SELECT              & OP_SELECT_DECODED_INT[1] ) |
                                        (DEFAULT_SYNC_READ_SELECT               & OP_SELECT_DECODED_INT[2] ) |
                                        (DEFAULT_SYNC_READMODIFYWRITE_SELECT    & OP_SELECT_DECODED_INT[3] ) |
                                        (DEFAULT_SYNC_WRITEREAD_SELECT          & OP_SELECT_DECODED_INT[4] ));
    assign DEFAULT_SELECT_SELECTED = DEFAULT_SELECT;
 
 
 
    //-------------------------------------------------------
    // Generate Signal STROBEDATAOUT0
    //-------------------------------------------------------
    // OperationSet: SYNC {{{
 
    assign DEFAULT_SYNC_NOOPERATION_STROBEDATAOUT0 = 1'b0;
 
    assign DEFAULT_SYNC_WRITE_STROBEDATAOUT0 = 1'b0;
 
    assign DEFAULT_SYNC_READ_STROBEDATAOUT0 =
                     (JCNT_FROM[1] & JCNT_TO[1]);
 
    assign DEFAULT_SYNC_READMODIFYWRITE_STROBEDATAOUT0 =
                     (JCNT_FROM[1] & JCNT_TO[1]);
 
    assign DEFAULT_SYNC_WRITEREAD_STROBEDATAOUT0 = 1'b0;
    // OperationSet: SYNC }}}
 
    //---------------------------------------------------------------------------------
    // Generate Merged Signal STROBEDATAOUT with selective enabling
    //---------------------------------------------------------------------------------
    // OperationSet: SYNC {{{
    assign DEFAULT_SYNC_NOOPERATION_STROBEDATAOUT =
                     (DEFAULT_SYNC_NOOPERATION_STROBEDATAOUT0);
    assign DEFAULT_SYNC_WRITE_STROBEDATAOUT =
                     (DEFAULT_SYNC_WRITE_STROBEDATAOUT0);
    assign DEFAULT_SYNC_READ_STROBEDATAOUT =
                     (DEFAULT_SYNC_READ_STROBEDATAOUT0);
    assign DEFAULT_SYNC_READMODIFYWRITE_STROBEDATAOUT =
                     (DEFAULT_SYNC_READMODIFYWRITE_STROBEDATAOUT0);
    assign DEFAULT_SYNC_WRITEREAD_STROBEDATAOUT =
                     (DEFAULT_SYNC_WRITEREAD_STROBEDATAOUT0);
    // OperationSet: SYNC }}}
 
    assign DEFAULT_STROBEDATAOUT = ((~LAST_STATE_DONE) & BIST_RUN) & (
                                        (DEFAULT_SYNC_NOOPERATION_STROBEDATAOUT                & OP_SELECT_DECODED_INT[0] ) |
                                        (DEFAULT_SYNC_WRITE_STROBEDATAOUT       & OP_SELECT_DECODED_INT[1] ) |
                                        (DEFAULT_SYNC_READ_STROBEDATAOUT        & OP_SELECT_DECODED_INT[2] ) |
                                        (DEFAULT_SYNC_READMODIFYWRITE_STROBEDATAOUT            & OP_SELECT_DECODED_INT[3] ) |
                                        (DEFAULT_SYNC_WRITEREAD_STROBEDATAOUT   & OP_SELECT_DECODED_INT[4] ));
 
 
    assign DEFAULT_STROBEDATAOUT_SELECTED =  DEFAULT_STROBEDATAOUT;
 
 
    //---------------
    // Signal mapping
    //---------------
    assign BIST_WRITEENABLE =
           (BIST_WRITEENABLE_BIT0_EN) & DEFAULT_WRITEENABLE_SELECTED ;
    assign BIST_OUTPUTENABLE =
           (BIST_OUTPUTENABLE_BIT0_EN) & DEFAULT_OUTPUTENABLE_SELECTED ;
    assign BIST_SELECT =
           (BIST_SELECT_BIT0_EN) & DEFAULT_SELECT_SELECTED ;
 
    assign BIST_CMP = ((~LV_TM)|MEM_BYPASS_EN)&DEFAULT_STROBEDATAOUT_SELECTED ;
 
    //-------------------
    // Address decoding 
    //-------------------
       
    assign BIST_WRITEENABLE_BIT0_EN = 
                                  1'b1;
       
    assign BIST_OUTPUTENABLE_BIT0_EN = 
                                  1'b1;
       
    assign BIST_SELECT_BIT0_EN = 
                                  1'b1;
      
    //-----------------
    // OPFAM#_OPSET_SEL
    //-----------------
    
    
      
    //-------------------
    // Generate LAST_TICK
    //-------------------
    // OperationSet: SYNC {{{
    assign DEFAULT_SYNC_LAST_TICK =
                           ((JCNT_FROM[2] & JCNT_TO[2]) | (~OP_SELECT_DECODED_INT[0])) &
                           ((JCNT_FROM[0] & JCNT_TO[0]) | (~OP_SELECT_DECODED_INT[1])) &
                           ((JCNT_FROM[0] & JCNT_TO[0]) | (~OP_SELECT_DECODED_INT[2])) &
                           ((JCNT_FROM[0] & JCNT_TO[0]) | (~OP_SELECT_DECODED_INT[3])) &
                           ((JCNT_FROM[0] & JCNT_TO[0]) | (~OP_SELECT_DECODED_INT[4]));
    // OperationSet: SYNC }}}
       
    assign DEFAULT_LAST_TICK = DEFAULT_SYNC_LAST_TICK;
        
        
      
    assign RESET_LAST_TICK_REG      = ~SIGNAL_GEN_ENABLE;
    //-----------------------
    // LAST_TICK_D
    //-----------------------
    assign LAST_TICK_D = DEFAULT_LAST_TICK;
   
   
    //-------------------------
    // LAST_TICK_REG
    //-------------------------
    //synopsys sync_set_reset "RESET_LAST_TICK_REG"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
            LAST_TICK_REG <= 1'b0;
       else
        if (RESET_LAST_TICK_REG) begin
            LAST_TICK_REG <= 1'b0;
        end else begin
           if (~SIGNAL_GEN_HOLD) begin
              LAST_TICK_REG <= (~LAST_OPERATION_DONE) & (~LAST_TICK_REG) & LAST_TICK_D ;
           end
        end
    end
    
    
    assign OPERATION_LAST_TICK_REG = LAST_TICK_REG;
    assign OPSET_SELECT_REG_SI = JCNT_SO;
  
    //--------------------------
    // OPERATION SELECT REGISTER
    //--------------------------
    assign OPSET_SELECT_WIRE = 1'b0; // OperationSet: SYNC

    // synopsys async_set_reset "BIST_ASYNC_RESETN"
     always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
             OPSET_SELECT_REG <= 1'b0;
       else
        if (RESET_REG_DEFAULT_MODE & BIST_ALGO_SEL_CNT) begin 
          OPSET_SELECT_REG <=  OPSET_SELECT_WIRE ;
        end
        else begin
          if (BIST_SHIFT_SHORT) begin
             OPSET_SELECT_REG <= OPSET_SELECT_REG_SI;
          end
        end          
      end  
  
endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_signal_gen
     
/*------------------------------------------------------------------------------
     Module      :  memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_repeat_loop_cntrl
 
     Description :  This module contains logic used to re-execute previously 
                    specified instructions with modified address, write data,
                    and/or expect data.
---------------------------------------------------------------------------- */
 
module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_repeat_loop_cntrl (
  input wire BIST_CLK,
  input wire RESET_REG_SETUP1,
  input wire RESET_REG_DEFAULT_MODE,
  input wire  [1:0] LOOP_CMD,
  input wire BIST_ASYNC_RESETN,
  input wire  [2:0] ADD_Y1_CMD,
  input wire  [2:0] ADD_X1_CMD,
  input wire  [3:0] WDATA_CMD,
  input wire  [3:0] EDATA_CMD,
  input wire INH_LAST_ADDR_CNT,
  input wire INH_DATA_CMP,
  input wire LOOP_STATE_TRUE,
  input wire  [1:0] A_EQUALS_B_INVERT_DATA,
  input wire A_EQUALS_B_TRIGGER,
  input wire SI,
  input wire BIST_HOLD,
  input wire LAST_TICK,
  input wire BIST_SHIFT_SHORT,
  input wire BIST_RUN,
  input wire  ESOE_RESET,
  output wire LOOPCOUNTMAX_TRIGGER,
  output wire [3:0] LOOP_POINTER,
  output wire [2:0] ADD_Y1_CMD_MODIFIED,
  output wire [2:0] ADD_X1_CMD_MODIFIED,
  output wire [3:0] WDATA_CMD_MODIFIED,
  output wire [3:0] EDATA_CMD_MODIFIED,
  output wire INH_LAST_ADDR_CNT_MODIFIED,
  output wire INH_DATA_CMP_MODIFIED,
  output wire SO
);
    reg    [1:0]     LOOP_A_CNTR;
    reg    [1:0]     LOOP_B_CNTR;
    wire             LOOP_A_CNTR_SI;
    wire             LOOP_A_CNTR_SO;
    wire             LOOP_B_CNTR_SI;
    wire             LOOP_B_CNTR_SO;
    
    wire   [1:0]     CNTR_A_MAX_REG;   
    wire   [3:0]     CNTR_A_LOOP_POINTER_REG;
    wire   [4:0]     CNTR_A_LOOP1_REG;
    wire   [4:0]     CNTR_A_LOOP2_REG;
    wire   [4:0]     CNTR_A_LOOP3_REG;
    wire   [1:0]     CNTR_B_MAX_REG;  
    wire   [3:0]     CNTR_B_LOOP_POINTER_REG;
    wire   [4:0]     CNTR_B_LOOP1_REG;
    wire   [4:0]     CNTR_B_LOOP2_REG;
    wire   [4:0]     CNTR_B_LOOP3_REG;
    wire   [1:0]     CNTR_A_MAX_WIRE;
    wire   [3:0]     CNTR_A_LOOP_POINTER_WIRE;
    wire   [4:0]     CNTR_A_LOOP1_WIRE;
    wire   [4:0]     CNTR_A_LOOP2_WIRE;
    wire   [4:0]     CNTR_A_LOOP3_WIRE;
    wire   [1:0]     CNTR_B_MAX_WIRE;
    wire   [3:0]     CNTR_B_LOOP_POINTER_WIRE;
    wire   [4:0]     CNTR_B_LOOP1_WIRE;
    wire   [4:0]     CNTR_B_LOOP2_WIRE;
    wire   [4:0]     CNTR_B_LOOP3_WIRE;
    
 
 
    wire             INC_CNTR_A;
    wire             INC_CNTR_B;
    wire             INC_CNTR_BA;
 
    wire             CNTR_A_MAX;
    wire             CNTR_B_MAX;
  
    wire             ENABLE_CNTR_A;
    wire             ENABLE_CNTR_B;
  
    wire             RESET_CNTR_A;
    wire             RESET_CNTR_B;
 
    wire             ADD_SEQUENCE_FLIP;
    wire             WDATA_SEQUENCE_FLIP;
    wire             EDATA_SEQUENCE_FLIP;
    wire             INH_DATA_CMP_NESTED_LOOP_FLIP;
    wire             INH_DATA_CMP_MODIFIED_INT;
 
    wire   [4:0]     CNTR_A_LOOP_REG_SEL;
    wire   [4:0]     CNTR_B_LOOP_REG_SEL;

    assign SO        = LOOP_B_CNTR_SO;
    assign LOOPCOUNTMAX_TRIGGER     = (INC_CNTR_BA & CNTR_A_MAX & CNTR_B_MAX) |
                                      (INC_CNTR_A  & CNTR_A_MAX)              |
                                      (INC_CNTR_B  & CNTR_B_MAX)              ;
 
    assign LOOP_POINTER             = (INC_CNTR_A | (INC_CNTR_BA & (~CNTR_A_MAX))) ? CNTR_A_LOOP_POINTER_REG :
                                                                            CNTR_B_LOOP_POINTER_REG ;
 
    assign INC_CNTR_A               = (LOOP_CMD == 2'b01);
    assign INC_CNTR_B               = (LOOP_CMD == 2'b10);
    assign INC_CNTR_BA              = (LOOP_CMD == 2'b11);
 
    assign RESET_CNTR_A             = (ESOE_RESET | RESET_REG_SETUP1 | ((~BIST_HOLD) & LAST_TICK & LOOP_STATE_TRUE & CNTR_A_MAX & (INC_CNTR_A | INC_CNTR_BA)));
    assign RESET_CNTR_B             = (ESOE_RESET | RESET_REG_SETUP1 | ((~BIST_HOLD) & LAST_TICK & LOOP_STATE_TRUE & ((INC_CNTR_B & CNTR_B_MAX) | (CNTR_A_MAX & CNTR_B_MAX & INC_CNTR_BA))));
 
    assign ENABLE_CNTR_A            = (INC_CNTR_A | INC_CNTR_BA);
    assign ENABLE_CNTR_B            = ((INC_CNTR_BA & CNTR_A_MAX) | (INC_CNTR_B));
 
    assign CNTR_A_MAX               = (LOOP_A_CNTR == CNTR_A_MAX_REG);
    assign CNTR_B_MAX               = (LOOP_B_CNTR == CNTR_B_MAX_REG);
 

    //---------------
    // LOOP COUNTER A
    //---------------
    assign LOOP_A_CNTR_SI = SI;
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
          LOOP_A_CNTR               <= 2'b00;
       else
       if (BIST_SHIFT_SHORT) begin
          LOOP_A_CNTR               <= {LOOP_A_CNTR[0:0],LOOP_A_CNTR_SI};
       end else begin
          if (RESET_CNTR_A) begin
             LOOP_A_CNTR            <= 2'b00;
          end else begin 
             if ((~BIST_HOLD) & BIST_RUN & ENABLE_CNTR_A & LAST_TICK & LOOP_STATE_TRUE) begin
                LOOP_A_CNTR         <= INC_FUNCTION_FOR_CNTR_A(LOOP_A_CNTR);
             end
          end
       end
    end
    assign LOOP_A_CNTR_SO = LOOP_A_CNTR[1];

    //---------------
    // LOOP COUNTER B
    //---------------
    assign LOOP_B_CNTR_SI = LOOP_A_CNTR_SO;
    //synopsys sync_set_reset "RESET_CNTR_B"
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
          LOOP_B_CNTR               <= 2'b00;
       else
       if (BIST_SHIFT_SHORT) begin
          LOOP_B_CNTR               <= {LOOP_B_CNTR[0:0],LOOP_B_CNTR_SI};
       end else begin
          if (RESET_CNTR_B) begin
             LOOP_B_CNTR            <= 2'b00;
          end else begin 
             if ((~BIST_HOLD) & BIST_RUN & ENABLE_CNTR_B & LAST_TICK & LOOP_STATE_TRUE) begin
                LOOP_B_CNTR         <= INC_FUNCTION_FOR_CNTR_B(LOOP_B_CNTR);
             end
          end
       end
    end
    assign LOOP_B_CNTR_SO = LOOP_B_CNTR[1];
 

    assign CNTR_A_LOOP_REG_SEL     = (LOOP_A_CNTR == 2'b00) ? 5'b00000          :
                                     (LOOP_A_CNTR == 2'b01) ? CNTR_A_LOOP1_REG  :
                                     (LOOP_A_CNTR == 2'b10) ? CNTR_A_LOOP2_REG  :
                                                              CNTR_A_LOOP3_REG  ;

    assign CNTR_B_LOOP_REG_SEL     = (LOOP_B_CNTR == 2'b00) ? 5'b00000          :
                                     (LOOP_B_CNTR == 2'b01) ? CNTR_B_LOOP1_REG  :
                                     (LOOP_B_CNTR == 2'b10) ? CNTR_B_LOOP2_REG  :
                                                              CNTR_B_LOOP3_REG  ;

    assign EDATA_SEQUENCE_FLIP                    = CNTR_A_LOOP_REG_SEL[4] ^ CNTR_B_LOOP_REG_SEL[4] ^ (A_EQUALS_B_INVERT_DATA[1] & A_EQUALS_B_TRIGGER);
    assign WDATA_SEQUENCE_FLIP                    = CNTR_A_LOOP_REG_SEL[3] ^ CNTR_B_LOOP_REG_SEL[3] ^ (A_EQUALS_B_INVERT_DATA[0] & A_EQUALS_B_TRIGGER);
    assign ADD_SEQUENCE_FLIP                      = CNTR_A_LOOP_REG_SEL[2] ^ CNTR_B_LOOP_REG_SEL[2];
    assign INH_DATA_CMP_NESTED_LOOP_FLIP          = CNTR_A_LOOP_REG_SEL[0] ^ CNTR_B_LOOP_REG_SEL[0];
 
    assign ADD_Y1_CMD_MODIFIED     = {ADD_Y1_CMD[2:1]            , ADD_Y1_CMD[0] ^ ADD_SEQUENCE_FLIP};
    assign ADD_X1_CMD_MODIFIED     = {ADD_X1_CMD[2:1]            , ADD_X1_CMD[0] ^ ADD_SEQUENCE_FLIP};
 
    assign WDATA_CMD_MODIFIED      = {WDATA_CMD[3:1]             , WDATA_CMD[0] ^ WDATA_SEQUENCE_FLIP}; 
    assign EDATA_CMD_MODIFIED      = {EDATA_CMD[3:1]             , EDATA_CMD[0] ^ EDATA_SEQUENCE_FLIP};
 
    assign INH_LAST_ADDR_CNT_MODIFIED             = (LOOP_STATE_TRUE & ENABLE_CNTR_B & (LOOP_B_CNTR != 2'b00))               ? CNTR_B_LOOP_REG_SEL[1]      :
                                                    (LOOP_STATE_TRUE & ENABLE_CNTR_A & (LOOP_A_CNTR != 2'b00))               ? CNTR_A_LOOP_REG_SEL[1]      :
                                                                                                                 INH_LAST_ADDR_CNT          ;
 
    assign INH_DATA_CMP_MODIFIED_INT              = ((LOOP_B_CNTR != 2'b00) | (LOOP_A_CNTR != 2'b00))         ? INH_DATA_CMP_NESTED_LOOP_FLIP              : 
                                                                                                                   INH_DATA_CMP             ;
    assign INH_DATA_CMP_MODIFIED = INH_DATA_CMP_MODIFIED_INT;
    //-------------------------
    // LOOP COUNTER A REGISTERS
    //-------------------------
    assign CNTR_A_MAX_WIRE         = 2'b01;
    assign CNTR_A_LOOP_POINTER_WIRE               = 4'b1010;
    assign CNTR_A_LOOP1_WIRE[4]    = 1'b1;
    assign CNTR_A_LOOP1_WIRE[3]    = 1'b1;
    assign CNTR_A_LOOP1_WIRE[2]    = 1'b0;
    assign CNTR_A_LOOP1_WIRE[1]    = 1'b1;
    assign CNTR_A_LOOP1_WIRE[0]    = 1'b0;
    assign CNTR_A_LOOP2_WIRE[4]    = 1'b0;
    assign CNTR_A_LOOP2_WIRE[3]    = 1'b0;
    assign CNTR_A_LOOP2_WIRE[2]    = 1'b0;
    assign CNTR_A_LOOP2_WIRE[1]    = 1'b0;
    assign CNTR_A_LOOP2_WIRE[0]    = 1'b0;
    assign CNTR_A_LOOP3_WIRE[4]    = 1'b0;
    assign CNTR_A_LOOP3_WIRE[3]    = 1'b0;
    assign CNTR_A_LOOP3_WIRE[2]    = 1'b0;
    assign CNTR_A_LOOP3_WIRE[1]    = 1'b0;
    assign CNTR_A_LOOP3_WIRE[0]    = 1'b0;
    assign CNTR_A_MAX_REG          = CNTR_A_MAX_WIRE;
    assign CNTR_A_LOOP_POINTER_REG                = CNTR_A_LOOP_POINTER_WIRE;  
    assign CNTR_A_LOOP1_REG[4]     = CNTR_A_LOOP1_WIRE[4]; 
    assign CNTR_A_LOOP1_REG[3]     = CNTR_A_LOOP1_WIRE[3];
    assign CNTR_A_LOOP1_REG[2]     = CNTR_A_LOOP1_WIRE[2]; 
    assign CNTR_A_LOOP1_REG[1]     = CNTR_A_LOOP1_WIRE[1];
    assign CNTR_A_LOOP1_REG[0]     = CNTR_A_LOOP1_WIRE[0];
    assign CNTR_A_LOOP2_REG[4]     = CNTR_A_LOOP2_WIRE[4]; 
    assign CNTR_A_LOOP2_REG[3]     = CNTR_A_LOOP2_WIRE[3];
    assign CNTR_A_LOOP2_REG[2]     = CNTR_A_LOOP2_WIRE[2]; 
    assign CNTR_A_LOOP2_REG[1]     = CNTR_A_LOOP2_WIRE[1];
    assign CNTR_A_LOOP2_REG[0]     = CNTR_A_LOOP2_WIRE[0];
    assign CNTR_A_LOOP3_REG[4]     = CNTR_A_LOOP3_WIRE[4]; 
    assign CNTR_A_LOOP3_REG[3]     = CNTR_A_LOOP3_WIRE[3];
    assign CNTR_A_LOOP3_REG[2]     = CNTR_A_LOOP3_WIRE[2]; 
    assign CNTR_A_LOOP3_REG[1]     = CNTR_A_LOOP3_WIRE[1];
    assign CNTR_A_LOOP3_REG[0]     = CNTR_A_LOOP3_WIRE[0];
    
    //-------------------------
    // LOOP COUNTER B REGISTERS
    //-------------------------
    assign CNTR_B_MAX_WIRE         = 2'b00;
    assign CNTR_B_LOOP_POINTER_WIRE               = 4'b1101;
    assign CNTR_B_LOOP1_WIRE[4]    = 1'b0;
    assign CNTR_B_LOOP1_WIRE[3]    = 1'b0;
    assign CNTR_B_LOOP1_WIRE[2]    = 1'b0;
    assign CNTR_B_LOOP1_WIRE[1]    = 1'b0;
    assign CNTR_B_LOOP1_WIRE[0]    = 1'b0;
    assign CNTR_B_LOOP2_WIRE[4]    = 1'b0;
    assign CNTR_B_LOOP2_WIRE[3]    = 1'b0;
    assign CNTR_B_LOOP2_WIRE[2]    = 1'b0;
    assign CNTR_B_LOOP2_WIRE[1]    = 1'b0;
    assign CNTR_B_LOOP2_WIRE[0]    = 1'b0;
    assign CNTR_B_LOOP3_WIRE[4]    = 1'b0;
    assign CNTR_B_LOOP3_WIRE[3]    = 1'b0;
    assign CNTR_B_LOOP3_WIRE[2]    = 1'b0;
    assign CNTR_B_LOOP3_WIRE[1]    = 1'b0;
    assign CNTR_B_LOOP3_WIRE[0]    = 1'b0;
    assign CNTR_B_MAX_REG          = CNTR_B_MAX_WIRE;
    assign CNTR_B_LOOP_POINTER_REG                = CNTR_B_LOOP_POINTER_WIRE;  
    assign CNTR_B_LOOP1_REG[4]     = CNTR_B_LOOP1_WIRE[4]; 
    assign CNTR_B_LOOP1_REG[3]     = CNTR_B_LOOP1_WIRE[3];
    assign CNTR_B_LOOP1_REG[2]     = CNTR_B_LOOP1_WIRE[2]; 
    assign CNTR_B_LOOP1_REG[1]     = CNTR_B_LOOP1_WIRE[1];
    assign CNTR_B_LOOP1_REG[0]     = CNTR_B_LOOP1_WIRE[0];
    assign CNTR_B_LOOP2_REG[4]     = CNTR_B_LOOP2_WIRE[4]; 
    assign CNTR_B_LOOP2_REG[3]     = CNTR_B_LOOP2_WIRE[3];
    assign CNTR_B_LOOP2_REG[2]     = CNTR_B_LOOP2_WIRE[2]; 
    assign CNTR_B_LOOP2_REG[1]     = CNTR_B_LOOP2_WIRE[1];
    assign CNTR_B_LOOP2_REG[0]     = CNTR_B_LOOP2_WIRE[0];
    assign CNTR_B_LOOP3_REG[4]     = CNTR_B_LOOP3_WIRE[4]; 
    assign CNTR_B_LOOP3_REG[3]     = CNTR_B_LOOP3_WIRE[3];
    assign CNTR_B_LOOP3_REG[2]     = CNTR_B_LOOP3_WIRE[2]; 
    assign CNTR_B_LOOP3_REG[1]     = CNTR_B_LOOP3_WIRE[1];
    assign CNTR_B_LOOP3_REG[0]     = CNTR_B_LOOP3_WIRE[0];

    //-----------------------------
    // Increment Counter A function
    //-----------------------------
    function automatic [1:0] INC_FUNCTION_FOR_CNTR_A;
    input            [1:0] COUNT;
    reg              TOGGLE;
    integer i;
       begin
          INC_FUNCTION_FOR_CNTR_A[0]               = ~COUNT[0];
          TOGGLE     = 1;
          for (i=1; i<=1; i=i+1) begin
             TOGGLE                 = COUNT[i-1] & TOGGLE;
             INC_FUNCTION_FOR_CNTR_A[i]            = COUNT[i] ^ TOGGLE;
          end
       end
    endfunction

    //-----------------------------
    // Increment Counter B function
    //-----------------------------
    function automatic [1:0] INC_FUNCTION_FOR_CNTR_B;
    input            [1:0] COUNT;
    reg              TOGGLE;
    integer i;
       begin
          INC_FUNCTION_FOR_CNTR_B[0]               = ~COUNT[0];
          TOGGLE     = 1;
          for (i=1; i<=1; i=i+1) begin
             TOGGLE                 = COUNT[i-1] & TOGGLE;
             INC_FUNCTION_FOR_CNTR_B[i]            = COUNT[i] ^ TOGGLE;
          end
       end
    endfunction
endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_repeat_loop_cntrl
 
 
/*------------------------------------------------------------------------------
     Module      :  memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_data_gen
 
     Description :  This module contains the data generator block.
 
---------------------------------------------------------------------------- */
 
module memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_data_gen (
  input wire BIST_CLK,
  input wire BIST_HOLD,
  input wire BIST_ASYNC_RESETN,
  input wire RESET_REG_DEFAULT_MODE,
  input wire [3:0] WDATA_CMD,
  input wire [3:0] EDATA_CMD,
  input wire [2:0] ROW_ADDRESS,
  input wire [2:0] COLUMN_ADDRESS,
  input wire LAST_TICK,
  input wire BIST_RUN,
  input wire BIST_SHIFT_SHORT,
  input wire SI,
  input wire BIST_ALGO_SEL_CNT,
  output wire [1:0] WRITE_DATA,
  output wire [1:0] EXPECT_DATA,
  input wire BIST_WRITEENABLE,
  output wire SO
);
 
    wire   [1:0]     MEMORY_CONTENT;
    reg    [1:0]     WRITE_DATA_INT;
    reg    [1:0]     EXPECT_DATA_INT;
    wire   [3:0]     EDATA_CMD_SELECTED;
    wire   [3:0]     WDATA_CMD_SELECTED;
 
    wire             WDATA_ROT;
    wire             WDATA_INV_FDBK;
 
    wire             EDATA_ROT;
    wire             EDATA_INV_FDBK;
 
    wire             WDATA_SHIFT;
    wire             EDATA_SHIFT;
 
    wire             WDATA_SELECT_ZEROS_REG;
    wire   [1:0]     WDATA_REG_SELECTED;
    wire             WDATA_INVERT;
 
    wire             EDATA_SELECT_ZEROS_REG;
    wire   [1:0]     EDATA_REG_SELECTED;
    wire             EDATA_INVERT;
    wire             EDATA_SI;
    wire             WDATA_SI;
    wire   [2:0]     X_ADDR_BIT_SEL_DECODED;
    wire   [2:0]     Y_ADDR_BIT_SEL_DECODED;
 
    wire             WDATA_EN_ADDR_BIT_INVERSION;
    wire             EDATA_EN_ADDR_BIT_INVERSION;
    wire             EN_ADDR_BIT_INVERSION_TO_BUF;
    wire             EN_ADDR_BIT_INVERSION;
 
    reg    [1:0]     EDATA_REG;
    reg    [1:0]     WDATA_REG;
    reg              X_ADDR_BIT_SEL_REG;
    reg              Y_ADDR_BIT_SEL_REG;
    wire             X_ADDR_BIT_SEL_WIRE;  
    wire             Y_ADDR_BIT_SEL_WIRE;

    assign SO        = Y_ADDR_BIT_SEL_REG;

    //
    // ExpectDataCmd                         Decode
    // ----------------                      -------
    // DataReg                               4'b0000
    // InverseDataReg                        4'b0001
    // Zero                                  4'b0010
    // One                                   4'b0011
    // DataReg_Rotate                        4'b0100
    // InverseDataReg_Rotate                 4'b0101
    // DataReg_RotateWithInvert              4'b0110
    // InverseDataReg_RotateWithInvert       4'b0111
    // Set_DataReg                           4'b1000
    // Reset_DataReg                         4'b1001
    // Memory_Content                        4'b1010
    //

//------------------------
//-- Write Data Command --
//------------------------
    assign WDATA_CMD_SELECTED = WDATA_CMD;

//-------------------------
//-- Expect Data Command --
//-------------------------
    assign EDATA_CMD_SELECTED = EDATA_CMD;

//-------------------------
//-- Write Data Register --
//-------------------------
    assign WDATA_ROT                = (WDATA_CMD_SELECTED == 4'b0100) |
                                      (WDATA_CMD_SELECTED == 4'b0101) |
                                      (WDATA_CMD_SELECTED == 4'b0110) |
                                      (WDATA_CMD_SELECTED == 4'b0111) ;
 
    assign WDATA_INV_FDBK           = (WDATA_CMD_SELECTED == 4'b0110) |
                                      (WDATA_CMD_SELECTED == 4'b0111) ;
 
    assign WDATA_SHIFT              = (BIST_SHIFT_SHORT) | ( LAST_TICK & WDATA_ROT & BIST_RUN);
    
    assign WDATA_SI                 = (BIST_SHIFT_SHORT) ? SI :
                                                         WDATA_ROT & (WDATA_INV_FDBK ^ WDATA_REG[1]);
 
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN)
            WDATA_REG               <= 2'b00;
        else
        if (RESET_REG_DEFAULT_MODE & BIST_ALGO_SEL_CNT)
            WDATA_REG               <= 2'b00; // Algorithm: SMARCH
        else
        if (WDATA_SHIFT)
            WDATA_REG               <= {WDATA_REG[0:0], WDATA_SI};    
    end

//--------------------------
//-- Expect Data Register --
//--------------------------
    assign EDATA_ROT                = (EDATA_CMD_SELECTED == 4'b0100) |
                                      (EDATA_CMD_SELECTED == 4'b0101) |
                                      (EDATA_CMD_SELECTED == 4'b0110) |
                                      (EDATA_CMD_SELECTED == 4'b0111) ;
 
    assign EDATA_INV_FDBK           = (EDATA_CMD_SELECTED == 4'b0110) |
                                      (EDATA_CMD_SELECTED == 4'b0111) ;
 
    assign EDATA_SHIFT              = (BIST_SHIFT_SHORT) | ( LAST_TICK & EDATA_ROT & BIST_RUN);
    
    assign EDATA_SI                 = (BIST_SHIFT_SHORT) ? WDATA_REG[1] :
                                                        EDATA_ROT & (EDATA_INV_FDBK ^ EDATA_REG[1]);
    
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
        if (~BIST_ASYNC_RESETN)
            EDATA_REG               <= 2'b00;
        else
        if (RESET_REG_DEFAULT_MODE & BIST_ALGO_SEL_CNT)
            EDATA_REG               <= 2'b00; // Algorithm: SMARCH
        else
        if (EDATA_SHIFT)
            EDATA_REG               <= {EDATA_REG[0:0], EDATA_SI};
    end

//----------------------------------
//-- Write Data for MemoryContent --
//----------------------------------
    assign MEMORY_CONTENT = 2'b00; // BitSliceWidth: 1

//---------------------------
//-- Write Data Generation --
//---------------------------
    always @ (MEMORY_CONTENT or WDATA_CMD_SELECTED or WDATA_REG or WDATA_EN_ADDR_BIT_INVERSION) begin
        case (WDATA_CMD_SELECTED)
        4'b0001,
        4'b0101,
        4'b0111:     WRITE_DATA_INT = (~WDATA_REG) ^ {2{ WDATA_EN_ADDR_BIT_INVERSION }};
        4'b0011:     WRITE_DATA_INT = (~2'b00) ^ {2{ WDATA_EN_ADDR_BIT_INVERSION }};
        4'b0010:     WRITE_DATA_INT = 2'b00 ^ {2{ WDATA_EN_ADDR_BIT_INVERSION }};
        4'b1000:     WRITE_DATA_INT = ~(2'b00);
        4'b1001:     WRITE_DATA_INT = 2'b00;
        4'b1010:     WRITE_DATA_INT = MEMORY_CONTENT;
        default:     WRITE_DATA_INT = WDATA_REG ^ {2{ WDATA_EN_ADDR_BIT_INVERSION }};
        endcase
    end
    assign WRITE_DATA = WRITE_DATA_INT;

//----------------------------
//-- Expect Data Generation --
//----------------------------
    always @ (MEMORY_CONTENT or EDATA_CMD_SELECTED or EDATA_REG or EDATA_EN_ADDR_BIT_INVERSION) begin
        case (EDATA_CMD_SELECTED)
        4'b0001,
        4'b0101,
        4'b0111:     EXPECT_DATA_INT = (~EDATA_REG) ^ {2{ EDATA_EN_ADDR_BIT_INVERSION }};
        4'b0011:     EXPECT_DATA_INT = (~2'b00) ^ {2{ EDATA_EN_ADDR_BIT_INVERSION }};
        4'b0010:     EXPECT_DATA_INT = 2'b00 ^ {2{ EDATA_EN_ADDR_BIT_INVERSION }};
        4'b1000:     EXPECT_DATA_INT = ~(2'b00);
        4'b1001:     EXPECT_DATA_INT = 2'b00;
        4'b1010:     EXPECT_DATA_INT = MEMORY_CONTENT;
        default:     EXPECT_DATA_INT = EDATA_REG ^ {2{ EDATA_EN_ADDR_BIT_INVERSION }};
        endcase
    end
    assign EXPECT_DATA = EXPECT_DATA_INT;

 
    // Decode address bit for inversion
    assign X_ADDR_BIT_SEL_DECODED[2]              = 1'b0; 
    assign X_ADDR_BIT_SEL_DECODED[1]              = 1'b0; 
    assign X_ADDR_BIT_SEL_DECODED[0]              = (X_ADDR_BIT_SEL_REG == 1'b1); 
 
    assign Y_ADDR_BIT_SEL_DECODED[2]              = 1'b0;
    assign Y_ADDR_BIT_SEL_DECODED[1]              = 1'b0;
    assign Y_ADDR_BIT_SEL_DECODED[0]              = (Y_ADDR_BIT_SEL_REG == 1'b1);
 
    // Address bit inversion mask
    assign EN_ADDR_BIT_INVERSION_TO_BUF           = (|(X_ADDR_BIT_SEL_DECODED & ROW_ADDRESS)) ^  (|(Y_ADDR_BIT_SEL_DECODED & COLUMN_ADDRESS));   
   //
   // An MCP can be declared through the EN_ADDR_BIT_INVERSION persistent buffer 
   // ONLY if no operation is writing in the first TICK.
   // If any operation writes in the first TICK, this creates an SCP path 
   // through this buffer.
   //
    memlibc_memory_bist_assembly_rtl_tessent_buf tessent_persistent_cell_EN_ADDR_BIT_INVERSION (
        .a           (EN_ADDR_BIT_INVERSION_TO_BUF),
        .y           (EN_ADDR_BIT_INVERSION)
    );    

//--------------------------
//-- Write Data Inversion --
//--------------------------
    assign WDATA_EN_ADDR_BIT_INVERSION = EN_ADDR_BIT_INVERSION;

//---------------------------
//-- Expect Data Inversion --
//---------------------------
    assign EDATA_EN_ADDR_BIT_INVERSION = EN_ADDR_BIT_INVERSION;
 
    // Select row bit to invert
    assign X_ADDR_BIT_SEL_WIRE     = 1'b0; // Algorithm: SMARCH
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
             X_ADDR_BIT_SEL_REG    <= 1'b0;
        else
        if (RESET_REG_DEFAULT_MODE & BIST_ALGO_SEL_CNT) begin
           X_ADDR_BIT_SEL_REG      <= X_ADDR_BIT_SEL_WIRE;     
        end
        else begin
            if (BIST_SHIFT_SHORT) begin
             X_ADDR_BIT_SEL_REG    <= {EDATA_REG[1]};
            end        
        end    
    end
 
    // Select column bit to invert
    assign Y_ADDR_BIT_SEL_WIRE     = 1'b0; // Algorithm: SMARCH
    
    // synopsys async_set_reset "BIST_ASYNC_RESETN"
    always @ (posedge BIST_CLK or negedge BIST_ASYNC_RESETN) begin
       if (~BIST_ASYNC_RESETN)
            Y_ADDR_BIT_SEL_REG     <= 1'b0;
       else
        if (RESET_REG_DEFAULT_MODE & BIST_ALGO_SEL_CNT) begin
           Y_ADDR_BIT_SEL_REG      <= Y_ADDR_BIT_SEL_WIRE;          
        end   
        else begin
            if (BIST_SHIFT_SHORT) begin
             Y_ADDR_BIT_SEL_REG    <= {X_ADDR_BIT_SEL_REG};
            end
        end    
    end
 
endmodule // memlibc_memory_bist_assembly_rtl_tessent_mbist_c1_controller_data_gen
 
 
 
 
 
