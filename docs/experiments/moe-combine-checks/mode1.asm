
/home/rkuo/research/llm-weight-compression/_meta/maya-moe-combine-20261021/kernels-gfx1201.elf:	file format elf64-amdgpu

Disassembly of section .text:

0000000000032700 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb1EEEvPfPKfPKiS5_iiii>:
	s_clause 0x1                                               // 000000032700: BF850001
	s_load_b32 s2, s[0:1], 0x3c                                // 000000032704: F4000080 F800003C
	s_load_b128 s[8:11], s[0:1], 0x20                          // 00000003270C: F4004200 F8000020
	s_wait_kmcnt 0x0                                           // 000000032714: BFC70000
	s_and_b32 s2, s2, 0xffff                                   // 000000032718: 8B02FF02 0000FFFF
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000032720: BF870009
	v_mad_co_u64_u32 v[0:1], null, ttmp9, s2, v[0:1]           // 000000032724: D6FE7C00 04000475
	s_mov_b32 s2, exec_lo                                      // 00000003272C: BE82007E
	v_cmpx_gt_i32_e64 s11, v0                                  // 000000032730: D4C4007E 0202000B
	s_cbranch_execz 105                                        // 000000032738: BFA50069 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb1EEEvPfPKfPKiS5_iiii+0x1e0>
	s_load_b256 s[0:7], s[0:1], 0x0                            // 00000003273C: F4006000 F8000000
	v_ashrrev_i32_e32 v1, 31, v0                               // 000000032744: 3402009F
	s_cmp_lt_i32 s8, 1                                         // 000000032748: BF048108
	s_cbranch_scc1 73                                          // 00000003274C: BFA20049 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb1EEEvPfPKfPKiS5_iiii+0x174>
	s_mov_b32 s14, ttmp7                                       // 000000032750: BE8E0073
	s_ashr_i32 s15, ttmp7, 31                                  // 000000032754: 860F9F73
	s_ashr_i32 s13, s11, 31                                    // 000000032758: 860D9F0B
	s_mov_b32 s12, s11                                         // 00000003275C: BE8C000B
	v_lshlrev_b64_e32 v[5:6], 2, v[0:1]                        // 000000032760: 3E0A0082
	s_mul_u64 s[16:17], s[12:13], s[14:15]                     // 000000032764: AA900E0C
	v_mov_b32_e32 v4, 0                                        // 000000032768: 7E080280
	s_lshl_b64 s[16:17], s[16:17], 2                           // 00000003276C: 84908210
	s_lshl_b64 s[14:15], s[14:15], 5                           // 000000032770: 848E850E
	s_wait_kmcnt 0x0                                           // 000000032774: BFC70000
	s_add_nc_u64 s[16:17], s[0:1], s[16:17]                    // 000000032778: A9901000
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 00000003277C: BF870099
	v_add_co_u32 v2, vcc_lo, s16, v5                           // 000000032780: D7006A02 02020A10
	v_add_co_ci_u32_e64 v3, null, s17, v6, vcc_lo              // 000000032788: D5207C03 01AA0C11
	v_add_co_u32 v5, vcc_lo, s2, v5                            // 000000032790: D7006A05 02020A02
	s_wait_alu depctr_va_vcc(0)                                // 000000032798: BF88FF9D
	v_add_co_ci_u32_e64 v6, null, s3, v6, vcc_lo               // 00000003279C: D5207C06 01AA0C03
	s_add_nc_u64 s[2:3], s[4:5], s[14:15]                      // 0000000327A4: A9820E04
	s_add_nc_u64 s[4:5], s[6:7], s[14:15]                      // 0000000327A8: A9840E06
	s_mov_b32 s6, 0                                            // 0000000327AC: BE860080
	s_branch 27                                                // 0000000327B0: BFA0001B <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb1EEEvPfPKfPKiS5_iiii+0x120>
	s_sub_co_i32 s6, s7, s9                                    // 0000000327B4: 81860907
	s_wait_alu depctr_sa_sdst(0)                               // 0000000327B8: BF88FF9E
	s_ashr_i32 s7, s6, 31                                      // 0000000327BC: 86079F06
	s_wait_alu depctr_sa_sdst(0)                               // 0000000327C0: BF88FF9E
	s_mul_u64 s[6:7], s[6:7], s[12:13]                         // 0000000327C4: AA860C06
	s_wait_alu depctr_sa_sdst(0)                               // 0000000327C8: BF88FF9E
	s_lshl_b64 s[6:7], s[6:7], 2                               // 0000000327CC: 84868206
	s_wait_alu depctr_sa_sdst(0)                               // 0000000327D0: BF88FF9E
	v_add_co_u32 v7, vcc_lo, v5, s6                            // 0000000327D4: D7006A07 02000D05
	s_wait_alu depctr_va_vcc(0)                                // 0000000327DC: BF88FF9D
	v_add_co_ci_u32_e64 v8, null, s7, v6, vcc_lo               // 0000000327E0: D5207C08 01AA0C07
	s_load_b32 s6, s[4:5], 0x0                                 // 0000000327E8: F4000182 F8000000
	global_load_b32 v7, v[7:8], off                            // 0000000327F0: EE05007C 00000007 00000007
	s_wait_loadcnt 0x0                                         // 0000000327FC: BFC00000
	s_wait_kmcnt 0x0                                           // 000000032800: BFC70000
	v_fmac_f32_e32 v4, s6, v7                                  // 000000032804: 56080E06
	s_mov_b32 s6, -1                                           // 000000032808: BE8600C1
	s_add_co_i32 s8, s8, -1                                    // 00000003280C: 8108C108
	s_add_nc_u64 s[2:3], s[2:3], 4                             // 000000032810: A9828402
	s_cmp_eq_u32 s8, 0                                         // 000000032814: BF068008
	s_add_nc_u64 s[4:5], s[4:5], 4                             // 000000032818: A9848404
	s_cbranch_scc1 24                                          // 00000003281C: BFA20018 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb1EEEvPfPKfPKiS5_iiii+0x180>
	s_load_b32 s7, s[2:3], 0x0                                 // 000000032820: F40001C1 F8000000
	s_wait_kmcnt 0x0                                           // 000000032828: BFC70000
	s_cmp_lt_i32 s7, s9                                        // 00000003282C: BF040907
	s_cselect_b32 s14, -1, 0                                   // 000000032830: 980E80C1
	s_cmp_ge_i32 s7, s10                                       // 000000032834: BF030A07
	s_cselect_b32 s15, -1, 0                                   // 000000032838: 980F80C1
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)// 00000003283C: BF870499
	s_or_b32 s14, s14, s15                                     // 000000032840: 8C0E0F0E
	s_and_b32 vcc_lo, exec_lo, s14                             // 000000032844: 8B6A0E7E
	s_wait_alu depctr_sa_sdst(0)                               // 000000032848: BF88FF9E
	s_cbranch_vccnz 65519                                      // 00000003284C: BFA4FFEF <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb1EEEvPfPKfPKiS5_iiii+0x10c>
	s_xor_b32 s6, s6, -1                                       // 000000032850: 8D06C106
	s_wait_alu depctr_sa_sdst(0)                               // 000000032854: BF88FF9E
	s_and_not1_b32 vcc_lo, exec_lo, s6                         // 000000032858: 916A067E
	s_wait_alu depctr_sa_sdst(0)                               // 00000003285C: BF88FF9E
	s_cbranch_vccnz 65492                                      // 000000032860: BFA4FFD4 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb1EEEvPfPKfPKiS5_iiii+0xb4>
	global_load_b32 v4, v[2:3], off                            // 000000032864: EE05007C 00000004 00000002
	s_branch 65488                                             // 000000032870: BFA0FFD0 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb1EEEvPfPKfPKiS5_iiii+0xb4>
	v_mov_b32_e32 v4, 0                                        // 000000032874: 7E080280
	s_wait_kmcnt 0x0                                           // 000000032878: BFC70000
	s_mov_b32 s6, 0                                            // 00000003287C: BE860080
	s_wait_alu depctr_sa_sdst(0)                               // 000000032880: BF88FF9E
	s_and_b32 vcc_lo, exec_lo, s6                              // 000000032884: 8B6A067E
	s_wait_alu depctr_sa_sdst(0)                               // 000000032888: BF88FF9E
	s_cbranch_vccz 20                                          // 00000003288C: BFA30014 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb1EEEvPfPKfPKiS5_iiii+0x1e0>
	s_mov_b32 s2, ttmp7                                        // 000000032890: BE820073
	s_ashr_i32 s3, ttmp7, 31                                   // 000000032894: 86039F73
	s_ashr_i32 s5, s11, 31                                     // 000000032898: 86059F0B
	s_mov_b32 s4, s11                                          // 00000003289C: BE84000B
	v_lshlrev_b64_e32 v[0:1], 2, v[0:1]                        // 0000000328A0: 3E000082
	s_wait_alu depctr_sa_sdst(0)                               // 0000000328A4: BF88FF9E
	s_mul_u64 s[2:3], s[4:5], s[2:3]                           // 0000000328A8: AA820204
	s_wait_alu depctr_sa_sdst(0)                               // 0000000328AC: BF88FF9E
	s_lshl_b64 s[2:3], s[2:3], 2                               // 0000000328B0: 84828202
	s_wait_alu depctr_sa_sdst(0)                               // 0000000328B4: BF88FF9E
	s_add_nc_u64 s[0:1], s[0:1], s[2:3]                        // 0000000328B8: A9800200
	s_wait_alu depctr_sa_sdst(0)                               // 0000000328BC: BF88FF9E
	v_add_co_u32 v0, vcc_lo, s0, v0                            // 0000000328C0: D7006A00 02020000
	s_wait_alu depctr_va_vcc(0)                                // 0000000328C8: BF88FF9D
	v_add_co_ci_u32_e64 v1, null, s1, v1, vcc_lo               // 0000000328CC: D5207C01 01AA0201
	global_store_b32 v[0:1], v4, off                           // 0000000328D4: EE06807C 02000000 00000000
	s_endpgm                                                   // 0000000328E0: BFB00000
