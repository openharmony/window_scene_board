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
 * 通知列表滑动控制器
 *
 * @since 2022-12-29
 */
export class NtfListScrollController {
  /**
   * 是否滑动到底部
   */
  public isReachEnd: boolean = false;

  /**
   * list列表滑动控制器
   */
  private scroller: Scroller = new Scroller();

  /**
   * 下拉面板时跟手位移监听集
   */
  private followTranListeners: Set<OnFollowTranChangeListener> = new Set();

  private clearAllListeners: Set<OnClearAllAnimListener> = new Set();

  /**
   * 注册监听
   *
   * @param listener 监听器
   */
  registerOnFollowTranChangeListener(listener: OnFollowTranChangeListener): void {
    this.followTranListeners.add(listener);
  }

  /**
   * 注册监听
   *
   * @param listener 监听器
   */
  unregisterOnFollowTranChangeListener(listener: OnFollowTranChangeListener): void {
    this.followTranListeners.delete(listener);
  }

  /**
   * 注册监听
   *
   * @param listener 监听器
   */
  registerOnClearAllListener(listener: OnClearAllAnimListener): void {
    this.clearAllListeners.add(listener);
  }

  /**
   * 注册监听
   *
   * @param listener 监听器
   */
  unregisterOnClearAllListener(listener: OnClearAllAnimListener): void {
    this.clearAllListeners.delete(listener);
  }



  /**
   * 获取滑动控制器
   *
   * @return 滑动控制器
   */
  getScroller(): Scroller {
    return this.scroller;
  }

  /**
   * 滑动复位到第一个
   */
  scrollToFirst(): void {
    this.scroller.scrollEdge(Edge.Top);
  }

  /**
   * 下拉出面板时，数据列表跟随位移
   *
   * @param tranY 位移距离
   */
  followTranY(tranY: number): void {
    this.followTranListeners.forEach((listener: OnFollowTranChangeListener) => {
      listener.onFollowTranChange(tranY);
    });
  }

  clearAll(): void {
    this.clearAllListeners.forEach((listener: OnClearAllAnimListener) => {
      listener.onClearAllAnim();
    });
  }

  /**
   * 下拉面板回弹动效
   *
   * @param tranAnim 回弹动效
   */
  followTranANim(tranAnim: AnimateParam | null): void {
    this.followTranListeners.forEach((listener: OnFollowTranChangeListener) => {
      if (tranAnim != null) {
        listener.onFollowTranAnimChange(tranAnim)
      }
    });
  }

  /**
   * 下拉面板元素依次出现动效
   *
   * @param isShow 展示与隐藏
   * @param isWithAnim 是否伴随动效
   * @param isDropDownPanelHide 双中心面板是否收起
   */
  followTransItemAnim(isShow: boolean, isWithAnim: boolean, isDropDownPanelHide?: boolean): void {
    this.followTranListeners.forEach((listener: OnFollowTranChangeListener) => {
      listener.onFollowTranItemAnim(isShow, isWithAnim, isDropDownPanelHide);
    });
  }

  /**
   * 获取当前Y轴滚动偏移量
   *
   * @return 滚动偏移量
   */
  getCurrentOffset(): number {
    return this.scroller.currentOffset()?.yOffset;
  }

  /**
   * 设置是否达到底部
   *
   * @param isReachEnd true 到达底部
   */
  setReachEnd(isReachEnd: boolean): void {
    this.isReachEnd = isReachEnd;
  }
}

export interface OnClearAllAnimListener {
  onClearAllAnim():void;
}

/**
 * 下拉面板时跟手位移监听
 */
export interface OnFollowTranChangeListener {
  /**
   * Y轴位移回调
   *
   * @param tranY 平移值
   */
  onFollowTranChange(tranY: number): void;

  /**
   * Y轴位移动效
   *
   * @param tranAnim 平移动画
   */
  onFollowTranAnimChange(tranAnim: AnimateParam): void;

  /**
   * item元素动效
   *
   * @param isShow 显示与隐藏
   * @param isWithAnim 是否伴随动效
   * @param isDropDownPanelHide 双中心面板是否收起
   */
  onFollowTranItemAnim(isShow: boolean, isWithAnim: boolean, isDropDownPanelHide?: boolean): void;
}