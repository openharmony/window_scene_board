/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
 * 沉浸卡片固定UI样式
 * 从沉浸锁屏同步过来
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
}