# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Mon Feb 26 15:53:48 2024
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 59 signals
# End_DVE_Session_Save_Info

# DVE version: O-2018.09-SP2_Full64
# DVE build date: Feb 28 2019 23:39:41


#<Session mode="View" path="/home/os6536/ece475/ece475-lab2/build/session.riscv-sub.vcd.vpd.tcl" type="Debug">

#<Database>

gui_set_time_units 1s
#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Mon Feb 26 15:53:48 2024
# 59 signals
# End_DVE_Session_Save_Info

# DVE version: O-2018.09-SP2_Full64
# DVE build date: Feb 28 2019 23:39:41


#Add ncecessay scopes
gui_load_child_values {riscv_sim.proc.dpath.rfile}
gui_load_child_values {riscv_sim.proc}
gui_load_child_values {riscv_sim.mem.mem}

gui_set_time_units 1s

set _wave_session_group_1 Group1
if {[gui_sg_is_group -name "$_wave_session_group_1"]} {
    set _wave_session_group_1 [gui_sg_generate_new_name]
}
set Group1 "$_wave_session_group_1"

gui_sg_addsignal -group "$_wave_session_group_1" { {V1:riscv_sim.mem.mem.clk} {V1:riscv_sim.mem.memreq0_val} {V1:riscv_sim.mem.memreq1_val} {V1:riscv_sim.proc.ctrl.inst_is_load_Xhl} {V1:riscv_sim.proc.ctrl.byp0_mux_sel_Dhl} {V1:riscv_sim.proc.ctrl.op1_mux_sel_Dhl} {V1:riscv_sim.proc.ctrl.byp1_mux_sel_Dhl} {V1:riscv_sim.proc.ctrl.cs} {V1:riscv_sim.proc.ctrl.ir_Dhl} {V1:riscv_sim.proc.ctrl.imemresp_queue_mux_out_Fhl} {V1:riscv_sim.proc.ctrl.imemresp_queue_val_Fhl} {V1:riscv_sim.proc.ctrl.imemresp_msg_data} {V1:riscv_sim.proc.ctrl.imemreq_val} {V1:riscv_sim.proc.ctrl.stall_Dhl} {V1:riscv_sim.proc.imemreq_msg_addr} {V1:riscv_sim.proc.pc_mux_sel_Phl} {V1:riscv_sim.proc.ctrl.brj_taken_Xhl} {V1:riscv_sim.proc.ctrl.any_br_taken_Xhl} {V1:riscv_sim.proc.ctrl.br_sel_Xhl} {V1:riscv_sim.proc.dpath.branch_cond_ne_Xhl} {V1:riscv_sim.proc.dpath.byp0_mux_sel_Dhl} {V1:riscv_sim.proc.ctrl.rs1_M_byp_Dhl} {V1:riscv_sim.proc.ctrl.rs1_W_byp_Dhl} {V1:riscv_sim.proc.ctrl.rs1_X_byp_Dhl} {V1:riscv_sim.proc.ctrl.rs1_byp_Dhl} {V1:riscv_sim.proc.ctrl.rs2_M_byp_Dhl} {V1:riscv_sim.proc.ctrl.rs2_W_byp_Dhl} {V1:riscv_sim.proc.ctrl.rs2_X_byp_Dhl} {V1:riscv_sim.proc.ctrl.rs2_byp_Dhl} {V1:riscv_sim.proc.dpath.byp0_mux_out_Dhl} {V1:riscv_sim.proc.dpath.rf_rdata0_Dhl} {V1:riscv_sim.proc.dpath.rf_raddr0_Dhl} {V1:riscv_sim.proc.ctrl.op0_mux_sel_Dhl} {V1:riscv_sim.proc.dpath.op0_mux_out_Dhl} {V1:riscv_sim.proc.dpath.op1_mux_sel_Dhl} {V1:riscv_sim.proc.dpath.op1_mux_out_Dhl} {V1:riscv_sim.proc.dpath.op1_mux_out_Xhl} {V1:riscv_sim.proc.dpath.op0_mux_out_Xhl} {V1:riscv_sim.proc.ctrl.brj_taken_Dhl} {V1:riscv_sim.proc.ctrl.inst_val_Fhl} {V1:riscv_sim.proc.ctrl.inst_val_Dhl} {V1:riscv_sim.proc.ctrl.inst_val_Xhl} {V1:riscv_sim.proc.ctrl.bubble_Fhl} {V1:riscv_sim.proc.ctrl.squash_Fhl} {V1:riscv_sim.proc.ctrl.dmemreq_val} {V1:riscv_sim.proc.ctrl.inst_is_load_Xhl} {V1:riscv_sim.proc.ctrl.dmemreq_msg_rw_Dhl} {V1:riscv_sim.proc.ctrl.stall_hazard_Dhl} {V1:riscv_sim.proc.dpath.rfile.raddr0} {V1:riscv_sim.proc.dpath.rfile.rdata0} {V1:riscv_sim.proc.dpath.rfile.wen_p} {V1:riscv_sim.proc.dpath.rfile.waddr_p} {V1:riscv_sim.proc.dpath.rfile.wdata_p} {V1:riscv_sim.proc.dpath.wb_mux_out_Whl} {V1:riscv_sim.proc.dpath.wb_mux_sel_Mhl} {V1:riscv_sim.proc.dpath.alu_out_Xhl} {V1:riscv_sim.proc.dpath.execute_mux_out_Mhl} {V1:riscv_sim.proc.dpath.execute_mux_out_Xhl} {V1:riscv_sim.proc.dpath.execute_mux_sel_Xhl} }
if {![info exists useOldWindow]} { 
	set useOldWindow true
}
if {$useOldWindow && [string first "Wave" [gui_get_current_window -view]]==0} { 
	set Wave.1 [gui_get_current_window -view] 
} else {
	set Wave.1 [lindex [gui_get_window_ids -type Wave] 0]
if {[string first "Wave" ${Wave.1}]!=0} {
gui_open_window Wave
set Wave.1 [ gui_get_current_window -view ]
}
}

set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 324 596
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group1}]
gui_list_select -id ${Wave.1} {riscv_sim.proc.ctrl.inst_val_Dhl }
gui_seek_criteria -id ${Wave.1} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group ${Group1}  -item riscv_sim.proc.ctrl.rs2_byp_Dhl -position below

gui_marker_move -id ${Wave.1} {C1} 505
gui_view_scroll -id ${Wave.1} -vertical -set 225
gui_show_grid -id ${Wave.1} -enable false
#</Session>

