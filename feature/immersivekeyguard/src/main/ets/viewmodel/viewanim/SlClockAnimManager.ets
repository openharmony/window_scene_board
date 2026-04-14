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

import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { AnimValue } from '@ohos/systemuicommon';
import { SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ClockStaticStateType, NotificationStateManager } from '@ohos/screenlockcommon';
import { ISlClockAnimVm } from '../../common/interface/ISlClockAnimVm';
import { ImmAnimBaseMgrV2 } from '../v2/anim/ImmAnimBaseManagerV2';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';

/**
 * 跟手场景常量
 */
enum TouchConst {
  SCALE_MAX = 1.1, // 放大场景最大值
  SCALE_MIN = 0.9, // 缩小场景最小值
  DOWN_FACTOR = 0.3, // 下拉位移比率
  UP_FACTOR = 0.2 // 上滑位移比率
}

// 时钟动效时延，时钟80，沉浸模块考虑代码时延
const CLOCK_ANIM_DELAY = 75;

/**
 * 锁屏时钟组件动效管理
 */
export class SlClockAnimManager extends ImmAnimBaseMgrV2 implements ISlClockAnimVm {
  /**
   * 锁屏时钟组件动效状态
   */
  private clockAnimState?: WidgetAnimState;

  private getClockAnimState(): WidgetAnimState {
    if (this.clockAnimState) {
      return this.clockAnimState;
    }
    let clockStaticSt = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE);
    this.clockAnimState = clockStaticSt?.getSlState(ClockStaticStateType.CLOCK_VIEW_ANIM) as WidgetAnimState;
    return this.clockAnimState;
  }

  /**
   * 锁屏首页时钟组件动效状态
   *
   * @returns 动效状态
   */
  public getClockViewAnimSt(): WidgetAnimState {
    return this.getClockAnimState();
  }

  /**
   * 时钟动效时延
   * 数字时钟样式1/8，收起样式动效有时延
   *
   * @returns 时延
   */
  public getClockAnimDelay(): number {
    return NotificationStateManager.notificationState.isClockAnimDelay ? CLOCK_ANIM_DELAY : 0;
  }

  /**
   * 更新时钟同步动效时速度
   *
   * @param vel 速度
   */
  public updateClockVel(vel: number): void {
    NotificationStateManager.updateTouchVelocityY(vel);
    // 跟手场景，存在速度时，强制关闭时钟动效时延
    NotificationStateManager.updateDisableDelay(vel !== 0);
  }

  /**
   * 重置时钟动效速度
   */
  public resetClockVel(): void {
    NotificationStateManager.updateTouchVelocityY(0);
    NotificationStateManager.updateDisableDelay();
  }

  /**
   * 打断时钟形态切换动效
   */
  public requestInterruptClockAnim(): void {
    NotificationStateManager.requestInterruptClockAnim();
  }

  /**
   * 锁屏时钟组件开启动效场景
   *
   * @param scene 场景
   */
  public startClockAnimScene(scene?: string): void {
    this.getClockAnimState()?.setAnimScene({ animScene: scene, isAnimating: true, isForceRemove: false });
  }

  /**
   * 锁屏时钟组件结束动效场景
   *
   * @param scene 场景
   */
  public endClockAnimScene(scene?: string): void {
    this.getClockAnimState()?.setAnimScene({ animScene: scene, isAnimating: false, isForceRemove: false });
  }

  /**
   * 锁屏时钟组件动效终值
   */
  public endClockAnimState(): void {
    this.getClockAnimState()?.setTranY(AnimValue.VALUE_MIN)
      .setScaleX(AnimValue.VALUE_MAX).setScaleY(AnimValue.VALUE_MAX);
  }

  /**
   * 清空锁屏时钟组件动效
   *
   * @param scene 动效场景
   */
  public clearClockAnimState(scene?: string): void {
    this.endClockAnimScene(scene);
    this.getClockAnimState()?.setTranY().setScaleX().setScaleY();
  }

  /**
   * 时钟是否位移
   *
   * @returns true存在位移
   */
  public hasClockTranY(): boolean {
    let tranY = this.getClockAnimState()?.getTranY() ?? AnimValue.VALUE_MIN;
    return tranY !== AnimValue.VALUE_MIN;
  }

  /**
   * 跟手动效设置动效值
   *
   * @param tranY 竖向位移
   * @param progress 缩放进度
   * @param isZoomIn 是否放大场景
   */
  public setTouchAnimValue(tranY: number, progress: number, isZoomIn: boolean = true): void {
    let endScale = isZoomIn ? TouchConst.SCALE_MAX : TouchConst.SCALE_MIN;
    let startScale = AnimValue.VALUE_MAX;
    let curScale = startScale + (endScale - startScale) * progress;
    let tranFactor = isZoomIn ? TouchConst.DOWN_FACTOR : TouchConst.UP_FACTOR;
    this.getClockAnimState()?.setTranY(tranY * tranFactor).setScaleX(curScale).setScaleY(curScale);
  }
}