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

import { ResizeConfig, ResizeHotArea } from '../../../common/FolderResizeConstants';
import { IObserver } from './IObserver';

/**
 * 布局属性相关的observer接口
 */
export interface ResizeObserverImpl extends IObserver {
  /**
   * 更新正在拖拽的热区位置，进而更新拖拽把手的显隐
   *
   * @param hotArea 拖拽热区
   */
  refreshHotArea(hotArea: ResizeHotArea, isRefreshAlign: boolean): void;

  /**
   * 获取动画的背板属性
   * @param resizeConfig 目标config
   * @param gapX 边框GAP
   */
  getBgAnimatorEvent(resizeConfig: ResizeConfig, gapX?: number): () => void;

  /**
   * 背板X方向回弹
   * @param resizeConfig 目标config
   * @returns
   */
  getBgReboundX(resizeConfig: ResizeConfig): () => void;

  /**
   * 背板Y方向回弹
   * @param resizeConfig 目标config
   * @returns
   */
  getBgReboundY(resizeConfig: ResizeConfig): () => void;

  /**
   * 拖拽过程文件夹名的X位移
   * @param translate 位移量
   */
  setNameTransX(translate: number): void;

  /**
   * 拖拽过程文件夹名的X位移
   */
  getNameTransX(): number;

  /**
   * 拖拽过程文件夹名的Y位移
   * @param translate 位移量
   */
  setNameTransY(translate: number): void;

  /**
   * 拖拽过程文件夹名的Y位移
   */
  getNameTransY(): number;

  /**
   * 设置目标的zIndex
   * @param index 目标的索引
   * @param zIndex 目标的zIndex
   */
  setZIndex(index: number, zIndex: number): void;

  /**
   * 获取目标的zIndex
   * @param index 目标的索引
   */
  getZIndex(index: number): number;

  /**
   * 获取热区方向
   * @returns
   */
  getHotAreaPosition(): number;

  /**
   * 重置背板参数
   */
  resetBgParams(): void;
}