proc main(uint64 a0_0, uint64 a1_0, uint64 a2_0, uint64 a3_0, uint64 a4_0, uint64 a5_0, uint64 a6_0, uint64 a7_0, uint64 a8_0, uint64 b0_0, uint64 b1_0, uint64 b2_0, uint64 b3_0, uint64 b4_0, uint64 b5_0, uint64 b6_0, uint64 b7_0, uint64 b8_0) =
{ true && and [a0_0 <u 5188146770730827776@64, a1_0 <u 5188146770730827776@64, a2_0 <u 5188146770730827776@64, a3_0 <u 5188146770730827776@64, a4_0 <u 5188146770730827776@64, a5_0 <u 5188146770730827776@64, a6_0 <u 5188146770730827776@64, a7_0 <u 5188146770730827776@64, a8_0 <u 5188146770730827776@64, b0_0 <u 3458764513820639232@64, b1_0 <u 3458764513820639232@64, b2_0 <u 3458764513820639232@64, b3_0 <u 3458764513820639232@64, b4_0 <u 3458764513820639232@64, b5_0 <u 3458764513820639232@64, b6_0 <u 3458764513820639232@64, b7_0 <u 3458764513820639232@64, b8_0 <u 3458764513820639232@64] }
mov in1191_0_1 a0_0;
mov in1191_8_1 a1_0;
mov in1191_16_1 a2_0;
mov in1191_24_1 a3_0;
mov in1191_32_1 a4_0;
mov in1191_40_1 a5_0;
mov in1191_48_1 a6_0;
mov in1191_56_1 a7_0;
mov in1191_64_1 a8_0;
mov in2190_0_1 b0_0;
mov in2190_8_1 b1_0;
mov in2190_16_1 b2_0;
mov in2190_24_1 b3_0;
mov in2190_32_1 b4_0;
mov in2190_40_1 b5_0;
mov in2190_48_1 b6_0;
mov in2190_56_1 b7_0;
mov in2190_64_1 b8_0;
mov v202_1 in2190_0_1;
mov v203_1 in2190_8_1;
mul v204_1 v203_1 2@uint64;
mov v205_1 in2190_16_1;
mul v206_1 v205_1 2@uint64;
mov v207_1 in2190_24_1;
mul v208_1 v207_1 2@uint64;
mov v209_1 in2190_32_1;
mul v210_1 v209_1 2@uint64;
mov v211_1 in2190_40_1;
mul v212_1 v211_1 2@uint64;
mov v213_1 in2190_48_1;
mul v214_1 v213_1 2@uint64;
mov v215_1 in2190_56_1;
mul v216_1 v215_1 2@uint64;
mov v217_1 in2190_64_1;
mul v218_1 v217_1 2@uint64;
mov v1_1 in1191_0_1;
mulj v4_1 v1_1 v202_1;
mulj v6_1 v1_1 v203_1;
mov v7_1 in1191_8_1;
mulj v9_1 v202_1 v7_1;
add v290_1 v6_1 v9_1;
mulj v12_1 v1_1 v205_1;
mulj v13_1 v203_1 v7_1;
add v277_1 v12_1 v13_1;
mov v15_1 in1191_16_1;
mulj v17_1 v202_1 v15_1;
add v278_1 v17_1 v277_1;
mulj v20_1 v1_1 v207_1;
mulj v21_1 v7_1 v205_1;
add v265_1 v20_1 v21_1;
mov v23_1 in1191_24_1;
mulj v25_1 v202_1 v23_1;
mulj v26_1 v203_1 v15_1;
add v266_1 v25_1 v265_1;
add v267_1 v26_1 v266_1;
mulj v30_1 v1_1 v209_1;
mulj v31_1 v7_1 v207_1;
add v253_1 v30_1 v31_1;
mulj v33_1 v203_1 v23_1;
mulj v34_1 v205_1 v15_1;
add v254_1 v33_1 v253_1;
add v255_1 v34_1 v254_1;
mov v37_1 in1191_32_1;
mulj v39_1 v202_1 v37_1;
add v256_1 v39_1 v255_1;
mulj v42_1 v1_1 v211_1;
mulj v43_1 v7_1 v209_1;
add v242_1 v42_1 v43_1;
mulj v45_1 v205_1 v23_1;
mulj v46_1 v15_1 v207_1;
add v243_1 v45_1 v242_1;
add v244_1 v46_1 v243_1;
mov v49_1 in1191_40_1;
mulj v51_1 v202_1 v49_1;
mulj v52_1 v203_1 v37_1;
add v245_1 v51_1 v244_1;
add v246_1 v52_1 v245_1;
mulj v56_1 v1_1 v213_1;
mulj v57_1 v7_1 v211_1;
add v231_1 v56_1 v57_1;
mulj v59_1 v207_1 v23_1;
mulj v60_1 v15_1 v209_1;
add v232_1 v59_1 v231_1;
add v233_1 v60_1 v232_1;
mulj v63_1 v203_1 v49_1;
mulj v64_1 v205_1 v37_1;
add v234_1 v63_1 v233_1;
add v235_1 v64_1 v234_1;
mov v67_1 in1191_48_1;
mulj v69_1 v202_1 v67_1;
add v236_1 v69_1 v235_1;
mulj v72_1 v1_1 v215_1;
mulj v73_1 v7_1 v213_1;
add v222_1 v72_1 v73_1;
mulj v75_1 v23_1 v209_1;
mulj v76_1 v15_1 v211_1;
add v223_1 v75_1 v222_1;
add v224_1 v76_1 v223_1;
mulj v79_1 v205_1 v49_1;
mulj v80_1 v207_1 v37_1;
add v225_1 v79_1 v224_1;
add v226_1 v80_1 v225_1;
mov v83_1 in1191_56_1;
mulj v85_1 v202_1 v83_1;
mulj v86_1 v203_1 v67_1;
add v227_1 v85_1 v226_1;
add v88_1 v86_1 v227_1;
mulj v90_1 v1_1 v217_1;
mulj v91_1 v7_1 v215_1;
add v309_1 v90_1 v91_1;
mulj v93_1 v23_1 v211_1;
mulj v94_1 v15_1 v213_1;
add v310_1 v93_1 v309_1;
add v311_1 v94_1 v310_1;
mulj v97_1 v207_1 v49_1;
mulj v98_1 v209_1 v37_1;
add v312_1 v97_1 v311_1;
add v313_1 v98_1 v312_1;
mulj v101_1 v203_1 v83_1;
mulj v102_1 v205_1 v67_1;
add v314_1 v101_1 v313_1;
add v104_1 v102_1 v314_1;
mov v105_1 in1191_64_1;
mulj v107_1 v202_1 v105_1;
add v108_1 v104_1 v107_1;
mov out192_128_1 v108_1;
mulj v110_1 v7_1 v218_1;
mulj v112_1 v15_1 v216_1;
add v113_1 v110_1 v112_1;
mulj v115_1 v37_1 v212_1;
mulj v117_1 v23_1 v214_1;
add v300_1 v4_1 v113_1;
add v301_1 v115_1 v300_1;
mulj v121_1 v67_1 v208_1;
mulj v123_1 v49_1 v210_1;
add v302_1 v117_1 v301_1;
add v303_1 v121_1 v302_1;
mulj v127_1 v105_1 v204_1;
mulj v129_1 v83_1 v206_1;
add v304_1 v123_1 v303_1;
add v305_1 v127_1 v304_1;
add v132_1 v129_1 v305_1;
mov out192_0_1 v132_1;
mulj v133_1 v15_1 v218_1;
mulj v134_1 v23_1 v216_1;
mulj v136_1 v49_1 v212_1;
mulj v137_1 v37_1 v214_1;
mulj v140_1 v83_1 v208_1;
mulj v141_1 v67_1 v210_1;
mulj v144_1 v105_1 v206_1;
add v291_1 v133_1 v290_1;
add v292_1 v134_1 v291_1;
add v293_1 v136_1 v292_1;
add v294_1 v137_1 v293_1;
add v295_1 v140_1 v294_1;
add v296_1 v141_1 v295_1;
add v146_1 v144_1 v296_1;
mov out192_16_1 v146_1;
mulj v147_1 v23_1 v218_1;
mulj v148_1 v37_1 v216_1;
mulj v150_1 v67_1 v212_1;
mulj v151_1 v49_1 v214_1;
mulj v154_1 v105_1 v208_1;
mulj v155_1 v83_1 v210_1;
add v279_1 v147_1 v278_1;
add v280_1 v148_1 v279_1;
add v281_1 v150_1 v280_1;
add v282_1 v151_1 v281_1;
add v283_1 v154_1 v282_1;
add v158_1 v155_1 v283_1;
mov out192_32_1 v158_1;
mulj v159_1 v37_1 v218_1;
mulj v160_1 v49_1 v216_1;
mulj v162_1 v83_1 v212_1;
mulj v163_1 v67_1 v214_1;
mulj v166_1 v105_1 v210_1;
add v268_1 v159_1 v267_1;
add v269_1 v160_1 v268_1;
add v270_1 v162_1 v269_1;
add v271_1 v163_1 v270_1;
add v168_1 v166_1 v271_1;
mov out192_48_1 v168_1;
mulj v169_1 v49_1 v218_1;
mulj v170_1 v67_1 v216_1;
mulj v172_1 v105_1 v212_1;
mulj v173_1 v83_1 v214_1;
add v257_1 v169_1 v256_1;
add v258_1 v170_1 v257_1;
add v259_1 v172_1 v258_1;
add v176_1 v173_1 v259_1;
mov out192_64_1 v176_1;
mulj v177_1 v67_1 v218_1;
mulj v178_1 v83_1 v216_1;
mulj v180_1 v105_1 v214_1;
add v247_1 v177_1 v246_1;
add v248_1 v178_1 v247_1;
add v182_1 v180_1 v248_1;
mov out192_80_1 v182_1;
mulj v183_1 v83_1 v218_1;
mulj v184_1 v105_1 v216_1;
add v237_1 v183_1 v236_1;
add v186_1 v184_1 v237_1;
mov out192_96_1 v186_1;
mulj v187_1 v105_1 v218_1;
add v188_1 v88_1 v187_1;
mov out192_112_1 v188_1;
mov c0_1 out192_0_1;
mov c1_1 out192_16_1;
mov c2_1 out192_32_1;
mov c3_1 out192_48_1;
mov c4_1 out192_64_1;
mov c5_1 out192_80_1;
mov c6_1 out192_96_1;
mov c7_1 out192_112_1;
mov c8_1 out192_128_1;
{ c0_1 + (c1_1 * 288230376151711744) + (c2_1 * 83076749736557242056487941267521536) + (c3_1 * 23945242826029513411849172299223580994042798784118784) + (c4_1 * 6901746346790563787434755862277025452451108972170386555162524223799296) + (c5_1 * 1989292945639146568621528992587283360401824603189390869761855907572637988050133502132224) + (c6_1 * 573374653997517877902705223825521735199141247292070280934397209846730719022121202017504638277531421638656) + (c7_1 * 165263992197562149737978827008192759957101170741070304821162198818601447809077836456297302609928821211897803006255839576064) + (c8_1 * 47634102635436893179040485073748265163400240214004076398607741693502376385799646303105256699577209032590132615988260237052123652332890095616) = (a0_0 + (a1_0 * 288230376151711744) + (a2_0 * 83076749736557242056487941267521536) + (a3_0 * 23945242826029513411849172299223580994042798784118784) + (a4_0 * 6901746346790563787434755862277025452451108972170386555162524223799296) + (a5_0 * 1989292945639146568621528992587283360401824603189390869761855907572637988050133502132224) + (a6_0 * 573374653997517877902705223825521735199141247292070280934397209846730719022121202017504638277531421638656) + (a7_0 * 165263992197562149737978827008192759957101170741070304821162198818601447809077836456297302609928821211897803006255839576064) + (a8_0 * 47634102635436893179040485073748265163400240214004076398607741693502376385799646303105256699577209032590132615988260237052123652332890095616)) * (b0_0 + (b1_0 * 288230376151711744) + (b2_0 * 83076749736557242056487941267521536) + (b3_0 * 23945242826029513411849172299223580994042798784118784) + (b4_0 * 6901746346790563787434755862277025452451108972170386555162524223799296) + (b5_0 * 1989292945639146568621528992587283360401824603189390869761855907572637988050133502132224) + (b6_0 * 573374653997517877902705223825521735199141247292070280934397209846730719022121202017504638277531421638656) + (b7_0 * 165263992197562149737978827008192759957101170741070304821162198818601447809077836456297302609928821211897803006255839576064) + (b8_0 * 47634102635436893179040485073748265163400240214004076398607741693502376385799646303105256699577209032590132615988260237052123652332890095616)) (mod 6864797660130609714981900799081393217269435300143305409394463459185543183397656052122559640661454554977296311391480858037121987999716643812574028291115057152 - 1) && true }
