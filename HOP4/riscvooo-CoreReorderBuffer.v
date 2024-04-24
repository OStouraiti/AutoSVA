//=========================================================================
// 5-Stage RISCV Scoreboard
//=========================================================================

`ifndef RISCV_CORE_REORDERBUFFER_V
`define RISCV_CORE_REORDERBUFFER_V

module riscv_CoreReorderBuffer
(
    /*AUTOSVA
    rob_alloc_commit_trans: rob_alloc_req -IN> rob_commit
    [4:0] rob_alloc_req_data = rob_alloc_req_preg
    rob_commit_val = rob_commit_wen
    [4:0] rob_commit_data = rob_commit_rf_waddr
    [3:0] rob_alloc_req_transid = 4'b0
    [3:0] rob_commit_transid = 4'b0
    rob_fill_commit_trans: rob_fill -IN> rob_commit
    [3:0] rob_fill_data = rob_fill_slot
    [3:0] rob_commit_data = rob_commit_slot
    rob_commit_val = rob_commit_wen
    [3:0] rob_fill_transid = rob_fill_slot
    [3:0] rob_commit_transid = rob_commit_slot
    */
  input         clk,
  input         reset,

  input         rob_alloc_req_val,
  output        rob_alloc_req_rdy,
  input  [ 4:0] rob_alloc_req_preg,
  
  output [ 3:0] rob_alloc_resp_slot,

  input         rob_fill_val,
  input  [ 3:0] rob_fill_slot,

  output        rob_commit_wen,
  output [ 3:0] rob_commit_slot,
  output [ 4:0] rob_commit_rf_waddr
);

/*
wire rob_alloc_req_rdy   = 1'b1;
wire rob_alloc_resp_slot = 5'b0;
wire rob_commit_wen      = 1'b0;
wire rob_commit_rf_waddr = 1'b0;
wire rob_commit_slot     = 5'b0;
*/

  assign rob_alloc_req_rdy   = !(full); 
  assign rob_alloc_resp_slot = (rob[tail][0] == 5'b0) ? tail : 5'bx;
  assign rob_commit_wen      = ((rob[head][1] == 5'b0) && (rob[head][0] == 5'b1)) ? 1'b1: 1'b0;
  assign rob_commit_rf_waddr = ((rob[head][1] == 5'b0) && (rob[head][0] == 5'b1)) ? rob[head][2]: 5'bx;
  assign rob_commit_slot     = ((rob[head][1] == 5'b0) && (rob[head][0] == 5'b1)) ? head: 5'bx;

  reg [3:0] head;
  reg [3:0] tail;

  //head and tail out of bounds checking
  //calculate the number of entries based on tail and head pointers
  wire [3:0] num_entries = (tail[3] ^ head[3]) ? {1'b1, tail - head} 
  :                                        tail - head; 

  //maximum number of entries is 16
  wire full = (num_entries > 16);
  integer i;
  reg [4:0] rob [15:0][2:0];
  always @(posedge clk) begin
    if (reset) begin
      head <= 5'b0;
      tail <= 5'b0;
      for (i=0; i < 16; i++) begin
        rob[i][0] <= 5'b0; 
        rob[i][1] <= 5'b0; 
      end
    end
    else begin
      //insert something to the rob
      if (rob_alloc_req_val && (rob[tail][0] == 5'b0)) begin
        rob[tail][0] <= 5'b1; //setting the valid bit
        rob[tail][1] <= 5'b1; //setting the pending bit
        rob[tail][2] <= rob_alloc_req_preg; //setting the physical register 
        tail <= tail + 4'd1; //increment the tail to the next entry
      end
      //fill slot
      if (rob_fill_val && rob[rob_fill_slot][0] && rob[rob_fill_slot][1]) begin
        rob[rob_fill_slot][1] <= 5'b0; //set to no longer pending
      end
      // commit the head entry
      if ((rob[head][1] == 5'b0) && (rob[head][0] == 5'b1)) begin
        head <= head + 4'd1; //increment the head to the next entry
        rob[head][0] <= 5'b0; //invalidate the entry
      end
    end
  end

endmodule

`endif