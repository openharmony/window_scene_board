/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import type { DigitalKeyboardItem } from './DigitalKeyboardItem';
import Constants from '../../common/Constants';
import { ResUtils } from '@ohos/windowscene';

const FATHER_ID: string = '__container__';

/**
 * password constants
 *
 * @since 2023-12-14
 */
export default class PasswordConstants {

  // 密码错误后小圆点向左偏移量
  public static DOT_ERR_ANI_LEFT: number = -5;
  // 密码错误后小圆点向右偏移量
  public static DOT_ERR_ANI_RIGHT: number = 2.5;
  // 密码错误后小圆点默认偏移量
  public static DOT_ERR_ANI_DEFAULT: number = 0;
  // 手机密码键盘按钮上边距
  public static NUM_KEYBOARD_TOP_MARGIN_PHONE: number = 20;
  // 小折叠外屏密码键盘按钮上边距
  public static OUTER_NUM_KEYBOARD_TOP_MARGIN_PHONE: number = 4;
  // 手机密码键盘按钮左边距
  public static NUM_KEYBOARD_LEFT_MARGIN_PHONE: number = 28;
  // 小折叠外屏密码键盘按钮左边距
  public static OUTER_NUM_KEYBOARD_LEFT_MARGIN_PHONE: number = 16;
  // 平板密码键盘按钮上边距
  public static NUM_KEYBOARD_TOP_MARGIN_PAD: number = 39;
  // 手机密码键盘高度
  public static NUM_KEYBOARD_HEIGHT: number = 68;
  // 小折叠外屏手机密码键盘高度
  public static OUTER_NUM_KEYBOARD_HEIGHT: number = 48;
  // 密码逐行延时时间
  public static readonly DELAY_TIME_PER_ROW: number = 60;
  // 图形密码区缩放比例
  public static readonly PATTERN_ZONE_INIT_SCALE: number = 0.7;
  // 数字密码区缩放比例
  public static readonly PSD_ZONE_INIT_SCALE: number = 0.6;
  // 密码动效曲线刚度
  public static readonly PSD_ELEMENT_STIFFNESS: number = 228;
  // 密码动效曲线阻尼
  public static readonly PSD_ELEMENT_DAMPING: number = 30;
  // 密码页返回时延
  public static readonly PSD_BACK_DELAY: number = 50;
  // 密码页返回动效播放时间
  public static readonly PSD_BACK_ANIM_TIME: number = 100;
  // 密码页退场模糊时间
  public static readonly PSD_BACK_BLUR_TIME: number = 400;
  // 密码页进场模糊时间
  public static readonly PSD_ENTER_BLUR_TIME: number = 250;
  // 密码页最大模糊
  public static readonly MAX_PWD_BLUR: number = 50;
  // 密码区默认比例
  public static readonly DEFAULT_SCALE_PWD: number = 1.0;
  // 密码页默认透明度
  public static readonly DEFAULT_OPACITY_PWD: number = 1.0;
  // 密码页最小缩放比例
  public static readonly MIN_ZOOM_RATIO_PWD: number = 0.9;
  // 密码页最小透明度
  public static readonly MIN_OPACITY_PWD: number = 0;
  // 扩展新形态小折叠产品小外屏锁头图标高度
  public static readonly SMALL_FOLD_LOCK_ICON_HEIGHT: number = 16;
  // 扩展新形态小折叠产品小外屏图标锁头宽度
  public static readonly SMALL_FOLD_LOCK_ICON_WIDTH: number = 16;
  // 图标锁头高度
  public static readonly DEFAULT_LOCK_ICON_HEIGHT: number = 24;
  // 图标锁头宽度
  public static readonly DEFAULT_LOCK_ICON_WIDTH: number = 24;
  // tips距离底部边距
  public static readonly TIPS_TEXT_MARGIN_BOTTOM: number = 48;
  // 外屏tips距离底部边距
  public static readonly SMALL_TIPS_TEXT_MARGIN_BOTTOM: number = 8;
  // 外屏tips跑马灯宽度
  public static readonly SMALL_TIPS_TEXT_WIDTH: number = 296;
  // 无障碍朗读密码输入成功播报延迟
  public static readonly ACCESSIBILITY_INPUT_SUCCESS_DOT_CAST_DELAY: number = 500;

  /**
   * 数字密码键盘按钮锚点配置
   */
  public static readonly NUM_POSITION_GROUP_ALIGN: Map<number, AlignRuleOption> = new Map<number, AlignRuleOption>([
    [0, {
      top: { anchor: FATHER_ID, align: VerticalAlign.Top },
      left: { anchor: FATHER_ID, align: HorizontalAlign.Start },
    }],

    [1, {
      top: { anchor: FATHER_ID, align: VerticalAlign.Top },
      middle: { anchor: FATHER_ID, align: HorizontalAlign.Center },
    }],

    [2, {
      top: { anchor: FATHER_ID, align: VerticalAlign.Top },
      right: { anchor: FATHER_ID, align: HorizontalAlign.End },
    }],
  ]);

  /**
   * digital keyboard
   */
  public static readonly NUM_KEYBOARD: DigitalKeyboardItem[] =
    [
      {
        index: 0,
        row1: '1',
        row2: '',
        row3: $r('app.string.keypad_password_one'),
        biasX: -1,
        biasY: 0,
        turnNum: 0,
        value: 1,
        bkg: false,
        needAnimation: true
      },
      {
        index: 1,
        row1: '2',
        row2: 'ABC',
        row3: $r('app.string.keypad_password_two'),
        biasX: 0,
        biasY: 0,
        turnNum: 0,
        value: 2,
        bkg: false,
        needAnimation: true
      },
      {
        index: 2,
        row1: '3',
        row2: 'DEF',
        row3: $r('app.string.keypad_password_three'),
        biasX: 1,
        biasY: 0,
        turnNum: 0,
        value: 3,
        bkg: false,
        needAnimation: true
      },
      {
        index: 3,
        row1: '4',
        row2: 'GHI',
        row3: $r('app.string.keypad_password_four'),
        biasX: -1,
        biasY: 1,
        turnNum: 1,
        value: 4,
        bkg: false,
        needAnimation: true
      },
      {
        index: 4,
        row1: '5',
        row2: 'JKL',
        row3: $r('app.string.keypad_password_five'),
        biasX: 0,
        biasY: 1,
        turnNum: 1,
        value: 5,
        bkg: false,
        needAnimation: true
      },
      {
        index: 5,
        row1: '6',
        row2: 'MNO',
        row3: $r('app.string.keypad_password_six'),
        biasX: 1,
        biasY: 1,
        turnNum: 1,
        value: 6,
        bkg: false,
        needAnimation: true
      },
      {
        index: 6,
        row1: '7',
        row2: 'PQRS',
        row3: $r('app.string.keypad_password_seven'),
        biasX: -1,
        biasY: 2,
        turnNum: 2,
        value: 7,
        bkg: false,
        needAnimation: true
      },
      {
        index: 7,
        row1: '8',
        row2: 'TUV',
        row3: $r('app.string.keypad_password_eight'),
        biasX: 0,
        biasY: 2,
        turnNum: 2,
        value: 8,
        bkg: false,
        needAnimation: true
      },
      {
        index: 8,
        row1: '9',
        row2: 'WXYZ',
        row3: $r('app.string.keypad_password_nine'),
        biasX: 1,
        biasY: 2,
        turnNum: 2,
        value: 9,
        bkg: false,
        needAnimation: true
      },
      {
        index: 9,
        row1: $r('app.string.emergency_call'),
        row2: '',
        row3: $r('app.string.emergency_call'),
        biasX: -1,
        biasY: 3,
        turnNum: 3,
        value: Constants.EMERGENCY_CALL,
        bkg: false,
        needAnimation: true
      },
      {
        index: 10,
        row1: '0',
        row2: '+',
        row3: $r('app.string.keypad_password_zero'),
        biasX: 0,
        biasY: 3,
        turnNum: 3,
        value: 0,
        bkg: false,
        needAnimation: true
      },
      {
        index: 11,
        row1: $r('app.string.psd_back'),
        row2: '',
        row3: $r('app.string.psd_back'),
        biasX: 1,
        biasY: 3,
        turnNum: 3,
        value: Constants.GO_BACK,
        bkg: false,
        needAnimation: true
      }
    ];

  public static readonly RTL_NUM_KEYBOARD: DigitalKeyboardItem[] =
    [{
        index: 0,
        row1: '1',
        row2: '',
        row3: $r('app.string.keypad_password_one'),
        biasX: -1,
        biasY: 0,
        turnNum: 0,
        value: 1,
        bkg: false,
        needAnimation: true
      },
      {
        index: 1,
        row1: '2',
        row2: 'ABC',
        row3: $r('app.string.keypad_password_two'),
        biasX: 0,
        biasY: 0,
        turnNum: 0,
        value: 2,
        bkg: false,
        needAnimation: true
      },
      {
        index: 2,
        row1: '3',
        row2: 'DEF',
        row3: $r('app.string.keypad_password_three'),
        biasX: 1,
        biasY: 0,
        turnNum: 0,
        value: 3,
        bkg: false,
        needAnimation: true
      },
      {
        index: 3,
        row1: '4',
        row2: 'GHI',
        row3: $r('app.string.keypad_password_four'),
        biasX: -1,
        biasY: 1,
        turnNum: 1,
        value: 4,
        bkg: false,
        needAnimation: true
      },
      {
        index: 4,
        row1: '5',
        row2: 'JKL',
        row3: $r('app.string.keypad_password_five'),
        biasX: 0,
        biasY: 1,
        turnNum: 1,
        value: 5,
        bkg: false,
        needAnimation: true
      },
      {
        index: 5,
        row1: '6',
        row2: 'MNO',
        row3: $r('app.string.keypad_password_six'),
        biasX: 1,
        biasY: 1,
        turnNum: 1,
        value: 6,
        bkg: false,
        needAnimation: true
      },
      {
        index: 6,
        row1: '7',
        row2: 'PQRS',
        row3: $r('app.string.keypad_password_seven'),
        biasX: -1,
        biasY: 2,
        turnNum: 2,
        value: 7,
        bkg: false,
        needAnimation: true
      },
      {
        index: 7,
        row1: '8',
        row2: 'TUV',
        row3: $r('app.string.keypad_password_eight'),
        biasX: 0,
        biasY: 2,
        turnNum: 2,
        value: 8,
        bkg: false,
        needAnimation: true
      },
      {
        index: 8,
        row1: '9',
        row2: 'WXYZ',
        row3: $r('app.string.keypad_password_nine'),
        biasX: 1,
        biasY: 2,
        turnNum: 2,
        value: 9,
        bkg: false,
        needAnimation: true
      }, {
        index: 9,
        row1: $r('app.string.psd_back'),
        row2: '',
        row3: $r('app.string.psd_back'),
        biasX: 1,
        biasY: 3,
        turnNum: 3,
        value: Constants.GO_BACK,
        bkg: false,
        needAnimation: true
      },
      {
        index: 10,
        row1: '0',
        row2: '+',
        row3: $r('app.string.keypad_password_zero'),
        biasX: 0,
        biasY: 3,
        turnNum: 3,
        value: 0,
        bkg: false,
        needAnimation: true
      }, {
        index: 11,
        row1: $r('app.string.emergency_call'),
        row2: '',
        row3: $r('app.string.emergency_call'),
        biasX: -1,
        biasY: 3,
        turnNum: 3,
        value: Constants.EMERGENCY_CALL,
        bkg: false,
        needAnimation: true
      }
    ];

  // 按压数字键盘按钮时数字及字母实现vibrancy效果的提亮接口参数
  public static readonly NUMBER_PRESSED_BRIGHTNESS_OPTIONS: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_fraction_on')),
    saturation: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_redCof1')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_redCof2')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_blueCof2'))]
  }
  // 默认状态未按压数字键盘按钮时数字的提亮接口参数
  public static readonly NUMBER_BRIGHTNESS_OPTIONS: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_a')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_b')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_fraction_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_redCof1')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_redCof2')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_text_tertiary_gloss_blueCof2'))]
  }
  // 未按压数字键盘按钮时字母的提亮接口参数
  public static readonly LETTER_BRIGHTNESS_OPTIONS: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_white_font_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_white_font_lightUpDegree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_fraction_on')),
    saturation: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_white_font_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_white_font_redCof1')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_white_font_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_white_font_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_white_font_redCof2')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_white_font_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_white_font_blueCof2'))]
  }
  // 浅色壁纸下未按压数字键盘按钮时字母的提亮接口参数
  public static readonly LETTER_LIGHT_WALLPAPER_BRIGHTNESS_OPTIONS: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_black_font_rate')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_black_font_lightUpDegree')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_fraction_on')),
    saturation: ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_black_font_saturation')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_black_font_redCof1')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_black_font_greenCof1')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_black_font_blueCof1'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_black_font_redCof2')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_black_font_greenCof2')),
      ResUtils.getConvertNumber($r('app.float.num_keyboard_brightness_letter_black_font_blueCof2'))]
  }
}
