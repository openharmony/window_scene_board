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
import { SystemParamUtils } from '@ohos/screenlockcommon';
import { curves } from '@kit.ArkUI';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/src/main/ets/template/newStyle/BrightnessOptionUtils';

/**
 * 沉浸锁屏胶囊常量
 *
 * @since 2024-03-07
 */
export class ImmersiveCapsuleConstants {
  public static isStacked: boolean = true;
  public static isExpand: boolean = false;
  public static isGroup: Boolean = true;
  public static hideContentSuffix: String = '条通知';

  /**
   * 普通通知胶囊参数
   */
  public static readonly CAPSULE_GROUP_NORMAL_TOP_PADDING: number = 6;
  public static readonly CAPSULE_GROUP_NORMAL_BOTTOM_PADDING: number = 5;
  public static readonly CAPSULE_NORMAL_WIDTH: number = 28;
  public static readonly CAPSULE_NORMAL_HEIGHT: number = 19;
  public static readonly CAPSULE_GROUP_MAIN_RIGHT_MARGIN: number = 4;
  public static readonly CAPSULE_GROUP_RIGHT_MARGIN: number = 10;

  /**
   * 胶囊参数
   */
  public static readonly CAPSULE_WIDTH: number = 208;
  public static readonly CAPSULE_HEIGHT: number = 48;
  public static readonly STACKED_DISTANCE: number = 6;
  public static readonly CAPSULE_RADIUS: number = 24;
  public static readonly CAPSULE_PADDING: number = 6;
  public static readonly CAPSULE_STACK_ALPHA: number = 0.25;
  public static readonly CAPSULE_CAPSULE_EFFECT_COLOR: ResourceColor = $r('app.color.immersive_capsule_color');
  public static readonly CAPSULE_SHADOW_WIDTH_PERCENTAGE: number = 0.96;
  public static readonly CAPSULE_MIN_FONT_SCALE: number = 0.5;
  public static readonly CAPSULE_MAX_FONT_SCALE: number = 1.15;

  /**
   * 胶囊图标参数
   */
  public static readonly CAPSULE_ICON_SPECS: number = 36;
  public static readonly CAPSULE_ICON_RADIUS: number = 12;
  public static readonly CAPSULE_ICON_MARGIN: number = 6;
  public static readonly CAPSULE_SMALL_ICON_MARGIN: number = 2;
  public static readonly CAPSULE_LARGE_ICON_ZINDEX: number = 10;
  public static readonly CAPSULE_SMALL_MASK_ZINDEX: number = 20;
  public static readonly CAPSULE_SMALL_ICON_ZINDEX: number = 30;
  /**
   * 主文本参数
   */
  public static readonly CAPSULE_MAIN_TEXT_HEIGHT: number = 19;
  public static readonly CAPSULE_MAIN_TEXT_FONT_SIZE: number = 14;
  public static readonly CAPSULE_MAIN_TEXT_WIDTH: number = 144;
  public static readonly CAPSULE_MAIN_TEXT_EXTEND_WIDTH: number = 112;
  public static readonly CAPSULE_MAIN_TEXT_MARGIN_TOP: number = 7;
  public static readonly CAPSULE_MAIN_TIME_TEXT_MARGIN_TOP: number = 6;
  /**
   *  副文本参数
   */
  public static readonly CAPSULE_SECONDARY_TEXT_FONT_SIZE: number = 12;
  public static readonly CAPSULE_SECONDARY_TEXT_HEIGHT: number = 17;
  public static readonly CAPSULE_SECONDARY_TEXT_WIDTH: number = 144;
  public static readonly CAPSULE_SECONDARY_TEXT_MARGIN_BOTTOM: number = 5;
  public static readonly CAPSULE_SECONDARY_TEXT_MARGIN_TOP: number = 0;
  /**
   * 文本区参数
   */
  public static readonly CAPSULE_TEXT_SPACE: number = 4;
  public static readonly CAPSULE_TEXT_TOP_MARGIN: number = 6;
  public static readonly CAPSULE_TEXT_BOTTOM_MARGIN: number = 7;
  public static readonly CAPSULE_TEXT_RIGHT_MARGIN: number = 16;
  /**
   * 扩展区参数
   */
  public static readonly CAPSULE_EXTEND_SPECS: number = 36;
  public static readonly CAPSULE_EXTEND_BTN_SPACE: number = 8;
  public static readonly CAPSULE_EXTEND_INNER_SPECS: number = 20;
  public static readonly CAPSULE_EXTEND_RIGHT_MARGIN: number = 6;
  public static readonly CAPSULE_EXTEND_LEFT_MARGIN: number = 6;
  public static readonly CAPSULE_EXTEND_TOP_MARGIN: number = 6;
  public static readonly CAPSULE_EXTEND_BOTTOM_MARGIN: number = 6;
  public static readonly CAPSULE_EXTEND_TEXT_FONT_SIZE: number | string | Resource = '10fp';
  public static readonly CAPSULE_EXTEND_MAX_LINE: number = 2;
  public static readonly CAPSULE_EXTEND_SMALL_ICON_SPECS: number = 14;
  public static readonly CAPSULE_EXTEND_ICON_RADIUS: number = 18;
  public static readonly CAPSULE_EXTEND_SMALL_ICON_RADIUS: number = 4;

  /**
   * 胶囊强提醒参数
   */
  public static readonly CAPSULE_REMIND_DURATION: number = 5000;
  public static readonly CAPSULE_REMIND_ANIM_END_SPACE: number = 8;

  /**
   * 胶囊动效参数
   */
  public static readonly CAPSULE_ANIM_SPRING_CURVE = curves.interpolatingSpring(0, 1, 228, 21);
  public static readonly CAPSULE_UPDATE_ANIM_FOLD_CURVE = curves.cubicBezierCurve(0.2, 0, 0.2, 1);
  public static readonly CAPSULE_UPDATE_ANIM_EXPAND_CURVE = curves.interpolatingSpring(0, 1, 228, 22);
  public static readonly CAPSULE_REMIND_ANIM_OUT_CURVE = curves.cubicBezierCurve(0.2, 0, 0.2, 1);
  public static readonly CAPSULE_REMIND_ANIM_BACK_CURVE = curves.interpolatingSpring(0, 1, 228, 22);

  /**
   * 胶囊顶部更新动效是否开启
   */
  public static readonly CAPSULE_TOP_UPDATE_ANIM_ENABLE = false;

  /**
   * 胶囊动效开关
   */
  public static readonly CAPSULE_ANIM_ENABLE =
    SystemParamUtils.getSystemParam('const.immersivekeyguard.capsule_anim_enable', 'true') === 'true';

  public static getIconAreaSpecs(): number {
    return ImmersiveCapsuleConstants.CAPSULE_HEIGHT;
  }

  public static getTextAreaWidth(isExtend: boolean = false): number {
    return isExtend ? ImmersiveCapsuleConstants.CAPSULE_MAIN_TEXT_EXTEND_WIDTH :
      ImmersiveCapsuleConstants.CAPSULE_MAIN_TEXT_WIDTH;
  }

  public static getCapsuleHeight(): number {
    return ImmersiveCapsuleConstants.CAPSULE_HEIGHT;
  }

  public static getMainTextFontSize(): number | string | Resource {
    return $r('sys.float.ohos_id_text_size_body2');
  }

  public static getMainTextFontColor(isLight?: boolean): ResourceColor {
    return isLight ? $r('app.color.immersive_capsule_main_text') : $r('app.color.immersive_capsule_main_text2');
  }

  public static getDefaultFontColor(isLight?: boolean): ResourceColor {
    return isLight ? $r('app.color.immersive_capsule_default') : $r('app.color.immersive_capsule_default2');
  }

  public static getSecondaryTextFontSize(): number | string | Resource {
    return $r('sys.float.ohos_id_text_size_body3');
  }

  public static getSecondaryTextFontColor(isLight?: boolean): ResourceColor {
    return isLight ? $r('app.color.immersive_capsule_second_text') : $r('app.color.immersive_capsule_second_text2');
  }

  public static getIconColor(): ResourceColor {
    return $r('sys.color.ohos_id_color_primary');
  }

  public static getCapsuleBlur(isLight?: boolean): BlurStyle {
    return !isLight ? BlurStyle.Regular : BlurStyle.Thin;
  }

  public static getProgressBackgroundColor(isLight?: boolean): ResourceColor {
    return isLight ? $r('app.color.immersive_capsule_progress_bg_color') :
    $r('app.color.immersive_capsule_progress_bg_color2');
  }

  public static getProgressColor(isLight?: boolean): ResourceColor {
    return isLight ? $r('app.color.immersive_capsule_progress_color') :
    $r('app.color.immersive_capsule_progress_color2');
  }

  public static getButtonBackground(): ResourceColor {
    return '#FF000000';
  }

  public static getButtonColor(): ResourceColor {
    return $r('app.color.immersive_capsule_button_color');
  }

  public static getShadeEffect(isLight?: boolean): BackgroundEffectOptions {
    return {
      policy: 1,
      radius: 15,
      color: isLight ? $r('app.color.immersive_capsule_shade_effect') : $r('app.color.immersive_capsule_shade_effect2')
    }
  }

  public static getCapsuleBrightEffect(isContent: boolean = true, isLight: boolean = true): BrightnessOptions {
    if (isContent) {
      if (isLight) {
        return BrightnessOptionUtils.keyguardCapsuleBackFirstDarkOption;
      } else {
        return BrightnessOptionUtils.keyguardCapsuleBackFirstLightOption;
      }
    } else {
      if (isLight) {
        return {
          rate: 0.177,
          lightUpDegree: 30.0 / 255,
          cubicCoeff: -0.0000041 * 255 * 255,
          quadCoeff: 0.003114 * 255,
          saturation: 1.8,
          posRGB: [0.6, 0.5, 0.5],
          negRGB: [0.3, 1, 1],
          fraction: 0
        }
      } else {
        return {
          rate: 0.858,
          lightUpDegree: 19.0 / 255,
          cubicCoeff: -0.000005 * 255 * 255,
          quadCoeff: 0.0009794 * 255,
          saturation: 1.5,
          posRGB: [1, 0.7, 1],
          negRGB: [1, 1, 1],
          fraction: 0
        }
      }
    }
  }

  public static getCapsuleTextBrightEffect(isPrimary: boolean = true, isLight: boolean = true): BrightnessOptions {
    if (isPrimary) {
      if (isLight) {
        return BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight;
      } else {
        return BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark;
      }
    } else {
      if (isLight) {
        return BrightnessOptionUtils.getInstance().foregroundSecondaryOption;
      } else {
        return BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption;
      }
    }
  }

  public static getCapsuleExtendBrightEffect(isLight?: boolean): BrightnessOptions {
    if (isLight) {
      return {
        rate: 1,
        lightUpDegree: -20 / 255,
        cubicCoeff: 0,
        quadCoeff: 0,
        saturation: 1.2,
        posRGB: [0.8, 0.8, 0.5],
        negRGB: [1, 1, 1],
        fraction: 0
      }
    } else {
      return {
        rate: 1,
        lightUpDegree: 15 / 255,
        cubicCoeff: 0,
        quadCoeff: 0,
        saturation: 1.2,
        posRGB: [0.8, 0.8, 0.5],
        negRGB: [1, 1, 1],
        fraction: 0
      }
    }
  }
}

