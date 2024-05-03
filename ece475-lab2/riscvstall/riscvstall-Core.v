//=========================================================================
// 5-Stage RISCV Core
//=========================================================================

`ifndef RISCV_CORE_V
`define RISCV_CORE_V

`include "../../ece475-lab2/vc/vc-MemReqMsg.v"
`include "../../ece475-lab2/vc/vc-MemRespMsg.v"
`include "../../ece475-lab2/riscvstall/riscvstall-CoreCtrl.v"
`include "../../ece475-lab2/riscvstall/riscvstall-CoreDpath.v"
`include "../../ece475-lab2/riscvstall/riscvstall-InstMsg.v"
`include "../../ece475-lab2/riscvstall/riscvstall-Instructions.v"


module riscv_Core
(
  /*AUTOSVA
    ir_rf_trans: ir -IN> rf
    [7:0] ir_transid = ir_transid_reg
    [7:0] rf_transid = rf_transid_reg
    rf_val = ctrl.inst_val_Whl && ctrl.rf_wen_Whl && (type_alu_r_instr_Whl || type_alu_i_instr_Whl);
    rf_rdy = 1'b1
    ir_val = ctrl.inst_val_Dhl && (type_alu_r_instr_Dhl || type_alu_i_instr_Dhl)
    ir_rdy = !stall_Dhl_reg;
    [31:0] ir_data = alu_output_reg
    [31:0] rf_data = rf_data_reg
    
    load_ir_dmem_trans: load_ir -IN> load_dmem
    [7:0] load_ir_transid = load_ir_transid_reg
    [7:0] load_dmem_transid = load_dmem_transid_reg
    load_ir_rdy = !stall_Dhl_reg;
    load_ir_val = ctrl.inst_val_Dhl && type_load_instr_Dhl
    load_dmem_rdy = dmemreq_rdy_Mhl
    load_dmem_val = ctrl.inst_val_Mhl && (dmemreq_msg_rw_Mhl && dmemreq_val_Mhl) && type_load_instr_Mhl && !stall_Mhl_reg
    [31:0] load_ir_data = load_mem_addr_reg
    [31:0] load_dmem_data = load_dmemreq_msg_addr_Whl

    load_dmem_rf_trans: load_dmem_out -IN> load_rf
    [7:0] load_dmem_out_transid = load_dmem_out_transid_reg
    [7:0] load_rf_transid = load_rf_transid_reg
    load_dmem_out_rdy = dmemresp_val
    load_dmem_out_val = ctrl.inst_val_Mhl && type_load_instr_Mhl && dmemreq_val_Mhl && !stall_Mhl_reg
    load_rf_rdy = 1'b1
    load_rf_val = dpath.rf_wen_Whl && ctrl.inst_val_Whl && type_load_instr_Whl
    [31:0] load_dmem_out_data = load_dmem_out_data_reg
    [31:0] load_rf_data = load_rf_data_reg

    store_ir_dmem_trans: store_ir -IN> store_dmem
    [7:0] store_ir_transid = store_ir_transid_reg
    [7:0] store_dmem_transid = store_dmem_transid_reg
    store_ir_rdy = !stall_Dhl_reg;
    store_ir_val = ctrl.inst_val_Dhl && type_store_instr_Dhl
    store_dmem_rdy = dmemreq_rdy_Mhl
    store_dmem_val = ctrl.inst_val_Mhl && ((dmemreq_msg_rw_Mhl == 2'd2) && dmemreq_val_Mhl) && type_store_instr_Mhl && !stall_Mhl_reg
    [31:0] store_ir_data = store_mem_addr_reg
    [31:0] store_dmem_data = store_dmemreq_msg_addr_Whl

  */

  input         clk,
  input         reset,

  // Instruction Memory Request Port

  output [`VC_MEM_REQ_MSG_SZ(32,32)-1:0] imemreq_msg,
  output                                 imemreq_val,
  input                                  imemreq_rdy,

  // Instruction Memory Response Port

  input [`VC_MEM_RESP_MSG_SZ(32)-1:0] imemresp_msg,
  input                               imemresp_val,

  // Data Memory Request Port

  output [`VC_MEM_REQ_MSG_SZ(32,32)-1:0] dmemreq_msg,
  output                                 dmemreq_val,
  input                                  dmemreq_rdy,

  // Data Memory Response Port

  input [`VC_MEM_RESP_MSG_SZ(32)-1:0] dmemresp_msg,
  input                               dmemresp_val,

  // CSR Status Register Output to Host

  output [31:0] csr_status
);

  wire [31:0] imemreq_msg_addr;
  wire [31:0] imemresp_msg_data;

  wire        dmemreq_msg_rw;
  wire  [1:0] dmemreq_msg_len;
  wire [31:0] dmemreq_msg_addr;
  wire [31:0] dmemreq_msg_data;
  wire [31:0] dmemresp_msg_data;

  wire  [1:0] pc_mux_sel_Phl;
  wire  [1:0] op0_mux_sel_Dhl;
  wire  [2:0] op1_mux_sel_Dhl;
  wire [31:0] inst_Dhl;
  wire  [3:0] alu_fn_Xhl;
  wire  [2:0] muldivreq_msg_fn_Xhl;
  wire        muldivreq_val;
  wire        muldivreq_rdy;
  wire        muldivresp_val;
  wire        muldivresp_rdy;
  wire        muldiv_mux_sel_Xhl;
  wire        execute_mux_sel_Xhl;
  wire  [2:0] dmemresp_mux_sel_Mhl;
  wire        dmemresp_queue_en_Mhl;
  wire        dmemresp_queue_val_Mhl;
  wire        wb_mux_sel_Mhl;
  wire        rf_wen_Whl;
  wire  [4:0] rf_waddr_Whl;
  wire        stall_Fhl;
  wire        stall_Dhl;
  wire        stall_Xhl;
  wire        stall_Mhl;
  wire        stall_Whl;

  wire        branch_cond_eq_Xhl;
  wire        branch_cond_ne_Xhl;
  wire        branch_cond_lt_Xhl;
  wire        branch_cond_ltu_Xhl;
  wire        branch_cond_ge_Xhl;
  wire        branch_cond_geu_Xhl;
  wire [31:0] proc2csr_data_Whl;

  //----------------------------------------------------------------------
  // Pack Memory Request Messages
  //----------------------------------------------------------------------

  vc_MemReqMsgToBits#(32,32) imemreq_msg_to_bits
  (
    .t (`VC_MEM_REQ_MSG_TYPE_READ),
    .addr (imemreq_msg_addr),
    .len  (2'd0),
    .data (32'bx),
    .bits (imemreq_msg)
  );

  vc_MemReqMsgToBits#(32,32) dmemreq_msg_to_bits
  (
    .t (dmemreq_msg_rw),
    .addr (dmemreq_msg_addr),
    .len  (dmemreq_msg_len),
    .data (dmemreq_msg_data),
    .bits (dmemreq_msg)
  );

  //----------------------------------------------------------------------
  // Unpack Memory Response Messages
  //----------------------------------------------------------------------

  vc_MemRespMsgFromBits#(32) imemresp_msg_from_bits
  (
    .bits (imemresp_msg),
    .t (),
    .len  (),
    .data (imemresp_msg_data)
  );

  vc_MemRespMsgFromBits#(32) dmemresp_msg_from_bits
  (
    .bits (dmemresp_msg),
    .t (),
    .len  (),
    .data (dmemresp_msg_data)
  );

  //----------------------------------------------------------------------
  // Control Unit
  //----------------------------------------------------------------------

  riscv_CoreCtrl ctrl
  (
    .clk                    (clk),
    .reset                  (reset),

    // Instruction Memory Port

    .imemreq_val            (imemreq_val),
    .imemreq_rdy            (imemreq_rdy),
    .imemresp_msg_data      (imemresp_msg_data),
    .imemresp_val           (imemresp_val),

    // Data Memory Port

    .dmemreq_msg_rw         (dmemreq_msg_rw),
    .dmemreq_msg_len        (dmemreq_msg_len),
    .dmemreq_val            (dmemreq_val),
    .dmemreq_rdy            (dmemreq_rdy),
    .dmemresp_val           (dmemresp_val),

    // Controls Signals (ctrl->dpath)

    .pc_mux_sel_Phl         (pc_mux_sel_Phl),
    .op0_mux_sel_Dhl        (op0_mux_sel_Dhl),
    .op1_mux_sel_Dhl        (op1_mux_sel_Dhl),
    .inst_Dhl               (inst_Dhl),
    .alu_fn_Xhl             (alu_fn_Xhl),
    .muldivreq_msg_fn_Xhl   (muldivreq_msg_fn_Xhl),
    .muldivreq_val          (muldivreq_val),
    .muldivreq_rdy          (muldivreq_rdy),
    .muldivresp_val         (muldivresp_val),
    .muldivresp_rdy         (muldivresp_rdy),
    .muldiv_mux_sel_Xhl     (muldiv_mux_sel_Xhl),
    .execute_mux_sel_Xhl    (execute_mux_sel_Xhl),
    .dmemresp_mux_sel_Mhl   (dmemresp_mux_sel_Mhl),
    .dmemresp_queue_en_Mhl  (dmemresp_queue_en_Mhl),
    .dmemresp_queue_val_Mhl (dmemresp_queue_val_Mhl),
    .wb_mux_sel_Mhl         (wb_mux_sel_Mhl),
    .rf_wen_out_Whl         (rf_wen_Whl),
    .rf_waddr_Whl           (rf_waddr_Whl),
    .stall_Fhl              (stall_Fhl),
    .stall_Dhl              (stall_Dhl),
    .stall_Xhl              (stall_Xhl),
    .stall_Mhl              (stall_Mhl),
    .stall_Whl              (stall_Whl),

    // Control Signals (dpath->ctrl)

    .branch_cond_eq_Xhl	    (branch_cond_eq_Xhl),
    .branch_cond_ne_Xhl	    (branch_cond_ne_Xhl),
    .branch_cond_lt_Xhl	    (branch_cond_lt_Xhl),
    .branch_cond_ltu_Xhl	  (branch_cond_ltu_Xhl),
    .branch_cond_ge_Xhl	    (branch_cond_ge_Xhl),
    .branch_cond_geu_Xhl	  (branch_cond_geu_Xhl),
    .proc2csr_data_Whl      (proc2csr_data_Whl),

    // CSR Status

    .csr_status             (csr_status)
  );

  //----------------------------------------------------------------------
  // Datapath
  //----------------------------------------------------------------------

  riscv_CoreDpath dpath
  (
    .clk                     (clk),
    .reset                   (reset),

    // Instruction Memory Port

    .imemreq_msg_addr        (imemreq_msg_addr),

    // Data Memory Port

    .dmemreq_msg_addr        (dmemreq_msg_addr),
    .dmemreq_msg_data        (dmemreq_msg_data),
    .dmemresp_msg_data       (dmemresp_msg_data),

    // Controls Signals (ctrl->dpath)

    .pc_mux_sel_Phl          (pc_mux_sel_Phl),
    .op0_mux_sel_Dhl         (op0_mux_sel_Dhl),
    .op1_mux_sel_Dhl         (op1_mux_sel_Dhl),
    .inst_Dhl                (inst_Dhl),
    .alu_fn_Xhl              (alu_fn_Xhl),
    .muldivreq_msg_fn_Xhl    (muldivreq_msg_fn_Xhl),
    .muldivreq_val           (muldivreq_val),
    .muldivreq_rdy           (muldivreq_rdy),
    .muldivresp_val          (muldivresp_val),
    .muldivresp_rdy          (muldivresp_rdy),
    .muldiv_mux_sel_Xhl      (muldiv_mux_sel_Xhl),
    .execute_mux_sel_Xhl     (execute_mux_sel_Xhl),
    .dmemresp_mux_sel_Mhl    (dmemresp_mux_sel_Mhl),
    .dmemresp_queue_en_Mhl   (dmemresp_queue_en_Mhl),
    .dmemresp_queue_val_Mhl  (dmemresp_queue_val_Mhl),
    .wb_mux_sel_Mhl          (wb_mux_sel_Mhl),
    .rf_wen_Whl              (rf_wen_Whl),
    .rf_waddr_Whl            (rf_waddr_Whl),
    .stall_Fhl               (stall_Fhl),
    .stall_Dhl               (stall_Dhl),
    .stall_Xhl               (stall_Xhl),
    .stall_Mhl               (stall_Mhl),
    .stall_Whl               (stall_Whl),

    // Control Signals (dpath->ctrl)

    .branch_cond_eq_Xhl	     (branch_cond_eq_Xhl),
    .branch_cond_ne_Xhl	     (branch_cond_ne_Xhl),
    .branch_cond_lt_Xhl	     (branch_cond_lt_Xhl),
    .branch_cond_ltu_Xhl	 (branch_cond_ltu_Xhl),
    .branch_cond_ge_Xhl	     (branch_cond_ge_Xhl),
    .branch_cond_geu_Xhl	 (branch_cond_geu_Xhl),
    .proc2csr_data_Whl       (proc2csr_data_Whl)
  );

endmodule

`endif

// vim: set textwidth=0 ts=2 sw=2 sts=2 :
