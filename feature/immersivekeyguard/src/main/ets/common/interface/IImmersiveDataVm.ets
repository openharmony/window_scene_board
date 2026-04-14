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

import { INotificationDataVm } from '@ohos/systemuicommon/newIndex';
import { NotificationArray } from '@ohos/systemuicommon/newTsIndex';

/**
 * 沉浸模块数据接收处理业务抽象层
 */
export interface IImmersiveDataVm extends INotificationDataVm {
  /**
   * 全量数据索引集
   *
   * @returns 索引集 groupKey -> index
   */
  getDataIndexMap(): Map<string, number>;

  /**
   * 单个数据索引映射
   *
   * @param groupKey 分组标识
   * @returns 索引值，-1表示无对应映射
   */
  getDataIndex(groupKey?: string): number;

  /**
   * 支持沉浸态的数据集
   *
   * @returns 数据集
   */
  getImmList(): NotificationArray;
}