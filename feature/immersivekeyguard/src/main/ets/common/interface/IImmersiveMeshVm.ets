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

import { IImmersiveGraftVm } from './IImmersiveGraftVm';
import { IImmLifeCycleVm } from './IImmLifeCycleVm';

/**
 * 沉浸模块栅格业务抽象层
 */
export interface IImmersiveMeshVm extends IImmersiveGraftVm, IImmLifeCycleVm {
  /**
   * 通知单条目大小变化
   *
   * @param key 通知key值
   * @param oldSize 旧大小
   * @param newSize 新大小
   */
  onListItemSizeChange(key: string, oldSize: SizeOptions, newSize: SizeOptions): void;

  /**
   * 卡片大小变化
   *
   * @param oldSize 旧大小
   * @param newSize 新大小
   */
  onCardSizeChange(oldSize: SizeOptions, newSize: SizeOptions): void;

  /**
   * 列表通知key值变化时, 通知新增、删除等
   *
   * @param itemKeys 列表通知key值
   */
  onListItemKeysChange(itemKeys: Map<string, number>): void;

  /**
   * 触发锁屏时钟收起展开
   *
   * @param isNeedCollapse 时钟是否需要收起
   */
  screenLockClockShift(isNeedToCollapse: boolean): void;

  /**
   * 请求刷新栅格范围
   */
  requestUpdateMeshRange(): void;

  /**
   * 取值列表底部间距
   *
   * @returns 列表底部间距
   */
  getListBottomPadding(): number;

  /**
   * 刷新列表是否最大高度状态，非动效中调用，自带动效变形
   *
   * @param isReachMax true列表最大高度
   */
  updateListReachMax(isReachMax: boolean): void;
}