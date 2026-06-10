/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import {
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import StyleConfiguration from '../common/StyleConfiguration';

const TAG = 'BrightnessOptionUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const regex = /rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*[\d.]+)?\)/i;

export class BrightnessOptionUtils {
  private static mInstance?: BrightnessOptionUtils;

  public static getInstance(): BrightnessOptionUtils {
    if (!BrightnessOptionUtils.mInstance) {
      BrightnessOptionUtils.mInstance = new BrightnessOptionUtils();
    }
    return BrightnessOptionUtils.mInstance;
  }

  // 用于提亮掺入透明度FF，颜色不生效
  public static brightColor = '#FFFFFFFF';

  // 底板4级
  public static backgroundFourOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_card_four_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_card_four_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_card_four_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_card_four_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_four_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_four_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_card_four_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_four_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_four_blueCof2'))]
  };

  // 底板4级
  public static backgroundFourOptionDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_card_four_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_card_four_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_card_four_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_card_four_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_four_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_four_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_card_four_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_four_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_four_blueCof2_dark'))]
  };

  // 音量条黑色背景 全量调节 light模式
  public static brightnessVolumeBlackBgLight: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_lightUpDegree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_saturation_light')),
    negRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_negRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_negRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_negRGB3'))],
    posRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_posRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_posRGB2_light')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_posRGB3'))]
  };

  // 音量条黑色背景 全量调节 dark模式
  public static brightnessVolumeBlackBgDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_rate_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_lightUpDegree_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_saturation_dark')),
    negRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_negRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_negRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_negRGB3'))],
    posRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_posRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_posRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_posRGB3'))]
  };


  // 音量条黑色背景 单悬浮音量条
  public static brightnessVolumeBlackBg: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_lightUpDegree_Single')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_saturation')),
    negRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_negRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_negRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_negRGB3'))],
    posRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_posRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_posRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_black_bg_posRGB3'))]
  };

  // 音量条白色背景 全量调节 light模式
  public static brightnessVolumeWhiteBgLight: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_rate_light')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_lightUpDegree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_saturation_light')),
    negRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_negRGB1_light')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_negRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_negRGB3'))],
    posRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_posRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_posRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_posRGB3'))]
  };

  // 音量条白色背景 全量调节 dark模式
  public static brightnessVolumeWhiteBgDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_rate_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_lightUpDegree_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_saturation_dark')),
    negRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_negRGB1_dark')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_negRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_negRGB3_dark'))],
    posRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_posRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_posRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_posRGB3_dark'))]
  };

  // 音量条白色背景 单悬浮音量条
  public static brightnessVolumeWhiteBg: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_lightUpDegree_single')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_saturation')),
    negRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_negRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_negRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_negRGB3'))],
    posRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_posRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_posRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_white_bg_posRGB3'))]
  };

  // 音量条堆叠投影 堆叠投影
  public static brightnessVolumeStackingBg: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Volume_brightness_stacking_bg_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Volume_brightness_stacking_bg_lightUpDegree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_Stacking')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Volume_brightness_stacking_bg_saturation')),
    negRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_stacking_bg_negRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_stacking_bg_negRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_stacking_bg_negRGB3'))],
    posRGB: [ResUtils.getConvertNumber($r('app.float.Volume_brightness_stacking_bg_posRGB1')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_stacking_bg_posRGB2')),
      ResUtils.getConvertNumber($r('app.float.Volume_brightness_stacking_bg_posRGB3'))]
  };

  // 底板5级 控制中心通知中心底板使用
  public backgroundFiveOptionDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof2_dark'))]
  };

  // 底板5级 控制中心通知中心底板使用
  public backgroundFiveOptionDark2in1PcType: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_a_dark_pc_mode')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_b_dark_pc_mode')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_n_dark_pc_mode')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof1_dark_pc_mode')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof1_dark_pc_mode')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof1_dark_pc_mode'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof2_dark_pc_mode')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof2_dark_pc_mode')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof2_dark_pc_mode'))]
  };

  // 底板5级 控制中心通知中心底板使用
  public backgroundFiveOptionOnDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_on')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof2_dark'))]
  };

  public getBackgroundFiveOption(isDark: boolean): BrightnessOptions {
    if (DeviceHelper.is2In1DevicePcType()) {
      if (isDark) {
        return this.backgroundFiveOptionDark2in1PcType;
      } else {
        return this.backgroundFiveOption2in1PcType;
      }
    } else {
      if (isDark) {
        return this.backgroundFiveOptionDark;
      } else {
        return this.backgroundFiveOption;
      }
    }
  }

  // 底板5级 控制中心通知中心底板使用
  public backgroundFiveOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof2'))]
  };

  // 底板5级 控制中心通知中心底板使用
  public backgroundFiveOption2in1PcType: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_a_pc_mode')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_b_pc_mode')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_n_pc_mode')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof1_pc_mode')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof1_pc_mode')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof1_pc_mode'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof2_pc_mode')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof2_pc_mode')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof2_pc_mode'))]
  };

  // 控制中心音量条、亮度条背景条使用
  public volumeAndBrightNessBgOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof2'))]
  };

  public volumeAndBrightNessBgOptionDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof2_dark'))]
  };

  // 底板5级 控制中心通知中心底板使用
  public backgroundFiveOptionOn: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_on')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_main_card_blueCof2'))]
  };

  // PC状态栏二级面板浅色模式底板使用
  public statusBarPanelOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_cubic')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_quad')),
    fraction: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Status_bar_panel_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Status_bar_panel_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Status_bar_panel_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Status_bar_panel_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Status_bar_panel_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Status_bar_panel_blueCof2'))]
  };

  // PC状态栏二级面板深色模式底板使用
  public statusBarPanelDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_cubic_dark')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_quad_dark')),
    fraction: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Status_bar_panel_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Status_bar_panel_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Status_bar_panel_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Status_bar_panel_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Status_bar_panel_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Status_bar_panel_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Status_bar_panel_blueCof2_dark'))]
  };

  public backgroundSixOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_card_six_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_card_six_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_card_six_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_card_six_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_six_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_six_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_card_six_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_six_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_six_blueCof2'))]
  }

  public backgroundSevenDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_blueCof2_dark'))]
  };

  public backgroundEightOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_card_eight_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_card_eight_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_card_eight_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_card_eight_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_eight_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_eight_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_card_eight_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_eight_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_card_eight_blueCof2'))]
  };

  public backgroundNineDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_icon_default_bg_brightness')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.phone_clear_brightness_lightUpDegree_off_darkMode')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_blueCof2_dark'))]
  };

  public backgroundTenDarkOption: BrightnessOptions = {
    rate: -0.4514217,
    lightUpDegree: 0.1343258,
    cubicCoeff: -1.2679875,
    quadCoeff: 2.150619,
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: 2,
    posRGB: [0.6, 0.7, 0.5],
    negRGB: [0.4, 1, 0.5]
  };

  // 亮度条背景浅色 定制类型
  public static brightnessBgLight: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightbar_bottom_card_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightbar_bottom_card_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightbar_bottom_card_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightbar_bottom_card_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightbar_bottom_card_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightbar_bottom_card_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightbar_bottom_card_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightbar_bottom_card_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightbar_bottom_card_blueCof2'))]
  }

  // 二级页亮度条选中模式
  public static subpageBrightnessChoosenLight: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_light_lightUpDegree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_light_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_light_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_light_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_light_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_light_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_light_blueCof2'))]
  }

  // 二级页亮度条背景浅色 定制类型
  public static subpageBrightnessBgLight: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_bg_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_bg_light_lightUpDegree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_bg_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_bg_light_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_bg_light_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_bg_light_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_bg_light_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_bg_light_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_subpage_brightness_bg_light_blueCof2'))]
  }

  // 亮度条、亮度条二级页底板背景浅色 定制类型
  public static brightnessSubpageBgLight: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_subpage_bg_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_subpage_bg_light_lightUpDegree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_subpage_bg_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_subpage_bg_light_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_subpage_bg_light_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_subpage_bg_light_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_subpage_bg_light_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_subpage_bg_light_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_subpage_bg_light_blueCof2'))]
  }

  // 亮度条选中浅色模式
  public brightnessChoosenLight: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_blueCof2'))]
  }

  // 亮度条未选中状态
  public brightnessNotChosenLight: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof2'))]
  }

  // 亮度条选中深色模式
  public brightnessChoosenOptionDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_volume_top_card_blueCof2_dark'))]
  }

  public brightnessNotChosenDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof2_dark'))]
  };

  // WIFI 小底板 嵌套型
  public customWifiBg: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof2'))]
  }

  public groupRemainderCount: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_b_cout')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof1_cout')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof2'))]
  }

  public customWifiBgDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof2_dark'))]
  };

  // WIFI 小底板 嵌套型 选中状态
  public customWifiBgOn: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_on')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof2'))]
  }

  public customWifiBgOnDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_on')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_upper_card_blueCof2_dark'))]
  };

  // 通知按钮背景
  public customActionViewBg: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_blueCof2'))]
  }

  // 通知按钮背景 深色
  public customActionViewBgDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_action_view_bg_blueCof2_dark'))]
  }

  // 横幅通知背景
  public static bannerCardOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_cubic')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_quad')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_blueCof2'))]
  }

  // 横幅通知背景 深色
  public static bannerCardDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_cubic_dark')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_quad_dark')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_blueCof2_dark'))]
  }

  // 锁屏卡片背景
  public static keyguardCardOption: BrightnessOptions = {
    rate: 0.9099,
    lightUpDegree: 0.4573725,
    cubicCoeff: 0.25268715,
    quadCoeff: -0.663,
    fraction: 0,
    saturation: 1.5,
    posRGB: [1.2, 1.8, 1],
    negRGB: [2, 2.2, 0.5]
  }

  // 锁屏卡片背景 深色
  public static keyguardCardDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_cubic_dark')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_quad_dark')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_keyguard_card_bg_blueCof2_dark'))]
  }

  public static keyguardImmersiveCardOption: BrightnessOptions = {
    rate: 0.5895,
    lightUpDegree: 0.5098,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.9,
    posRGB: [1.2, 1.8, 1],
    negRGB: [2, 2.2, 0.5]
  }

  public static keyguardImmersiveDarkCardOption: BrightnessOptions = {
    rate: 0.6667,
    lightUpDegree: -0.015686,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 2,
    posRGB: [0.6, 0.7, 0.5],
    negRGB: [0.4, 1, 0.5]
  }

  // 前景哑光1级 黑字
  public foregroundPrimaryOptionLight: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof2'))]
  }

  // 前景哑光1级 黑字 音量条定制
  public static foregroundPrimaryOptionLightVolume: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_b_volume')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_n_volume')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof2'))]
  }

  // 前景哑光1级 黑字 选中
  public foregroundPrimaryOnOptionLight: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_on')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof2'))]
  }

  // 前景哑光1级 白字
  public foregroundPrimaryOptionDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof2_dark'))]
  }

  // 前景哑光1级 白字 音量条定制
  public static foregroundPrimaryOptionDarkVolume: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_b_dark_volume')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_n_dark_volume')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof2_dark'))]
  }

  // 前景哑光1级 白字 选中
  public foregroundPrimaryOnOptionDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_on')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_blueCof2_dark'))]
  }

  // 二级底板上文字、图标使用
  public foregroundPrimaryOptionOnBackgroundDark: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_on_background_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_on_background_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_on_background_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_on_background_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_on_background_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_on_background_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_on_background_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_on_background_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_primary_on_background_blueCof2_dark'))]
  }

  // 前景哑光2级
  public foregroundSecondaryOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_blueCof3'))]
  }

  // 炫彩前景3级 音量条定制
  public static foregroundSecondaryOptionVolume: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_a_volume')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_b_volume')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_n_volume')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_redCof1_volume')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_greenCof1_volume')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_blueCof1_volume'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_greenCof2_volume')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_blueCof3_volume'))]
  }

  // 前景哑光2级深色模式
  public foregroundSecondaryDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_greenCof3_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_blueCof4_dark'))]
  }

  // 炫彩前景3级 音量条定制 深色模式
  public static foregroundSecondaryDarkOptionVolume: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_a_dark_volume')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_b_dark_volume')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_n_dark_volume')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_redCof1_dark_volume')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_greenCof1_dark_volume')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_blueCof1_dark_volume'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_redCof2_dark_volume')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_greenCof3_dark_volume')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_secondary_frosted_blueCof4_dark_volume'))]
  }

  // 前景哑光3级 TODO
  public static foregroundTertiaryOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_blueCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_greenCof2'))]
  }

  // 前景哑光3级深色模式
  public foregroundTertiaryDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_blueCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_tertiary_greenCof2_dark'))]
  }

  // 前景炫彩1级深色模式
  public static foregroundPrimaryGlossDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_blueCof2_dark'))]
  }

  // 前景炫彩1级
  public static foregroundPrimaryGlossOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_foreground_primary_gloss_blueCof2'))]
  }

  // 前景炫彩2级深色模式
  public static foregroundSecondaryGlossDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_blueCof2_dark'))]
  }

  // 前景炫彩2级
  public static foregroundSecondaryGlossOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_icon_secondary_blueCof2'))]
  }

  // 前景炫彩3级 黑字
  public foregroundTertiaryGlossOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_blueCof2'))]
  }

  // 前景炫彩3级深色模式 白字
  public foregroundTertiaryGlossDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_text_tertiary_gloss_blueCof2_dark'))]
  }

  public static foregroundDividerForGroupOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_blueCof2'))],
  }

  public static foregroundDividerForGroupDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_cross_layer_blueCof2_dark'))]
  }

  public foregroundDividerOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_blueCof2'))],
  }

  public foregroundDividerDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_foreground_divider_blueCof2_dark'))]
  }

  public static liveListItemCardOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_lightUpDegree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_cubicCoeff')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_quadCoeff')),
    fraction: ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_fraction')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_live_listitem_card_blueCof2'))]
  }

  public static keyguardTimeDarkOption: BrightnessOptions = {
    rate: 0.2864,
    lightUpDegree: 0.172549,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.5,
    posRGB: [14, 8, 10],
    negRGB: [4, 6, 10],
  }

  public static keyguardTimeDarkOptionForFillColor: BrightnessOptions = {
    rate: 0.2864,
    lightUpDegree: 0.172549,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0.4,
    saturation: 1.5,
    posRGB: [14, 12, 10],
    negRGB: [4, 6, 10],
  }

  public static keyguardTimeLightOption: BrightnessOptions = {
    rate: 0.415,
    lightUpDegree: 0.7684,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0.5,
    saturation: 1.7,
    posRGB: [1, 2, 0.4],
    negRGB: [3, 4, 3],
  }

  public static lockIconNormalOption: BrightnessOptions = {
    rate: 0.415,
    lightUpDegree: 0.7684,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0.98,
    saturation: 1.7,
    posRGB: [1, 2, 0.4],
    negRGB: [3, 4, 3],
  }

  public static keyguardTimeLightOptionForFillColor: BrightnessOptions = {
    rate: 0.415,
    lightUpDegree: 165.95 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0.5,
    saturation: 2,
    posRGB: [1, 2, 0.4],
    negRGB: [3, 4, 3],
  }

  public static aodTimeLightOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Aod_time_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Aod_time_light_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Aod_time_light_cubic_coeff_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Aod_time_light_quad_coeff_default')),
    fraction: 0,
    saturation: ResUtils.getConvertNumber($r('app.float.Aod_time_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Aod_time_light_pos_rgb_p1')),
      ResUtils.getConvertNumber($r('app.float.Aod_time_light_pos_rgb_p2')),
      ResUtils.getConvertNumber($r('app.float.Aod_time_light_pos_rgb_p3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Aod_time_light_neg_reg_p1')),
      ResUtils.getConvertNumber($r('app.float.Aod_time_light_neg_reg_p2')),
      ResUtils.getConvertNumber($r('app.float.Aod_time_light_neg_reg_p3'))],
  }

  public static aodTimeLightOptionForNewEffect: BrightnessOptions = {
    rate: 0.4324,
    lightUpDegree: 0.43137,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.7,
    posRGB: [1, 2, 0.4],
    negRGB: [3, 4, 3],
  }

  public static aodTimeLightOptionForFillColor: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_cubic_coeff_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_quad_coeff_default')),
    fraction: 0.98,
    saturation: ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_pos_rgb_p1')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_pos_rgb_p2')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_pos_rgb_p3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_neg_reg_p1')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_neg_reg_p2')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_neg_reg_p3'))],
  }

  public static aodNtfBgLightOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_cubic_coeff_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_quad_coeff_default')),
    fraction: 1,
    saturation: ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_pos_rgb_p1')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_pos_rgb_p2')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_pos_rgb_p3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_neg_reg_p1')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_neg_reg_p2')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_light_neg_reg_p3'))],
  }

  public aodTimeLightOptionForButtonBgColor: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_cubic_coeff_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_quad_coeff_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_fraction_default')),
    saturation: ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_pos_rgb_p1')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_pos_rgb_p2')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_pos_rgb_p3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_neg_reg_p1')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_neg_reg_p2')),
      ResUtils.getConvertNumber($r('app.float.Keyguard_time_button_bg_light_neg_reg_p3'))],
  }

  public static keyguardCardBackgroundDarkOption: BrightnessOptions = {
    rate: -0.1249,
    lightUpDegree: 0.25,
    cubicCoeff: -0.6795,
    quadCoeff: 1.4696,
    fraction: 0,
    saturation: 1.5,
    posRGB: [0.7, 1, 1],
    negRGB: [1, 1, 1],
  }

  public static keyguardFormDarkOption: BrightnessOptions = {
    rate: 0.4,
    lightUpDegree: 0.2,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0.2,
    saturation: 1,
    posRGB: [11, 9, 10],
    negRGB: [4, 6, 10],
  }

  public static keyguardCardBackgroundLightOption: BrightnessOptions = {
    rate: 0.5975,
    lightUpDegree: 0.2175,
    cubicCoeff: -0.9,
    quadCoeff: 0.985,
    fraction: 0,
    saturation: 1.2,
    posRGB: [1.5, 0.8, 0.5],
    negRGB: [1.8, 1, 0.5],
  }

  /**
   * 锁屏通知aod下提亮底板
   */
  public static aodScreenNtfBaseboardLightOption: BrightnessOptions = {
    rate: 0.2811,
    lightUpDegree: 0.1176,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 3,
    fraction: 0,
    posRGB: [0.6, 0.7, 0],
    negRGB: [0.4, 1, 0.5],
  }

  /**
   * 锁屏通知胶囊第二层底板
   */
  public static aodScreenNtfSecondBoardLightOption: BrightnessOptions = {
    rate: 0.2811,
    lightUpDegree: 0.0784,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 2,
    fraction: 0,
    posRGB: [0.6, 0.7, 0],
    negRGB: [0.4, 1, 0.5],
  }

  /**
   * AOD锁屏卡片前景非赋色场景提亮参数
   */
  public static aodFormFrontLightOption: BrightnessOptions = {
    rate: 0.4324,
    lightUpDegree: 110 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 1.7,
    fraction: 0,
    posRGB: [1, 2, 0.4],
    negRGB: [3, 4, 3],
  }

  /**
   * AOD锁屏卡片前景赋色场景压暗参数
   */
  public static aodFormFrontColorationDarkOption: BrightnessOptions = {
    rate: 0.415,
    lightUpDegree: 130 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 2,
    fraction: 0.4,
    posRGB: [14, 12, 10],
    negRGB: [4, 6, 10],
  }

  /**
   * AOD锁屏卡片前景赋色场景提亮参数
   */
  public static aodFormFrontColorationLightOption: BrightnessOptions = {
    rate: 0.415,
    lightUpDegree: 130 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 2,
    fraction: 0.4,
    posRGB: [1, 2, 0.4],
    negRGB: [3, 4, 3],
  }

  /**
   * AOD锁屏卡片背板提亮参数
   */
  public static aodFormBackboardLightOption: BrightnessOptions = {
    rate: 0.2811,
    lightUpDegree: 0.1176,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 2,
    fraction: 0,
    posRGB: [0.6, 0.7, 0],
    negRGB: [0.4, 1, 0.5],
  }

  public static keyguardFormLightOption: BrightnessOptions = {
    rate: 0.4,
    lightUpDegree: 0.2,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0.2,
    saturation: 1,
    posRGB: [4, 3, 0.2],
    negRGB: [1.6, 3, 3],
  }

  public static keyguardSecondBrightnessOption: BrightnessOptions = {
    rate: 0.415,
    lightUpDegree: 165.95 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0.5,
    saturation: 1.7,
    posRGB: [1, 2, 0.4],
    negRGB: [3, 4, 3],
  }

  public progressBrightnessOption: BrightnessOptions = {
    rate: 0.9093,
    lightUpDegree:  0.0549,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    posRGB: [0.1, 0.2, 0.2],
    negRGB: [1.5, 1.5, 0.2]
  }

  public static keyguardCapsuleBackFirstDarkOption: BrightnessOptions = {
    rate: 0.1864641,
    lightUpDegree: 0.149,
    cubicCoeff: -0.195075,
    quadCoeff: 0.7999605,
    fraction: 0,
    saturation: 1.7,
    posRGB: [0.6, 0.5, 0.5],
    negRGB: [0.3, 1, 1],
  }

  public static keyguardCapsuleBackFirstLightOption: BrightnessOptions = {
    rate: 0.784,
    lightUpDegree: 0.1215686,
    cubicCoeff: -0.6307425,
    quadCoeff: 0.617559,
    fraction: 0,
    saturation: 1.5,
    posRGB: [1, 0.5, 1],
    negRGB: [1.2, 1, 1],
  }


  /**
   * 锁屏扩展区浅色壁纸下提亮参数
   */
  public static readonly CAPSULE_EXTEND_DARK_OPTION: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -20 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 1.2,
    posRGB: [0.8, 0.8, 0.5],
    negRGB: [1, 1, 1],
    fraction: 0
  }

  /**
   * 锁屏扩展区深色壁纸下提亮参数
   */
  public static readonly CAPSULE_EXTEND_LIGHT_OPTION: BrightnessOptions = {
    rate: 1,
    lightUpDegree: 15 / 255,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 1.2,
    posRGB: [0.8, 0.8, 0.5],
    negRGB: [1, 1, 1],
    fraction: 0
  }

  /**
   * 锁屏通知胶囊背板浅色壁纸下提亮参数
   */
  public static readonly keyguardCapsuleBackSecondDarkOption: BrightnessOptions = {
    rate: 0.177,
    lightUpDegree: 0.1176,
    cubicCoeff: -0.2666025,
    quadCoeff: 0.79407,
    saturation: 1.8,
    posRGB: [0.6, 0.5, 0.5],
    negRGB: [0.3, 1, 1],
    fraction: 0
  }

  /**
   * 锁屏通知胶囊背板深色壁纸下提亮参数
   */
  public static readonly keyguardCapsuleBackSecondLightOption: BrightnessOptions = {
    rate: 0.858,
    lightUpDegree: 0.0745,
    cubicCoeff: -0.325125,
    quadCoeff: 0.249747,
    saturation: 1.5,
    posRGB: [1, 0.7, 1],
    negRGB: [1, 1, 1],
    fraction: 0
  }

  public static systemLiveButtonBgCardOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_cubic_coeff_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_quad_coeff_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_fraction_default')),
    saturation: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_pos_rgb_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_pos_rgb_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_pos_rgb_p3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_neg_reg_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_neg_reg_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_neg_reg_p3'))],
  }

  public static systemLiveButtonBgCardDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_cubic_coeff_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_quad_coeff_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_fraction_default')),
    saturation: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_pos_rgb_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_pos_rgb_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_pos_rgb_p3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_neg_reg_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_neg_reg_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_neg_reg_p3'))],
  }

  public static systemLiveButtonOnBgCardOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_light_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_cubic_coeff_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_quad_coeff_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_fraction_default')),
    saturation: ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_light_pos_rgb_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_light_pos_rgb_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_light_pos_rgb_p3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_light_neg_reg_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_light_neg_reg_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_light_neg_reg_p3'))],
  }

  public static systemLiveButtonOnBgCardDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_dark_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_dark_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_cubic_coeff_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_quad_coeff_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_fraction_default')),
    saturation: ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_dark_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_dark_pos_rgb_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_dark_pos_rgb_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_dark_pos_rgb_p3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_dark_neg_reg_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_dark_neg_reg_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_on_bg_dark_neg_reg_p3'))],
  }

  public static systemLiveButtonOffBgCardOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_light_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_cubic_coeff_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_quad_coeff_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_light_fraction_default')),
    saturation: ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_light_pos_rgb_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_light_pos_rgb_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_light_pos_rgb_p3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_light_neg_reg_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_light_neg_reg_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_light_neg_reg_p3'))],
  }

  public static systemLiveButtonOffBgCardDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_dark_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_dark_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_cubic_coeff_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_quad_coeff_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.system_live_button_bg_dark_fraction_default')),
    saturation: ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_dark_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_dark_pos_rgb_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_dark_pos_rgb_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_dark_pos_rgb_p3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_dark_neg_reg_p1')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_dark_neg_reg_p2')),
      ResUtils.getConvertNumber($r('app.float.system_live_button_off_bg_dark_neg_reg_p3'))],
  }

  // 横幅通知背景
  public bannerCardOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_cubic')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_quad')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_n')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_redCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_redCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_blueCof2'))]
  }

  // 横幅通知背景 深色
  public bannerCardDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_a_dark')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_b_dark')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_cubic_dark')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_quad_dark')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Notification_banner_card_bg_blueCof2_dark'))]
  }

  public static immersiveCapBgcLightOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_cubic_coeff')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_quad_coeff')),
    fraction: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_fraction')),
    saturation: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_pos_rgb1')),
      ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_pos_rgb2')),
      ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_pos_rgb3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_neg_rgb1')),
      ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_neg_rgb2')),
      ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_light_neg_rgb3'))],
  }

  public static immersiveCapBgcDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_up_degree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_cubic_coeff')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_quad_coeff')),
    fraction: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_fraction')),
    saturation: ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_pos_rgb1')),
      ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_pos_rgb2')),
      ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_pos_rgb3'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_neg_rgb1')),
      ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_neg_rgb2')),
      ResUtils.getConvertNumber($r('app.float.immersive_cap_extend_text_dark_neg_rgb3'))],
  }

  public static changeColor(color?: string): ResourceColor | undefined {
    let colorWithoutCapacity = BrightnessOptionUtils.removeColorCapacity(color);
    let color16: string = BrightnessOptionUtils.rgbToHex(colorWithoutCapacity);
    let targetColor16 = BrightnessOptionUtils.colorMap.get(color16);
    return targetColor16 ? BrightnessOptionUtils.hexToRgb(targetColor16) : colorWithoutCapacity;
  }

  private static removeColorCapacity(textColor?: string): string {
    if (!textColor) {
      return '';
    }
    const match = textColor.match(regex);
    if (match) {
      const r = match[1];
      const g = match[2];
      const b = match[3];
      const newColor = `rgb(${r}, ${g}, ${b})`;
      return newColor;
    }
    return textColor;
  }

  private static readonly colorMap: Map<string, string> = new Map([
    ['000000', 'E6000000'],
    ['ffffff', 'E6ffffff'],
    ['8981f7', '543BFF'],
    ['86c5e3', '00C5FF'],
    ['92d6cc', '0DE7C5'],
    ['92c48d', '27D416'],
    ['bddb69', '8BED00'],
    ['c386f0', 'ED27FF'],
    ['e67c92', 'FF2062'],
    ['e87361', 'FF1F00'],
    ['ed955f', 'FF5900'],
    ['f9bc64', 'FF9700'],
    ['f5dc62', 'FFD400']
  ]);

  private static hexToRgb(hex: string): string {
    // 判断16进制颜色是否合法
    const regex = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i;
    const result = regex.exec(hex);
    if (!result) {
      return hex;
    }

    // 将16进制转换为10进制
    const r = parseInt(result[1], 16);
    const g = parseInt(result[2], 16);
    const b = parseInt(result[3], 16);

    // 返回RGB颜色
    return `rgb(${r}, ${g}, ${b})`;
  }

  private static rgbToHex(rgb: string): string {
    // 将字符串转为数组，去掉括号和空格
    const rgbArr = rgb.replace(/[^\d,]/g, '').split(',');

    // 将RGB值转为16进制
    const hexArr = rgbArr.map((val) => {
      const hex = Number(val).toString(16);
      return hex.length === 1 ? '0' + hex : hex;
    });

    // 拼接16进制颜色值
    const hexColor = hexArr.join('');

    return hexColor;
  }

  /**
   * 密码页按键前景提亮，深色壁纸下
   */
  public static passwordDarkOption: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -0.07,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    posRGB: [0, 0.2, 0.8],
    negRGB: [0.3, 1.5, 1],
  }
  public static resetPressButtonDarkOption: BrightnessOptions = {
    rate: 1,
    lightUpDegree: -0.07,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    posRGB: [0, 0.2, 0.8],
    negRGB: [0.3, 1.5, 1],
  }

  /**
   * 调整rgb值，a值不变
   *
   * @param color 原颜色
   * @returns 调整后颜色
   */
  public static changeRgb(color?: string): ResourceColor | undefined {
    if (!color) {
      return '';
    }
    const rgba: number[] | undefined = color.match(/\d+(\.\d+)?/g)?.map(Number);
    const change = (value: number) => Math.min(value + 20, 255);
    if (rgba && rgba.length === 4) {
      const r = change(rgba[0]);
      const g = change(rgba[1]);
      const b = change(rgba[2]);
      const a = rgba[3];
      return `rgba(${r}, ${g}, ${b}, ${a})`;
    }
    return color;
  }

  /**
   * 密码页按键前景提亮，浅色壁纸下
   */
  public static passwordLightOption: BrightnessOptions = {
    rate: 1,
    lightUpDegree: 0.07,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    posRGB: [1, 3, 1],
    negRGB: [1, 0.5, 1],
  }
  public static resetPressButtonLightOption: BrightnessOptions = {
    rate: 1,
    lightUpDegree: 0.2,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 0,
    saturation: 1.2,
    posRGB: [1, 3, 1],
    negRGB: [1, 0.5, 1],
  }
}