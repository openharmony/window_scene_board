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

interface ProgressDot {
  offset: number;
  isInProgress: boolean;
}

/**
 * 三方实况卡片扩展区进度VM
 */
export interface ILiveCardOtherProgressVm {
  /*
   * 虚线进度条 坐标点横坐标集合
   */
  dots: ProgressDot[];

  /**
   * 虚线条宽度
   */
  dotProgressWidth: number;

  /*
   * 进度条高度
   */
  lineHeight: number;

  /*
   * 进度条颜色
   */
  lineColor: string;

  /*
   * 进度条背景颜色
   */
  lineBackgroundColor: string;

  /**
   * 进度条进度
   */
  lineProgress: number;

  /*
   * 指示器偏移量
   */
  translateX: number;

  /**
   * 指示器透明度
   */
  indicatorOpacity: number;

  /**
   * 指示器显示控制
   */
  isIndicatorShow: boolean;
  /**
   * 指示器显示类型
   */
  layoutIndicatorType: number;

  /**
   * 扩展区透明度
   */
  extendOpacity?: number | undefined;

  /**
   * 判断是否要执行动效
   */
  checkStartAnim(): boolean;
  /*
   * 处理进度条宽度变化
   */
  handleLineSizeChange(newSize: SizeOptions): void;

  /*
   * 处理指示器宽度变化
   */
  handleIndicatorOverlaySizeChange(newSize: SizeOptions): void;

  /*
   * 获取动效延时
   */
  checkAnimalDelay(): number;

  /**
   * 进度动效
   * @param delay 动效延时
   * @param resetType 0-不重置初始位置，1-重置初始位置为上一节点，2-重置初始位置为0点（默认1）
   * @returns
   */
  startProgressAnim(delay?: number, resetType?: 0 | 1 | 2): Promise<void>;

  /**
   * 判断当前指示器类型是否显示在进度线上方
   * @returns
   */
  isLayoutIndicatorTypeUp(): boolean;

  /**
   * 判断当前指示器类型是否显示覆盖在进度线上
   * @returns
   */
  isLayoutIndicatorTypeOverlay(): boolean;
}

