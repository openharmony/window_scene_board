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
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SwipeInwardController';
const homeLog: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

class SwipeInwardEvent {
  public x: number = -1;
  public y: number = -1;
  public timestamp: number = 0;

  clone(event: SwipeInwardEvent): void {
    this.x = event.x;
    this.y = event.y;
    this.timestamp = event.timestamp;
  }

  set(x: number, y: number, time: number): void {
    this.x = x;
    this.y = y;
    this.timestamp = time;
  }

  reset(): void {
    this.set(-1, -1, 0);
  }

}
// 滑动方向
enum SwipeInwardDirection {
  SWIPE_INWARD_NONE = 0,
  SWIPE_INWARD_LEFT = 1,
  SWIPE_INWARD_RIGHT = 2,
}
// 常量
export class SwipeInwardConstants {
  public static readonly SWIPE_INWARD_TOUCHPAD_WIDTH = 120; // touch pad width
  public static readonly SWIPE_INWARD_TOUCHPAD_HEIGHT = 72; // touch pad height
  public static readonly SWIPE_INWARD_ANGLE_THRESHOLD = 2; // 内滑角度阈值(竖直/水平)
  public static readonly SWIPE_INWARD_MAX_DIS_THREE = 45; // 内滑手势最长距离
  public static readonly SWIPE_INWARD_MIN_FRAME = 5; // 数据帧要求的最小数量
  public static readonly SWIPE_INWARD_OFFSET_FACTOR = 1.5; // 数据帧要求的最小数量
  public static readonly SWIPE_INWARD_HALF = 0.5;
  public static readonly VIRTUAL_TOUCHPAD_WIDTH = 120 * 2.0;
  public static readonly BACK_DISTANCE_THRESHOLD = 0;
  public static readonly BACK_ANGLE_THRESHOLD = 95;
  public static readonly CANCEL_BACK_DISTANCE_THRESHOLD = 16;
  public static readonly CANCEL_BACK_DISTANCE_THRESHOLD_120 = 32;
}

export class SwipeInwardController {
  private readonly NS_COUNT_PER_MS: number = 1000000;
  private isHandling: boolean = false;
  private gestureFrames: number = 0;
  private curState: number = SwipeInwardDirection.SWIPE_INWARD_NONE;

  private prePointerData: SwipeInwardEvent = new SwipeInwardEvent();
  private curPointerData: SwipeInwardEvent = new SwipeInwardEvent();
  private startPointerData: SwipeInwardEvent = new SwipeInwardEvent();
  private endPointerData: SwipeInwardEvent = new SwipeInwardEvent();

  public getHandleState(): boolean {
    return this.isHandling;
  }

  public beginHandle(x: number, y: number, time: number): void {
    this.isHandling = true;
    this.gestureFrames = SwipeInwardConstants.SWIPE_INWARD_MIN_FRAME;
    this.startPointerData.set(x, y, time);
    this.prePointerData.set(x, y, time);
    this.curPointerData.set(x, y, time);
    this.curState = SwipeInwardDirection.SWIPE_INWARD_NONE;
  }

  public endHandle(): void {
    this.isHandling = false;
  }

  public updatePointerData(x: number, y: number, time: number): void {
    this.prePointerData.set(this.curPointerData.x, this.curPointerData.y, this.curPointerData.timestamp);
    this.curPointerData.set(x, y, time);
  }

  public calculateAndJudge(): void {
    if (this.curPointerData.timestamp === this.prePointerData.timestamp) {
      return;
    }
    // 初始方向判断
    if (this.curState === SwipeInwardDirection.SWIPE_INWARD_NONE) {
      if (this.curPointerData.x < this.prePointerData.x) {
        this.curState = SwipeInwardDirection.SWIPE_INWARD_LEFT;
      } else if (this.curPointerData.x > this.prePointerData.x) {
        this.curState = SwipeInwardDirection.SWIPE_INWARD_RIGHT;
      }
    }
    // 滑动方向左右校验
    if ((this.curPointerData.x < this.prePointerData.x && SwipeInwardDirection.SWIPE_INWARD_RIGHT === this.curState) ||
      (this.curPointerData.x > this.prePointerData.x && SwipeInwardDirection.SWIPE_INWARD_LEFT === this.curState)) {
      homeLog.showInfo('judge finish: direction err, curState: %{public}d, curX: %{public}d, preX: %{public}d',
        this.curState, this.curPointerData.x, this.prePointerData.x);
      this.isHandling = false;
    }
    // 滑动相对水平角度不能过大
    if (Math.abs(this.curPointerData.y - this.startPointerData.y) >
      Math.abs(this.curPointerData.x - this.startPointerData.x) * SwipeInwardConstants.SWIPE_INWARD_ANGLE_THRESHOLD) {
      homeLog.showInfo('swipeInward judge finish:swipe angle err');
      this.isHandling = false;
    }
    // 内滑距离不能过长(待优化，后续下沉到多模)
    if (Math.abs(this.curPointerData.x - this.startPointerData.x) >
      SwipeInwardConstants.SWIPE_INWARD_TOUCHPAD_WIDTH * SwipeInwardConstants.SWIPE_INWARD_MAX_DIS_THREE) {
      homeLog.showInfo('swipeInward judge finish:swipe distance too long, distance: %{public}d',
        Math.abs(this.curPointerData.x - this.startPointerData.x));
      this.isHandling = false;
    }
    // 防止大面积机制影响
    this.gestureFrames--;
  }

  public judgeIfDoBack(): boolean {
    if (this.gestureFrames > 0) {
      homeLog.showInfo(`swipeInward judge finish:swipe frames few ${this.gestureFrames}`);
      return false;
    }
    return true;
  }

  public reset(): void {
    this.isHandling = false;
    this.gestureFrames = SwipeInwardConstants.SWIPE_INWARD_MIN_FRAME;
    this.curState = SwipeInwardDirection.SWIPE_INWARD_NONE;
    this.prePointerData.reset();
    this.curPointerData.reset();
    this.startPointerData.reset();
    this.endPointerData.reset();
  }

  public createGestureEvent(startPositionX: number, startPositionY: number,
    screenWidth: number, screenHeight: number): GestureEvent {
    let event: GestureEvent = {
      repeat: false,
      fingerList: [{
        id: 0,
        localX: 0,
        localY: 0,
        globalX: 0,
        globalY: 0,
        displayX: 0,
        displayY: 0
      }],
      offsetX: this.getOffsetX(startPositionX) * SwipeInwardConstants.SWIPE_INWARD_OFFSET_FACTOR,
      offsetY: startPositionY,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area: {
          width: 0,
          height: 0,
          position: { x: 0, y: 0 },
          globalPosition: { x: 0, y: 0 }
        }
      },
      timestamp: this.curPointerData.timestamp * this.NS_COUNT_PER_MS,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.TOUCHPAD
    };
    // 根据触控板的宽度换算成屏幕的位置, x轴坐标需要缩小
    event.fingerList[0].globalX = startPositionX / SwipeInwardConstants.VIRTUAL_TOUCHPAD_WIDTH * px2vp(screenWidth);
    event.fingerList[0].globalY =
      startPositionY / SwipeInwardConstants.SWIPE_INWARD_TOUCHPAD_HEIGHT * px2vp(screenHeight);
    // 相对于当前组件元素原始区域左上角的y轴坐标,  根据触控板高度换算成屏幕的高度
    event.fingerList[0].localY =
      startPositionY / SwipeInwardConstants.SWIPE_INWARD_TOUCHPAD_HEIGHT * px2vp(screenHeight);
    return event;
  }
 
  private getOffsetX(positionX: number): number {
    // 向右滑动
    if (this.curState === SwipeInwardDirection.SWIPE_INWARD_RIGHT) {
      return positionX;
    }
    if (this.curState === SwipeInwardDirection.SWIPE_INWARD_LEFT) {
      // 向左滑动
      return positionX - SwipeInwardConstants.SWIPE_INWARD_TOUCHPAD_WIDTH;
    }
    return positionX < SwipeInwardConstants.SWIPE_INWARD_TOUCHPAD_WIDTH * SwipeInwardConstants.SWIPE_INWARD_HALF ?
      positionX : positionX - SwipeInwardConstants.SWIPE_INWARD_TOUCHPAD_WIDTH;
  }
}