
/home/rkuo/research/llm-weight-compression/_meta/maya-attention-global-address-20261021/kernels-gfx1201.elf:	file format elf64-amdgpu

Disassembly of section .text:

0000000000037600 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf>:
	s_load_b32 s3, s[0:1], 0xe8                                // 000000037600: F40000C0 F80000E8
	s_mov_b32 s2, ttmp7                                        // 000000037608: BE820073
	s_add_nc_u64 s[8:9], s[0:1], 40                            // 00000003760C: A988A800
	s_mov_b32 s19, 0                                           // 000000037610: BE930080
	s_wait_kmcnt 0x0                                           // 000000037614: BFC70000
	s_cmp_eq_u32 s3, 0                                         // 000000037618: BF068003
	s_cbranch_scc1 2612                                        // 00000003761C: BFA20A34 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x28f0>
	s_clause 0x1                                               // 000000037620: BF850001
	s_load_b96 s[4:6], s[8:9], 0xc4                            // 000000037624: F400A104 F80000C4
	s_load_b64 s[10:11], s[8:9], 0xd8                          // 00000003762C: F4002284 F80000D8
	s_wait_kmcnt 0x0                                           // 000000037634: BFC70000
	s_add_co_i32 s14, s4, s2                                   // 000000037638: 810E0204
	s_ashr_i32 s13, s5, 31                                     // 00000003763C: 860D9F05
	s_mov_b32 s12, s5                                          // 000000037640: BE8C0005
	s_ashr_i32 s15, s14, 31                                    // 000000037644: 860F9F0E
	s_sub_nc_u64 s[16:17], s[12:13], s[10:11]                  // 000000037648: AA100A0C
	s_add_nc_u64 s[12:13], s[14:15], 1                         // 00000003764C: A98C810E
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)// 000000037650: BF8704C9
	v_cmp_gt_i64_e64 s3, s[16:17], s[12:13]                    // 000000037654: D4540003 02001810
	s_and_b32 s3, s3, exec_lo                                  // 00000003765C: 8B037E03
	s_cselect_b32 s18, s16, s12                                // 000000037660: 98120C10
	s_add_co_i32 s3, s5, s14                                   // 000000037664: 81030E05
	s_sub_co_i32 s3, s3, s18                                   // 000000037668: 81831203
	s_cmp_lt_i32 s6, 1                                         // 00000003766C: BF048106
	s_cbranch_scc1 181                                         // 000000037670: BFA200B5 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x348>
	s_add_nc_u64 s[4:5], s[12:13], s[10:11]                    // 000000037674: A9840A0C
	s_mov_b32 s7, 0                                            // 000000037678: BE870080
	s_cmp_lg_u32 s5, 0                                         // 00000003767C: BF078005
	s_cbranch_scc0 2588                                        // 000000037680: BFA10A1C <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x28f4>
	s_add_nc_u64 s[10:11], s[6:7], 0                           // 000000037684: A98A8006
	s_mov_b32 s17, s7                                          // 000000037688: BE910007
	s_xor_b64 s[10:11], s[10:11], 0                            // 00000003768C: 8D8A800A
	s_mov_b32 s23, s7                                          // 000000037690: BE970007
	s_cvt_f32_u32 s12, s10                                     // 000000037694: BE8C650A
	s_cvt_f32_u32 s13, s11                                     // 000000037698: BE8D650B
	s_sub_nc_u64 s[14:15], 0, s[10:11]                         // 00000003769C: AA0E0A80
	s_wait_alu depctr_sa_sdst(0)                               // 0000000376A0: BF88FF9E
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)// 0000000376A4: BF870529
	s_fmamk_f32 s12, s13, 0x4f800000, s12                      // 0000000376A8: A30C0C0D 4F800000
	s_wait_alu depctr_sa_sdst(0)                               // 0000000376B0: BF88FF9E
	v_s_rcp_f32 s12, s12                                       // 0000000376B4: D684000C 0201000C
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)// 0000000376BC: BF870525
	s_mul_f32 s12, s12, 0x5f7ffffc                             // 0000000376C0: A20CFF0C 5F7FFFFC
	s_wait_alu depctr_sa_sdst(0)                               // 0000000376C8: BF88FF9E
	s_mul_f32 s13, s12, 0x2f800000                             // 0000000376CC: A20DFF0C 2F800000
	s_wait_alu depctr_sa_sdst(0)                               // 0000000376D4: BF88FF9E
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)// 0000000376D8: BF87052A
	s_trunc_f32 s13, s13                                       // 0000000376DC: BE8D620D
	s_wait_alu depctr_sa_sdst(0)                               // 0000000376E0: BF88FF9E
	s_fmamk_f32 s12, s13, 0xcf800000, s12                      // 0000000376E4: A30C0C0D CF800000
	s_cvt_u32_f32 s13, s13                                     // 0000000376EC: BE8D670D
	s_wait_alu depctr_sa_sdst(0)                               // 0000000376F0: BF88FF9E
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)// 0000000376F4: BF870529
	s_cvt_u32_f32 s12, s12                                     // 0000000376F8: BE8C670C
	s_wait_alu depctr_sa_sdst(0)                               // 0000000376FC: BF88FF9E
	s_mul_u64 s[20:21], s[14:15], s[12:13]                     // 000000037700: AA940C0E
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000037704: BF870009
	s_mul_hi_u32 s25, s12, s21                                 // 000000037708: 9699150C
	s_mul_i32 s24, s12, s21                                    // 00000003770C: 9618150C
	s_mul_hi_u32 s16, s12, s20                                 // 000000037710: 9690140C
	s_mul_i32 s22, s13, s20                                    // 000000037714: 9616140D
	s_wait_alu depctr_sa_sdst(0)                               // 000000037718: BF88FF9E
	s_add_nc_u64 s[16:17], s[16:17], s[24:25]                  // 00000003771C: A9901810
	s_mul_hi_u32 s19, s13, s20                                 // 000000037720: 9693140D
	s_mul_hi_u32 s26, s13, s21                                 // 000000037724: 969A150D
	s_wait_alu depctr_sa_sdst(0)                               // 000000037728: BF88FF9E
	s_add_co_u32 s16, s16, s22                                 // 00000003772C: 80101610
	s_add_co_ci_u32 s22, s17, s19                              // 000000037730: 82161311
	s_mul_i32 s20, s13, s21                                    // 000000037734: 9614150D
	s_add_co_ci_u32 s21, s26, 0                                // 000000037738: 8215801A
	s_delay_alu instid0(SALU_CYCLE_1)                          // 00000003773C: BF870009
	s_add_nc_u64 s[16:17], s[22:23], s[20:21]                  // 000000037740: A9901416
	s_mov_b32 s21, s7                                          // 000000037744: BE950007
	s_wait_alu depctr_sa_sdst(0)                               // 000000037748: BF88FF9E
	s_add_co_u32 s12, s12, s16                                 // 00000003774C: 800C100C
	s_add_co_ci_u32 s13, s13, s17                              // 000000037750: 820D110D
	s_mov_b32 s17, s7                                          // 000000037754: BE910007
	s_wait_alu depctr_sa_sdst(0)                               // 000000037758: BF88FF9E
	s_mul_u64 s[14:15], s[14:15], s[12:13]                     // 00000003775C: AA8E0C0E
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000037760: BF870009
	s_mul_hi_u32 s23, s12, s15                                 // 000000037764: 96970F0C
	s_mul_i32 s22, s12, s15                                    // 000000037768: 96160F0C
	s_mul_hi_u32 s16, s12, s14                                 // 00000003776C: 96900E0C
	s_mul_i32 s20, s13, s14                                    // 000000037770: 96140E0D
	s_wait_alu depctr_sa_sdst(0)                               // 000000037774: BF88FF9E
	s_add_nc_u64 s[16:17], s[16:17], s[22:23]                  // 000000037778: A9901610
	s_mul_hi_u32 s19, s13, s14                                 // 00000003777C: 96930E0D
	s_mul_hi_u32 s24, s13, s15                                 // 000000037780: 96980F0D
	s_mul_i32 s14, s13, s15                                    // 000000037784: 960E0F0D
	s_wait_alu depctr_sa_sdst(0)                               // 000000037788: BF88FF9E
	s_add_co_u32 s15, s16, s20                                 // 00000003778C: 800F1410
	s_add_co_ci_u32 s20, s17, s19                              // 000000037790: 82141311
	s_add_co_ci_u32 s15, s24, 0                                // 000000037794: 820F8018
	s_mov_b32 s17, s7                                          // 000000037798: BE910007
	s_add_nc_u64 s[14:15], s[20:21], s[14:15]                  // 00000003779C: A98E0E14
	s_delay_alu instid0(SALU_CYCLE_1)                          // 0000000377A0: BF870009
	s_add_co_u32 s19, s12, s14                                 // 0000000377A4: 80130E0C
	s_add_co_ci_u32 s20, s13, s15                              // 0000000377A8: 82140F0D
	s_ashr_i32 s12, s5, 31                                     // 0000000377AC: 860C9F05
	s_wait_alu depctr_sa_sdst(0)                               // 0000000377B0: BF88FF9E
	s_mov_b32 s13, s12                                         // 0000000377B4: BE8D000C
	s_wait_alu depctr_sa_sdst(0)                               // 0000000377B8: BF88FF9E
	s_add_nc_u64 s[14:15], s[4:5], s[12:13]                    // 0000000377BC: A98E0C04
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)// 0000000377C0: BF870499
	s_xor_b64 s[14:15], s[14:15], s[12:13]                     // 0000000377C4: 8D8E0C0E
	s_mul_hi_u32 s23, s14, s20                                 // 0000000377C8: 9697140E
	s_mul_i32 s22, s14, s20                                    // 0000000377CC: 9616140E
	s_mul_hi_u32 s16, s14, s19                                 // 0000000377D0: 9690130E
	s_mul_hi_u32 s24, s15, s19                                 // 0000000377D4: 9698130F
	s_mul_i32 s19, s15, s19                                    // 0000000377D8: 9613130F
	s_wait_alu depctr_sa_sdst(0)                               // 0000000377DC: BF88FF9E
	s_add_nc_u64 s[16:17], s[16:17], s[22:23]                  // 0000000377E0: A9901610
	s_mul_hi_u32 s5, s15, s20                                  // 0000000377E4: 9685140F
	s_wait_alu depctr_sa_sdst(0)                               // 0000000377E8: BF88FF9E
	s_add_co_u32 s16, s16, s19                                 // 0000000377EC: 80101310
	s_mul_i32 s22, s15, s20                                    // 0000000377F0: 9616140F
	s_add_co_ci_u32 s20, s17, s24                              // 0000000377F4: 82141811
	s_add_co_ci_u32 s23, s5, 0                                 // 0000000377F8: 82178005
	s_delay_alu instid0(SALU_CYCLE_1)                          // 0000000377FC: BF870009
	s_add_nc_u64 s[16:17], s[20:21], s[22:23]                  // 000000037800: A9901614
	s_wait_alu depctr_sa_sdst(0)                               // 000000037804: BF88FF9E
	s_mul_u64 s[20:21], s[10:11], s[16:17]                     // 000000037808: AA94100A
	s_add_nc_u64 s[22:23], s[16:17], 1                         // 00000003780C: A9968110
	s_sub_co_u32 s5, s14, s20                                  // 000000037810: 8085140E
	s_cselect_b32 s14, -1, 0                                   // 000000037814: 980E80C1
	s_sub_co_i32 s19, s15, s21                                 // 000000037818: 8193150F
	s_cmp_lg_u32 s14, 0                                        // 00000003781C: BF07800E
	s_sub_co_ci_u32 s19, s19, s11                              // 000000037820: 82930B13
	s_sub_co_u32 s20, s5, s10                                  // 000000037824: 80940A05
	s_sub_co_ci_u32 s19, s19, 0                                // 000000037828: 82938013
	s_delay_alu instid0(SALU_CYCLE_1)                          // 00000003782C: BF870009
	s_cmp_ge_u32 s19, s11                                      // 000000037830: BF090B13
	s_cselect_b32 s24, -1, 0                                   // 000000037834: 981880C1
	s_cmp_ge_u32 s20, s10                                      // 000000037838: BF090A14
	s_cselect_b32 s20, -1, 0                                   // 00000003783C: 981480C1
	s_cmp_eq_u32 s19, s11                                      // 000000037840: BF060B13
	s_cselect_b32 s19, s20, s24                                // 000000037844: 98131814
	s_add_nc_u64 s[24:25], s[16:17], 2                         // 000000037848: A9988210
	s_cmp_lg_u32 s19, 0                                        // 00000003784C: BF078013
	s_cselect_b32 s19, s24, s22                                // 000000037850: 98131618
	s_cselect_b32 s20, s25, s23                                // 000000037854: 98141719
	s_cmp_lg_u32 s14, 0                                        // 000000037858: BF07800E
	s_sub_co_ci_u32 s14, s15, s21                              // 00000003785C: 828E150F
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000037860: BF870009
	s_cmp_ge_u32 s14, s11                                      // 000000037864: BF090B0E
	s_cselect_b32 s15, -1, 0                                   // 000000037868: 980F80C1
	s_cmp_ge_u32 s5, s10                                       // 00000003786C: BF090A05
	s_cselect_b32 s5, -1, 0                                    // 000000037870: 980580C1
	s_cmp_eq_u32 s14, s11                                      // 000000037874: BF060B0E
	s_cselect_b32 s5, s5, s15                                  // 000000037878: 98050F05
	s_delay_alu instid0(SALU_CYCLE_1)                          // 00000003787C: BF870009
	s_cmp_lg_u32 s5, 0                                         // 000000037880: BF078005
	s_cselect_b32 s11, s20, s17                                // 000000037884: 980B1114
	s_cselect_b32 s10, s19, s16                                // 000000037888: 980A1013
	s_xor_b64 s[12:13], s[12:13], 0                            // 00000003788C: 8D8C800C
	s_wait_alu depctr_sa_sdst(0)                               // 000000037890: BF88FF9E
	s_xor_b64 s[10:11], s[10:11], s[12:13]                     // 000000037894: 8D8A0C0A
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000037898: BF870009
	s_sub_nc_u64 s[12:13], s[10:11], s[12:13]                  // 00000003789C: AA0C0C0A
	s_load_b32 s10, s[8:9], 0xd0                               // 0000000378A0: F4000284 F80000D0
	s_and_not1_b32 vcc_lo, exec_lo, s7                         // 0000000378A8: 916A077E
	s_cbranch_vccnz 31                                         // 0000000378AC: BFA4001F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x32c>
	v_cvt_f32_u32_e32 v1, s6                                   // 0000000378B0: 7E020C06
	s_sub_co_i32 s7, 0, s6                                     // 0000000378B4: 81870680
	s_mov_b32 s13, 0                                           // 0000000378B8: BE8D0080
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_1)// 0000000378BC: BF870291
	v_rcp_iflag_f32_e32 v1, v1                                 // 0000000378C0: 7E025701
	v_mul_f32_e32 v1, 0x4f7ffffe, v1                           // 0000000378C4: 100202FF 4F7FFFFE
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000378CC: BF870091
	v_cvt_u32_f32_e32 v1, v1                                   // 0000000378D0: 7E020F01
	v_readfirstlane_b32 s5, v1                                 // 0000000378D4: 7E0A0501
	s_wait_alu depctr_sa_sdst(0)                               // 0000000378D8: BF88FF9E
	s_mul_i32 s7, s7, s5                                       // 0000000378DC: 96070507
	s_wait_alu depctr_sa_sdst(0)                               // 0000000378E0: BF88FF9E
	s_mul_hi_u32 s7, s5, s7                                    // 0000000378E4: 96870705
	s_wait_alu depctr_sa_sdst(0)                               // 0000000378E8: BF88FF9E
	s_add_co_i32 s5, s5, s7                                    // 0000000378EC: 81050705
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)// 0000000378F0: BF870499
	s_mul_hi_u32 s5, s4, s5                                    // 0000000378F4: 96850504
	s_mul_i32 s7, s5, s6                                       // 0000000378F8: 96070605
	s_wait_alu depctr_sa_sdst(0)                               // 0000000378FC: BF88FF9E
	s_sub_co_i32 s4, s4, s7                                    // 000000037900: 81840704
	s_add_co_i32 s7, s5, 1                                     // 000000037904: 81078105
	s_sub_co_i32 s11, s4, s6                                   // 000000037908: 818B0604
	s_cmp_ge_u32 s4, s6                                        // 00000003790C: BF090604
	s_wait_alu depctr_sa_sdst(0)                               // 000000037910: BF88FF9E
	s_cselect_b32 s5, s7, s5                                   // 000000037914: 98050507
	s_cselect_b32 s4, s11, s4                                  // 000000037918: 9804040B
	s_add_co_i32 s7, s5, 1                                     // 00000003791C: 81078105
	s_cmp_ge_u32 s4, s6                                        // 000000037920: BF090604
	s_wait_alu depctr_sa_sdst(0)                               // 000000037924: BF88FF9E
	s_cselect_b32 s12, s7, s5                                  // 000000037928: 980C0507
	s_wait_kmcnt 0x0                                           // 00000003792C: BFC70000
	s_ashr_i32 s11, s10, 31                                    // 000000037930: 860B9F0A
	s_wait_alu depctr_sa_sdst(0)                               // 000000037934: BF88FF9E
	v_cmp_lt_i64_e64 s4, s[10:11], s[12:13]                    // 000000037938: D4510004 0200180A
	s_and_b32 s4, s4, exec_lo                                  // 000000037940: 8B047E04
	s_cselect_b32 s19, s10, s12                                // 000000037944: 98130C0A
	s_add_co_i32 s20, s3, 1                                    // 000000037948: 81148103
	s_cbranch_execnz 11                                        // 00000003794C: BFA6000B <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x37c>
	s_ashr_i32 s3, s2, 31                                      // 000000037950: 86039F02
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)// 000000037954: BF870499
	s_lshl_b64 s[4:5], s[2:3], 2                               // 000000037958: 84848202
	s_add_nc_u64 s[4:5], s[8:9], s[4:5]                        // 00000003795C: A9840408
	s_clause 0x2                                               // 000000037960: BF850002
	s_load_b32 s20, s[4:5], 0x40                               // 000000037964: F4000502 F8000040
	s_load_b32 s19, s[4:5], 0x80                               // 00000003796C: F40004C2 F8000080
	s_load_b32 s18, s[4:5], 0x0                                // 000000037974: F4000482 F8000000
	s_clause 0x1                                               // 00000003797C: BF850001
	s_load_b64 s[16:17], s[0:1], 0x110                         // 000000037980: F4002400 F8000110
	s_load_b256 s[4:11], s[0:1], 0x0                           // 000000037988: F4006100 F8000000
	s_ashr_i32 s3, s2, 31                                      // 000000037990: 86039F02
	s_lshl_b32 s14, ttmp9, 3                                   // 000000037994: 840E8375
	v_lshrrev_b32_e32 v17, 5, v0                               // 000000037998: 32220085
	s_ashr_i32 s15, s14, 31                                    // 00000003799C: 860F9F0E
	v_dual_mov_b32 v36, 0 :: v_dual_and_b32 v53, 31, v0        // 0000000379A0: CA240080 2434009F
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000379A8: BF870001
	v_lshlrev_b32_e32 v3, 6, v53                               // 0000000379AC: 30066A86
	s_wait_kmcnt 0x0                                           // 0000000379B0: BFC70000
	s_ashr_i32 s13, s16, 31                                    // 0000000379B4: 860D9F10
	s_mov_b32 s12, s16                                         // 0000000379B8: BE8C0010
	s_wait_alu depctr_sa_sdst(0)                               // 0000000379BC: BF88FF9E
	s_mul_u64 s[12:13], s[12:13], s[2:3]                       // 0000000379C0: AA8C020C
	s_wait_alu depctr_sa_sdst(0)                               // 0000000379C4: BF88FF9E
	s_add_nc_u64 s[12:13], s[12:13], s[14:15]                  // 0000000379C8: A98C0E0C
	s_wait_alu depctr_sa_sdst(0)                               // 0000000379CC: BF88FF9E
	v_add_co_u32 v1, s16, s12, v17                             // 0000000379D0: D7001001 0202220C
	s_wait_alu depctr_va_sdst(0)                               // 0000000379D8: BF88F19F
	v_add_co_ci_u32_e64 v2, null, s13, 0, s16                  // 0000000379DC: D5207C02 0041000D
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000379E4: BF870091
	v_lshlrev_b64_e32 v[1:2], 11, v[1:2]                       // 0000000379E8: 3E02028B
	v_add_co_u32 v1, vcc_lo, s4, v1                            // 0000000379EC: D7006A01 02020204
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000379F4: BF870001
	v_add_co_ci_u32_e64 v2, null, s5, v2, vcc_lo               // 0000000379F8: D5207C02 01AA0405
	s_mov_b32 s4, exec_lo                                      // 000000037A00: BE84007E
	v_add_co_u32 v13, vcc_lo, v1, v3                           // 000000037A04: D7006A0D 02020701
	s_wait_alu depctr_va_vcc(0)                                // 000000037A0C: BF88FF9D
	v_add_co_ci_u32_e64 v14, null, 0, v2, vcc_lo               // 000000037A10: D5207C0E 01AA0480
	s_clause 0x3                                               // 000000037A18: BF850003
	global_load_b128 v[1:4], v[13:14], off offset:48           // 000000037A1C: EE05C07C 00000001 0000300D
	global_load_b128 v[5:8], v[13:14], off offset:32           // 000000037A28: EE05C07C 00000005 0000200D
	global_load_b128 v[9:12], v[13:14], off offset:16          // 000000037A34: EE05C07C 00000009 0000100D
	global_load_b128 v[13:16], v[13:14], off                   // 000000037A40: EE05C07C 0000000D 0000000D
	v_cmpx_gt_u32_e32 8, v0                                    // 000000037A4C: 7D980088
	s_cbranch_execz 9                                          // 000000037A50: BFA50009 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x478>
	v_dual_mov_b32 v19, 0xf149f2ca :: v_dual_lshlrev_b32 v18, 2, v0// 000000037A54: CA2200FF 13120082 F149F2CA
	v_mov_b32_e32 v20, 0                                       // 000000037A60: 7E280280
	s_delay_alu instid0(VALU_DEP_2)                            // 000000037A64: BF870002
	v_add_nc_u32_e32 v18, 0x4800, v18                          // 000000037A68: 4A2424FF 00004800
	ds_store_2addr_b32 v18, v20, v19 offset0:136 offset1:144   // 000000037A70: D8389088 00131412
	s_wait_alu depctr_sa_sdst(0)                               // 000000037A78: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000037A7C: 8C7E047E
	v_dual_mov_b32 v37, 0 :: v_dual_lshlrev_b32 v52, 1, v0     // 000000037A80: CA220080 25340081
	v_dual_mov_b32 v38, 0 :: v_dual_mov_b32 v39, 0             // 000000037A88: CA100080 26260080
	v_dual_mov_b32 v42, 0 :: v_dual_mov_b32 v41, 0             // 000000037A90: CA100080 2A280080
	v_dual_mov_b32 v44, 0 :: v_dual_mov_b32 v43, 0             // 000000037A98: CA100080 2C2A0080
	v_dual_mov_b32 v46, 0 :: v_dual_mov_b32 v45, 0             // 000000037AA0: CA100080 2E2C0080
	v_dual_mov_b32 v48, 0 :: v_dual_mov_b32 v47, 0             // 000000037AA8: CA100080 302E0080
	v_dual_mov_b32 v50, 0 :: v_dual_mov_b32 v49, 0             // 000000037AB0: CA100080 32300080
	v_dual_mov_b32 v40, 0 :: v_dual_mov_b32 v51, 0             // 000000037AB8: CA100080 28320080
	s_add_co_i32 s5, s19, s20                                  // 000000037AC0: 81051413
	s_wait_alu depctr_sa_sdst(0)                               // 000000037AC4: BF88FF9E
	s_cmp_lt_i32 s5, 1                                         // 000000037AC8: BF048105
	s_cbranch_scc1 1655                                        // 000000037ACC: BFA20677 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1eac>
	v_dual_mov_b32 v33, 0 :: v_dual_and_b32 v18, 15, v0        // 000000037AD0: CA240080 2112008F
	v_lshrrev_b32_e32 v54, 4, v0                               // 000000037AD8: 326C0084
	v_dual_mov_b32 v50, 0 :: v_dual_lshlrev_b32 v19, 3, v0     // 000000037ADC: CA220080 32120083
	v_dual_mov_b32 v37, 0 :: v_dual_and_b32 v20, 2, v52        // 000000037AE4: CA240080 25146882
	s_delay_alu instid0(VALU_DEP_4)                            // 000000037AEC: BF870004
	v_dual_mov_b32 v51, 0 :: v_dual_lshlrev_b32 v56, 4, v18    // 000000037AF0: CA220080 33382484
	s_load_b32 s22, s[0:1], 0x20                               // 000000037AF8: F4000580 F8000020
	v_dual_mov_b32 v48, 0 :: v_dual_lshlrev_b32 v57, 1, v18    // 000000037B00: CA220080 30382481
	v_dual_mov_b32 v46, 0 :: v_dual_lshlrev_b32 v21, 10, v54   // 000000037B08: CA220080 2E146C8A
	v_dual_mov_b32 v49, 0 :: v_dual_lshlrev_b32 v58, 6, v18    // 000000037B10: CA220080 313A2486
	v_dual_mov_b32 v47, 0 :: v_dual_and_b32 v18, 0xf0, v19     // 000000037B18: CA240080 2F1226FF 000000F0
	v_or_b32_e32 v22, 1, v20                                   // 000000037B24: 382C2881
	v_xor_b32_e32 v23, 0x120, v56                              // 000000037B28: 3A2E70FF 00000120
	v_xor_b32_e32 v24, 0x240, v56                              // 000000037B30: 3A3070FF 00000240
	v_xor_b32_e32 v25, 0x360, v56                              // 000000037B38: 3A3270FF 00000360
	v_or_b32_e32 v55, 0x4800, v19                              // 000000037B40: 386E26FF 00004800
	v_dual_mov_b32 v44, 0 :: v_dual_lshlrev_b32 v19, 5, v20    // 000000037B48: CA220080 2C122885
	v_or_b32_e32 v59, v21, v56                                 // 000000037B50: 38767115
	v_lshl_or_b32 v20, v20, 8, v18                             // 000000037B54: D6560014 04491114
	v_lshl_or_b32 v18, v22, 8, v18                             // 000000037B5C: D6560012 04491116
	v_or_b32_e32 v60, v21, v23                                 // 000000037B64: 38782F15
	v_or_b32_e32 v61, v21, v24                                 // 000000037B68: 387A3115
	v_dual_mov_b32 v45, 0 :: v_dual_lshlrev_b32 v22, 5, v22    // 000000037B6C: CA220080 2D162C85
	v_or_b32_e32 v62, v21, v25                                 // 000000037B74: 387C3315
	v_bfe_u32 v21, v0, 2, 2                                    // 000000037B78: D6100015 02090500
	v_dual_mov_b32 v42, 0 :: v_dual_and_b32 v23, 0xf0, v0      // 000000037B80: CA240080 2A1600FF 000000F0
	v_xor_b32_e32 v63, v19, v20                                // 000000037B8C: 3A7E2913
	v_xor_b32_e32 v64, v22, v18                                // 000000037B90: 3A802516
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)// 000000037B94: BF870214
	v_dual_mov_b32 v36, 0 :: v_dual_lshlrev_b32 v19, 5, v21    // 000000037B98: CA220080 24122A85
	v_lshl_or_b32 v18, v21, 8, v23                             // 000000037BA0: D6560012 045D1115
	v_dual_mov_b32 v38, 0 :: v_dual_lshlrev_b32 v65, 8, v17    // 000000037BA8: CA220080 26402288
	v_dual_mov_b32 v40, 0 :: v_dual_lshlrev_b32 v17, 2, v17    // 000000037BB0: CA220080 28102282
	v_dual_mov_b32 v43, 0 :: v_dual_and_b32 v20, 6, v52        // 000000037BB8: CA240080 2B146886
	s_delay_alu instid0(VALU_DEP_4)                            // 000000037BC0: BF870004
	v_xor_b32_e32 v18, v19, v18                                // 000000037BC4: 3A242513
	v_mbcnt_lo_u32_b32 v68, -1, 0                              // 000000037BC8: D71F0044 020100C1
	s_ashr_i32 s19, s18, 31                                    // 000000037BD0: 86139F12
	s_wait_kmcnt 0x0                                           // 000000037BD4: BFC70000
	s_ashr_i32 s23, s22, 31                                    // 000000037BD8: 86179F16
	s_lshl_b64 s[18:19], s[18:19], 10                          // 000000037BDC: 84928A12
	s_mul_u64 s[2:3], s[22:23], s[2:3]                         // 000000037BE0: AA820216
	s_add_nc_u64 s[6:7], s[6:7], s[18:19]                      // 000000037BE4: A9861206
	s_lshl_b64 s[18:19], s[2:3], 2                             // 000000037BE8: 84928202
	v_cmp_eq_u32_e64 s2, 0, v53                                // 000000037BEC: D44A0002 02026A80
	v_or_b32_e32 v66, 0x4000, v65                              // 000000037BF4: 388482FF 00004000
	v_cmp_gt_u32_e64 s3, 0x100, v0                             // 000000037BFC: D44C0003 020200FF 00000100
	v_or_b32_e32 v67, 0x4a40, v17                              // 000000037C08: 388622FF 00004A40
	v_or_b32_e32 v69, 0x4a00, v17                              // 000000037C10: 388A22FF 00004A00
	v_or_b32_e32 v70, 0x4a20, v17                              // 000000037C18: 388C22FF 00004A20
	v_lshl_or_b32 v71, v20, 1, v18                             // 000000037C20: D6560047 04490314
	v_lshl_or_b32 v72, v53, 2, v65                             // 000000037C28: D6560048 05050535
	v_xor_b32_e32 v73, 16, v68                                 // 000000037C30: 3A928890
	v_xor_b32_e32 v74, 8, v68                                  // 000000037C34: 3A948888
	v_xor_b32_e32 v75, 4, v68                                  // 000000037C38: 3A968884
	v_xor_b32_e32 v76, 2, v68                                  // 000000037C3C: 3A988882
	v_xor_b32_e32 v77, 1, v68                                  // 000000037C40: 3A9A8881
	v_mov_b32_e32 v41, 0                                       // 000000037C44: 7E520280
	v_mov_b32_e32 v39, 0                                       // 000000037C48: 7E4E0280
	s_add_nc_u64 s[10:11], s[10:11], s[18:19]                  // 000000037C4C: A98A120A
	s_mov_b32 s16, 0                                           // 000000037C50: BE900080
	s_mov_b32 s18, s5                                          // 000000037C54: BE920005
	s_branch 5                                                 // 000000037C58: BFA00005 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x670>
	s_add_co_i32 s16, s16, 64                                  // 000000037C5C: 8110C010
	s_sub_co_i32 s18, s18, 64                                  // 000000037C60: 8192C012
	s_wait_alu depctr_sa_sdst(0)                               // 000000037C64: BF88FF9E
	s_cmp_ge_i32 s16, s5                                       // 000000037C68: BF030510
	s_cbranch_scc1 1551                                        // 000000037C6C: BFA2060F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1eac>
	s_wait_alu depctr_sa_sdst(0)                               // 000000037C70: BF88FF9E
	s_sub_co_i32 s23, s5, s16                                  // 000000037C74: 81971005
	s_mov_b32 s4, exec_lo                                      // 000000037C78: BE84007E
	s_wait_alu depctr_sa_sdst(0)                               // 000000037C7C: BF88FF9E
	s_min_i32 s19, s23, 64                                     // 000000037C80: 8913C017
	s_wait_alu depctr_sa_sdst(0)                               // 000000037C84: BF88FF9E
	v_cmpx_gt_u32_e64 s19, v0                                  // 000000037C88: D4CC007E 02020013
	s_cbranch_execz 39                                         // 000000037C90: BFA50027 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x730>
	v_add_nc_u32_e32 v19, s16, v0                              // 000000037C94: 4A260010
	s_mov_b32 s21, exec_lo                                     // 000000037C98: BE95007E
	s_delay_alu instid0(VALU_DEP_1)                            // 000000037C9C: BF870001
	v_cmpx_le_i32_e64 s20, v19                                 // 000000037CA0: D4C3007E 02022614
	s_wait_alu depctr_sa_sdst(0)                               // 000000037CA8: BF88FF9E
	s_xor_b32 s21, exec_lo, s21                                // 000000037CAC: 8D15157E
	s_cbranch_execz 16                                         // 000000037CB0: BFA50010 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x6f4>
	v_subrev_nc_u32_e32 v32, s20, v19                          // 000000037CB4: 4E402614
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000037CB8: BF870091
	v_lshlrev_b64_e32 v[17:18], 2, v[32:33]                    // 000000037CBC: 3E224082
	v_add_co_u32 v17, vcc_lo, s10, v17                         // 000000037CC0: D7006A11 0202220A
	s_wait_alu depctr_va_vcc(0)                                // 000000037CC8: BF88FF9D
	s_delay_alu instid0(VALU_DEP_2)                            // 000000037CCC: BF870002
	v_add_co_ci_u32_e64 v18, null, s11, v18, vcc_lo            // 000000037CD0: D5207C12 01AA240B
	global_load_b32 v17, v[17:18], off                         // 000000037CD8: EE05007C 00000011 00000011
	s_wait_loadcnt 0x0                                         // 000000037CE4: BFC00000
	v_mad_co_i64_i32 v[17:18], null, 0x120, v17, s[8:9]        // 000000037CE8: D6FF7C11 002222FF 00000120
	s_wait_alu depctr_sa_sdst(0)                               // 000000037CF4: BF88FF9E
	s_and_not1_saveexec_b32 s21, s21                           // 000000037CF8: BE953015
	v_ashrrev_i32_e32 v20, 31, v19                             // 000000037CFC: 3428269F
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000037D00: BF870091
	v_lshlrev_b64_e32 v[17:18], 10, v[19:20]                   // 000000037D04: 3E22268A
	v_add_co_u32 v17, vcc_lo, s6, v17                          // 000000037D08: D7006A11 02022206
	s_wait_alu depctr_va_vcc(0)                                // 000000037D10: BF88FF9D
	s_delay_alu instid0(VALU_DEP_2)                            // 000000037D14: BF870002
	v_add_co_ci_u32_e64 v18, null, s7, v18, vcc_lo             // 000000037D18: D5207C12 01AA2407
	s_wait_alu depctr_sa_sdst(0)                               // 000000037D20: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s21                             // 000000037D24: 8C7E157E
	ds_store_b64 v55, v[17:18]                                 // 000000037D28: D9340000 00001137
	s_wait_alu depctr_sa_sdst(0)                               // 000000037D30: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000037D34: 8C7E047E
	s_wait_loadcnt_dscnt 0x0                                   // 000000037D38: BFC80000
	s_barrier_signal -1                                        // 000000037D3C: BE804EC1
	s_min_i32 s21, s18, 64                                     // 000000037D40: 8915C012
	s_cmp_gt_i32 s23, 0                                        // 000000037D44: BF028017
	s_cselect_b32 s22, -1, 0                                   // 000000037D48: 981680C1
	s_cmp_lt_i32 s23, 1                                        // 000000037D4C: BF048117
	s_barrier_wait 0xffff                                      // 000000037D50: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 000000037D54: EE0AC07C 00040000 00000000
	s_cbranch_scc1 663                                         // 000000037D60: BFA20297 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x11c0>
	v_mov_b32_e32 v78, v65                                     // 000000037D64: 7E9C0341
	s_mov_b32 s24, 0                                           // 000000037D68: BE980080
	s_wait_alu depctr_sa_sdst(0)                               // 000000037D6C: BF88FF9E
	s_mov_b32 s25, s21                                         // 000000037D70: BE990015
	s_branch 12                                                // 000000037D74: BFA0000C <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x7a8>
	s_wait_loadcnt_dscnt 0x0                                   // 000000037D78: BFC80000
	s_barrier_signal -1                                        // 000000037D7C: BE804EC1
	v_add_nc_u32_e32 v78, 64, v78                              // 000000037D80: 4A9C9CC0
	s_add_co_i32 s24, s24, 16                                  // 000000037D84: 81189018
	s_add_co_i32 s25, s25, -16                                 // 000000037D88: 8119D019
	s_wait_alu depctr_sa_sdst(0)                               // 000000037D8C: BF88FF9E
	s_cmp_ge_i32 s24, s19                                      // 000000037D90: BF031318
	s_barrier_wait 0xffff                                      // 000000037D94: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 000000037D98: EE0AC07C 00040000 00000000
	s_cbranch_scc1 646                                         // 000000037DA4: BFA20286 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x11c0>
	s_sub_co_i32 s26, s19, s24                                 // 000000037DA8: 819A1813
	s_mov_b32 s27, exec_lo                                     // 000000037DAC: BE9B007E
	s_min_i32 s4, s26, 16                                      // 000000037DB0: 8904901A
	s_wait_alu depctr_sa_sdst(0)                               // 000000037DB4: BF88FF9E
	v_cmpx_gt_u32_e64 s4, v54                                  // 000000037DB8: D4CC007E 02026C04
	s_cbranch_execz 499                                        // 000000037DC0: BFA501F3 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0xf90>
	v_add_nc_u32_e32 v17, s24, v54                             // 000000037DC4: 4A226C18
	s_delay_alu instid0(VALU_DEP_1)                            // 000000037DC8: BF870001
	v_lshlrev_b32_e32 v18, 3, v17                              // 000000037DCC: 30242283
	v_add_nc_u32_e32 v17, s16, v17                             // 000000037DD0: 4A222210
	ds_load_b64 v[34:35], v18 offset:18432                     // 000000037DD4: D9D84800 22000012
	v_cmp_le_i32_e32 vcc_lo, s20, v17                          // 000000037DDC: 7C862214
	s_and_saveexec_b32 s4, vcc_lo                              // 000000037DE0: BE84206A
	s_wait_alu depctr_sa_sdst(0)                               // 000000037DE4: BF88FF9E
	s_xor_b32 s28, exec_lo, s4                                 // 000000037DE8: 8D1C047E
	s_cbranch_execz 453                                        // 000000037DEC: BFA501C5 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0xf04>
	s_wait_dscnt 0x0                                           // 000000037DF0: BFC60000
	v_add_co_u32 v21, vcc_lo, v34, v57                         // 000000037DF4: D7006A15 02027322
	s_wait_alu depctr_va_vcc(0)                                // 000000037DFC: BF88FF9D
	v_add_co_ci_u32_e64 v22, null, 0, v35, vcc_lo              // 000000037E00: D5207C16 01AA4680
	v_add_co_u32 v17, vcc_lo, v34, v56                         // 000000037E08: D7006A11 02027122
	s_wait_alu depctr_va_vcc(0)                                // 000000037E10: BF88FF9D
	v_add_co_ci_u32_e64 v18, null, 0, v35, vcc_lo              // 000000037E14: D5207C12 01AA4680
	global_load_d16_i8 v24, v[21:22], off offset:256           // 000000037E1C: EE07C07C 00000018 00010015
	v_mov_b32_e32 v25, 0x7fc00000                              // 000000037E28: 7E3202FF 7FC00000
	v_mov_b32_e32 v23, 0x7fc00000                              // 000000037E30: 7E2E02FF 7FC00000
	global_load_b128 v[17:20], v[17:18], off                   // 000000037E38: EE05C07C 00000011 00000011
	s_wait_loadcnt 0x1                                         // 000000037E44: BFC00001
	v_bfe_u32 v27, v24, 3, 4                                   // 000000037E48: D610001B 02110718
	v_and_b32_e32 v26, 7, v24                                  // 000000037E50: 36343087
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000037E54: BF870112
	v_cmp_ne_u32_e32 vcc_lo, 15, v27                           // 000000037E58: 7C9A368F
	v_cmp_ne_u32_e64 s4, 7, v26                                // 000000037E5C: D44D0004 02023487
	s_or_b32 s29, s4, vcc_lo                                   // 000000037E64: 8C1D6A04
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000037E68: BF870009
	s_and_saveexec_b32 s4, s29                                 // 000000037E6C: BE84201D
	s_cbranch_execz 15                                         // 000000037E70: BFA5000F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x8b0>
	s_mov_b32 s29, exec_lo                                     // 000000037E74: BE9D007E
	v_cmpx_ne_u32_e32 0, v27                                   // 000000037E78: 7D9A3680
	s_xor_b32 s29, exec_lo, s29                                // 000000037E7C: 8D1D1D7E
	v_lshlrev_b32_e32 v25, 20, v26                             // 000000037E80: 30323494
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000037E84: BF870091
	v_lshl_or_b32 v25, v27, 23, v25                            // 000000037E88: D6560019 04652F1B
	v_add_nc_u32_e32 v25, 0x3c000000, v25                      // 000000037E90: 4A3232FF 3C000000
	s_and_not1_saveexec_b32 s29, s29                           // 000000037E98: BE9D301D
	v_cvt_f32_ubyte0_e32 v25, v26                              // 000000037E9C: 7E32231A
	s_delay_alu instid0(VALU_DEP_1)                            // 000000037EA0: BF870001
	v_mul_f32_e32 v25, 0x3b000000, v25                         // 000000037EA4: 103232FF 3B000000
	s_or_b32 exec_lo, exec_lo, s29                             // 000000037EAC: 8C7E1D7E
	s_wait_alu depctr_sa_sdst(0)                               // 000000037EB0: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000037EB4: 8C7E047E
	global_load_d16_i8 v22, v[21:22], off offset:257           // 000000037EB8: EE07C07C 00000016 00010115
	s_wait_loadcnt 0x0                                         // 000000037EC4: BFC00000
	v_bfe_u32 v26, v22, 3, 4                                   // 000000037EC8: D610001A 02110716
	v_and_b32_e32 v21, 7, v22                                  // 000000037ED0: 362A2C87
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000037ED4: BF870112
	v_cmp_ne_u32_e32 vcc_lo, 15, v26                           // 000000037ED8: 7C9A348F
	v_cmp_ne_u32_e64 s4, 7, v21                                // 000000037EDC: D44D0004 02022A87
	s_or_b32 s29, s4, vcc_lo                                   // 000000037EE4: 8C1D6A04
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000037EE8: BF870009
	s_and_saveexec_b32 s4, s29                                 // 000000037EEC: BE84201D
	s_cbranch_execz 15                                         // 000000037EF0: BFA5000F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x930>
	s_mov_b32 s29, exec_lo                                     // 000000037EF4: BE9D007E
	v_cmpx_ne_u32_e32 0, v26                                   // 000000037EF8: 7D9A3480
	s_xor_b32 s29, exec_lo, s29                                // 000000037EFC: 8D1D1D7E
	v_lshlrev_b32_e32 v21, 20, v21                             // 000000037F00: 302A2A94
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000037F04: BF870091
	v_lshl_or_b32 v21, v26, 23, v21                            // 000000037F08: D6560015 04552F1A
	v_add_nc_u32_e32 v23, 0x3c000000, v21                      // 000000037F10: 4A2E2AFF 3C000000
	s_and_not1_saveexec_b32 s29, s29                           // 000000037F18: BE9D301D
	v_cvt_f32_ubyte0_e32 v21, v21                              // 000000037F1C: 7E2A2315
	s_delay_alu instid0(VALU_DEP_1)                            // 000000037F20: BF870001
	v_mul_f32_e32 v23, 0x3b000000, v21                         // 000000037F24: 102E2AFF 3B000000
	s_or_b32 exec_lo, exec_lo, s29                             // 000000037F2C: 8C7E1D7E
	s_wait_alu depctr_sa_sdst(0)                               // 000000037F30: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000037F34: 8C7E047E
	v_cmp_gt_i16_e32 vcc_lo, 0, v24.l                          // 000000037F38: 7C683080
	v_lshlrev_b32_e32 v21, 9, v17                              // 000000037F3C: 302A2289
	v_lshlrev_b32_e32 v27, 8, v17                              // 000000037F40: 30362288
	v_mov_b16_e32 v34.h, 0                                     // 000000037F44: 7F443880
	v_lshlrev_b32_e32 v31, 8, v18                              // 000000037F48: 303E2488
	s_wait_alu depctr_va_vcc(0)                                // 000000037F4C: BF88FF9D
	v_cndmask_b32_e64 v24, v25, -v25, vcc_lo                   // 000000037F50: D5010018 41AA3319
	v_cmp_gt_i16_e32 vcc_lo, 0, v22.l                          // 000000037F58: 7C682C80
	v_lshlrev_b32_e32 v25, 5, v17                              // 000000037F5C: 30322285
	v_lshlrev_b32_e32 v26, 12, v17                             // 000000037F60: 3034228C
	v_and_b32_e32 v21, 0xe00, v21                              // 000000037F64: 362A2AFF 00000E00
	v_mul_f32_e32 v29, 0x46800000, v24                         // 000000037F6C: 103A30FF 46800000
	s_wait_alu depctr_va_vcc(0)                                // 000000037F74: BF88FF9D
	v_cndmask_b32_e64 v23, v23, -v23, vcc_lo                   // 000000037F78: D5010017 41AA2F17
	v_lshlrev_b32_e32 v28, 1, v17                              // 000000037F80: 30382281
	v_and_b32_e32 v25, 0xe00, v25                              // 000000037F84: 363232FF 00000E00
	v_and_or_b32 v21, 0x8000, v26, v21                         // 000000037F8C: D6570015 045634FF 00008000
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)// 000000037F98: BF870214
	v_dual_mul_f32 v23, 0x46800000, v23 :: v_dual_lshlrev_b32 v24, 4, v17// 000000037F9C: C8E22EFF 17182284 46800000
	v_and_b32_e32 v26, 0xe00, v28                              // 000000037FA8: 363438FF 00000E00
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)// 000000037FB0: BF870214
	v_and_or_b32 v25, 0x8000, v27, v25                         // 000000037FB4: D6570019 046636FF 00008000
	v_fma_mix_f32 v21, v21, v29, neg(0) op_sel_hi:[1,0,0]      // 000000037FC0: CC200015 8A023B15
	v_and_b32_e32 v27, 0x8000, v17                             // 000000037FC8: 363622FF 00008000
	v_lshrrev_b32_e32 v28, 3, v17                              // 000000037FD0: 32382283
	v_and_or_b32 v24, 0x8000, v24, v26                         // 000000037FD4: D6570018 046A30FF 00008000
	v_fma_mix_f32 v25, v25, v29, neg(0) op_sel_hi:[1,0,0]      // 000000037FE0: CC200019 8A023B19
	v_mov_b16_e32 v34.l, v21.h                                 // 000000037FE8: 7E443995
	v_lshrrev_b32_e32 v35, 3, v18                              // 000000037FEC: 32462483
	v_and_or_b32 v26, 0xe00, v28, v27                          // 000000037FF0: D657001A 046E38FF 00000E00
	v_fma_mix_f32 v24, v24, v29, neg(0) op_sel_hi:[1,0,0]      // 000000037FFC: CC200018 8A023B18
	v_lshrrev_b32_e32 v28, 19, v17                             // 000000038004: 32382293
	v_and_or_b32 v21, 0xffff0000, v25, v34                     // 000000038008: D6570015 048A32FF FFFF0000
	v_lshrrev_b32_e32 v25, 4, v17                              // 000000038014: 32322284
	v_fma_mix_f32 v26, v26, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038018: CC20001A 8A023B1A
	v_mov_b16_e32 v34.l, v24.h                                 // 000000038020: 7E443998
	v_lshrrev_b32_e32 v24, 7, v17                              // 000000038024: 32302287
	v_lshrrev_b32_e32 v27, 8, v17                              // 000000038028: 32362288
	v_and_b32_e32 v28, 0xe00, v28                              // 00000003802C: 363838FF 00000E00
	v_lshrrev_b32_e32 v79, 11, v18                             // 000000038034: 329E248B
	v_and_or_b32 v22, 0xffff0000, v26, v34                     // 000000038038: D6570016 048A34FF FFFF0000
	v_and_b32_e32 v24, 0xe00, v24                              // 000000038044: 363030FF 00000E00
	v_lshrrev_b32_e32 v26, 15, v17                             // 00000003804C: 3234228F
	v_mov_b16_e32 v34.l, v17.h                                 // 000000038050: 7E443991
	v_lshlrev_b32_e32 v80, 8, v19                              // 000000038054: 30A02688
	v_lshrrev_b32_e32 v82, 3, v19                              // 000000038058: 32A42683
	v_and_or_b32 v24, 0x8000, v25, v24                         // 00000003805C: D6570018 046232FF 00008000
	v_lshrrev_b32_e32 v25, 11, v17                             // 000000038068: 3232228B
	v_lshrrev_b32_e32 v17, 12, v17                             // 00000003806C: 3222228C
	v_and_b32_e32 v26, 0xe00, v26                              // 000000038070: 363434FF 00000E00
	v_lshlrev_b32_e32 v83, 8, v20                              // 000000038078: 30A62888
	v_fma_mix_f32 v30, v24, v29, neg(0) op_sel_hi:[1,0,0]      // 00000003807C: CC20001E 8A023B18
	v_lshlrev_b32_e32 v24, 9, v18                              // 000000038084: 30302489
	v_and_b32_e32 v25, 0xe00, v25                              // 000000038088: 363232FF 00000E00
	v_and_or_b32 v17, 0x8000, v17, v26                         // 000000038090: D6570011 046A22FF 00008000
	v_and_or_b32 v26, 0x8000, v34, v28                         // 00000003809C: D657001A 047244FF 00008000
	v_lshlrev_b32_e32 v28, 12, v18                             // 0000000380A8: 3038248C
	v_and_b32_e32 v24, 0xe00, v24                              // 0000000380AC: 363030FF 00000E00
	v_and_or_b32 v25, 0x8000, v27, v25                         // 0000000380B4: D6570019 046636FF 00008000
	v_fma_mix_f32 v17, v17, v29, neg(0) op_sel_hi:[1,0,0]      // 0000000380C0: CC200011 8A023B11
	v_lshlrev_b32_e32 v27, 5, v18                              // 0000000380C8: 30362485
	v_fma_mix_f32 v26, v26, v29, neg(0) op_sel_hi:[1,0,0]      // 0000000380CC: CC20001A 8A023B1A
	v_and_or_b32 v24, 0x8000, v28, v24                         // 0000000380D4: D6570018 046238FF 00008000
	v_lshlrev_b32_e32 v28, 1, v18                              // 0000000380E0: 30382481
	v_mov_b16_e32 v34.l, v17.h                                 // 0000000380E4: 7E443991
	v_and_b32_e32 v27, 0xe00, v27                              // 0000000380E8: 363636FF 00000E00
	v_lshlrev_b32_e32 v17, 4, v18                              // 0000000380F0: 30222484
	v_fma_mix_f32 v32, v24, v29, neg(0) op_sel_hi:[1,0,0]      // 0000000380F4: CC200020 8A023B18
	v_and_b32_e32 v28, 0xe00, v28                              // 0000000380FC: 363838FF 00000E00
	v_and_or_b32 v24, 0xffff0000, v26, v34                     // 000000038104: D6570018 048A34FF FFFF0000
	v_and_or_b32 v27, 0x8000, v31, v27                         // 000000038110: D657001B 046E3EFF 00008000
	v_and_b32_e32 v31, 0x8000, v18                             // 00000003811C: 363E24FF 00008000
	v_mov_b16_e32 v34.l, v32.h                                 // 000000038124: 7E4439A0
	v_and_or_b32 v17, 0x8000, v17, v28                         // 000000038128: D6570011 047222FF 00008000
	v_lshrrev_b32_e32 v32, 19, v18                             // 000000038134: 32402493
	v_fma_mix_f32 v26, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038138: CC20001A 8A023B1B
	v_and_or_b32 v27, 0xe00, v35, v31                          // 000000038140: D657001B 047E46FF 00000E00
	v_fma_mix_f32 v31, v25, v29, neg(0) op_sel_hi:[1,0,0]      // 00000003814C: CC20001F 8A023B19
	v_fma_mix_f32 v17, v17, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038154: CC200011 8A023B11
	v_mov_b16_e32 v35.l, v30.h                                 // 00000003815C: 7E46399E
	v_and_or_b32 v25, 0xffff0000, v26, v34                     // 000000038160: D6570019 048A34FF FFFF0000
	v_fma_mix_f32 v26, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 00000003816C: CC20001A 8A023B1B
	v_lshrrev_b32_e32 v27, 4, v18                              // 000000038174: 32362484
	v_mov_b16_e32 v34.l, v17.h                                 // 000000038178: 7E443991
	v_lshrrev_b32_e32 v17, 7, v18                              // 00000003817C: 32222487
	v_lshrrev_b32_e32 v30, 15, v18                             // 000000038180: 323C248F
	v_lshrrev_b32_e32 v28, 8, v18                              // 000000038184: 32382488
	v_lshrrev_b32_e32 v85, 3, v20                              // 000000038188: 32AA2883
	v_and_or_b32 v26, 0xffff0000, v26, v34                     // 00000003818C: D657001A 048A34FF FFFF0000
	v_and_b32_e32 v17, 0xe00, v17                              // 000000038198: 362222FF 00000E00
	v_mov_b16_e32 v34.l, v18.h                                 // 0000000381A0: 7E443992
	v_lshrrev_b32_e32 v18, 12, v18                             // 0000000381A4: 3224248C
	v_lshrrev_b32_e32 v86, 12, v20                             // 0000000381A8: 32AC288C
	v_lshrrev_b32_e32 v87, 19, v20                             // 0000000381AC: 32AE2893
	v_and_or_b32 v17, 0x8000, v27, v17                         // 0000000381B0: D6570011 044636FF 00008000
	v_and_b32_e32 v27, 0xe00, v30                              // 0000000381BC: 36363CFF 00000E00
	v_and_b32_e32 v30, 0xe00, v32                              // 0000000381C4: 363C40FF 00000E00
	v_and_b32_e32 v32, 0xe00, v79                              // 0000000381CC: 36409EFF 00000E00
	v_lshlrev_b32_e32 v79, 9, v19                              // 0000000381D4: 309E2689
	v_fma_mix_f32 v17, v17, v29, neg(0) op_sel_hi:[1,0,0]      // 0000000381D8: CC200011 8A023B11
	v_and_or_b32 v18, 0x8000, v18, v27                         // 0000000381E0: D6570012 046E24FF 00008000
	v_and_or_b32 v27, 0x8000, v34, v30                         // 0000000381EC: D657001B 047A44FF 00008000
	v_and_or_b32 v30, 0x8000, v28, v32                         // 0000000381F8: D657001E 048238FF 00008000
	v_lshlrev_b32_e32 v28, 12, v19                             // 000000038204: 3038268C
	v_and_b32_e32 v32, 0xe00, v79                              // 000000038208: 36409EFF 00000E00
	v_fma_mix_f32 v18, v18, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038210: CC200012 8A023B12
	v_lshlrev_b32_e32 v79, 5, v19                              // 000000038218: 309E2685
	v_fma_mix_f32 v27, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 00000003821C: CC20001B 8A023B1B
	v_mov_b16_e32 v35.h, v34.h                                 // 000000038224: 7F4639A2
	v_and_or_b32 v28, 0x8000, v28, v32                         // 000000038228: D657001C 048238FF 00008000
	v_lshlrev_b32_e32 v32, 1, v19                              // 000000038234: 30402681
	v_and_b32_e32 v79, 0xe00, v79                              // 000000038238: 369E9EFF 00000E00
	v_mov_b16_e32 v34.l, v18.h                                 // 000000038240: 7E443992
	v_lshlrev_b32_e32 v18, 4, v19                              // 000000038244: 30242684
	v_fma_mix_f32 v81, v28, v23, neg(0) op_sel_hi:[1,0,0]      // 000000038248: CC200051 8A022F1C
	v_and_b32_e32 v32, 0xe00, v32                              // 000000038250: 364040FF 00000E00
	v_and_or_b32 v79, 0x8000, v80, v79                         // 000000038258: D657004F 053EA0FF 00008000
	v_and_b32_e32 v80, 0x8000, v19                             // 000000038264: 36A026FF 00008000
	v_and_or_b32 v28, 0xffff0000, v27, v34                     // 00000003826C: D657001C 048A36FF FFFF0000
	v_mov_b16_e32 v34.l, v81.h                                 // 000000038278: 7E4439D1
	v_and_or_b32 v18, 0x8000, v18, v32                         // 00000003827C: D6570012 048224FF 00008000
	v_fma_mix_f32 v27, v79, v23, neg(0) op_sel_hi:[1,0,0]      // 000000038288: CC20001B 8A022F4F
	v_and_or_b32 v32, 0xe00, v82, v80                          // 000000038290: D6570020 0542A4FF 00000E00
	v_fma_mix_f32 v79, v30, v29, neg(0) op_sel_hi:[1,0,0]      // 00000003829C: CC20004F 8A023B1E
	v_mov_b16_e32 v80.l, v17.h                                 // 0000000382A4: 7EA03991
	v_fma_mix_f32 v18, v18, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000382A8: CC200012 8A022F12
	v_and_or_b32 v29, 0xffff0000, v27, v34                     // 0000000382B0: D657001D 048A36FF FFFF0000
	v_fma_mix_f32 v17, v32, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000382BC: CC200011 8A022F20
	v_lshrrev_b32_e32 v32, 7, v19                              // 0000000382C4: 32402687
	v_lshrrev_b32_e32 v81, 19, v19                             // 0000000382C8: 32A22693
	v_mov_b16_e32 v34.l, v18.h                                 // 0000000382CC: 7E443992
	v_lshrrev_b32_e32 v18, 4, v19                              // 0000000382D0: 32242684
	v_lshrrev_b32_e32 v27, 8, v19                              // 0000000382D4: 32362688
	v_and_b32_e32 v32, 0xe00, v32                              // 0000000382D8: 364040FF 00000E00
	v_lshrrev_b32_e32 v82, 11, v19                             // 0000000382E0: 32A4268B
	v_and_or_b32 v30, 0xffff0000, v17, v34                     // 0000000382E4: D657001E 048A22FF FFFF0000
	v_lshrrev_b32_e32 v17, 15, v19                             // 0000000382F0: 3222268F
	v_mov_b16_e32 v34.l, v19.h                                 // 0000000382F4: 7E443993
	v_lshrrev_b32_e32 v19, 12, v19                             // 0000000382F8: 3226268C
	v_and_b32_e32 v81, 0xe00, v81                              // 0000000382FC: 36A2A2FF 00000E00
	v_and_or_b32 v18, 0x8000, v18, v32                         // 000000038304: D6570012 048224FF 00008000
	v_and_b32_e32 v17, 0xe00, v17                              // 000000038310: 362222FF 00000E00
	v_lshlrev_b32_e32 v32, 9, v20                              // 000000038318: 30402889
	v_and_b32_e32 v82, 0xe00, v82                              // 00000003831C: 36A4A4FF 00000E00
	v_mov_b16_e32 v80.h, v34.h                                 // 000000038324: 7FA039A2
	v_fma_mix_f32 v18, v18, v23, neg(0) op_sel_hi:[1,0,0]      // 000000038328: CC200012 8A022F12
	v_and_or_b32 v17, 0x8000, v19, v17                         // 000000038330: D6570011 044626FF 00008000
	v_and_or_b32 v19, 0x8000, v34, v81                         // 00000003833C: D6570013 054644FF 00008000
	v_lshlrev_b32_e32 v81, 12, v20                             // 000000038348: 30A2288C
	v_and_b32_e32 v32, 0xe00, v32                              // 00000003834C: 364040FF 00000E00
	v_and_or_b32 v27, 0x8000, v27, v82                         // 000000038354: D657001B 054A36FF 00008000
	v_fma_mix_f32 v17, v17, v23, neg(0) op_sel_hi:[1,0,0]      // 000000038360: CC200011 8A022F11
	v_lshlrev_b32_e32 v82, 5, v20                              // 000000038368: 30A42885
	v_fma_mix_f32 v19, v19, v23, neg(0) op_sel_hi:[1,0,0]      // 00000003836C: CC200013 8A022F13
	v_and_or_b32 v32, 0x8000, v81, v32                         // 000000038374: D6570020 0482A2FF 00008000
	v_lshlrev_b32_e32 v81, 1, v20                              // 000000038380: 30A22881
	v_mov_b16_e32 v34.l, v17.h                                 // 000000038384: 7E443991
	v_and_b32_e32 v82, 0xe00, v82                              // 000000038388: 36A4A4FF 00000E00
	v_lshlrev_b32_e32 v17, 4, v20                              // 000000038390: 30222884
	v_fma_mix_f32 v84, v32, v23, neg(0) op_sel_hi:[1,0,0]      // 000000038394: CC200054 8A022F20
	v_and_b32_e32 v81, 0xe00, v81                              // 00000003839C: 36A2A2FF 00000E00
	v_and_or_b32 v32, 0xffff0000, v19, v34                     // 0000000383A4: D6570020 048A26FF FFFF0000
	v_and_or_b32 v82, 0x8000, v83, v82                         // 0000000383B0: D6570052 054AA6FF 00008000
	v_and_b32_e32 v83, 0x8000, v20                             // 0000000383BC: 36A628FF 00008000
	v_mov_b16_e32 v34.l, v84.h                                 // 0000000383C4: 7E4439D4
	v_and_or_b32 v17, 0x8000, v17, v81                         // 0000000383C8: D6570011 054622FF 00008000
	v_lshrrev_b32_e32 v84, 8, v20                              // 0000000383D4: 32A82888
	v_fma_mix_f32 v19, v82, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000383D8: CC200013 8A022F52
	v_and_or_b32 v81, 0xe00, v85, v83                          // 0000000383E0: D6570051 054EAAFF 00000E00
	v_fma_mix_f32 v83, v27, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000383EC: CC200053 8A022F1B
	v_fma_mix_f32 v82, v17, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000383F4: CC200052 8A022F11
	v_lshrrev_b32_e32 v27, 4, v20                              // 0000000383FC: 32362884
	v_and_or_b32 v17, 0xffff0000, v19, v34                     // 000000038400: D6570011 048A26FF FFFF0000
	v_fma_mix_f32 v19, v81, v23, neg(0) op_sel_hi:[1,0,0]      // 00000003840C: CC200013 8A022F51
	v_mov_b16_e32 v81.l, v18.h                                 // 000000038414: 7EA23992
	v_mov_b16_e32 v34.l, v82.h                                 // 000000038418: 7E4439D2
	v_lshrrev_b32_e32 v82, 7, v20                              // 00000003841C: 32A42887
	v_lshrrev_b32_e32 v85, 11, v20                             // 000000038420: 32AA288B
	v_mov_b16_e32 v81.h, v34.h                                 // 000000038424: 7FA239A2
	s_delay_alu instid0(VALU_DEP_4)                            // 000000038428: BF870004
	v_and_or_b32 v18, 0xffff0000, v19, v34                     // 00000003842C: D6570012 048A26FF FFFF0000
	v_lshrrev_b32_e32 v19, 15, v20                             // 000000038438: 3226288F
	v_and_b32_e32 v82, 0xe00, v82                              // 00000003843C: 36A4A4FF 00000E00
	v_and_b32_e32 v85, 0xe00, v85                              // 000000038444: 36AAAAFF 00000E00
	v_mov_b16_e32 v34.l, v20.h                                 // 00000003844C: 7E443994
	v_and_b32_e32 v20, 0xe00, v87                              // 000000038450: 3628AEFF 00000E00
	v_and_b32_e32 v19, 0xe00, v19                              // 000000038458: 362626FF 00000E00
	v_and_or_b32 v27, 0x8000, v27, v82                         // 000000038460: D657001B 054A36FF 00008000
	v_and_or_b32 v82, 0x8000, v84, v85                         // 00000003846C: D6570052 0556A8FF 00008000
	v_mov_b16_e32 v84.h, v34.h                                 // 000000038478: 7FA839A2
	v_and_or_b32 v20, 0x8000, v34, v20                         // 00000003847C: D6570014 045244FF 00008000
	v_and_or_b32 v19, 0x8000, v86, v19                         // 000000038488: D6570013 044EACFF 00008000
	v_fma_mix_f32 v27, v27, v23, neg(0) op_sel_hi:[1,0,0]      // 000000038494: CC20001B 8A022F1B
	v_fma_mix_f32 v82, v82, v23, neg(0) op_sel_hi:[1,0,0]      // 00000003849C: CC200052 8A022F52
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)// 0000000384A4: BF870214
	v_fma_mix_f32 v20, v20, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000384A8: CC200014 8A022F14
	v_fma_mix_f32 v19, v19, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000384B0: CC200013 8A022F13
	s_delay_alu instid0(VALU_DEP_4)                            // 0000000384B8: BF870004
	v_mov_b16_e32 v84.l, v27.h                                 // 0000000384BC: 7EA8399B
	v_and_or_b32 v23, 0xffff0000, v31, v35                     // 0000000384C0: D6570017 048E3EFF FFFF0000
	v_and_or_b32 v27, 0xffff0000, v79, v80                     // 0000000384CC: D657001B 05429EFF FFFF0000
	v_and_or_b32 v31, 0xffff0000, v83, v81                     // 0000000384D8: D657001F 0546A6FF FFFF0000
	v_mov_b16_e32 v34.l, v19.h                                 // 0000000384E4: 7E443993
	v_and_or_b32 v19, 0xffff0000, v82, v84                     // 0000000384E8: D6570013 0552A4FF FFFF0000
	s_delay_alu instid0(VALU_DEP_2)                            // 0000000384F4: BF870002
	v_and_or_b32 v20, 0xffff0000, v20, v34                     // 0000000384F8: D6570014 048A28FF FFFF0000
	s_and_not1_saveexec_b32 s4, s28                            // 000000038504: BE84301C
	s_cbranch_execz 19                                         // 000000038508: BFA50013 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0xf58>
	s_wait_dscnt 0x0                                           // 00000003850C: BFC60000
	v_add_co_u32 v17, vcc_lo, v34, v58                         // 000000038510: D7006A11 02027522
	s_wait_alu depctr_va_vcc(0)                                // 000000038518: BF88FF9D
	v_add_co_ci_u32_e64 v18, null, 0, v35, vcc_lo              // 00000003851C: D5207C12 01AA4680
	s_clause 0x3                                               // 000000038524: BF850003
	global_load_b128 v[21:24], v[17:18], off                   // 000000038528: EE05C07C 00000015 00000011
	global_load_b128 v[25:28], v[17:18], off offset:16         // 000000038534: EE05C07C 00000019 00001011
	global_load_b128 v[29:32], v[17:18], off offset:32         // 000000038540: EE05C07C 0000001D 00002011
	global_load_b128 v[17:20], v[17:18], off offset:48         // 00000003854C: EE05C07C 00000011 00003011
	s_wait_alu depctr_sa_sdst(0)                               // 000000038558: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 00000003855C: 8C7E047E
	s_wait_loadcnt 0x3                                         // 000000038560: BFC00003
	ds_store_b128 v59, v[21:24]                                // 000000038564: DB7C0000 0000153B
	s_wait_loadcnt 0x2                                         // 00000003856C: BFC00002
	ds_store_b128 v60, v[25:28]                                // 000000038570: DB7C0000 0000193C
	s_wait_loadcnt 0x1                                         // 000000038578: BFC00001
	ds_store_b128 v61, v[29:32]                                // 00000003857C: DB7C0000 00001D3D
	s_wait_loadcnt 0x0                                         // 000000038584: BFC00000
	ds_store_b128 v62, v[17:20]                                // 000000038588: DB7C0000 0000113E
	s_or_b32 exec_lo, exec_lo, s27                             // 000000038590: 8C7E1B7E
	s_wait_loadcnt_dscnt 0x0                                   // 000000038594: BFC80000
	s_barrier_signal -1                                        // 000000038598: BE804EC1
	s_cmp_lt_i32 s26, 1                                        // 00000003859C: BF04811A
	s_barrier_wait 0xffff                                      // 0000000385A0: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 0000000385A4: EE0AC07C 00040000 00000000
	s_cbranch_scc1 65009                                       // 0000000385B0: BFA2FDF1 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x778>
	v_cmp_gt_u32_e32 vcc_lo, 32, v73                           // 0000000385B4: 7C9892A0
	v_med3_i32 v17, s25, 1, 16                                 // 0000000385B8: D6200011 02410219
	v_dual_mov_b32 v24, v64 :: v_dual_mov_b32 v23, v63         // 0000000385C0: CA100140 1816013F
	s_wait_alu depctr_va_vcc(0)                                // 0000000385C8: BF88FF9D
	v_cndmask_b32_e32 v18, v68, v73, vcc_lo                    // 0000000385CC: 02249344
	v_cmp_gt_u32_e32 vcc_lo, 32, v74                           // 0000000385D0: 7C9894A0
	v_readfirstlane_b32 s4, v17                                // 0000000385D4: 7E080511
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_4) | instid1(VALU_DEP_2)// 0000000385D8: BF870153
	v_lshlrev_b32_e32 v17, 2, v18                              // 0000000385DC: 30222482
	s_wait_alu depctr_va_vcc(0)                                // 0000000385E0: BF88FF9D
	v_cndmask_b32_e32 v19, v68, v74, vcc_lo                    // 0000000385E4: 02269544
	v_cmp_gt_u32_e32 vcc_lo, 32, v75                           // 0000000385E8: 7C9896A0
	s_lshl_b32 s4, s4, 10                                      // 0000000385EC: 84048A04
	v_lshlrev_b32_e32 v18, 2, v19                              // 0000000385F0: 30242682
	s_wait_alu depctr_va_vcc(0)                                // 0000000385F4: BF88FF9D
	v_cndmask_b32_e32 v20, v68, v75, vcc_lo                    // 0000000385F8: 02289744
	v_cmp_gt_u32_e32 vcc_lo, 32, v76                           // 0000000385FC: 7C9898A0
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)// 000000038600: BF870142
	v_lshlrev_b32_e32 v19, 2, v20                              // 000000038604: 30262882
	s_wait_alu depctr_va_vcc(0)                                // 000000038608: BF88FF9D
	v_cndmask_b32_e32 v21, v68, v76, vcc_lo                    // 00000003860C: 022A9944
	v_cmp_gt_u32_e32 vcc_lo, 32, v77                           // 000000038610: 7C989AA0
	v_lshlrev_b32_e32 v20, 2, v21                              // 000000038614: 30282A82
	s_wait_alu depctr_va_vcc(0)                                // 000000038618: BF88FF9D
	v_cndmask_b32_e32 v22, v68, v77, vcc_lo                    // 00000003861C: 022C9B44
	s_delay_alu instid0(VALU_DEP_1)                            // 000000038620: BF870001
	v_dual_mov_b32 v22, v78 :: v_dual_lshlrev_b32 v21, 2, v22  // 000000038624: CA22014E 16142C82
	s_branch 11                                                // 00000003862C: BFA0000B <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x105c>
	s_or_b32 exec_lo, exec_lo, s26                             // 000000038630: 8C7E1A7E
	v_add_nc_u32_e32 v24, 0x400, v24                           // 000000038634: 4A3030FF 00000400
	v_add_nc_u32_e32 v23, 0x400, v23                           // 00000003863C: 4A2E2EFF 00000400
	v_add_nc_u32_e32 v22, 4, v22                               // 000000038644: 4A2C2C84
	s_wait_alu depctr_sa_sdst(0)                               // 000000038648: BF88FF9E
	s_addk_co_i32 s4, 0xfc00                                   // 00000003864C: B784FC00
	s_wait_alu depctr_sa_sdst(0)                               // 000000038650: BF88FF9E
	s_cmp_eq_u32 s4, 0                                         // 000000038654: BF068004
	s_cbranch_scc1 64967                                       // 000000038658: BFA2FDC7 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x778>
	s_wait_dscnt 0x0                                           // 00000003865C: BFC60000
	ds_load_b128 v[25:28], v23                                 // 000000038660: DBFC0000 19000017
	s_wait_dscnt 0x0                                           // 000000038668: BFC60000
	v_lshlrev_b32_e32 v35, 16, v26                             // 00000003866C: 30463490
	v_lshlrev_b32_e32 v29, 16, v25                             // 000000038670: 303A3290
	v_and_b32_e32 v25, 0xffff0000, v25                         // 000000038674: 363232FF FFFF0000
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)// 00000003867C: BF870142
	v_fma_f32 v34, v13, v29, 0                                 // 000000038680: D6130022 02023B0D
	ds_load_b128 v[29:32], v24                                 // 000000038688: DBFC0000 1D000018
	v_dual_fmac_f32 v34, v14, v25 :: v_dual_and_b32 v25, 0xffff0000, v26// 000000038690: C824330E 221834FF FFFF0000
	v_lshlrev_b32_e32 v26, 16, v27                             // 00000003869C: 30343690
	v_fmac_f32_e32 v34, v15, v35                               // 0000000386A0: 5644470F
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000386A4: BF870091
	v_dual_fmac_f32 v34, v16, v25 :: v_dual_and_b32 v25, 0xffff0000, v27// 0000000386A8: C8243310 221836FF FFFF0000
	v_fmac_f32_e32 v34, v9, v26                                // 0000000386B4: 56443509
	v_lshlrev_b32_e32 v26, 16, v28                             // 0000000386B8: 30343890
	s_wait_dscnt 0x0                                           // 0000000386BC: BFC60000
	v_mov_b16_e32 v27.l, v29.l                                 // 0000000386C0: 7E36391D
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000386C4: BF870093
	v_dual_fmac_f32 v34, v10, v25 :: v_dual_and_b32 v25, 0xffff0000, v28// 0000000386C8: C824330A 221838FF FFFF0000
	v_fmac_f32_e32 v34, v11, v26                               // 0000000386D4: 5644350B
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)// 0000000386D8: BF8701A3
	v_lshlrev_b32_e32 v26, 16, v27                             // 0000000386DC: 30343690
	v_mov_b16_e32 v27.l, v30.l                                 // 0000000386E0: 7E36391E
	v_fmac_f32_e32 v34, v12, v25                               // 0000000386E4: 5644330C
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_3)// 0000000386E8: BF870191
	v_dual_fmac_f32 v34, v5, v26 :: v_dual_and_b32 v25, 0xffff0000, v29// 0000000386EC: C8243505 22183AFF FFFF0000
	v_lshlrev_b32_e32 v26, 16, v27                             // 0000000386F8: 30343690
	v_mov_b16_e32 v27.l, v31.l                                 // 0000000386FC: 7E36391F
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000038700: BF870093
	v_dual_fmac_f32 v34, v6, v25 :: v_dual_and_b32 v25, 0xffff0000, v30// 000000038704: C8243306 22183CFF FFFF0000
	v_fmac_f32_e32 v34, v7, v26                                // 000000038710: 56443507
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_1) | instid1(VALU_DEP_3)// 000000038714: BF8701A3
	v_lshlrev_b32_e32 v26, 16, v27                             // 000000038718: 30343690
	v_mov_b16_e32 v27.l, v32.l                                 // 00000003871C: 7E363920
	v_dual_fmac_f32 v34, v8, v25 :: v_dual_and_b32 v25, 0xffff0000, v31// 000000038720: C8243308 22183EFF FFFF0000
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_3)// 00000003872C: BF870191
	v_fmac_f32_e32 v34, v1, v26                                // 000000038730: 56443501
	v_lshlrev_b32_e32 v26, 16, v27                             // 000000038734: 30343690
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000038738: BF870092
	v_dual_fmac_f32 v34, v2, v25 :: v_dual_and_b32 v25, 0xffff0000, v32// 00000003873C: C8243302 221840FF FFFF0000
	v_fmac_f32_e32 v34, v3, v26                                // 000000038748: 56443503
	s_delay_alu instid0(VALU_DEP_1)                            // 00000003874C: BF870001
	v_fmac_f32_e32 v34, v4, v25                                // 000000038750: 56443304
	ds_bpermute_b32 v25, v17, v34                              // 000000038754: DACC0000 19002211
	s_wait_dscnt 0x0                                           // 00000003875C: BFC60000
	v_add_f32_e32 v25, v34, v25                                // 000000038760: 06323322
	ds_bpermute_b32 v26, v18, v25                              // 000000038764: DACC0000 1A001912
	s_wait_dscnt 0x0                                           // 00000003876C: BFC60000
	v_add_f32_e32 v25, v25, v26                                // 000000038770: 06323519
	ds_bpermute_b32 v26, v19, v25                              // 000000038774: DACC0000 1A001913
	s_wait_dscnt 0x0                                           // 00000003877C: BFC60000
	v_add_f32_e32 v25, v25, v26                                // 000000038780: 06323519
	ds_bpermute_b32 v26, v20, v25                              // 000000038784: DACC0000 1A001914
	s_wait_dscnt 0x0                                           // 00000003878C: BFC60000
	v_add_f32_e32 v25, v25, v26                                // 000000038790: 06323519
	ds_bpermute_b32 v26, v21, v25                              // 000000038794: DACC0000 1A001915
	s_and_saveexec_b32 s26, s2                                 // 00000003879C: BE9A2002
	s_cbranch_execz 65443                                      // 0000000387A0: BFA5FFA3 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1030>
	s_wait_dscnt 0x0                                           // 0000000387A4: BFC60000
	v_add_f32_e32 v25, v25, v26                                // 0000000387A8: 06323519
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000387AC: BF870001
	v_mul_f32_e32 v25, s17, v25                                // 0000000387B0: 10323211
	ds_store_b32 v22, v25 offset:16384                         // 0000000387B4: D8344000 00001916
	s_branch 65436                                             // 0000000387BC: BFA0FF9C <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1030>
	s_and_saveexec_b32 s24, s3                                 // 0000000387C0: BE982003
	s_cbranch_execz 208                                        // 0000000387C4: BFA500D0 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1508>
	v_cmp_gt_i32_e32 vcc_lo, s23, v53                          // 0000000387C8: 7C886A17
	v_mov_b32_e32 v17, 0xff800000                              // 0000000387CC: 7E2202FF FF800000
	s_and_saveexec_b32 s23, vcc_lo                             // 0000000387D4: BE97206A
	s_cbranch_execz 23                                         // 0000000387D8: BFA50017 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1238>
	v_dual_mov_b32 v17, 0xff800000 :: v_dual_mov_b32 v18, v72  // 0000000387DC: CA1000FF 11120148 FF800000
	v_mov_b32_e32 v19, v53                                     // 0000000387E8: 7E260335
	s_mov_b32 s25, 0                                           // 0000000387EC: BE990080
	ds_load_b32 v20, v18 offset:16384                          // 0000000387F0: D8D84000 14000012
	v_add_nc_u32_e32 v19, 32, v19                              // 0000000387F8: 4A2626A0
	v_dual_max_num_f32 v17, v17, v17 :: v_dual_add_nc_u32 v18, 0x80, v18// 0000000387FC: CAA02311 111224FF 00000080
	s_wait_dscnt 0x0                                           // 000000038808: BFC60000
	v_max_num_f32_e32 v20, v20, v20                            // 00000003880C: 2C282914
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000038810: BF870113
	v_cmp_le_i32_e64 s4, s19, v19                              // 000000038814: D4430004 02022613
	v_max_num_f32_e32 v17, v17, v20                            // 00000003881C: 2C222911
	s_wait_alu depctr_sa_sdst(0)                               // 000000038820: BF88FF9E
	s_or_b32 s25, s4, s25                                      // 000000038824: 8C191904
	s_wait_alu depctr_sa_sdst(0)                               // 000000038828: BF88FF9E
	s_and_not1_b32 exec_lo, exec_lo, s25                       // 00000003882C: 917E197E
	s_cbranch_execnz 65519                                     // 000000038830: BFA6FFEF <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x11f0>
	s_or_b32 exec_lo, exec_lo, s25                             // 000000038834: 8C7E197E
	s_wait_alu depctr_sa_sdst(0)                               // 000000038838: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s23                             // 00000003883C: 8C7E177E
	v_cmp_gt_u32_e64 s4, 32, v73                               // 000000038840: D44C0004 020292A0
	s_wait_alu depctr_va_sdst(0)                               // 000000038848: BF88F19F
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 00000003884C: BF870121
	v_cndmask_b32_e64 v18, v68, v73, s4                        // 000000038850: D5010012 00129344
	v_cmp_gt_u32_e64 s4, 32, v74                               // 000000038858: D44C0004 020294A0
	v_lshlrev_b32_e32 v18, 2, v18                              // 000000038860: 30242482
	s_wait_alu depctr_va_sdst(0)                               // 000000038864: BF88F19F
	s_delay_alu instid0(VALU_DEP_2)                            // 000000038868: BF870002
	v_cndmask_b32_e64 v20, v68, v74, s4                        // 00000003886C: D5010014 00129544
	v_cmp_gt_u32_e64 s4, 32, v75                               // 000000038874: D44C0004 020296A0
	ds_bpermute_b32 v19, v18, v17                              // 00000003887C: DACC0000 13001112
	v_max_num_f32_e32 v17, v17, v17                            // 000000038884: 2C222311
	s_wait_dscnt 0x0                                           // 000000038888: BFC60000
	v_max_num_f32_e32 v21, v19, v19                            // 00000003888C: 2C2A2713
	v_lshlrev_b32_e32 v19, 2, v20                              // 000000038890: 30262882
	s_delay_alu instid0(VALU_DEP_2)                            // 000000038894: BF870002
	v_max_num_f32_e32 v17, v17, v21                            // 000000038898: 2C222B11
	s_wait_alu depctr_va_sdst(0)                               // 00000003889C: BF88F19F
	v_cndmask_b32_e64 v21, v68, v75, s4                        // 0000000388A0: D5010015 00129744
	v_cmp_gt_u32_e64 s4, 32, v76                               // 0000000388A8: D44C0004 020298A0
	ds_bpermute_b32 v20, v19, v17                              // 0000000388B0: DACC0000 14001113
	s_wait_dscnt 0x0                                           // 0000000388B8: BFC60000
	v_max_num_f32_e32 v22, v20, v20                            // 0000000388BC: 2C2C2914
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000388C0: BF870001
	v_dual_max_num_f32 v17, v17, v22 :: v_dual_lshlrev_b32 v20, 2, v21// 0000000388C4: CAA22D11 11142A82
	s_wait_alu depctr_va_sdst(0)                               // 0000000388CC: BF88F19F
	v_cndmask_b32_e64 v22, v68, v76, s4                        // 0000000388D0: D5010016 00129944
	v_cmp_gt_u32_e64 s4, 32, v77                               // 0000000388D8: D44C0004 02029AA0
	ds_bpermute_b32 v21, v20, v17                              // 0000000388E0: DACC0000 15001114
	v_lshlrev_b32_e32 v22, 2, v22                              // 0000000388E8: 302C2C82
	s_wait_alu depctr_va_sdst(0)                               // 0000000388EC: BF88F19F
	v_cndmask_b32_e64 v23, v68, v77, s4                        // 0000000388F0: D5010017 00129B44
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_1)// 0000000388F8: BF8700B1
	v_lshlrev_b32_e32 v23, 2, v23                              // 0000000388FC: 302E2E82
	s_wait_dscnt 0x0                                           // 000000038900: BFC60000
	v_max_num_f32_e32 v21, v21, v21                            // 000000038904: 2C2A2B15
	v_max_num_f32_e32 v17, v17, v21                            // 000000038908: 2C222B11
	ds_bpermute_b32 v21, v22, v17                              // 00000003890C: DACC0000 15001116
	s_wait_dscnt 0x0                                           // 000000038914: BFC60000
	v_max_num_f32_e32 v21, v21, v21                            // 000000038918: 2C2A2B15
	s_delay_alu instid0(VALU_DEP_1)                            // 00000003891C: BF870001
	v_max_num_f32_e32 v17, v17, v21                            // 000000038920: 2C222B11
	ds_load_b32 v21, v67                                       // 000000038924: D8D80000 15000043
	ds_bpermute_b32 v24, v23, v17                              // 00000003892C: DACC0000 18001117
	s_wait_dscnt 0x0                                           // 000000038934: BFC60000
	v_max3_num_f32 v17, v21, v17, v24                          // 000000038938: D62A0011 04622315
	v_mov_b32_e32 v24, 0                                       // 000000038940: 7E300280
	s_and_saveexec_b32 s4, vcc_lo                              // 000000038944: BE84206A
	s_cbranch_execz 49                                         // 000000038948: BFA50031 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1410>
	v_dual_mov_b32 v24, 0 :: v_dual_mov_b32 v25, v53           // 00000003894C: CA100080 18180135
	s_mov_b32 s23, 0                                           // 000000038954: BE970080
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(VALU_DEP_1)// 000000038958: BF8700D1
	v_lshl_add_u32 v26, v25, 2, v66                            // 00000003895C: D646001A 05090519
	v_add_nc_u32_e32 v25, 32, v25                              // 000000038964: 4A3232A0
	ds_load_b32 v27, v26                                       // 000000038968: D8D80000 1B00001A
	s_wait_dscnt 0x0                                           // 000000038970: BFC60000
	v_sub_f32_e32 v27, v27, v17                                // 000000038974: 0836231B
	v_mul_f32_e32 v28, 0x3fb8aa3b, v27                         // 000000038978: 103836FF 3FB8AA3B
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)// 000000038980: BF8700A1
	v_fma_f32 v29, 0x3fb8aa3b, v27, -v28                       // 000000038984: D613001D 847236FF 3FB8AA3B
	v_rndne_f32_e32 v30, v28                                   // 000000038990: 7E3C471C
	v_sub_f32_e32 v28, v28, v30                                // 000000038994: 08383D1C
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2ce8ed0, v27                  // 000000038998: 7C3636FF C2CE8ED0
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000389A0: BF870094
	v_fmac_f32_e32 v29, 0x32a5705f, v27                        // 0000000389A4: 563A36FF 32A5705F
	v_add_f32_e32 v28, v28, v29                                // 0000000389AC: 06383B1C
	v_cvt_i32_f32_e32 v29, v30                                 // 0000000389B0: 7E3A111E
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(TRANS32_DEP_1)// 0000000389B4: BF870292
	v_exp_f32_e32 v28, v28                                     // 0000000389B8: 7E384B1C
	v_ldexp_f32 v28, v28, v29                                  // 0000000389BC: D71C001C 02023B1C
	s_wait_alu depctr_va_vcc(0)                                // 0000000389C4: BF88FF9D
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)// 0000000389C8: BF870131
	v_cndmask_b32_e32 v28, 0, v28, vcc_lo                      // 0000000389CC: 02383880
	v_cmp_nlt_f32_e32 vcc_lo, 0x42b17218, v27                  // 0000000389D0: 7C3C36FF 42B17218
	s_wait_alu depctr_va_vcc(0)                                // 0000000389D8: BF88FF9D
	v_cndmask_b32_e32 v27, 0x7f800000, v28, vcc_lo             // 0000000389DC: 023638FF 7F800000
	v_cmp_le_i32_e32 vcc_lo, s19, v25                          // 0000000389E4: 7C863213
	s_delay_alu instid0(VALU_DEP_2)                            // 0000000389E8: BF870002
	v_add_f32_e32 v24, v24, v27                                // 0000000389EC: 06303718
	s_wait_alu depctr_sa_sdst(0)                               // 0000000389F0: BF88FF9E
	s_or_b32 s23, vcc_lo, s23                                  // 0000000389F4: 8C17176A
	ds_store_b32 v26, v27                                      // 0000000389F8: D8340000 00001B1A
	s_wait_alu depctr_sa_sdst(0)                               // 000000038A00: BF88FF9E
	s_and_not1_b32 exec_lo, exec_lo, s23                       // 000000038A04: 917E177E
	s_cbranch_execnz 65491                                     // 000000038A08: BFA6FFD3 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1358>
	s_or_b32 exec_lo, exec_lo, s23                             // 000000038A0C: 8C7E177E
	s_wait_alu depctr_sa_sdst(0)                               // 000000038A10: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000038A14: 8C7E047E
	ds_bpermute_b32 v18, v18, v24                              // 000000038A18: DACC0000 12001812
	s_wait_dscnt 0x0                                           // 000000038A20: BFC60000
	v_add_f32_e32 v18, v24, v18                                // 000000038A24: 06242518
	ds_bpermute_b32 v19, v19, v18                              // 000000038A28: DACC0000 13001213
	s_wait_dscnt 0x0                                           // 000000038A30: BFC60000
	v_add_f32_e32 v18, v18, v19                                // 000000038A34: 06242712
	ds_bpermute_b32 v19, v20, v18                              // 000000038A38: DACC0000 13001214
	s_wait_dscnt 0x0                                           // 000000038A40: BFC60000
	v_add_f32_e32 v18, v18, v19                                // 000000038A44: 06242712
	ds_bpermute_b32 v19, v22, v18                              // 000000038A48: DACC0000 13001216
	s_wait_dscnt 0x0                                           // 000000038A50: BFC60000
	v_add_f32_e32 v18, v18, v19                                // 000000038A54: 06242712
	ds_bpermute_b32 v19, v23, v18                              // 000000038A58: DACC0000 13001217
	s_and_b32 exec_lo, exec_lo, s2                             // 000000038A60: 8B7E027E
	s_cbranch_execz 40                                         // 000000038A64: BFA50028 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1508>
	v_sub_f32_e32 v20, v21, v17                                // 000000038A68: 08282315
	s_wait_dscnt 0x0                                           // 000000038A6C: BFC60000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 000000038A70: BF870121
	v_dual_add_f32 v18, v18, v19 :: v_dual_mul_f32 v21, 0x3fb8aa3b, v20// 000000038A74: C9062712 121428FF 3FB8AA3B
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2ce8ed0, v20                  // 000000038A80: 7C3628FF C2CE8ED0
	v_fma_f32 v22, 0x3fb8aa3b, v20, -v21                       // 000000038A88: D6130016 845628FF 3FB8AA3B
	v_rndne_f32_e32 v23, v21                                   // 000000038A94: 7E2E4715
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 000000038A98: BF870121
	v_dual_fmac_f32 v22, 0x32a5705f, v20 :: v_dual_sub_f32 v21, v21, v23// 000000038A9C: C80A28FF 16142F15 32A5705F
	v_cvt_i32_f32_e32 v23, v23                                 // 000000038AA8: 7E2E1117
	v_add_f32_e32 v21, v21, v22                                // 000000038AAC: 062A2D15
	ds_load_b32 v22, v70                                       // 000000038AB0: D8D80000 16000046
	v_exp_f32_e32 v21, v21                                     // 000000038AB8: 7E2A4B15
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)// 000000038ABC: BF8700A5
	v_ldexp_f32 v21, v21, v23                                  // 000000038AC0: D71C0015 02022F15
	s_wait_alu depctr_va_vcc(0)                                // 000000038AC8: BF88FF9D
	v_cndmask_b32_e32 v21, 0, v21, vcc_lo                      // 000000038ACC: 022A2A80
	v_cmp_nlt_f32_e32 vcc_lo, 0x42b17218, v20                  // 000000038AD0: 7C3C28FF 42B17218
	s_wait_alu depctr_va_vcc(0)                                // 000000038AD8: BF88FF9D
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_1)// 000000038ADC: BF8700A2
	v_cndmask_b32_e32 v19, 0x7f800000, v21, vcc_lo             // 000000038AE0: 02262AFF 7F800000
	s_wait_dscnt 0x0                                           // 000000038AE8: BFC60000
	v_fmac_f32_e32 v18, v19, v22                               // 000000038AEC: 56242D13
	ds_store_b32 v69, v19                                      // 000000038AF0: D8340000 00001345
	ds_store_b32 v70, v18                                      // 000000038AF8: D8340000 00001246
	ds_store_b32 v67, v17                                      // 000000038B00: D8340000 00001143
	s_wait_alu depctr_sa_sdst(0)                               // 000000038B08: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s24                             // 000000038B0C: 8C7E187E
	s_wait_loadcnt_dscnt 0x0                                   // 000000038B10: BFC80000
	s_barrier_signal -1                                        // 000000038B14: BE804EC1
	s_and_not1_b32 vcc_lo, exec_lo, s22                        // 000000038B18: 916A167E
	s_barrier_wait 0xffff                                      // 000000038B1C: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 000000038B20: EE0AC07C 00040000 00000000
	ds_load_b128 v[17:20], v33 offset:18944                    // 000000038B2C: DBFC4A00 11000021
	ds_load_b128 v[21:24], v33 offset:18960                    // 000000038B34: DBFC4A10 15000021
	s_wait_dscnt 0x1                                           // 000000038B3C: BFC60001
	v_dual_mul_f32 v51, v51, v17 :: v_dual_mul_f32 v48, v48, v18// 000000038B40: C8C62333 33302530
	v_dual_mul_f32 v50, v50, v17 :: v_dual_mul_f32 v49, v49, v18// 000000038B48: C8C62332 32302531
	v_dual_mul_f32 v47, v47, v19 :: v_dual_mul_f32 v44, v44, v20// 000000038B50: C8C6272F 2F2C292C
	v_dual_mul_f32 v46, v46, v19 :: v_dual_mul_f32 v45, v45, v20// 000000038B58: C8C6272E 2E2C292D
	s_wait_dscnt 0x0                                           // 000000038B60: BFC60000
	v_dual_mul_f32 v43, v43, v21 :: v_dual_mul_f32 v38, v38, v22// 000000038B64: C8C62B2B 2B262D26
	v_dual_mul_f32 v42, v42, v21 :: v_dual_mul_f32 v41, v41, v22// 000000038B6C: C8C62B2A 2A282D29
	v_dual_mul_f32 v40, v40, v23 :: v_dual_mul_f32 v39, v39, v24// 000000038B74: C8C62F28 28263127
	v_dual_mul_f32 v37, v37, v23 :: v_dual_mul_f32 v36, v36, v24// 000000038B7C: C8C62F25 25243124
	s_wait_alu depctr_sa_sdst(0)                               // 000000038B84: BF88FF9E
	s_cbranch_vccnz 64564                                      // 000000038B88: BFA4FC34 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x65c>
	s_mov_b32 s22, 0                                           // 000000038B8C: BE960080
	s_mov_b32 s23, 0                                           // 000000038B90: BE970080
	s_branch 12                                                // 000000038B94: BFA0000C <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x15c8>
	s_wait_loadcnt 0x0                                         // 000000038B98: BFC00000
	s_barrier_signal -1                                        // 000000038B9C: BE804EC1
	s_add_co_i32 s23, s23, 16                                  // 000000038BA0: 81179017
	s_add_co_i32 s21, s21, -16                                 // 000000038BA4: 8115D015
	s_add_co_i32 s22, s22, 64                                  // 000000038BA8: 8116C016
	s_wait_alu depctr_sa_sdst(0)                               // 000000038BAC: BF88FF9E
	s_cmp_ge_i32 s23, s19                                      // 000000038BB0: BF031317
	s_barrier_wait 0xffff                                      // 000000038BB4: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 000000038BB8: EE0AC07C 00040000 00000000
	s_cbranch_scc1 64549                                       // 000000038BC4: BFA2FC25 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x65c>
	s_wait_alu depctr_sa_sdst(0)                               // 000000038BC8: BF88FF9E
	s_sub_co_i32 s24, s19, s23                                 // 000000038BCC: 81981713
	s_mov_b32 s25, exec_lo                                     // 000000038BD0: BE99007E
	s_wait_alu depctr_sa_sdst(0)                               // 000000038BD4: BF88FF9E
	s_min_i32 s4, s24, 16                                      // 000000038BD8: 89049018
	s_wait_alu depctr_sa_sdst(0)                               // 000000038BDC: BF88FF9E
	v_cmpx_gt_u32_e64 s4, v54                                  // 000000038BE0: D4CC007E 02026C04
	s_cbranch_execz 499                                        // 000000038BE8: BFA501F3 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1db8>
	v_add_nc_u32_e32 v17, s23, v54                             // 000000038BEC: 4A226C17
	s_delay_alu instid0(VALU_DEP_1)                            // 000000038BF0: BF870001
	v_lshlrev_b32_e32 v18, 3, v17                              // 000000038BF4: 30242283
	v_add_nc_u32_e32 v17, s16, v17                             // 000000038BF8: 4A222210
	ds_load_b64 v[34:35], v18 offset:18432                     // 000000038BFC: D9D84800 22000012
	v_cmp_le_i32_e32 vcc_lo, s20, v17                          // 000000038C04: 7C862214
	s_and_saveexec_b32 s4, vcc_lo                              // 000000038C08: BE84206A
	s_wait_alu depctr_sa_sdst(0)                               // 000000038C0C: BF88FF9E
	s_xor_b32 s26, exec_lo, s4                                 // 000000038C10: 8D1A047E
	s_cbranch_execz 453                                        // 000000038C14: BFA501C5 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1d2c>
	s_wait_dscnt 0x0                                           // 000000038C18: BFC60000
	v_add_co_u32 v21, vcc_lo, v34, v57                         // 000000038C1C: D7006A15 02027322
	s_wait_alu depctr_va_vcc(0)                                // 000000038C24: BF88FF9D
	v_add_co_ci_u32_e64 v22, null, 0, v35, vcc_lo              // 000000038C28: D5207C16 01AA4680
	v_add_co_u32 v17, vcc_lo, v34, v56                         // 000000038C30: D7006A11 02027122
	s_wait_alu depctr_va_vcc(0)                                // 000000038C38: BF88FF9D
	v_add_co_ci_u32_e64 v18, null, 0, v35, vcc_lo              // 000000038C3C: D5207C12 01AA4680
	global_load_d16_i8 v24, v[21:22], off offset:256           // 000000038C44: EE07C07C 00000018 00010015
	v_mov_b32_e32 v25, 0x7fc00000                              // 000000038C50: 7E3202FF 7FC00000
	v_mov_b32_e32 v23, 0x7fc00000                              // 000000038C58: 7E2E02FF 7FC00000
	global_load_b128 v[17:20], v[17:18], off                   // 000000038C60: EE05C07C 00000011 00000011
	s_wait_loadcnt 0x1                                         // 000000038C6C: BFC00001
	v_bfe_u32 v27, v24, 3, 4                                   // 000000038C70: D610001B 02110718
	v_and_b32_e32 v26, 7, v24                                  // 000000038C78: 36343087
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000038C7C: BF870112
	v_cmp_ne_u32_e32 vcc_lo, 15, v27                           // 000000038C80: 7C9A368F
	v_cmp_ne_u32_e64 s4, 7, v26                                // 000000038C84: D44D0004 02023487
	s_or_b32 s27, s4, vcc_lo                                   // 000000038C8C: 8C1B6A04
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000038C90: BF870009
	s_and_saveexec_b32 s4, s27                                 // 000000038C94: BE84201B
	s_cbranch_execz 15                                         // 000000038C98: BFA5000F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x16d8>
	s_mov_b32 s27, exec_lo                                     // 000000038C9C: BE9B007E
	v_cmpx_ne_u32_e32 0, v27                                   // 000000038CA0: 7D9A3680
	s_xor_b32 s27, exec_lo, s27                                // 000000038CA4: 8D1B1B7E
	v_lshlrev_b32_e32 v25, 20, v26                             // 000000038CA8: 30323494
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000038CAC: BF870091
	v_lshl_or_b32 v25, v27, 23, v25                            // 000000038CB0: D6560019 04652F1B
	v_add_nc_u32_e32 v25, 0x3c000000, v25                      // 000000038CB8: 4A3232FF 3C000000
	s_and_not1_saveexec_b32 s27, s27                           // 000000038CC0: BE9B301B
	v_cvt_f32_ubyte0_e32 v25, v26                              // 000000038CC4: 7E32231A
	s_delay_alu instid0(VALU_DEP_1)                            // 000000038CC8: BF870001
	v_mul_f32_e32 v25, 0x3b000000, v25                         // 000000038CCC: 103232FF 3B000000
	s_or_b32 exec_lo, exec_lo, s27                             // 000000038CD4: 8C7E1B7E
	s_wait_alu depctr_sa_sdst(0)                               // 000000038CD8: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000038CDC: 8C7E047E
	global_load_d16_i8 v22, v[21:22], off offset:257           // 000000038CE0: EE07C07C 00000016 00010115
	s_wait_loadcnt 0x0                                         // 000000038CEC: BFC00000
	v_bfe_u32 v26, v22, 3, 4                                   // 000000038CF0: D610001A 02110716
	v_and_b32_e32 v21, 7, v22                                  // 000000038CF8: 362A2C87
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000038CFC: BF870112
	v_cmp_ne_u32_e32 vcc_lo, 15, v26                           // 000000038D00: 7C9A348F
	v_cmp_ne_u32_e64 s4, 7, v21                                // 000000038D04: D44D0004 02022A87
	s_or_b32 s27, s4, vcc_lo                                   // 000000038D0C: 8C1B6A04
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000038D10: BF870009
	s_and_saveexec_b32 s4, s27                                 // 000000038D14: BE84201B
	s_cbranch_execz 15                                         // 000000038D18: BFA5000F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1758>
	s_mov_b32 s27, exec_lo                                     // 000000038D1C: BE9B007E
	v_cmpx_ne_u32_e32 0, v26                                   // 000000038D20: 7D9A3480
	s_xor_b32 s27, exec_lo, s27                                // 000000038D24: 8D1B1B7E
	v_lshlrev_b32_e32 v21, 20, v21                             // 000000038D28: 302A2A94
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000038D2C: BF870091
	v_lshl_or_b32 v21, v26, 23, v21                            // 000000038D30: D6560015 04552F1A
	v_add_nc_u32_e32 v23, 0x3c000000, v21                      // 000000038D38: 4A2E2AFF 3C000000
	s_and_not1_saveexec_b32 s27, s27                           // 000000038D40: BE9B301B
	v_cvt_f32_ubyte0_e32 v21, v21                              // 000000038D44: 7E2A2315
	s_delay_alu instid0(VALU_DEP_1)                            // 000000038D48: BF870001
	v_mul_f32_e32 v23, 0x3b000000, v21                         // 000000038D4C: 102E2AFF 3B000000
	s_or_b32 exec_lo, exec_lo, s27                             // 000000038D54: 8C7E1B7E
	s_wait_alu depctr_sa_sdst(0)                               // 000000038D58: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000038D5C: 8C7E047E
	v_cmp_gt_i16_e32 vcc_lo, 0, v24.l                          // 000000038D60: 7C683080
	v_lshlrev_b32_e32 v21, 9, v17                              // 000000038D64: 302A2289
	v_lshlrev_b32_e32 v27, 8, v17                              // 000000038D68: 30362288
	v_mov_b16_e32 v34.h, 0                                     // 000000038D6C: 7F443880
	v_lshlrev_b32_e32 v31, 8, v18                              // 000000038D70: 303E2488
	s_wait_alu depctr_va_vcc(0)                                // 000000038D74: BF88FF9D
	v_cndmask_b32_e64 v24, v25, -v25, vcc_lo                   // 000000038D78: D5010018 41AA3319
	v_cmp_gt_i16_e32 vcc_lo, 0, v22.l                          // 000000038D80: 7C682C80
	v_lshlrev_b32_e32 v25, 5, v17                              // 000000038D84: 30322285
	v_lshlrev_b32_e32 v26, 12, v17                             // 000000038D88: 3034228C
	v_and_b32_e32 v21, 0xe00, v21                              // 000000038D8C: 362A2AFF 00000E00
	v_mul_f32_e32 v29, 0x46800000, v24                         // 000000038D94: 103A30FF 46800000
	s_wait_alu depctr_va_vcc(0)                                // 000000038D9C: BF88FF9D
	v_cndmask_b32_e64 v23, v23, -v23, vcc_lo                   // 000000038DA0: D5010017 41AA2F17
	v_lshlrev_b32_e32 v28, 1, v17                              // 000000038DA8: 30382281
	v_and_b32_e32 v25, 0xe00, v25                              // 000000038DAC: 363232FF 00000E00
	v_and_or_b32 v21, 0x8000, v26, v21                         // 000000038DB4: D6570015 045634FF 00008000
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)// 000000038DC0: BF870214
	v_dual_mul_f32 v23, 0x46800000, v23 :: v_dual_lshlrev_b32 v24, 4, v17// 000000038DC4: C8E22EFF 17182284 46800000
	v_and_b32_e32 v26, 0xe00, v28                              // 000000038DD0: 363438FF 00000E00
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)// 000000038DD8: BF870214
	v_and_or_b32 v25, 0x8000, v27, v25                         // 000000038DDC: D6570019 046636FF 00008000
	v_fma_mix_f32 v21, v21, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038DE8: CC200015 8A023B15
	v_and_b32_e32 v27, 0x8000, v17                             // 000000038DF0: 363622FF 00008000
	v_lshrrev_b32_e32 v28, 3, v17                              // 000000038DF8: 32382283
	v_and_or_b32 v24, 0x8000, v24, v26                         // 000000038DFC: D6570018 046A30FF 00008000
	v_fma_mix_f32 v25, v25, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038E08: CC200019 8A023B19
	v_mov_b16_e32 v34.l, v21.h                                 // 000000038E10: 7E443995
	v_lshrrev_b32_e32 v35, 3, v18                              // 000000038E14: 32462483
	v_and_or_b32 v26, 0xe00, v28, v27                          // 000000038E18: D657001A 046E38FF 00000E00
	v_fma_mix_f32 v24, v24, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038E24: CC200018 8A023B18
	v_lshrrev_b32_e32 v28, 19, v17                             // 000000038E2C: 32382293
	v_and_or_b32 v21, 0xffff0000, v25, v34                     // 000000038E30: D6570015 048A32FF FFFF0000
	v_lshrrev_b32_e32 v25, 4, v17                              // 000000038E3C: 32322284
	v_fma_mix_f32 v26, v26, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038E40: CC20001A 8A023B1A
	v_mov_b16_e32 v34.l, v24.h                                 // 000000038E48: 7E443998
	v_lshrrev_b32_e32 v24, 7, v17                              // 000000038E4C: 32302287
	v_lshrrev_b32_e32 v27, 8, v17                              // 000000038E50: 32362288
	v_and_b32_e32 v28, 0xe00, v28                              // 000000038E54: 363838FF 00000E00
	v_lshrrev_b32_e32 v78, 11, v18                             // 000000038E5C: 329C248B
	v_and_or_b32 v22, 0xffff0000, v26, v34                     // 000000038E60: D6570016 048A34FF FFFF0000
	v_and_b32_e32 v24, 0xe00, v24                              // 000000038E6C: 363030FF 00000E00
	v_lshrrev_b32_e32 v26, 15, v17                             // 000000038E74: 3234228F
	v_mov_b16_e32 v34.l, v17.h                                 // 000000038E78: 7E443991
	v_lshlrev_b32_e32 v79, 8, v19                              // 000000038E7C: 309E2688
	v_lshrrev_b32_e32 v81, 3, v19                              // 000000038E80: 32A22683
	v_and_or_b32 v24, 0x8000, v25, v24                         // 000000038E84: D6570018 046232FF 00008000
	v_lshrrev_b32_e32 v25, 11, v17                             // 000000038E90: 3232228B
	v_lshrrev_b32_e32 v17, 12, v17                             // 000000038E94: 3222228C
	v_and_b32_e32 v26, 0xe00, v26                              // 000000038E98: 363434FF 00000E00
	v_lshlrev_b32_e32 v82, 8, v20                              // 000000038EA0: 30A42888
	v_fma_mix_f32 v30, v24, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038EA4: CC20001E 8A023B18
	v_lshlrev_b32_e32 v24, 9, v18                              // 000000038EAC: 30302489
	v_and_b32_e32 v25, 0xe00, v25                              // 000000038EB0: 363232FF 00000E00
	v_and_or_b32 v17, 0x8000, v17, v26                         // 000000038EB8: D6570011 046A22FF 00008000
	v_and_or_b32 v26, 0x8000, v34, v28                         // 000000038EC4: D657001A 047244FF 00008000
	v_lshlrev_b32_e32 v28, 12, v18                             // 000000038ED0: 3038248C
	v_and_b32_e32 v24, 0xe00, v24                              // 000000038ED4: 363030FF 00000E00
	v_and_or_b32 v25, 0x8000, v27, v25                         // 000000038EDC: D6570019 046636FF 00008000
	v_fma_mix_f32 v17, v17, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038EE8: CC200011 8A023B11
	v_lshlrev_b32_e32 v27, 5, v18                              // 000000038EF0: 30362485
	v_fma_mix_f32 v26, v26, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038EF4: CC20001A 8A023B1A
	v_and_or_b32 v24, 0x8000, v28, v24                         // 000000038EFC: D6570018 046238FF 00008000
	v_lshlrev_b32_e32 v28, 1, v18                              // 000000038F08: 30382481
	v_mov_b16_e32 v34.l, v17.h                                 // 000000038F0C: 7E443991
	v_and_b32_e32 v27, 0xe00, v27                              // 000000038F10: 363636FF 00000E00
	v_lshlrev_b32_e32 v17, 4, v18                              // 000000038F18: 30222484
	v_fma_mix_f32 v32, v24, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038F1C: CC200020 8A023B18
	v_and_b32_e32 v28, 0xe00, v28                              // 000000038F24: 363838FF 00000E00
	v_and_or_b32 v24, 0xffff0000, v26, v34                     // 000000038F2C: D6570018 048A34FF FFFF0000
	v_and_or_b32 v27, 0x8000, v31, v27                         // 000000038F38: D657001B 046E3EFF 00008000
	v_and_b32_e32 v31, 0x8000, v18                             // 000000038F44: 363E24FF 00008000
	v_mov_b16_e32 v34.l, v32.h                                 // 000000038F4C: 7E4439A0
	v_and_or_b32 v17, 0x8000, v17, v28                         // 000000038F50: D6570011 047222FF 00008000
	v_lshrrev_b32_e32 v32, 19, v18                             // 000000038F5C: 32402493
	v_fma_mix_f32 v26, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038F60: CC20001A 8A023B1B
	v_and_or_b32 v27, 0xe00, v35, v31                          // 000000038F68: D657001B 047E46FF 00000E00
	v_fma_mix_f32 v31, v25, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038F74: CC20001F 8A023B19
	v_fma_mix_f32 v17, v17, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038F7C: CC200011 8A023B11
	v_mov_b16_e32 v35.l, v30.h                                 // 000000038F84: 7E46399E
	v_and_or_b32 v25, 0xffff0000, v26, v34                     // 000000038F88: D6570019 048A34FF FFFF0000
	v_fma_mix_f32 v26, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 000000038F94: CC20001A 8A023B1B
	v_lshrrev_b32_e32 v27, 4, v18                              // 000000038F9C: 32362484
	v_mov_b16_e32 v34.l, v17.h                                 // 000000038FA0: 7E443991
	v_lshrrev_b32_e32 v17, 7, v18                              // 000000038FA4: 32222487
	v_lshrrev_b32_e32 v30, 15, v18                             // 000000038FA8: 323C248F
	v_lshrrev_b32_e32 v28, 8, v18                              // 000000038FAC: 32382488
	v_lshrrev_b32_e32 v84, 3, v20                              // 000000038FB0: 32A82883
	v_and_or_b32 v26, 0xffff0000, v26, v34                     // 000000038FB4: D657001A 048A34FF FFFF0000
	v_and_b32_e32 v17, 0xe00, v17                              // 000000038FC0: 362222FF 00000E00
	v_mov_b16_e32 v34.l, v18.h                                 // 000000038FC8: 7E443992
	v_lshrrev_b32_e32 v18, 12, v18                             // 000000038FCC: 3224248C
	v_lshrrev_b32_e32 v85, 12, v20                             // 000000038FD0: 32AA288C
	v_lshrrev_b32_e32 v86, 19, v20                             // 000000038FD4: 32AC2893
	v_and_or_b32 v17, 0x8000, v27, v17                         // 000000038FD8: D6570011 044636FF 00008000
	v_and_b32_e32 v27, 0xe00, v30                              // 000000038FE4: 36363CFF 00000E00
	v_and_b32_e32 v30, 0xe00, v32                              // 000000038FEC: 363C40FF 00000E00
	v_and_b32_e32 v32, 0xe00, v78                              // 000000038FF4: 36409CFF 00000E00
	v_lshlrev_b32_e32 v78, 9, v19                              // 000000038FFC: 309C2689
	v_fma_mix_f32 v17, v17, v29, neg(0) op_sel_hi:[1,0,0]      // 000000039000: CC200011 8A023B11
	v_and_or_b32 v18, 0x8000, v18, v27                         // 000000039008: D6570012 046E24FF 00008000
	v_and_or_b32 v27, 0x8000, v34, v30                         // 000000039014: D657001B 047A44FF 00008000
	v_and_or_b32 v30, 0x8000, v28, v32                         // 000000039020: D657001E 048238FF 00008000
	v_lshlrev_b32_e32 v28, 12, v19                             // 00000003902C: 3038268C
	v_and_b32_e32 v32, 0xe00, v78                              // 000000039030: 36409CFF 00000E00
	v_fma_mix_f32 v18, v18, v29, neg(0) op_sel_hi:[1,0,0]      // 000000039038: CC200012 8A023B12
	v_lshlrev_b32_e32 v78, 5, v19                              // 000000039040: 309C2685
	v_fma_mix_f32 v27, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 000000039044: CC20001B 8A023B1B
	v_mov_b16_e32 v35.h, v34.h                                 // 00000003904C: 7F4639A2
	v_and_or_b32 v28, 0x8000, v28, v32                         // 000000039050: D657001C 048238FF 00008000
	v_lshlrev_b32_e32 v32, 1, v19                              // 00000003905C: 30402681
	v_and_b32_e32 v78, 0xe00, v78                              // 000000039060: 369C9CFF 00000E00
	v_mov_b16_e32 v34.l, v18.h                                 // 000000039068: 7E443992
	v_lshlrev_b32_e32 v18, 4, v19                              // 00000003906C: 30242684
	v_fma_mix_f32 v80, v28, v23, neg(0) op_sel_hi:[1,0,0]      // 000000039070: CC200050 8A022F1C
	v_and_b32_e32 v32, 0xe00, v32                              // 000000039078: 364040FF 00000E00
	v_and_or_b32 v78, 0x8000, v79, v78                         // 000000039080: D657004E 053A9EFF 00008000
	v_and_b32_e32 v79, 0x8000, v19                             // 00000003908C: 369E26FF 00008000
	v_and_or_b32 v28, 0xffff0000, v27, v34                     // 000000039094: D657001C 048A36FF FFFF0000
	v_mov_b16_e32 v34.l, v80.h                                 // 0000000390A0: 7E4439D0
	v_and_or_b32 v18, 0x8000, v18, v32                         // 0000000390A4: D6570012 048224FF 00008000
	v_fma_mix_f32 v27, v78, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000390B0: CC20001B 8A022F4E
	v_and_or_b32 v32, 0xe00, v81, v79                          // 0000000390B8: D6570020 053EA2FF 00000E00
	v_fma_mix_f32 v78, v30, v29, neg(0) op_sel_hi:[1,0,0]      // 0000000390C4: CC20004E 8A023B1E
	v_mov_b16_e32 v79.l, v17.h                                 // 0000000390CC: 7E9E3991
	v_fma_mix_f32 v18, v18, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000390D0: CC200012 8A022F12
	v_and_or_b32 v29, 0xffff0000, v27, v34                     // 0000000390D8: D657001D 048A36FF FFFF0000
	v_fma_mix_f32 v17, v32, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000390E4: CC200011 8A022F20
	v_lshrrev_b32_e32 v32, 7, v19                              // 0000000390EC: 32402687
	v_lshrrev_b32_e32 v80, 19, v19                             // 0000000390F0: 32A02693
	v_mov_b16_e32 v34.l, v18.h                                 // 0000000390F4: 7E443992
	v_lshrrev_b32_e32 v18, 4, v19                              // 0000000390F8: 32242684
	v_lshrrev_b32_e32 v27, 8, v19                              // 0000000390FC: 32362688
	v_and_b32_e32 v32, 0xe00, v32                              // 000000039100: 364040FF 00000E00
	v_lshrrev_b32_e32 v81, 11, v19                             // 000000039108: 32A2268B
	v_and_or_b32 v30, 0xffff0000, v17, v34                     // 00000003910C: D657001E 048A22FF FFFF0000
	v_lshrrev_b32_e32 v17, 15, v19                             // 000000039118: 3222268F
	v_mov_b16_e32 v34.l, v19.h                                 // 00000003911C: 7E443993
	v_lshrrev_b32_e32 v19, 12, v19                             // 000000039120: 3226268C
	v_and_b32_e32 v80, 0xe00, v80                              // 000000039124: 36A0A0FF 00000E00
	v_and_or_b32 v18, 0x8000, v18, v32                         // 00000003912C: D6570012 048224FF 00008000
	v_and_b32_e32 v17, 0xe00, v17                              // 000000039138: 362222FF 00000E00
	v_lshlrev_b32_e32 v32, 9, v20                              // 000000039140: 30402889
	v_and_b32_e32 v81, 0xe00, v81                              // 000000039144: 36A2A2FF 00000E00
	v_mov_b16_e32 v79.h, v34.h                                 // 00000003914C: 7F9E39A2
	v_fma_mix_f32 v18, v18, v23, neg(0) op_sel_hi:[1,0,0]      // 000000039150: CC200012 8A022F12
	v_and_or_b32 v17, 0x8000, v19, v17                         // 000000039158: D6570011 044626FF 00008000
	v_and_or_b32 v19, 0x8000, v34, v80                         // 000000039164: D6570013 054244FF 00008000
	v_lshlrev_b32_e32 v80, 12, v20                             // 000000039170: 30A0288C
	v_and_b32_e32 v32, 0xe00, v32                              // 000000039174: 364040FF 00000E00
	v_and_or_b32 v27, 0x8000, v27, v81                         // 00000003917C: D657001B 054636FF 00008000
	v_fma_mix_f32 v17, v17, v23, neg(0) op_sel_hi:[1,0,0]      // 000000039188: CC200011 8A022F11
	v_lshlrev_b32_e32 v81, 5, v20                              // 000000039190: 30A22885
	v_fma_mix_f32 v19, v19, v23, neg(0) op_sel_hi:[1,0,0]      // 000000039194: CC200013 8A022F13
	v_and_or_b32 v32, 0x8000, v80, v32                         // 00000003919C: D6570020 0482A0FF 00008000
	v_lshlrev_b32_e32 v80, 1, v20                              // 0000000391A8: 30A02881
	v_mov_b16_e32 v34.l, v17.h                                 // 0000000391AC: 7E443991
	v_and_b32_e32 v81, 0xe00, v81                              // 0000000391B0: 36A2A2FF 00000E00
	v_lshlrev_b32_e32 v17, 4, v20                              // 0000000391B8: 30222884
	v_fma_mix_f32 v83, v32, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000391BC: CC200053 8A022F20
	v_and_b32_e32 v80, 0xe00, v80                              // 0000000391C4: 36A0A0FF 00000E00
	v_and_or_b32 v32, 0xffff0000, v19, v34                     // 0000000391CC: D6570020 048A26FF FFFF0000
	v_and_or_b32 v81, 0x8000, v82, v81                         // 0000000391D8: D6570051 0546A4FF 00008000
	v_and_b32_e32 v82, 0x8000, v20                             // 0000000391E4: 36A428FF 00008000
	v_mov_b16_e32 v34.l, v83.h                                 // 0000000391EC: 7E4439D3
	v_and_or_b32 v17, 0x8000, v17, v80                         // 0000000391F0: D6570011 054222FF 00008000
	v_lshrrev_b32_e32 v83, 8, v20                              // 0000000391FC: 32A62888
	v_fma_mix_f32 v19, v81, v23, neg(0) op_sel_hi:[1,0,0]      // 000000039200: CC200013 8A022F51
	v_and_or_b32 v80, 0xe00, v84, v82                          // 000000039208: D6570050 054AA8FF 00000E00
	v_fma_mix_f32 v82, v27, v23, neg(0) op_sel_hi:[1,0,0]      // 000000039214: CC200052 8A022F1B
	v_fma_mix_f32 v81, v17, v23, neg(0) op_sel_hi:[1,0,0]      // 00000003921C: CC200051 8A022F11
	v_lshrrev_b32_e32 v27, 4, v20                              // 000000039224: 32362884
	v_and_or_b32 v17, 0xffff0000, v19, v34                     // 000000039228: D6570011 048A26FF FFFF0000
	v_fma_mix_f32 v19, v80, v23, neg(0) op_sel_hi:[1,0,0]      // 000000039234: CC200013 8A022F50
	v_mov_b16_e32 v80.l, v18.h                                 // 00000003923C: 7EA03992
	v_mov_b16_e32 v34.l, v81.h                                 // 000000039240: 7E4439D1
	v_lshrrev_b32_e32 v81, 7, v20                              // 000000039244: 32A22887
	v_lshrrev_b32_e32 v84, 11, v20                             // 000000039248: 32A8288B
	v_mov_b16_e32 v80.h, v34.h                                 // 00000003924C: 7FA039A2
	s_delay_alu instid0(VALU_DEP_4)                            // 000000039250: BF870004
	v_and_or_b32 v18, 0xffff0000, v19, v34                     // 000000039254: D6570012 048A26FF FFFF0000
	v_lshrrev_b32_e32 v19, 15, v20                             // 000000039260: 3226288F
	v_and_b32_e32 v81, 0xe00, v81                              // 000000039264: 36A2A2FF 00000E00
	v_and_b32_e32 v84, 0xe00, v84                              // 00000003926C: 36A8A8FF 00000E00
	v_mov_b16_e32 v34.l, v20.h                                 // 000000039274: 7E443994
	v_and_b32_e32 v20, 0xe00, v86                              // 000000039278: 3628ACFF 00000E00
	v_and_b32_e32 v19, 0xe00, v19                              // 000000039280: 362626FF 00000E00
	v_and_or_b32 v27, 0x8000, v27, v81                         // 000000039288: D657001B 054636FF 00008000
	v_and_or_b32 v81, 0x8000, v83, v84                         // 000000039294: D6570051 0552A6FF 00008000
	v_mov_b16_e32 v83.h, v34.h                                 // 0000000392A0: 7FA639A2
	v_and_or_b32 v20, 0x8000, v34, v20                         // 0000000392A4: D6570014 045244FF 00008000
	v_and_or_b32 v19, 0x8000, v85, v19                         // 0000000392B0: D6570013 044EAAFF 00008000
	v_fma_mix_f32 v27, v27, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000392BC: CC20001B 8A022F1B
	v_fma_mix_f32 v81, v81, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000392C4: CC200051 8A022F51
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)// 0000000392CC: BF870214
	v_fma_mix_f32 v20, v20, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000392D0: CC200014 8A022F14
	v_fma_mix_f32 v19, v19, v23, neg(0) op_sel_hi:[1,0,0]      // 0000000392D8: CC200013 8A022F13
	s_delay_alu instid0(VALU_DEP_4)                            // 0000000392E0: BF870004
	v_mov_b16_e32 v83.l, v27.h                                 // 0000000392E4: 7EA6399B
	v_and_or_b32 v23, 0xffff0000, v31, v35                     // 0000000392E8: D6570017 048E3EFF FFFF0000
	v_and_or_b32 v27, 0xffff0000, v78, v79                     // 0000000392F4: D657001B 053E9CFF FFFF0000
	v_and_or_b32 v31, 0xffff0000, v82, v80                     // 000000039300: D657001F 0542A4FF FFFF0000
	v_mov_b16_e32 v34.l, v19.h                                 // 00000003930C: 7E443993
	v_and_or_b32 v19, 0xffff0000, v81, v83                     // 000000039310: D6570013 054EA2FF FFFF0000
	s_delay_alu instid0(VALU_DEP_2)                            // 00000003931C: BF870002
	v_and_or_b32 v20, 0xffff0000, v20, v34                     // 000000039320: D6570014 048A28FF FFFF0000
	s_and_not1_saveexec_b32 s4, s26                            // 00000003932C: BE84301A
	s_cbranch_execz 19                                         // 000000039330: BFA50013 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1d80>
	s_wait_dscnt 0x0                                           // 000000039334: BFC60000
	v_add_co_u32 v17, vcc_lo, v34, v58                         // 000000039338: D7006A11 02027522
	s_wait_alu depctr_va_vcc(0)                                // 000000039340: BF88FF9D
	v_add_co_ci_u32_e64 v18, null, 0, v35, vcc_lo              // 000000039344: D5207C12 01AA4680
	s_clause 0x3                                               // 00000003934C: BF850003
	global_load_b128 v[21:24], v[17:18], off                   // 000000039350: EE05C07C 00000015 00000011
	global_load_b128 v[25:28], v[17:18], off offset:16         // 00000003935C: EE05C07C 00000019 00001011
	global_load_b128 v[29:32], v[17:18], off offset:32         // 000000039368: EE05C07C 0000001D 00002011
	global_load_b128 v[17:20], v[17:18], off offset:48         // 000000039374: EE05C07C 00000011 00003011
	s_wait_alu depctr_sa_sdst(0)                               // 000000039380: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000039384: 8C7E047E
	s_wait_loadcnt 0x3                                         // 000000039388: BFC00003
	ds_store_b128 v59, v[21:24]                                // 00000003938C: DB7C0000 0000153B
	s_wait_loadcnt 0x2                                         // 000000039394: BFC00002
	ds_store_b128 v60, v[25:28]                                // 000000039398: DB7C0000 0000193C
	s_wait_loadcnt 0x1                                         // 0000000393A0: BFC00001
	ds_store_b128 v61, v[29:32]                                // 0000000393A4: DB7C0000 00001D3D
	s_wait_loadcnt 0x0                                         // 0000000393AC: BFC00000
	ds_store_b128 v62, v[17:20]                                // 0000000393B0: DB7C0000 0000113E
	s_or_b32 exec_lo, exec_lo, s25                             // 0000000393B8: 8C7E197E
	s_wait_loadcnt_dscnt 0x0                                   // 0000000393BC: BFC80000
	s_barrier_signal -1                                        // 0000000393C0: BE804EC1
	s_cmp_lt_i32 s24, 1                                        // 0000000393C4: BF048118
	s_barrier_wait 0xffff                                      // 0000000393C8: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 0000000393CC: EE0AC07C 00040000 00000000
	s_cbranch_scc1 65007                                       // 0000000393D8: BFA2FDEF <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1598>
	v_med3_i32 v17, s21, 1, 16                                 // 0000000393DC: D6200011 02410215
	s_mov_b32 s24, s22                                         // 0000000393E4: BE980016
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000393E8: BF870001
	v_readfirstlane_b32 s4, v17                                // 0000000393EC: 7E080511
	v_mov_b32_e32 v17, v71                                     // 0000000393F0: 7E220347
	s_lshl_b32 s4, s4, 10                                      // 0000000393F4: 84048A04
	ds_load_b32 v26, v17                                       // 0000000393F8: D8D80000 1A000011
	s_wait_alu depctr_sa_sdst(0)                               // 000000039400: BF88FF9E
	v_dual_mov_b32 v24, s24 :: v_dual_add_nc_u32 v17, 0x400, v17// 000000039404: CA200018 181022FF 00000400
	s_addk_co_i32 s4, 0xfc00                                   // 000000039410: B784FC00
	s_add_co_i32 s24, s24, 4                                   // 000000039414: 81188418
	ds_load_2addr_stride64_b32 v[18:19], v24 offset0:64 offset1:65// 000000039418: D8E04140 12000018
	ds_load_2addr_stride64_b32 v[20:21], v24 offset0:66 offset1:67// 000000039420: D8E04342 14000018
	ds_load_2addr_stride64_b32 v[22:23], v24 offset0:68 offset1:69// 000000039428: D8E04544 16000018
	ds_load_2addr_stride64_b32 v[24:25], v24 offset0:70 offset1:71// 000000039430: D8E04746 18000018
	s_wait_alu depctr_sa_sdst(0)                               // 000000039438: BF88FF9E
	s_cmp_eq_u32 s4, 0                                         // 00000003943C: BF068004
	s_wait_dscnt 0x4                                           // 000000039440: BFC60004
	v_lshlrev_b32_e32 v27, 16, v26                             // 000000039444: 30363490
	s_wait_dscnt 0x3                                           // 000000039448: BFC60003
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 00000003944C: BF870091
	v_dual_fmac_f32 v51, v18, v27 :: v_dual_and_b32 v26, 0xffff0000, v26// 000000039450: C8243712 331A34FF FFFF0000
	v_dual_fmac_f32 v50, v18, v26 :: v_dual_fmac_f32 v49, v19, v27// 00000003945C: C8003512 32303713
	s_wait_dscnt 0x2                                           // 000000039464: BFC60002
	v_dual_fmac_f32 v48, v19, v26 :: v_dual_fmac_f32 v47, v20, v27// 000000039468: C8003513 302E3714
	v_dual_fmac_f32 v46, v20, v26 :: v_dual_fmac_f32 v45, v21, v27// 000000039470: C8003514 2E2C3715
	s_wait_dscnt 0x1                                           // 000000039478: BFC60001
	v_dual_fmac_f32 v44, v21, v26 :: v_dual_fmac_f32 v43, v22, v27// 00000003947C: C8003515 2C2A3716
	v_dual_fmac_f32 v42, v22, v26 :: v_dual_fmac_f32 v41, v23, v27// 000000039484: C8003516 2A283717
	s_wait_dscnt 0x0                                           // 00000003948C: BFC60000
	v_dual_fmac_f32 v38, v23, v26 :: v_dual_fmac_f32 v39, v25, v27// 000000039490: C8003517 26263719
	v_fmac_f32_e32 v40, v24, v27                               // 000000039498: 56503718
	v_fmac_f32_e32 v37, v24, v26                               // 00000003949C: 564A3518
	v_fmac_f32_e32 v36, v25, v26                               // 0000000394A0: 56483519
	s_cbranch_scc0 65492                                       // 0000000394A4: BFA1FFD4 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1df8>
	s_branch 64955                                             // 0000000394A8: BFA0FDBB <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1598>
	s_load_b64 s[2:3], s[0:1], 0x108                           // 0000000394AC: F4002080 F8000108
	v_mov_b32_e32 v0, 0                                        // 0000000394B4: 7E000280
	s_lshl_b64 s[4:5], s[14:15], 2                             // 0000000394B8: 8484820E
	s_load_b64 s[0:1], s[0:1], 0x118                           // 0000000394BC: F4002000 F8000118
	v_lshlrev_b32_e32 v24, 2, v52                              // 0000000394C4: 30306882
	s_wait_loadcnt 0x0                                         // 0000000394C8: BFC00000
	ds_load_b128 v[16:19], v0 offset:19008                     // 0000000394CC: DBFC4A40 10000000
	ds_load_b128 v[20:23], v0 offset:19024                     // 0000000394D4: DBFC4A50 14000000
	s_wait_kmcnt 0x0                                           // 0000000394DC: BFC70000
	s_add_nc_u64 s[2:3], s[2:3], s[4:5]                        // 0000000394E0: A9820402
	s_clause 0x1                                               // 0000000394E4: BF850001
	global_load_b128 v[8:11], v0, s[2:3] offset:16             // 0000000394E8: EE05C002 00000008 00001000
	global_load_b128 v[12:15], v0, s[2:3]                      // 0000000394F4: EE05C002 0000000C 00000000
	v_add_co_u32 v24, s0, s0, v24                              // 000000039500: D7000018 02023000
	s_wait_alu depctr_va_sdst(0)                               // 000000039508: BF88F19F
	v_add_co_ci_u32_e64 v25, null, s1, 0, s0                   // 00000003950C: D5207C19 00010001
	s_wait_dscnt 0x1                                           // 000000039514: BFC60001
	v_readfirstlane_b32 s0, v16                                // 000000039518: 7E000510
	v_readfirstlane_b32 s1, v17                                // 00000003951C: 7E020511
	v_readfirstlane_b32 s3, v19                                // 000000039520: 7E060513
	ds_load_b128 v[4:7], v0 offset:18976                       // 000000039524: DBFC4A20 04000000
	ds_load_b128 v[0:3], v0 offset:18992                       // 00000003952C: DBFC4A30 00000000
	v_readfirstlane_b32 s2, v18                                // 000000039534: 7E040512
	s_wait_dscnt 0x2                                           // 000000039538: BFC60002
	v_readfirstlane_b32 s6, v21                                // 00000003953C: 7E0C0515
	v_readfirstlane_b32 s7, v22                                // 000000039540: 7E0E0516
	v_readfirstlane_b32 s5, v20                                // 000000039544: 7E0A0514
	v_readfirstlane_b32 s9, v23                                // 000000039548: 7E120517
	s_wait_loadcnt 0x1                                         // 00000003954C: BFC00001
	v_readfirstlane_b32 s17, v8                                // 000000039550: 7E220508
	s_wait_loadcnt 0x0                                         // 000000039554: BFC00000
	v_readfirstlane_b32 s4, v12                                // 000000039558: 7E08050C
	v_readfirstlane_b32 s8, v13                                // 00000003955C: 7E10050D
	v_readfirstlane_b32 s16, v15                               // 000000039560: 7E20050F
	v_readfirstlane_b32 s15, v14                               // 000000039564: 7E1E050E
	v_readfirstlane_b32 s11, v10                               // 000000039568: 7E16050A
	s_sub_f32 s18, s4, s0                                      // 00000003956C: A0920004
	s_sub_f32 s0, s8, s1                                       // 000000039570: A0800108
	s_sub_f32 s8, s16, s3                                      // 000000039574: A0880310
	s_sub_f32 s4, s15, s2                                      // 000000039578: A084020F
	s_wait_alu depctr_sa_sdst(0)                               // 00000003957C: BF88FF9E
	s_mul_f32 s1, s18, 0x3fb8aa3b                              // 000000039580: A201FF12 3FB8AA3B
	s_mul_f32 s2, s0, 0x3fb8aa3b                               // 000000039588: A202FF00 3FB8AA3B
	v_readfirstlane_b32 s14, v9                                // 000000039590: 7E1C0509
	s_sub_f32 s7, s11, s7                                      // 000000039594: A087070B
	s_wait_alu depctr_sa_sdst(0)                               // 000000039598: BF88FF9E
	s_xor_b32 s3, s1, 0x80000000                               // 00000003959C: 8D03FF01 80000000
	s_rndne_f32 s16, s1                                        // 0000000395A4: BE906301
	s_fmamk_f32 s3, s18, 0x3fb8aa3b, s3                        // 0000000395A8: A3030312 3FB8AA3B
	s_cmp_nlt_f32 s18, 0xc2ce8ed0                              // 0000000395B0: BF4EFF12 C2CE8ED0
	s_rndne_f32 s20, s2                                        // 0000000395B8: BE946302
	s_wait_alu depctr_sa_sdst(0)                               // 0000000395BC: BF88FF9E
	s_sub_f32 s1, s1, s16                                      // 0000000395C0: A0811001
	s_fmamk_f32 s3, s18, 0x32a5705f, s3                        // 0000000395C4: A3030312 32A5705F
	s_cvt_i32_f32 s16, s16                                     // 0000000395CC: BE906610
	s_cselect_b32 vcc_lo, -1, 0                                // 0000000395D0: 986A80C1
	s_cmp_ngt_f32 s18, 0x42b17218                              // 0000000395D4: BF4BFF12 42B17218
	s_wait_alu depctr_sa_sdst(0)                               // 0000000395DC: BF88FF9E
	s_add_f32 s1, s1, s3                                       // 0000000395E0: A0010301
	s_sub_f32 s26, s2, s20                                     // 0000000395E4: A09A1402
	s_sub_f32 s6, s14, s6                                      // 0000000395E8: A086060E
	s_mul_f32 s11, s4, 0x3fb8aa3b                              // 0000000395EC: A20BFF04 3FB8AA3B
	s_wait_alu depctr_sa_sdst(0)                               // 0000000395F4: BF88FF9E
	v_s_exp_f32 s1, s1                                         // 0000000395F8: D6800001 02010001
	s_mul_f32 s14, s8, 0x3fb8aa3b                              // 000000039600: A20EFF08 3FB8AA3B
	v_readfirstlane_b32 s10, v11                               // 000000039608: 7E14050B
	s_rndne_f32 s21, s11                                       // 00000003960C: BE95630B
	s_cvt_i32_f32 s20, s20                                     // 000000039610: BE946614
	s_rndne_f32 s3, s14                                        // 000000039614: BE83630E
	s_sub_f32 s5, s17, s5                                      // 000000039618: A0850511
	s_wait_alu depctr_sa_sdst(0)                               // 00000003961C: BF88FF9E
	s_sub_f32 s27, s11, s21                                    // 000000039620: A09B150B
	v_ldexp_f32 v8, s1, s16                                    // 000000039624: D71C0008 02002001
	s_cvt_i32_f32 s16, s21                                     // 00000003962C: BE906615
	s_sub_f32 s18, s14, s3                                     // 000000039630: A092030E
	s_cvt_i32_f32 s21, s3                                      // 000000039634: BE956603
	s_mul_f32 s15, s5, 0x3fb8aa3b                              // 000000039638: A20FFF05 3FB8AA3B
	v_cndmask_b32_e32 v8, 0, v8, vcc_lo                        // 000000039640: 02101080
	s_cselect_b32 vcc_lo, -1, 0                                // 000000039644: 986A80C1
	s_xor_b32 s1, s2, 0x80000000                               // 000000039648: 8D01FF02 80000000
	s_lshl_b64 s[2:3], s[12:13], 11                            // 000000039650: 84828B0C
	s_wait_alu depctr_sa_sdst(0)                               // 000000039654: BF88FF9E
	s_fmamk_f32 s1, s0, 0x3fb8aa3b, s1                         // 000000039658: A3010100 3FB8AA3B
	v_cndmask_b32_e32 v8, 0x7f800000, v8, vcc_lo               // 000000039660: 021010FF 7F800000
	s_cmp_nlt_f32 s0, 0xc2ce8ed0                               // 000000039668: BF4EFF00 C2CE8ED0
	s_rndne_f32 s22, s15                                       // 000000039670: BE96630F
	s_wait_alu depctr_sa_sdst(0)                               // 000000039674: BF88FF9E
	s_fmamk_f32 s1, s0, 0x32a5705f, s1                         // 000000039678: A3010100 32A5705F
	s_mul_f32 s17, s6, 0x3fb8aa3b                              // 000000039680: A211FF06 3FB8AA3B
	s_wait_dscnt 0x1                                           // 000000039688: BFC60001
	v_add_f32_e32 v10, v4, v8                                  // 00000003968C: 06141104
	s_cselect_b32 vcc_lo, -1, 0                                // 000000039690: 986A80C1
	s_wait_alu depctr_sa_sdst(0)                               // 000000039694: BF88FF9E
	s_add_f32 s1, s26, s1                                      // 000000039698: A001011A
	s_cmp_ngt_f32 s0, 0x42b17218                               // 00000003969C: BF4BFF00 42B17218
	v_add_co_u32 v8, s0, v24, s2                               // 0000000396A4: D7000008 02000518
	v_div_scale_f32 v4, null, v10, v10, v51                    // 0000000396AC: D6FC7C04 04CE150A
	s_wait_alu depctr_sa_sdst(0)                               // 0000000396B4: BF88FF9E
	v_s_exp_f32 s1, s1                                         // 0000000396B8: D6800001 02010001
	v_div_scale_f32 v11, null, v10, v10, v50                   // 0000000396C0: D6FC7C0B 04CA150A
	s_wait_alu depctr_va_sdst(0)                               // 0000000396C8: BF88F19F
	v_add_co_ci_u32_e64 v9, null, s3, v25, s0                  // 0000000396CC: D5207C09 00023203
	v_rcp_f32_e32 v12, v4                                      // 0000000396D4: 7E185504
	v_div_scale_f32 v15, s0, v51, v10, v51                     // 0000000396D8: D6FC000F 04CE1533
	v_rcp_f32_e32 v13, v11                                     // 0000000396E0: 7E1A550B
	s_sub_f32 s28, s15, s22                                    // 0000000396E4: A09C160F
	v_ldexp_f32 v14, s1, s20                                   // 0000000396E8: D71C000E 02002801
	s_cvt_i32_f32 s22, s22                                     // 0000000396F0: BE966616
	s_rndne_f32 s23, s17                                       // 0000000396F4: BE976311
	s_mul_f32 s19, s7, 0x3fb8aa3b                              // 0000000396F8: A213FF07 3FB8AA3B
	s_sub_f32 s9, s10, s9                                      // 000000039700: A089090A
	v_fma_f32 v16, -v4, v12, 1.0                               // 000000039704: D6130010 23CA1904
	s_wait_alu depctr_sa_sdst(0)                               // 00000003970C: BF88FF9E
	s_sub_f32 s29, s17, s23                                    // 000000039710: A09D1711
	v_fma_f32 v17, -v11, v13, 1.0                              // 000000039714: D6130011 23CA1B0B
	s_cvt_i32_f32 s23, s23                                     // 00000003971C: BE976617
	s_rndne_f32 s24, s19                                       // 000000039720: BE986313
	v_fmac_f32_e32 v12, v16, v12                               // 000000039724: 56181910
	v_cndmask_b32_e32 v14, 0, v14, vcc_lo                      // 000000039728: 021C1C80
	s_cselect_b32 vcc_lo, -1, 0                                // 00000003972C: 986A80C1
	s_xor_b32 s1, s11, 0x80000000                              // 000000039730: 8D01FF0B 80000000
	v_fmac_f32_e32 v13, v17, v13                               // 000000039738: 561A1B11
	s_wait_alu depctr_sa_sdst(0)                               // 00000003973C: BF88FF9E
	s_fmamk_f32 s2, s4, 0x3fb8aa3b, s1                         // 000000039740: A3020104 3FB8AA3B
	v_cndmask_b32_e32 v14, 0x7f800000, v14, vcc_lo             // 000000039748: 021C1CFF 7F800000
	v_div_scale_f32 v18, s1, v50, v10, v50                     // 000000039750: D6FC0112 04CA1532
	s_cmp_nlt_f32 s4, 0xc2ce8ed0                               // 000000039758: BF4EFF04 C2CE8ED0
	s_wait_alu depctr_sa_sdst(0)                               // 000000039760: BF88FF9E
	s_fmamk_f32 s2, s4, 0x32a5705f, s2                         // 000000039764: A3020204 32A5705F
	s_sub_f32 s26, s19, s24                                    // 00000003976C: A09A1813
	v_dual_add_f32 v14, v5, v14 :: v_dual_mul_f32 v5, v15, v12 // 000000039770: C9061D05 0E04190F
	s_wait_alu depctr_sa_sdst(0)                               // 000000039778: BF88FF9E
	s_add_f32 s2, s27, s2                                      // 00000003977C: A002021B
	v_mul_f32_e32 v16, v18, v13                                // 000000039780: 10201B12
	s_cselect_b32 vcc_lo, -1, 0                                // 000000039784: 986A80C1
	v_div_scale_f32 v17, null, v14, v14, v49                   // 000000039788: D6FC7C11 04C61D0E
	s_wait_alu depctr_sa_sdst(0)                               // 000000039790: BF88FF9E
	v_s_exp_f32 s11, s2                                        // 000000039794: D680000B 02010002
	v_div_scale_f32 v20, null, v14, v14, v48                   // 00000003979C: D6FC7C14 04C21D0E
	v_fma_f32 v21, -v4, v5, v15                                // 0000000397A4: D6130015 243E0B04
	v_fma_f32 v22, -v11, v16, v18                              // 0000000397AC: D6130016 244A210B
	v_rcp_f32_e32 v24, v17                                     // 0000000397B4: 7E305511
	s_cmp_ngt_f32 s4, 0x42b17218                               // 0000000397B8: BF4BFF04 42B17218
	v_rcp_f32_e32 v25, v20                                     // 0000000397C0: 7E325514
	v_fmac_f32_e32 v5, v21, v12                                // 0000000397C4: 560A1915
	v_ldexp_f32 v21, s11, s16                                  // 0000000397C8: D71C0015 0200200B
	v_fmac_f32_e32 v16, v22, v13                               // 0000000397D0: 56201B16
	s_cselect_b32 s4, -1, 0                                    // 0000000397D4: 980480C1
	s_xor_b32 s11, s14, 0x80000000                             // 0000000397D8: 8D0BFF0E 80000000
	v_fma_f32 v4, -v4, v5, v15                                 // 0000000397E0: D6130004 243E0B04
	v_cndmask_b32_e32 v15, 0, v21, vcc_lo                      // 0000000397E8: 021E2A80
	v_fma_f32 v11, -v11, v16, v18                              // 0000000397EC: D613000B 244A210B
	v_fma_f32 v18, -v17, v24, 1.0                              // 0000000397F4: D6130012 23CA3111
	s_wait_alu depctr_sa_sdst(0)                               // 0000000397FC: BF88FF9E
	s_fmamk_f32 s11, s8, 0x3fb8aa3b, s11                       // 000000039800: A30B0B08 3FB8AA3B
	s_mov_b32 vcc_lo, s0                                       // 000000039808: BEEA0000
	v_fma_f32 v21, -v20, v25, 1.0                              // 00000003980C: D6130015 23CA3314
	s_wait_alu depctr_sa_sdst(0)                               // 000000039814: BF88FF9E
	v_div_fmas_f32 v4, v4, v12, v5                             // 000000039818: D6370004 04161904
	v_cndmask_b32_e64 v5, 0x7f800000, v15, s4                  // 000000039820: D5010005 00121EFF 7F800000
	s_fmamk_f32 s0, s8, 0x32a5705f, s11                        // 00000003982C: A3000B08 32A5705F
	v_div_scale_f32 v19, s2, v49, v14, v49                     // 000000039834: D6FC0213 04C61D31
	v_fmac_f32_e32 v24, v18, v24                               // 00000003983C: 56303112
	s_mov_b32 vcc_lo, s1                                       // 000000039840: BEEA0001
	v_div_scale_f32 v23, s3, v48, v14, v48                     // 000000039844: D6FC0317 04C21D30
	s_wait_alu depctr_sa_sdst(0)                               // 00000003984C: BF88FF9E
	v_div_fmas_f32 v11, v11, v13, v16                          // 000000039850: D637000B 04421B0B
	v_fmac_f32_e32 v25, v21, v25                               // 000000039858: 56323315
	s_add_f32 s0, s18, s0                                      // 00000003985C: A0000012
	v_add_f32_e32 v12, v6, v5                                  // 000000039860: 06180B06
	v_mul_f32_e32 v6, v19, v24                                 // 000000039864: 100C3113
	v_div_fixup_f32 v4, v4, v10, v51                           // 000000039868: D6270004 04CE1504
	s_wait_alu depctr_sa_sdst(0)                               // 000000039870: BF88FF9E
	v_s_exp_f32 s4, s0                                         // 000000039874: D6800004 02010000
	v_div_fixup_f32 v5, v11, v10, v50                          // 00000003987C: D6270005 04CA150B
	v_mul_f32_e32 v10, v23, v25                                // 000000039884: 10143317
	v_div_scale_f32 v11, null, v12, v12, v47                   // 000000039888: D6FC7C0B 04BE190C
	v_div_scale_f32 v15, null, v12, v12, v46                   // 000000039890: D6FC7C0F 04BA190C
	v_fma_f32 v16, -v17, v6, v19                               // 000000039898: D6130010 244E0D11
	s_cmp_nlt_f32 s8, 0xc2ce8ed0                               // 0000000398A0: BF4EFF08 C2CE8ED0
	v_fma_f32 v18, -v20, v10, v23                              // 0000000398A8: D6130012 245E1514
	v_rcp_f32_e32 v22, v11                                     // 0000000398B0: 7E2C550B
	v_rcp_f32_e32 v26, v15                                     // 0000000398B4: 7E34550F
	v_fmac_f32_e32 v6, v16, v24                                // 0000000398B8: 560C3110
	v_ldexp_f32 v16, s4, s21                                   // 0000000398BC: D71C0010 02002A04
	v_fmac_f32_e32 v10, v18, v25                               // 0000000398C4: 56143312
	s_cselect_b32 vcc_lo, -1, 0                                // 0000000398C8: 986A80C1
	s_cmp_ngt_f32 s8, 0x42b17218                               // 0000000398CC: BF4BFF08 42B17218
	v_fma_f32 v17, -v17, v6, v19                               // 0000000398D4: D6130011 244E0D11
	s_wait_alu depctr_sa_sdst(0)                               // 0000000398DC: BF88FF9E
	v_cndmask_b32_e32 v16, 0, v16, vcc_lo                      // 0000000398E0: 02202080
	v_fma_f32 v18, -v20, v10, v23                              // 0000000398E4: D6130012 245E1514
	s_cselect_b32 s4, -1, 0                                    // 0000000398EC: 980480C1
	s_xor_b32 s8, s15, 0x80000000                              // 0000000398F0: 8D08FF0F 80000000
	v_fma_f32 v19, -v11, v22, 1.0                              // 0000000398F8: D6130013 23CA2D0B
	v_fma_f32 v20, -v15, v26, 1.0                              // 000000039900: D6130014 23CA350F
	s_wait_alu depctr_sa_sdst(0)                               // 000000039908: BF88FF9E
	s_fmamk_f32 s8, s5, 0x3fb8aa3b, s8                         // 00000003990C: A3080805 3FB8AA3B
	s_mov_b32 vcc_lo, s2                                       // 000000039914: BEEA0002
	v_cndmask_b32_e64 v16, 0x7f800000, v16, s4                 // 000000039918: D5010010 001220FF 7F800000
	s_wait_alu depctr_sa_sdst(0)                               // 000000039924: BF88FF9E
	v_div_fmas_f32 v6, v17, v24, v6                            // 000000039928: D6370006 041A3111
	s_mov_b32 vcc_lo, s3                                       // 000000039930: BEEA0003
	v_div_scale_f32 v13, s0, v47, v12, v47                     // 000000039934: D6FC000D 04BE192F
	s_fmamk_f32 s2, s5, 0x32a5705f, s8                         // 00000003993C: A3020805 32A5705F
	s_wait_alu depctr_sa_sdst(0)                               // 000000039944: BF88FF9E
	v_div_fmas_f32 v10, v18, v25, v10                          // 000000039948: D637000A 042A3312
	v_fmac_f32_e32 v22, v19, v22                               // 000000039950: 562C2D13
	v_div_scale_f32 v21, s1, v46, v12, v46                     // 000000039954: D6FC0115 04BA192E
	v_fmac_f32_e32 v26, v20, v26                               // 00000003995C: 56343514
	v_add_f32_e32 v16, v7, v16                                 // 000000039960: 06202107
	s_add_f32 s2, s28, s2                                      // 000000039964: A002021C
	v_div_fixup_f32 v7, v10, v14, v48                          // 000000039968: D6270007 04C21D0A
	v_mul_f32_e32 v10, v13, v22                                // 000000039970: 10142D0D
	v_div_fixup_f32 v6, v6, v14, v49                           // 000000039974: D6270006 04C61D06
	v_mul_f32_e32 v14, v21, v26                                // 00000003997C: 101C3515
	v_div_scale_f32 v17, null, v16, v16, v45                   // 000000039980: D6FC7C11 04B62110
	s_wait_alu depctr_sa_sdst(0)                               // 000000039988: BF88FF9E
	v_s_exp_f32 s4, s2                                         // 00000003998C: D6800004 02010002
	v_div_scale_f32 v19, null, v16, v16, v44                   // 000000039994: D6FC7C13 04B22110
	v_fma_f32 v20, -v11, v10, v13                              // 00000003999C: D6130014 2436150B
	s_cmp_nlt_f32 s5, 0xc2ce8ed0                               // 0000000399A4: BF4EFF05 C2CE8ED0
	v_fma_f32 v23, -v15, v14, v21                              // 0000000399AC: D6130017 24561D0F
	v_rcp_f32_e32 v25, v17                                     // 0000000399B4: 7E325511
	v_rcp_f32_e32 v27, v19                                     // 0000000399B8: 7E365513
	v_fmac_f32_e32 v10, v20, v22                               // 0000000399BC: 56142D14
	s_cselect_b32 vcc_lo, -1, 0                                // 0000000399C0: 986A80C1
	s_cmp_ngt_f32 s5, 0x42b17218                               // 0000000399C4: BF4BFF05 42B17218
	v_fmac_f32_e32 v14, v23, v26                               // 0000000399CC: 561C3517
	v_ldexp_f32 v20, s4, s22                                   // 0000000399D0: D71C0014 02002C04
	v_fma_f32 v11, -v11, v10, v13                              // 0000000399D8: D613000B 2436150B
	s_cselect_b32 s4, -1, 0                                    // 0000000399E0: 980480C1
	s_xor_b32 s5, s17, 0x80000000                              // 0000000399E4: 8D05FF11 80000000
	v_fma_f32 v13, -v15, v14, v21                              // 0000000399EC: D613000D 24561D0F
	s_wait_alu depctr_sa_sdst(0)                               // 0000000399F4: BF88FF9E
	v_cndmask_b32_e32 v15, 0, v20, vcc_lo                      // 0000000399F8: 021E2880
	v_fma_f32 v20, -v17, v25, 1.0                              // 0000000399FC: D6130014 23CA3311
	s_fmamk_f32 s5, s6, 0x3fb8aa3b, s5                         // 000000039A04: A3050506 3FB8AA3B
	v_fma_f32 v21, -v19, v27, 1.0                              // 000000039A0C: D6130015 23CA3713
	s_mov_b32 vcc_lo, s0                                       // 000000039A14: BEEA0000
	v_div_scale_f32 v18, s2, v45, v16, v45                     // 000000039A18: D6FC0212 04B6212D
	s_wait_alu depctr_sa_sdst(0)                               // 000000039A20: BF88FF9E
	v_div_fmas_f32 v10, v11, v22, v10                          // 000000039A24: D637000A 042A2D0B
	s_fmamk_f32 s0, s6, 0x32a5705f, s5                         // 000000039A2C: A3000506 32A5705F
	s_mov_b32 vcc_lo, s1                                       // 000000039A34: BEEA0001
	v_cndmask_b32_e64 v11, 0x7f800000, v15, s4                 // 000000039A38: D501000B 00121EFF 7F800000
	v_fmac_f32_e32 v25, v20, v25                               // 000000039A44: 56323314
	v_div_scale_f32 v24, s3, v44, v16, v44                     // 000000039A48: D6FC0318 04B2212C
	s_wait_alu depctr_sa_sdst(0)                               // 000000039A50: BF88FF9E
	v_div_fmas_f32 v13, v13, v26, v14                          // 000000039A54: D637000D 043A350D
	v_fmac_f32_e32 v27, v21, v27                               // 000000039A5C: 56363715
	s_add_f32 s0, s29, s0                                      // 000000039A60: A000001D
	s_wait_dscnt 0x0                                           // 000000039A64: BFC60000
	v_add_f32_e32 v14, v0, v11                                 // 000000039A68: 061C1700
	v_mul_f32_e32 v0, v18, v25                                 // 000000039A6C: 10003312
	v_div_fixup_f32 v10, v10, v12, v47                         // 000000039A70: D627000A 04BE190A
	v_div_fixup_f32 v11, v13, v12, v46                         // 000000039A78: D627000B 04BA190D
	v_mul_f32_e32 v12, v24, v27                                // 000000039A80: 10183718
	s_cmp_nlt_f32 s6, 0xc2ce8ed0                               // 000000039A84: BF4EFF06 C2CE8ED0
	s_wait_alu depctr_sa_sdst(0)                               // 000000039A8C: BF88FF9E
	v_s_exp_f32 s4, s0                                         // 000000039A90: D6800004 02010000
	v_fma_f32 v21, -v17, v0, v18                               // 000000039A98: D6130015 244A0111
	v_div_scale_f32 v13, null, v14, v14, v43                   // 000000039AA0: D6FC7C0D 04AE1D0E
	v_fma_f32 v22, -v19, v12, v24                              // 000000039AA8: D6130016 24621913
	s_cselect_b32 vcc_lo, -1, 0                                // 000000039AB0: 986A80C1
	s_cmp_ngt_f32 s6, 0x42b17218                               // 000000039AB4: BF4BFF06 42B17218
	v_div_scale_f32 v20, null, v14, v14, v42                   // 000000039ABC: D6FC7C14 04AA1D0E
	v_fmac_f32_e32 v0, v21, v25                                // 000000039AC4: 56003315
	v_ldexp_f32 v21, s4, s23                                   // 000000039AC8: D71C0015 02002E04
	s_cselect_b32 s4, -1, 0                                    // 000000039AD0: 980480C1
	s_xor_b32 s5, s19, 0x80000000                              // 000000039AD4: 8D05FF13 80000000
	v_fmac_f32_e32 v12, v22, v27                               // 000000039ADC: 56183716
	s_wait_alu depctr_sa_sdst(0)                               // 000000039AE0: BF88FF9E
	s_fmamk_f32 s5, s7, 0x3fb8aa3b, s5                         // 000000039AE4: A3050507 3FB8AA3B
	v_rcp_f32_e32 v26, v13                                     // 000000039AEC: 7E34550D
	v_rcp_f32_e32 v28, v20                                     // 000000039AF0: 7E385514
	v_fma_f32 v17, -v17, v0, v18                               // 000000039AF4: D6130011 244A0111
	v_fma_f32 v18, -v19, v12, v24                              // 000000039AFC: D6130012 24621913
	v_cndmask_b32_e32 v19, 0, v21, vcc_lo                      // 000000039B04: 02262A80
	s_mov_b32 vcc_lo, s2                                       // 000000039B08: BEEA0002
	s_wait_alu depctr_sa_sdst(0)                               // 000000039B0C: BF88FF9E
	s_fmamk_f32 s2, s7, 0x32a5705f, s5                         // 000000039B10: A3020507 32A5705F
	s_cmp_nlt_f32 s7, 0xc2ce8ed0                               // 000000039B18: BF4EFF07 C2CE8ED0
	v_div_fmas_f32 v0, v17, v25, v0                            // 000000039B20: D6370000 04023311
	v_fma_f32 v21, -v13, v26, 1.0                              // 000000039B28: D6130015 23CA350D
	s_wait_alu depctr_sa_sdst(0)                               // 000000039B30: BF88FF9E
	s_add_f32 s2, s26, s2                                      // 000000039B34: A002021A
	v_fma_f32 v22, -v20, v28, 1.0                              // 000000039B38: D6130016 23CA3914
	s_mov_b32 vcc_lo, s3                                       // 000000039B40: BEEA0003
	v_div_scale_f32 v15, s0, v43, v14, v43                     // 000000039B44: D6FC000F 04AE1D2B
	s_wait_alu depctr_sa_sdst(0)                               // 000000039B4C: BF88FF9E
	v_s_exp_f32 s2, s2                                         // 000000039B50: D6800002 02010002
	v_fmac_f32_e32 v26, v21, v26                               // 000000039B58: 56343515
	s_mul_f32 s10, s9, 0x3fb8aa3b                              // 000000039B5C: A20AFF09 3FB8AA3B
	s_cvt_i32_f32 s24, s24                                     // 000000039B64: BE986618
	v_div_fmas_f32 v12, v18, v27, v12                          // 000000039B68: D637000C 04323712
	s_cselect_b32 vcc_lo, -1, 0                                // 000000039B70: 986A80C1
	s_cmp_ngt_f32 s7, 0x42b17218                               // 000000039B74: BF4BFF07 42B17218
	v_div_scale_f32 v23, s1, v42, v14, v42                     // 000000039B7C: D6FC0117 04AA1D2A
	v_fmac_f32_e32 v28, v22, v28                               // 000000039B84: 56383916
	v_cndmask_b32_e64 v17, 0x7f800000, v19, s4                 // 000000039B88: D5010011 001226FF 7F800000
	v_mul_f32_e32 v18, v15, v26                                // 000000039B94: 1024350F
	s_wait_alu depctr_sa_sdst(0)                               // 000000039B98: BF88FF9E
	v_ldexp_f32 v27, s2, s24                                   // 000000039B9C: D71C001B 02003002
	s_cselect_b32 s2, -1, 0                                    // 000000039BA4: 980280C1
	s_xor_b32 s4, s10, 0x80000000                              // 000000039BA8: 8D04FF0A 80000000
	s_rndne_f32 s25, s10                                       // 000000039BB0: BE99630A
	v_mul_f32_e32 v19, v23, v28                                // 000000039BB4: 10263917
	s_wait_alu depctr_sa_sdst(0)                               // 000000039BB8: BF88FF9E
	s_fmamk_f32 s5, s9, 0x3fb8aa3b, s4                         // 000000039BBC: A3050409 3FB8AA3B
	v_add_f32_e32 v17, v1, v17                                 // 000000039BC4: 06222301
	v_div_fixup_f32 v1, v12, v16, v44                          // 000000039BC8: D6270001 04B2210C
	v_fma_f32 v12, -v13, v18, v15                              // 000000039BD0: D613000C 243E250D
	s_sub_f32 s30, s10, s25                                    // 000000039BD8: A09E190A
	s_wait_alu depctr_sa_sdst(0)                               // 000000039BDC: BF88FF9E
	s_fmamk_f32 s5, s9, 0x32a5705f, s5                         // 000000039BE0: A3050509 32A5705F
	v_div_fixup_f32 v0, v0, v16, v45                           // 000000039BE8: D6270000 04B62100
	v_fma_f32 v16, -v20, v19, v23                              // 000000039BF0: D6130010 245E2714
	v_div_scale_f32 v21, null, v17, v17, v41                   // 000000039BF8: D6FC7C15 04A62311
	v_div_scale_f32 v22, null, v17, v17, v38                   // 000000039C00: D6FC7C16 049A2311
	v_fmac_f32_e32 v18, v12, v26                               // 000000039C08: 5624350C
	s_wait_alu depctr_sa_sdst(0)                               // 000000039C0C: BF88FF9E
	s_add_f32 s5, s30, s5                                      // 000000039C10: A005051E
	v_fmac_f32_e32 v19, v16, v28                               // 000000039C14: 56263910
	v_rcp_f32_e32 v24, v21                                     // 000000039C18: 7E305515
	v_cndmask_b32_e32 v12, 0, v27, vcc_lo                      // 000000039C1C: 02183680
	s_mov_b32 vcc_lo, s0                                       // 000000039C20: BEEA0000
	s_wait_alu depctr_sa_sdst(0)                               // 000000039C24: BF88FF9E
	v_s_exp_f32 s0, s5                                         // 000000039C28: D6800000 02010005
	v_rcp_f32_e32 v25, v22                                     // 000000039C30: 7E325516
	v_fma_f32 v13, -v13, v18, v15                              // 000000039C34: D613000D 243E250D
	v_fma_f32 v15, -v20, v19, v23                              // 000000039C3C: D613000F 245E2714
	s_cvt_i32_f32 s25, s25                                     // 000000039C44: BE996619
	s_cmp_nlt_f32 s9, 0xc2ce8ed0                               // 000000039C48: BF4EFF09 C2CE8ED0
	v_fma_f32 v20, -v21, v24, 1.0                              // 000000039C50: D6130014 23CA3115
	v_div_fmas_f32 v13, v13, v26, v18                          // 000000039C58: D637000D 044A350D
	s_mov_b32 vcc_lo, s1                                       // 000000039C60: BEEA0001
	v_cndmask_b32_e64 v18, 0x7f800000, v12, s2                 // 000000039C64: D5010012 000A18FF 7F800000
	s_wait_alu depctr_sa_sdst(0)                               // 000000039C70: BF88FF9E
	v_div_fmas_f32 v15, v15, v28, v19                          // 000000039C74: D637000F 044E390F
	v_ldexp_f32 v19, s0, s25                                   // 000000039C7C: D71C0013 02003200
	v_fma_f32 v23, -v22, v25, 1.0                              // 000000039C84: D6130017 23CA3316
	s_cselect_b32 vcc_lo, -1, 0                                // 000000039C8C: 986A80C1
	s_cmp_ngt_f32 s9, 0x42b17218                               // 000000039C90: BF4BFF09 42B17218
	v_div_scale_f32 v16, s3, v41, v17, v41                     // 000000039C98: D6FC0310 04A62329
	v_fmac_f32_e32 v24, v20, v24                               // 000000039CA0: 56303114
	v_add_f32_e32 v18, v2, v18                                 // 000000039CA4: 06242502
	s_wait_alu depctr_sa_sdst(0)                               // 000000039CA8: BF88FF9E
	v_cndmask_b32_e32 v2, 0, v19, vcc_lo                       // 000000039CAC: 02042680
	v_div_scale_f32 v27, s4, v38, v17, v38                     // 000000039CB0: D6FC041B 049A2326
	v_fmac_f32_e32 v25, v23, v25                               // 000000039CB8: 56323317
	s_cselect_b32 vcc_lo, -1, 0                                // 000000039CBC: 986A80C1
	v_div_fixup_f32 v12, v13, v14, v43                         // 000000039CC0: D627000C 04AE1D0D
	v_div_fixup_f32 v13, v15, v14, v42                         // 000000039CC8: D627000D 04AA1D0F
	v_mul_f32_e32 v14, v16, v24                                // 000000039CD0: 101C3110
	s_wait_alu depctr_sa_sdst(0)                               // 000000039CD4: BF88FF9E
	v_cndmask_b32_e32 v2, 0x7f800000, v2, vcc_lo               // 000000039CD8: 020404FF 7F800000
	v_div_scale_f32 v15, null, v18, v18, v40                   // 000000039CE0: D6FC7C0F 04A22512
	v_div_scale_f32 v19, null, v18, v18, v37                   // 000000039CE8: D6FC7C13 04962512
	v_mul_f32_e32 v20, v27, v25                                // 000000039CF0: 1028331B
	v_fma_f32 v23, -v21, v14, v16                              // 000000039CF4: D6130017 24421D15
	v_add_f32_e32 v29, v3, v2                                  // 000000039CFC: 063A0503
	v_rcp_f32_e32 v26, v15                                     // 000000039D00: 7E34550F
	v_rcp_f32_e32 v28, v19                                     // 000000039D04: 7E385513
	v_fma_f32 v2, -v22, v20, v27                               // 000000039D08: D6130002 246E2916
	v_fmac_f32_e32 v14, v23, v24                               // 000000039D10: 561C3117
	v_div_scale_f32 v23, null, v29, v29, v39                   // 000000039D14: D6FC7C17 049E3B1D
	v_div_scale_f32 v32, null, v29, v29, v36                   // 000000039D1C: D6FC7C20 04923B1D
	v_div_scale_f32 v3, s0, v40, v18, v40                      // 000000039D24: D6FC0003 04A22528
	v_fmac_f32_e32 v20, v2, v25                                // 000000039D2C: 56283302
	v_fma_f32 v16, -v21, v14, v16                              // 000000039D30: D6130010 24421D15
	v_rcp_f32_e32 v33, v23                                     // 000000039D38: 7E425517
	v_fma_f32 v2, -v15, v26, 1.0                               // 000000039D3C: D6130002 23CA350F
	v_fma_f32 v31, -v19, v28, 1.0                              // 000000039D44: D613001F 23CA3913
	v_fma_f32 v21, -v22, v20, v27                              // 000000039D4C: D6130015 246E2916
	v_rcp_f32_e32 v22, v32                                     // 000000039D54: 7E2C5520
	v_div_scale_f32 v30, s1, v37, v18, v37                     // 000000039D58: D6FC011E 04962525
	v_fmac_f32_e32 v26, v2, v26                                // 000000039D60: 56343502
	v_fmac_f32_e32 v28, v31, v28                               // 000000039D64: 5638391F
	s_mov_b32 vcc_lo, s3                                       // 000000039D68: BEEA0003
	v_div_scale_f32 v27, s2, v39, v29, v39                     // 000000039D6C: D6FC021B 049E3B27
	s_wait_alu depctr_sa_sdst(0)                               // 000000039D74: BF88FF9E
	v_div_fmas_f32 v2, v16, v24, v14                           // 000000039D78: D6370002 043A3110
	v_fma_f32 v14, -v23, v33, 1.0                              // 000000039D80: D613000E 23CA4317
	v_mul_f32_e32 v16, v3, v26                                 // 000000039D88: 10203503
	v_mul_f32_e32 v24, v30, v28                                // 000000039D8C: 1030391E
	v_fma_f32 v31, -v32, v22, 1.0                              // 000000039D90: D613001F 23CA2D20
	s_mov_b32 vcc_lo, s4                                       // 000000039D98: BEEA0004
	v_fmac_f32_e32 v33, v14, v33                               // 000000039D9C: 5642430E
	v_div_scale_f32 v14, s3, v36, v29, v36                     // 000000039DA0: D6FC030E 04923B24
	v_fma_f32 v34, -v15, v16, v3                               // 000000039DA8: D6130022 240E210F
	v_fma_f32 v35, -v19, v24, v30                              // 000000039DB0: D6130023 247A3113
	v_fmac_f32_e32 v22, v31, v22                               // 000000039DB8: 562C2D1F
	v_mul_f32_e32 v31, v27, v33                                // 000000039DBC: 103E431B
	s_wait_alu depctr_sa_sdst(0)                               // 000000039DC0: BF88FF9E
	v_div_fmas_f32 v20, v21, v25, v20                          // 000000039DC4: D6370014 04523315
	v_fmac_f32_e32 v16, v34, v26                               // 000000039DCC: 56203522
	v_dual_fmac_f32 v24, v35, v28 :: v_dual_mul_f32 v21, v14, v22// 000000039DD0: C8063923 18142D0E
	v_fma_f32 v25, -v23, v31, v27                              // 000000039DD8: D6130019 246E3F17
	s_mov_b32 vcc_lo, s0                                       // 000000039DE0: BEEA0000
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)// 000000039DE4: BF870193
	v_fma_f32 v3, -v15, v16, v3                                // 000000039DE8: D6130003 240E210F
	v_fma_f32 v15, -v19, v24, v30                              // 000000039DF0: D613000F 247A3113
	v_fma_f32 v19, -v32, v21, v14                              // 000000039DF8: D6130013 243A2B20
	v_fmac_f32_e32 v31, v25, v33                               // 000000039E00: 563E4319
	v_div_fixup_f32 v2, v2, v17, v41                           // 000000039E04: D6270002 04A62302
	s_wait_alu depctr_sa_sdst(0)                               // 000000039E0C: BF88FF9E
	v_div_fmas_f32 v16, v3, v26, v16                           // 000000039E10: D6370010 04423503
	s_mov_b32 vcc_lo, s1                                       // 000000039E18: BEEA0001
	v_fmac_f32_e32 v21, v19, v22                               // 000000039E1C: 562A2D13
	v_fma_f32 v3, -v23, v31, v27                               // 000000039E20: D6130003 246E3F17
	s_wait_alu depctr_sa_sdst(0)                               // 000000039E28: BF88FF9E
	v_div_fmas_f32 v15, v15, v28, v24                          // 000000039E2C: D637000F 0462390F
	s_mov_b32 vcc_lo, s2                                       // 000000039E34: BEEA0002
	v_fma_f32 v14, -v32, v21, v14                              // 000000039E38: D613000E 243A2B20
	s_wait_alu depctr_sa_sdst(0)                               // 000000039E40: BF88FF9E
	v_div_fmas_f32 v19, v3, v33, v31                           // 000000039E44: D6370013 047E4303
	s_mov_b32 vcc_lo, s3                                       // 000000039E4C: BEEA0003
	v_div_fixup_f32 v3, v20, v17, v38                          // 000000039E50: D6270003 049A2314
	v_div_fixup_f32 v15, v15, v18, v37                         // 000000039E58: D627000F 0496250F
	s_wait_alu depctr_sa_sdst(0)                               // 000000039E60: BF88FF9E
	v_div_fmas_f32 v21, v14, v22, v21                          // 000000039E64: D6370015 04562D0E
	v_div_fixup_f32 v14, v16, v18, v40                         // 000000039E6C: D627000E 04A22510
	v_div_fixup_f32 v16, v19, v29, v39                         // 000000039E74: D6270010 049E3B13
	s_delay_alu instid0(VALU_DEP_3)                            // 000000039E7C: BF870003
	v_div_fixup_f32 v17, v21, v29, v36                         // 000000039E80: D6270011 04923B15
	s_clause 0x7                                               // 000000039E88: BF850007
	global_store_b64 v[8:9], v[4:5], off                       // 000000039E8C: EE06C07C 02000000 00000008
	global_store_b64 v[8:9], v[6:7], off offset:2048           // 000000039E98: EE06C07C 03000000 00080008
	global_store_b64 v[8:9], v[10:11], off offset:4096         // 000000039EA4: EE06C07C 05000000 00100008
	global_store_b64 v[8:9], v[0:1], off offset:6144           // 000000039EB0: EE06C07C 00000000 00180008
	global_store_b64 v[8:9], v[12:13], off offset:8192         // 000000039EBC: EE06C07C 06000000 00200008
	global_store_b64 v[8:9], v[2:3], off offset:10240          // 000000039EC8: EE06C07C 01000000 00280008
	global_store_b64 v[8:9], v[14:15], off offset:12288        // 000000039ED4: EE06C07C 07000000 00300008
	global_store_b64 v[8:9], v[16:17], off offset:14336        // 000000039EE0: EE06C07C 08000000 00380008
	s_endpgm                                                   // 000000039EEC: BFB00000
	s_branch 63127                                             // 000000039EF0: BFA0F697 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x350>
	s_load_b32 s10, s[8:9], 0xd0                               // 000000039EF4: F4000284 F80000D0
	s_branch 63084                                             // 000000039EFC: BFA0F66C <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb1EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x2b0>
