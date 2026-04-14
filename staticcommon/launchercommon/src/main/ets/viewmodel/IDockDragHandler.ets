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

import { GridLayoutItemInfo } from '../TsIndex'
import { RectangularCoordinates } from '@ohos/componenthelper';

/**
 * dock拖拽代理接口类
 */
export interface IDockDragHandler {
  /**
   * 获取dock元素item左上角位置
   *
   * @param folderItem 文件夹item
   * @returns 左上角位置点坐标
   */
  getDockItemLeftTopPosition(folderItem: GridLayoutItemInfo): RectangularCoordinates.Point;

  /**
   * 获取dock栏元素translate，用于新建元素时保持挤位偏移量
   *
   * @param key 元素标识
   * @returns 该元素的translate
   */
  getDockItemTranslate(key: string): number;

  /**
   * 获取dock文件夹中心点位置
   *
   * @param folderItem 文件夹信息
   * @returns 中心点位置
   */
  getDockItemPositionByItem(folderItem: GridLayoutItemInfo): number[];

  /**
   * 根据元素的index查找dock元素位置
   *
   * @param index 元素在dock列表里的序号
   * @returns 中心点位置信息
   */
  getDockItemPosition(index: number): number[];

  /**
   * 清除dock栏挤位信息
   */
  clearSqueezeInfo(): void
}