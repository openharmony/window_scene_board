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
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';

/**
 * 沉浸卡片固定UI样式
 */
@Observed
export class ImmersiveCardStyle {
  /**
   * 宽屏场景卡片宽度
   */
  public widescreenWidth?: number | string;
  /**
   * 宽屏场景卡片高度
   */
  public widescreenHeight?: number | string;
  /**
   * 卡片实际高度
   */
  public height?: number | string;
  /**
   * 卡片实际宽度
   */
  public width?: number | string;
  /**
   * 卡片位移
   */
  public translate?: TranslateOptions;
  /**
   * 卡片透明度
   */
  public opacity?: number;
  /**
   * 卡片是否启用事件
   */
  public enabled?: boolean;
  /**
   * 卡片是否可见
   */
  public visibility?: Visibility;
  /**
   * 沉浸提示文字最大缩放倍数
   */
  public uiExtensionTipFontScale?: number;
  /**
   * 沉浸提示文字行高
   */
  public uiExtensionTipLineHeight?: string | Resource;
  /**
   * 沉浸提示按钮行高
   */
  public uiExtensionTipBtnLineHeight?: string | Resource;
  /**
   * 沉浸提示按钮行高
   */
  public uiExtensionTipImageVisibility?: boolean;
  /**
   * 沉浸提示按钮底部外边距
   */
  public uiExtensionTipBtnBottomMargin?: number;
  /**
   * 沉浸提示文字垂直对齐格式
   */
  public uiExtensionTipTextFlexAlign?: FlexAlign;
  /**
   * 沉浸提示按钮宽度
   */
  public uiExtensionTipBtnWidth?: Length;
  /**
   * 沉浸提示背景色
   */
  public uiExtensionTipBackgroundColor?: Resource;

  /**
   * 返回按钮模糊半径
   */
  public isLightColor?: boolean;
  /**
   * 返回按钮箭头提亮参数
   */
  public backBtnForegroundBrightnessOption?: BrightnessOptions;
  /**
   * 返回按钮背景提亮参数
   */
  public backBtnBackgroundBrightnessOption?: BrightnessOptions =
    BrightnessOptionUtils.keyguardCapsuleBackFirstDarkOption;

  /**
   * 返回按钮去提亮压暗后的背景色
   */
  public backBtnBackgroundColor?: ResourceColor;
  /**
   * 返回按钮去提亮压暗后的前景色
   */
  public backBtnForegroundColor?: ResourceColor;
}