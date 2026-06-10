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

import { LiveNotification } from '../model/LiveNotification'

export interface ILiveHeadsUpVm {
  /**
   * 实况横幅数据
   */
  live?: LiveNotification;

  /**
   * 显示用的横幅数据
   */
  showLive?: LiveNotification;

  /**
   * 内容组件id
   */
  contentId: string;

  /**
   * 内容尺寸
   */
  contentSize?: SizeOptions;

  /**
   * 内容透明度
   */
  contentOpacity: number;

  /**
   * 内容横向位移
   */
  contentOffsetX: number;

  /**
   * 内容纵向位移
   */
  contentOffsetY: number;

  /**
   * 容器组件大小
   */
  containerSize?: SizeOptions;

  /**
   * 容器透明度
   */
  containerOpacity: number;

  /**
   * 是否打断横幅
   */
  isInterrupt: boolean;

  /**
   * 消息数组
   */
  timeoutMap: Map<string, number>;

  /**
   * 消息是否已经过期
   */
  isTimeout: boolean;
  /**
   * 横幅的hashcode
   */
  headsUpNtfHashCode?: string;

  /**
   * 当前胶囊是否处于hide中
   */
  isHiding: boolean;

  /**
   * 实况横幅之间是否为抢占出场
   */
  preemption: boolean;

  /**
   * 实况横幅不需要注册天气事件监听
   */
  isBannerWeatherScene: boolean;

  /**
   * 是否显示为实况横幅，用于控制组件是否显隐
   */
  isLiveHeadsUp: boolean;

  headsUpArea?: Area;

  /**
   * 挖孔变化回调
   */
  onCutoutChange(): void;

  /**
   * 初始化
   */
  init(): void;

  /**
   * 隐藏横幅
   */
  hide(live: LiveNotification): Promise<void>;

  /**
   * 立马隐藏横幅
   */
  hideImmediately(live: LiveNotification): Promise<void>;

  /**
   * 内容显示回调
   */
  onContentAppear: () => void;

  /**
   * 内容消失回调
   */
  onContentDisappear: () => void;

  /**
   * 横幅点击
   */
  onClick: () => Promise<void>;

  /**
   * 横幅触摸
   */
  onTouchEvent(event: TouchEvent): void;

  /**
   * 横幅位置变化
   */
  onListAreaChange(oldArea: Area, area: Area): void;

  /**
   * 清理定时器
   */
  clearTimeout(live: LiveNotification): void;

  /**
   * 调整并获取容器宽度，避免设置钱包小卡热区后，普通实况横幅出场时，onAreaChange不使能
   */
  getContainerWidth(containerWidth: number): number;

  getCardMargin(): LengthMetrics;

  getCardAlign(): Alignment;

  getCardPadding(): number;

  startWantAgentByHeadsUp(): Promise<void>;
}