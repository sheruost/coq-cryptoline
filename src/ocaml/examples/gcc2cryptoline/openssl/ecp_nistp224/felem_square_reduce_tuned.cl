proc main(uint64 a0_0, uint64 a1_0, uint64 a2_0, uint64 a3_0, uint64 a4_0) =
{ true && and [a0_0 <u 1152921504606846976@64, a1_0 <u 1152921504606846976@64, a2_0 <u 1152921504606846976@64, a3_0 <u 1152921504606846976@64] }
mov in2_0_1 a0_0;
mov in2_8_1 a1_0;
mov in2_16_1 a2_0;
mov in2_24_1 a3_0;
mov v59_1 in2_0_1;
mul tmp060_1 v59_1 2@uint64;
mov v61_1 in2_8_1;
mul tmp162_1 v61_1 2@uint64;
mov v63_1 in2_16_1;
mul tmp264_1 v63_1 2@uint64;
mulj v66_1 v59_1 v59_1;
mulj v68_1 v59_1 tmp162_1;
mulj v70_1 v59_1 tmp264_1;
mulj v72_1 v61_1 v61_1;
mov value_lo_1 0@uint64;
mov value_hi_1 9223372036854775680@uint64;
join value_1 value_hi_1 value_lo_1;
add v90_1 v72_1 value_1;
mov v74_1 in2_24_1;
mulj v77_1 v74_1 tmp060_1;
mulj v78_1 tmp264_1 v61_1;
add v79_1 v77_1 v78_1;
mulj v80_1 tmp162_1 v74_1;
mulj v82_1 v63_1 v63_1;
mulj v84_1 tmp264_1 v74_1;
mulj v85_1 v74_1 v74_1;
mov value_lo_2 32768@uint64;
mov value_hi_2 9223372036854775808@uint64;
join value_2 value_hi_2 value_lo_2;
add v8_1 v66_1 value_2;
mov value_lo_3 18410715276690587648@uint64;
mov value_hi_3 9223372036854775679@uint64;
join value_3 value_hi_3 value_lo_3;
add v10_1 v68_1 value_3;
add v12_1 v70_1 v90_1;
split v16_1 tmp_to_use_1 v85_1 16;
add v91_1 v16_1 v80_1;
add v17_1 v82_1 v91_1;
split tmp1_1 tmp2_1 v85_1 88;
shl v18_1 tmp2_1 40;
mov value_lo_4 72056494526300160@uint64;
mov value_hi_4 0@uint64;
join value_4 value_hi_4 value_lo_4;
and v19_1@uint128 v18_1 value_4;
assume v19_1 = tmp_to_use_1 * 1099511627776 && true;
add v20_1 v19_1 v79_1;
sub v21_1 v12_1 v85_1;
split v23_1 tmp_to_use_2 v84_1 16;
add v24_1 v20_1 v23_1;
split tmp1_2 tmp2_2 v84_1 88;
shl v25_1 tmp2_2 40;
mov value_lo_5 72056494526300160@uint64;
mov value_hi_5 0@uint64;
join value_5 value_hi_5 value_lo_5;
and v26_1@uint128 v25_1 value_5;
assume v26_1 = tmp_to_use_2 * 1099511627776 && true;
add v27_1 v21_1 v26_1;
sub v28_1 v10_1 v84_1;
split v29_1 tmp_to_use_3 v17_1 16;
add v30_1 v27_1 v29_1;
split tmp1_3 tmp2_3 v17_1 88;
shl v31_1 tmp2_3 40;
mov value_lo_6 72056494526300160@uint64;
mov value_hi_6 0@uint64;
join value_6 value_hi_6 value_lo_6;
and v32_1@uint128 v31_1 value_6;
assume v32_1 = tmp_to_use_3 * 1099511627776 && true;
add v33_1 v28_1 v32_1;
sub v34_1 v8_1 v17_1;
split v35_1 tmp_to_use_4 v30_1 56;
add v36_1 v24_1 v35_1;
mov value_lo_7 72057594037927935@uint64;
mov value_hi_7 0@uint64;
join value_7 value_hi_7 value_lo_7;
and v37_1@uint128 v30_1 value_7;
assume v37_1 = tmp_to_use_4 && true;
split v38_1 tmp_to_use_5 v36_1 56;
mov value_lo_8 72057594037927935@uint64;
mov value_hi_8 0@uint64;
join value_8 value_hi_8 value_lo_8;
and v39_1@uint128 v36_1 value_8;
assume v39_1 = tmp_to_use_5 && true;
split v40_1 tmp_to_use_6 v36_1 72;
add v41_1 v37_1 v40_1;
split tmp1_4 tmp2_4 v38_1 88;
shl v42_1 tmp2_4 40;
mov value_lo_9 72056494526300160@uint64;
mov value_hi_9 0@uint64;
join value_9 value_hi_9 value_lo_9;
and v43_1@uint128 v42_1 value_9;
assume v43_1 + (v40_1 * 1099511627776 * 65536) = v38_1 * 1099511627776 && true;
add v44_1 v33_1 v43_1;
sub v45_1 v34_1 v38_1;
split v46_1 tmp_to_use_7 v45_1 56;
add v47_1 v44_1 v46_1;
cast v48_1@uint64 v45_1;
and v49_1@uint64 v48_1 72057594037927935@uint64;
vpc tmp_to_use_p_1@uint64 tmp_to_use_7;
assume v49_1 = tmp_to_use_7 && true;
mov out4_0_1 v49_1;
split v50_1 tmp_to_use_8 v47_1 56;
add v51_1 v41_1 v50_1;
cast v52_1@uint64 v47_1;
and v53_1@uint64 v52_1 72057594037927935@uint64;
vpc tmp_to_use_p_2@uint64 tmp_to_use_8;
assume v53_1 = tmp_to_use_8 && true;
mov out4_8_1 v53_1;
split v54_1 tmp_to_use_9 v51_1 56;
add v55_1 v39_1 v54_1;
cast v56_1@uint64 v51_1;
and v57_1@uint64 v56_1 72057594037927935@uint64;
vpc tmp_to_use_p_3@uint64 tmp_to_use_9;
assume v57_1 = tmp_to_use_9 && true;
mov out4_16_1 v57_1;
vpc v58_1@uint64 v55_1;
mov out4_24_1 v58_1;
mov c0_1 out4_0_1;
mov c1_1 out4_8_1;
mov c2_1 out4_16_1;
mov c3_1 out4_24_1;
{ c0_1 + (c1_1 * 72057594037927936) + (c2_1 * 5192296858534827628530496329220096) + (c3_1 * 374144419156711147060143317175368453031918731001856) = (a0_0 + (a1_0 * 72057594037927936) + (a2_0 * 5192296858534827628530496329220096) + (a3_0 * 374144419156711147060143317175368453031918731001856)) * (a0_0 + (a1_0 * 72057594037927936) + (a2_0 * 5192296858534827628530496329220096) + (a3_0 * 374144419156711147060143317175368453031918731001856)) (mod 26959946667150639794667015087019630673637144422540572481103610249216 - 79228162514264337593543950336 + 1) && and [v19_1 = mul (tmp_to_use_1) (1099511627776@128), v26_1 = mul (tmp_to_use_2) (1099511627776@128), v32_1 = mul (tmp_to_use_3) (1099511627776@128), v37_1 = tmp_to_use_4, v39_1 = tmp_to_use_5, add (v43_1) (mul (mul (v40_1) (1099511627776@128)) (65536@128)) = mul (v38_1) (1099511627776@128), v49_1 = tmp_to_use_p_1, v53_1 = tmp_to_use_p_2, v57_1 = tmp_to_use_p_3, c0_1 <u 72057594037927936@64, c1_1 <u 72057594037927936@64, c2_1 <u 72057594037927936@64, c3_1 <u add (72057594037927936@64) (65536@64)] }
