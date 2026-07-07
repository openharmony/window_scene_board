/**
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
/**
 * layout in password and pin page constants
 *
 * @since 2024-03-07
 */
/**
 * 设备分类 区分设备类型 给不同的布局参数
 *
 * @since 2024-03-07
 */
export enum DeviceClassification {

  /**
   * pad横屏
   */
  PSD_PAD_LANDSCAPE = 0,

  /**
   * pad竖屏
   */
  PSD_PAD_PORTRAIT = 1,

  /**
   * 折叠屏展开态
   */
  PSD_FOLD_EXPAND = 2,

  /**
   * 手机无指纹状态和折叠屏折叠态
   */
  PSD_NO_FINGER = 3,

  /**
   * 低指纹手机，有指纹
   */
  PSD_LOW_FINGER_PRINT_PHONE = 4,

  /**
   * 高指纹手机，有指纹
   */
  PSD_HEIGHT_FINGER_PRINT_PHONE = 5,

  /**
   * 折叠屏展开态-横屏
   */
  PSD_FOLD_EXPAND_HORIZONTAL = 6,
  /**
   * 小折叠屏折叠态
   */
  PSD_SMALL_FOLD_PHONE = 7,
  /**
   * 三折叠屏G态横屏
   */
  PSD_THREE_FOLD_G_HORIZONTAL = 8,
  /**
   * 三折叠屏G态竖屏
   */
  PSD_THREE_FOLD_G_PORTRAIT = 9,
}

/**
 * 拉起keyboard密码页面类型区分
 */
export enum KeyboardPageType {
  /**
   * 数字密码
   */
  PSD_DIGITAL = 0,

  /**
   * 自定义数字密码
   */
  PSD_CUSTOM = 1,

  /**
   * 混合密码
   */
  PSD_MIX = 2,

  /**
   * pin码
   */
  PSD_SIM_CARD = 3,

  /**
   * parttern密码
   */
  PSD_PATTERN = 4,

  /**
   * 四位pin码
   */
  PSD_FOUR = 5,
}

/**
 * 密码页面参数类型声明
 */
export interface PassWordLayout {
  index: DeviceClassification,
  numKeyboardHeight: Resource,
  // 密码键盘距离底部的距离
  psdBottomMargin: Resource,
  digitalPsdFlexMarginNumKeyBoard: Resource,
  customPsdFlexMarginNumKeyBoard: Resource,
  mixPsdFlexMarginNumKeyBoard: Resource,
  patternPSDMarginBottom: Resource,
  textMarginPatternLock: Resource,

}

/**
 * 栅格类型声明
 */
export interface DevicesGrids {
  index: DeviceClassification,
  psdMargin: number,
  psdGutter: number,
  psdColumn: number,
}

/**
 * pin页面参数类型声明
 */
export interface PinLayout {
  index: DeviceClassification,
  pinInputHeight: Resource,
  pinTopFlexHeight: Resource,
  pukTopFlexHeight: Resource,
  pinKeyBoardHeight: Resource,
  pinKeyBoardMarginBottom: Resource,
  pinDialogWidth: Resource,
}

export default class KeyBoardLayoutConstants {
  // 不同设备的栅格的类型
  public static readonly DEVICES_GRIDS: Map<DeviceClassification, DevicesGrids> = new Map([
    // pad横屏
    [
      DeviceClassification.PSD_PAD_LANDSCAPE,
      {
        index: DeviceClassification.PSD_PAD_LANDSCAPE,
        psdMargin: 12,
        psdGutter: 16,
        psdColumn: 12,
      } as DevicesGrids
    ],

    // pad竖屏
    [
      DeviceClassification.PSD_PAD_PORTRAIT,
      {
        index: DeviceClassification.PSD_PAD_PORTRAIT,
        psdMargin: 12,
        psdGutter: 16,
        psdColumn: 8,
      }
    ],

    // 折叠屏展开态
    [
      DeviceClassification.PSD_FOLD_EXPAND,
      {
        index: DeviceClassification.PSD_FOLD_EXPAND,
        psdMargin: 24,
        psdGutter: 24,
        psdColumn: 8,
      }
    ],

    // 手机或折叠屏
    [
      DeviceClassification.PSD_NO_FINGER,
      {
        index: DeviceClassification.PSD_NO_FINGER,
        psdMargin: 24,
        psdGutter: 24,
        psdColumn: 4,
      }
    ],

    // 小折叠屏折叠态
    [
      DeviceClassification.PSD_SMALL_FOLD_PHONE,
      {
        index: DeviceClassification.PSD_SMALL_FOLD_PHONE,
        psdMargin: 24,
        psdGutter: 8,
        psdColumn: 4,
      }
    ],

    // 三折叠G态横屏
    [
      DeviceClassification.PSD_THREE_FOLD_G_HORIZONTAL,
      {
        index: DeviceClassification.PSD_THREE_FOLD_G_HORIZONTAL,
        psdMargin: 24,
        psdGutter: 24,
        psdColumn: 12,
      }
    ]
  ]);
  // 设备密码页面参数
  public static readonly PSD_LAYOUT: Map<DeviceClassification, PassWordLayout> = new Map([
    // pad横屏
    [
      DeviceClassification.PSD_PAD_LANDSCAPE,
      {
        index: DeviceClassification.PSD_PAD_LANDSCAPE,
        numKeyboardHeight: $r('app.float.num_keyboard_height_pad_landscape'),
        psdBottomMargin: $r('app.float.psd_bottom_margin_pad_landscape'),
        digitalPsdFlexMarginNumKeyBoard: $r('app.float.digital_psd_flex_margin_numkeyboard_pad_landscape'),
        customPsdFlexMarginNumKeyBoard: $r('app.float.custom_psd_flex_margin_numkeyboard_pad_landscape'),
        mixPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_pad_landscape'),
        patternPSDMarginBottom: $r('app.float.parttern_psd_flex_margin_numkeyboard_pad_landscape'),
        textMarginPatternLock: $r('app.float.parttern_psd_text_margin_patternlock_pad_landscape'),
      } as PassWordLayout
    ],

    // pad竖屏
    [
      DeviceClassification.PSD_PAD_PORTRAIT,
      {
        index: DeviceClassification.PSD_PAD_PORTRAIT,
        numKeyboardHeight: $r('app.float.num_keyboard_height_pad_portrait'),
        psdBottomMargin: $r('app.float.psd_bottom_margin_pad_portrait'),
        digitalPsdFlexMarginNumKeyBoard: $r('app.float.digital_psd_flex_margin_numkeyboard_pad_portrait'),
        customPsdFlexMarginNumKeyBoard: $r('app.float.custom_psd_flex_margin_numkeyboard_pad_portrait'),
        mixPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_pad_portrait'),
        patternPSDMarginBottom: $r('app.float.parttern_psd_flex_margin_numkeyboard_pad_portrait'),
        textMarginPatternLock: $r('app.float.parttern_psd_text_margin_patternlock_pad_portrait'),
      }
    ],

    // 折叠屏展开态
    [
      DeviceClassification.PSD_FOLD_EXPAND,
      {
        index: DeviceClassification.PSD_FOLD_EXPAND,
        numKeyboardHeight: $r('app.float.num_keyboard_height_fold_expand'),
        psdBottomMargin: $r('app.float.psd_bottom_margin_phone_no_print'), // shuiping 96
        digitalPsdFlexMarginNumKeyBoard: $r('app.float.digital_psd_flex_margin_numkeyboard_fold_expand'),
        customPsdFlexMarginNumKeyBoard: $r('app.float.custom_psd_flex_margin_numkeyboard_fold_expand'),
        mixPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_fold_expand'),
        patternPSDMarginBottom: $r('app.float.parttern_psd_bottom_margin_phone_no_print'), // 114
        textMarginPatternLock: $r('app.float.parttern_psd_text_margin_patternlock_phone'),
      }
    ],

    // 手机无指纹状态和折叠屏折叠态
    [
      DeviceClassification.PSD_NO_FINGER,
      {
        index: DeviceClassification.PSD_NO_FINGER,
        numKeyboardHeight: $r('app.float.num_keyboard_height_phone_no_print'),
        psdBottomMargin: $r('app.float.psd_bottom_margin_phone_no_print'),
        digitalPsdFlexMarginNumKeyBoard: $r('app.float.digital_psd_flex_margin_numkeyboard_phone_no_print'),
        customPsdFlexMarginNumKeyBoard: $r('app.float.custom_psd_flex_margin_numkeyboard_phone_no_print'),
        mixPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_phone_no_print'),
        patternPSDMarginBottom: $r('app.float.parttern_psd_bottom_margin_phone_no_print'),
        textMarginPatternLock: $r('app.float.parttern_psd_text_margin_patternlock_phone'),
      }
    ],

    // 低指纹手机，有指纹
    [
      DeviceClassification.PSD_LOW_FINGER_PRINT_PHONE,
      {
        index: DeviceClassification.PSD_LOW_FINGER_PRINT_PHONE,
        numKeyboardHeight: $r('app.float.num_keyboard_height_phone_low_finger_print'),
        psdBottomMargin: $r('app.float.psd_bottom_margin_phone_low_finger_print'),
        digitalPsdFlexMarginNumKeyBoard: $r('app.float.digital_psd_flex_margin_numkeyboard_phone_low_finger_print'),
        customPsdFlexMarginNumKeyBoard: $r('app.float.custom_psd_flex_margin_numkeyboard_phone_low_finger_print'),
        mixPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_phone_low_finger_print'),
        patternPSDMarginBottom: $r('app.float.parttern_psd_bottom_margin_phone_low_finger_print'),
        textMarginPatternLock: $r('app.float.parttern_psd_text_margin_patternlock_phone'),
      }
    ],

    // 高指纹手机，有指纹
    [
      DeviceClassification.PSD_HEIGHT_FINGER_PRINT_PHONE,
      {
        index: DeviceClassification.PSD_HEIGHT_FINGER_PRINT_PHONE,
        numKeyboardHeight: $r('app.float.num_keyboard_height_phone_height_finger_print'),
        psdBottomMargin: $r('app.float.psd_bottom_margin_phone_height_finger_print'),
        digitalPsdFlexMarginNumKeyBoard: $r('app.float.digital_psd_flex_margin_numkeyboard_phone_height_finger_print'),
        customPsdFlexMarginNumKeyBoard: $r('app.float.custom_psd_flex_margin_numkeyboard_phone_height_finger_print'),
        mixPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_phone_height_finger_print'),
        patternPSDMarginBottom: $r('app.float.parttern_psd_bottom_margin_phone_height_finger_print'),
        textMarginPatternLock: $r('app.float.parttern_psd_text_margin_patternlock_phone'),
      }
    ],

    // 折叠屏展开态-横屏
    [
      DeviceClassification.PSD_FOLD_EXPAND_HORIZONTAL,
      {
        index: DeviceClassification.PSD_FOLD_EXPAND_HORIZONTAL,
        numKeyboardHeight: $r('app.float.num_keyboard_height_fold_expand'),
        psdBottomMargin: $r('app.float.psd_bottom_margin_phone_fold_expand_horizontal'),
        digitalPsdFlexMarginNumKeyBoard: $r('app.float.digital_psd_flex_margin_numkeyboard_fold_expand'),
        customPsdFlexMarginNumKeyBoard: $r('app.float.custom_psd_flex_margin_numkeyboard_fold_expand'),
        mixPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_fold_expand'),
        patternPSDMarginBottom: $r('app.float.parttern_psd_bottom_margin_phone_landscape'), // 横屏86
        textMarginPatternLock: $r('app.float.parttern_psd_text_margin_patternlock_phone'),
      }
    ],

    // 小折叠手机折叠态
    [
      DeviceClassification.PSD_SMALL_FOLD_PHONE,
      {
        index: DeviceClassification.PSD_SMALL_FOLD_PHONE,
        numKeyboardHeight: $r('app.float.num_keyboard_height_phone_small_fold'),
        psdBottomMargin: $r('app.float.psd_bottom_margin_phone_height_small_fold'),
        digitalPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_small_fold'),
        customPsdFlexMarginNumKeyBoard: $r('app.float.custom_psd_flex_margin_numkeyboard_phone_height_finger_print'),
        mixPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_phone_height_finger_print'),
        patternPSDMarginBottom: $r('app.float.parttern_psd_bottom_margin_phone_height_finger_print'),
        textMarginPatternLock: $r('app.float.parttern_psd_text_margin_patternlock_phone'),
      }
    ],

    // 三折叠G态横屏
    [
      DeviceClassification.PSD_THREE_FOLD_G_HORIZONTAL,
      {
        index: DeviceClassification.PSD_THREE_FOLD_G_HORIZONTAL,
        numKeyboardHeight: $r('app.float.num_keyboard_height_fold_expand'),
        psdBottomMargin: $r('app.float.psd_bottom_margin_phone_g_landscape'),
        digitalPsdFlexMarginNumKeyBoard: $r('app.float.digital_psd_flex_margin_numkeyboard_fold_expand'),
        customPsdFlexMarginNumKeyBoard: $r('app.float.custom_psd_flex_margin_numkeyboard_fold_expand'),
        mixPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_fold_expand'),
        patternPSDMarginBottom: $r('app.float.parttern_psd_bottom_margin_phone_no_print'),
        textMarginPatternLock: $r('app.float.parttern_psd_text_margin_patternlock_phone'),
      }
    ],

    // 三折叠G态竖屏
    [
      DeviceClassification.PSD_THREE_FOLD_G_PORTRAIT,
      {
        index: DeviceClassification.PSD_THREE_FOLD_G_PORTRAIT,
        numKeyboardHeight: $r('app.float.num_keyboard_height_fold_expand'),
        psdBottomMargin: $r('app.float.psd_bottom_margin_phone_g_portrait'),
        digitalPsdFlexMarginNumKeyBoard: $r('app.float.digital_psd_flex_margin_numkeyboard_fold_expand'),
        customPsdFlexMarginNumKeyBoard: $r('app.float.custom_psd_flex_margin_numkeyboard_fold_expand'),
        mixPsdFlexMarginNumKeyBoard: $r('app.float.mix_psd_flex_margin_numkeyboard_fold_expand'),
        patternPSDMarginBottom: $r('app.float.parttern_psd_bottom_margin_phone_g_portrait'),
        textMarginPatternLock: $r('app.float.parttern_psd_text_margin_patternlock_phone'),
      }
    ],
  ]);
  // pin码页面参数
  public static readonly PIN_LAYOUT: Map<DeviceClassification, PinLayout> = new Map([
    // pad横屏
    [
      DeviceClassification.PSD_PAD_LANDSCAPE,
      {
        index: DeviceClassification.PSD_PAD_LANDSCAPE,
        pinInputHeight: $r('app.float.pin_input_height_pad'),
        pinTopFlexHeight: $r('app.float.pin_top_flex_height_pad'),
        pukTopFlexHeight: $r('app.float.puk_top_flex_height_pad'),
        pinKeyBoardHeight: $r('app.float.num_keyboard_height_pad_landscape'),
        pinKeyBoardMarginBottom: $r('app.float.pin_keyboard_margin_bottom_pad_landscape'),
        pinDialogWidth: $r('app.float.pin_dialog_width_pad_landscape'),
      } as PinLayout
    ],

    // pad竖屏
    [
      DeviceClassification.PSD_PAD_PORTRAIT,
      {
        index: DeviceClassification.PSD_PAD_PORTRAIT,
        pinInputHeight: $r('app.float.pin_input_height_pad'),
        pinTopFlexHeight: $r('app.float.pin_top_flex_height_pad'),
        pukTopFlexHeight: $r('app.float.puk_top_flex_height_pad'),
        pinKeyBoardHeight: $r('app.float.num_keyboard_height_pad_portrait'),
        pinKeyBoardMarginBottom: $r('app.float.pin_keyboard_margin_bottom_pad_portrait'),
        pinDialogWidth: $r('app.float.pin_dialog_width_pad_portrait'),
      }
    ],
    // 折叠屏展开态-竖屏
    [
      DeviceClassification.PSD_FOLD_EXPAND,
      {
        index: DeviceClassification.PSD_FOLD_EXPAND,
        pinInputHeight: $r('app.float.pin_input_height_phone'),
        pinTopFlexHeight: $r('app.float.pin_top_flex_height_phone'),
        pukTopFlexHeight: $r('app.float.puk_top_flex_height_phone'),
        pinKeyBoardHeight: $r('app.float.num_keyboard_height_fold_expand'),
        pinKeyBoardMarginBottom: $r('app.float.pin_keyboard_margin_bottom_phone'),
        pinDialogWidth: $r('app.float.pin_dialog_width_phone'),
      }
    ],

    // 手机无指纹状态和折叠屏折叠态
    [
      DeviceClassification.PSD_NO_FINGER,
      {
        index: DeviceClassification.PSD_NO_FINGER,
        pinInputHeight: $r('app.float.pin_input_height_phone'),
        pinTopFlexHeight: $r('app.float.pin_top_flex_height_phone'),
        pukTopFlexHeight: $r('app.float.puk_top_flex_height_phone'),
        pinKeyBoardHeight: $r('app.float.num_keyboard_height_fold_expand'),
        pinKeyBoardMarginBottom: $r('app.float.pin_keyboard_margin_bottom_phone'),
        pinDialogWidth: $r('app.float.pin_dialog_width_phone'),
      }
    ],

    // 折叠屏展开态-横屏
    [
      DeviceClassification.PSD_FOLD_EXPAND_HORIZONTAL,
      {
        index: DeviceClassification.PSD_FOLD_EXPAND_HORIZONTAL,
        pinInputHeight: $r('app.float.pin_input_height_phone'),
        pinTopFlexHeight: $r('app.float.pin_top_flex_height_phone'),
        pukTopFlexHeight: $r('app.float.puk_top_flex_height_phone'),
        pinKeyBoardHeight: $r('app.float.num_keyboard_height_fold_expand'),
        pinKeyBoardMarginBottom: $r('app.float.pin_keyboard_margin_bottom_phone_horizontal'),
        pinDialogWidth: $r('app.float.pin_dialog_width_phone'),
      }
    ],

    // 小折叠手机折叠态
    [
      DeviceClassification.PSD_SMALL_FOLD_PHONE,
      {
        index: DeviceClassification.PSD_SMALL_FOLD_PHONE,
        pinInputHeight: $r('app.float.pin_input_height_small_fold_phone'),
        pinTopFlexHeight: $r('app.float.pin_top_flex_height_small_fold_phone'),
        pukTopFlexHeight: $r('app.float.pin_top_flex_height_small_fold_phone'),
        pinKeyBoardHeight: $r('app.float.num_keyboard_height_fold_expand'),
        pinKeyBoardMarginBottom: $r('app.float.pin_keyboard_margin_bottom_small_fold_phone'),
        pinDialogWidth: $r('app.float.pin_dialog_width_phone'),
      }
    ]
  ]);
  public static readonly GUTTER_COUNT: number = 1;
  public static readonly MARGIN_BOTH_SIDE_COUNT: number = 2;
  public static readonly INPUT_WIDTH_SIM_CARD_PHONE: number = 260;
  public static readonly OUTER_INPUT_WIDTH_SIM_CARD_PHONE: number = 208;
  public static readonly KEYBOARD_WIDTH_SIM_CARD_PHONE: number = 260;
  public static readonly OUTER_KEYBOARD_WIDTH_SIM_CARD_PHONE: number = 208;

  // keyBoard宽度计算参数 手机 或折叠机 3.5 columns + 3 gutter
  public static readonly KEYBOARD_WIDTH_COUNT_COLUMNS: number = 3.5;
  public static readonly KEYBOARD_WIDTH_COUNT_GUTTER: number = 3;

  // keyBoard宽度计算参数 pad 4 columns + 3 gutter
  public static readonly KEYBOARD_WIDTH_COUNT_COLUMNS_PAD: number = 4;
  public static readonly KEYBOARD_WIDTH_COUNT_GUTTER_PAD: number = 3;

  // 输入框宽度计算参数 2.5 columns + 2 gutter
  public static readonly INPUT_TIP_WIDTH_COUNT_COLUMNS: number = 2.5;
  public static readonly INPUT_TIP_WIDTH_COUNT_GUTTER: number = 2;

  // keyboard高度计算 pad
  public static readonly PAD_KEYBOARD_HEIGHT_RATIO_LANDSCAPE: number = 2;
  public static readonly PAD_KEYBOARD_HEIGHT_RATIO_PORTRAIT: number = 3;

  // sim卡页面puk和记住pin的prop宽度 4 columns + 3 gutter
  public static readonly SIM_PROP_COLUMN_COUNT: number = 4;
  public static readonly SIM_PROP_GUTTER_COUNT: number = 3;

  // 密码页面箭头侧边距离 2 columns + 1 gutter
  public static readonly ARROW_MARGIN_COLUMN_COUNT: number = 2;
  public static readonly ARROW_MARGIN_GUTTER_COUNT: number = 1;

  // 混合密码页面高度计算
  public static readonly PAD_KEYBOARD_MIX_HEIGHT_MARGIN_BOTTOM_LANDSCAPE: number = 32;
  public static readonly PAD_KEYBOARD_MIX_HEIGHT_MARGIN_BOTTOM_PORTRAIT: number = 64;
  public static readonly PAD_KEYBOARD_HEIGHT_MARGIN_INPUT_PORTRAIT: number = 106;
  public static readonly PAD_KEYBOARD_HEIGHT_MARGIN_INPUT_LANDSCAPE: number = 40;
  public static readonly PAD_EMERGENCY_HEIGHT: number = 46;

  // keyboard高度 手机或折叠屏
  public static readonly KEYBOARD_HEIGHT_PHONE: number = 332;
  public static readonly KEYBOARD_HEIGHT_PHONE_OUTER_SCREEN: number = 204;
  public static readonly KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_LOW_FINGER: number = 468;
  public static readonly KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_HIGH_FINGER: number = 432;
  public static readonly KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_NO_FINGER: number = 410;
  public static readonly THREE_FOLD_G_PORTRAIT_KEYBOARD_MIX_MARGIN_BOTTOM: number = 530;
  public static readonly KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_OUTER_SCREEN: number = 207;

  public static readonly SCROLL_WIDTH_REDUCE:number = 98;
  public static readonly OUTER_SCROLL_WIDTH_REDUCE:number = 130;
  public static readonly PHONE_INPUT_WIDTH:number = 260;
  public static readonly OUTER_PHONE_INPUT_WIDTH:number = 204;
  // 输入栏与键盘间间隔
  public static readonly SIM_CARD_TIP_COLUMN_HEIGHT:number = 110;
  // 外屏输入栏与键盘间间隔--PUK未锁定
  public static readonly OUTER_SIM_CARD_TIP_COLUMN_HEIGHT:number = 12;
  // 外屏输入栏与键盘间间隔--PUK锁定
  public static readonly OUTER_SIM_CARD_TIP_COLUMN_HEIGHT_PUK_LOCKED:number = 24;
  // 手机密码页面宽度（不包含图案密码）
  public static readonly PHONE_KEYBOARD_WIDTH:number = 260;
  // 扩展新形态小折叠产品外屏手机密码页面宽度（不包含图案密码）
  public static readonly OUTER_PHONE_KEYBOARD_WIDTH:number = 208;
  // 手机图案密码页面宽度
  public static readonly PHONE_PATTERN_WIDTH:number = 288;

  // 三折叠G态MARGIN个数
  public static readonly THREE_FOLD_G_COUNT_MARGINS: number = 2;
  // 三折叠G态密码盘所占COLUMN个数
  public static readonly THREE_FOLD_G_KEYBOARD_COUNT_COLUMNS: number = 4;
  // 三折叠G态密码盘所占GUTTER个数
  public static readonly THREE_FOLD_G_KEYBOARD_COUNT_GUTTERS: number = 4;
  // 三折叠G态密码盘所占MARGIN个数
  public static readonly THREE_FOLD_G_KEYBOARD_COUNT_MARGIN: number = 1;
  // 数字密码 折叠展开态的竖屏  距离底部 96
  public static readonly PSD_FOLD_EXPAND_MARGIN_BOTTOM: number = 96;
  // 数字密码 折叠展开态的横屏 距离底部 68
  public static readonly PSD_FOLD_EXPAND_HORIZONTAL_MARGIN_BOTTOM: number = 68;
  // 图案密码 折叠展开态的竖屏  距离底部 114
  public static readonly PATTERN_FOLD_EXPAND_MARGIN_BOTTOM: number = 114;
  // 图案密码 折叠展开态的横屏  距离底部 86
  public static readonly PATTERN_FOLD_EXPAND_HORIZONTAL_MARGIN_BOTTOM: number = 86;
  // 箭头按键高度的一半
  public static readonly HALF_ARROW_HEIGHT: number = 16;
  // 折叠机密码页面箭头宽度
  public static readonly ARROW_WIDTH: number = 32;
  // SIM卡页prop距离侧边边距24vp 两侧48
  public static readonly SIM_PROP_MARGIN_BOTH_SIZE: number = 48;
  // SIM卡页prop文字距离两边的距离
  public static readonly SIM_PROP_TEXT_MARGIN_BOTH_SIZE: number = 32;


};
