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
import inputMonitor from '@ohos.multimodalInput.inputMonitor';
import { TouchEvent } from '@ohos.multimodalInput.touchEvent';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'TouchMoveMonitor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class Point {
  x: number = 0;
  y: number = 0;
}

export class TouchMoveMonitor {
  private isMonitoring: boolean = false;
  private getTouchPosition: (touchEvent: TouchEvent) => Point = this.defaultGetTouchPosition;
  private receivePositionCallback: (position: Point, touchEvent: TouchEvent) => void = () => {};

  /**
   * 开启多模事件监听
   * @param onMoveCallback 回调
   *
   * @return 是否开启成功
   */
  public start(onMoveCallback: (position: Point, touchEvent: TouchEvent) => void): boolean {
    if (this.isMonitoring) {
      log.showInfo('monitoring, don`t run "start" again!');
      return false;
    }

    try {
      this.receivePositionCallback = onMoveCallback;
      inputMonitor.on('touch', this.onMove);
      this.isMonitoring = true;
      log.showInfo('inputMonitor start!');
      return true;
    } catch (error) {
      log.showWarn(`start inputMonitor failed! code:${error.code} msg:${error.message}`);
      this.reSet();
    }
    return false;
  }

  /**
   * 关闭多模事件监听
   *
   * @return 是否关闭成功
   */
  public end(): boolean {
    if (!this.isMonitoring) {
      log.showInfo('monitor has not started!');
      return false;
    }

    try {
      this.reSet();
      inputMonitor.off('touch', this.onMove);
      this.isMonitoring = false;
      log.showInfo(`inputMonitor off! this.isMonitoring:${this.isMonitoring}`);
      return true;
    } catch (error) {
      log.showWarn(`end inputMonitor failed! code:${error.code} msg:${error.message}`);
    }
    return false;
  }

  /**
   * 重写获取触摸位置方法
   * @param fn 重写方法
   */
  public overrideGetTouchPosition(fn: (touchEvent: TouchEvent) => Point): void {
    this.getTouchPosition = fn;
  }

  private defaultGetTouchPosition(touchEvent: TouchEvent): Point {
    const touch = touchEvent.touches[0];
    if (!touch) {
      return {x: -1, y: -1};
    }
    return {
      x: px2vp(touch.windowX),
      y: px2vp(touch.windowY)
    };
  }

  private reSet(): void {
    this.receivePositionCallback = (): void => {};
    this.getTouchPosition = this.defaultGetTouchPosition;
  }

  private onMove: inputMonitor.TouchEventReceiver = (touchEvent: TouchEvent) => {
    const touchPosition = this.getTouchPosition(touchEvent);
    this.receivePositionCallback(touchPosition, touchEvent);
    //若返回true，本次触摸后续产生的事件不再分发到窗口；若返回false，本次触摸后续产生的事件还会分发到窗口。
    return false;
  };
}