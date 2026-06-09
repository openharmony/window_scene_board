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

import { AnimEvent, ComponentPosition } from '@ohos/screenlockcommon/Index';
import { ImmersiveTypeScene } from '@ohos/systemuicommon';
import { NotificationArray, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { ImmListData } from '../../model/data/v2/ImmListData';
import { SlListBindStateV2 } from '../../model/data/v2/SlListBindStateV2';
import { SlListStaticStateV2 } from '../../model/data/v2/SlListStaticStateV2';
import { IImmDataShareVm } from './IImmDataShareVm';
import { IImmersiveExtendVm } from './IImmersiveExtendVm';
import { IImmGestureEventVm } from './IImmGestureEventVm';
import { IImmLifeCycleVm } from './IImmLifeCycleVm';

/**
 * 沉浸列表业务管理抽象层
 */
export interface IImmersiveListVm extends IImmersiveExtendVm, IImmDataShareVm, IImmLifeCycleVm, IImmGestureEventVm {
  /**
   * 锁屏通知列表数据
   *
   * @returns 列表数据
   */
  getSlNtfList(): NotificationArray;

  /**
   * 取值列表数据
   *
   * @param groupKey 分组标识
   * @returns 列表数据
   */
  getListData(groupKey?: string): ImmListData | undefined;

  /**
   * 静态状态管理器
   *
   * @returns 静态状态管理器
   */
  getSlStaticState(): SlListStaticStateV2;

  /**
   * UI绑定状态管理器
   *
   * @returns UI绑定状态管理器
   */
  getSlBindState(): SlListBindStateV2;

  /**
   * 检测条目横滑状态，是否拦截点击事件
   *
   * @param ntf 条目数据
   * @returns true 拦截点击事件
   */
  checkSwipeInterruptClick(ntf?: NotificationBase): boolean;

  /**
   * 嫁接通知中心，刷新列表数据
   */
  graftUpdateNtf(): void;

  /**
   * 缓存条目位置
   *
   * @param groupKey 分组标识
   * @param position 条目位置
   */
  cacheItemPosition(groupKey: string, position: Area | SizeOptions | ComponentPosition): void;

  /**
   * 取值条目位置
   *
   * @param groupKey 分组标识
   * @returns 条目位置
   */
  getItemPosition(groupKey: string): ComponentPosition | undefined;

  /**
   * 列表整体区域变化回调
   *
   * @param oldValue 旧区域
   * @param newValue 新区域
   */
  onListAreaChange(oldValue: Area, newValue: Area): void;

  /**
   * 列表即将滑动回调
   *
   * @param willOffset 即将滑动偏移
   */
  onListWillScroll(willOffset?: number): void;

  /**
   * 列表滑动到起始位置
   */
  onReachStart(): void;

  /**
   * 列表滑动到末尾位置
   */
  onReachEnd(): void;

  /**
   * 列表条目上树回调
   *
   * @param itemData 条目数据
   * @param index 条目索引
   */
  onItemAppear(itemData: NotificationBase, index: number): void;

  /**
   * 列表条目显示区域变化
   *
   * @param itemData 条目数据
   * @param newValue 新区域
   * @param index 条目索引
   */
  onItemAreaChange(itemData: NotificationBase, newValue: Area, index: number): void;

  /**
   * 列表条目大小变化
   *
   * @param itemData 条目数据
   * @param oldValue 旧大小
   * @param newValue 新大小
   */
  onItemSizeChange(itemData: NotificationBase, oldValue: SizeOptions, newValue: SizeOptions): void;

  /**
   * 列表条目可见索引变化回调
   */
  onScrollIndexChange(): void;

  /**
   * 列表条目图标点击
   *
   * @param groupKey 分组标识
   */
  onItemIconClick(groupKey: string): void;

  /**
   * 列表过渡胶囊
   *
   * @param vel 速度
   * @param scene 场景
   * @param onFinish 动效结束回调
   */
  onListToCap(vel?: number, scene?: ImmersiveTypeScene, onFinish?: AnimEvent): void;
}