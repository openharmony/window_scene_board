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

import { observer } from '@kit.TelephonyKit';

/**
 * 组件动效样式类型
 */
export enum AodStyleType {
  // 字体颜色
  FONT_COLOR = 'fontColor',
  // 背景颜色
  BACKGROUND_COLOR = 'backgroundColor',
  // 着重字体颜色
  WEIGHT_FONT_COLOR = 'weightFontColor',
  // Faded字体颜色
  FADED_FONT_COLOR = 'fadedFontColor',
  // 阴影胶囊模糊颜色
  SHADE_BACKGROUND_COLOR = 'shadeBackgroundColor',
  // 胶囊底板透明度
  CAPSULE_BG_ALPHA = 'capsuleBackgroundAlpha',
  // 胶囊一级文本颜色
  CAPSULE_MAIN_FONT_COLOR = 'capsuleMainFontColor',
  // 胶囊二级文本颜色
  CAPSULE_SECONDARY_FONT_COLOR = 'capsuleSecondaryFontColor',
  // 实况卡片二级文本颜色
  CARD_SECONDARY_FONT_COLOR = 'cardSecondaryFontColor',
  // 分割线颜色
  LIST_SEPARATOR_COLOR = 'listSeparatorColor',
  // 播控功能按钮颜色
  MEDIA_BUTTON_COLOR = 'mediaButtonColor',
  // 播控默认图背板颜色
  MEDIA_BACKGROUND_COLOR = 'mediaBackgroundColor',
  // 播控胶囊态功能按钮背板颜色
  MEDIA_BUTTON_BACKGROUND_COLOR = 'mediaButtonBackgroundColor',
  // 播控胶囊态音符图标颜色
  CAPSULE_MUSIC_COLOR = 'capsuleMusicColor',
  // 播控沉浸态音符图标颜色
  IMMERSIVE_MUSIC_COLOR = 'mediaMusicColor',
  // 锁屏时钟颜色
  SCREEN_LOCK_CLOCK_COLOR = 'screenLockClockColor',
  // AOD场景卡片背板颜色
  AOD_FORM_PANEL_COLOR = 'aodFormPanelColor',
  // 卡片提示区域背景颜色
  AUTH_TIP_BG_COLOR = 'authTipBgColor',
  // 卡片提示区域标题颜色
  AUTH_TIP_TITLE_COLOR = 'authTipTitleColor',
  // 卡片提示区域按钮颜色
  AUTH_TIP_BUTTON_COLOR = 'authTipButtonColor',
  // 卡片提示区域分隔线颜色
  AUTH_TIP_DIVIDER_COLOR = 'authTipDividerColor',
  // 通知卡片底板颜色
  LIST_CARD_BACKGROUND_COLOR = 'listCardBackgroundColor',
  // 通知卡片底板颜色
  CARD_TIP_FILL_COLOR = 'cardTipFillColor',
  // 通知卡片底板透明度
  LIST_CARD_BG_ALPHA = 'listCardBackgroundAlpha',
  // 沉浸卡片背板透明度
  IMMERSIVE_CARD_BG_ALPHA = 'immersiveCardBackgroundAlpha',
  // 沉浸卡片大图透明度
  IMMERSIVE_CARD_PREVIEW_ALPHA = 'immersiveCardPreviewAlpha',
  // 通知固定区应用图片透明度
  NTF_APP_ICON_ALPHA = 'ntfAppIconAlpha',
  // 通知辅助区按钮透明度
  NTF_EXTEND_VIEW_ALPHA_BUTTON = 'ntfExtendViewAlphaButton',
  // 通知辅助区按钮文字透明度
  NTF_EXTEND_VIEW_ALPHA_BUTTON_TEXT = 'ntfExtendViewCapsuleButtonText',
  // 通知辅助区展示内容透明度
  NTF_EXTEND_VIEW_ALPHA_CONTENT = 'ntfExtendViewAlphaContent',
  // 通知扩展区透明度
  NTF_EXTEND_COMPONENT_ALPHA = 'ntfExtendComponentAlpha',
}

/**
 * 组件属性默认值
 */
export enum WDefault {
  MAX_VALUE = 1
}

/**
 * 沉浸AOD组件默认UI样式
 */
@Observed
export class ImmersiveAodStyle {
  /**
   * 是否AOD显示
   */
  @Track public isAod: boolean = false;

  /**
   * 是否一镜到底动效期间
   */
  @Track public isOneMirror: number = 0;

  /**
   * 通知列表是否达到最大网格数
   */
  @Track public isReachMax: boolean = false;

  /**
   * 一镜到底期间，通知面板是否隐藏
   */
  @Track public isKgNtfHidden: boolean = false;

  /**
   * 锁屏壁纸是否缩放
   */
  @Track public isKgWallpaperScale: boolean = true;

  /**
   * 锁屏壁纸是否压暗
   */
  @Track public isKgWallpaperLight: boolean = false;

  @Track private aodStyleMap: Map<AodStyleType, number> = new Map([
    [AodStyleType.FONT_COLOR, 0x66FFFFFF],
    [AodStyleType.WEIGHT_FONT_COLOR, 0x66FFFFFF],
    [AodStyleType.BACKGROUND_COLOR, 0xFF2D2D2D],
    [AodStyleType.FADED_FONT_COLOR, 0xFFFFFFFF],
    [AodStyleType.LIST_CARD_BACKGROUND_COLOR, 0xFF1E1E1E],
    [AodStyleType.SHADE_BACKGROUND_COLOR, 0XFF242424],
    [AodStyleType.CAPSULE_MAIN_FONT_COLOR, 0x66FFFFFF],
    [AodStyleType.CAPSULE_SECONDARY_FONT_COLOR, 0x66FFFFFF],
    [AodStyleType.LIST_SEPARATOR_COLOR, 0xFF666666],
    [AodStyleType.AUTH_TIP_BG_COLOR, 0x26000000],
    [AodStyleType.AUTH_TIP_TITLE_COLOR, 0x99FFFFFF],
    [AodStyleType.AUTH_TIP_BUTTON_COLOR, 0x99FFFFFF],
    [AodStyleType.AUTH_TIP_DIVIDER_COLOR, 0xFFFFFFFF],
    [AodStyleType.MEDIA_BUTTON_COLOR, 0xFF4D4D4D],
    [AodStyleType.MEDIA_BACKGROUND_COLOR, 0x19FFFFFF],
    [AodStyleType.MEDIA_BUTTON_BACKGROUND_COLOR, 0x0DFFFFFF],
    [AodStyleType.CAPSULE_MUSIC_COLOR, 0x66FFFFFF],
    [AodStyleType.SCREEN_LOCK_CLOCK_COLOR, 0xFE999999],
    [AodStyleType.IMMERSIVE_MUSIC_COLOR, 0x33FFFFFF],
    [AodStyleType.CARD_SECONDARY_FONT_COLOR, 0X4DFFFFFF],
    [AodStyleType.AOD_FORM_PANEL_COLOR, 0x996E6E6E],
    [AodStyleType.CARD_TIP_FILL_COLOR, 0xFFFFFFFF],
    [AodStyleType.CAPSULE_BG_ALPHA, 0.9],
    [AodStyleType.LIST_CARD_BG_ALPHA, 0.9],
    [AodStyleType.IMMERSIVE_CARD_BG_ALPHA, 0.3],
    [AodStyleType.IMMERSIVE_CARD_PREVIEW_ALPHA, 0.6],
    [AodStyleType.NTF_APP_ICON_ALPHA, 0.4],
    [AodStyleType.NTF_EXTEND_VIEW_ALPHA_BUTTON, 0.1],
    [AodStyleType.NTF_EXTEND_VIEW_ALPHA_BUTTON_TEXT, 0.3],
    [AodStyleType.NTF_EXTEND_VIEW_ALPHA_CONTENT, 0.4],
    [AodStyleType.NTF_EXTEND_COMPONENT_ALPHA, 0.4],
  ]);

  /**
   * 设置样式值
   *
   * @param type 样式类型
   * @param value 对应值
   * @returns 链式
   */
  bindStyle(type: AodStyleType, value?: number): ImmersiveAodStyle {
    this[type] = value;
    return this;
  }

  /**
   * 获取对应样式值
   *
   * @param type 样式类型
   * @returns 值
   */
  getStyleValue(type: AodStyleType): number | undefined {
    return this.aodStyleMap.get(type);
  }

  /**
   * 获取对应样式值
   *
   * @param type 样式类型
   * @param defaultValue 样式类型
   * @returns 值
   */
  getValueDefault(type: AodStyleType, defaultValue: number | string = 0): number | string {
    return this.getStyleValue(type) ?? defaultValue;
  }

  /**
   * 获取通知胶囊、通知卡片左侧图标的透明度
   *
   * @returns 透明度
   */
  getNtfIconOpacity(): number | undefined {
    return this.isAod ? this.getStyleValue(AodStyleType.NTF_APP_ICON_ALPHA) : WDefault.MAX_VALUE;
  }

  /**
   * 设置通知列表是否达到最大网格数
   *
   */
  setNtfMeshReachMax(isReachMax: boolean): void {
    this.isReachMax = isReachMax;
  }

  /**
   * 获取列表态是否达到最大长度
   *
   * @returns 值
   */
  isNtfReachMax(): boolean {
    return this.isReachMax;
  }

  /**
   * 是否是一镜到底动效期间或已进入AOD
   *
   * @returns 值
   */
  isOneMirrorToAod(): boolean {
    return this.isOneMirror > 0 || this.isAod;
  }
}
