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

import {
  AnimEvent,
  ComponentPosition,
  WidgetAnimStateV2,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import { IImmersiveAnimBaseVm } from './IImmersiveAnimBaseVm';

// 条目翻转折叠更新入参
export interface ItemFoldParam {
  offset?: number; // 即将滑动偏移
  sizeChangeItem?: string; // 大小切换条目标识
  oldSize?: number; // 切换前大小
  newSize?: number; // 切换后大小
  isResolveWait?: boolean; // 是否释放动效等待
  isFromScroll?: boolean; // 更新是否来源滑动
}

/**
 * 沉浸列表模块动效业务抽象层
 */
export interface IImmersiveListAnimVm extends IImmersiveAnimBaseVm {
  /**
   * 列表根布局动效状态管理器
   *
   * @returns 根布局动效管理器
   */
  getRootAnimSt(): WidgetAnimStateV2;

  /**
   * 列表条目通用动效状态管理器
   *
   * @param groupKey 条目标识
   * @returns 条目通用动效管理器
   */
  getItemComAnimSt(groupKey: string): WidgetAnimStateV2 | undefined;

  /**
   * 列表条目阴影组件动效状态管理器
   *
   * @param groupKey 条目标识
   * @returns 条目阴影组件动效管理器
   */
  getItemShadowAnimSt(groupKey: string): WidgetAnimStateV2 | undefined;

  /**
   * 列表条目折叠翻转动效状态管理器
   *
   * @param groupKey 条目标识
   * @returns 条目折叠翻转动效管理器
   */
  getItemFoldAnimSt(groupKey: string): WidgetAnimStateV2 | undefined;

  /**
   * 列表条目inner动效状态管理器
   *
   * @param groupKey 条目标识
   * @returns 条目inner动效管理器
   */
  getItemInnerAnimSt(groupKey: string): WidgetAnimStateV2 | undefined;

  /**
   * 列表条目背景动效状态管理器
   *
   * @param groupKey 条目标识
   * @returns 条目背景动效管理器
   */
  getItemBgAnimSt(groupKey: string): WidgetAnimStateV2 | undefined;

  /**
   * 列表根布局样式状态管理器
   *
   * @returns 根布局样式状态管理器
   */
  getRootStyle(): WidgetStyleStateV2 | undefined;

  /**
   * 列表条目通用样式状态管理器
   *
   * @param groupKey 条目标识
   * @returns 条目通用样式管理器
   */
  getItemComStyle(groupKey: string): WidgetStyleStateV2 | undefined;

  /**
   * 列表根布局位置
   *
   * @returns 位置
   */
  getRootPos(): ComponentPosition | undefined;

  /**
   * 列表条目位置
   *
   * @param groupKey 条目唯一标识
   * @returns 位置
   */
  getItemPos(groupKey: string): ComponentPosition | undefined;

  /**
   * 列表数据大小
   *
   * @returns 数据大小
   */
  getListDataSize(): number;

  /**
   * 可见条目起始索引
   *
   * @returns 起始索引
   */
  getItemStartIndex(): number;

  /**
   * 可见条目结束索引
   *
   * @returns 结束索引
   */
  getItemEndIndex(): number;

  /**
   * 目标索引条目的标识
   *
   * @param itemIndex 目标索引
   * @returns 条目标识
   */
  getItemGroupKey(itemIndex: number): string | undefined;

  /**
   * 启动列表对齐方式切换动效
   *
   * @param isReachMax 是否最大栅格
   * @param endValue 动效终值
   */
  startListAlignAnim(isReachMax: boolean, endValue: AnimEvent): void;

  /**
   * 启动列表数据刷新动效
   *
   * @param endValue 动效终值
   */
  startListDataAnim(endValue: AnimEvent): void;
}