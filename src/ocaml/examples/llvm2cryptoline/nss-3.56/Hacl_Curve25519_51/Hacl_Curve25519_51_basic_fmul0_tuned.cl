proc main(uint64 mem0_0_0, uint64 mem0_16_0, uint64 mem0_24_0, uint64 mem0_32_0, uint64 mem0_8_0, uint64 mem1_0_0, uint64 mem1_16_0, uint64 mem1_24_0, uint64 mem1_32_0, uint64 mem1_8_0) =
{ true && and [mem0_0_0 <=u 20266198323167223@64, mem0_8_0 <=u 22517998136852470@64, mem0_16_0 <=u 20266198323167223@64, mem0_24_0 <=u 20266198323167223@64, mem0_32_0 <=u 20266198323167223@64, mem1_0_0 <=u 20266198323167223@64, mem1_8_0 <=u 22517998136852470@64, mem1_16_0 <=u 20266198323167223@64, mem1_24_0 <=u 20266198323167223@64, mem1_32_0 <=u 20266198323167223@64] }
mov v0_1 mem0_0_0;
mov v1_1 mem0_8_0;
mov v2_1 mem0_16_0;
mov v3_1 mem0_24_0;
mov v4_1 mem0_32_0;
mov v5_1 mem1_0_0;
mov v6_1 mem1_8_0;
mov v7_1 mem1_16_0;
mov v8_1 mem1_24_0;
mov v9_1 mem1_32_0;
mul v_mul_1 v6_1 19@uint64;
mul v_mul10_1 v7_1 19@uint64;
mul v_mul11_1 v8_1 19@uint64;
mul v_mul12_1 v9_1 19@uint64;
cast v_conv_i_1@uint128 v0_1;
cast v_conv1_i_1@uint128 v5_1;
mul v_mul_i_1 v_conv1_i_1 v_conv_i_1;
cast v_conv1_i898_1@uint128 v6_1;
mul v_mul_i899_1 v_conv1_i898_1 v_conv_i_1;
cast v_conv1_i890_1@uint128 v7_1;
mul v_mul_i891_1 v_conv1_i890_1 v_conv_i_1;
cast v_conv1_i882_1@uint128 v8_1;
mul v_mul_i883_1 v_conv1_i882_1 v_conv_i_1;
cast v_conv1_i874_1@uint128 v9_1;
mul v_mul_i875_1 v_conv1_i874_1 v_conv_i_1;
cast v_conv_i865_1@uint128 v1_1;
cast v_conv1_i866_1@uint128 v_mul12_1;
mul v_mul_i867_1 v_conv1_i866_1 v_conv_i865_1;
mul v_mul_i845_1 v_conv1_i_1 v_conv_i865_1;
add v_add_i837_1 v_mul_i899_1 v_mul_i845_1;
mul v_mul_i823_1 v_conv1_i898_1 v_conv_i865_1;
mul v_mul_i801_1 v_conv1_i890_1 v_conv_i865_1;
mul v_mul_i779_1 v_conv1_i882_1 v_conv_i865_1;
cast v_conv_i755_1@uint128 v2_1;
cast v_conv1_i756_1@uint128 v_mul11_1;
mul v_mul_i757_1 v_conv1_i756_1 v_conv_i755_1;
mul v_mul_i735_1 v_conv1_i866_1 v_conv_i755_1;
mul v_mul_i713_1 v_conv1_i_1 v_conv_i755_1;
mul v_mul_i691_1 v_conv1_i898_1 v_conv_i755_1;
mul v_mul_i669_1 v_conv1_i890_1 v_conv_i755_1;
cast v_conv_i645_1@uint128 v3_1;
cast v_conv1_i646_1@uint128 v_mul10_1;
mul v_mul_i647_1 v_conv1_i646_1 v_conv_i645_1;
mul v_mul_i625_1 v_conv1_i756_1 v_conv_i645_1;
mul v_mul_i603_1 v_conv1_i866_1 v_conv_i645_1;
mul v_mul_i581_1 v_conv1_i_1 v_conv_i645_1;
mul v_mul_i559_1 v_conv1_i898_1 v_conv_i645_1;
cast v_conv_i535_1@uint128 v4_1;
cast v_conv1_i536_1@uint128 v_mul_1;
mul v_mul_i537_1 v_conv1_i536_1 v_conv_i535_1;
add v_add_i859_1 v_mul_i537_1 v_mul_i_1;
add v_add_i749_1 v_add_i859_1 v_mul_i647_1;
add v_add_i639_1 v_add_i749_1 v_mul_i757_1;
add v_add_i529_1 v_add_i639_1 v_mul_i867_1;
mul v_mul_i515_1 v_conv1_i646_1 v_conv_i535_1;
mul v_mul_i493_1 v_conv1_i756_1 v_conv_i535_1;
mul v_mul_i471_1 v_conv1_i866_1 v_conv_i535_1;
mul v_mul_i449_1 v_conv1_i_1 v_conv_i535_1;
cast v_retval_sroa_0_0_extract_trunc_i433_1@uint64 v_add_i529_1;
and v_and_1@uint64 v_retval_sroa_0_0_extract_trunc_i433_1 2251799813685247@uint64;
split v_shr_i424_1 tmp_to_be_used_1 v_add_i529_1 51;
vpc tmp_v_1@uint64 tmp_to_be_used_1;
assume tmp_v_1 = v_and_1 && true;
and v_y_sroa_0_0_insert_ext_i413_1@uint128 v_shr_i424_1 18446744073709551615@uint128;
vpc tmp_cast_1@uint64 v_shr_i424_1;
cast tmp_cast_2@uint128 tmp_cast_1;
assume tmp_cast_2 = v_y_sroa_0_0_insert_ext_i413_1 && true;
add v_add_i727_1 v_add_i837_1 v_mul_i515_1;
add v_add_i617_1 v_add_i727_1 v_mul_i625_1;
add v_add_i507_1 v_add_i617_1 v_mul_i735_1;
add v_add_i414_1 v_add_i507_1 v_y_sroa_0_0_insert_ext_i413_1;
cast v_retval_sroa_0_0_extract_trunc_i415_1@uint64 v_add_i414_1;
and v_and162_1@uint64 v_retval_sroa_0_0_extract_trunc_i415_1 2251799813685247@uint64;
split v_shr_i404_1 tmp_to_be_used_2 v_add_i414_1 51;
vpc tmp_v_2@uint64 tmp_to_be_used_2;
assume tmp_v_2 = v_and162_1 && true;
and v_y_sroa_0_0_insert_ext_i393_1@uint128 v_shr_i404_1 18446744073709551615@uint128;
vpc tmp_cast_3@uint64 v_shr_i404_1;
cast tmp_cast_4@uint128 tmp_cast_3;
assume tmp_cast_4 = v_y_sroa_0_0_insert_ext_i393_1 && true;
add v_add_i815_1 v_mul_i823_1 v_mul_i713_1;
add v_add_i705_1 v_add_i815_1 v_mul_i891_1;
add v_add_i595_1 v_add_i705_1 v_mul_i493_1;
add v_add_i485_1 v_add_i595_1 v_mul_i603_1;
add v_add_i394_1 v_add_i485_1 v_y_sroa_0_0_insert_ext_i393_1;
split v_shr_i384_1 tmp_to_be_used_3 v_add_i394_1 51;
and v_y_sroa_0_0_insert_ext_i373_1@uint128 v_shr_i384_1 18446744073709551615@uint128;
vpc tmp_cast_5@uint64 v_shr_i384_1;
cast tmp_cast_6@uint128 tmp_cast_5;
assume tmp_cast_6 = v_y_sroa_0_0_insert_ext_i373_1 && true;
add v_add_i793_1 v_mul_i691_1 v_mul_i581_1;
add v_add_i683_1 v_add_i793_1 v_mul_i801_1;
add v_add_i573_1 v_add_i683_1 v_mul_i883_1;
add v_add_i463_1 v_add_i573_1 v_mul_i471_1;
add v_add_i374_1 v_add_i463_1 v_y_sroa_0_0_insert_ext_i373_1;
mov v10_0_1 v_add_i394_1;
nondet undef_1_1@uint128;
mov v10_1_1 undef_1_1;
mov v11_0_1 v10_0_1;
mov v11_1_1 v_add_i374_1;
cast v12_0_1@uint64 v11_0_1;
cast v12_1_1@uint64 v11_1_1;
and v13_0_1@uint64 v12_0_1 2251799813685247@uint64;
and v13_1_1@uint64 v12_1_1 2251799813685247@uint64;
vpc tmp_v_3@uint64 tmp_to_be_used_3;
assume tmp_v_3 = v13_0_1 && true;
split v_shr_i364_1 tmp_to_be_used_4 v_add_i374_1 51;
vpc tmp_v_4@uint64 tmp_to_be_used_4;
assume tmp_v_4 = v13_1_1 && true;
and v_y_sroa_0_0_insert_ext_i_1@uint128 v_shr_i364_1 18446744073709551615@uint128;
vpc tmp_cast_7@uint64 v_shr_i364_1;
cast tmp_cast_8@uint128 tmp_cast_7;
assume tmp_cast_8 = v_y_sroa_0_0_insert_ext_i_1 && true;
add v_add_i771_1 v_mul_i559_1 v_mul_i449_1;
add v_add_i661_1 v_add_i771_1 v_mul_i669_1;
add v_add_i551_1 v_add_i661_1 v_mul_i779_1;
add v_add_i441_1 v_add_i551_1 v_mul_i875_1;
add v_add_i_1 v_add_i441_1 v_y_sroa_0_0_insert_ext_i_1;
cast v_retval_sroa_0_0_extract_trunc_i355_1@uint64 v_add_i_1;
and v_and204_1@uint64 v_retval_sroa_0_0_extract_trunc_i355_1 2251799813685247@uint64;
split v_shr_i_1 tmp_to_be_used_5 v_add_i_1 51;
vpc tmp_v_5@uint64 tmp_to_be_used_5;
assume tmp_v_5 = v_and204_1 && true;
vpc v_retval_sroa_0_0_extract_trunc_i347_1@uint64 v_shr_i_1;
mul v_mul210_1 v_retval_sroa_0_0_extract_trunc_i347_1 19@uint64;
add v_add_1 v_mul210_1 v_and_1;
and v_and211_1@uint64 v_add_1 2251799813685247@uint64;
split v_shr_1 tmp_to_be_used_6 v_add_1 51;
vpc tmp_v_6@uint64 tmp_to_be_used_6;
assume tmp_v_6 = v_and211_1 && true;
add v_add212_1 v_shr_1 v_and162_1;
mov mem2_0_1 v_and211_1;
mov mem2_8_1 v_add212_1;
mov mem2_16_1 v13_0_1;
mov mem2_24_1 v13_1_1;
mov mem2_32_1 v_and204_1;
{ mem2_0_1 + (mem2_8_1 * 2251799813685248) + (mem2_16_1 * 5070602400912917605986812821504) + (mem2_24_1 * 11417981541647679048466287755595961091061972992) + (mem2_32_1 * 25711008708143844408671393477458601640355247900524685364822016) = (mem0_0_0 + (mem0_8_0 * 2251799813685248) + (mem0_16_0 * 5070602400912917605986812821504) + (mem0_24_0 * 11417981541647679048466287755595961091061972992) + (mem0_32_0 * 25711008708143844408671393477458601640355247900524685364822016)) * (mem1_0_0 + (mem1_8_0 * 2251799813685248) + (mem1_16_0 * 5070602400912917605986812821504) + (mem1_24_0 * 11417981541647679048466287755595961091061972992) + (mem1_32_0 * 25711008708143844408671393477458601640355247900524685364822016)) (mod 57896044618658097711785492504343953926634992332820282019728792003956564819968 - 19) && and [tmp_v_1 = v_and_1, tmp_cast_2 = v_y_sroa_0_0_insert_ext_i413_1, tmp_v_2 = v_and162_1, tmp_cast_4 = v_y_sroa_0_0_insert_ext_i393_1, tmp_cast_6 = v_y_sroa_0_0_insert_ext_i373_1, tmp_v_3 = v13_0_1, tmp_v_4 = v13_1_1, tmp_cast_8 = v_y_sroa_0_0_insert_ext_i_1, tmp_v_5 = v_and204_1, tmp_v_6 = v_and211_1, mem2_0_1 <=u 2251799813685247@64, mem2_8_1 <=u 2251799813693439@64, mem2_16_1 <=u 2251799813685247@64, mem2_24_1 <=u 2251799813685247@64, mem2_32_1 <=u 2251799813685247@64] }
