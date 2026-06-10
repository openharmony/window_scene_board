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
import { slWallpaperMgr } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/src/main/ets/template/newStyle/BrightnessOptionUtils';

/**
 * 沉浸锁屏胶囊常量
 *
 * @since 2024-03-07
 */
export class MediaImmersiveConstants {
  public static isStacked: boolean = true;
  public static isExpand: boolean = false;
  public static isGroup: Boolean = true;
  public static hideContentSuffix: String = '条通知';
  /**
   * 胶囊参数
   */
  public static readonly CAPSULE_WIDTH: number = 208;
  public static readonly CAPSULE_HEIGHT: number = 48;
  public static readonly STACKED_DISTANCE: number = 4;
  public static readonly CAPSULE_RADIUS: number = 18;
  public static readonly CAPSULE_STACK_ALPHA: number = 0.3;
  /**
   * 胶囊图标参数
   */
  public static readonly CAPSULE_ICON_SPECS: number = 36;
  public static readonly CAPSULE_ICON_RADIUS: number = 10;
  /**
   * 主文本参数
   */
  public static readonly CAPSULE_MAIN_TEXT_FONT_SIZE: number = 14;
  public static readonly CAPSULE_MAIN_TEXT_WIDTH: number = 144;
  public static readonly CAPSULE_MAIN_TEXT_EXTEND_WIDTH: number = 112;
  private static foregroundPrimaryOption: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundPrimaryOptionLight;
  private static foregroundPrimaryDarkOption: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundPrimaryOptionDark;
  /**
   *  副文本参数
   */
  public static readonly CAPSULE_SECONDARY_TEXT_FONT_SIZE: number = 12;
  public static readonly CAPSULE_SECONDARY_TEXT_WIDTH: number = 144;
  private static foregroundSecondaryOption: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundTertiaryGlossOption;
  private static foregroundSecondaryDarkOption: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundTertiaryDarkOption;
  /**
   * 扩展区参数
   */
  public static readonly CAPSULE_EXTEND_SPECS: number = 36;
  public static readonly CAPSULE_EXTEND_INNER_SPECS: number = 24;
  public static readonly CAPSULE_EXTEND_RIGHT_MARGIN: number = 6;
  public static readonly CAPSULE_EXTEND_LEFT_MARGIN: number = 6;
  public static readonly CAPSULE_EXTEND_TOP_MARGIN: number = 6;
  public static readonly CAPSULE_EXTEND_BOTTOM_MARGIN: number = 6;
  public static readonly CAPSULE_EXTEND_TEXT_FONT_SIZE: number | string | Resource = '10fp';
  public static readonly CAPSULE_EXTEND_MAX_LINE: number = 2;
  public static readonly CAPSULE_EXTEND_SMALL_ICON_SPECS: number = 16;
  public static readonly CAPSULE_EXTEND_ICON_RADIUS: number = 18;
  /**
   * 沉浸态除了图以外的卡片内高度
   * 上边距24 + 图与标题间距8 + 主标题21 + 副标题19 + 进度条40 + 按钮栏48 + 下边距14
   */
  public static readonly IMMERSIVE_HEIGHT_EXCEPT_IMAGE = 174;
  /**
   * 歌词参数
   */
  public static readonly LYRIC_FONT_MAIN = 20;
  public static readonly LYRIC_FONT_OTHER = 16;

  public static getIconAreaSpecs(): number {
    return MediaImmersiveConstants.CAPSULE_HEIGHT;
  }

  public static getTextAreaWidth(isExtend: boolean = false): number {
    return isExtend ? MediaImmersiveConstants.CAPSULE_MAIN_TEXT_EXTEND_WIDTH :
    MediaImmersiveConstants.CAPSULE_MAIN_TEXT_WIDTH;
  }

  public static getCapsuleHeight(): number {
    return MediaImmersiveConstants.CAPSULE_HEIGHT;
  }

  public static getMainTextFontSize(): number | string | Resource {
    return $r('sys.float.ohos_id_text_size_body2');
  }

  public static getMainTextFontColor(): ResourceColor {
    return slWallpaperMgr.getSlWallpaperState()
      .isLightWallpaper ? '#000000' : '#FFFFFF';
  }

  public static getMainTextBrightColor(isDarken: boolean): BrightnessOptions {
    return isDarken ? MediaImmersiveConstants.foregroundPrimaryOption :
      MediaImmersiveConstants.foregroundPrimaryDarkOption;
  }

  public static getDefaultFontColor(): ResourceColor {
    return slWallpaperMgr.getSlWallpaperState()
      .isLightWallpaper ? '#000000' : '#FFFFFF';
  }

  public static getSecondaryTextFontSize(): number | string | Resource {
    return $r('sys.float.ohos_id_text_size_body3');
  }

  public static getSecondaryTextFontColor(): ResourceColor {
    return slWallpaperMgr.getSlWallpaperState()
      .isLightWallpaper ? '#000000' : '#FFFFFF';
  }

  public static getSecondaryBrightColor(isDarken: boolean): BrightnessOptions {
    return isDarken ? MediaImmersiveConstants.foregroundSecondaryOption :
      MediaImmersiveConstants.foregroundSecondaryDarkOption;
  }

  public static getIconColor(): ResourceColor {
    return $r('sys.color.icon_primary');
  }

  public static getCapsuleBackgroundColor(): ResourceColor {
    return slWallpaperMgr.getSlWallpaperState().isLightWallpaper ? '#3FFF' : '3000';
  }

  public static getCapsuleStackBackgroundColor(): ResourceColor {
    return slWallpaperMgr.getSlWallpaperState().isLightWallpaper ? '#19FFFFFF' : '19000000';
  }

  public static getCapsuleBlur(): BlurStyle {
    return !slWallpaperMgr.getSlWallpaperState().isLightWallpaper ? BlurStyle.Regular : BlurStyle.Thin;
  }
}

