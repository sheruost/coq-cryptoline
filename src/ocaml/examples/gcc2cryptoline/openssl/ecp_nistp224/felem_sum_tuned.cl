proc main(uint64 a0_0, uint64 a1_0, uint64 a2_0, uint64 a3_0, uint64 a4_0, uint64 b0_0, uint64 b1_0, uint64 b2_0, uint64 b3_0, uint64 b4_0) =
{ true && and [a0_0 <u 144115188075855872@64, a1_0 <u 144115188075855872@64, a2_0 <u 144115188075855872@64, a3_0 <u 144115188075855872@64, b0_0 <u 144115188075855872@64, b1_0 <u 144115188075855872@64, b2_0 <u 144115188075855872@64, b3_0 <u 144115188075855872@64] }
mov in15_0_1 a0_0;
mov in15_8_1 a1_0;
mov in15_16_1 a2_0;
mov in15_24_1 a3_0;
mov out14_0_1 b0_0;
mov out14_8_1 b1_0;
mov out14_16_1 b2_0;
mov out14_24_1 b3_0;
mov v1_1 out14_0_1;
mov v2_1 in15_0_1;
add v3_1 v1_1 v2_1;
mov out14_0_2 v3_1;
mov v4_1 out14_8_1;
mov v5_1 in15_8_1;
add v6_1 v4_1 v5_1;
mov out14_8_2 v6_1;
mov v7_1 out14_16_1;
mov v8_1 in15_16_1;
add v9_1 v7_1 v8_1;
mov out14_16_2 v9_1;
mov v10_1 out14_24_1;
mov v11_1 in15_24_1;
add v12_1 v10_1 v11_1;
mov out14_24_2 v12_1;
mov c0_1 out14_0_2;
mov c1_1 out14_8_2;
mov c2_1 out14_16_2;
mov c3_1 out14_24_2;
{ c0_1 + (c1_1 * 72057594037927936) + (c2_1 * 5192296858534827628530496329220096) + (c3_1 * 374144419156711147060143317175368453031918731001856) = a0_0 + (a1_0 * 72057594037927936) + (a2_0 * 5192296858534827628530496329220096) + (a3_0 * 374144419156711147060143317175368453031918731001856) + b0_0 + (b1_0 * 72057594037927936) + (b2_0 * 5192296858534827628530496329220096) + (b3_0 * 374144419156711147060143317175368453031918731001856) (mod 26959946667150639794667015087019630673637144422540572481103610249216 - 79228162514264337593543950336 + 1) && and [c0_1 <u 288230376151711744@64, c1_1 <u 288230376151711744@64, c2_1 <u 288230376151711744@64, c3_1 <u 288230376151711744@64] }
