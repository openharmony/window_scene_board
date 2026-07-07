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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AIBarViewModel } from '../../../aiBar/AIBarModel/AIBarViewModel';
import { GameOperationParams } from './GameOperationParams';
import { SystemSceneConstants } from '../../SystemSceneConstants';

const TAG = 'GameOperationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 游戏场景下，底部导航操作管理
 */
export class GameOperationManager {
  // 游戏场景下，相关操作参数
  private params: GameOperationParams = new GameOperationParams();
  private aiBarViewModel?: AIBarViewModel;

  /**
   * 构造，依赖AIBarViewModel游戏场景参数isInGameSign
   *
   * @param aiBarViewModel
   */
  public constructor(aiBarViewModel: AIBarViewModel) {
    this.aiBarViewModel = aiBarViewModel;
  }

  /**
   * 监听底部导航TouchEvent
   */
  public onTouchEvent(event: TouchEvent): void {
    // 非游戏场景，不做特殊处理
    if (!this.aiBarViewModel?.aiBarData.isInGameSign) {
      return;
    }
    if (event.type === TouchType.Down) {
      this.params.isHasOtherFinger = !this.isFirstFinger(event);
      if (!this.params.isHasOtherFinger) {
        // 记录第一根手指的Down事件
        this.params.firstFingerEvent = event;
      }
    }
    if (event.type === TouchType.Move) {
      this.calculateFirstFingerMoveOffset(event);
    }
  }

  /**
   * 第一根手指滑动是否有效
   * 多指同时操作
   *
   * @returns
   */
  public isFirstFingerMoveValid(): boolean {
    // 非游戏场景，不用判断第一根手指滑动的有效性
    if (!this.aiBarViewModel?.aiBarData.isInGameSign) {
      return true;
    }
    // 没有其他手指滑动，第一根手指滑动有效
    if (!this.params.isHasOtherFinger) {
      return true;
    }
    // 有其他手指滑动，第一根手指滑动大于20px为有效滑动
    log.showInfo(`firstFingerMoveOffset: ${this.params.firstFingerMoveOffset}`);
    if (this.params.firstFingerMoveOffset > px2vp(SystemSceneConstants.FIRST_FINGER_MOVE_THRESHOLD)) {
      return true;
    }
    return false;
  }

  /**
   * 重置参数
   */
  public reset(): void {
    this.params.reset();
  }

  /**
   * 是否是第一根手指按下
   *
   * @param event
   * @returns
   */
  private isFirstFinger(event: TouchEvent): boolean {
    let touchId = event.changedTouches[0].id;
    return touchId === SystemSceneConstants.FIRST_FINGER_TOUCH_ID ||
      touchId === SystemSceneConstants.MOUSE_TOUCH_ID || touchId === SystemSceneConstants.PEN_TOUCH_ID;
  }

  /**
   * 计算第一根手指的滑动距离
   *
   * @param event
   */
  private calculateFirstFingerMoveOffset(event: TouchEvent): void {
    // 非第一根手指的Touch事件，不计算第一根手指的滑动距离
    if (!this.isFirstFinger(event)) {
      return;
    }
    // 没有其他手指滑动，第一根手指滑动有效，不用计算第一根手指的滑动距离
    if (!this.params.isHasOtherFinger) {
      return;
    }
    if (event.changedTouches[0].id === this.params.firstFingerEvent?.changedTouches[0].id) {
      let offsetX = Math.abs(event.changedTouches[0].x - this.params.firstFingerEvent?.changedTouches[0].x);
      let offsetY = Math.abs(event.changedTouches[0].y - this.params.firstFingerEvent?.changedTouches[0].y);
      this.params.firstFingerMoveOffset = Math.sqrt(offsetX * offsetX + offsetY * offsetY);
      log.showInfo(`onTouch first finger move ${this.params.firstFingerMoveOffset}`);
    }
  }
}