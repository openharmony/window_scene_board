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
 * 三方实况取餐卡片VM
 */
export interface ILiveCardOtherPickupVm {
  /**
   * 扩展区副文本字体大小
   */
  contentFontSize?: number | string;

  /**
   * 扩展区副文本字重
   */
  contentFontWeight?: FontWeight | number | string;

  /**
   * 扩展区副文本下划线底部间距
   */
  lineMarginBottom?: number;
}