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
import { NormalNotificationGroup } from '../../model/NormalNotificationGroup';
import { NotificationArray, NotificationBase } from '../../model/NotificationBase';

export enum NotificationRefreshType {
  DATA_INIT,
  DATA_ADD,
  DATA_UPDATE,
  DATA_DELETE
}

/**
 * 通知数据刷新记录仪
 */
export interface NotificationRefreshRecord {
  // 数据是否有刷新
  isDataRefresh: boolean;
  // 数据刷新类型
  dataRefreshType: NotificationRefreshType;
  // 新增/删除数据集(groupKey)
  changeDataSet?: Set<string>;
  // 更新数据集(groupKey)
  updateDataSet?: Set<string>;
}

/**
 * 通知数据管理业务
 */
export interface INotificationDataVm {
  /**
   * 初始化
   */
  init(): void;

  /**
   * 销毁
   */
  destroy(): void;

  /**
   * 分组数据集遍历
   *
   * @param callback 遍历回调
   */
  groupForEach(callback: (value: NotificationBase, key: string, map: Map<string, NotificationBase>) => void): void;

  /**
   * 取值分组数据
   *
   * @param groupKey 分组标识
   * @returns 分组数据
   */
  getNtfByGroupKey(groupKey: string): NotificationBase | undefined;

  /**
   * 取值单数据
   *
   * @param hashcode 单通知标识
   * @returns 单数据
   */
  getNtfByHashCode(hashcode: string): NotificationBase | undefined;

  /**
   * 获取一个单通知所属的组通知
   *
   * @param ntf 单通知数据
   * @returns 组通知数据
   */
  getGroupNtf(ntf: NotificationBase): NormalNotificationGroup | undefined;

  /**
   * 解除组通知
   *
   * @param group 组通知数据
   */
  releaseGroup(group: NormalNotificationGroup): void;
}