/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * 各种字体在字号88的情况下，数字的宽高以及分隔符的宽度，通过getRectInfo接口实测得到；字体更新后，需要同步更新对应数据
 */
export class TextSizeConf {
  public fontSize: number = 88;
  public numberWidth: number = 52;
  public numberHeight: number = 74.76923076923077;
  public separatorWidth: number = 26.76923076923077;
}

let textSizeForHarmonyClock01: TextSizeConf = {
  fontSize: 88,
  numberWidth: 52,
  numberHeight: 74.76923076923077,
  separatorWidth: 26.76923076923077
};

let textSizeForHarmonyClock02: TextSizeConf = {
  fontSize: 88,
  numberWidth: 52,
  numberHeight: 74.76923076923077,
  separatorWidth: 26.76923076923077
};

let textSizeForHarmonyClock03: TextSizeConf = {
  fontSize: 88,
  numberWidth: 52,
  numberHeight: 74.76923076923077,
  separatorWidth: 26.76923076923077
};

let textSizeForHarmonyClock04: TextSizeConf = {
  fontSize: 88,
  numberWidth: 52,
  numberHeight: 74.76923076923077,
  separatorWidth: 30.153846153846153
};

let textSizeForHarmonyClock05: TextSizeConf = {
  fontSize: 88,
  numberWidth: 52,
  numberHeight: 74.76923076923077,
  separatorWidth: 26.153846153846153
};

let textSizeForHarmonyClock06: TextSizeConf = {
  fontSize: 88,
  numberWidth: 51.38461538461539,
  numberHeight: 74.76923076923077,
  separatorWidth: 26.46153846153846
};

let textSizeForHarmonyClock07: TextSizeConf = {
  fontSize: 88,
  numberWidth: 51.38461538461539,
  numberHeight: 74.76923076923077,
  separatorWidth: 25.846153846153847
};

let textSizeForHarmonyClock08: TextSizeConf = {
  fontSize: 88,
  numberWidth: 52,
  numberHeight: 74.76923076923077,
  separatorWidth: 26.76923076923077
};

let textSizeForHarmonyClockUDLayout1: TextSizeConf = {
  fontSize: 50,
  numberWidth: 44.92307692307692,
  numberHeight: 48.61538461538461,
  separatorWidth: 26.153846153846153
};

let textSizeForHarmonyClockUDLayout2_4: TextSizeConf = {
  fontSize: 88,
  numberWidth: 52.61538461538461,
  numberHeight: 72.92307692307692,
  separatorWidth: 26.46153846153846
};

export {
  textSizeForHarmonyClock01 as TEXT_SIZE_FOR_HARMONY_CLOCK_01,
  textSizeForHarmonyClock02 as TEXT_SIZE_FOR_HARMONY_CLOCK_02,
  textSizeForHarmonyClock03 as TEXT_SIZE_FOR_HARMONY_CLOCK_03,
  textSizeForHarmonyClock04 as TEXT_SIZE_FOR_HARMONY_CLOCK_04,
  textSizeForHarmonyClock05 as TEXT_SIZE_FOR_HARMONY_CLOCK_05,
  textSizeForHarmonyClock06 as TEXT_SIZE_FOR_HARMONY_CLOCK_06,
  textSizeForHarmonyClock07 as TEXT_SIZE_FOR_HARMONY_CLOCK_07,
  textSizeForHarmonyClock08 as TEXT_SIZE_FOR_HARMONY_CLOCK_08,
  textSizeForHarmonyClockUDLayout1 as TEXT_SIZE_FOR_HARMONY_CLOCK_UD_LAYOUT1,
  textSizeForHarmonyClockUDLayout2_4 as TEXT_SIZE_FOR_HARMONY_CLOCK_UD_LAYOUT_2_4
};
