
/home/rkuo/research/llm-weight-compression/_meta/maya-moe-combine-20261021/kernels-gfx1201.elf:	file format elf64-amdgpu

Disassembly of section .text:

0000000000032900 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb0EEEvPfPKfPKiS5_iiii>:
	s_clause 0x1                                               // 000000032900: BF850001
	s_load_b32 s2, s[0:1], 0x3c                                // 000000032904: F4000080 F800003C
	s_load_b128 s[8:11], s[0:1], 0x20                          // 00000003290C: F4004200 F8000020
	s_wait_kmcnt 0x0                                           // 000000032914: BFC70000
	s_and_b32 s2, s2, 0xffff                                   // 000000032918: 8B02FF02 0000FFFF
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000032920: BF870009
	v_mad_co_u64_u32 v[0:1], null, ttmp9, s2, v[0:1]           // 000000032924: D6FE7C00 04000475
	s_mov_b32 s2, exec_lo                                      // 00000003292C: BE82007E
	v_cmpx_gt_i32_e64 s11, v0                                  // 000000032930: D4C4007E 0202000B
	s_cbranch_execz 83                                         // 000000032938: BFA50053 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb0EEEvPfPKfPKiS5_iiii+0x188>
	s_load_b256 s[0:7], s[0:1], 0x0                            // 00000003293C: F4006000 F8000000
	v_ashrrev_i32_e32 v1, 31, v0                               // 000000032944: 3402009F
	s_mov_b32 s12, s11                                         // 000000032948: BE8C000B
	s_mov_b32 s14, ttmp7                                       // 00000003294C: BE8E0073
	s_ashr_i32 s15, ttmp7, 31                                  // 000000032950: 860F9F73
	s_ashr_i32 s13, s11, 31                                    // 000000032954: 860D9F0B
	v_lshlrev_b64_e32 v[2:3], 2, v[0:1]                        // 000000032958: 3E040082
	s_mul_u64 s[16:17], s[12:13], s[14:15]                     // 00000003295C: AA900E0C
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000032960: BF870009
	s_lshl_b64 s[16:17], s[16:17], 2                           // 000000032964: 84908210
	s_cmp_lt_i32 s8, 1                                         // 000000032968: BF048108
	s_wait_kmcnt 0x0                                           // 00000003296C: BFC70000
	s_add_nc_u64 s[0:1], s[0:1], s[16:17]                      // 000000032970: A9801000
	s_wait_alu depctr_sa_sdst(0)                               // 000000032974: BF88FF9E
	v_add_co_u32 v0, vcc_lo, s0, v2                            // 000000032978: D7006A00 02020400
	s_delay_alu instid0(VALU_DEP_1)                            // 000000032980: BF870001
	v_add_co_ci_u32_e64 v1, null, s1, v3, vcc_lo               // 000000032984: D5207C01 01AA0601
	global_load_b32 v4, v[0:1], off                            // 00000003298C: EE05007C 00000004 00000000
	s_cbranch_scc1 50                                          // 000000032998: BFA20032 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb0EEEvPfPKfPKiS5_iiii+0x164>
	v_add_co_u32 v2, vcc_lo, s2, v2                            // 00000003299C: D7006A02 02020402
	s_wait_alu depctr_va_vcc(0)                                // 0000000329A4: BF88FF9D
	v_add_co_ci_u32_e64 v3, null, s3, v3, vcc_lo               // 0000000329A8: D5207C03 01AA0603
	s_lshl_b64 s[14:15], s[14:15], 5                           // 0000000329B0: 848E850E
	s_delay_alu instid0(SALU_CYCLE_1)                          // 0000000329B4: BF870009
	s_add_nc_u64 s[0:1], s[4:5], s[14:15]                      // 0000000329B8: A9800E04
	s_add_nc_u64 s[2:3], s[6:7], s[14:15]                      // 0000000329BC: A9820E06
	s_mov_b32 s5, 0                                            // 0000000329C0: BE850080
	s_mov_b32 s4, 0                                            // 0000000329C4: BE840080
	s_branch 5                                                 // 0000000329C8: BFA00005 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb0EEEvPfPKfPKiS5_iiii+0xe0>
	s_add_co_i32 s8, s8, -1                                    // 0000000329CC: 8108C108
	s_add_nc_u64 s[0:1], s[0:1], 4                             // 0000000329D0: A9808400
	s_cmp_eq_u32 s8, 0                                         // 0000000329D4: BF068008
	s_add_nc_u64 s[2:3], s[2:3], 4                             // 0000000329D8: A9828402
	s_cbranch_scc1 34                                          // 0000000329DC: BFA20022 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb0EEEvPfPKfPKiS5_iiii+0x168>
	s_load_b32 s6, s[0:1], 0x0                                 // 0000000329E0: F4000180 F8000000
	s_wait_kmcnt 0x0                                           // 0000000329E8: BFC70000
	s_cmp_lt_i32 s6, s9                                        // 0000000329EC: BF040906
	s_cselect_b32 s7, -1, 0                                    // 0000000329F0: 980780C1
	s_cmp_ge_i32 s6, s10                                       // 0000000329F4: BF030A06
	s_cselect_b32 s11, -1, 0                                   // 0000000329F8: 980B80C1
	s_wait_alu depctr_sa_sdst(0)                               // 0000000329FC: BF88FF9E
	s_or_b32 s7, s7, s11                                       // 000000032A00: 8C070B07
	s_wait_alu depctr_sa_sdst(0)                               // 000000032A04: BF88FF9E
	s_and_b32 vcc_lo, exec_lo, s7                              // 000000032A08: 8B6A077E
	s_wait_alu depctr_sa_sdst(0)                               // 000000032A0C: BF88FF9E
	s_cbranch_vccnz 65518                                      // 000000032A10: BFA4FFEE <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb0EEEvPfPKfPKiS5_iiii+0xcc>
	s_sub_co_i32 s4, s6, s9                                    // 000000032A14: 81840906
	s_wait_alu depctr_sa_sdst(0)                               // 000000032A18: BF88FF9E
	s_mul_u64 s[6:7], s[4:5], s[12:13]                         // 000000032A1C: AA860C04
	s_load_b32 s4, s[2:3], 0x0                                 // 000000032A20: F4000101 F8000000
	s_lshl_b64 s[6:7], s[6:7], 2                               // 000000032A28: 84868206
	s_wait_alu depctr_sa_sdst(0)                               // 000000032A2C: BF88FF9E
	v_add_co_u32 v5, vcc_lo, v2, s6                            // 000000032A30: D7006A05 02000D02
	s_wait_alu depctr_va_vcc(0)                                // 000000032A38: BF88FF9D
	v_add_co_ci_u32_e64 v6, null, s7, v3, vcc_lo               // 000000032A3C: D5207C06 01AA0607
	global_load_b32 v5, v[5:6], off                            // 000000032A44: EE05007C 00000005 00000005
	s_wait_loadcnt 0x0                                         // 000000032A50: BFC00000
	s_wait_kmcnt 0x0                                           // 000000032A54: BFC70000
	v_fmac_f32_e32 v4, s4, v5                                  // 000000032A58: 56080A04
	s_mov_b32 s4, -1                                           // 000000032A5C: BE8400C1
	s_branch 65498                                             // 000000032A60: BFA0FFDA <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb0EEEvPfPKfPKiS5_iiii+0xcc>
	s_mov_b32 s4, 0                                            // 000000032A64: BE840080
	s_wait_alu depctr_sa_sdst(0)                               // 000000032A68: BF88FF9E
	s_and_b32 vcc_lo, exec_lo, s4                              // 000000032A6C: 8B6A047E
	s_wait_alu depctr_sa_sdst(0)                               // 000000032A70: BF88FF9E
	s_cbranch_vccz 4                                           // 000000032A74: BFA30004 <_ZN6strata3ds412_GLOBAL__N_118moe_combine_kernelILb0EEEvPfPKfPKiS5_iiii+0x188>
	s_wait_loadcnt 0x0                                         // 000000032A78: BFC00000
	global_store_b32 v[0:1], v4, off                           // 000000032A7C: EE06807C 02000000 00000000
	s_endpgm                                                   // 000000032A88: BFB00000
