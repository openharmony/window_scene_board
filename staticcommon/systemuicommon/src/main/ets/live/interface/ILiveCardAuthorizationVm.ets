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

/**
 * 卡片授权VM
 */
export interface ILiveCardAuthorizationVm {
  /**
   * 应用传入的是否显示授权提示
   */
  isShowAuthorizationZone: boolean;
  /**
   * 内部控制的是否显示授权提示（实况面板不显示，通知面板需要显示）
   */
  showAuthorizationTip: boolean;
  /**
   * 是否显示授权提示，由应用是否传入对应字段和内部控制变量共同控制
   */
  isShowAuthorization: boolean;
  /**
   * 授权按钮提示
   */
  cardAuthorizationTip: ResourceStr;
  /**
   * text字体颜色
   */
  textFontColor: ResourceColor;
  /**
   * text字体透明度
   */
  textOpacity?: number | undefined;
  /**
   * text字体大小
   */
  textFontSize: Length;
  /**
   * 字体最大缩放倍数
   */
  maxFontScale: number;
  /**
   * text行高度
   */
  textLineHeight: Length;
  /**
   * 提亮参数
   */
  brightness: number;
  /**
   * 背景颜色参数
   */
  backgroundColor?: ResourceColor | undefined;
  /**
   * 分割线颜色
   */
  dividerColor: ResourceColor;
  /**
   * 分割线透明度
   */
  dividerOpacity: number;
  /**
   * 按钮字体颜色
   */
  buttonTextFontColor: ResourceColor;
  /**
   * text字体透明度
   */
  buttonTextOpacity: number;
  /**
   * text字体大小
   */
  buttonTextFontSize: Length;
  /**
   * text行高度
   */
  buttonTextLineHeight: Length;
  /**
   * text组件高度
   */
  buttonHeight: Length;
  /**
   * 左侧按钮是否按压状态
   */
  isLeftActionPressed: boolean;
  /**
   * 右侧按钮是否按压状态
   */
  isRightActionPressed: boolean;

  /**
   * 触摸事件
   */
  onTouchEvent(event: TouchEvent, button: string): void
  /**
   * 授权变化事件
   */
  onAuthorizationChange(enable: boolean): void;
}
