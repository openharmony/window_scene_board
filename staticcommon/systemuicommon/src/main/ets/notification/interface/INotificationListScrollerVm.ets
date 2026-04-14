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
import { NotificationBase } from '../../model/NotificationBase';

/**
 * 通知列表滚动控制的VM
 */
export interface INotificationListScrollerVm {
  /**
   * 滚动条对象
   */
  scroller: Scroller;

  /**
   * 当前滚动条产生的总位移
   */
  currentOffsetY: number;

  /**
   * 列表间间隔
   */
  space: number;

  /**
   * 列表滚动条状态
   */
  barState: BarState;

  /**
   * 第一条通知的index
   */
  startIndex: number;

  /**
   * 最后一条通知的index
   */
  endIndex: number;

  /**
   * 第一个item的scroll堆叠效果产生的纵向位移
   */
  startItemTranslateY: number;

  /**
   * 当前列表是否正在滑动中
   */
  isScrolling: boolean;

  /**
   * 通知中心下滑最大距离
   */
  maxDropDownDis: number;

  /**
   * 更新滑动状态
   * @param isStart 滑动事件 是：开始滑动 否：结束滑动
   */
  updateScrollStatus(isStart: boolean): void;

  /**
   * 列表高度变化
   * @param size
   */
  onListSizeChange(size: SizeOptions): void;

  /**
   * 滚动项变化时回调
   * @param start
   * @param end
   */
  onScrollIndex(start: number, end: number): void;

  /**
   * 每一次滚动之前回调
   */
  onWillScroll(scrollOffset: number, scrollState: ScrollState): void;
  /**
   * 每一次滚动之后回调
   */
  onDidScroll(scrollOffset: number, scrollState: ScrollState): void;
  /**
   * 滑动开始回调
   */
  onStartScroll(): void;
  /**
   * 滑动结束回调
   */
  onStopScroll(): void;

  /**
   * 滚动到顶部
   */
  scrollToTop(): void;

  /**
   * 删除链式补位动效
   *
   * @param ntf 被删除的通知
   * @param index 被删除通知的index下标
   * @param doDelete 具体删除操作
   */
  doDeleteChainAnimation(ntf: NotificationBase, index: number, doDelete: () => void): void;

  /**
   * 滚动场景item列表显示更新（位移、透明度、缩放）
   * @param scrollOffset 滚动条位移
   * @param onlyMiddle 是否仅处理中间item 忽略首尾
   * @param handleEndNextItem 是否处理底部下一个待显示的item
   */
  transform(scrollOffset?: number, onlyMiddle?: boolean, handleEndNextItem?: boolean): void;

  /**
   * 更新动效参数，增加防抖处理
   */
  debouncedTransform(): void

  /**
   * 处理最后一张卡片的堆叠效果
   */
  transformEndItem(scrollOffset?: number, notification?: NotificationBase, forceTransform?: boolean): void;

  /**
   * 获取最后一张卡片堆叠态的translateY
   */
  getEndItemTranslateY(): number | undefined;

  /**
   * 列表向上滚动一段距离
   */
  scrollUpIfNeed(ntf?: NotificationBase): void;

  scrollMoreNtfToBottomIfNeed(): void;

  /**
   * 获取一镜到底卡片裁切rect
   * @param itemRect
   * @returns
   */
  getOneMirrorCardClipRect(itemRect: RectResult): RectResult;
}