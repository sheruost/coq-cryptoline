proc main(uint128 a0_0, uint128 a1_0, uint128 a2_0, uint128 a3_0) =
{ true && and [a0_0 <u 649037107316853453566312041152512@128, a1_0 <u 649037107316853453566312041152512@128, a2_0 <u 649037107316853453566312041152512@128, a3_0 <u 649037107316853453566312041152512@128] }
mov in50_0_1 a0_0;
mov in50_16_1 a1_0;
mov in50_32_1 a2_0;
mov in50_48_1 a3_0;
mov v2_1 in50_48_1;
mov value_lo_1 18446744069414584320@uint64;
mov value_hi_1 0@uint64;
join value_1 value_hi_1 value_lo_1;
add v3_1 v2_1 value_1;
mov v4_1 in50_32_1;
split v5_1 tmp_to_use_1 v4_1 64;
add v6_1 v3_1 v5_1;
mov value_lo_2 18446744073709551615@uint64;
mov value_hi_2 0@uint64;
join value_2 value_hi_2 value_lo_2;
and v1_1@uint128 v4_1 value_2;
assume v1_1 = tmp_to_use_1 && true;
mov value_lo_3 18446673704965373952@uint64;
mov value_hi_3 0@uint64;
join value_3 value_hi_3 value_lo_3;
add v8_1 v1_1 value_3;
mov v10_1 in50_0_1;
mov value_lo_4 18446744073709551615@uint64;
mov value_hi_4 0@uint64;
join value_4 value_hi_4 value_lo_4;
add v11_1 v10_1 value_4;
mov v12_1 in50_16_1;
mov value_lo_5 4294967295@uint64;
mov value_hi_5 70368744177664@uint64;
join value_5 value_hi_5 value_lo_5;
add v13_1 v12_1 value_5;
split v14_1 tmp_to_use_2 v6_1 64;
vpc a52_1@uint64 v14_1;
mov value_lo_6 18446744073709551615@uint64;
mov value_hi_6 0@uint64;
join value_6 value_hi_6 value_lo_6;
and v7_1@uint128 v6_1 value_6;
assume v7_1 = tmp_to_use_2 && true;
split tmp1_1 tmp2_1 v14_1 96;
shl v16_1 tmp2_1 32;
assume tmp1_1 = 0 && true;
sub v76_1 v16_1 v14_1;
add v17_1 v7_1 v76_1;
split v18_1 tmp_to_use_3 v17_1 64;
vpc a53_1@uint64 v18_1;
add b54_1 a52_1 a53_1;
mov value_lo_7 18446744073709551615@uint64;
mov value_hi_7 0@uint64;
join value_7 value_hi_7 value_lo_7;
and v9_1@uint128 v17_1 value_7;
assume v9_1 = tmp_to_use_3 && true;
split tmp1_2 tmp2_2 v18_1 96;
shl v20_1 tmp2_2 32;
assume tmp1_2 = 0 && true;
sub v75_1 v20_1 v18_1;
add v21_1 v9_1 v75_1;
vpc v22_1@uint128 b54_1;
add v23_1 v11_1 v22_1;
split tmp1_3 tmp2_3 v22_1 96;
shl v24_1 tmp2_3 32;
assume tmp1_3 = 0 && true;
sub v25_1 v13_1 v24_1;
split v26_1 tmp_to_use_4 v21_1 64;
vpc high55_1@uint64 v26_1;
subb high_1 high56_1 0@uint64 high55_1;
cast low57_1@uint64 v21_1;
vpc tmp_to_use_p_1@uint64 tmp_to_use_4;
assume low57_1 = tmp_to_use_4 && true;
cast v27_1@int64 v21_1;
assume v27_1 = low57_1 && true;
split low_h1bit_1 low_l63bit_1 low57_1 63;
vpc mask_1@uint1 low_h1bit_1;
and low59_1@uint64 low57_1 9223372036854775807@uint64;
adds discarded_1 low60_1 low59_1 9223372041149743103@uint64;
not low61_1@uint64 low60_1;
split low_1 discarded_2 low61_1 63;
vpc low_2@uint1 low_1;
cmov v31_1 mask_1 low_2 0@uint1;
cmov mask63_1 v31_1 1@uint1 high_1;
cmov v32_1 mask63_1 18446744073709551615@uint128 0@uint128;
sub v33_1 v23_1 v32_1;
cmov v34_1 mask63_1 4294967295@uint64 0@uint64;
vpc v35_1@uint128 v34_1;
sub v36_1 v25_1 v35_1;
cmov v37_1 mask63_1 18446744069414584321@uint64 0@uint64;
vpc v38_1@uint128 v37_1;
sub v39_1 v21_1 v38_1;
split v40_1 tmp_to_use_5 v33_1 64;
add v41_1 v36_1 v40_1;
cast v42_1@uint64 v33_1;
vpc tmp_to_use_p_2@uint64 tmp_to_use_5;
assume v42_1 = tmp_to_use_p_2 && true;
split v43_1 tmp_to_use_6 v41_1 64;
add v44_1 v8_1 v43_1;
cast v45_1@uint64 v41_1;
vpc tmp_to_use_p_3@uint64 tmp_to_use_6;
assume v45_1 = tmp_to_use_6 && true;
split v46_1 tmp_to_use_7 v44_1 64;
add v47_1 v39_1 v46_1;
cast v48_1@uint64 v44_1;
vpc tmp_to_use_p_4@uint64 tmp_to_use_7;
assume v48_1 = tmp_to_use_7 && true;
mov out64_0_1 v42_1;
mov out64_8_1 v45_1;
mov out64_16_1 v48_1;
vpc v49_1@uint64 v47_1;
mov out64_24_1 v49_1;
mov c0_1 out64_0_1;
mov c1_1 out64_8_1;
mov c2_1 out64_16_1;
mov c3_1 out64_24_1;
{ c0_1 + (c1_1 * 18446744073709551616) + (c2_1 * 340282366920938463463374607431768211456) + (c3_1 * 6277101735386680763835789423207666416102355444464034512896) = a0_0 + (a1_0 * 18446744073709551616) + (a2_0 * 340282366920938463463374607431768211456) + (a3_0 * 6277101735386680763835789423207666416102355444464034512896) (mod 18446744073709551615 + (4294967295 * 18446744073709551616) + (0 * 340282366920938463463374607431768211456) + (18446744069414584321 * 6277101735386680763835789423207666416102355444464034512896)) && and [v1_1 = tmp_to_use_1, v7_1 = tmp_to_use_2, tmp1_1 = 0@128, v9_1 = tmp_to_use_3, tmp1_2 = 0@128, tmp1_3 = 0@128, low57_1 = tmp_to_use_p_1, v27_1 = low57_1, v42_1 = tmp_to_use_p_2, v45_1 = tmp_to_use_p_3, v48_1 = tmp_to_use_p_4] }
