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
 * 卡片授权提示按钮VM
 */
export interface ILiveCardAuthorizationButtonVm {
  /**
   * 按钮字体颜色
   */
  buttonTextFontColor: number;
  /**
   * text字体透明度
   */
  buttonTextOpacity: number;
  /**
   * text字体大小
   */
  buttonTextFontSize: number;
  /**
   * text行高度
   */
  buttonTextLineHeight: number;
  /**
   * action是否按压状态
   */
  isActionPressed: boolean;
  /**
   * 触摸事件
   */
  onTouchEvent(event: TouchEvent): void;
}
