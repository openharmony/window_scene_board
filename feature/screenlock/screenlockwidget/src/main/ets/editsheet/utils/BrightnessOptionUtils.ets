/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

const TAG = 'BrightnessOptionUtils';

export class BrightnessOptionUtils {
  // 顶部按钮底板浅色模式
  public static readonly backgroundSixOption: BrightnessOptions = {
    rate: 0.5895,
    lightUpDegree: 0.46,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.5,
    negRGB: [1.2, 1.8, 1],
    posRGB: [2, 2.2, 0.5],
  }

  // 时钟编辑框浅色模式
  public static readonly backgroundSevenOption: BrightnessOptions = {
    rate: 0.5125,
    lightUpDegree: 0.464,
    cubicCoeff: -0.3902,
    quadCoeff: 0.3723,
    fraction: 0,
    saturation: 1.5,
    negRGB: [1.5, 1.5, 0.5],
    posRGB: [1.2, 2.2, 1],
  }

  // 顶部按钮底板深色模式
  public static readonly backgroundSevenDarkOption: BrightnessOptions = {
    rate: 0.89,
    lightUpDegree: -0.0884,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.5,
    negRGB: [-0.1, 0.1, 0.2],
    posRGB: [1, 1.3, 0.5],
  };

  // 编辑底板浅色模式
  public static readonly brightnessBgLight: BrightnessOptions = {
    rate: 0.945,
    lightUpDegree: 0.0966,
    cubicCoeff: 0,
    quadCoeff: -0.2381,
    fraction: 0,
    saturation: 1.8,
    negRGB: [1.2, 0.8, 1],
    posRGB: [0.7, 0.5, 1],
  }

  // 编辑底板深色模式
  public static readonly brightnessBgDark: BrightnessOptions = {
    rate: 0.8,
    lightUpDegree: 0.2353,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.1,
    negRGB: [1, 1.2, 1],
    posRGB: [2.5, 2, 1],
  }

  // 一级菜单高亮浅色模式
  public static readonly highlightBgLight: BrightnessOptions = {
    rate: 1,
    lightUpDegree: 0.0588,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    negRGB: [1, 1, 1],
    posRGB: [1, 0.7, 1],
  }

  // 二级菜单高亮浅色模式
  public static readonly highlightBgSecondaryLight: BrightnessOptions = {
    rate: 1,
    lightUpDegree: 0.0196,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    negRGB: [1, 1, 1],
    posRGB: [1, 0.7, 1],
  }

  // 一级菜单高亮深色模式
  public static readonly highlightBgDark: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -0.0588,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    negRGB: [0.3, 0.7, 1],
    posRGB: [0.4, 0.5, 0.5],
  }

  // 二级菜单高亮深色模式
  public static readonly highlightBgSecondaryDark: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -0.0196,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    negRGB: [0.3, 0.7, 1],
    posRGB: [0.4, 0.5, 0.5],
  }

  // 二级菜单选中高亮浅色模式
  public static readonly selectBgSecondaryLight: BrightnessOptions = {
    rate: 1,
    lightUpDegree: 0.0588,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    negRGB: [1, 1, 1],
    posRGB: [1, 0.7, 1],
  }

  // 二级菜单选中高亮深色模式
  public static readonly selectBgSecondaryDark: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -0.0588,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    negRGB: [0.3, 0.7, 1],
    posRGB: [0.4, 0.5, 0.5],
  }

  // 深色前景
  public static readonly foregroundSecondaryOption: BrightnessOptions = {
    rate: 0.3573,
    lightUpDegree: 0.0904,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.5,
    posRGB: [7, 10, 7],
    negRGB: [11, 11, 7.9],
  }

  // 浅色前景
  public static readonly foregroundSecondaryDarkOption: BrightnessOptions = {
    rate: 1,
    lightUpDegree: 0.6,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    negRGB: [1, 2, 1],
    posRGB: [0.5, 1, 0.5],
  }

  // 输入框、粗分隔线
  public static readonly inputLineOption: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -0.04,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.1,
    negRGB: [0.3, 1, 1],
    posRGB: [0.4, 0.5, 0.5],
  }

  // 细分隔线深色模式
  public static readonly lineOption: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -0.098,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    negRGB: [0.3, 1, 1],
    posRGB: [0.4, 0.5, 0.5],
  }

  // 合体字半模态卡片背板提亮参数-浅色模式
  public static FORM_BACKGROUND_LIGHT: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -55 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 2,
    negRGB: [2.3, 4.5, 2],
    posRGB: [0.5, 2, 0.5],
  };

  // 合体字半模态卡片背板提亮参数-深色模式
  public static FORM_BACKGROUND_DARK: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -15 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 2,
    negRGB: [2.3, 4.5, 2],
    posRGB: [0.5, 2, 0.5],
  };
}