// This property file was autogenerated by AutoSVA on 2024-04-22
// to check the behavior of the original RTL module, whose interface is described below: 


module riscv_CoreReorderBuffer_prop
#(
		parameter ASSERT_INPUTS = 0)
(
		input         clk,
		input         reset,
		
		input         rob_alloc_req_val,
		input         rob_alloc_req_rdy, //output
		input  [ 4:0] rob_alloc_req_preg,
		
		input  [ 3:0] rob_alloc_resp_slot, //output
		
		input         rob_fill_val,
		input  [ 3:0] rob_fill_slot,
		
		input         rob_commit_wen, //output
		input  [ 3:0] rob_commit_slot, //output
		input  [ 4:0] rob_commit_rf_waddr //output
	);

//==============================================================================
// Local Parameters
//==============================================================================

genvar j;
default clocking cb @(posedge clk);
endclocking
default disable iff (reset);

// Re-defined wires 
wire [4:0] rob_alloc_req_data;
wire [7:0] rob_alloc_req_transid;
wire rob_commit_val;
wire [4:0] rob_commit_data;
wire [7:0] rob_commit_transid;

// Symbolics and Handshake signals
wire [0:0] symb_rob_alloc_req_transid;
am__symb_rob_alloc_req_transid_stable: assume property($stable(symb_rob_alloc_req_transid));
wire rob_commit_hsk = rob_commit_val;
wire rob_alloc_req_hsk = rob_alloc_req_val && rob_alloc_req_rdy;

//==============================================================================
// Modeling
//==============================================================================

// Modeling incoming request for rob_trans
// Generate sampling signals and model
reg [3:0] rob_trans_transid_sampled;
wire rob_trans_transid_set = rob_alloc_req_hsk && rob_alloc_req_transid == symb_rob_alloc_req_transid;
wire rob_trans_transid_response = rob_commit_hsk && rob_commit_transid == symb_rob_alloc_req_transid;

always_ff @(posedge clk) begin
	if(reset) begin
		rob_trans_transid_sampled <= '0;
	end else if (rob_trans_transid_set || rob_trans_transid_response ) begin
		rob_trans_transid_sampled <= rob_trans_transid_sampled + rob_trans_transid_set - rob_trans_transid_response;
	end
end
co__rob_trans_transid_sampled: cover property (|rob_trans_transid_sampled);
if (ASSERT_INPUTS) begin
	as__rob_trans_transid_sample_no_overflow: assert property (rob_trans_transid_sampled != '1 || !rob_trans_transid_set);
end else begin
	am__rob_trans_transid_sample_no_overflow: assume property (rob_trans_transid_sampled != '1 || !rob_trans_transid_set);
end

// Assert that if valid eventually ready or dropped valid
as__rob_trans_transid_hsk_or_drop: assert property (rob_alloc_req_val |-> s_eventually(!rob_alloc_req_val || rob_alloc_req_rdy));
// Assert that every request has a response and that every reponse has a request
as__rob_trans_transid_eventual_response: assert property (|rob_trans_transid_sampled |-> s_eventually(rob_commit_val && (rob_commit_transid == symb_rob_alloc_req_transid) ));
as__rob_trans_transid_was_a_request: assert property (rob_trans_transid_response |-> rob_trans_transid_set || rob_trans_transid_sampled);


// Modeling data integrity for rob_trans_transid
reg [4:0] rob_trans_transid_data_model;
always_ff @(posedge clk) begin
	if(reset) begin
		rob_trans_transid_data_model <= '0;
	end else if (rob_trans_transid_set) begin
		rob_trans_transid_data_model <= rob_alloc_req_data;
	end
end

as__rob_trans_transid_data_unique: assert property (|rob_trans_transid_sampled |-> !rob_trans_transid_set);
as__rob_trans_transid_data_integrity: assert property (|rob_trans_transid_sampled && rob_trans_transid_response |-> (rob_commit_data == rob_trans_transid_data_model));

assign rob_commit_data = rob_commit_rf_waddr;
assign rob_alloc_req_transid = rob_alloc_req_transid_reg;
assign rob_commit_transid = rob_commit_transid_reg;
assign rob_commit_val = rob_commit_wen;
assign rob_alloc_req_data = rob_alloc_req_preg;

//X PROPAGATION ASSERTIONS
`ifdef XPROP
	 as__no_x_rob_commit_val: assert property(!$isunknown(rob_commit_val));
	 as__no_x_rob_commit_data: assert property(rob_commit_val |-> !$isunknown(rob_commit_data));
	 as__no_x_rob_commit_transid: assert property(rob_commit_val |-> !$isunknown(rob_commit_transid));
	 as__no_x_rob_alloc_req_val: assert property(!$isunknown(rob_alloc_req_val));
	 as__no_x_rob_alloc_req_transid: assert property(rob_alloc_req_val |-> !$isunknown(rob_alloc_req_transid));
	 as__no_x_rob_alloc_req_data: assert property(rob_alloc_req_val |-> !$isunknown(rob_alloc_req_data));
`endif

//====DESIGNER-ADDED-SVA====//
reg [7:0] rob_alloc_req_transid_reg;
reg [7:0] rob_commit_transid_reg;

always @(posedge clk) begin
	if (reset) begin
		rob_alloc_req_transid_reg <= 8'b0;
		rob_commit_transid_reg <= 8'b0;
	end
	else begin
		if (rob_alloc_req_val && rob_alloc_req_rdy) begin
			rob_alloc_req_transid_reg <= rob_alloc_req_transid_reg + 1 ;
		end
		if (rob_commit_val) begin
			rob_commit_transid_reg <= rob_commit_transid_reg + 1;
		end
	end
end

// Assume that every slot that gets allocated eventually gets filled
integer i;
always @* begin
    for (i = 0; i < 16; i++) begin
        assume property (@(posedge clk) (rob_alloc_resp_slot == i) |-> s_eventually (rob_fill_slot == i));
    end
end

// Assert that one cycle after getting filled, a slot gets commited
// FIX: Only holds true for the head.
integer i;
always @* begin
    for (i = 0; i < 16; i++) begin
        assert property (@(posedge clk) ((rob_fill_slot == i && (rob_fill_val))) |-> s_eventually ((rob_commit_slot == i) && rob_commit_wen));
    end
end

// Assume fill slot is any of the pending slots
as_fill_slot_valid: assume property (@(posedge clk) rob_fill_val |-> (rob_fill_slot != 'bx) && (rob_fill_slot == pending_slots[0] ||
																			   									 pending_slots[1] ||
																			   									 pending_slots[2] ||
																			   									 pending_slots[3] ||
																			   									 pending_slots[4] ||
																			   									 pending_slots[5] ||
																			   									 pending_slots[6] ||
																			   									 pending_slots[7] ||
																			   									 pending_slots[8] ||
																			   									 pending_slots[9] ||
																			   									 pending_slots[10] ||
																			   									 pending_slots[11] ||
																			   									 pending_slots[12] ||
																			   									 pending_slots[13] ||
																			   									 pending_slots[14] ||
																			   									 pending_slots[15]));							


// Determine pending slots (have been allocated and not yet filled)
logic [3:0] pending_slots [15:0];
always @(posedge clk) begin
	if (reset) begin
		pending_slots <= '{default: 'x};
	end
	else begin
		if (rob_alloc_req_val && rob_alloc_req_rdy) begin
			pending_slots[rob_alloc_resp_slot] <= rob_alloc_resp_slot;
		end
		if (rob_commit_wen) begin
			pending_slots[rob_commit_slot] <= 4'bx;
		end
	end
end

// Assume that reset gets asserted for a clock cycle
as_reset: assume property (@(posedge clk) s_eventually $rose(reset) |-> ##1 $fell(reset)); 

endmodule