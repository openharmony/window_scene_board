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

import { NotificationAction } from '../../model/NotificationContent';

/**
 * 系统实况按钮VM
 */
export interface ILiveActionButtonVm {
  /**
   * 按钮背景颜色集合
   */
  actionButtons: Array<NotificationAction>;

  /**
   * 是否显示关联服务按钮
   */
  isShowActionButtons: boolean;

  /**
   * 按钮组背景颜色
   */
  backgroundColor: ResourceColor;

  /**
   * 按钮背景颜色集合
   */
  backgroundColors: Array<ResourceColor>;

  /**
   * 按钮文本颜色
   */
  fontColor: ResourceColor;

  /**
   * 按钮文本大小
   */
  fontSize: Length;

  /**
   * 按钮文本行高
   */
  lineHeight: Length;

  /**
   * 服务按钮文本透明度
   */
  actionTextAlpha?: number | undefined;

  /**
   * 分割线透明度
   */
  dividerAlpha?: number | undefined;

  /**
   * 分割线前景提亮参数
   */
  dividerFgBrightness?: BrightnessOptions | undefined;

  /**
   * 触摸事件
   */
  handleTouchEvent(event: TouchEvent, index: number): void;

  /**
   * 是否存在点击事件
   */
  hasClickEvent(index: number): boolean;

  /**
   * 点击事件
   */
  handleClickEvent: (index: number) => Promise<void>;

  getDividerVisible(): Visibility;

  setHandleClickAction?: (callback: (index: number) => Promise<void>) => void;
}