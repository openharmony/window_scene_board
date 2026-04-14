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

import { AnimEvent, LimitSet } from '@ohos/screenlockcommon/Index';

// 沉浸模块动效曲线参数配置
export class ImmAnimParam {
  // 动效结束回调集，非清除集
  private readonly staticAnimFinish: LimitSet<AnimEvent> = new LimitSet();
  // 动效结束回调集，自动清除集
  private readonly dynamicAnimFinish: LimitSet<AnimEvent> = new LimitSet();
  // 动效曲线参数
  private animParam: AnimateParam = {};
  // 标识是否主动效
  private _isMainAnim: boolean = false;
  // 默认动效结束回调
  private readonly _defaultAnimFinish: AnimEvent = () => {
    // 统一处理回调
    this.staticAnimFinish.forEach((finish) => finish?.());
    this.dynamicAnimFinish.forEach((finish) => finish?.());
    // 回调完毕，清除
    this.dynamicAnimFinish.clear();
  };

  private constructor() {
  }

  /**
   * 绑定动效曲线参数
   *
   * @param param 动效曲线
   * @returns 链式
   */
  public buildAnimParam(param: AnimateParam): ImmAnimParam {
    this.animParam = param;
    // 强制使用默认结束器
    if (param) {
      this.addStaticFinish(param.onFinish);
      param.onFinish = this._defaultAnimFinish;
    }
    return this;
  }

  /**
   * 标识是否主动效
   *
   * @param isMainAnim true主动效
   * @returns 链式
   */
  public buildMainAnim(isMainAnim: boolean): ImmAnimParam {
    this._isMainAnim = isMainAnim;
    return this;
  }

  /**
   * 更新曲线时长
   *
   * @param duration 时长
   */
  public updateDuration(duration: number): ImmAnimParam {
    if (this.animParam) {
      this.animParam.duration = duration;
    }
    return this;
  }

  /**
   * 更新曲线
   *
   * @param curve 曲线
   */
  public updateCurve(curve?: ICurve): ImmAnimParam {
    if (this.animParam) {
      this.animParam.curve = curve;
    }
    return this;
  }

  /**
   * 添加结束回调事件，非清除集
   *
   * @param finish 动效结束回调
   */
  public addStaticFinish(finish?: AnimEvent): void {
    if (!finish) {
      return;
    }
    this.staticAnimFinish.add(finish);
  }

  /**
   * 添加结束回调事件，自动清除集
   *
   * @param finish 动效结束回调
   */
  public addDynamicFinish(finish?: AnimEvent): void {
    if (!finish) {
      return;
    }
    this.dynamicAnimFinish.add(finish);
  }

  /**
   * 动效曲线参数
   *
   * @returns 曲线参数
   */
  public getAnimParam(): AnimateParam {
    return this.animParam;
  }

  /**
   * 是否主动效
   *
   * @returns true主动效
   */
  public isMainAnim(): boolean {
    return this._isMainAnim;
  }

  /**
   * 实例
   *
   * @returns 实例
   */
  public static wrap(): ImmAnimParam {
    return new ImmAnimParam();
  }
}