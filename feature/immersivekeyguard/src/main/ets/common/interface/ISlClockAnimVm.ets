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

import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { IImmersiveAnimBaseVm } from './IImmersiveAnimBaseVm';

/**
 * 锁屏时钟组件动效业务管理抽象层
 */
export interface ISlClockAnimVm extends IImmersiveAnimBaseVm {
  /**
   * 取值时钟动效状态
   *
   * @returns 动效状态
   */
  getClockViewAnimSt(): WidgetAnimState;

  /**
   * 时钟动效时延
   *
   * @returns 时延
   */
  getClockAnimDelay(): number;

  /**
   * 更新时钟同步动效时速度
   *
   * @param vel 速度
   */
  updateClockVel(vel: number): void;

  /**
   * 重置时钟动效速度
   */
  resetClockVel(): void;

  /**
   * 请求打断时钟动效
   */
  requestInterruptClockAnim(): void;

  /**
   * 时钟动效添加场景
   *
   * @param scene 动效场景
   */
  startClockAnimScene(scene?: string): void;

  /**
   * 结束时钟动效场景
   *
   * @param scene 动效场景
   */
  endClockAnimScene(scene?: string): void;

  /**
   * 时钟动效终值复位
   */
  endClockAnimState(): void;

  /**
   * 清空时钟动效场景
   *
   * @param scene 动效场景
   */
  clearClockAnimState(scene?: string): void;

  /**
   * 时钟是否存在位移
   *
   * @returns true已位移
   */
  hasClockTranY(): boolean;

  /**
   * 跟手动效值设置
   *
   * @param tranY 位移
   * @param progress 进度
   * @param isZoomIn 是否放大场景
   */
  setTouchAnimValue(tranY: number, progress: number, isZoomIn?: boolean): void;
}