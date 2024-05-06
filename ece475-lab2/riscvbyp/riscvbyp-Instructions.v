module riscv_Instructions (
    input [31:0]    instr,
    output          type_add_instr,
    output          type_sub_instr,
    output          type_sll_instr,
    output          type_slt_instr,
    output          type_sltu_instr,
    output          type_xor_instr,
    output          type_srl_instr,
    output          type_sra_instr,
    output          type_or_instr,
    output          type_and_instr,
    output          type_mul_instr, 
    output          type_div_instr, 
    output          type_divu_instr, 
    output          type_rem_instr, 
    output          type_remu_instr, 
    output          type_addi_instr,
    output          type_slti_instr,
    output          type_sltiu_instr,
    output          type_xori_instr,
    output          type_ori_instr,
    output          type_andi_instr,
    output          type_slli_instr,
    output          type_srli_instr,
    output          type_srai_instr,
    output          type_lw_instr,
    output          type_lb_instr,
    output          type_lh_instr,
    output          type_lbu_instr,
    output          type_lhu_instr,
    output          type_sw_instr,
    output          type_sb_instr,
    output          type_sh_instr,
    output          type_beq_instr,
    output          type_bne_instr,
    output          type_blt_instr,
    output          type_bge_instr,
    output          type_bltu_instr,
    output          type_bgeu_instr,
    output          type_jal_instr,
    output          type_jalr_instr
);

// ALU R-type
assign type_add_instr = (instr[31:25] == 7'b0)       && (instr[14:12] == 3'b0)   && (instr[6:0] == 7'b0110011);
assign type_sub_instr = (instr[31:25] == 7'b0100000) && (instr[14:12] == 3'b0)   && (instr[6:0] == 7'b0110011);
assign type_sll_instr = (instr[31:25] == 7'b0)       && (instr[14:12] == 3'b001) && (instr[6:0] == 7'b0110011);
assign type_slt_instr = (instr[31:25] == 7'b0)       && (instr[14:12] == 3'b010) && (instr[6:0] == 7'b0110011);
assign type_sltu_instr = (instr[31:25] == 7'b0)      && (instr[14:12] == 3'b011) && (instr[6:0] == 7'b0110011);
assign type_xor_instr = (instr[31:25] == 7'b0)       && (instr[14:12] == 3'b100) && (instr[6:0] == 7'b0110011);
assign type_srl_instr = (instr[31:25] == 7'b0)       && (instr[14:12] == 3'b101) && (instr[6:0] == 7'b0110011);
assign type_sra_instr = (instr[31:25] == 7'b0100000) && (instr[14:12] == 3'b101) && (instr[6:0] == 7'b0110011);
assign type_or_instr = (instr[31:25] == 7'b0)        && (instr[14:12] == 3'b110) && (instr[6:0] == 7'b0110011);
assign type_and_instr = (instr[31:25] == 7'b0)       && (instr[14:12] == 3'b111) && (instr[6:0] == 7'b0110011);
assign type_mul_instr = (instr[31:25] == 7'b0000001) && (instr[14:12] == 3'b000) && (instr[6:0] == 7'b0110011);
assign type_div_instr = (instr[31:25] == 7'b0000001) && (instr[14:12] == 3'b100) && (instr[6:0] == 7'b0110011);
assign type_divu_instr = (instr[31:25] == 7'b0000001) && (instr[14:12] == 3'b101) && (instr[6:0] == 7'b0110011);
assign type_rem_instr = (instr[31:25] == 7'b0000001) && (instr[14:12] == 3'b110) && (instr[6:0] == 7'b0110011);
assign type_remu_instr = (instr[31:25] == 7'b0000001) && (instr[14:12] == 3'b111) && (instr[6:0] == 7'b0110011);

// ALU I-type
assign type_addi_instr = (instr[14:12] == 3'b0)  && (instr[6:0] == 7'b0010011);
assign type_slti_instr = (instr[14:12] == 3'b010)  && (instr[6:0] == 7'b0010011);
assign type_sltiu_instr = (instr[14:12] == 3'b011)  && (instr[6:0] == 7'b0010011);
assign type_xori_instr = (instr[14:12] == 3'b100)  && (instr[6:0] == 7'b0010011);
assign type_ori_instr = (instr[14:12] == 3'b110)  && (instr[6:0] == 7'b0010011);
assign type_andi_instr = (instr[14:12] == 3'b111)  && (instr[6:0] == 7'b0010011);
assign type_slli_instr = (instr[31:25] == 7'b0) && (instr[14:12] == 3'b001)  && (instr[6:0] == 7'b0010011);
assign type_srli_instr = (instr[31:25] == 7'b0) && (instr[14:12] == 3'b101)  && (instr[6:0] == 7'b0010011);
assign type_srai_instr = (instr[31:25] == 7'b0100000) && (instr[14:12] == 3'b101)  && (instr[6:0] == 7'b0010011);

// Load
assign type_lw_instr = (instr[14:12] == 3'b010) && (instr[6:0] == 7'b0000011);
assign type_lb_instr = (instr[14:12] == 3'b000) && (instr[6:0] == 7'b0000011);
assign type_lh_instr = (instr[14:12] == 3'b001) && (instr[6:0] == 7'b0000011);
assign type_lbu_instr = (instr[14:12] == 3'b100) && (instr[6:0] == 7'b0000011);
assign type_lhu_instr = (instr[14:12] == 3'b101) && (instr[6:0] == 7'b0000011);

// Store
assign type_sw_instr = (instr[14:12] == 3'b010) && (instr[6:0] == 7'b0100011);
assign type_sb_instr = (instr[14:12] == 3'b000) && (instr[6:0] == 7'b0100011);
assign type_sh_instr = (instr[14:12] == 3'b001) && (instr[6:0] == 7'b0100011);

// Branch
assign type_beq_instr = (instr[14:12] == 3'b000) && (instr[6:0] == 7'b1100011 );
assign type_bne_instr = (instr[14:12] == 3'b001) && (instr[6:0] == 7'b1100011 );
assign type_blt_instr = (instr[14:12] == 3'b100) && (instr[6:0] == 7'b1100011 );
assign type_bge_instr = (instr[14:12] == 3'b101) && (instr[6:0] == 7'b1100011 );
assign type_bltu_instr = (instr[14:12] == 3'b110) && (instr[6:0] == 7'b1100011 );
assign type_bgeu_instr = (instr[14:12] == 3'b111) && (instr[6:0] == 7'b1100011 );

// Jal and Jalr
assign type_jal_instr = ( instr[6:0] == 7'b1101111 );  
assign type_jalr_instr = ( (instr[14:12] == 3'b0) && (instr[6:0] == 7'b1100111) );  

endmodule