(* @frege
===== Verification =====
Prefix: OCAMLRUNPARAM=s=8G
Options: -v -jobs 16 -fork -cadical /home/mht208/Sources/cadical/cadical-rel-1.3.0/build/cadical  -sat_cert grat  -gratchk /home/mht208/Sources/grat/gratchk/code/gratchk  -gratgen /home/mht208/Sources/grat/gratgen/gratgen  -no_carry_constraint -tmpdir .
Command: OCAMLRUNPARAM=s=8G ./coqcryptoline.exe -v -jobs 16 -fork -cadical /home/mht208/Sources/cadical/cadical-rel-1.3.0/build/cadical  -sat_cert grat  -gratchk /home/mht208/Sources/grat/gratchk/code/gratchk  -gratgen /home/mht208/Sources/grat/gratgen/gratgen  -no_carry_constraint -tmpdir .  fe_sub_tuned.cl

Results of checking CNF formulas:       [OK]            0.837963 seconds
Finding polynomial coefficients         [OK]            0.051021 seconds
Verification result:                    [OK]            1.146538 seconds
*)

proc main(uint32 a0_0, uint32 a1_0, uint32 a2_0, uint32 a3_0, uint32 a4_0, uint32 a5_0, uint32 a6_0, uint32 a7_0, uint32 a8_0, uint32 a9_0, uint32 b0_0, uint32 b1_0, uint32 b2_0, uint32 b3_0, uint32 b4_0, uint32 b5_0, uint32 b6_0, uint32 b7_0, uint32 b8_0, uint32 b9_0) =
{ true && and [a0_0 <=u 73819750@32, a1_0 <=u 36909875@32, a2_0 <=u 73819750@32, a3_0 <=u 36909875@32, a4_0 <=u 73819750@32, a5_0 <=u 36909875@32, a6_0 <=u 73819750@32, a7_0 <=u 36909875@32, a8_0 <=u 73819750@32, a9_0 <=u 36909875@32, b0_0 <=u 73819750@32, b1_0 <=u 36909875@32, b2_0 <=u 73819750@32, b3_0 <=u 36909875@32, b4_0 <=u 73819750@32, b5_0 <=u 36909875@32, b6_0 <=u 73819750@32, b7_0 <=u 36909875@32, b8_0 <=u 73819750@32, b9_0 <=u 36909875@32] }
mov f5_0_1 a0_0;
mov f5_4_1 a1_0;
mov f5_8_1 a2_0;
mov f5_12_1 a3_0;
mov f5_16_1 a4_0;
mov f5_20_1 a5_0;
mov f5_24_1 a6_0;
mov f5_28_1 a7_0;
mov f5_32_1 a8_0;
mov f5_36_1 a9_0;
mov g4_0_1 b0_0;
mov g4_4_1 b1_0;
mov g4_8_1 b2_0;
mov g4_12_1 b3_0;
mov g4_16_1 b4_0;
mov g4_20_1 b5_0;
mov g4_24_1 b6_0;
mov g4_28_1 b7_0;
mov g4_32_1 b8_0;
mov g4_36_1 b9_0;
mov x209_1 f5_36_1;
mov x2110_1 f5_32_1;
mov vect_x5_186018_0_1 f5_0_1;
mov vect_x5_186018_4_1 f5_4_1;
mov vect_x5_186018_8_1 f5_8_1;
mov vect_x5_186018_12_1 f5_12_1;
mov vect_x5_186021_0_1 f5_16_1;
mov vect_x5_186021_4_1 f5_20_1;
mov vect_x5_186021_8_1 f5_24_1;
mov vect_x5_186021_12_1 f5_28_1;
mov x3819_1 g4_36_1;
mov x3920_1 g4_32_1;
mov vect_x23_2860629_0_1 g4_0_1;
mov vect_x23_2860629_4_1 g4_4_1;
mov vect_x23_2860629_8_1 g4_8_1;
mov vect_x23_2860629_12_1 g4_12_1;
mov vect_x23_2860733_0_1 g4_16_1;
mov vect_x23_2860733_4_1 g4_20_1;
mov vect_x23_2860733_8_1 g4_24_1;
mov vect_x23_2860733_12_1 g4_28_1;
add vect__7460362_0_1 vect_x5_186018_0_1 134217690@uint32;
add vect__7460362_4_1 vect_x5_186018_4_1 67108862@uint32;
add vect__7460362_8_1 vect_x5_186018_8_1 134217726@uint32;
add vect__7460362_12_1 vect_x5_186018_12_1 67108862@uint32;
add vect__7460363_0_1 vect_x5_186021_0_1 134217726@uint32;
add vect__7460363_4_1 vect_x5_186021_4_1 67108862@uint32;
add vect__7460363_8_1 vect_x5_186021_8_1 134217726@uint32;
add vect__7460363_12_1 vect_x5_186021_12_1 67108862@uint32;
sub vect__3060837_0_1 vect__7460362_0_1 vect_x23_2860629_0_1;
sub vect__3060837_4_1 vect__7460362_4_1 vect_x23_2860629_4_1;
sub vect__3060837_8_1 vect__7460362_8_1 vect_x23_2860629_8_1;
sub vect__3060837_12_1 vect__7460362_12_1 vect_x23_2860629_12_1;
sub vect__3060839_0_1 vect__7460363_0_1 vect_x23_2860733_0_1;
sub vect__3060839_4_1 vect__7460363_4_1 vect_x23_2860733_4_1;
sub vect__3060839_8_1 vect__7460363_8_1 vect_x23_2860733_8_1;
sub vect__3060839_12_1 vect__7460363_12_1 vect_x23_2860733_12_1;
mov h6_0_1 vect__3060837_0_1;
mov h6_4_1 vect__3060837_4_1;
mov h6_8_1 vect__3060837_8_1;
mov h6_12_1 vect__3060837_12_1;
mov h6_16_1 vect__3060839_0_1;
mov h6_20_1 vect__3060839_4_1;
mov h6_24_1 vect__3060839_8_1;
mov h6_28_1 vect__3060839_12_1;
add v66_1 x2110_1 134217726@uint32;
sub v46_1 v66_1 x3920_1;
mov h6_32_1 v46_1;
add v65_1 x209_1 67108862@uint32;
sub v48_1 v65_1 x3819_1;
mov h6_36_1 v48_1;
mov c0_1 h6_0_1;
mov c1_1 h6_4_1;
mov c2_1 h6_8_1;
mov c3_1 h6_12_1;
mov c4_1 h6_16_1;
mov c5_1 h6_20_1;
mov c6_1 h6_24_1;
mov c7_1 h6_28_1;
mov c8_1 h6_32_1;
mov c9_1 h6_36_1;
{ c0_1 + (c1_1 * 67108864) + (c2_1 * 2251799813685248) + (c3_1 * 151115727451828646838272) + (c4_1 * 5070602400912917605986812821504) + (c5_1 * 340282366920938463463374607431768211456) + (c6_1 * 11417981541647679048466287755595961091061972992) + (c7_1 * 766247770432944429179173513575154591809369561091801088) + (c8_1 * 25711008708143844408671393477458601640355247900524685364822016) + (c9_1 * 1725436586697640946858688965569256363112777243042596638790631055949824) = a0_0 + (a1_0 * 67108864) + (a2_0 * 2251799813685248) + (a3_0 * 151115727451828646838272) + (a4_0 * 5070602400912917605986812821504) + (a5_0 * 340282366920938463463374607431768211456) + (a6_0 * 11417981541647679048466287755595961091061972992) + (a7_0 * 766247770432944429179173513575154591809369561091801088) + (a8_0 * 25711008708143844408671393477458601640355247900524685364822016) + (a9_0 * 1725436586697640946858688965569256363112777243042596638790631055949824) - (b0_0 + (b1_0 * 67108864) + (b2_0 * 2251799813685248) + (b3_0 * 151115727451828646838272) + (b4_0 * 5070602400912917605986812821504) + (b5_0 * 340282366920938463463374607431768211456) + (b6_0 * 11417981541647679048466287755595961091061972992) + (b7_0 * 766247770432944429179173513575154591809369561091801088) + (b8_0 * 25711008708143844408671393477458601640355247900524685364822016) + (b9_0 * 1725436586697640946858688965569256363112777243042596638790631055949824)) (mod 57896044618658097711785492504343953926634992332820282019728792003956564819968 - 19) && and [c0_1 <=u 221459250@32, c1_1 <=u 110729625@32, c2_1 <=u 221459250@32, c3_1 <=u 110729625@32, c4_1 <=u 221459250@32, c5_1 <=u 110729625@32, c6_1 <=u 221459250@32, c7_1 <=u 110729625@32, c8_1 <=u 221459250@32, c9_1 <=u 110729625@32] }
