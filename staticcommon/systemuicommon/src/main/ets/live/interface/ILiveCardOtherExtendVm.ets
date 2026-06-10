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
import { BaseGesture } from '../../vm/BaseGesture';

/**
 * 三方实况卡片扩展区VM
 */
export interface ILiveCardOtherExtendVm {
  /**
   * 三方辅助区宽高
   */
  extendWidth: number | string | undefined;
  extendHeight: number | string | undefined;

  /**
   * 普通文本参数
   */
  normalTextWidth: number | string | undefined;
  normalTextHeight: number | string | undefined;
  normalTextMaxFont: Length | undefined;
  normalTextMinFont: Length | undefined;

  /**
   * 胶囊文本参数
   */
  capsuleButtonHeight: number | string | undefined;
  capsuleButtonWidth : Length | undefined;
  capsuleButtonMaxWidth : Length | undefined;
  capsuleButtonTextHeight: number | string | undefined;
  capsuleButtonTopMargin: number | undefined;
  capsuleButtonLeftMargin: number | undefined;

  /**
   * 系统按钮宽度
   */
  buttonLength: number | string | undefined;

  /**
   * 文本颜色
   */
  textColor: ResourceColor | undefined;

  /**
   * 文本提亮
   */
  fontFgBrightness: BrightnessOptions | undefined;

  /**
   * 按钮背景颜色
   */
  buttonBgColor: ResourceColor | string | undefined;

  /**
   * 按钮背景提亮
   */
  buttonBgBrightness: BrightnessOptions | undefined;

  /**
   * 天气按钮背景提亮
   */
  weatherButtonBrightness: BrightnessOptions | undefined;

  /**
   * 天气按钮背景颜色
   */
  weatherButtonBgColor: ResourceColor | string | undefined;

  /**
   * 提亮属性与emoji同时设置时需要RenderGroup置false
   * @param text 胶囊文本
   */
  isRenderGroup: boolean;

  /**
   * 文本或图片透明度
   */
  opacity: number | undefined;

  /**
   * 按钮文本透明度
   */
  buttonTextOpacity: number | undefined;

  /**
   * 扩展区点击手势
   */
  tapGesture?: TapGestureHandler;

  /**
   * 图片扩展区出现动效
   */
  startImageAnim(delay?: number): Promise<void>;

  setHandleClickAction?: (callback: () => Promise<void>) => void;
}