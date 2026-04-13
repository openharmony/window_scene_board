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
import { WindowConstants } from '@ohos/commonconstants';

/**
 * banner面板样式常量值
 */
export class BannerStyle {
  /**
   * 阴影横向偏移量
   */
  readonly shadowOffsetX: number = WindowConstants.BANNER_SHADOW_OFFSET_X;

  /**
   * 阴影竖向偏移量
   */
  readonly shadowOffsetY: number = WindowConstants.BANNER_SHADOW_OFFSET_Y;

  /**
   * 阴影颜色
   */
  readonly shadowColor: string = WindowConstants.BANNER_SHADOW_COLOR;

  /**
   * 阴影半径
   */
  readonly shadowRadius: number = WindowConstants.BANNER_SHADOW_RADIUS;

  /**
   * 普通场景，banner顶部间距，vp
   */
  readonly marginTop: number = 47;

  /**
   * 普通场景，banner距离状态栏高度，vp
   */
  readonly marginStatusBarTop: number = 8;

  /**
   * 扩展折叠设备外屏场景，相对于内屏实况列表的位置，应该向上偏移3VP
   */
  readonly marginTopOuterHomeFold: number = -3;

  /**
   * 沉浸式横屏场景，banner顶部间距，vp
   */
  readonly marginTopInImmersive: number = 8;

  /**
   * banner底部间距，vp
   * 预留空间处理投影
   */
  readonly marginBottom: number = 28;

  /**
   * verde外屏bottom
   */
  readonly marginBottomOuterHomeFold: number = 32;

  /**
   * Pad和PC banner底部间距，vp
   * 预留空间处理投影
   */
  readonly landMarginBottom: number = 50;

  /**
   * banner左右间距，vp
   * 预留空间处理投影
   */
  readonly marginLeftRight: number = 16;

  /**
   * banner窗口底部间距，vp
   */
  readonly bannerMarginBottom: number = 0;

  /**
   * 构造
   */
  private constructor() {
  }

  /**
   * 创建样式
   *
   * @returns 样式
   */
  static createStyle(): BannerStyle {
    return new BannerStyle();
  }
}