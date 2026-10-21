
/home/rkuo/research/llm-weight-compression/_meta/maya-attention-global-address-20261021/kernels-gfx1201.elf:	file format elf64-amdgpu

Disassembly of section .text:

0000000000040300 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf>:
	s_load_b32 s3, s[0:1], 0xe8                                // 000000040300: F40000C0 F80000E8
	s_mov_b32 s2, ttmp7                                        // 000000040308: BE820073
	s_add_nc_u64 s[8:9], s[0:1], 40                            // 00000004030C: A988A800
	s_mov_b32 s19, 0                                           // 000000040310: BE930080
	s_wait_kmcnt 0x0                                           // 000000040314: BFC70000
	s_cmp_eq_u32 s3, 0                                         // 000000040318: BF068003
	s_cbranch_scc1 2600                                        // 00000004031C: BFA20A28 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x28c0>
	s_clause 0x1                                               // 000000040320: BF850001
	s_load_b96 s[4:6], s[8:9], 0xc4                            // 000000040324: F400A104 F80000C4
	s_load_b64 s[10:11], s[8:9], 0xd8                          // 00000004032C: F4002284 F80000D8
	s_wait_kmcnt 0x0                                           // 000000040334: BFC70000
	s_add_co_i32 s14, s4, s2                                   // 000000040338: 810E0204
	s_ashr_i32 s13, s5, 31                                     // 00000004033C: 860D9F05
	s_mov_b32 s12, s5                                          // 000000040340: BE8C0005
	s_ashr_i32 s15, s14, 31                                    // 000000040344: 860F9F0E
	s_sub_nc_u64 s[16:17], s[12:13], s[10:11]                  // 000000040348: AA100A0C
	s_add_nc_u64 s[12:13], s[14:15], 1                         // 00000004034C: A98C810E
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_3) | instid1(SALU_CYCLE_1)// 000000040350: BF8704C9
	v_cmp_gt_i64_e64 s3, s[16:17], s[12:13]                    // 000000040354: D4540003 02001810
	s_and_b32 s3, s3, exec_lo                                  // 00000004035C: 8B037E03
	s_cselect_b32 s18, s16, s12                                // 000000040360: 98120C10
	s_add_co_i32 s3, s5, s14                                   // 000000040364: 81030E05
	s_sub_co_i32 s3, s3, s18                                   // 000000040368: 81831203
	s_cmp_lt_i32 s6, 1                                         // 00000004036C: BF048106
	s_cbranch_scc1 181                                         // 000000040370: BFA200B5 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x348>
	s_add_nc_u64 s[4:5], s[12:13], s[10:11]                    // 000000040374: A9840A0C
	s_mov_b32 s7, 0                                            // 000000040378: BE870080
	s_cmp_lg_u32 s5, 0                                         // 00000004037C: BF078005
	s_cbranch_scc0 2576                                        // 000000040380: BFA10A10 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x28c4>
	s_add_nc_u64 s[10:11], s[6:7], 0                           // 000000040384: A98A8006
	s_mov_b32 s17, s7                                          // 000000040388: BE910007
	s_xor_b64 s[10:11], s[10:11], 0                            // 00000004038C: 8D8A800A
	s_mov_b32 s23, s7                                          // 000000040390: BE970007
	s_cvt_f32_u32 s12, s10                                     // 000000040394: BE8C650A
	s_cvt_f32_u32 s13, s11                                     // 000000040398: BE8D650B
	s_sub_nc_u64 s[14:15], 0, s[10:11]                         // 00000004039C: AA0E0A80
	s_wait_alu depctr_sa_sdst(0)                               // 0000000403A0: BF88FF9E
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)// 0000000403A4: BF870529
	s_fmamk_f32 s12, s13, 0x4f800000, s12                      // 0000000403A8: A30C0C0D 4F800000
	s_wait_alu depctr_sa_sdst(0)                               // 0000000403B0: BF88FF9E
	v_s_rcp_f32 s12, s12                                       // 0000000403B4: D684000C 0201000C
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)// 0000000403BC: BF870525
	s_mul_f32 s12, s12, 0x5f7ffffc                             // 0000000403C0: A20CFF0C 5F7FFFFC
	s_wait_alu depctr_sa_sdst(0)                               // 0000000403C8: BF88FF9E
	s_mul_f32 s13, s12, 0x2f800000                             // 0000000403CC: A20DFF0C 2F800000
	s_wait_alu depctr_sa_sdst(0)                               // 0000000403D4: BF88FF9E
	s_delay_alu instid0(SALU_CYCLE_2) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)// 0000000403D8: BF87052A
	s_trunc_f32 s13, s13                                       // 0000000403DC: BE8D620D
	s_wait_alu depctr_sa_sdst(0)                               // 0000000403E0: BF88FF9E
	s_fmamk_f32 s12, s13, 0xcf800000, s12                      // 0000000403E4: A30C0C0D CF800000
	s_cvt_u32_f32 s13, s13                                     // 0000000403EC: BE8D670D
	s_wait_alu depctr_sa_sdst(0)                               // 0000000403F0: BF88FF9E
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(SKIP_1) | instid1(SALU_CYCLE_2)// 0000000403F4: BF870529
	s_cvt_u32_f32 s12, s12                                     // 0000000403F8: BE8C670C
	s_wait_alu depctr_sa_sdst(0)                               // 0000000403FC: BF88FF9E
	s_mul_u64 s[20:21], s[14:15], s[12:13]                     // 000000040400: AA940C0E
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000040404: BF870009
	s_mul_hi_u32 s25, s12, s21                                 // 000000040408: 9699150C
	s_mul_i32 s24, s12, s21                                    // 00000004040C: 9618150C
	s_mul_hi_u32 s16, s12, s20                                 // 000000040410: 9690140C
	s_mul_i32 s22, s13, s20                                    // 000000040414: 9616140D
	s_wait_alu depctr_sa_sdst(0)                               // 000000040418: BF88FF9E
	s_add_nc_u64 s[16:17], s[16:17], s[24:25]                  // 00000004041C: A9901810
	s_mul_hi_u32 s19, s13, s20                                 // 000000040420: 9693140D
	s_mul_hi_u32 s26, s13, s21                                 // 000000040424: 969A150D
	s_wait_alu depctr_sa_sdst(0)                               // 000000040428: BF88FF9E
	s_add_co_u32 s16, s16, s22                                 // 00000004042C: 80101610
	s_add_co_ci_u32 s22, s17, s19                              // 000000040430: 82161311
	s_mul_i32 s20, s13, s21                                    // 000000040434: 9614150D
	s_add_co_ci_u32 s21, s26, 0                                // 000000040438: 8215801A
	s_delay_alu instid0(SALU_CYCLE_1)                          // 00000004043C: BF870009
	s_add_nc_u64 s[16:17], s[22:23], s[20:21]                  // 000000040440: A9901416
	s_mov_b32 s21, s7                                          // 000000040444: BE950007
	s_wait_alu depctr_sa_sdst(0)                               // 000000040448: BF88FF9E
	s_add_co_u32 s12, s12, s16                                 // 00000004044C: 800C100C
	s_add_co_ci_u32 s13, s13, s17                              // 000000040450: 820D110D
	s_mov_b32 s17, s7                                          // 000000040454: BE910007
	s_wait_alu depctr_sa_sdst(0)                               // 000000040458: BF88FF9E
	s_mul_u64 s[14:15], s[14:15], s[12:13]                     // 00000004045C: AA8E0C0E
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000040460: BF870009
	s_mul_hi_u32 s23, s12, s15                                 // 000000040464: 96970F0C
	s_mul_i32 s22, s12, s15                                    // 000000040468: 96160F0C
	s_mul_hi_u32 s16, s12, s14                                 // 00000004046C: 96900E0C
	s_mul_i32 s20, s13, s14                                    // 000000040470: 96140E0D
	s_wait_alu depctr_sa_sdst(0)                               // 000000040474: BF88FF9E
	s_add_nc_u64 s[16:17], s[16:17], s[22:23]                  // 000000040478: A9901610
	s_mul_hi_u32 s19, s13, s14                                 // 00000004047C: 96930E0D
	s_mul_hi_u32 s24, s13, s15                                 // 000000040480: 96980F0D
	s_mul_i32 s14, s13, s15                                    // 000000040484: 960E0F0D
	s_wait_alu depctr_sa_sdst(0)                               // 000000040488: BF88FF9E
	s_add_co_u32 s15, s16, s20                                 // 00000004048C: 800F1410
	s_add_co_ci_u32 s20, s17, s19                              // 000000040490: 82141311
	s_add_co_ci_u32 s15, s24, 0                                // 000000040494: 820F8018
	s_mov_b32 s17, s7                                          // 000000040498: BE910007
	s_add_nc_u64 s[14:15], s[20:21], s[14:15]                  // 00000004049C: A98E0E14
	s_delay_alu instid0(SALU_CYCLE_1)                          // 0000000404A0: BF870009
	s_add_co_u32 s19, s12, s14                                 // 0000000404A4: 80130E0C
	s_add_co_ci_u32 s20, s13, s15                              // 0000000404A8: 82140F0D
	s_ashr_i32 s12, s5, 31                                     // 0000000404AC: 860C9F05
	s_wait_alu depctr_sa_sdst(0)                               // 0000000404B0: BF88FF9E
	s_mov_b32 s13, s12                                         // 0000000404B4: BE8D000C
	s_wait_alu depctr_sa_sdst(0)                               // 0000000404B8: BF88FF9E
	s_add_nc_u64 s[14:15], s[4:5], s[12:13]                    // 0000000404BC: A98E0C04
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)// 0000000404C0: BF870499
	s_xor_b64 s[14:15], s[14:15], s[12:13]                     // 0000000404C4: 8D8E0C0E
	s_mul_hi_u32 s23, s14, s20                                 // 0000000404C8: 9697140E
	s_mul_i32 s22, s14, s20                                    // 0000000404CC: 9616140E
	s_mul_hi_u32 s16, s14, s19                                 // 0000000404D0: 9690130E
	s_mul_hi_u32 s24, s15, s19                                 // 0000000404D4: 9698130F
	s_mul_i32 s19, s15, s19                                    // 0000000404D8: 9613130F
	s_wait_alu depctr_sa_sdst(0)                               // 0000000404DC: BF88FF9E
	s_add_nc_u64 s[16:17], s[16:17], s[22:23]                  // 0000000404E0: A9901610
	s_mul_hi_u32 s5, s15, s20                                  // 0000000404E4: 9685140F
	s_wait_alu depctr_sa_sdst(0)                               // 0000000404E8: BF88FF9E
	s_add_co_u32 s16, s16, s19                                 // 0000000404EC: 80101310
	s_mul_i32 s22, s15, s20                                    // 0000000404F0: 9616140F
	s_add_co_ci_u32 s20, s17, s24                              // 0000000404F4: 82141811
	s_add_co_ci_u32 s23, s5, 0                                 // 0000000404F8: 82178005
	s_delay_alu instid0(SALU_CYCLE_1)                          // 0000000404FC: BF870009
	s_add_nc_u64 s[16:17], s[20:21], s[22:23]                  // 000000040500: A9901614
	s_wait_alu depctr_sa_sdst(0)                               // 000000040504: BF88FF9E
	s_mul_u64 s[20:21], s[10:11], s[16:17]                     // 000000040508: AA94100A
	s_add_nc_u64 s[22:23], s[16:17], 1                         // 00000004050C: A9968110
	s_sub_co_u32 s5, s14, s20                                  // 000000040510: 8085140E
	s_cselect_b32 s14, -1, 0                                   // 000000040514: 980E80C1
	s_sub_co_i32 s19, s15, s21                                 // 000000040518: 8193150F
	s_cmp_lg_u32 s14, 0                                        // 00000004051C: BF07800E
	s_sub_co_ci_u32 s19, s19, s11                              // 000000040520: 82930B13
	s_sub_co_u32 s20, s5, s10                                  // 000000040524: 80940A05
	s_sub_co_ci_u32 s19, s19, 0                                // 000000040528: 82938013
	s_delay_alu instid0(SALU_CYCLE_1)                          // 00000004052C: BF870009
	s_cmp_ge_u32 s19, s11                                      // 000000040530: BF090B13
	s_cselect_b32 s24, -1, 0                                   // 000000040534: 981880C1
	s_cmp_ge_u32 s20, s10                                      // 000000040538: BF090A14
	s_cselect_b32 s20, -1, 0                                   // 00000004053C: 981480C1
	s_cmp_eq_u32 s19, s11                                      // 000000040540: BF060B13
	s_cselect_b32 s19, s20, s24                                // 000000040544: 98131814
	s_add_nc_u64 s[24:25], s[16:17], 2                         // 000000040548: A9988210
	s_cmp_lg_u32 s19, 0                                        // 00000004054C: BF078013
	s_cselect_b32 s19, s24, s22                                // 000000040550: 98131618
	s_cselect_b32 s20, s25, s23                                // 000000040554: 98141719
	s_cmp_lg_u32 s14, 0                                        // 000000040558: BF07800E
	s_sub_co_ci_u32 s14, s15, s21                              // 00000004055C: 828E150F
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000040560: BF870009
	s_cmp_ge_u32 s14, s11                                      // 000000040564: BF090B0E
	s_cselect_b32 s15, -1, 0                                   // 000000040568: 980F80C1
	s_cmp_ge_u32 s5, s10                                       // 00000004056C: BF090A05
	s_cselect_b32 s5, -1, 0                                    // 000000040570: 980580C1
	s_cmp_eq_u32 s14, s11                                      // 000000040574: BF060B0E
	s_cselect_b32 s5, s5, s15                                  // 000000040578: 98050F05
	s_delay_alu instid0(SALU_CYCLE_1)                          // 00000004057C: BF870009
	s_cmp_lg_u32 s5, 0                                         // 000000040580: BF078005
	s_cselect_b32 s11, s20, s17                                // 000000040584: 980B1114
	s_cselect_b32 s10, s19, s16                                // 000000040588: 980A1013
	s_xor_b64 s[12:13], s[12:13], 0                            // 00000004058C: 8D8C800C
	s_wait_alu depctr_sa_sdst(0)                               // 000000040590: BF88FF9E
	s_xor_b64 s[10:11], s[10:11], s[12:13]                     // 000000040594: 8D8A0C0A
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000040598: BF870009
	s_sub_nc_u64 s[12:13], s[10:11], s[12:13]                  // 00000004059C: AA0C0C0A
	s_load_b32 s10, s[8:9], 0xd0                               // 0000000405A0: F4000284 F80000D0
	s_and_not1_b32 vcc_lo, exec_lo, s7                         // 0000000405A8: 916A077E
	s_cbranch_vccnz 31                                         // 0000000405AC: BFA4001F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x32c>
	v_cvt_f32_u32_e32 v1, s6                                   // 0000000405B0: 7E020C06
	s_sub_co_i32 s7, 0, s6                                     // 0000000405B4: 81870680
	s_mov_b32 s13, 0                                           // 0000000405B8: BE8D0080
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(TRANS32_DEP_1)// 0000000405BC: BF870291
	v_rcp_iflag_f32_e32 v1, v1                                 // 0000000405C0: 7E025701
	v_mul_f32_e32 v1, 0x4f7ffffe, v1                           // 0000000405C4: 100202FF 4F7FFFFE
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000405CC: BF870091
	v_cvt_u32_f32_e32 v1, v1                                   // 0000000405D0: 7E020F01
	v_readfirstlane_b32 s5, v1                                 // 0000000405D4: 7E0A0501
	s_wait_alu depctr_sa_sdst(0)                               // 0000000405D8: BF88FF9E
	s_mul_i32 s7, s7, s5                                       // 0000000405DC: 96070507
	s_wait_alu depctr_sa_sdst(0)                               // 0000000405E0: BF88FF9E
	s_mul_hi_u32 s7, s5, s7                                    // 0000000405E4: 96870705
	s_wait_alu depctr_sa_sdst(0)                               // 0000000405E8: BF88FF9E
	s_add_co_i32 s5, s5, s7                                    // 0000000405EC: 81050705
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)// 0000000405F0: BF870499
	s_mul_hi_u32 s5, s4, s5                                    // 0000000405F4: 96850504
	s_mul_i32 s7, s5, s6                                       // 0000000405F8: 96070605
	s_wait_alu depctr_sa_sdst(0)                               // 0000000405FC: BF88FF9E
	s_sub_co_i32 s4, s4, s7                                    // 000000040600: 81840704
	s_add_co_i32 s7, s5, 1                                     // 000000040604: 81078105
	s_sub_co_i32 s11, s4, s6                                   // 000000040608: 818B0604
	s_cmp_ge_u32 s4, s6                                        // 00000004060C: BF090604
	s_wait_alu depctr_sa_sdst(0)                               // 000000040610: BF88FF9E
	s_cselect_b32 s5, s7, s5                                   // 000000040614: 98050507
	s_cselect_b32 s4, s11, s4                                  // 000000040618: 9804040B
	s_add_co_i32 s7, s5, 1                                     // 00000004061C: 81078105
	s_cmp_ge_u32 s4, s6                                        // 000000040620: BF090604
	s_wait_alu depctr_sa_sdst(0)                               // 000000040624: BF88FF9E
	s_cselect_b32 s12, s7, s5                                  // 000000040628: 980C0507
	s_wait_kmcnt 0x0                                           // 00000004062C: BFC70000
	s_ashr_i32 s11, s10, 31                                    // 000000040630: 860B9F0A
	s_wait_alu depctr_sa_sdst(0)                               // 000000040634: BF88FF9E
	v_cmp_lt_i64_e64 s4, s[10:11], s[12:13]                    // 000000040638: D4510004 0200180A
	s_and_b32 s4, s4, exec_lo                                  // 000000040640: 8B047E04
	s_cselect_b32 s19, s10, s12                                // 000000040644: 98130C0A
	s_add_co_i32 s20, s3, 1                                    // 000000040648: 81148103
	s_cbranch_execnz 11                                        // 00000004064C: BFA6000B <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x37c>
	s_ashr_i32 s3, s2, 31                                      // 000000040650: 86039F02
	s_delay_alu instid0(SALU_CYCLE_1) | instskip(NEXT) | instid1(SALU_CYCLE_1)// 000000040654: BF870499
	s_lshl_b64 s[4:5], s[2:3], 2                               // 000000040658: 84848202
	s_add_nc_u64 s[4:5], s[8:9], s[4:5]                        // 00000004065C: A9840408
	s_clause 0x2                                               // 000000040660: BF850002
	s_load_b32 s20, s[4:5], 0x40                               // 000000040664: F4000502 F8000040
	s_load_b32 s19, s[4:5], 0x80                               // 00000004066C: F40004C2 F8000080
	s_load_b32 s18, s[4:5], 0x0                                // 000000040674: F4000482 F8000000
	s_clause 0x1                                               // 00000004067C: BF850001
	s_load_b64 s[16:17], s[0:1], 0x110                         // 000000040680: F4002400 F8000110
	s_load_b256 s[4:11], s[0:1], 0x0                           // 000000040688: F4006100 F8000000
	s_ashr_i32 s3, s2, 31                                      // 000000040690: 86039F02
	s_lshl_b32 s14, ttmp9, 3                                   // 000000040694: 840E8375
	v_lshrrev_b32_e32 v17, 5, v0                               // 000000040698: 32220085
	s_ashr_i32 s15, s14, 31                                    // 00000004069C: 860F9F0E
	v_dual_mov_b32 v37, 0 :: v_dual_and_b32 v54, 31, v0        // 0000000406A0: CA240080 2536009F
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000406A8: BF870001
	v_lshlrev_b32_e32 v3, 6, v54                               // 0000000406AC: 30066C86
	s_wait_kmcnt 0x0                                           // 0000000406B0: BFC70000
	s_ashr_i32 s13, s16, 31                                    // 0000000406B4: 860D9F10
	s_mov_b32 s12, s16                                         // 0000000406B8: BE8C0010
	s_wait_alu depctr_sa_sdst(0)                               // 0000000406BC: BF88FF9E
	s_mul_u64 s[12:13], s[12:13], s[2:3]                       // 0000000406C0: AA8C020C
	s_wait_alu depctr_sa_sdst(0)                               // 0000000406C4: BF88FF9E
	s_add_nc_u64 s[12:13], s[12:13], s[14:15]                  // 0000000406C8: A98C0E0C
	s_wait_alu depctr_sa_sdst(0)                               // 0000000406CC: BF88FF9E
	v_add_co_u32 v1, s16, s12, v17                             // 0000000406D0: D7001001 0202220C
	s_wait_alu depctr_va_sdst(0)                               // 0000000406D8: BF88F19F
	v_add_co_ci_u32_e64 v2, null, s13, 0, s16                  // 0000000406DC: D5207C02 0041000D
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000406E4: BF870091
	v_lshlrev_b64_e32 v[1:2], 11, v[1:2]                       // 0000000406E8: 3E02028B
	v_add_co_u32 v1, vcc_lo, s4, v1                            // 0000000406EC: D7006A01 02020204
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000406F4: BF870001
	v_add_co_ci_u32_e64 v2, null, s5, v2, vcc_lo               // 0000000406F8: D5207C02 01AA0405
	s_mov_b32 s4, exec_lo                                      // 000000040700: BE84007E
	v_add_co_u32 v13, vcc_lo, v1, v3                           // 000000040704: D7006A0D 02020701
	s_wait_alu depctr_va_vcc(0)                                // 00000004070C: BF88FF9D
	v_add_co_ci_u32_e64 v14, null, 0, v2, vcc_lo               // 000000040710: D5207C0E 01AA0480
	s_clause 0x3                                               // 000000040718: BF850003
	global_load_b128 v[1:4], v[13:14], off offset:48           // 00000004071C: EE05C07C 00000001 0000300D
	global_load_b128 v[5:8], v[13:14], off offset:32           // 000000040728: EE05C07C 00000005 0000200D
	global_load_b128 v[9:12], v[13:14], off offset:16          // 000000040734: EE05C07C 00000009 0000100D
	global_load_b128 v[13:16], v[13:14], off                   // 000000040740: EE05C07C 0000000D 0000000D
	v_cmpx_gt_u32_e32 8, v0                                    // 00000004074C: 7D980088
	s_cbranch_execz 9                                          // 000000040750: BFA50009 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x478>
	v_dual_mov_b32 v19, 0xf149f2ca :: v_dual_lshlrev_b32 v18, 2, v0// 000000040754: CA2200FF 13120082 F149F2CA
	v_mov_b32_e32 v20, 0                                       // 000000040760: 7E280280
	s_delay_alu instid0(VALU_DEP_2)                            // 000000040764: BF870002
	v_add_nc_u32_e32 v18, 0x4800, v18                          // 000000040768: 4A2424FF 00004800
	ds_store_2addr_b32 v18, v20, v19 offset0:136 offset1:144   // 000000040770: D8389088 00131412
	s_wait_alu depctr_sa_sdst(0)                               // 000000040778: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 00000004077C: 8C7E047E
	v_dual_mov_b32 v38, 0 :: v_dual_lshlrev_b32 v53, 1, v0     // 000000040780: CA220080 26340081
	v_dual_mov_b32 v39, 0 :: v_dual_mov_b32 v40, 0             // 000000040788: CA100080 27280080
	v_dual_mov_b32 v43, 0 :: v_dual_mov_b32 v42, 0             // 000000040790: CA100080 2B2A0080
	v_dual_mov_b32 v45, 0 :: v_dual_mov_b32 v44, 0             // 000000040798: CA100080 2D2C0080
	v_dual_mov_b32 v47, 0 :: v_dual_mov_b32 v46, 0             // 0000000407A0: CA100080 2F2E0080
	v_dual_mov_b32 v49, 0 :: v_dual_mov_b32 v48, 0             // 0000000407A8: CA100080 31300080
	v_dual_mov_b32 v51, 0 :: v_dual_mov_b32 v50, 0             // 0000000407B0: CA100080 33320080
	v_dual_mov_b32 v41, 0 :: v_dual_mov_b32 v52, 0             // 0000000407B8: CA100080 29340080
	s_add_co_i32 s5, s19, s20                                  // 0000000407C0: 81051413
	s_wait_alu depctr_sa_sdst(0)                               // 0000000407C4: BF88FF9E
	s_cmp_lt_i32 s5, 1                                         // 0000000407C8: BF048105
	s_cbranch_scc1 1643                                        // 0000000407CC: BFA2066B <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1e7c>
	v_dual_mov_b32 v51, 0 :: v_dual_and_b32 v18, 15, v0        // 0000000407D0: CA240080 3312008F
	v_lshrrev_b32_e32 v55, 4, v0                               // 0000000407D8: 326E0084
	v_dual_mov_b32 v36, 0 :: v_dual_lshlrev_b32 v19, 3, v0     // 0000000407DC: CA220080 24120083
	v_dual_mov_b32 v49, 0 :: v_dual_and_b32 v20, 2, v53        // 0000000407E4: CA240080 31146A82
	s_delay_alu instid0(VALU_DEP_4)                            // 0000000407EC: BF870004
	v_dual_mov_b32 v38, 0 :: v_dual_lshlrev_b32 v57, 4, v18    // 0000000407F0: CA220080 26382484
	s_load_b32 s22, s[0:1], 0x20                               // 0000000407F8: F4000580 F8000020
	v_dual_mov_b32 v47, 0 :: v_dual_lshlrev_b32 v58, 1, v18    // 000000040800: CA220080 2F3A2481
	v_dual_mov_b32 v52, 0 :: v_dual_lshlrev_b32 v21, 10, v55   // 000000040808: CA220080 34146E8A
	v_dual_mov_b32 v50, 0 :: v_dual_lshlrev_b32 v59, 6, v18    // 000000040810: CA220080 323A2486
	v_dual_mov_b32 v45, 0 :: v_dual_and_b32 v18, 0xf0, v19     // 000000040818: CA240080 2D1226FF 000000F0
	v_or_b32_e32 v22, 1, v20                                   // 000000040824: 382C2881
	v_xor_b32_e32 v23, 0x120, v57                              // 000000040828: 3A2E72FF 00000120
	v_xor_b32_e32 v24, 0x240, v57                              // 000000040830: 3A3072FF 00000240
	v_xor_b32_e32 v25, 0x360, v57                              // 000000040838: 3A3272FF 00000360
	v_or_b32_e32 v56, 0x4800, v19                              // 000000040840: 387026FF 00004800
	v_dual_mov_b32 v48, 0 :: v_dual_lshlrev_b32 v19, 5, v20    // 000000040848: CA220080 30122885
	v_or_b32_e32 v60, v21, v57                                 // 000000040850: 38787315
	v_lshl_or_b32 v20, v20, 8, v18                             // 000000040854: D6560014 04491114
	v_lshl_or_b32 v18, v22, 8, v18                             // 00000004085C: D6560012 04491116
	v_or_b32_e32 v61, v21, v23                                 // 000000040864: 387A2F15
	v_or_b32_e32 v62, v21, v24                                 // 000000040868: 387C3115
	v_dual_mov_b32 v43, 0 :: v_dual_lshlrev_b32 v22, 5, v22    // 00000004086C: CA220080 2B162C85
	v_or_b32_e32 v63, v21, v25                                 // 000000040874: 387E3315
	v_bfe_u32 v21, v0, 2, 2                                    // 000000040878: D6100015 02090500
	v_dual_mov_b32 v46, 0 :: v_dual_and_b32 v23, 0xf0, v0      // 000000040880: CA240080 2E1600FF 000000F0
	v_xor_b32_e32 v64, v19, v20                                // 00000004088C: 3A802913
	v_xor_b32_e32 v65, v22, v18                                // 000000040890: 3A822516
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_4)// 000000040894: BF870214
	v_dual_mov_b32 v44, 0 :: v_dual_lshlrev_b32 v19, 5, v21    // 000000040898: CA220080 2C122A85
	v_lshl_or_b32 v18, v21, 8, v23                             // 0000000408A0: D6560012 045D1115
	v_dual_mov_b32 v39, 0 :: v_dual_lshlrev_b32 v66, 8, v17    // 0000000408A8: CA220080 27422288
	v_dual_mov_b32 v42, 0 :: v_dual_lshlrev_b32 v17, 2, v17    // 0000000408B0: CA220080 2A102282
	v_dual_mov_b32 v37, 0 :: v_dual_and_b32 v20, 6, v53        // 0000000408B8: CA240080 25146A86
	s_delay_alu instid0(VALU_DEP_4)                            // 0000000408C0: BF870004
	v_xor_b32_e32 v18, v19, v18                                // 0000000408C4: 3A242513
	v_mbcnt_lo_u32_b32 v69, -1, 0                              // 0000000408C8: D71F0045 020100C1
	s_ashr_i32 s19, s18, 31                                    // 0000000408D0: 86139F12
	s_wait_kmcnt 0x0                                           // 0000000408D4: BFC70000
	s_ashr_i32 s23, s22, 31                                    // 0000000408D8: 86179F16
	s_lshl_b64 s[18:19], s[18:19], 10                          // 0000000408DC: 84928A12
	s_mul_u64 s[2:3], s[22:23], s[2:3]                         // 0000000408E0: AA820216
	s_add_nc_u64 s[6:7], s[6:7], s[18:19]                      // 0000000408E4: A9861206
	s_lshl_b64 s[18:19], s[2:3], 2                             // 0000000408E8: 84928202
	v_cmp_eq_u32_e64 s2, 0, v54                                // 0000000408EC: D44A0002 02026C80
	v_or_b32_e32 v67, 0x4000, v66                              // 0000000408F4: 388684FF 00004000
	v_cmp_gt_u32_e64 s3, 0x100, v0                             // 0000000408FC: D44C0003 020200FF 00000100
	v_or_b32_e32 v68, 0x4a40, v17                              // 000000040908: 388822FF 00004A40
	v_or_b32_e32 v70, 0x4a00, v17                              // 000000040910: 388C22FF 00004A00
	v_or_b32_e32 v71, 0x4a20, v17                              // 000000040918: 388E22FF 00004A20
	v_lshl_or_b32 v72, v20, 1, v18                             // 000000040920: D6560048 04490314
	v_lshl_or_b32 v73, v54, 2, v66                             // 000000040928: D6560049 05090536
	v_xor_b32_e32 v74, 16, v69                                 // 000000040930: 3A948A90
	v_xor_b32_e32 v75, 8, v69                                  // 000000040934: 3A968A88
	v_xor_b32_e32 v76, 4, v69                                  // 000000040938: 3A988A84
	v_xor_b32_e32 v77, 2, v69                                  // 00000004093C: 3A9A8A82
	v_xor_b32_e32 v78, 1, v69                                  // 000000040940: 3A9C8A81
	v_dual_mov_b32 v41, 0 :: v_dual_mov_b32 v40, 0             // 000000040944: CA100080 29280080
	s_add_nc_u64 s[10:11], s[10:11], s[18:19]                  // 00000004094C: A98A120A
	s_mov_b32 s16, 0                                           // 000000040950: BE900080
	s_mov_b32 s18, s5                                          // 000000040954: BE920005
	s_branch 5                                                 // 000000040958: BFA00005 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x670>
	s_add_co_i32 s16, s16, 64                                  // 00000004095C: 8110C010
	s_sub_co_i32 s18, s18, 64                                  // 000000040960: 8192C012
	s_wait_alu depctr_sa_sdst(0)                               // 000000040964: BF88FF9E
	s_cmp_ge_i32 s16, s5                                       // 000000040968: BF030510
	s_cbranch_scc1 1539                                        // 00000004096C: BFA20603 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1e7c>
	s_wait_alu depctr_sa_sdst(0)                               // 000000040970: BF88FF9E
	s_sub_co_i32 s23, s5, s16                                  // 000000040974: 81971005
	s_mov_b32 s4, exec_lo                                      // 000000040978: BE84007E
	s_wait_alu depctr_sa_sdst(0)                               // 00000004097C: BF88FF9E
	s_min_i32 s19, s23, 64                                     // 000000040980: 8913C017
	s_wait_alu depctr_sa_sdst(0)                               // 000000040984: BF88FF9E
	v_cmpx_gt_u32_e64 s19, v0                                  // 000000040988: D4CC007E 02020013
	s_cbranch_execz 39                                         // 000000040990: BFA50027 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x730>
	v_add_nc_u32_e32 v19, s16, v0                              // 000000040994: 4A260010
	s_mov_b32 s21, exec_lo                                     // 000000040998: BE95007E
	s_delay_alu instid0(VALU_DEP_1)                            // 00000004099C: BF870001
	v_cmpx_le_i32_e64 s20, v19                                 // 0000000409A0: D4C3007E 02022614
	s_wait_alu depctr_sa_sdst(0)                               // 0000000409A8: BF88FF9E
	s_xor_b32 s21, exec_lo, s21                                // 0000000409AC: 8D15157E
	s_cbranch_execz 16                                         // 0000000409B0: BFA50010 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x6f4>
	v_subrev_nc_u32_e32 v35, s20, v19                          // 0000000409B4: 4E462614
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 0000000409B8: BF870091
	v_lshlrev_b64_e32 v[17:18], 2, v[35:36]                    // 0000000409BC: 3E224682
	v_add_co_u32 v17, vcc_lo, s10, v17                         // 0000000409C0: D7006A11 0202220A
	s_wait_alu depctr_va_vcc(0)                                // 0000000409C8: BF88FF9D
	s_delay_alu instid0(VALU_DEP_2)                            // 0000000409CC: BF870002
	v_add_co_ci_u32_e64 v18, null, s11, v18, vcc_lo            // 0000000409D0: D5207C12 01AA240B
	global_load_b32 v17, v[17:18], off                         // 0000000409D8: EE05007C 00000011 00000011
	s_wait_loadcnt 0x0                                         // 0000000409E4: BFC00000
	v_mad_co_i64_i32 v[17:18], null, 0x120, v17, s[8:9]        // 0000000409E8: D6FF7C11 002222FF 00000120
	s_wait_alu depctr_sa_sdst(0)                               // 0000000409F4: BF88FF9E
	s_and_not1_saveexec_b32 s21, s21                           // 0000000409F8: BE953015
	v_ashrrev_i32_e32 v20, 31, v19                             // 0000000409FC: 3428269F
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000040A00: BF870091
	v_lshlrev_b64_e32 v[17:18], 10, v[19:20]                   // 000000040A04: 3E22268A
	v_add_co_u32 v17, vcc_lo, s6, v17                          // 000000040A08: D7006A11 02022206
	s_wait_alu depctr_va_vcc(0)                                // 000000040A10: BF88FF9D
	s_delay_alu instid0(VALU_DEP_2)                            // 000000040A14: BF870002
	v_add_co_ci_u32_e64 v18, null, s7, v18, vcc_lo             // 000000040A18: D5207C12 01AA2407
	s_wait_alu depctr_sa_sdst(0)                               // 000000040A20: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s21                             // 000000040A24: 8C7E157E
	ds_store_b64 v56, v[17:18]                                 // 000000040A28: D9340000 00001138
	s_wait_alu depctr_sa_sdst(0)                               // 000000040A30: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000040A34: 8C7E047E
	s_wait_loadcnt_dscnt 0x0                                   // 000000040A38: BFC80000
	s_barrier_signal -1                                        // 000000040A3C: BE804EC1
	s_min_i32 s21, s18, 64                                     // 000000040A40: 8915C012
	s_cmp_gt_i32 s23, 0                                        // 000000040A44: BF028017
	s_cselect_b32 s22, -1, 0                                   // 000000040A48: 981680C1
	s_cmp_lt_i32 s23, 1                                        // 000000040A4C: BF048117
	s_barrier_wait 0xffff                                      // 000000040A50: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 000000040A54: EE0AC07C 00040000 00000000
	s_cbranch_scc1 656                                         // 000000040A60: BFA20290 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x11a4>
	v_mov_b32_e32 v79, v66                                     // 000000040A64: 7E9E0342
	s_mov_b32 s24, 0                                           // 000000040A68: BE980080
	s_wait_alu depctr_sa_sdst(0)                               // 000000040A6C: BF88FF9E
	s_mov_b32 s25, s21                                         // 000000040A70: BE990015
	s_branch 12                                                // 000000040A74: BFA0000C <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x7a8>
	s_wait_loadcnt_dscnt 0x0                                   // 000000040A78: BFC80000
	s_barrier_signal -1                                        // 000000040A7C: BE804EC1
	v_add_nc_u32_e32 v79, 64, v79                              // 000000040A80: 4A9E9EC0
	s_add_co_i32 s24, s24, 16                                  // 000000040A84: 81189018
	s_add_co_i32 s25, s25, -16                                 // 000000040A88: 8119D019
	s_wait_alu depctr_sa_sdst(0)                               // 000000040A8C: BF88FF9E
	s_cmp_ge_i32 s24, s19                                      // 000000040A90: BF031318
	s_barrier_wait 0xffff                                      // 000000040A94: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 000000040A98: EE0AC07C 00040000 00000000
	s_cbranch_scc1 639                                         // 000000040AA4: BFA2027F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x11a4>
	s_sub_co_i32 s26, s19, s24                                 // 000000040AA8: 819A1813
	s_mov_b32 s27, exec_lo                                     // 000000040AAC: BE9B007E
	s_min_i32 s4, s26, 16                                      // 000000040AB0: 8904901A
	s_wait_alu depctr_sa_sdst(0)                               // 000000040AB4: BF88FF9E
	v_cmpx_gt_u32_e64 s4, v55                                  // 000000040AB8: D4CC007E 02026E04
	s_cbranch_execz 494                                        // 000000040AC0: BFA501EE <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0xf7c>
	v_add_nc_u32_e32 v17, s24, v55                             // 000000040AC4: 4A226E18
	s_delay_alu instid0(VALU_DEP_1)                            // 000000040AC8: BF870001
	v_lshlrev_b32_e32 v18, 3, v17                              // 000000040ACC: 30242283
	v_add_nc_u32_e32 v17, s16, v17                             // 000000040AD0: 4A222210
	ds_load_b64 v[21:22], v18 offset:18432                     // 000000040AD4: D9D84800 15000012
	v_cmp_le_i32_e32 vcc_lo, s20, v17                          // 000000040ADC: 7C862214
	s_and_saveexec_b32 s4, vcc_lo                              // 000000040AE0: BE84206A
	s_wait_alu depctr_sa_sdst(0)                               // 000000040AE4: BF88FF9E
	s_xor_b32 s28, exec_lo, s4                                 // 000000040AE8: 8D1C047E
	s_cbranch_execz 448                                        // 000000040AEC: BFA501C0 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0xef0>
	s_wait_dscnt 0x0                                           // 000000040AF0: BFC60000
	v_add_co_u32 v17, vcc_lo, v21, v58                         // 000000040AF4: D7006A11 02027515
	s_wait_alu depctr_va_vcc(0)                                // 000000040AFC: BF88FF9D
	v_add_co_ci_u32_e64 v18, null, 0, v22, vcc_lo              // 000000040B00: D5207C12 01AA2C80
	v_add_co_u32 v19, vcc_lo, v21, v57                         // 000000040B08: D7006A13 02027315
	s_wait_alu depctr_va_vcc(0)                                // 000000040B10: BF88FF9D
	v_add_co_ci_u32_e64 v20, null, 0, v22, vcc_lo              // 000000040B14: D5207C14 01AA2C80
	flat_load_d16_i8 v24, v[17:18] offset:256                  // 000000040B1C: EC07C07C 00000018 00010011
	v_mov_b32_e32 v25, 0x7fc00000                              // 000000040B28: 7E3202FF 7FC00000
	flat_load_b128 v[20:23], v[19:20]                          // 000000040B30: EC05C07C 00000014 00000013
	s_wait_loadcnt_dscnt 0x101                                 // 000000040B3C: BFC80101
	v_dual_mov_b32 v19, 0x7fc00000 :: v_dual_and_b32 v26, 7, v24// 000000040B40: CA2400FF 131A3087 7FC00000
	v_bfe_u32 v27, v24, 3, 4                                   // 000000040B4C: D610001B 02110718
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000040B54: BF870112
	v_cmp_ne_u32_e64 s4, 7, v26                                // 000000040B58: D44D0004 02023487
	v_cmp_ne_u32_e32 vcc_lo, 15, v27                           // 000000040B60: 7C9A368F
	s_or_b32 s29, s4, vcc_lo                                   // 000000040B64: 8C1D6A04
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000040B68: BF870009
	s_and_saveexec_b32 s4, s29                                 // 000000040B6C: BE84201D
	s_cbranch_execz 15                                         // 000000040B70: BFA5000F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x8b0>
	s_mov_b32 s29, exec_lo                                     // 000000040B74: BE9D007E
	v_cmpx_ne_u32_e32 0, v27                                   // 000000040B78: 7D9A3680
	s_xor_b32 s29, exec_lo, s29                                // 000000040B7C: 8D1D1D7E
	v_lshlrev_b32_e32 v25, 20, v26                             // 000000040B80: 30323494
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000040B84: BF870091
	v_lshl_or_b32 v25, v27, 23, v25                            // 000000040B88: D6560019 04652F1B
	v_add_nc_u32_e32 v25, 0x3c000000, v25                      // 000000040B90: 4A3232FF 3C000000
	s_and_not1_saveexec_b32 s29, s29                           // 000000040B98: BE9D301D
	v_cvt_f32_ubyte0_e32 v25, v26                              // 000000040B9C: 7E32231A
	s_delay_alu instid0(VALU_DEP_1)                            // 000000040BA0: BF870001
	v_mul_f32_e32 v25, 0x3b000000, v25                         // 000000040BA4: 103232FF 3B000000
	s_or_b32 exec_lo, exec_lo, s29                             // 000000040BAC: 8C7E1D7E
	s_wait_alu depctr_sa_sdst(0)                               // 000000040BB0: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000040BB4: 8C7E047E
	flat_load_d16_i8 v18, v[17:18] offset:257                  // 000000040BB8: EC07C07C 00000012 00010111
	s_wait_loadcnt_dscnt 0x0                                   // 000000040BC4: BFC80000
	v_bfe_u32 v26, v18, 3, 4                                   // 000000040BC8: D610001A 02110712
	v_and_b32_e32 v17, 7, v18                                  // 000000040BD0: 36222487
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000040BD4: BF870112
	v_cmp_ne_u32_e32 vcc_lo, 15, v26                           // 000000040BD8: 7C9A348F
	v_cmp_ne_u32_e64 s4, 7, v17                                // 000000040BDC: D44D0004 02022287
	s_or_b32 s29, s4, vcc_lo                                   // 000000040BE4: 8C1D6A04
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000040BE8: BF870009
	s_and_saveexec_b32 s4, s29                                 // 000000040BEC: BE84201D
	s_cbranch_execz 15                                         // 000000040BF0: BFA5000F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x930>
	s_mov_b32 s29, exec_lo                                     // 000000040BF4: BE9D007E
	v_cmpx_ne_u32_e32 0, v26                                   // 000000040BF8: 7D9A3480
	s_xor_b32 s29, exec_lo, s29                                // 000000040BFC: 8D1D1D7E
	v_lshlrev_b32_e32 v17, 20, v17                             // 000000040C00: 30222294
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000040C04: BF870091
	v_lshl_or_b32 v17, v26, 23, v17                            // 000000040C08: D6560011 04452F1A
	v_add_nc_u32_e32 v19, 0x3c000000, v17                      // 000000040C10: 4A2622FF 3C000000
	s_and_not1_saveexec_b32 s29, s29                           // 000000040C18: BE9D301D
	v_cvt_f32_ubyte0_e32 v17, v17                              // 000000040C1C: 7E222311
	s_delay_alu instid0(VALU_DEP_1)                            // 000000040C20: BF870001
	v_mul_f32_e32 v19, 0x3b000000, v17                         // 000000040C24: 102622FF 3B000000
	s_or_b32 exec_lo, exec_lo, s29                             // 000000040C2C: 8C7E1D7E
	s_wait_alu depctr_sa_sdst(0)                               // 000000040C30: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000040C34: 8C7E047E
	v_cmp_gt_i16_e32 vcc_lo, 0, v24.l                          // 000000040C38: 7C683080
	v_lshlrev_b32_e32 v17, 9, v20                              // 000000040C3C: 30222889
	v_lshlrev_b32_e32 v28, 1, v20                              // 000000040C40: 30382881
	v_lshlrev_b32_e32 v27, 8, v20                              // 000000040C44: 30362888
	v_mov_b16_e32 v35.h, 0                                     // 000000040C48: 7F463880
	s_wait_alu depctr_va_vcc(0)                                // 000000040C4C: BF88FF9D
	v_cndmask_b32_e64 v24, v25, -v25, vcc_lo                   // 000000040C50: D5010018 41AA3319
	v_cmp_gt_i16_e32 vcc_lo, 0, v18.l                          // 000000040C58: 7C682480
	v_lshlrev_b32_e32 v25, 5, v20                              // 000000040C5C: 30322885
	v_and_b32_e32 v17, 0xe00, v17                              // 000000040C60: 362222FF 00000E00
	v_lshlrev_b32_e32 v31, 8, v21                              // 000000040C68: 303E2A88
	v_dual_mul_f32 v29, 0x46800000, v24 :: v_dual_lshlrev_b32 v30, 9, v21// 000000040C6C: C8E230FF 1D1E2A89 46800000
	s_wait_alu depctr_va_vcc(0)                                // 000000040C78: BF88FF9D
	v_cndmask_b32_e64 v19, v19, -v19, vcc_lo                   // 000000040C7C: D5010013 41AA2713
	v_lshlrev_b32_e32 v26, 12, v20                             // 000000040C84: 3034288C
	v_and_b32_e32 v25, 0xe00, v25                              // 000000040C88: 363232FF 00000E00
	v_lshlrev_b32_e32 v24, 4, v20                              // 000000040C90: 30302884
	v_and_b32_e32 v30, 0xe00, v30                              // 000000040C94: 363C3CFF 00000E00
	v_mul_f32_e32 v19, 0x46800000, v19                         // 000000040C9C: 102626FF 46800000
	v_and_or_b32 v17, 0x8000, v26, v17                         // 000000040CA4: D6570011 044634FF 00008000
	v_and_b32_e32 v26, 0xe00, v28                              // 000000040CB0: 363438FF 00000E00
	v_and_or_b32 v25, 0x8000, v27, v25                         // 000000040CB8: D6570019 046636FF 00008000
	v_and_b32_e32 v27, 0x8000, v20                             // 000000040CC4: 363628FF 00008000
	v_lshrrev_b32_e32 v28, 3, v20                              // 000000040CCC: 32382883
	v_fma_mix_f32 v17, v17, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040CD0: CC200011 8A023B11
	v_and_or_b32 v24, 0x8000, v24, v26                         // 000000040CD8: D6570018 046A30FF 00008000
	v_fma_mix_f32 v25, v25, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040CE4: CC200019 8A023B19
	v_lshrrev_b32_e32 v32, 3, v21                              // 000000040CEC: 32402A83
	v_and_or_b32 v26, 0xe00, v28, v27                          // 000000040CF0: D657001A 046E38FF 00000E00
	v_mov_b16_e32 v35.l, v17.h                                 // 000000040CFC: 7E463991
	v_fma_mix_f32 v24, v24, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040D00: CC200018 8A023B18
	v_lshrrev_b32_e32 v28, 19, v20                             // 000000040D08: 32382893
	v_lshrrev_b32_e32 v27, 8, v20                              // 000000040D0C: 32362888
	v_fma_mix_f32 v26, v26, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040D10: CC20001A 8A023B1A
	v_and_or_b32 v17, 0xffff0000, v25, v35                     // 000000040D18: D6570011 048E32FF FFFF0000
	v_mov_b16_e32 v35.l, v24.h                                 // 000000040D24: 7E463998
	v_lshrrev_b32_e32 v24, 7, v20                              // 000000040D28: 32302887
	v_lshrrev_b32_e32 v25, 4, v20                              // 000000040D2C: 32322884
	v_and_b32_e32 v28, 0xe00, v28                              // 000000040D30: 363838FF 00000E00
	v_lshrrev_b32_e32 v33, 11, v21                             // 000000040D38: 32422A8B
	v_and_or_b32 v18, 0xffff0000, v26, v35                     // 000000040D3C: D6570012 048E34FF FFFF0000
	v_and_b32_e32 v24, 0xe00, v24                              // 000000040D48: 363030FF 00000E00
	v_lshrrev_b32_e32 v26, 15, v20                             // 000000040D50: 3234288F
	v_mov_b16_e32 v35.l, v20.h                                 // 000000040D54: 7E463994
	v_lshlrev_b32_e32 v80, 8, v22                              // 000000040D58: 30A02C88
	v_lshrrev_b32_e32 v81, 3, v22                              // 000000040D5C: 32A22C83
	v_and_or_b32 v24, 0x8000, v25, v24                         // 000000040D60: D6570018 046232FF 00008000
	v_lshrrev_b32_e32 v25, 11, v20                             // 000000040D6C: 3232288B
	v_lshrrev_b32_e32 v20, 12, v20                             // 000000040D70: 3228288C
	v_and_b32_e32 v26, 0xe00, v26                              // 000000040D74: 363434FF 00000E00
	v_lshrrev_b32_e32 v82, 11, v22                             // 000000040D7C: 32A42C8B
	v_fma_mix_f32 v24, v24, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040D80: CC200018 8A023B18
	v_and_b32_e32 v25, 0xe00, v25                              // 000000040D88: 363232FF 00000E00
	v_lshlrev_b32_e32 v83, 8, v23                              // 000000040D90: 30A62E88
	v_and_or_b32 v20, 0x8000, v20, v26                         // 000000040D94: D6570014 046A28FF 00008000
	v_and_or_b32 v26, 0x8000, v35, v28                         // 000000040DA0: D657001A 047246FF 00008000
	v_lshlrev_b32_e32 v28, 12, v21                             // 000000040DAC: 30382A8C
	v_and_or_b32 v25, 0x8000, v27, v25                         // 000000040DB0: D6570019 046636FF 00008000
	v_lshlrev_b32_e32 v27, 5, v21                              // 000000040DBC: 30362A85
	v_fma_mix_f32 v20, v20, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040DC0: CC200014 8A023B14
	v_fma_mix_f32 v26, v26, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040DC8: CC20001A 8A023B1A
	v_and_or_b32 v28, 0x8000, v28, v30                         // 000000040DD0: D657001C 047A38FF 00008000
	v_lshlrev_b32_e32 v30, 1, v21                              // 000000040DDC: 303C2A81
	v_and_b32_e32 v27, 0xe00, v27                              // 000000040DE0: 363636FF 00000E00
	v_mov_b16_e32 v35.l, v20.h                                 // 000000040DE8: 7E463994
	v_lshlrev_b32_e32 v20, 4, v21                              // 000000040DEC: 30282A84
	v_fma_mix_f32 v28, v28, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040DF0: CC20001C 8A023B1C
	v_and_b32_e32 v30, 0xe00, v30                              // 000000040DF8: 363C3CFF 00000E00
	v_and_or_b32 v27, 0x8000, v31, v27                         // 000000040E00: D657001B 046E3EFF 00008000
	v_and_b32_e32 v31, 0x8000, v21                             // 000000040E0C: 363E2AFF 00008000
	v_mov_b16_e32 v34.l, v24.h                                 // 000000040E14: 7E443998
	v_and_b32_e32 v82, 0xe00, v82                              // 000000040E18: 36A4A4FF 00000E00
	v_and_or_b32 v30, 0x8000, v20, v30                         // 000000040E20: D657001E 047A28FF 00008000
	v_and_or_b32 v20, 0xffff0000, v26, v35                     // 000000040E2C: D6570014 048E34FF FFFF0000
	v_fma_mix_f32 v26, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040E38: CC20001A 8A023B1B
	v_mov_b16_e32 v35.l, v28.h                                 // 000000040E40: 7E46399C
	v_and_or_b32 v27, 0xe00, v32, v31                          // 000000040E44: D657001B 047E40FF 00000E00
	v_fma_mix_f32 v28, v30, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040E50: CC20001C 8A023B1E
	v_fma_mix_f32 v30, v25, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040E58: CC20001E 8A023B19
	v_lshrrev_b32_e32 v31, 15, v21                             // 000000040E60: 323E2A8F
	v_and_or_b32 v24, 0xffff0000, v26, v35                     // 000000040E64: D6570018 048E34FF FFFF0000
	v_lshrrev_b32_e32 v26, 7, v21                              // 000000040E70: 32342A87
	v_fma_mix_f32 v25, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040E74: CC200019 8A023B1B
	v_mov_b16_e32 v35.l, v28.h                                 // 000000040E7C: 7E46399C
	v_lshrrev_b32_e32 v27, 4, v21                              // 000000040E80: 32362A84
	v_lshrrev_b32_e32 v32, 19, v21                             // 000000040E84: 32402A93
	v_and_b32_e32 v26, 0xe00, v26                              // 000000040E88: 363434FF 00000E00
	v_lshrrev_b32_e32 v28, 8, v21                              // 000000040E90: 32382A88
	v_and_or_b32 v25, 0xffff0000, v25, v35                     // 000000040E94: D6570019 048E32FF FFFF0000
	v_mov_b16_e32 v35.l, v21.h                                 // 000000040EA0: 7E463995
	v_lshrrev_b32_e32 v21, 12, v21                             // 000000040EA4: 322A2A8C
	v_and_or_b32 v26, 0x8000, v27, v26                         // 000000040EA8: D657001A 046A36FF 00008000
	v_and_b32_e32 v27, 0xe00, v31                              // 000000040EB4: 36363EFF 00000E00
	v_and_b32_e32 v31, 0xe00, v32                              // 000000040EBC: 363E40FF 00000E00
	v_and_b32_e32 v32, 0xe00, v33                              // 000000040EC4: 364042FF 00000E00
	v_lshlrev_b32_e32 v33, 9, v22                              // 000000040ECC: 30422C89
	v_fma_mix_f32 v26, v26, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040ED0: CC20001A 8A023B1A
	v_and_or_b32 v21, 0x8000, v21, v27                         // 000000040ED8: D6570015 046E2AFF 00008000
	v_and_or_b32 v27, 0x8000, v35, v31                         // 000000040EE4: D657001B 047E46FF 00008000
	v_and_or_b32 v28, 0x8000, v28, v32                         // 000000040EF0: D657001C 048238FF 00008000
	v_lshlrev_b32_e32 v31, 12, v22                             // 000000040EFC: 303E2C8C
	v_and_b32_e32 v32, 0xe00, v33                              // 000000040F00: 364042FF 00000E00
	v_fma_mix_f32 v21, v21, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040F08: CC200015 8A023B15
	v_lshlrev_b32_e32 v33, 5, v22                              // 000000040F10: 30422C85
	v_fma_mix_f32 v27, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040F14: CC20001B 8A023B1B
	v_lshrrev_b32_e32 v85, 3, v23                              // 000000040F1C: 32AA2E83
	v_and_or_b32 v31, 0x8000, v31, v32                         // 000000040F20: D657001F 04823EFF 00008000
	v_lshlrev_b32_e32 v32, 1, v22                              // 000000040F2C: 30402C81
	v_and_b32_e32 v33, 0xe00, v33                              // 000000040F30: 364242FF 00000E00
	v_mov_b16_e32 v35.l, v21.h                                 // 000000040F38: 7E463995
	v_lshlrev_b32_e32 v21, 4, v22                              // 000000040F3C: 302A2C84
	v_fma_mix_f32 v31, v31, v19, neg(0) op_sel_hi:[1,0,0]      // 000000040F40: CC20001F 8A02271F
	v_and_b32_e32 v32, 0xe00, v32                              // 000000040F48: 364040FF 00000E00
	v_and_or_b32 v33, 0x8000, v80, v33                         // 000000040F50: D6570021 0486A0FF 00008000
	v_and_b32_e32 v80, 0x8000, v22                             // 000000040F5C: 36A02CFF 00008000
	v_and_or_b32 v27, 0xffff0000, v27, v35                     // 000000040F64: D657001B 048E36FF FFFF0000
	v_mov_b16_e32 v35.l, v31.h                                 // 000000040F70: 7E46399F
	v_and_or_b32 v21, 0x8000, v21, v32                         // 000000040F74: D6570015 04822AFF 00008000
	v_fma_mix_f32 v32, v33, v19, neg(0) op_sel_hi:[1,0,0]      // 000000040F80: CC200020 8A022721
	v_and_or_b32 v31, 0xe00, v81, v80                          // 000000040F88: D657001F 0542A2FF 00000E00
	v_fma_mix_f32 v80, v28, v29, neg(0) op_sel_hi:[1,0,0]      // 000000040F94: CC200050 8A023B1C
	v_lshrrev_b32_e32 v33, 7, v22                              // 000000040F9C: 32422C87
	v_fma_mix_f32 v21, v21, v19, neg(0) op_sel_hi:[1,0,0]      // 000000040FA0: CC200015 8A022715
	v_mov_b16_e32 v21.l, v26.h                                 // 000000040FA8: 7E2A399A
	v_and_or_b32 v28, 0xffff0000, v32, v35                     // 000000040FAC: D657001C 048E40FF FFFF0000
	v_fma_mix_f32 v26, v31, v19, neg(0) op_sel_hi:[1,0,0]      // 000000040FB8: CC20001A 8A02271F
	v_lshrrev_b32_e32 v31, 4, v22                              // 000000040FC0: 323E2C84
	v_mov_b16_e32 v35.l, v21.h                                 // 000000040FC4: 7E463995
	v_lshrrev_b32_e32 v81, 19, v22                             // 000000040FC8: 32A22C93
	v_and_b32_e32 v33, 0xe00, v33                              // 000000040FCC: 364242FF 00000E00
	v_lshrrev_b32_e32 v32, 8, v22                              // 000000040FD4: 32402C88
	v_lshrrev_b32_e32 v86, 12, v23                             // 000000040FD8: 32AC2E8C
	v_and_or_b32 v29, 0xffff0000, v26, v35                     // 000000040FDC: D657001D 048E34FF FFFF0000
	v_lshrrev_b32_e32 v26, 15, v22                             // 000000040FE8: 32342C8F
	v_mov_b16_e32 v35.l, v22.h                                 // 000000040FEC: 7E463996
	v_lshrrev_b32_e32 v22, 12, v22                             // 000000040FF0: 322C2C8C
	v_and_b32_e32 v81, 0xe00, v81                              // 000000040FF4: 36A2A2FF 00000E00
	v_and_or_b32 v33, 0x8000, v31, v33                         // 000000040FFC: D6570021 04863EFF 00008000
	v_and_b32_e32 v26, 0xe00, v26                              // 000000041008: 363434FF 00000E00
	v_lshlrev_b32_e32 v31, 9, v23                              // 000000041010: 303E2E89
	v_and_or_b32 v32, 0x8000, v32, v82                         // 000000041014: D6570020 054A40FF 00008000
	v_lshlrev_b32_e32 v82, 5, v23                              // 000000041020: 30A42E85
	v_fma_mix_f32 v33, v33, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041024: CC200021 8A022721
	v_and_or_b32 v22, 0x8000, v22, v26                         // 00000004102C: D6570016 046A2CFF 00008000
	v_and_or_b32 v26, 0x8000, v35, v81                         // 000000041038: D657001A 054646FF 00008000
	v_lshlrev_b32_e32 v81, 12, v23                             // 000000041044: 30A22E8C
	v_and_b32_e32 v31, 0xe00, v31                              // 000000041048: 363E3EFF 00000E00
	v_and_b32_e32 v82, 0xe00, v82                              // 000000041050: 36A4A4FF 00000E00
	v_fma_mix_f32 v22, v22, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041058: CC200016 8A022716
	v_fma_mix_f32 v26, v26, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041060: CC20001A 8A02271A
	v_lshrrev_b32_e32 v87, 19, v23                             // 000000041068: 32AE2E93
	v_and_or_b32 v31, 0x8000, v81, v31                         // 00000004106C: D657001F 047EA2FF 00008000
	v_lshlrev_b32_e32 v81, 1, v23                              // 000000041078: 30A22E81
	v_mov_b16_e32 v35.l, v22.h                                 // 00000004107C: 7E463996
	v_lshlrev_b32_e32 v22, 4, v23                              // 000000041080: 302C2E84
	v_and_or_b32 v82, 0x8000, v83, v82                         // 000000041084: D6570052 054AA6FF 00008000
	v_fma_mix_f32 v84, v31, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041090: CC200054 8A02271F
	v_and_b32_e32 v81, 0xe00, v81                              // 000000041098: 36A2A2FF 00000E00
	v_and_b32_e32 v83, 0x8000, v23                             // 0000000410A0: 36A62EFF 00008000
	v_and_or_b32 v31, 0xffff0000, v26, v35                     // 0000000410A8: D657001F 048E34FF FFFF0000
	v_fma_mix_f32 v26, v82, v19, neg(0) op_sel_hi:[1,0,0]      // 0000000410B4: CC20001A 8A022752
	v_mov_b16_e32 v35.l, v84.h                                 // 0000000410BC: 7E4639D4
	v_and_or_b32 v22, 0x8000, v22, v81                         // 0000000410C0: D6570016 05462CFF 00008000
	v_and_or_b32 v81, 0xe00, v85, v83                          // 0000000410CC: D6570051 054EAAFF 00000E00
	v_fma_mix_f32 v82, v32, v19, neg(0) op_sel_hi:[1,0,0]      // 0000000410D8: CC200052 8A022720
	v_lshrrev_b32_e32 v83, 7, v23                              // 0000000410E0: 32A62E87
	v_and_or_b32 v32, 0xffff0000, v26, v35                     // 0000000410E4: D6570020 048E34FF FFFF0000
	v_fma_mix_f32 v22, v22, v19, neg(0) op_sel_hi:[1,0,0]      // 0000000410F0: CC200016 8A022716
	v_fma_mix_f32 v26, v81, v19, neg(0) op_sel_hi:[1,0,0]      // 0000000410F8: CC20001A 8A022751
	v_mov_b16_e32 v22.l, v33.h                                 // 000000041100: 7E2C39A1
	v_lshrrev_b32_e32 v81, 4, v23                              // 000000041104: 32A22E84
	v_lshrrev_b32_e32 v85, 11, v23                             // 000000041108: 32AA2E8B
	v_mov_b16_e32 v35.l, v22.h                                 // 00000004110C: 7E463996
	v_and_b32_e32 v83, 0xe00, v83                              // 000000041110: 36A6A6FF 00000E00
	v_lshrrev_b32_e32 v84, 8, v23                              // 000000041118: 32A82E88
	v_mov_b16_e32 v34.h, v35.h                                 // 00000004111C: 7F4439A3
	v_and_b32_e32 v85, 0xe00, v85                              // 000000041120: 36AAAAFF 00000E00
	v_and_or_b32 v33, 0xffff0000, v26, v35                     // 000000041128: D6570021 048E34FF FFFF0000
	v_lshrrev_b32_e32 v26, 15, v23                             // 000000041134: 32342E8F
	v_and_or_b32 v81, 0x8000, v81, v83                         // 000000041138: D6570051 054EA2FF 00008000
	v_mov_b16_e32 v35.l, v23.h                                 // 000000041144: 7E463997
	v_and_b32_e32 v23, 0xe00, v87                              // 000000041148: 362EAEFF 00000E00
	v_and_or_b32 v83, 0x8000, v84, v85                         // 000000041150: D6570053 0556A8FF 00008000
	v_and_b32_e32 v26, 0xe00, v26                              // 00000004115C: 363434FF 00000E00
	v_fma_mix_f32 v81, v81, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041164: CC200051 8A022751
	v_mov_b16_e32 v21.h, v35.h                                 // 00000004116C: 7F2A39A3
	v_and_or_b32 v23, 0x8000, v35, v23                         // 000000041170: D6570017 045E46FF 00008000
	v_mov_b16_e32 v22.h, v35.h                                 // 00000004117C: 7F2C39A3
	v_and_or_b32 v26, 0x8000, v86, v26                         // 000000041180: D657001A 046AACFF 00008000
	v_fma_mix_f32 v83, v83, v19, neg(0) op_sel_hi:[1,0,0]      // 00000004118C: CC200053 8A022753
	v_mov_b16_e32 v81.l, v81.h                                 // 000000041194: 7EA239D1
	v_mov_b16_e32 v81.h, v35.h                                 // 000000041198: 7FA239A3
	v_fma_mix_f32 v23, v23, v19, neg(0) op_sel_hi:[1,0,0]      // 00000004119C: CC200017 8A022717
	v_fma_mix_f32 v26, v26, v19, neg(0) op_sel_hi:[1,0,0]      // 0000000411A4: CC20001A 8A02271A
	v_and_or_b32 v19, 0xffff0000, v30, v34                     // 0000000411AC: D6570013 048A3CFF FFFF0000
	v_and_or_b32 v30, 0xffff0000, v82, v22                     // 0000000411B8: D657001E 045AA4FF FFFF0000
	v_and_or_b32 v34, 0xffff0000, v83, v81                     // 0000000411C4: D6570022 0546A6FF FFFF0000
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 0000000411D0: BF870124
	v_mov_b16_e32 v35.l, v26.h                                 // 0000000411D4: 7E46399A
	v_and_or_b32 v26, 0xffff0000, v80, v21                     // 0000000411D8: D657001A 0456A0FF FFFF0000
	v_and_or_b32 v35, 0xffff0000, v23, v35                     // 0000000411E4: D6570023 048E2EFF FFFF0000
	s_and_not1_saveexec_b32 s4, s28                            // 0000000411F0: BE84301C
	s_cbranch_execz 19                                         // 0000000411F4: BFA50013 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0xf44>
	s_wait_dscnt 0x0                                           // 0000000411F8: BFC60000
	v_add_co_u32 v21, vcc_lo, v21, v59                         // 0000000411FC: D7006A15 02027715
	s_wait_alu depctr_va_vcc(0)                                // 000000041204: BF88FF9D
	v_add_co_ci_u32_e64 v22, null, 0, v22, vcc_lo              // 000000041208: D5207C16 01AA2C80
	s_clause 0x3                                               // 000000041210: BF850003
	flat_load_b128 v[17:20], v[21:22]                          // 000000041214: EC05C07C 00000011 00000015
	flat_load_b128 v[24:27], v[21:22] offset:16                // 000000041220: EC05C07C 00000018 00001015
	flat_load_b128 v[28:31], v[21:22] offset:32                // 00000004122C: EC05C07C 0000001C 00002015
	flat_load_b128 v[32:35], v[21:22] offset:48                // 000000041238: EC05C07C 00000020 00003015
	s_wait_alu depctr_sa_sdst(0)                               // 000000041244: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000041248: 8C7E047E
	s_wait_loadcnt_dscnt 0x303                                 // 00000004124C: BFC80303
	ds_store_b128 v60, v[17:20]                                // 000000041250: DB7C0000 0000113C
	s_wait_loadcnt_dscnt 0x203                                 // 000000041258: BFC80203
	ds_store_b128 v61, v[24:27]                                // 00000004125C: DB7C0000 0000183D
	s_wait_loadcnt_dscnt 0x103                                 // 000000041264: BFC80103
	ds_store_b128 v62, v[28:31]                                // 000000041268: DB7C0000 00001C3E
	s_wait_loadcnt_dscnt 0x3                                   // 000000041270: BFC80003
	ds_store_b128 v63, v[32:35]                                // 000000041274: DB7C0000 0000203F
	s_or_b32 exec_lo, exec_lo, s27                             // 00000004127C: 8C7E1B7E
	s_wait_loadcnt_dscnt 0x0                                   // 000000041280: BFC80000
	s_barrier_signal -1                                        // 000000041284: BE804EC1
	s_cmp_lt_i32 s26, 1                                        // 000000041288: BF04811A
	s_barrier_wait 0xffff                                      // 00000004128C: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 000000041290: EE0AC07C 00040000 00000000
	s_cbranch_scc1 65014                                       // 00000004129C: BFA2FDF6 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x778>
	v_cmp_gt_u32_e32 vcc_lo, 32, v74                           // 0000000412A0: 7C9894A0
	v_med3_i32 v17, s25, 1, 16                                 // 0000000412A4: D6200011 02410219
	v_dual_mov_b32 v24, v65 :: v_dual_mov_b32 v23, v64         // 0000000412AC: CA100141 18160140
	s_wait_alu depctr_va_vcc(0)                                // 0000000412B4: BF88FF9D
	v_cndmask_b32_e32 v18, v69, v74, vcc_lo                    // 0000000412B8: 02249545
	v_cmp_gt_u32_e32 vcc_lo, 32, v75                           // 0000000412BC: 7C9896A0
	v_readfirstlane_b32 s4, v17                                // 0000000412C0: 7E080511
	s_delay_alu instid0(VALU_DEP_3) | instskip(SKIP_4) | instid1(VALU_DEP_2)// 0000000412C4: BF870153
	v_lshlrev_b32_e32 v17, 2, v18                              // 0000000412C8: 30222482
	s_wait_alu depctr_va_vcc(0)                                // 0000000412CC: BF88FF9D
	v_cndmask_b32_e32 v19, v69, v75, vcc_lo                    // 0000000412D0: 02269745
	v_cmp_gt_u32_e32 vcc_lo, 32, v76                           // 0000000412D4: 7C9898A0
	s_lshl_b32 s4, s4, 10                                      // 0000000412D8: 84048A04
	v_lshlrev_b32_e32 v18, 2, v19                              // 0000000412DC: 30242682
	s_wait_alu depctr_va_vcc(0)                                // 0000000412E0: BF88FF9D
	v_cndmask_b32_e32 v20, v69, v76, vcc_lo                    // 0000000412E4: 02289945
	v_cmp_gt_u32_e32 vcc_lo, 32, v77                           // 0000000412E8: 7C989AA0
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)// 0000000412EC: BF870142
	v_lshlrev_b32_e32 v19, 2, v20                              // 0000000412F0: 30262882
	s_wait_alu depctr_va_vcc(0)                                // 0000000412F4: BF88FF9D
	v_cndmask_b32_e32 v21, v69, v77, vcc_lo                    // 0000000412F8: 022A9B45
	v_cmp_gt_u32_e32 vcc_lo, 32, v78                           // 0000000412FC: 7C989CA0
	v_lshlrev_b32_e32 v20, 2, v21                              // 000000041300: 30282A82
	s_wait_alu depctr_va_vcc(0)                                // 000000041304: BF88FF9D
	v_cndmask_b32_e32 v22, v69, v78, vcc_lo                    // 000000041308: 022C9D45
	s_delay_alu instid0(VALU_DEP_1)                            // 00000004130C: BF870001
	v_dual_mov_b32 v22, v79 :: v_dual_lshlrev_b32 v21, 2, v22  // 000000041310: CA22014F 16142C82
	s_branch 11                                                // 000000041318: BFA0000B <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1048>
	s_or_b32 exec_lo, exec_lo, s26                             // 00000004131C: 8C7E1A7E
	v_add_nc_u32_e32 v24, 0x400, v24                           // 000000041320: 4A3030FF 00000400
	v_add_nc_u32_e32 v23, 0x400, v23                           // 000000041328: 4A2E2EFF 00000400
	v_add_nc_u32_e32 v22, 4, v22                               // 000000041330: 4A2C2C84
	s_wait_alu depctr_sa_sdst(0)                               // 000000041334: BF88FF9E
	s_addk_co_i32 s4, 0xfc00                                   // 000000041338: B784FC00
	s_wait_alu depctr_sa_sdst(0)                               // 00000004133C: BF88FF9E
	s_cmp_eq_u32 s4, 0                                         // 000000041340: BF068004
	s_cbranch_scc1 64972                                       // 000000041344: BFA2FDCC <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x778>
	s_wait_dscnt 0x0                                           // 000000041348: BFC60000
	ds_load_b128 v[25:28], v23                                 // 00000004134C: DBFC0000 19000017
	s_wait_dscnt 0x0                                           // 000000041354: BFC60000
	v_lshlrev_b32_e32 v29, 16, v25                             // 000000041358: 303A3290
	v_and_b32_e32 v25, 0xffff0000, v25                         // 00000004135C: 363232FF FFFF0000
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_3) | instid1(VALU_DEP_2)// 000000041364: BF870142
	v_fma_f32 v33, v13, v29, 0                                 // 000000041368: D6130021 02023B0D
	ds_load_b128 v[29:32], v24                                 // 000000041370: DBFC0000 1D000018
	v_dual_fmac_f32 v33, v14, v25 :: v_dual_lshlrev_b32 v34, 16, v26// 000000041378: C822330E 21223490
	v_and_b32_e32 v25, 0xffff0000, v26                         // 000000041380: 363234FF FFFF0000
	v_dual_fmac_f32 v33, v15, v34 :: v_dual_lshlrev_b32 v26, 16, v27// 000000041388: C822450F 211A3690
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_3) | instid1(VALU_DEP_3)// 000000041390: BF8701C1
	v_fmac_f32_e32 v33, v16, v25                               // 000000041394: 56423310
	v_and_b32_e32 v25, 0xffff0000, v27                         // 000000041398: 363236FF FFFF0000
	s_wait_dscnt 0x0                                           // 0000000413A0: BFC60000
	v_mov_b16_e32 v27.l, v29.l                                 // 0000000413A4: 7E36391D
	v_dual_fmac_f32 v33, v9, v26 :: v_dual_lshlrev_b32 v26, 16, v28// 0000000413A8: C8223509 211A3890
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 0000000413B0: BF870121
	v_fmac_f32_e32 v33, v10, v25                               // 0000000413B4: 5642330A
	v_and_b32_e32 v25, 0xffff0000, v28                         // 0000000413B8: 363238FF FFFF0000
	v_dual_fmac_f32 v33, v11, v26 :: v_dual_lshlrev_b32 v26, 16, v27// 0000000413C0: C822350B 211A3690
	v_mov_b16_e32 v27.l, v30.l                                 // 0000000413C8: 7E36391E
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 0000000413CC: BF870122
	v_fmac_f32_e32 v33, v12, v25                               // 0000000413D0: 5642330C
	v_and_b32_e32 v25, 0xffff0000, v29                         // 0000000413D4: 36323AFF FFFF0000
	v_dual_fmac_f32 v33, v5, v26 :: v_dual_lshlrev_b32 v26, 16, v27// 0000000413DC: C8223505 211A3690
	v_mov_b16_e32 v27.l, v31.l                                 // 0000000413E4: 7E36391F
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 0000000413E8: BF870122
	v_fmac_f32_e32 v33, v6, v25                                // 0000000413EC: 56423306
	v_and_b32_e32 v25, 0xffff0000, v30                         // 0000000413F0: 36323CFF FFFF0000
	v_dual_fmac_f32 v33, v7, v26 :: v_dual_lshlrev_b32 v26, 16, v27// 0000000413F8: C8223507 211A3690
	v_mov_b16_e32 v27.l, v32.l                                 // 000000041400: 7E363920
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 000000041404: BF870122
	v_fmac_f32_e32 v33, v8, v25                                // 000000041408: 56423308
	v_and_b32_e32 v25, 0xffff0000, v31                         // 00000004140C: 36323EFF FFFF0000
	v_dual_fmac_f32 v33, v1, v26 :: v_dual_lshlrev_b32 v26, 16, v27// 000000041414: C8223501 211A3690
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 00000004141C: BF870121
	v_fmac_f32_e32 v33, v2, v25                                // 000000041420: 56423302
	v_and_b32_e32 v25, 0xffff0000, v32                         // 000000041424: 363240FF FFFF0000
	v_fmac_f32_e32 v33, v3, v26                                // 00000004142C: 56423503
	s_delay_alu instid0(VALU_DEP_1)                            // 000000041430: BF870001
	v_fmac_f32_e32 v33, v4, v25                                // 000000041434: 56423304
	ds_bpermute_b32 v25, v17, v33                              // 000000041438: DACC0000 19002111
	s_wait_dscnt 0x0                                           // 000000041440: BFC60000
	v_add_f32_e32 v25, v33, v25                                // 000000041444: 06323321
	ds_bpermute_b32 v26, v18, v25                              // 000000041448: DACC0000 1A001912
	s_wait_dscnt 0x0                                           // 000000041450: BFC60000
	v_add_f32_e32 v25, v25, v26                                // 000000041454: 06323519
	ds_bpermute_b32 v26, v19, v25                              // 000000041458: DACC0000 1A001913
	s_wait_dscnt 0x0                                           // 000000041460: BFC60000
	v_add_f32_e32 v25, v25, v26                                // 000000041464: 06323519
	ds_bpermute_b32 v26, v20, v25                              // 000000041468: DACC0000 1A001914
	s_wait_dscnt 0x0                                           // 000000041470: BFC60000
	v_add_f32_e32 v25, v25, v26                                // 000000041474: 06323519
	ds_bpermute_b32 v26, v21, v25                              // 000000041478: DACC0000 1A001915
	s_and_saveexec_b32 s26, s2                                 // 000000041480: BE9A2002
	s_cbranch_execz 65445                                      // 000000041484: BFA5FFA5 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x101c>
	s_wait_dscnt 0x0                                           // 000000041488: BFC60000
	v_add_f32_e32 v25, v25, v26                                // 00000004148C: 06323519
	s_delay_alu instid0(VALU_DEP_1)                            // 000000041490: BF870001
	v_mul_f32_e32 v25, s17, v25                                // 000000041494: 10323211
	ds_store_b32 v22, v25 offset:16384                         // 000000041498: D8344000 00001916
	s_branch 65438                                             // 0000000414A0: BFA0FF9E <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x101c>
	s_and_saveexec_b32 s24, s3                                 // 0000000414A4: BE982003
	s_cbranch_execz 208                                        // 0000000414A8: BFA500D0 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x14ec>
	v_cmp_gt_i32_e32 vcc_lo, s23, v54                          // 0000000414AC: 7C886C17
	v_mov_b32_e32 v17, 0xff800000                              // 0000000414B0: 7E2202FF FF800000
	s_and_saveexec_b32 s23, vcc_lo                             // 0000000414B8: BE97206A
	s_cbranch_execz 23                                         // 0000000414BC: BFA50017 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x121c>
	v_dual_mov_b32 v17, 0xff800000 :: v_dual_mov_b32 v18, v73  // 0000000414C0: CA1000FF 11120149 FF800000
	v_mov_b32_e32 v19, v54                                     // 0000000414CC: 7E260336
	s_mov_b32 s25, 0                                           // 0000000414D0: BE990080
	ds_load_b32 v20, v18 offset:16384                          // 0000000414D4: D8D84000 14000012
	v_add_nc_u32_e32 v19, 32, v19                              // 0000000414DC: 4A2626A0
	v_dual_max_num_f32 v17, v17, v17 :: v_dual_add_nc_u32 v18, 0x80, v18// 0000000414E0: CAA02311 111224FF 00000080
	s_wait_dscnt 0x0                                           // 0000000414EC: BFC60000
	v_max_num_f32_e32 v20, v20, v20                            // 0000000414F0: 2C282914
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_2)// 0000000414F4: BF870113
	v_cmp_le_i32_e64 s4, s19, v19                              // 0000000414F8: D4430004 02022613
	v_max_num_f32_e32 v17, v17, v20                            // 000000041500: 2C222911
	s_wait_alu depctr_sa_sdst(0)                               // 000000041504: BF88FF9E
	s_or_b32 s25, s4, s25                                      // 000000041508: 8C191904
	s_wait_alu depctr_sa_sdst(0)                               // 00000004150C: BF88FF9E
	s_and_not1_b32 exec_lo, exec_lo, s25                       // 000000041510: 917E197E
	s_cbranch_execnz 65519                                     // 000000041514: BFA6FFEF <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x11d4>
	s_or_b32 exec_lo, exec_lo, s25                             // 000000041518: 8C7E197E
	s_wait_alu depctr_sa_sdst(0)                               // 00000004151C: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s23                             // 000000041520: 8C7E177E
	v_cmp_gt_u32_e64 s4, 32, v74                               // 000000041524: D44C0004 020294A0
	s_wait_alu depctr_va_sdst(0)                               // 00000004152C: BF88F19F
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 000000041530: BF870121
	v_cndmask_b32_e64 v18, v69, v74, s4                        // 000000041534: D5010012 00129545
	v_cmp_gt_u32_e64 s4, 32, v75                               // 00000004153C: D44C0004 020296A0
	v_lshlrev_b32_e32 v18, 2, v18                              // 000000041544: 30242482
	s_wait_alu depctr_va_sdst(0)                               // 000000041548: BF88F19F
	s_delay_alu instid0(VALU_DEP_2)                            // 00000004154C: BF870002
	v_cndmask_b32_e64 v20, v69, v75, s4                        // 000000041550: D5010014 00129745
	v_cmp_gt_u32_e64 s4, 32, v76                               // 000000041558: D44C0004 020298A0
	ds_bpermute_b32 v19, v18, v17                              // 000000041560: DACC0000 13001112
	v_max_num_f32_e32 v17, v17, v17                            // 000000041568: 2C222311
	s_wait_dscnt 0x0                                           // 00000004156C: BFC60000
	v_max_num_f32_e32 v21, v19, v19                            // 000000041570: 2C2A2713
	v_lshlrev_b32_e32 v19, 2, v20                              // 000000041574: 30262882
	s_delay_alu instid0(VALU_DEP_2)                            // 000000041578: BF870002
	v_max_num_f32_e32 v17, v17, v21                            // 00000004157C: 2C222B11
	s_wait_alu depctr_va_sdst(0)                               // 000000041580: BF88F19F
	v_cndmask_b32_e64 v21, v69, v76, s4                        // 000000041584: D5010015 00129945
	v_cmp_gt_u32_e64 s4, 32, v77                               // 00000004158C: D44C0004 02029AA0
	ds_bpermute_b32 v20, v19, v17                              // 000000041594: DACC0000 14001113
	s_wait_dscnt 0x0                                           // 00000004159C: BFC60000
	v_max_num_f32_e32 v22, v20, v20                            // 0000000415A0: 2C2C2914
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000415A4: BF870001
	v_dual_max_num_f32 v17, v17, v22 :: v_dual_lshlrev_b32 v20, 2, v21// 0000000415A8: CAA22D11 11142A82
	s_wait_alu depctr_va_sdst(0)                               // 0000000415B0: BF88F19F
	v_cndmask_b32_e64 v22, v69, v77, s4                        // 0000000415B4: D5010016 00129B45
	v_cmp_gt_u32_e64 s4, 32, v78                               // 0000000415BC: D44C0004 02029CA0
	ds_bpermute_b32 v21, v20, v17                              // 0000000415C4: DACC0000 15001114
	v_lshlrev_b32_e32 v22, 2, v22                              // 0000000415CC: 302C2C82
	s_wait_alu depctr_va_sdst(0)                               // 0000000415D0: BF88F19F
	v_cndmask_b32_e64 v23, v69, v78, s4                        // 0000000415D4: D5010017 00129D45
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_1)// 0000000415DC: BF8700B1
	v_lshlrev_b32_e32 v23, 2, v23                              // 0000000415E0: 302E2E82
	s_wait_dscnt 0x0                                           // 0000000415E4: BFC60000
	v_max_num_f32_e32 v21, v21, v21                            // 0000000415E8: 2C2A2B15
	v_max_num_f32_e32 v17, v17, v21                            // 0000000415EC: 2C222B11
	ds_bpermute_b32 v21, v22, v17                              // 0000000415F0: DACC0000 15001116
	s_wait_dscnt 0x0                                           // 0000000415F8: BFC60000
	v_max_num_f32_e32 v21, v21, v21                            // 0000000415FC: 2C2A2B15
	s_delay_alu instid0(VALU_DEP_1)                            // 000000041600: BF870001
	v_max_num_f32_e32 v17, v17, v21                            // 000000041604: 2C222B11
	ds_load_b32 v21, v68                                       // 000000041608: D8D80000 15000044
	ds_bpermute_b32 v24, v23, v17                              // 000000041610: DACC0000 18001117
	s_wait_dscnt 0x0                                           // 000000041618: BFC60000
	v_max3_num_f32 v17, v21, v17, v24                          // 00000004161C: D62A0011 04622315
	v_mov_b32_e32 v24, 0                                       // 000000041624: 7E300280
	s_and_saveexec_b32 s4, vcc_lo                              // 000000041628: BE84206A
	s_cbranch_execz 49                                         // 00000004162C: BFA50031 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x13f4>
	v_dual_mov_b32 v24, 0 :: v_dual_mov_b32 v25, v54           // 000000041630: CA100080 18180136
	s_mov_b32 s23, 0                                           // 000000041638: BE970080
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_4) | instid1(VALU_DEP_1)// 00000004163C: BF8700D1
	v_lshl_add_u32 v26, v25, 2, v67                            // 000000041640: D646001A 050D0519
	v_add_nc_u32_e32 v25, 32, v25                              // 000000041648: 4A3232A0
	ds_load_b32 v27, v26                                       // 00000004164C: D8D80000 1B00001A
	s_wait_dscnt 0x0                                           // 000000041654: BFC60000
	v_sub_f32_e32 v27, v27, v17                                // 000000041658: 0836231B
	v_mul_f32_e32 v28, 0x3fb8aa3b, v27                         // 00000004165C: 103836FF 3FB8AA3B
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)// 000000041664: BF8700A1
	v_fma_f32 v29, 0x3fb8aa3b, v27, -v28                       // 000000041668: D613001D 847236FF 3FB8AA3B
	v_rndne_f32_e32 v30, v28                                   // 000000041674: 7E3C471C
	v_sub_f32_e32 v28, v28, v30                                // 000000041678: 08383D1C
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2ce8ed0, v27                  // 00000004167C: 7C3636FF C2CE8ED0
	s_delay_alu instid0(VALU_DEP_4) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000041684: BF870094
	v_fmac_f32_e32 v29, 0x32a5705f, v27                        // 000000041688: 563A36FF 32A5705F
	v_add_f32_e32 v28, v28, v29                                // 000000041690: 06383B1C
	v_cvt_i32_f32_e32 v29, v30                                 // 000000041694: 7E3A111E
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(TRANS32_DEP_1)// 000000041698: BF870292
	v_exp_f32_e32 v28, v28                                     // 00000004169C: 7E384B1C
	v_ldexp_f32 v28, v28, v29                                  // 0000000416A0: D71C001C 02023B1C
	s_wait_alu depctr_va_vcc(0)                                // 0000000416A8: BF88FF9D
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_2) | instid1(VALU_DEP_2)// 0000000416AC: BF870131
	v_cndmask_b32_e32 v28, 0, v28, vcc_lo                      // 0000000416B0: 02383880
	v_cmp_nlt_f32_e32 vcc_lo, 0x42b17218, v27                  // 0000000416B4: 7C3C36FF 42B17218
	s_wait_alu depctr_va_vcc(0)                                // 0000000416BC: BF88FF9D
	v_cndmask_b32_e32 v27, 0x7f800000, v28, vcc_lo             // 0000000416C0: 023638FF 7F800000
	v_cmp_le_i32_e32 vcc_lo, s19, v25                          // 0000000416C8: 7C863213
	s_delay_alu instid0(VALU_DEP_2)                            // 0000000416CC: BF870002
	v_add_f32_e32 v24, v24, v27                                // 0000000416D0: 06303718
	s_wait_alu depctr_sa_sdst(0)                               // 0000000416D4: BF88FF9E
	s_or_b32 s23, vcc_lo, s23                                  // 0000000416D8: 8C17176A
	ds_store_b32 v26, v27                                      // 0000000416DC: D8340000 00001B1A
	s_wait_alu depctr_sa_sdst(0)                               // 0000000416E4: BF88FF9E
	s_and_not1_b32 exec_lo, exec_lo, s23                       // 0000000416E8: 917E177E
	s_cbranch_execnz 65491                                     // 0000000416EC: BFA6FFD3 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x133c>
	s_or_b32 exec_lo, exec_lo, s23                             // 0000000416F0: 8C7E177E
	s_wait_alu depctr_sa_sdst(0)                               // 0000000416F4: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 0000000416F8: 8C7E047E
	ds_bpermute_b32 v18, v18, v24                              // 0000000416FC: DACC0000 12001812
	s_wait_dscnt 0x0                                           // 000000041704: BFC60000
	v_add_f32_e32 v18, v24, v18                                // 000000041708: 06242518
	ds_bpermute_b32 v19, v19, v18                              // 00000004170C: DACC0000 13001213
	s_wait_dscnt 0x0                                           // 000000041714: BFC60000
	v_add_f32_e32 v18, v18, v19                                // 000000041718: 06242712
	ds_bpermute_b32 v19, v20, v18                              // 00000004171C: DACC0000 13001214
	s_wait_dscnt 0x0                                           // 000000041724: BFC60000
	v_add_f32_e32 v18, v18, v19                                // 000000041728: 06242712
	ds_bpermute_b32 v19, v22, v18                              // 00000004172C: DACC0000 13001216
	s_wait_dscnt 0x0                                           // 000000041734: BFC60000
	v_add_f32_e32 v18, v18, v19                                // 000000041738: 06242712
	ds_bpermute_b32 v19, v23, v18                              // 00000004173C: DACC0000 13001217
	s_and_b32 exec_lo, exec_lo, s2                             // 000000041744: 8B7E027E
	s_cbranch_execz 40                                         // 000000041748: BFA50028 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x14ec>
	v_sub_f32_e32 v20, v21, v17                                // 00000004174C: 08282315
	s_wait_dscnt 0x0                                           // 000000041750: BFC60000
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 000000041754: BF870121
	v_dual_add_f32 v18, v18, v19 :: v_dual_mul_f32 v21, 0x3fb8aa3b, v20// 000000041758: C9062712 121428FF 3FB8AA3B
	v_cmp_ngt_f32_e32 vcc_lo, 0xc2ce8ed0, v20                  // 000000041764: 7C3628FF C2CE8ED0
	v_fma_f32 v22, 0x3fb8aa3b, v20, -v21                       // 00000004176C: D6130016 845628FF 3FB8AA3B
	v_rndne_f32_e32 v23, v21                                   // 000000041778: 7E2E4715
	s_delay_alu instid0(VALU_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 00000004177C: BF870121
	v_dual_fmac_f32 v22, 0x32a5705f, v20 :: v_dual_sub_f32 v21, v21, v23// 000000041780: C80A28FF 16142F15 32A5705F
	v_cvt_i32_f32_e32 v23, v23                                 // 00000004178C: 7E2E1117
	v_add_f32_e32 v21, v21, v22                                // 000000041790: 062A2D15
	ds_load_b32 v22, v71                                       // 000000041794: D8D80000 16000047
	v_exp_f32_e32 v21, v21                                     // 00000004179C: 7E2A4B15
	s_delay_alu instid0(TRANS32_DEP_1) | instskip(SKIP_1) | instid1(VALU_DEP_1)// 0000000417A0: BF8700A5
	v_ldexp_f32 v21, v21, v23                                  // 0000000417A4: D71C0015 02022F15
	s_wait_alu depctr_va_vcc(0)                                // 0000000417AC: BF88FF9D
	v_cndmask_b32_e32 v21, 0, v21, vcc_lo                      // 0000000417B0: 022A2A80
	v_cmp_nlt_f32_e32 vcc_lo, 0x42b17218, v20                  // 0000000417B4: 7C3C28FF 42B17218
	s_wait_alu depctr_va_vcc(0)                                // 0000000417BC: BF88FF9D
	s_delay_alu instid0(VALU_DEP_2) | instskip(SKIP_1) | instid1(VALU_DEP_1)// 0000000417C0: BF8700A2
	v_cndmask_b32_e32 v19, 0x7f800000, v21, vcc_lo             // 0000000417C4: 02262AFF 7F800000
	s_wait_dscnt 0x0                                           // 0000000417CC: BFC60000
	v_fmac_f32_e32 v18, v19, v22                               // 0000000417D0: 56242D13
	ds_store_b32 v70, v19                                      // 0000000417D4: D8340000 00001346
	ds_store_b32 v71, v18                                      // 0000000417DC: D8340000 00001247
	ds_store_b32 v68, v17                                      // 0000000417E4: D8340000 00001144
	s_wait_alu depctr_sa_sdst(0)                               // 0000000417EC: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s24                             // 0000000417F0: 8C7E187E
	s_wait_loadcnt_dscnt 0x0                                   // 0000000417F4: BFC80000
	s_barrier_signal -1                                        // 0000000417F8: BE804EC1
	s_and_not1_b32 vcc_lo, exec_lo, s22                        // 0000000417FC: 916A167E
	s_barrier_wait 0xffff                                      // 000000041800: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 000000041804: EE0AC07C 00040000 00000000
	ds_load_b128 v[17:20], v36 offset:18944                    // 000000041810: DBFC4A00 11000024
	ds_load_b128 v[21:24], v36 offset:18960                    // 000000041818: DBFC4A10 15000024
	s_wait_dscnt 0x1                                           // 000000041820: BFC60001
	v_dual_mul_f32 v52, v52, v17 :: v_dual_mul_f32 v49, v49, v18// 000000041824: C8C62334 34302531
	v_dual_mul_f32 v51, v51, v17 :: v_dual_mul_f32 v50, v50, v18// 00000004182C: C8C62333 33322532
	v_dual_mul_f32 v48, v48, v19 :: v_dual_mul_f32 v45, v45, v20// 000000041834: C8C62730 302C292D
	v_dual_mul_f32 v47, v47, v19 :: v_dual_mul_f32 v46, v46, v20// 00000004183C: C8C6272F 2F2E292E
	s_wait_dscnt 0x0                                           // 000000041844: BFC60000
	v_dual_mul_f32 v44, v44, v21 :: v_dual_mul_f32 v39, v39, v22// 000000041848: C8C62B2C 2C262D27
	v_dual_mul_f32 v43, v43, v21 :: v_dual_mul_f32 v42, v42, v22// 000000041850: C8C62B2B 2B2A2D2A
	v_dual_mul_f32 v41, v41, v23 :: v_dual_mul_f32 v40, v40, v24// 000000041858: C8C62F29 29283128
	v_dual_mul_f32 v38, v38, v23 :: v_dual_mul_f32 v37, v37, v24// 000000041860: C8C62F26 26243125
	s_wait_alu depctr_sa_sdst(0)                               // 000000041868: BF88FF9E
	s_cbranch_vccnz 64571                                      // 00000004186C: BFA4FC3B <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x65c>
	s_mov_b32 s22, 0                                           // 000000041870: BE960080
	s_mov_b32 s23, 0                                           // 000000041874: BE970080
	s_branch 12                                                // 000000041878: BFA0000C <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x15ac>
	s_wait_loadcnt 0x0                                         // 00000004187C: BFC00000
	s_barrier_signal -1                                        // 000000041880: BE804EC1
	s_add_co_i32 s23, s23, 16                                  // 000000041884: 81179017
	s_add_co_i32 s21, s21, -16                                 // 000000041888: 8115D015
	s_add_co_i32 s22, s22, 64                                  // 00000004188C: 8116C016
	s_wait_alu depctr_sa_sdst(0)                               // 000000041890: BF88FF9E
	s_cmp_ge_i32 s23, s19                                      // 000000041894: BF031317
	s_barrier_wait 0xffff                                      // 000000041898: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 00000004189C: EE0AC07C 00040000 00000000
	s_cbranch_scc1 64556                                       // 0000000418A8: BFA2FC2C <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x65c>
	s_wait_alu depctr_sa_sdst(0)                               // 0000000418AC: BF88FF9E
	s_sub_co_i32 s24, s19, s23                                 // 0000000418B0: 81981713
	s_mov_b32 s25, exec_lo                                     // 0000000418B4: BE99007E
	s_wait_alu depctr_sa_sdst(0)                               // 0000000418B8: BF88FF9E
	s_min_i32 s4, s24, 16                                      // 0000000418BC: 89049018
	s_wait_alu depctr_sa_sdst(0)                               // 0000000418C0: BF88FF9E
	v_cmpx_gt_u32_e64 s4, v55                                  // 0000000418C4: D4CC007E 02026E04
	s_cbranch_execz 494                                        // 0000000418CC: BFA501EE <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1d88>
	v_add_nc_u32_e32 v17, s23, v55                             // 0000000418D0: 4A226E17
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000418D4: BF870001
	v_lshlrev_b32_e32 v18, 3, v17                              // 0000000418D8: 30242283
	v_add_nc_u32_e32 v17, s16, v17                             // 0000000418DC: 4A222210
	ds_load_b64 v[21:22], v18 offset:18432                     // 0000000418E0: D9D84800 15000012
	v_cmp_le_i32_e32 vcc_lo, s20, v17                          // 0000000418E8: 7C862214
	s_and_saveexec_b32 s4, vcc_lo                              // 0000000418EC: BE84206A
	s_wait_alu depctr_sa_sdst(0)                               // 0000000418F0: BF88FF9E
	s_xor_b32 s26, exec_lo, s4                                 // 0000000418F4: 8D1A047E
	s_cbranch_execz 448                                        // 0000000418F8: BFA501C0 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1cfc>
	s_wait_dscnt 0x0                                           // 0000000418FC: BFC60000
	v_add_co_u32 v17, vcc_lo, v21, v58                         // 000000041900: D7006A11 02027515
	s_wait_alu depctr_va_vcc(0)                                // 000000041908: BF88FF9D
	v_add_co_ci_u32_e64 v18, null, 0, v22, vcc_lo              // 00000004190C: D5207C12 01AA2C80
	v_add_co_u32 v19, vcc_lo, v21, v57                         // 000000041914: D7006A13 02027315
	s_wait_alu depctr_va_vcc(0)                                // 00000004191C: BF88FF9D
	v_add_co_ci_u32_e64 v20, null, 0, v22, vcc_lo              // 000000041920: D5207C14 01AA2C80
	flat_load_d16_i8 v24, v[17:18] offset:256                  // 000000041928: EC07C07C 00000018 00010011
	v_mov_b32_e32 v25, 0x7fc00000                              // 000000041934: 7E3202FF 7FC00000
	flat_load_b128 v[20:23], v[19:20]                          // 00000004193C: EC05C07C 00000014 00000013
	s_wait_loadcnt_dscnt 0x101                                 // 000000041948: BFC80101
	v_dual_mov_b32 v19, 0x7fc00000 :: v_dual_and_b32 v26, 7, v24// 00000004194C: CA2400FF 131A3087 7FC00000
	v_bfe_u32 v27, v24, 3, 4                                   // 000000041958: D610001B 02110718
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)// 000000041960: BF870112
	v_cmp_ne_u32_e64 s4, 7, v26                                // 000000041964: D44D0004 02023487
	v_cmp_ne_u32_e32 vcc_lo, 15, v27                           // 00000004196C: 7C9A368F
	s_or_b32 s27, s4, vcc_lo                                   // 000000041970: 8C1B6A04
	s_delay_alu instid0(SALU_CYCLE_1)                          // 000000041974: BF870009
	s_and_saveexec_b32 s4, s27                                 // 000000041978: BE84201B
	s_cbranch_execz 15                                         // 00000004197C: BFA5000F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x16bc>
	s_mov_b32 s27, exec_lo                                     // 000000041980: BE9B007E
	v_cmpx_ne_u32_e32 0, v27                                   // 000000041984: 7D9A3680
	s_xor_b32 s27, exec_lo, s27                                // 000000041988: 8D1B1B7E
	v_lshlrev_b32_e32 v25, 20, v26                             // 00000004198C: 30323494
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000041990: BF870091
	v_lshl_or_b32 v25, v27, 23, v25                            // 000000041994: D6560019 04652F1B
	v_add_nc_u32_e32 v25, 0x3c000000, v25                      // 00000004199C: 4A3232FF 3C000000
	s_and_not1_saveexec_b32 s27, s27                           // 0000000419A4: BE9B301B
	v_cvt_f32_ubyte0_e32 v25, v26                              // 0000000419A8: 7E32231A
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000419AC: BF870001
	v_mul_f32_e32 v25, 0x3b000000, v25                         // 0000000419B0: 103232FF 3B000000
	s_or_b32 exec_lo, exec_lo, s27                             // 0000000419B8: 8C7E1B7E
	s_wait_alu depctr_sa_sdst(0)                               // 0000000419BC: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 0000000419C0: 8C7E047E
	flat_load_d16_i8 v18, v[17:18] offset:257                  // 0000000419C4: EC07C07C 00000012 00010111
	s_wait_loadcnt_dscnt 0x0                                   // 0000000419D0: BFC80000
	v_bfe_u32 v26, v18, 3, 4                                   // 0000000419D4: D610001A 02110712
	v_and_b32_e32 v17, 7, v18                                  // 0000000419DC: 36222487
	s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)// 0000000419E0: BF870112
	v_cmp_ne_u32_e32 vcc_lo, 15, v26                           // 0000000419E4: 7C9A348F
	v_cmp_ne_u32_e64 s4, 7, v17                                // 0000000419E8: D44D0004 02022287
	s_or_b32 s27, s4, vcc_lo                                   // 0000000419F0: 8C1B6A04
	s_delay_alu instid0(SALU_CYCLE_1)                          // 0000000419F4: BF870009
	s_and_saveexec_b32 s4, s27                                 // 0000000419F8: BE84201B
	s_cbranch_execz 15                                         // 0000000419FC: BFA5000F <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x173c>
	s_mov_b32 s27, exec_lo                                     // 000000041A00: BE9B007E
	v_cmpx_ne_u32_e32 0, v26                                   // 000000041A04: 7D9A3480
	s_xor_b32 s27, exec_lo, s27                                // 000000041A08: 8D1B1B7E
	v_lshlrev_b32_e32 v17, 20, v17                             // 000000041A0C: 30222294
	s_delay_alu instid0(VALU_DEP_1) | instskip(NEXT) | instid1(VALU_DEP_1)// 000000041A10: BF870091
	v_lshl_or_b32 v17, v26, 23, v17                            // 000000041A14: D6560011 04452F1A
	v_add_nc_u32_e32 v19, 0x3c000000, v17                      // 000000041A1C: 4A2622FF 3C000000
	s_and_not1_saveexec_b32 s27, s27                           // 000000041A24: BE9B301B
	v_cvt_f32_ubyte0_e32 v17, v17                              // 000000041A28: 7E222311
	s_delay_alu instid0(VALU_DEP_1)                            // 000000041A2C: BF870001
	v_mul_f32_e32 v19, 0x3b000000, v17                         // 000000041A30: 102622FF 3B000000
	s_or_b32 exec_lo, exec_lo, s27                             // 000000041A38: 8C7E1B7E
	s_wait_alu depctr_sa_sdst(0)                               // 000000041A3C: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000041A40: 8C7E047E
	v_cmp_gt_i16_e32 vcc_lo, 0, v24.l                          // 000000041A44: 7C683080
	v_lshlrev_b32_e32 v17, 9, v20                              // 000000041A48: 30222889
	v_lshlrev_b32_e32 v28, 1, v20                              // 000000041A4C: 30382881
	v_lshlrev_b32_e32 v27, 8, v20                              // 000000041A50: 30362888
	v_mov_b16_e32 v35.h, 0                                     // 000000041A54: 7F463880
	s_wait_alu depctr_va_vcc(0)                                // 000000041A58: BF88FF9D
	v_cndmask_b32_e64 v24, v25, -v25, vcc_lo                   // 000000041A5C: D5010018 41AA3319
	v_cmp_gt_i16_e32 vcc_lo, 0, v18.l                          // 000000041A64: 7C682480
	v_lshlrev_b32_e32 v25, 5, v20                              // 000000041A68: 30322885
	v_and_b32_e32 v17, 0xe00, v17                              // 000000041A6C: 362222FF 00000E00
	v_lshlrev_b32_e32 v31, 8, v21                              // 000000041A74: 303E2A88
	v_dual_mul_f32 v29, 0x46800000, v24 :: v_dual_lshlrev_b32 v30, 9, v21// 000000041A78: C8E230FF 1D1E2A89 46800000
	s_wait_alu depctr_va_vcc(0)                                // 000000041A84: BF88FF9D
	v_cndmask_b32_e64 v19, v19, -v19, vcc_lo                   // 000000041A88: D5010013 41AA2713
	v_lshlrev_b32_e32 v26, 12, v20                             // 000000041A90: 3034288C
	v_and_b32_e32 v25, 0xe00, v25                              // 000000041A94: 363232FF 00000E00
	v_lshlrev_b32_e32 v24, 4, v20                              // 000000041A9C: 30302884
	v_and_b32_e32 v30, 0xe00, v30                              // 000000041AA0: 363C3CFF 00000E00
	v_mul_f32_e32 v19, 0x46800000, v19                         // 000000041AA8: 102626FF 46800000
	v_and_or_b32 v17, 0x8000, v26, v17                         // 000000041AB0: D6570011 044634FF 00008000
	v_and_b32_e32 v26, 0xe00, v28                              // 000000041ABC: 363438FF 00000E00
	v_and_or_b32 v25, 0x8000, v27, v25                         // 000000041AC4: D6570019 046636FF 00008000
	v_and_b32_e32 v27, 0x8000, v20                             // 000000041AD0: 363628FF 00008000
	v_lshrrev_b32_e32 v28, 3, v20                              // 000000041AD8: 32382883
	v_fma_mix_f32 v17, v17, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041ADC: CC200011 8A023B11
	v_and_or_b32 v24, 0x8000, v24, v26                         // 000000041AE4: D6570018 046A30FF 00008000
	v_fma_mix_f32 v25, v25, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041AF0: CC200019 8A023B19
	v_lshrrev_b32_e32 v32, 3, v21                              // 000000041AF8: 32402A83
	v_and_or_b32 v26, 0xe00, v28, v27                          // 000000041AFC: D657001A 046E38FF 00000E00
	v_mov_b16_e32 v35.l, v17.h                                 // 000000041B08: 7E463991
	v_fma_mix_f32 v24, v24, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041B0C: CC200018 8A023B18
	v_lshrrev_b32_e32 v28, 19, v20                             // 000000041B14: 32382893
	v_lshrrev_b32_e32 v27, 8, v20                              // 000000041B18: 32362888
	v_fma_mix_f32 v26, v26, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041B1C: CC20001A 8A023B1A
	v_and_or_b32 v17, 0xffff0000, v25, v35                     // 000000041B24: D6570011 048E32FF FFFF0000
	v_mov_b16_e32 v35.l, v24.h                                 // 000000041B30: 7E463998
	v_lshrrev_b32_e32 v24, 7, v20                              // 000000041B34: 32302887
	v_lshrrev_b32_e32 v25, 4, v20                              // 000000041B38: 32322884
	v_and_b32_e32 v28, 0xe00, v28                              // 000000041B3C: 363838FF 00000E00
	v_lshrrev_b32_e32 v33, 11, v21                             // 000000041B44: 32422A8B
	v_and_or_b32 v18, 0xffff0000, v26, v35                     // 000000041B48: D6570012 048E34FF FFFF0000
	v_and_b32_e32 v24, 0xe00, v24                              // 000000041B54: 363030FF 00000E00
	v_lshrrev_b32_e32 v26, 15, v20                             // 000000041B5C: 3234288F
	v_mov_b16_e32 v35.l, v20.h                                 // 000000041B60: 7E463994
	v_lshlrev_b32_e32 v79, 8, v22                              // 000000041B64: 309E2C88
	v_lshrrev_b32_e32 v80, 3, v22                              // 000000041B68: 32A02C83
	v_and_or_b32 v24, 0x8000, v25, v24                         // 000000041B6C: D6570018 046232FF 00008000
	v_lshrrev_b32_e32 v25, 11, v20                             // 000000041B78: 3232288B
	v_lshrrev_b32_e32 v20, 12, v20                             // 000000041B7C: 3228288C
	v_and_b32_e32 v26, 0xe00, v26                              // 000000041B80: 363434FF 00000E00
	v_lshrrev_b32_e32 v81, 11, v22                             // 000000041B88: 32A22C8B
	v_fma_mix_f32 v24, v24, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041B8C: CC200018 8A023B18
	v_and_b32_e32 v25, 0xe00, v25                              // 000000041B94: 363232FF 00000E00
	v_lshlrev_b32_e32 v82, 8, v23                              // 000000041B9C: 30A42E88
	v_and_or_b32 v20, 0x8000, v20, v26                         // 000000041BA0: D6570014 046A28FF 00008000
	v_and_or_b32 v26, 0x8000, v35, v28                         // 000000041BAC: D657001A 047246FF 00008000
	v_lshlrev_b32_e32 v28, 12, v21                             // 000000041BB8: 30382A8C
	v_and_or_b32 v25, 0x8000, v27, v25                         // 000000041BBC: D6570019 046636FF 00008000
	v_lshlrev_b32_e32 v27, 5, v21                              // 000000041BC8: 30362A85
	v_fma_mix_f32 v20, v20, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041BCC: CC200014 8A023B14
	v_fma_mix_f32 v26, v26, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041BD4: CC20001A 8A023B1A
	v_and_or_b32 v28, 0x8000, v28, v30                         // 000000041BDC: D657001C 047A38FF 00008000
	v_lshlrev_b32_e32 v30, 1, v21                              // 000000041BE8: 303C2A81
	v_and_b32_e32 v27, 0xe00, v27                              // 000000041BEC: 363636FF 00000E00
	v_mov_b16_e32 v35.l, v20.h                                 // 000000041BF4: 7E463994
	v_lshlrev_b32_e32 v20, 4, v21                              // 000000041BF8: 30282A84
	v_fma_mix_f32 v28, v28, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041BFC: CC20001C 8A023B1C
	v_and_b32_e32 v30, 0xe00, v30                              // 000000041C04: 363C3CFF 00000E00
	v_and_or_b32 v27, 0x8000, v31, v27                         // 000000041C0C: D657001B 046E3EFF 00008000
	v_and_b32_e32 v31, 0x8000, v21                             // 000000041C18: 363E2AFF 00008000
	v_mov_b16_e32 v34.l, v24.h                                 // 000000041C20: 7E443998
	v_and_b32_e32 v81, 0xe00, v81                              // 000000041C24: 36A2A2FF 00000E00
	v_and_or_b32 v30, 0x8000, v20, v30                         // 000000041C2C: D657001E 047A28FF 00008000
	v_and_or_b32 v20, 0xffff0000, v26, v35                     // 000000041C38: D6570014 048E34FF FFFF0000
	v_fma_mix_f32 v26, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041C44: CC20001A 8A023B1B
	v_mov_b16_e32 v35.l, v28.h                                 // 000000041C4C: 7E46399C
	v_and_or_b32 v27, 0xe00, v32, v31                          // 000000041C50: D657001B 047E40FF 00000E00
	v_fma_mix_f32 v28, v30, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041C5C: CC20001C 8A023B1E
	v_fma_mix_f32 v30, v25, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041C64: CC20001E 8A023B19
	v_lshrrev_b32_e32 v31, 15, v21                             // 000000041C6C: 323E2A8F
	v_and_or_b32 v24, 0xffff0000, v26, v35                     // 000000041C70: D6570018 048E34FF FFFF0000
	v_lshrrev_b32_e32 v26, 7, v21                              // 000000041C7C: 32342A87
	v_fma_mix_f32 v25, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041C80: CC200019 8A023B1B
	v_mov_b16_e32 v35.l, v28.h                                 // 000000041C88: 7E46399C
	v_lshrrev_b32_e32 v27, 4, v21                              // 000000041C8C: 32362A84
	v_lshrrev_b32_e32 v32, 19, v21                             // 000000041C90: 32402A93
	v_and_b32_e32 v26, 0xe00, v26                              // 000000041C94: 363434FF 00000E00
	v_lshrrev_b32_e32 v28, 8, v21                              // 000000041C9C: 32382A88
	v_and_or_b32 v25, 0xffff0000, v25, v35                     // 000000041CA0: D6570019 048E32FF FFFF0000
	v_mov_b16_e32 v35.l, v21.h                                 // 000000041CAC: 7E463995
	v_lshrrev_b32_e32 v21, 12, v21                             // 000000041CB0: 322A2A8C
	v_and_or_b32 v26, 0x8000, v27, v26                         // 000000041CB4: D657001A 046A36FF 00008000
	v_and_b32_e32 v27, 0xe00, v31                              // 000000041CC0: 36363EFF 00000E00
	v_and_b32_e32 v31, 0xe00, v32                              // 000000041CC8: 363E40FF 00000E00
	v_and_b32_e32 v32, 0xe00, v33                              // 000000041CD0: 364042FF 00000E00
	v_lshlrev_b32_e32 v33, 9, v22                              // 000000041CD8: 30422C89
	v_fma_mix_f32 v26, v26, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041CDC: CC20001A 8A023B1A
	v_and_or_b32 v21, 0x8000, v21, v27                         // 000000041CE4: D6570015 046E2AFF 00008000
	v_and_or_b32 v27, 0x8000, v35, v31                         // 000000041CF0: D657001B 047E46FF 00008000
	v_and_or_b32 v28, 0x8000, v28, v32                         // 000000041CFC: D657001C 048238FF 00008000
	v_lshlrev_b32_e32 v31, 12, v22                             // 000000041D08: 303E2C8C
	v_and_b32_e32 v32, 0xe00, v33                              // 000000041D0C: 364042FF 00000E00
	v_fma_mix_f32 v21, v21, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041D14: CC200015 8A023B15
	v_lshlrev_b32_e32 v33, 5, v22                              // 000000041D1C: 30422C85
	v_fma_mix_f32 v27, v27, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041D20: CC20001B 8A023B1B
	v_lshrrev_b32_e32 v84, 3, v23                              // 000000041D28: 32A82E83
	v_and_or_b32 v31, 0x8000, v31, v32                         // 000000041D2C: D657001F 04823EFF 00008000
	v_lshlrev_b32_e32 v32, 1, v22                              // 000000041D38: 30402C81
	v_and_b32_e32 v33, 0xe00, v33                              // 000000041D3C: 364242FF 00000E00
	v_mov_b16_e32 v35.l, v21.h                                 // 000000041D44: 7E463995
	v_lshlrev_b32_e32 v21, 4, v22                              // 000000041D48: 302A2C84
	v_fma_mix_f32 v31, v31, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041D4C: CC20001F 8A02271F
	v_and_b32_e32 v32, 0xe00, v32                              // 000000041D54: 364040FF 00000E00
	v_and_or_b32 v33, 0x8000, v79, v33                         // 000000041D5C: D6570021 04869EFF 00008000
	v_and_b32_e32 v79, 0x8000, v22                             // 000000041D68: 369E2CFF 00008000
	v_and_or_b32 v27, 0xffff0000, v27, v35                     // 000000041D70: D657001B 048E36FF FFFF0000
	v_mov_b16_e32 v35.l, v31.h                                 // 000000041D7C: 7E46399F
	v_and_or_b32 v21, 0x8000, v21, v32                         // 000000041D80: D6570015 04822AFF 00008000
	v_fma_mix_f32 v32, v33, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041D8C: CC200020 8A022721
	v_and_or_b32 v31, 0xe00, v80, v79                          // 000000041D94: D657001F 053EA0FF 00000E00
	v_fma_mix_f32 v79, v28, v29, neg(0) op_sel_hi:[1,0,0]      // 000000041DA0: CC20004F 8A023B1C
	v_lshrrev_b32_e32 v33, 7, v22                              // 000000041DA8: 32422C87
	v_fma_mix_f32 v21, v21, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041DAC: CC200015 8A022715
	v_mov_b16_e32 v21.l, v26.h                                 // 000000041DB4: 7E2A399A
	v_and_or_b32 v28, 0xffff0000, v32, v35                     // 000000041DB8: D657001C 048E40FF FFFF0000
	v_fma_mix_f32 v26, v31, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041DC4: CC20001A 8A02271F
	v_lshrrev_b32_e32 v31, 4, v22                              // 000000041DCC: 323E2C84
	v_mov_b16_e32 v35.l, v21.h                                 // 000000041DD0: 7E463995
	v_lshrrev_b32_e32 v80, 19, v22                             // 000000041DD4: 32A02C93
	v_and_b32_e32 v33, 0xe00, v33                              // 000000041DD8: 364242FF 00000E00
	v_lshrrev_b32_e32 v32, 8, v22                              // 000000041DE0: 32402C88
	v_lshrrev_b32_e32 v85, 12, v23                             // 000000041DE4: 32AA2E8C
	v_and_or_b32 v29, 0xffff0000, v26, v35                     // 000000041DE8: D657001D 048E34FF FFFF0000
	v_lshrrev_b32_e32 v26, 15, v22                             // 000000041DF4: 32342C8F
	v_mov_b16_e32 v35.l, v22.h                                 // 000000041DF8: 7E463996
	v_lshrrev_b32_e32 v22, 12, v22                             // 000000041DFC: 322C2C8C
	v_and_b32_e32 v80, 0xe00, v80                              // 000000041E00: 36A0A0FF 00000E00
	v_and_or_b32 v33, 0x8000, v31, v33                         // 000000041E08: D6570021 04863EFF 00008000
	v_and_b32_e32 v26, 0xe00, v26                              // 000000041E14: 363434FF 00000E00
	v_lshlrev_b32_e32 v31, 9, v23                              // 000000041E1C: 303E2E89
	v_and_or_b32 v32, 0x8000, v32, v81                         // 000000041E20: D6570020 054640FF 00008000
	v_lshlrev_b32_e32 v81, 5, v23                              // 000000041E2C: 30A22E85
	v_fma_mix_f32 v33, v33, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041E30: CC200021 8A022721
	v_and_or_b32 v22, 0x8000, v22, v26                         // 000000041E38: D6570016 046A2CFF 00008000
	v_and_or_b32 v26, 0x8000, v35, v80                         // 000000041E44: D657001A 054246FF 00008000
	v_lshlrev_b32_e32 v80, 12, v23                             // 000000041E50: 30A02E8C
	v_and_b32_e32 v31, 0xe00, v31                              // 000000041E54: 363E3EFF 00000E00
	v_and_b32_e32 v81, 0xe00, v81                              // 000000041E5C: 36A2A2FF 00000E00
	v_fma_mix_f32 v22, v22, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041E64: CC200016 8A022716
	v_fma_mix_f32 v26, v26, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041E6C: CC20001A 8A02271A
	v_lshrrev_b32_e32 v86, 19, v23                             // 000000041E74: 32AC2E93
	v_and_or_b32 v31, 0x8000, v80, v31                         // 000000041E78: D657001F 047EA0FF 00008000
	v_lshlrev_b32_e32 v80, 1, v23                              // 000000041E84: 30A02E81
	v_mov_b16_e32 v35.l, v22.h                                 // 000000041E88: 7E463996
	v_lshlrev_b32_e32 v22, 4, v23                              // 000000041E8C: 302C2E84
	v_and_or_b32 v81, 0x8000, v82, v81                         // 000000041E90: D6570051 0546A4FF 00008000
	v_fma_mix_f32 v83, v31, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041E9C: CC200053 8A02271F
	v_and_b32_e32 v80, 0xe00, v80                              // 000000041EA4: 36A0A0FF 00000E00
	v_and_b32_e32 v82, 0x8000, v23                             // 000000041EAC: 36A42EFF 00008000
	v_and_or_b32 v31, 0xffff0000, v26, v35                     // 000000041EB4: D657001F 048E34FF FFFF0000
	v_fma_mix_f32 v26, v81, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041EC0: CC20001A 8A022751
	v_mov_b16_e32 v35.l, v83.h                                 // 000000041EC8: 7E4639D3
	v_and_or_b32 v22, 0x8000, v22, v80                         // 000000041ECC: D6570016 05422CFF 00008000
	v_and_or_b32 v80, 0xe00, v84, v82                          // 000000041ED8: D6570050 054AA8FF 00000E00
	v_fma_mix_f32 v81, v32, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041EE4: CC200051 8A022720
	v_lshrrev_b32_e32 v82, 7, v23                              // 000000041EEC: 32A42E87
	v_and_or_b32 v32, 0xffff0000, v26, v35                     // 000000041EF0: D6570020 048E34FF FFFF0000
	v_fma_mix_f32 v22, v22, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041EFC: CC200016 8A022716
	v_fma_mix_f32 v26, v80, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041F04: CC20001A 8A022750
	v_mov_b16_e32 v22.l, v33.h                                 // 000000041F0C: 7E2C39A1
	v_lshrrev_b32_e32 v80, 4, v23                              // 000000041F10: 32A02E84
	v_lshrrev_b32_e32 v84, 11, v23                             // 000000041F14: 32A82E8B
	v_mov_b16_e32 v35.l, v22.h                                 // 000000041F18: 7E463996
	v_and_b32_e32 v82, 0xe00, v82                              // 000000041F1C: 36A4A4FF 00000E00
	v_lshrrev_b32_e32 v83, 8, v23                              // 000000041F24: 32A62E88
	v_mov_b16_e32 v34.h, v35.h                                 // 000000041F28: 7F4439A3
	v_and_b32_e32 v84, 0xe00, v84                              // 000000041F2C: 36A8A8FF 00000E00
	v_and_or_b32 v33, 0xffff0000, v26, v35                     // 000000041F34: D6570021 048E34FF FFFF0000
	v_lshrrev_b32_e32 v26, 15, v23                             // 000000041F40: 32342E8F
	v_and_or_b32 v80, 0x8000, v80, v82                         // 000000041F44: D6570050 054AA0FF 00008000
	v_mov_b16_e32 v35.l, v23.h                                 // 000000041F50: 7E463997
	v_and_b32_e32 v23, 0xe00, v86                              // 000000041F54: 362EACFF 00000E00
	v_and_or_b32 v82, 0x8000, v83, v84                         // 000000041F5C: D6570052 0552A6FF 00008000
	v_and_b32_e32 v26, 0xe00, v26                              // 000000041F68: 363434FF 00000E00
	v_fma_mix_f32 v80, v80, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041F70: CC200050 8A022750
	v_mov_b16_e32 v21.h, v35.h                                 // 000000041F78: 7F2A39A3
	v_and_or_b32 v23, 0x8000, v35, v23                         // 000000041F7C: D6570017 045E46FF 00008000
	v_mov_b16_e32 v22.h, v35.h                                 // 000000041F88: 7F2C39A3
	v_and_or_b32 v26, 0x8000, v85, v26                         // 000000041F8C: D657001A 046AAAFF 00008000
	v_fma_mix_f32 v82, v82, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041F98: CC200052 8A022752
	v_mov_b16_e32 v80.l, v80.h                                 // 000000041FA0: 7EA039D0
	v_mov_b16_e32 v80.h, v35.h                                 // 000000041FA4: 7FA039A3
	v_fma_mix_f32 v23, v23, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041FA8: CC200017 8A022717
	v_fma_mix_f32 v26, v26, v19, neg(0) op_sel_hi:[1,0,0]      // 000000041FB0: CC20001A 8A02271A
	v_and_or_b32 v19, 0xffff0000, v30, v34                     // 000000041FB8: D6570013 048A3CFF FFFF0000
	v_and_or_b32 v30, 0xffff0000, v81, v22                     // 000000041FC4: D657001E 045AA2FF FFFF0000
	v_and_or_b32 v34, 0xffff0000, v82, v80                     // 000000041FD0: D6570022 0542A4FF FFFF0000
	s_delay_alu instid0(VALU_DEP_4) | instskip(SKIP_1) | instid1(VALU_DEP_2)// 000000041FDC: BF870124
	v_mov_b16_e32 v35.l, v26.h                                 // 000000041FE0: 7E46399A
	v_and_or_b32 v26, 0xffff0000, v79, v21                     // 000000041FE4: D657001A 04569EFF FFFF0000
	v_and_or_b32 v35, 0xffff0000, v23, v35                     // 000000041FF0: D6570023 048E2EFF FFFF0000
	s_and_not1_saveexec_b32 s4, s26                            // 000000041FFC: BE84301A
	s_cbranch_execz 19                                         // 000000042000: BFA50013 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1d50>
	s_wait_dscnt 0x0                                           // 000000042004: BFC60000
	v_add_co_u32 v21, vcc_lo, v21, v59                         // 000000042008: D7006A15 02027715
	s_wait_alu depctr_va_vcc(0)                                // 000000042010: BF88FF9D
	v_add_co_ci_u32_e64 v22, null, 0, v22, vcc_lo              // 000000042014: D5207C16 01AA2C80
	s_clause 0x3                                               // 00000004201C: BF850003
	flat_load_b128 v[17:20], v[21:22]                          // 000000042020: EC05C07C 00000011 00000015
	flat_load_b128 v[24:27], v[21:22] offset:16                // 00000004202C: EC05C07C 00000018 00001015
	flat_load_b128 v[28:31], v[21:22] offset:32                // 000000042038: EC05C07C 0000001C 00002015
	flat_load_b128 v[32:35], v[21:22] offset:48                // 000000042044: EC05C07C 00000020 00003015
	s_wait_alu depctr_sa_sdst(0)                               // 000000042050: BF88FF9E
	s_or_b32 exec_lo, exec_lo, s4                              // 000000042054: 8C7E047E
	s_wait_loadcnt_dscnt 0x303                                 // 000000042058: BFC80303
	ds_store_b128 v60, v[17:20]                                // 00000004205C: DB7C0000 0000113C
	s_wait_loadcnt_dscnt 0x203                                 // 000000042064: BFC80203
	ds_store_b128 v61, v[24:27]                                // 000000042068: DB7C0000 0000183D
	s_wait_loadcnt_dscnt 0x103                                 // 000000042070: BFC80103
	ds_store_b128 v62, v[28:31]                                // 000000042074: DB7C0000 00001C3E
	s_wait_loadcnt_dscnt 0x3                                   // 00000004207C: BFC80003
	ds_store_b128 v63, v[32:35]                                // 000000042080: DB7C0000 0000203F
	s_or_b32 exec_lo, exec_lo, s25                             // 000000042088: 8C7E197E
	s_wait_loadcnt_dscnt 0x0                                   // 00000004208C: BFC80000
	s_barrier_signal -1                                        // 000000042090: BE804EC1
	s_cmp_lt_i32 s24, 1                                        // 000000042094: BF048118
	s_barrier_wait 0xffff                                      // 000000042098: BF94FFFF
	global_inv scope:SCOPE_SE                                  // 00000004209C: EE0AC07C 00040000 00000000
	s_cbranch_scc1 65012                                       // 0000000420A8: BFA2FDF4 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x157c>
	v_med3_i32 v17, s21, 1, 16                                 // 0000000420AC: D6200011 02410215
	s_mov_b32 s24, s22                                         // 0000000420B4: BE980016
	s_delay_alu instid0(VALU_DEP_1)                            // 0000000420B8: BF870001
	v_readfirstlane_b32 s4, v17                                // 0000000420BC: 7E080511
	v_mov_b32_e32 v17, v72                                     // 0000000420C0: 7E220348
	s_lshl_b32 s4, s4, 10                                      // 0000000420C4: 84048A04
	ds_load_b32 v26, v17                                       // 0000000420C8: D8D80000 1A000011
	s_wait_alu depctr_sa_sdst(0)                               // 0000000420D0: BF88FF9E
	v_dual_mov_b32 v24, s24 :: v_dual_add_nc_u32 v17, 0x400, v17// 0000000420D4: CA200018 181022FF 00000400
	s_addk_co_i32 s4, 0xfc00                                   // 0000000420E0: B784FC00
	s_add_co_i32 s24, s24, 4                                   // 0000000420E4: 81188418
	ds_load_2addr_stride64_b32 v[18:19], v24 offset0:64 offset1:65// 0000000420E8: D8E04140 12000018
	ds_load_2addr_stride64_b32 v[20:21], v24 offset0:66 offset1:67// 0000000420F0: D8E04342 14000018
	ds_load_2addr_stride64_b32 v[22:23], v24 offset0:68 offset1:69// 0000000420F8: D8E04544 16000018
	ds_load_2addr_stride64_b32 v[24:25], v24 offset0:70 offset1:71// 000000042100: D8E04746 18000018
	s_wait_alu depctr_sa_sdst(0)                               // 000000042108: BF88FF9E
	s_cmp_eq_u32 s4, 0                                         // 00000004210C: BF068004
	s_wait_dscnt 0x4                                           // 000000042110: BFC60004
	v_lshlrev_b32_e32 v27, 16, v26                             // 000000042114: 30363490
	v_and_b32_e32 v26, 0xffff0000, v26                         // 000000042118: 363434FF FFFF0000
	s_wait_dscnt 0x3                                           // 000000042120: BFC60003
	s_delay_alu instid0(VALU_DEP_2)                            // 000000042124: BF870002
	v_fmac_f32_e32 v50, v19, v27                               // 000000042128: 56643713
	s_wait_dscnt 0x2                                           // 00000004212C: BFC60002
	v_fmac_f32_e32 v46, v21, v27                               // 000000042130: 565C3715
	s_wait_dscnt 0x1                                           // 000000042134: BFC60001
	v_fmac_f32_e32 v42, v23, v27                               // 000000042138: 56543717
	s_wait_dscnt 0x0                                           // 00000004213C: BFC60000
	v_fmac_f32_e32 v41, v24, v27                               // 000000042140: 56523718
	v_dual_fmac_f32 v52, v18, v27 :: v_dual_fmac_f32 v49, v19, v26// 000000042144: C8003712 34303513
	v_dual_fmac_f32 v51, v18, v26 :: v_dual_fmac_f32 v48, v20, v27// 00000004214C: C8003512 33303714
	v_fmac_f32_e32 v45, v21, v26                               // 000000042154: 565A3515
	v_dual_fmac_f32 v47, v20, v26 :: v_dual_fmac_f32 v44, v22, v27// 000000042158: C8003514 2F2C3716
	v_fmac_f32_e32 v39, v23, v26                               // 000000042160: 564E3517
	v_fmac_f32_e32 v43, v22, v26                               // 000000042164: 56563516
	v_fmac_f32_e32 v38, v24, v26                               // 000000042168: 564C3518
	v_fmac_f32_e32 v40, v25, v27                               // 00000004216C: 56503719
	v_fmac_f32_e32 v37, v25, v26                               // 000000042170: 564A3519
	s_cbranch_scc0 65492                                       // 000000042174: BFA1FFD4 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x1dc8>
	s_branch 64960                                             // 000000042178: BFA0FDC0 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x157c>
	s_load_b64 s[2:3], s[0:1], 0x108                           // 00000004217C: F4002080 F8000108
	v_mov_b32_e32 v0, 0                                        // 000000042184: 7E000280
	s_lshl_b64 s[4:5], s[14:15], 2                             // 000000042188: 8484820E
	s_load_b64 s[0:1], s[0:1], 0x118                           // 00000004218C: F4002000 F8000118
	v_lshlrev_b32_e32 v24, 2, v53                              // 000000042194: 30306A82
	s_wait_loadcnt 0x0                                         // 000000042198: BFC00000
	ds_load_b128 v[16:19], v0 offset:19008                     // 00000004219C: DBFC4A40 10000000
	ds_load_b128 v[20:23], v0 offset:19024                     // 0000000421A4: DBFC4A50 14000000
	s_wait_kmcnt 0x0                                           // 0000000421AC: BFC70000
	s_add_nc_u64 s[2:3], s[2:3], s[4:5]                        // 0000000421B0: A9820402
	s_clause 0x1                                               // 0000000421B4: BF850001
	global_load_b128 v[8:11], v0, s[2:3] offset:16             // 0000000421B8: EE05C002 00000008 00001000
	global_load_b128 v[12:15], v0, s[2:3]                      // 0000000421C4: EE05C002 0000000C 00000000
	v_add_co_u32 v24, s0, s0, v24                              // 0000000421D0: D7000018 02023000
	s_wait_alu depctr_va_sdst(0)                               // 0000000421D8: BF88F19F
	v_add_co_ci_u32_e64 v25, null, s1, 0, s0                   // 0000000421DC: D5207C19 00010001
	s_wait_dscnt 0x1                                           // 0000000421E4: BFC60001
	v_readfirstlane_b32 s0, v16                                // 0000000421E8: 7E000510
	v_readfirstlane_b32 s1, v17                                // 0000000421EC: 7E020511
	v_readfirstlane_b32 s3, v19                                // 0000000421F0: 7E060513
	ds_load_b128 v[4:7], v0 offset:18976                       // 0000000421F4: DBFC4A20 04000000
	ds_load_b128 v[0:3], v0 offset:18992                       // 0000000421FC: DBFC4A30 00000000
	v_readfirstlane_b32 s2, v18                                // 000000042204: 7E040512
	s_wait_dscnt 0x2                                           // 000000042208: BFC60002
	v_readfirstlane_b32 s6, v21                                // 00000004220C: 7E0C0515
	v_readfirstlane_b32 s7, v22                                // 000000042210: 7E0E0516
	v_readfirstlane_b32 s5, v20                                // 000000042214: 7E0A0514
	v_readfirstlane_b32 s9, v23                                // 000000042218: 7E120517
	s_wait_loadcnt 0x1                                         // 00000004221C: BFC00001
	v_readfirstlane_b32 s17, v8                                // 000000042220: 7E220508
	s_wait_loadcnt 0x0                                         // 000000042224: BFC00000
	v_readfirstlane_b32 s4, v12                                // 000000042228: 7E08050C
	v_readfirstlane_b32 s8, v13                                // 00000004222C: 7E10050D
	v_readfirstlane_b32 s16, v15                               // 000000042230: 7E20050F
	v_readfirstlane_b32 s15, v14                               // 000000042234: 7E1E050E
	v_readfirstlane_b32 s11, v10                               // 000000042238: 7E16050A
	s_sub_f32 s18, s4, s0                                      // 00000004223C: A0920004
	s_sub_f32 s0, s8, s1                                       // 000000042240: A0800108
	s_sub_f32 s8, s16, s3                                      // 000000042244: A0880310
	s_sub_f32 s4, s15, s2                                      // 000000042248: A084020F
	s_wait_alu depctr_sa_sdst(0)                               // 00000004224C: BF88FF9E
	s_mul_f32 s1, s18, 0x3fb8aa3b                              // 000000042250: A201FF12 3FB8AA3B
	s_mul_f32 s2, s0, 0x3fb8aa3b                               // 000000042258: A202FF00 3FB8AA3B
	v_readfirstlane_b32 s14, v9                                // 000000042260: 7E1C0509
	s_sub_f32 s7, s11, s7                                      // 000000042264: A087070B
	s_wait_alu depctr_sa_sdst(0)                               // 000000042268: BF88FF9E
	s_xor_b32 s3, s1, 0x80000000                               // 00000004226C: 8D03FF01 80000000
	s_rndne_f32 s16, s1                                        // 000000042274: BE906301
	s_fmamk_f32 s3, s18, 0x3fb8aa3b, s3                        // 000000042278: A3030312 3FB8AA3B
	s_cmp_nlt_f32 s18, 0xc2ce8ed0                              // 000000042280: BF4EFF12 C2CE8ED0
	s_rndne_f32 s20, s2                                        // 000000042288: BE946302
	s_wait_alu depctr_sa_sdst(0)                               // 00000004228C: BF88FF9E
	s_sub_f32 s1, s1, s16                                      // 000000042290: A0811001
	s_fmamk_f32 s3, s18, 0x32a5705f, s3                        // 000000042294: A3030312 32A5705F
	s_cvt_i32_f32 s16, s16                                     // 00000004229C: BE906610
	s_cselect_b32 vcc_lo, -1, 0                                // 0000000422A0: 986A80C1
	s_cmp_ngt_f32 s18, 0x42b17218                              // 0000000422A4: BF4BFF12 42B17218
	s_wait_alu depctr_sa_sdst(0)                               // 0000000422AC: BF88FF9E
	s_add_f32 s1, s1, s3                                       // 0000000422B0: A0010301
	s_sub_f32 s26, s2, s20                                     // 0000000422B4: A09A1402
	s_sub_f32 s6, s14, s6                                      // 0000000422B8: A086060E
	s_mul_f32 s11, s4, 0x3fb8aa3b                              // 0000000422BC: A20BFF04 3FB8AA3B
	s_wait_alu depctr_sa_sdst(0)                               // 0000000422C4: BF88FF9E
	v_s_exp_f32 s1, s1                                         // 0000000422C8: D6800001 02010001
	s_mul_f32 s14, s8, 0x3fb8aa3b                              // 0000000422D0: A20EFF08 3FB8AA3B
	v_readfirstlane_b32 s10, v11                               // 0000000422D8: 7E14050B
	s_rndne_f32 s21, s11                                       // 0000000422DC: BE95630B
	s_cvt_i32_f32 s20, s20                                     // 0000000422E0: BE946614
	s_rndne_f32 s3, s14                                        // 0000000422E4: BE83630E
	s_sub_f32 s5, s17, s5                                      // 0000000422E8: A0850511
	s_wait_alu depctr_sa_sdst(0)                               // 0000000422EC: BF88FF9E
	s_sub_f32 s27, s11, s21                                    // 0000000422F0: A09B150B
	v_ldexp_f32 v8, s1, s16                                    // 0000000422F4: D71C0008 02002001
	s_cvt_i32_f32 s16, s21                                     // 0000000422FC: BE906615
	s_sub_f32 s18, s14, s3                                     // 000000042300: A092030E
	s_cvt_i32_f32 s21, s3                                      // 000000042304: BE956603
	s_mul_f32 s15, s5, 0x3fb8aa3b                              // 000000042308: A20FFF05 3FB8AA3B
	v_cndmask_b32_e32 v8, 0, v8, vcc_lo                        // 000000042310: 02101080
	s_cselect_b32 vcc_lo, -1, 0                                // 000000042314: 986A80C1
	s_xor_b32 s1, s2, 0x80000000                               // 000000042318: 8D01FF02 80000000
	s_lshl_b64 s[2:3], s[12:13], 11                            // 000000042320: 84828B0C
	s_wait_alu depctr_sa_sdst(0)                               // 000000042324: BF88FF9E
	s_fmamk_f32 s1, s0, 0x3fb8aa3b, s1                         // 000000042328: A3010100 3FB8AA3B
	v_cndmask_b32_e32 v8, 0x7f800000, v8, vcc_lo               // 000000042330: 021010FF 7F800000
	s_cmp_nlt_f32 s0, 0xc2ce8ed0                               // 000000042338: BF4EFF00 C2CE8ED0
	s_rndne_f32 s22, s15                                       // 000000042340: BE96630F
	s_wait_alu depctr_sa_sdst(0)                               // 000000042344: BF88FF9E
	s_fmamk_f32 s1, s0, 0x32a5705f, s1                         // 000000042348: A3010100 32A5705F
	s_mul_f32 s17, s6, 0x3fb8aa3b                              // 000000042350: A211FF06 3FB8AA3B
	s_wait_dscnt 0x1                                           // 000000042358: BFC60001
	v_add_f32_e32 v10, v4, v8                                  // 00000004235C: 06141104
	s_cselect_b32 vcc_lo, -1, 0                                // 000000042360: 986A80C1
	s_wait_alu depctr_sa_sdst(0)                               // 000000042364: BF88FF9E
	s_add_f32 s1, s26, s1                                      // 000000042368: A001011A
	s_cmp_ngt_f32 s0, 0x42b17218                               // 00000004236C: BF4BFF00 42B17218
	v_add_co_u32 v8, s0, v24, s2                               // 000000042374: D7000008 02000518
	v_div_scale_f32 v4, null, v10, v10, v52                    // 00000004237C: D6FC7C04 04D2150A
	s_wait_alu depctr_sa_sdst(0)                               // 000000042384: BF88FF9E
	v_s_exp_f32 s1, s1                                         // 000000042388: D6800001 02010001
	v_div_scale_f32 v11, null, v10, v10, v51                   // 000000042390: D6FC7C0B 04CE150A
	s_wait_alu depctr_va_sdst(0)                               // 000000042398: BF88F19F
	v_add_co_ci_u32_e64 v9, null, s3, v25, s0                  // 00000004239C: D5207C09 00023203
	v_rcp_f32_e32 v12, v4                                      // 0000000423A4: 7E185504
	v_div_scale_f32 v15, s0, v52, v10, v52                     // 0000000423A8: D6FC000F 04D21534
	v_rcp_f32_e32 v13, v11                                     // 0000000423B0: 7E1A550B
	s_sub_f32 s28, s15, s22                                    // 0000000423B4: A09C160F
	v_ldexp_f32 v14, s1, s20                                   // 0000000423B8: D71C000E 02002801
	s_cvt_i32_f32 s22, s22                                     // 0000000423C0: BE966616
	s_rndne_f32 s23, s17                                       // 0000000423C4: BE976311
	s_mul_f32 s19, s7, 0x3fb8aa3b                              // 0000000423C8: A213FF07 3FB8AA3B
	s_sub_f32 s9, s10, s9                                      // 0000000423D0: A089090A
	v_fma_f32 v16, -v4, v12, 1.0                               // 0000000423D4: D6130010 23CA1904
	s_wait_alu depctr_sa_sdst(0)                               // 0000000423DC: BF88FF9E
	s_sub_f32 s29, s17, s23                                    // 0000000423E0: A09D1711
	v_fma_f32 v17, -v11, v13, 1.0                              // 0000000423E4: D6130011 23CA1B0B
	s_cvt_i32_f32 s23, s23                                     // 0000000423EC: BE976617
	s_rndne_f32 s24, s19                                       // 0000000423F0: BE986313
	v_fmac_f32_e32 v12, v16, v12                               // 0000000423F4: 56181910
	v_cndmask_b32_e32 v14, 0, v14, vcc_lo                      // 0000000423F8: 021C1C80
	s_cselect_b32 vcc_lo, -1, 0                                // 0000000423FC: 986A80C1
	s_xor_b32 s1, s11, 0x80000000                              // 000000042400: 8D01FF0B 80000000
	v_fmac_f32_e32 v13, v17, v13                               // 000000042408: 561A1B11
	s_wait_alu depctr_sa_sdst(0)                               // 00000004240C: BF88FF9E
	s_fmamk_f32 s2, s4, 0x3fb8aa3b, s1                         // 000000042410: A3020104 3FB8AA3B
	v_cndmask_b32_e32 v14, 0x7f800000, v14, vcc_lo             // 000000042418: 021C1CFF 7F800000
	v_div_scale_f32 v18, s1, v51, v10, v51                     // 000000042420: D6FC0112 04CE1533
	s_cmp_nlt_f32 s4, 0xc2ce8ed0                               // 000000042428: BF4EFF04 C2CE8ED0
	s_wait_alu depctr_sa_sdst(0)                               // 000000042430: BF88FF9E
	s_fmamk_f32 s2, s4, 0x32a5705f, s2                         // 000000042434: A3020204 32A5705F
	s_sub_f32 s26, s19, s24                                    // 00000004243C: A09A1813
	v_dual_add_f32 v14, v5, v14 :: v_dual_mul_f32 v5, v15, v12 // 000000042440: C9061D05 0E04190F
	s_wait_alu depctr_sa_sdst(0)                               // 000000042448: BF88FF9E
	s_add_f32 s2, s27, s2                                      // 00000004244C: A002021B
	v_mul_f32_e32 v16, v18, v13                                // 000000042450: 10201B12
	s_cselect_b32 vcc_lo, -1, 0                                // 000000042454: 986A80C1
	v_div_scale_f32 v17, null, v14, v14, v50                   // 000000042458: D6FC7C11 04CA1D0E
	s_wait_alu depctr_sa_sdst(0)                               // 000000042460: BF88FF9E
	v_s_exp_f32 s11, s2                                        // 000000042464: D680000B 02010002
	v_div_scale_f32 v20, null, v14, v14, v49                   // 00000004246C: D6FC7C14 04C61D0E
	v_fma_f32 v21, -v4, v5, v15                                // 000000042474: D6130015 243E0B04
	v_fma_f32 v22, -v11, v16, v18                              // 00000004247C: D6130016 244A210B
	v_rcp_f32_e32 v24, v17                                     // 000000042484: 7E305511
	s_cmp_ngt_f32 s4, 0x42b17218                               // 000000042488: BF4BFF04 42B17218
	v_rcp_f32_e32 v25, v20                                     // 000000042490: 7E325514
	v_fmac_f32_e32 v5, v21, v12                                // 000000042494: 560A1915
	v_ldexp_f32 v21, s11, s16                                  // 000000042498: D71C0015 0200200B
	v_fmac_f32_e32 v16, v22, v13                               // 0000000424A0: 56201B16
	s_cselect_b32 s4, -1, 0                                    // 0000000424A4: 980480C1
	s_xor_b32 s11, s14, 0x80000000                             // 0000000424A8: 8D0BFF0E 80000000
	v_fma_f32 v4, -v4, v5, v15                                 // 0000000424B0: D6130004 243E0B04
	v_cndmask_b32_e32 v15, 0, v21, vcc_lo                      // 0000000424B8: 021E2A80
	v_fma_f32 v11, -v11, v16, v18                              // 0000000424BC: D613000B 244A210B
	v_fma_f32 v18, -v17, v24, 1.0                              // 0000000424C4: D6130012 23CA3111
	s_wait_alu depctr_sa_sdst(0)                               // 0000000424CC: BF88FF9E
	s_fmamk_f32 s11, s8, 0x3fb8aa3b, s11                       // 0000000424D0: A30B0B08 3FB8AA3B
	s_mov_b32 vcc_lo, s0                                       // 0000000424D8: BEEA0000
	v_fma_f32 v21, -v20, v25, 1.0                              // 0000000424DC: D6130015 23CA3314
	s_wait_alu depctr_sa_sdst(0)                               // 0000000424E4: BF88FF9E
	v_div_fmas_f32 v4, v4, v12, v5                             // 0000000424E8: D6370004 04161904
	v_cndmask_b32_e64 v5, 0x7f800000, v15, s4                  // 0000000424F0: D5010005 00121EFF 7F800000
	s_fmamk_f32 s0, s8, 0x32a5705f, s11                        // 0000000424FC: A3000B08 32A5705F
	v_div_scale_f32 v19, s2, v50, v14, v50                     // 000000042504: D6FC0213 04CA1D32
	v_fmac_f32_e32 v24, v18, v24                               // 00000004250C: 56303112
	s_mov_b32 vcc_lo, s1                                       // 000000042510: BEEA0001
	v_div_scale_f32 v23, s3, v49, v14, v49                     // 000000042514: D6FC0317 04C61D31
	s_wait_alu depctr_sa_sdst(0)                               // 00000004251C: BF88FF9E
	v_div_fmas_f32 v11, v11, v13, v16                          // 000000042520: D637000B 04421B0B
	v_fmac_f32_e32 v25, v21, v25                               // 000000042528: 56323315
	s_add_f32 s0, s18, s0                                      // 00000004252C: A0000012
	v_add_f32_e32 v12, v6, v5                                  // 000000042530: 06180B06
	v_mul_f32_e32 v6, v19, v24                                 // 000000042534: 100C3113
	v_div_fixup_f32 v4, v4, v10, v52                           // 000000042538: D6270004 04D21504
	s_wait_alu depctr_sa_sdst(0)                               // 000000042540: BF88FF9E
	v_s_exp_f32 s4, s0                                         // 000000042544: D6800004 02010000
	v_div_fixup_f32 v5, v11, v10, v51                          // 00000004254C: D6270005 04CE150B
	v_mul_f32_e32 v10, v23, v25                                // 000000042554: 10143317
	v_div_scale_f32 v11, null, v12, v12, v48                   // 000000042558: D6FC7C0B 04C2190C
	v_div_scale_f32 v15, null, v12, v12, v47                   // 000000042560: D6FC7C0F 04BE190C
	v_fma_f32 v16, -v17, v6, v19                               // 000000042568: D6130010 244E0D11
	s_cmp_nlt_f32 s8, 0xc2ce8ed0                               // 000000042570: BF4EFF08 C2CE8ED0
	v_fma_f32 v18, -v20, v10, v23                              // 000000042578: D6130012 245E1514
	v_rcp_f32_e32 v22, v11                                     // 000000042580: 7E2C550B
	v_rcp_f32_e32 v26, v15                                     // 000000042584: 7E34550F
	v_fmac_f32_e32 v6, v16, v24                                // 000000042588: 560C3110
	v_ldexp_f32 v16, s4, s21                                   // 00000004258C: D71C0010 02002A04
	v_fmac_f32_e32 v10, v18, v25                               // 000000042594: 56143312
	s_cselect_b32 vcc_lo, -1, 0                                // 000000042598: 986A80C1
	s_cmp_ngt_f32 s8, 0x42b17218                               // 00000004259C: BF4BFF08 42B17218
	v_fma_f32 v17, -v17, v6, v19                               // 0000000425A4: D6130011 244E0D11
	s_wait_alu depctr_sa_sdst(0)                               // 0000000425AC: BF88FF9E
	v_cndmask_b32_e32 v16, 0, v16, vcc_lo                      // 0000000425B0: 02202080
	v_fma_f32 v18, -v20, v10, v23                              // 0000000425B4: D6130012 245E1514
	s_cselect_b32 s4, -1, 0                                    // 0000000425BC: 980480C1
	s_xor_b32 s8, s15, 0x80000000                              // 0000000425C0: 8D08FF0F 80000000
	v_fma_f32 v19, -v11, v22, 1.0                              // 0000000425C8: D6130013 23CA2D0B
	v_fma_f32 v20, -v15, v26, 1.0                              // 0000000425D0: D6130014 23CA350F
	s_wait_alu depctr_sa_sdst(0)                               // 0000000425D8: BF88FF9E
	s_fmamk_f32 s8, s5, 0x3fb8aa3b, s8                         // 0000000425DC: A3080805 3FB8AA3B
	s_mov_b32 vcc_lo, s2                                       // 0000000425E4: BEEA0002
	v_cndmask_b32_e64 v16, 0x7f800000, v16, s4                 // 0000000425E8: D5010010 001220FF 7F800000
	s_wait_alu depctr_sa_sdst(0)                               // 0000000425F4: BF88FF9E
	v_div_fmas_f32 v6, v17, v24, v6                            // 0000000425F8: D6370006 041A3111
	s_mov_b32 vcc_lo, s3                                       // 000000042600: BEEA0003
	v_div_scale_f32 v13, s0, v48, v12, v48                     // 000000042604: D6FC000D 04C21930
	s_fmamk_f32 s2, s5, 0x32a5705f, s8                         // 00000004260C: A3020805 32A5705F
	s_wait_alu depctr_sa_sdst(0)                               // 000000042614: BF88FF9E
	v_div_fmas_f32 v10, v18, v25, v10                          // 000000042618: D637000A 042A3312
	v_fmac_f32_e32 v22, v19, v22                               // 000000042620: 562C2D13
	v_div_scale_f32 v21, s1, v47, v12, v47                     // 000000042624: D6FC0115 04BE192F
	v_fmac_f32_e32 v26, v20, v26                               // 00000004262C: 56343514
	v_add_f32_e32 v16, v7, v16                                 // 000000042630: 06202107
	s_add_f32 s2, s28, s2                                      // 000000042634: A002021C
	v_div_fixup_f32 v7, v10, v14, v49                          // 000000042638: D6270007 04C61D0A
	v_mul_f32_e32 v10, v13, v22                                // 000000042640: 10142D0D
	v_div_fixup_f32 v6, v6, v14, v50                           // 000000042644: D6270006 04CA1D06
	v_mul_f32_e32 v14, v21, v26                                // 00000004264C: 101C3515
	v_div_scale_f32 v17, null, v16, v16, v46                   // 000000042650: D6FC7C11 04BA2110
	s_wait_alu depctr_sa_sdst(0)                               // 000000042658: BF88FF9E
	v_s_exp_f32 s4, s2                                         // 00000004265C: D6800004 02010002
	v_div_scale_f32 v19, null, v16, v16, v45                   // 000000042664: D6FC7C13 04B62110
	v_fma_f32 v20, -v11, v10, v13                              // 00000004266C: D6130014 2436150B
	s_cmp_nlt_f32 s5, 0xc2ce8ed0                               // 000000042674: BF4EFF05 C2CE8ED0
	v_fma_f32 v23, -v15, v14, v21                              // 00000004267C: D6130017 24561D0F
	v_rcp_f32_e32 v25, v17                                     // 000000042684: 7E325511
	v_rcp_f32_e32 v27, v19                                     // 000000042688: 7E365513
	v_fmac_f32_e32 v10, v20, v22                               // 00000004268C: 56142D14
	s_cselect_b32 vcc_lo, -1, 0                                // 000000042690: 986A80C1
	s_cmp_ngt_f32 s5, 0x42b17218                               // 000000042694: BF4BFF05 42B17218
	v_fmac_f32_e32 v14, v23, v26                               // 00000004269C: 561C3517
	v_ldexp_f32 v20, s4, s22                                   // 0000000426A0: D71C0014 02002C04
	v_fma_f32 v11, -v11, v10, v13                              // 0000000426A8: D613000B 2436150B
	s_cselect_b32 s4, -1, 0                                    // 0000000426B0: 980480C1
	s_xor_b32 s5, s17, 0x80000000                              // 0000000426B4: 8D05FF11 80000000
	v_fma_f32 v13, -v15, v14, v21                              // 0000000426BC: D613000D 24561D0F
	s_wait_alu depctr_sa_sdst(0)                               // 0000000426C4: BF88FF9E
	v_cndmask_b32_e32 v15, 0, v20, vcc_lo                      // 0000000426C8: 021E2880
	v_fma_f32 v20, -v17, v25, 1.0                              // 0000000426CC: D6130014 23CA3311
	s_fmamk_f32 s5, s6, 0x3fb8aa3b, s5                         // 0000000426D4: A3050506 3FB8AA3B
	v_fma_f32 v21, -v19, v27, 1.0                              // 0000000426DC: D6130015 23CA3713
	s_mov_b32 vcc_lo, s0                                       // 0000000426E4: BEEA0000
	v_div_scale_f32 v18, s2, v46, v16, v46                     // 0000000426E8: D6FC0212 04BA212E
	s_wait_alu depctr_sa_sdst(0)                               // 0000000426F0: BF88FF9E
	v_div_fmas_f32 v10, v11, v22, v10                          // 0000000426F4: D637000A 042A2D0B
	s_fmamk_f32 s0, s6, 0x32a5705f, s5                         // 0000000426FC: A3000506 32A5705F
	s_mov_b32 vcc_lo, s1                                       // 000000042704: BEEA0001
	v_cndmask_b32_e64 v11, 0x7f800000, v15, s4                 // 000000042708: D501000B 00121EFF 7F800000
	v_fmac_f32_e32 v25, v20, v25                               // 000000042714: 56323314
	v_div_scale_f32 v24, s3, v45, v16, v45                     // 000000042718: D6FC0318 04B6212D
	s_wait_alu depctr_sa_sdst(0)                               // 000000042720: BF88FF9E
	v_div_fmas_f32 v13, v13, v26, v14                          // 000000042724: D637000D 043A350D
	v_fmac_f32_e32 v27, v21, v27                               // 00000004272C: 56363715
	s_add_f32 s0, s29, s0                                      // 000000042730: A000001D
	s_wait_dscnt 0x0                                           // 000000042734: BFC60000
	v_add_f32_e32 v14, v0, v11                                 // 000000042738: 061C1700
	v_mul_f32_e32 v0, v18, v25                                 // 00000004273C: 10003312
	v_div_fixup_f32 v10, v10, v12, v48                         // 000000042740: D627000A 04C2190A
	v_div_fixup_f32 v11, v13, v12, v47                         // 000000042748: D627000B 04BE190D
	v_mul_f32_e32 v12, v24, v27                                // 000000042750: 10183718
	s_cmp_nlt_f32 s6, 0xc2ce8ed0                               // 000000042754: BF4EFF06 C2CE8ED0
	s_wait_alu depctr_sa_sdst(0)                               // 00000004275C: BF88FF9E
	v_s_exp_f32 s4, s0                                         // 000000042760: D6800004 02010000
	v_fma_f32 v21, -v17, v0, v18                               // 000000042768: D6130015 244A0111
	v_div_scale_f32 v13, null, v14, v14, v44                   // 000000042770: D6FC7C0D 04B21D0E
	v_fma_f32 v22, -v19, v12, v24                              // 000000042778: D6130016 24621913
	s_cselect_b32 vcc_lo, -1, 0                                // 000000042780: 986A80C1
	s_cmp_ngt_f32 s6, 0x42b17218                               // 000000042784: BF4BFF06 42B17218
	v_div_scale_f32 v20, null, v14, v14, v43                   // 00000004278C: D6FC7C14 04AE1D0E
	v_fmac_f32_e32 v0, v21, v25                                // 000000042794: 56003315
	v_ldexp_f32 v21, s4, s23                                   // 000000042798: D71C0015 02002E04
	s_cselect_b32 s4, -1, 0                                    // 0000000427A0: 980480C1
	s_xor_b32 s5, s19, 0x80000000                              // 0000000427A4: 8D05FF13 80000000
	v_fmac_f32_e32 v12, v22, v27                               // 0000000427AC: 56183716
	s_wait_alu depctr_sa_sdst(0)                               // 0000000427B0: BF88FF9E
	s_fmamk_f32 s5, s7, 0x3fb8aa3b, s5                         // 0000000427B4: A3050507 3FB8AA3B
	v_rcp_f32_e32 v26, v13                                     // 0000000427BC: 7E34550D
	v_rcp_f32_e32 v28, v20                                     // 0000000427C0: 7E385514
	v_fma_f32 v17, -v17, v0, v18                               // 0000000427C4: D6130011 244A0111
	v_fma_f32 v18, -v19, v12, v24                              // 0000000427CC: D6130012 24621913
	v_cndmask_b32_e32 v19, 0, v21, vcc_lo                      // 0000000427D4: 02262A80
	s_mov_b32 vcc_lo, s2                                       // 0000000427D8: BEEA0002
	s_wait_alu depctr_sa_sdst(0)                               // 0000000427DC: BF88FF9E
	s_fmamk_f32 s2, s7, 0x32a5705f, s5                         // 0000000427E0: A3020507 32A5705F
	s_cmp_nlt_f32 s7, 0xc2ce8ed0                               // 0000000427E8: BF4EFF07 C2CE8ED0
	v_div_fmas_f32 v0, v17, v25, v0                            // 0000000427F0: D6370000 04023311
	v_fma_f32 v21, -v13, v26, 1.0                              // 0000000427F8: D6130015 23CA350D
	s_wait_alu depctr_sa_sdst(0)                               // 000000042800: BF88FF9E
	s_add_f32 s2, s26, s2                                      // 000000042804: A002021A
	v_fma_f32 v22, -v20, v28, 1.0                              // 000000042808: D6130016 23CA3914
	s_mov_b32 vcc_lo, s3                                       // 000000042810: BEEA0003
	v_div_scale_f32 v15, s0, v44, v14, v44                     // 000000042814: D6FC000F 04B21D2C
	s_wait_alu depctr_sa_sdst(0)                               // 00000004281C: BF88FF9E
	v_s_exp_f32 s2, s2                                         // 000000042820: D6800002 02010002
	v_fmac_f32_e32 v26, v21, v26                               // 000000042828: 56343515
	s_mul_f32 s10, s9, 0x3fb8aa3b                              // 00000004282C: A20AFF09 3FB8AA3B
	s_cvt_i32_f32 s24, s24                                     // 000000042834: BE986618
	v_div_fmas_f32 v12, v18, v27, v12                          // 000000042838: D637000C 04323712
	s_cselect_b32 vcc_lo, -1, 0                                // 000000042840: 986A80C1
	s_cmp_ngt_f32 s7, 0x42b17218                               // 000000042844: BF4BFF07 42B17218
	v_div_scale_f32 v23, s1, v43, v14, v43                     // 00000004284C: D6FC0117 04AE1D2B
	v_fmac_f32_e32 v28, v22, v28                               // 000000042854: 56383916
	v_cndmask_b32_e64 v17, 0x7f800000, v19, s4                 // 000000042858: D5010011 001226FF 7F800000
	v_mul_f32_e32 v18, v15, v26                                // 000000042864: 1024350F
	s_wait_alu depctr_sa_sdst(0)                               // 000000042868: BF88FF9E
	v_ldexp_f32 v27, s2, s24                                   // 00000004286C: D71C001B 02003002
	s_cselect_b32 s2, -1, 0                                    // 000000042874: 980280C1
	s_xor_b32 s4, s10, 0x80000000                              // 000000042878: 8D04FF0A 80000000
	s_rndne_f32 s25, s10                                       // 000000042880: BE99630A
	v_mul_f32_e32 v19, v23, v28                                // 000000042884: 10263917
	s_wait_alu depctr_sa_sdst(0)                               // 000000042888: BF88FF9E
	s_fmamk_f32 s5, s9, 0x3fb8aa3b, s4                         // 00000004288C: A3050409 3FB8AA3B
	v_add_f32_e32 v17, v1, v17                                 // 000000042894: 06222301
	v_div_fixup_f32 v1, v12, v16, v45                          // 000000042898: D6270001 04B6210C
	v_fma_f32 v12, -v13, v18, v15                              // 0000000428A0: D613000C 243E250D
	s_sub_f32 s30, s10, s25                                    // 0000000428A8: A09E190A
	s_wait_alu depctr_sa_sdst(0)                               // 0000000428AC: BF88FF9E
	s_fmamk_f32 s5, s9, 0x32a5705f, s5                         // 0000000428B0: A3050509 32A5705F
	v_div_fixup_f32 v0, v0, v16, v46                           // 0000000428B8: D6270000 04BA2100
	v_fma_f32 v16, -v20, v19, v23                              // 0000000428C0: D6130010 245E2714
	v_div_scale_f32 v21, null, v17, v17, v42                   // 0000000428C8: D6FC7C15 04AA2311
	v_div_scale_f32 v22, null, v17, v17, v39                   // 0000000428D0: D6FC7C16 049E2311
	v_fmac_f32_e32 v18, v12, v26                               // 0000000428D8: 5624350C
	s_wait_alu depctr_sa_sdst(0)                               // 0000000428DC: BF88FF9E
	s_add_f32 s5, s30, s5                                      // 0000000428E0: A005051E
	v_fmac_f32_e32 v19, v16, v28                               // 0000000428E4: 56263910
	v_rcp_f32_e32 v24, v21                                     // 0000000428E8: 7E305515
	v_cndmask_b32_e32 v12, 0, v27, vcc_lo                      // 0000000428EC: 02183680
	s_mov_b32 vcc_lo, s0                                       // 0000000428F0: BEEA0000
	s_wait_alu depctr_sa_sdst(0)                               // 0000000428F4: BF88FF9E
	v_s_exp_f32 s0, s5                                         // 0000000428F8: D6800000 02010005
	v_rcp_f32_e32 v25, v22                                     // 000000042900: 7E325516
	v_fma_f32 v13, -v13, v18, v15                              // 000000042904: D613000D 243E250D
	v_fma_f32 v15, -v20, v19, v23                              // 00000004290C: D613000F 245E2714
	s_cvt_i32_f32 s25, s25                                     // 000000042914: BE996619
	s_cmp_nlt_f32 s9, 0xc2ce8ed0                               // 000000042918: BF4EFF09 C2CE8ED0
	v_fma_f32 v20, -v21, v24, 1.0                              // 000000042920: D6130014 23CA3115
	v_div_fmas_f32 v13, v13, v26, v18                          // 000000042928: D637000D 044A350D
	s_mov_b32 vcc_lo, s1                                       // 000000042930: BEEA0001
	v_cndmask_b32_e64 v18, 0x7f800000, v12, s2                 // 000000042934: D5010012 000A18FF 7F800000
	s_wait_alu depctr_sa_sdst(0)                               // 000000042940: BF88FF9E
	v_div_fmas_f32 v15, v15, v28, v19                          // 000000042944: D637000F 044E390F
	v_ldexp_f32 v19, s0, s25                                   // 00000004294C: D71C0013 02003200
	v_fma_f32 v23, -v22, v25, 1.0                              // 000000042954: D6130017 23CA3316
	s_cselect_b32 vcc_lo, -1, 0                                // 00000004295C: 986A80C1
	s_cmp_ngt_f32 s9, 0x42b17218                               // 000000042960: BF4BFF09 42B17218
	v_div_scale_f32 v16, s3, v42, v17, v42                     // 000000042968: D6FC0310 04AA232A
	v_fmac_f32_e32 v24, v20, v24                               // 000000042970: 56303114
	v_add_f32_e32 v18, v2, v18                                 // 000000042974: 06242502
	s_wait_alu depctr_sa_sdst(0)                               // 000000042978: BF88FF9E
	v_cndmask_b32_e32 v2, 0, v19, vcc_lo                       // 00000004297C: 02042680
	v_div_scale_f32 v27, s4, v39, v17, v39                     // 000000042980: D6FC041B 049E2327
	v_fmac_f32_e32 v25, v23, v25                               // 000000042988: 56323317
	s_cselect_b32 vcc_lo, -1, 0                                // 00000004298C: 986A80C1
	v_div_fixup_f32 v12, v13, v14, v44                         // 000000042990: D627000C 04B21D0D
	v_div_fixup_f32 v13, v15, v14, v43                         // 000000042998: D627000D 04AE1D0F
	v_mul_f32_e32 v14, v16, v24                                // 0000000429A0: 101C3110
	s_wait_alu depctr_sa_sdst(0)                               // 0000000429A4: BF88FF9E
	v_cndmask_b32_e32 v2, 0x7f800000, v2, vcc_lo               // 0000000429A8: 020404FF 7F800000
	v_div_scale_f32 v15, null, v18, v18, v41                   // 0000000429B0: D6FC7C0F 04A62512
	v_div_scale_f32 v19, null, v18, v18, v38                   // 0000000429B8: D6FC7C13 049A2512
	v_mul_f32_e32 v20, v27, v25                                // 0000000429C0: 1028331B
	v_fma_f32 v23, -v21, v14, v16                              // 0000000429C4: D6130017 24421D15
	v_add_f32_e32 v29, v3, v2                                  // 0000000429CC: 063A0503
	v_rcp_f32_e32 v26, v15                                     // 0000000429D0: 7E34550F
	v_rcp_f32_e32 v28, v19                                     // 0000000429D4: 7E385513
	v_fma_f32 v2, -v22, v20, v27                               // 0000000429D8: D6130002 246E2916
	v_fmac_f32_e32 v14, v23, v24                               // 0000000429E0: 561C3117
	v_div_scale_f32 v23, null, v29, v29, v40                   // 0000000429E4: D6FC7C17 04A23B1D
	v_div_scale_f32 v32, null, v29, v29, v37                   // 0000000429EC: D6FC7C20 04963B1D
	v_div_scale_f32 v3, s0, v41, v18, v41                      // 0000000429F4: D6FC0003 04A62529
	v_fmac_f32_e32 v20, v2, v25                                // 0000000429FC: 56283302
	v_fma_f32 v16, -v21, v14, v16                              // 000000042A00: D6130010 24421D15
	v_rcp_f32_e32 v33, v23                                     // 000000042A08: 7E425517
	v_fma_f32 v2, -v15, v26, 1.0                               // 000000042A0C: D6130002 23CA350F
	v_fma_f32 v31, -v19, v28, 1.0                              // 000000042A14: D613001F 23CA3913
	v_fma_f32 v21, -v22, v20, v27                              // 000000042A1C: D6130015 246E2916
	v_rcp_f32_e32 v22, v32                                     // 000000042A24: 7E2C5520
	v_div_scale_f32 v30, s1, v38, v18, v38                     // 000000042A28: D6FC011E 049A2526
	v_fmac_f32_e32 v26, v2, v26                                // 000000042A30: 56343502
	v_fmac_f32_e32 v28, v31, v28                               // 000000042A34: 5638391F
	s_mov_b32 vcc_lo, s3                                       // 000000042A38: BEEA0003
	v_div_scale_f32 v27, s2, v40, v29, v40                     // 000000042A3C: D6FC021B 04A23B28
	s_wait_alu depctr_sa_sdst(0)                               // 000000042A44: BF88FF9E
	v_div_fmas_f32 v2, v16, v24, v14                           // 000000042A48: D6370002 043A3110
	v_fma_f32 v14, -v23, v33, 1.0                              // 000000042A50: D613000E 23CA4317
	v_mul_f32_e32 v16, v3, v26                                 // 000000042A58: 10203503
	v_mul_f32_e32 v24, v30, v28                                // 000000042A5C: 1030391E
	v_fma_f32 v31, -v32, v22, 1.0                              // 000000042A60: D613001F 23CA2D20
	s_mov_b32 vcc_lo, s4                                       // 000000042A68: BEEA0004
	v_fmac_f32_e32 v33, v14, v33                               // 000000042A6C: 5642430E
	v_div_scale_f32 v14, s3, v37, v29, v37                     // 000000042A70: D6FC030E 04963B25
	v_fma_f32 v34, -v15, v16, v3                               // 000000042A78: D6130022 240E210F
	v_fma_f32 v35, -v19, v24, v30                              // 000000042A80: D6130023 247A3113
	v_fmac_f32_e32 v22, v31, v22                               // 000000042A88: 562C2D1F
	v_mul_f32_e32 v31, v27, v33                                // 000000042A8C: 103E431B
	s_wait_alu depctr_sa_sdst(0)                               // 000000042A90: BF88FF9E
	v_div_fmas_f32 v20, v21, v25, v20                          // 000000042A94: D6370014 04523315
	v_fmac_f32_e32 v16, v34, v26                               // 000000042A9C: 56203522
	v_dual_fmac_f32 v24, v35, v28 :: v_dual_mul_f32 v21, v14, v22// 000000042AA0: C8063923 18142D0E
	v_fma_f32 v25, -v23, v31, v27                              // 000000042AA8: D6130019 246E3F17
	s_mov_b32 vcc_lo, s0                                       // 000000042AB0: BEEA0000
	s_delay_alu instid0(VALU_DEP_3) | instskip(NEXT) | instid1(VALU_DEP_3)// 000000042AB4: BF870193
	v_fma_f32 v3, -v15, v16, v3                                // 000000042AB8: D6130003 240E210F
	v_fma_f32 v15, -v19, v24, v30                              // 000000042AC0: D613000F 247A3113
	v_fma_f32 v19, -v32, v21, v14                              // 000000042AC8: D6130013 243A2B20
	v_fmac_f32_e32 v31, v25, v33                               // 000000042AD0: 563E4319
	v_div_fixup_f32 v2, v2, v17, v42                           // 000000042AD4: D6270002 04AA2302
	s_wait_alu depctr_sa_sdst(0)                               // 000000042ADC: BF88FF9E
	v_div_fmas_f32 v16, v3, v26, v16                           // 000000042AE0: D6370010 04423503
	s_mov_b32 vcc_lo, s1                                       // 000000042AE8: BEEA0001
	v_fmac_f32_e32 v21, v19, v22                               // 000000042AEC: 562A2D13
	v_fma_f32 v3, -v23, v31, v27                               // 000000042AF0: D6130003 246E3F17
	s_wait_alu depctr_sa_sdst(0)                               // 000000042AF8: BF88FF9E
	v_div_fmas_f32 v15, v15, v28, v24                          // 000000042AFC: D637000F 0462390F
	s_mov_b32 vcc_lo, s2                                       // 000000042B04: BEEA0002
	v_fma_f32 v14, -v32, v21, v14                              // 000000042B08: D613000E 243A2B20
	s_wait_alu depctr_sa_sdst(0)                               // 000000042B10: BF88FF9E
	v_div_fmas_f32 v19, v3, v33, v31                           // 000000042B14: D6370013 047E4303
	s_mov_b32 vcc_lo, s3                                       // 000000042B1C: BEEA0003
	v_div_fixup_f32 v3, v20, v17, v39                          // 000000042B20: D6270003 049E2314
	v_div_fixup_f32 v15, v15, v18, v38                         // 000000042B28: D627000F 049A250F
	s_wait_alu depctr_sa_sdst(0)                               // 000000042B30: BF88FF9E
	v_div_fmas_f32 v21, v14, v22, v21                          // 000000042B34: D6370015 04562D0E
	v_div_fixup_f32 v14, v16, v18, v41                         // 000000042B3C: D627000E 04A62510
	v_div_fixup_f32 v16, v19, v29, v40                         // 000000042B44: D6270010 04A23B13
	s_delay_alu instid0(VALU_DEP_3)                            // 000000042B4C: BF870003
	v_div_fixup_f32 v17, v21, v29, v37                         // 000000042B50: D6270011 04963B15
	s_clause 0x7                                               // 000000042B58: BF850007
	global_store_b64 v[8:9], v[4:5], off                       // 000000042B5C: EE06C07C 02000000 00000008
	global_store_b64 v[8:9], v[6:7], off offset:2048           // 000000042B68: EE06C07C 03000000 00080008
	global_store_b64 v[8:9], v[10:11], off offset:4096         // 000000042B74: EE06C07C 05000000 00100008
	global_store_b64 v[8:9], v[0:1], off offset:6144           // 000000042B80: EE06C07C 00000000 00180008
	global_store_b64 v[8:9], v[12:13], off offset:8192         // 000000042B8C: EE06C07C 06000000 00200008
	global_store_b64 v[8:9], v[2:3], off offset:10240          // 000000042B98: EE06C07C 01000000 00280008
	global_store_b64 v[8:9], v[14:15], off offset:12288        // 000000042BA4: EE06C07C 07000000 00300008
	global_store_b64 v[8:9], v[16:17], off offset:14336        // 000000042BB0: EE06C07C 08000000 00380008
	s_endpgm                                                   // 000000042BBC: BFB00000
	s_branch 63139                                             // 000000042BC0: BFA0F6A3 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x350>
	s_load_b32 s10, s[8:9], 0xd0                               // 000000042BC4: F4000284 F80000D0
	s_branch 63096                                             // 000000042BCC: BFA0F678 <_ZN6strata3ds412_GLOBAL__N_125sparse_attn_packed_kernelILi8ELb1ELb0EEEvPKfPKtPKhPKiiNS0_8AttnRowsES4_ifPf+0x2b0>
