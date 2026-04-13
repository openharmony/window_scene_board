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

import { DragItemPosition } from '@ohos/componentdrag';
import { DesktopDragResult } from '../bean/DesktopDragResult';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { CellLayoutDragDelegate } from '@ohos/componentdrag/src/main/ets/TsIndex';

/**
 * 桌面拖拽代理接口类
 */
export interface IDesktopDragHandler {
  /**
   * 拖拽开始
   *
   * @param x 坐标x
   * @param y 坐标y
   */
  onDragStart(x: number, y: number): void;

  /**
   * 拖拽松手
   *
   * @param x 坐标x
   * @param y 坐标y
   * @param event 拖拽事件
   * @param extraParams 拖拽参数
   * @returns
   */
  onDragDrop(x: number, y: number, event?: DragEvent, extraParams?: string): DesktopDragResult;

  /**
   * 拖拽离开
   *
   * @param x 坐标x
   * @param y 坐标y
   * @returns
   */
  onDragLeave(x: number, y: number): void;

  /**
   * 设置拖拽开始位置信息
   *
   * @param startPosition 起拖元素开始位置信息
   */
  setStartPosition(startPosition?: DragItemPosition): void;

  /**
   * 获取开始拖拽元素touch触碰位置
   *
   * @param x 位置x
   * @param y 位置y
   * @returns 位置信息
   */
  getTouchPosition(x: number, y: number): DragItemPosition;

  /**
   * 获取拖拽内部维护的pageIndex
   */
  getDragPageIndex(): number;

  /**
   * 获取发生拖拽的页面对应的pageIndex
   * @returns 页面数
   */
  getCurrentPageIndex(): number;

  /**
   * 获取拖拽元素数组，适配多选拖拽场景
   *
   * @returns 拖拽元素数组
   */
  getDragItems(): GridLayoutItemInfo[] | undefined;

  /**
   * 清空翻页定时器
   */
  clearSwipeTimeout(): void;

  /**
   * 拖拽离开图标后, 清理上一个图标的背板动效, 进行回缩动效
   */
  clearLastCoveredItemAnimation(): void;

  /**
   * 获取拖拽代理
   *
   * @returns
   */
  getDragDelegate(): CellLayoutDragDelegate | undefined;
}
