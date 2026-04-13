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
import { LiveNotification } from '../model/LiveNotification';

/**
 * 实况卡片列表VM
 */
export interface ILiveCardListVm {
  /**
   * 实况列表
   */
  liveList: LiveNotification[];
  /**
   * 实况通知Map
   */
  liveMap: Map<string, LiveNotification>;
  /**
   * 列表滚动控制器
   */
  scroller: ListScroller;
  /**
   * 列表区域
   */
  listEventResponseArea?: Area;
  /**
   * 列表透明度
   */
  listOpacity: number;
  /**
   * 列表缩放，动画使用
   */
  listScale: number;
  /**
   * 列表滚动效果
   */
  listEdgeEffect: EdgeEffect;

  /**
   * 列表能否滑动
   */
  enableScroll: boolean;
  /**
   * 列表是否处于回弹状态
   */
  isListRebound: boolean;
  /**
   * 列表是否触顶
   */
  isAlreadyReachStart: boolean;
  /**
   * 列表是否触底
   */
  isAlreadyReachEnd: boolean;
  /**
   * 是否使用静态模糊
   */
  isUseStaticEffect: boolean;
  /**
   * 是否需要顶部的渐变模糊能力
   */
  isNeedHeaderBlur?: boolean;
  /**
   * 是否显示顶部的渐变模糊
   */
  isShowHeaderBlur: boolean;
  /**
   * 卡片列表宽度
   */
  containerWidth: Length;
  /**
   * 初始化
   */
  init(): void;

  /**
   * 解注册
   */
  destroy(): void;

  /**
   * 重置卡片列表
   */
  resetList(): Promise<void>;

  /**
   * 重置卡片透明度
   */
  resetOpacity(): void;

  /**
   * 列表区域变化回调
   */
  onListAreaChange(area: Area): void;

  /**
   * 列表触摸事件
   * @param event
   */
  onListTouch(event: TouchEvent): void;

  /**
   * 列表将要滚动回调
   */
  onListWillScroll(offsetTop: number, scrollState: ScrollState): void;

  /**
   * 列表显示的index
   * @param start
   * @param end
   * @param center
   */
  onScrollIndexChange(start: number, end: number, center: number): void;

  /**
   * 列表触底触顶回调
   * @param isReachTop 此次是否是触顶回调
   */
  onListReachStartOrEnd(isReachTop: boolean): void;

  /**
   * 初始化实况列表
   */
  initLiveList(liveList: LiveNotification[]): void;

  /**
   * 新增实况卡片，需要做一些更新动效
   */
  addLive(live: LiveNotification): Promise<void>;

  /**
   * 本地更新实况列表，是由环境变化场景触发的更新（如主题切换、深浅色切换、语言切换等），不需要做动效
   */
  localUpdateLiveList(liveList: LiveNotification[]): void;

  /**
   * 远端更新实况卡片，是由业务方触发的更新，需要做一些更新动效
   */
  remoteUpdateLive(live: LiveNotification): void;

  /**
   * 删除实况
   */
  removeLiveList(liveList: LiveNotification[]): void;

  /**
   * 清除实况数据
   */
  clearLiveList(): void;

  getCardLeftMargin(): number;

  /**
   * 滚动到顶部
   */
  scrollToTop(): void;

  /**
   * 卡片面板已入场
   */
  onPanelShow(): void;

  /**
   * 卡片面板已退场
   */
  onPanelHide(): void;

  /**
   * 获取顶部渐变模糊参数
   * @returns
   */
  getHeaderBlurFilter?(): Filter | undefined;
}