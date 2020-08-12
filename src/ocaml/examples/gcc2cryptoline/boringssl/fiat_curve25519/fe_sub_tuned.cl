(* @frege
===== Verification =====
Prefix: OCAMLRUNPARAM=s=8G
Options: -v -jobs 16 -fork -cadical /home/mht208/Sources/cadical/cadical-rel-1.3.0/build/cadical  -sat_cert grat  -gratchk /home/mht208/Sources/grat/gratchk/code/gratchk  -gratgen /home/mht208/Sources/grat/gratgen/gratgen  -no_carry_constraint -tmpdir .
Command: OCAMLRUNPARAM=s=8G ./coqcryptoline.exe -v -jobs 16 -fork -cadical /home/mht208/Sources/cadical/cadical-rel-1.3.0/build/cadical  -sat_cert grat  -gratchk /home/mht208/Sources/grat/gratchk/code/gratchk  -gratgen /home/mht208/Sources/grat/gratgen/gratgen  -no_carry_constraint -tmpdir .  fe_sub_tuned.cl

Results of checking CNF formulas:       [OK]            0.250336 seconds
Finding polynomial coefficients         [OK]            0.028692 seconds
Verification result:                    [OK]            0.316011 seconds
*)

proc main(uint64 a0_0, uint64 a1_0, uint64 a2_0, uint64 a3_0, uint64 a4_0, uint64 b0_0, uint64 b1_0, uint64 b2_0, uint64 b3_0, uint64 b4_0) =
{ true && and [a0_0 <u 2251799813718016@64, a1_0 <u 2251799813718016@64, a2_0 <u 2251799813718016@64, a3_0 <u 2251799813718016@64, a4_0 <u 2251799813718016@64, b0_0 <u 2251799813718016@64, b1_0 <u 2251799813718016@64, b2_0 <u 2251799813718016@64, b3_0 <u 2251799813718016@64, b4_0 <u 2251799813718016@64] }
mov f2_0_1 a0_0;
mov f2_8_1 a1_0;
mov f2_16_1 a2_0;
mov f2_24_1 a3_0;
mov f2_32_1 a4_0;
mov g1_0_1 b0_0;
mov g1_8_1 b1_0;
mov g1_16_1 b2_0;
mov g1_24_1 b3_0;
mov g1_32_1 b4_0;
mov x105_1 f2_32_1;
mov vect_x5_958930_0_1 f2_0_1;
mov vect_x5_958930_1_1 f2_8_1;
mov vect_x5_959033_0_1 f2_16_1;
mov vect_x5_959033_1_1 f2_24_1;
mov x1810_1 g1_32_1;
mov vect_x13_1459440_0_1 g1_0_1;
mov vect_x13_1459440_1_1 g1_8_1;
mov vect_x13_1459542_0_1 g1_16_1;
mov vect_x13_1459542_1_1 g1_24_1;
add vect__3959119_0_1 vect_x5_958930_0_1 4503599627370458@uint64;
add vect__3959119_1_1 vect_x5_958930_1_1 4503599627370494@uint64;
add vect__3959121_0_1 vect_x5_959033_0_1 4503599627370494@uint64;
add vect__3959121_1_1 vect_x5_959033_1_1 4503599627370494@uint64;
sub vect__1659644_0_1 vect__3959119_0_1 vect_x13_1459440_0_1;
sub vect__1659644_1_1 vect__3959119_1_1 vect_x13_1459440_1_1;
sub vect__1659645_0_1 vect__3959121_0_1 vect_x13_1459542_0_1;
sub vect__1659645_1_1 vect__3959121_1_1 vect_x13_1459542_1_1;
mov h3_0_1 vect__1659644_0_1;
mov h3_8_1 vect__1659644_1_1;
mov h3_16_1 vect__1659645_0_1;
mov h3_24_1 vect__1659645_1_1;
add v35_1 x105_1 4503599627370494@uint64;
sub v24_1 v35_1 x1810_1;
mov h3_32_1 v24_1;
mov c0_1 h3_0_1;
mov c1_1 h3_8_1;
mov c2_1 h3_16_1;
mov c3_1 h3_24_1;
mov c4_1 h3_32_1;
{ c0_1 + (c1_1 * 2251799813685248) + (c2_1 * 5070602400912917605986812821504) + (c3_1 * 11417981541647679048466287755595961091061972992) + (c4_1 * 25711008708143844408671393477458601640355247900524685364822016) = a0_0 + (a1_0 * 2251799813685248) + (a2_0 * 5070602400912917605986812821504) + (a3_0 * 11417981541647679048466287755595961091061972992) + (a4_0 * 25711008708143844408671393477458601640355247900524685364822016) - (b0_0 + (b1_0 * 2251799813685248) + (b2_0 * 5070602400912917605986812821504) + (b3_0 * 11417981541647679048466287755595961091061972992) + (b4_0 * 25711008708143844408671393477458601640355247900524685364822016)) (mod 57896044618658097711785492504343953926634992332820282019728792003956564819968 - 19) && true }
