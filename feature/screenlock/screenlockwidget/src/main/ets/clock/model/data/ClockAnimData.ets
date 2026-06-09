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

import { ClockWidgetId } from '../../../common/WidgetParam';

/**
 * 时钟组件动效参数
 */
@Observed
export class ClockAnimData {
  @Track public dateGeoId: string = ''; // 日期元素geometry标识，用于元素共享动效
  @Track public weekGeoId: string = ''; // 星期元素geometry标识，用于元素共享动效
  @Track public lunarGeoId: string = ''; // 农历元素geometry标识，用于元素共享动效
  @Track public dateTransition: TransitionEffect = TransitionEffect.IDENTITY; // 日期元素转场效果，配合不同形态日期样式转场
  @Track public lineSeparatorAnimating: boolean = false; // 线分隔符动效状态
  @Track public pointSeparatorAnimating: boolean = false; // 点分隔符动效状态
  @Track public lineSeparatorAlpha?: number; // 线分隔符透明度
  @Track public pointSeparatorAlpha?: number; // 点分隔符透明度

  /**
   * 设置日期元素共享开关
   *
   * @param enable 开启/关闭
   * @returns 链式
   */
  public setDateGeometryEnable(enable: boolean = false): ClockAnimData {
    this.dateGeoId = enable ? ClockWidgetId.ID_DATE : '';
    return this;
  }

  /**
   * 设置星期元素共享开关
   *
   * @param enable 开启/关闭
   * @returns 链式
   */
  public setWeekGeometryEnable(enable: boolean = false): ClockAnimData {
    this.weekGeoId = enable ? ClockWidgetId.ID_WEEK : '';
    return this;
  }

  /**
   * 设置农历元素共享开关
   *
   * @param enable 开启/关闭
   * @returns 链式
   */
  public setLunarGeometryEnable(enable: boolean = false): ClockAnimData {
    this.lunarGeoId = enable ? ClockWidgetId.ID_LUNA : '';
    return this;
  }

  /**
   * 设置日期元素转场开关
   *
   * @param enable 开启/关闭
   * @returns 链式
   */
  public setDateTransitionEnable(enable: boolean = false): ClockAnimData {
    this.dateTransition = enable ? TransitionEffect.OPACITY : TransitionEffect.IDENTITY;
    return this;
  }

  /**
   * 设置线分隔符元素动效开关
   *
   * @param enable 开启/关闭
   * @returns 链式
   */
  public setLineSeparatorAnimating(enable: boolean = false): ClockAnimData {
    this.lineSeparatorAnimating = enable;
    return this;
  }

  /**
   * 设置点分隔符元素动效开关
   *
   * @param enable 开启/关闭
   * @returns 链式
   */
  public setPointSeparatorAnimating(enable: boolean = false): ClockAnimData {
    this.pointSeparatorAnimating = enable;
    return this;
  }

  /**
   * 设置线分隔符元素透明度
   *
   * @param alpha 透明度
   * @returns 链式
   */
  public setLineSeparatorAlpha(alpha?: number): ClockAnimData {
    this.lineSeparatorAlpha = alpha;
    return this;
  }

  /**
   * 设置点分隔符元素透明度
   *
   * @param alpha 透明度
   * @returns 链式
   */
  public setPointSeparatorAlpha(alpha?: number): ClockAnimData {
    this.pointSeparatorAlpha = alpha;
    return this;
  }

  /**
   * 清除全部动效
   */
  public clearAllAnim(): void {
    this.setDateGeometryEnable().setWeekGeometryEnable().setLunarGeometryEnable().setDateTransitionEnable();
  }

  /**
   * 清空分隔符动效
   */
  public clearSeparatorAnim(): void {
    this.setLineSeparatorAnimating().setPointSeparatorAnimating().setLineSeparatorAlpha().setPointSeparatorAlpha();
  }
}