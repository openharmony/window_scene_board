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

import Curves from '@ohos.curves';

/**
 * 向上竖滑阻尼系数，竖移值*系数
 */
const SWIPE_DAMP = 0.5;

/**
 * 横幅上滑阈值隐藏
 */
const HIDE_HEADS_UP_DISTANCE = 20;

// 位移转换为动画时间的系数
const ANIM_DURATION_FACTOR = 10;

/**
 * 横幅条目竖滑控制器
 */
export class BannerSwipeYController {
  /**
   * 竖滑回调集
   */
  private swipeCallback?: SwipeYCallback;
  /**
   * 当次滑动是否为竖向滑动
   */
  private isVertical: boolean = false;
  /**
   * 开始滑动前，条目平移位置
   */
  private startAnimItemTranY: number = 0;
  /**
   * 通知条目当前竖向平移距离
   */
  private itemTranY: number = 0;

  /**
   * 注册滑动监听器
   *
   * @param swipeCallback 回调器
   */
  public registerSwipeCallback(swipeCallback: SwipeYCallback): void {
    this.swipeCallback = swipeCallback;
  }

  /**
   * 解注册滑动监听器
   */
  public unregisterSwipeCallback(): void {
    this.swipeCallback = undefined;
  }

  /**
   * 开始竖滑
   *
   * @param event 手势事件
   */
  public onStartSwipe(event: GestureEvent): void {
    this.isVertical = this.isVerticalSwipe(event);
    if (!this.isVertical) {
      return;
    }
    this.startAnimItemTranY = event.offsetY;
    this.notifyTranYChange(event.offsetY);
  }

  /**
   * 更新竖滑
   *
   * @param event 手势事件
   */
  public onUpdateSwipe(event: GestureEvent): void {
    if (!this.isVertical) {
      return;
    }
    this.notifyTranYChange(event.offsetY);
  }

  /**
   * 结束竖滑
   *
   * @param event 手势事件
   */
  public onEndSwipe(event: GestureEvent): void {
    if (!this.isVertical) {
      return;
    }
    this.notifyTranYChange(event.offsetY);
    this.handleSwipeTouchEnd();
  }

  /**
   * 竖滑被取消
   */
  public onCancelSwipe(): void {
    if (!this.isVertical) {
      return;
    }
    this.handleSwipeTouchEnd();
  }

  /**
   * 是否竖向滑动
   *
   * @param event 滑动事件
   * @return true 竖向
   */
  private isVerticalSwipe(event: GestureEvent): boolean {
    return Math.abs(event.offsetY) > Math.abs(event.offsetX);
  }

  /**
   * 移动距离回调
   *
   * @param tranY 触摸竖移距离
   */
  private notifyTranYChange(tranY: number): void {
    let oriItemTranY = tranY + this.startAnimItemTranY;
    let realItemTranY = oriItemTranY;
    realItemTranY = oriItemTranY * SWIPE_DAMP;
    this.notifyTranYEndValue(realItemTranY);
  }

  /**
   * 回调竖移最终值
   *
   * @param endTranY 最终值
   * @param itemAnim 动效参数
   */
  private notifyTranYEndValue(endTranY: number, itemAnim?: AnimateParam): void {
    if (this.itemTranY !== endTranY) {
      this.itemTranY = endTranY;
      this.swipeCallback?.onUpdateItemTranY?.(endTranY, itemAnim);
    }
  }

  /**
   * 处理touch滑动结束事件
   */
  private handleSwipeTouchEnd(): void {
    if (this.itemTranY < 0 && (Math.abs(this.itemTranY) > HIDE_HEADS_UP_DISTANCE)) {
      this.notifyHideBanner();
    } else {
      this.startTranYAnim(0);
    }
  }

  /**
   * 开启移动动画
   *
   * @param endTranY 移动最终值
   * @param isHideEntry 是否隐藏通知
   */
  private startTranYAnim(endTranY: number): void {
    const dTranY: number = Math.abs(endTranY - this.itemTranY);
    let anim: AnimateParam = {
      duration: Math.round(dTranY) * ANIM_DURATION_FACTOR,
      curve: Curves.springCurve(0, 1, 80, 14),
      onFinish: () => {
      }
    };
    this.notifyTranYEndValue(endTranY, anim);
  }

  /**
   * 隐藏事件回调
   */
  private notifyHideBanner(): void {
    this.swipeCallback?.onHideBanner?.();
  }
}

/**
 * swipe处理结果回调
 */
export interface SwipeYCallback {
  /**
   * 更新通知条目竖向移动距离
   * 带有动画参数则启动动效，否则直接变更tranY属性
   *
   * @param tranY 移动距离
   * @param itemAnim 动画参数
   */
  onUpdateItemTranY?(tranY: number, itemAnim?: AnimateParam): void;

  /**
   * 更新通知条目隐藏事件
   */
  onHideBanner?(): void;
}