// This property file was autogenerated by AutoSVA on 2024-04-24
// to check the behavior of the original RTL module, whose interface is described below: 


`include "../../ece475-lab2/vc/vc-MemReqMsg.v"
`include "../../ece475-lab2/vc/vc-MemRespMsg.v"
`include "../../ece475-lab2/riscvstall/riscvstall-CoreCtrl.v"
`include "../../ece475-lab2/riscvstall/riscvstall-CoreDpath.v"
`include "../../ece475-lab2/riscvstall/riscvstall-InstMsg.v"

module riscv_Core_prop
#(
		parameter ASSERT_INPUTS = 0)
(
		input         clk,
		input         reset,
		
		// Instruction Memory Request Port
		
		input  [`VC_MEM_REQ_MSG_SZ(32,32)-1:0] imemreq_msg, //output
		input                                  imemreq_val, //output
		input                                  imemreq_rdy,
		
		// Instruction Memory Response Port
		
		input [`VC_MEM_RESP_MSG_SZ(32)-1:0] imemresp_msg,
		input                               imemresp_val,
		
		// Data Memory Request Port
		
		input  [`VC_MEM_REQ_MSG_SZ(32,32)-1:0] dmemreq_msg, //output
		input                                  dmemreq_val, //output
		input                                  dmemreq_rdy,
		
		// Data Memory Response Port
		
		input [`VC_MEM_RESP_MSG_SZ(32)-1:0] dmemresp_msg,
		input                               dmemresp_val,
		
		// CSR Status Register Output to Host
		
		input  [31:0] csr_status //output
	);

//==============================================================================
// Local Parameters
//==============================================================================

genvar j;
default clocking cb @(posedge clk);
endclocking
default disable iff (reset);

// Re-defined wires 
wire [7:0] ir_transid;
wire [7:0] rf_transid;
wire rf_val;
wire rf_rdy;
wire ir_val;
wire ir_rdy;

// Symbolics and Handshake signals
wire [7:0] symb_ir_transid;
am__symb_ir_transid_stable: assume property($stable(symb_ir_transid));
wire rf_hsk = rf_val && rf_rdy;
wire ir_hsk = ir_val && ir_rdy;

//==============================================================================
// Modeling
//==============================================================================

// Modeling incoming request for imem_rf_trans
if (ASSERT_INPUTS) begin
	as__imem_rf_trans_fairness: assert property (rf_val |-> s_eventually(rf_rdy));
end else begin
	am__imem_rf_trans_fairness: assume property (rf_val |-> s_eventually(rf_rdy));
end

// Generate sampling signals and model
reg [3:0] imem_rf_trans_transid_sampled;
wire imem_rf_trans_transid_set = ir_hsk && ir_transid == symb_ir_transid;
wire imem_rf_trans_transid_response = rf_hsk && rf_transid == symb_ir_transid;

always_ff @(posedge clk) begin
	if(reset) begin
		imem_rf_trans_transid_sampled <= '0;
	end else if (imem_rf_trans_transid_set || imem_rf_trans_transid_response ) begin
		imem_rf_trans_transid_sampled <= imem_rf_trans_transid_sampled + imem_rf_trans_transid_set - imem_rf_trans_transid_response;
	end
end
co__imem_rf_trans_transid_sampled: cover property (|imem_rf_trans_transid_sampled);
if (ASSERT_INPUTS) begin
	as__imem_rf_trans_transid_sample_no_overflow: assert property (imem_rf_trans_transid_sampled != '1 || !imem_rf_trans_transid_set);
end else begin
	am__imem_rf_trans_transid_sample_no_overflow: assume property (imem_rf_trans_transid_sampled != '1 || !imem_rf_trans_transid_set);
end


// Assert that if valid eventually ready or dropped valid
as__imem_rf_trans_transid_hsk_or_drop: assert property (ir_val |-> s_eventually(!ir_val || ir_rdy));
// Assert that every request has a response and that every reponse has a request
as__imem_rf_trans_transid_eventual_response: assert property (|imem_rf_trans_transid_sampled |-> s_eventually(rf_val && (rf_transid == symb_ir_transid) ));
as__imem_rf_trans_transid_was_a_request: assert property (imem_rf_trans_transid_response |-> imem_rf_trans_transid_set || imem_rf_trans_transid_sampled);

assign ir_rdy = !(ir_Dhl_prev == ctrl.ir_Dhl);
assign ir_val = ctrl.inst_val_Dhl;
assign rf_transid = rf_transid_reg;
assign rf_rdy = 1'b1;
assign rf_val = dpath.rf_wen_Whl && ctrl.inst_val_Whl;
assign ir_transid = ir_transid_reg;

//X PROPAGATION ASSERTIONS
`ifdef XPROP
	 as__no_x_rf_val: assert property(!$isunknown(rf_val));
	 as__no_x_rf_transid: assert property(rf_val |-> !$isunknown(rf_transid));
	 as__no_x_ir_val: assert property(!$isunknown(ir_val));
	 as__no_x_ir_transid: assert property(ir_val |-> !$isunknown(ir_transid));
`endif

//====DESIGNER-ADDED-SVA====//
reg [7:0] ir_transid_reg;
reg [7:0] rf_transid_reg; 

always_ff @(posedge clk) begin
	if (reset) begin
		ir_transid_reg <= 8'b0; 
		rf_transid_reg <= 8'b0;
	end else begin
		if (ir_val && ir_rdy) begin
			ir_transid_reg <= ir_transid_reg + 8'b1; 
		end

		if (rf_val) begin
			rf_transid_reg <= rf_transid_reg + 8'b1; 
		end
	end
end

reg [31:0] ir_Dhl_prev;
always_ff @(posedge clk) begin
	if (reset) begin
		ir_Dhl_prev <= 32'b0; 
	end else begin
		ir_Dhl_prev <= ctrl.ir_Dhl; 
	end
end
as_r_type_alu_instr: assume property ((ctrl.ir_Dhl  == `RISCV_INST_MSG_ADD) ||
									  (ctrl.ir_Dhl  == `RISCV_INST_MSG_SUB) ||
									  (ctrl.ir_Dhl  == `RISCV_INST_MSG_SLL) ||
									  (ctrl.ir_Dhl  == `RISCV_INST_MSG_SLT) ||
									  (ctrl.ir_Dhl  == `RISCV_INST_MSG_SLTU) ||
									  (ctrl.ir_Dhl  == `RISCV_INST_MSG_XOR) ||
									  (ctrl.ir_Dhl  == `RISCV_INST_MSG_SRL) ||
									  (ctrl.ir_Dhl  == `RISCV_INST_MSG_SRA) ||
									  (ctrl.ir_Dhl  == `RISCV_INST_MSG_OR) ||
									  (ctrl.ir_Dhl  == `RISCV_INST_MSG_AND) ); 
endmodule