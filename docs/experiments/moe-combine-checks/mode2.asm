
/home/rkuo/research/llm-weight-compression/_meta/maya-moe-combine-20261021/kernels-gfx1201.elf:	file format elf64-amdgpu

Disassembly of section .text:

000000000002cb00 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii>:
	s_clause 0x1                                               // 00000002CB00: BF850001
	s_load_b32 s2, s[0:1], 0x3c                                // 00000002CB04: F4000080 F800003C
	s_load_b96 s[8:10], s[0:1], 0x20                           // 00000002CB0C: F400A200 F8000020
	s_wait_kmcnt 0x0                                           // 00000002CB14: BFC70000
	s_and_b32 s2, s2, 0xffff                                   // 00000002CB18: 8B02FF02 0000FFFF
	s_delay_alu instid0(SALU_CYCLE_1)                          // 00000002CB20: BF870009
	v_mad_co_u64_u32 v[0:1], null, ttmp9, s2, v[0:1]           // 00000002CB24: D6FE7C00 04000475
	s_mov_b32 s2, exec_lo                                      // 00000002CB2C: BE82007E
	v_cmpx_gt_i32_e64 s10, v0                                  // 00000002CB30: D4C4007E 0202000A
	s_cbranch_execz 132                                        // 00000002CB38: BFA50084 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x24c>
	s_load_b256 s[0:7], s[0:1], 0x0                            // 00000002CB3C: F4006000 F8000000
	s_mov_b32 s18, ttmp7                                       // 00000002CB44: BE920073
	s_ashr_i32 s19, ttmp7, 31                                  // 00000002CB48: 86139F73
	s_delay_alu instid0(SALU_CYCLE_1)                          // 00000002CB4C: BF870009
	s_lshl_b64 s[16:17], s[18:19], 5                           // 00000002CB50: 84908512
	s_wait_kmcnt 0x0                                           // 00000002CB54: BFC70000
	s_add_nc_u64 s[4:5], s[4:5], s[16:17]                      // 00000002CB58: A9841004
	s_clause 0x1                                               // 00000002CB5C: BF850001
	s_load_b128 s[12:15], s[4:5], 0x0                          // 00000002CB60: F4004302 F8000000
	s_load_b64 s[4:5], s[4:5], 0x10                            // 00000002CB68: F4002102 F8000010
	s_wait_kmcnt 0x0                                           // 00000002CB70: BFC70000
	s_cmp_lt_i32 s12, s8                                       // 00000002CB74: BF04080C
	s_cselect_b32 s11, -1, 0                                   // 00000002CB78: 980B80C1
	s_cmp_ge_i32 s12, s9                                       // 00000002CB7C: BF03090C
	s_cselect_b32 s20, -1, 0                                   // 00000002CB80: 981480C1
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CB84: BF88FF9E
	s_or_b32 s24, s11, s20                                     // 00000002CB88: 8C18140B
	s_cmp_lt_i32 s13, s8                                       // 00000002CB8C: BF04080D
	s_cselect_b32 s11, -1, 0                                   // 00000002CB90: 980B80C1
	s_cmp_ge_i32 s13, s9                                       // 00000002CB94: BF03090D
	s_cselect_b32 s20, -1, 0                                   // 00000002CB98: 981480C1
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CB9C: BF88FF9E
	s_or_b32 s23, s11, s20                                     // 00000002CBA0: 8C17140B
	s_cmp_lt_i32 s14, s8                                       // 00000002CBA4: BF04080E
	s_cselect_b32 s11, -1, 0                                   // 00000002CBA8: 980B80C1
	s_cmp_ge_i32 s14, s9                                       // 00000002CBAC: BF03090E
	s_cselect_b32 s20, -1, 0                                   // 00000002CBB0: 981480C1
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CBB4: BF88FF9E
	s_or_b32 s22, s11, s20                                     // 00000002CBB8: 8C16140B
	s_cmp_lt_i32 s15, s8                                       // 00000002CBBC: BF04080F
	s_cselect_b32 s11, -1, 0                                   // 00000002CBC0: 980B80C1
	s_cmp_ge_i32 s15, s9                                       // 00000002CBC4: BF03090F
	s_cselect_b32 s20, -1, 0                                   // 00000002CBC8: 981480C1
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CBCC: BF88FF9E
	s_or_b32 s21, s11, s20                                     // 00000002CBD0: 8C15140B
	s_cmp_lt_i32 s4, s8                                        // 00000002CBD4: BF040804
	s_cselect_b32 s11, -1, 0                                   // 00000002CBD8: 980B80C1
	s_cmp_ge_i32 s4, s9                                        // 00000002CBDC: BF030904
	s_cselect_b32 s20, -1, 0                                   // 00000002CBE0: 981480C1
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CBE4: BF88FF9E
	s_or_b32 s20, s11, s20                                     // 00000002CBE8: 8C14140B
	s_cmp_lt_i32 s5, s8                                        // 00000002CBEC: BF040805
	s_cselect_b32 s11, -1, 0                                   // 00000002CBF0: 980B80C1
	s_cmp_ge_i32 s5, s9                                        // 00000002CBF4: BF030905
	s_cselect_b32 s9, -1, 0                                    // 00000002CBF8: 980980C1
	s_and_b32 s25, s24, s23                                    // 00000002CBFC: 8B191718
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CC00: BF88FF9E
	s_or_b32 s9, s11, s9                                       // 00000002CC04: 8C09090B
	s_and_b32 s25, s25, s22                                    // 00000002CC08: 8B191619
	s_delay_alu instid0(SALU_CYCLE_1)                          // 00000002CC0C: BF870009
	s_and_b32 s11, s25, s21                                    // 00000002CC10: 8B0B1519
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CC14: BF88FF9E
	s_and_b32 s11, s11, s9                                     // 00000002CC18: 8B0B090B
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CC1C: BF88FF9E
	s_and_b32 s11, s11, s20                                    // 00000002CC20: 8B0B140B
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CC24: BF88FF9E
	s_and_b32 vcc_lo, exec_lo, s11                             // 00000002CC28: 8B6A0B7E
	s_cbranch_vccnz 71                                         // 00000002CC2C: BFA40047 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x24c>
	v_ashrrev_i32_e32 v1, 31, v0                               // 00000002CC30: 3402009F
	s_ashr_i32 s11, s10, 31                                    // 00000002CC34: 860B9F0A
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CC38: BF88FF9E
	s_mul_u64 s[18:19], s[10:11], s[18:19]                     // 00000002CC3C: AA92120A
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(VALU_DEP_1)// 00000002CC40: BF8700C9
	s_lshl_b64 s[18:19], s[18:19], 2                           // 00000002CC44: 84928212
	v_lshlrev_b64_e32 v[3:4], 2, v[0:1]                        // 00000002CC48: 3E060082
	s_add_nc_u64 s[0:1], s[0:1], s[18:19]                      // 00000002CC4C: A9801200
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CC50: BF88FF9E
	v_add_co_u32 v0, vcc_lo, s0, v3                            // 00000002CC54: D7006A00 02020600
	s_delay_alu instid0(VALU_DEP_1)                            // 00000002CC5C: BF870001
	v_add_co_ci_u32_e64 v1, null, s1, v4, vcc_lo               // 00000002CC60: D5207C01 01AA0801
	v_add_co_u32 v3, vcc_lo, s2, v3                            // 00000002CC68: D7006A03 02020602
	s_wait_alu depctr_va_vcc(0)                                // 00000002CC70: BF88FF9D
	v_add_co_ci_u32_e64 v4, null, s3, v4, vcc_lo               // 00000002CC74: D5207C04 01AA0803
	global_load_b32 v2, v[0:1], off                            // 00000002CC7C: EE05007C 00000002 00000000
	s_xor_b32 s0, s24, -1                                      // 00000002CC88: 8D00C118
	s_xor_b32 s2, s23, -1                                      // 00000002CC8C: 8D02C117
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CC90: BF88FF9E
	s_and_not1_b32 vcc_lo, exec_lo, s0                         // 00000002CC94: 916A007E
	s_add_nc_u64 s[0:1], s[6:7], s[16:17]                      // 00000002CC98: A9801006
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CC9C: BF88FF9E
	s_cbranch_vccz 43                                          // 00000002CCA0: BFA3002B <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x250>
	s_and_not1_b32 vcc_lo, exec_lo, s2                         // 00000002CCA4: 916A027E
	s_xor_b32 s2, s22, -1                                      // 00000002CCA8: 8D02C116
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CCAC: BF88FF9E
	s_cbranch_vccz 61                                          // 00000002CCB0: BFA3003D <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x2a8>
	s_and_not1_b32 vcc_lo, exec_lo, s2                         // 00000002CCB4: 916A027E
	s_xor_b32 s2, s21, -1                                      // 00000002CCB8: 8D02C115
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CCBC: BF88FF9E
	s_cbranch_vccz 80                                          // 00000002CCC0: BFA30050 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x304>
	s_and_not1_b32 vcc_lo, exec_lo, s2                         // 00000002CCC4: 916A027E
	s_xor_b32 s2, s20, -1                                      // 00000002CCC8: 8D02C114
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CCCC: BF88FF9E
	s_cbranch_vccz 99                                          // 00000002CCD0: BFA30063 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x360>
	s_and_not1_b32 vcc_lo, exec_lo, s2                         // 00000002CCD4: 916A027E
	s_xor_b32 s2, s9, -1                                       // 00000002CCD8: 8D02C109
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CCDC: BF88FF9E
	s_cbranch_vccz 118                                         // 00000002CCE0: BFA30076 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x3bc>
	s_and_not1_b32 vcc_lo, exec_lo, s2                         // 00000002CCE4: 916A027E
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CCE8: BF88FF9E
	s_cbranch_vccnz 19                                         // 00000002CCEC: BFA40013 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x23c>
	s_sub_co_i32 s2, s5, s8                                    // 00000002CCF0: 81820805
	s_mov_b32 s3, 0                                            // 00000002CCF4: BE830080
	s_load_b32 s0, s[0:1], 0x14                                // 00000002CCF8: F4000000 F8000014
	s_mul_u64 s[2:3], s[2:3], s[10:11]                         // 00000002CD00: AA820A02
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CD04: BF88FF9E
	s_lshl_b64 s[2:3], s[2:3], 2                               // 00000002CD08: 84828202
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CD0C: BF88FF9E
	v_add_co_u32 v3, vcc_lo, v3, s2                            // 00000002CD10: D7006A03 02000503
	s_wait_alu depctr_va_vcc(0)                                // 00000002CD18: BF88FF9D
	v_add_co_ci_u32_e64 v4, null, s3, v4, vcc_lo               // 00000002CD1C: D5207C04 01AA0803
	global_load_b32 v3, v[3:4], off                            // 00000002CD24: EE05007C 00000003 00000003
	s_wait_loadcnt 0x0                                         // 00000002CD30: BFC00000
	s_wait_kmcnt 0x0                                           // 00000002CD34: BFC70000
	v_fmac_f32_e32 v2, s0, v3                                  // 00000002CD38: 56040600
	s_wait_loadcnt 0x0                                         // 00000002CD3C: BFC00000
	global_store_b32 v[0:1], v2, off                           // 00000002CD40: EE06807C 01000000 00000000
	s_endpgm                                                   // 00000002CD4C: BFB00000
	s_sub_co_i32 s6, s12, s8                                   // 00000002CD50: 8186080C
	s_mov_b32 s7, 0                                            // 00000002CD54: BE870080
	s_load_b32 s3, s[0:1], 0x0                                 // 00000002CD58: F40000C0 F8000000
	s_mul_u64 s[6:7], s[6:7], s[10:11]                         // 00000002CD60: AA860A06
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)// 00000002CD64: BF870499
	s_lshl_b64 s[6:7], s[6:7], 2                               // 00000002CD68: 84868206
	v_add_co_u32 v5, vcc_lo, v3, s6                            // 00000002CD6C: D7006A05 02000D03
	s_wait_alu depctr_va_vcc(0)                                // 00000002CD74: BF88FF9D
	v_add_co_ci_u32_e64 v6, null, s7, v4, vcc_lo               // 00000002CD78: D5207C06 01AA0807
	global_load_b32 v5, v[5:6], off                            // 00000002CD80: EE05007C 00000005 00000005
	s_wait_loadcnt 0x0                                         // 00000002CD8C: BFC00000
	s_wait_kmcnt 0x0                                           // 00000002CD90: BFC70000
	v_fmac_f32_e32 v2, s3, v5                                  // 00000002CD94: 56040A03
	s_and_not1_b32 vcc_lo, exec_lo, s2                         // 00000002CD98: 916A027E
	s_xor_b32 s2, s22, -1                                      // 00000002CD9C: 8D02C116
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CDA0: BF88FF9E
	s_cbranch_vccnz 65475                                      // 00000002CDA4: BFA4FFC3 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x1b4>
	s_sub_co_i32 s6, s13, s8                                   // 00000002CDA8: 8186080D
	s_mov_b32 s7, 0                                            // 00000002CDAC: BE870080
	s_load_b32 s3, s[0:1], 0x4                                 // 00000002CDB0: F40000C0 F8000004
	s_mul_u64 s[6:7], s[6:7], s[10:11]                         // 00000002CDB8: AA860A06
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CDBC: BF88FF9E
	s_lshl_b64 s[6:7], s[6:7], 2                               // 00000002CDC0: 84868206
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CDC4: BF88FF9E
	v_add_co_u32 v5, vcc_lo, v3, s6                            // 00000002CDC8: D7006A05 02000D03
	s_wait_alu depctr_va_vcc(0)                                // 00000002CDD0: BF88FF9D
	v_add_co_ci_u32_e64 v6, null, s7, v4, vcc_lo               // 00000002CDD4: D5207C06 01AA0807
	global_load_b32 v5, v[5:6], off                            // 00000002CDDC: EE05007C 00000005 00000005
	s_wait_loadcnt 0x0                                         // 00000002CDE8: BFC00000
	s_wait_kmcnt 0x0                                           // 00000002CDEC: BFC70000
	v_fmac_f32_e32 v2, s3, v5                                  // 00000002CDF0: 56040A03
	s_and_not1_b32 vcc_lo, exec_lo, s2                         // 00000002CDF4: 916A027E
	s_xor_b32 s2, s21, -1                                      // 00000002CDF8: 8D02C115
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CDFC: BF88FF9E
	s_cbranch_vccnz 65456                                      // 00000002CE00: BFA4FFB0 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x1c4>
	s_sub_co_i32 s6, s14, s8                                   // 00000002CE04: 8186080E
	s_mov_b32 s7, 0                                            // 00000002CE08: BE870080
	s_load_b32 s3, s[0:1], 0x8                                 // 00000002CE0C: F40000C0 F8000008
	s_mul_u64 s[6:7], s[6:7], s[10:11]                         // 00000002CE14: AA860A06
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CE18: BF88FF9E
	s_lshl_b64 s[6:7], s[6:7], 2                               // 00000002CE1C: 84868206
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CE20: BF88FF9E
	v_add_co_u32 v5, vcc_lo, v3, s6                            // 00000002CE24: D7006A05 02000D03
	s_wait_alu depctr_va_vcc(0)                                // 00000002CE2C: BF88FF9D
	v_add_co_ci_u32_e64 v6, null, s7, v4, vcc_lo               // 00000002CE30: D5207C06 01AA0807
	global_load_b32 v5, v[5:6], off                            // 00000002CE38: EE05007C 00000005 00000005
	s_wait_loadcnt 0x0                                         // 00000002CE44: BFC00000
	s_wait_kmcnt 0x0                                           // 00000002CE48: BFC70000
	v_fmac_f32_e32 v2, s3, v5                                  // 00000002CE4C: 56040A03
	s_and_not1_b32 vcc_lo, exec_lo, s2                         // 00000002CE50: 916A027E
	s_xor_b32 s2, s20, -1                                      // 00000002CE54: 8D02C114
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CE58: BF88FF9E
	s_cbranch_vccnz 65437                                      // 00000002CE5C: BFA4FF9D <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x1d4>
	s_sub_co_i32 s6, s15, s8                                   // 00000002CE60: 8186080F
	s_mov_b32 s7, 0                                            // 00000002CE64: BE870080
	s_load_b32 s3, s[0:1], 0xc                                 // 00000002CE68: F40000C0 F800000C
	s_mul_u64 s[6:7], s[6:7], s[10:11]                         // 00000002CE70: AA860A06
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CE74: BF88FF9E
	s_lshl_b64 s[6:7], s[6:7], 2                               // 00000002CE78: 84868206
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CE7C: BF88FF9E
	v_add_co_u32 v5, vcc_lo, v3, s6                            // 00000002CE80: D7006A05 02000D03
	s_wait_alu depctr_va_vcc(0)                                // 00000002CE88: BF88FF9D
	v_add_co_ci_u32_e64 v6, null, s7, v4, vcc_lo               // 00000002CE8C: D5207C06 01AA0807
	global_load_b32 v5, v[5:6], off                            // 00000002CE94: EE05007C 00000005 00000005
	s_wait_loadcnt 0x0                                         // 00000002CEA0: BFC00000
	s_wait_kmcnt 0x0                                           // 00000002CEA4: BFC70000
	v_fmac_f32_e32 v2, s3, v5                                  // 00000002CEA8: 56040A03
	s_and_not1_b32 vcc_lo, exec_lo, s2                         // 00000002CEAC: 916A027E
	s_xor_b32 s2, s9, -1                                       // 00000002CEB0: 8D02C109
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CEB4: BF88FF9E
	s_cbranch_vccnz 65418                                      // 00000002CEB8: BFA4FF8A <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x1e4>
	s_sub_co_i32 s6, s4, s8                                    // 00000002CEBC: 81860804
	s_mov_b32 s7, 0                                            // 00000002CEC0: BE870080
	s_load_b32 s3, s[0:1], 0x10                                // 00000002CEC4: F40000C0 F8000010
	s_mul_u64 s[6:7], s[6:7], s[10:11]                         // 00000002CECC: AA860A06
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CED0: BF88FF9E
	s_lshl_b64 s[6:7], s[6:7], 2                               // 00000002CED4: 84868206
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CED8: BF88FF9E
	v_add_co_u32 v5, vcc_lo, v3, s6                            // 00000002CEDC: D7006A05 02000D03
	s_wait_alu depctr_va_vcc(0)                                // 00000002CEE4: BF88FF9D
	v_add_co_ci_u32_e64 v6, null, s7, v4, vcc_lo               // 00000002CEE8: D5207C06 01AA0807
	global_load_b32 v5, v[5:6], off                            // 00000002CEF0: EE05007C 00000005 00000005
	s_wait_loadcnt 0x0                                         // 00000002CEFC: BFC00000
	s_wait_kmcnt 0x0                                           // 00000002CF00: BFC70000
	v_fmac_f32_e32 v2, s3, v5                                  // 00000002CF04: 56040A03
	s_and_not1_b32 vcc_lo, exec_lo, s2                         // 00000002CF08: 916A027E
	s_wait_alu depctr_sa_sdst(0)                               // 00000002CF0C: BF88FF9E
	s_cbranch_vccz 65399                                       // 00000002CF10: BFA3FF77 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x1f0>
	s_branch 65417                                             // 00000002CF14: BFA0FF89 <_ZN6strata3ds412_GLOBAL__N_119moe_combine6_kernelEPfPKfPKiS4_iii+0x23c>
