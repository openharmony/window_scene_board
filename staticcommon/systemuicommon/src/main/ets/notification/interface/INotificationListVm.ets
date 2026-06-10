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
import { DropDownEvent } from '@ohos/frameworkwrapper';
import { NotificationBase } from '../../model/NotificationBase';
import { INotificationDataVm } from './INotificationDataVm';

/**
 * 触发通知更新操作的枚举值
 */
export enum UpdateType {
  ADD_OR_UPDATE,
  COLLAPSE,
  DELETE_SINGLE,
  DELETE_CHILD,
  DELETE_GROUP,
  DELETE_MORE_BRIEF,
  CLEAR_ALL,
  DEVICE_MODE_CHANGE,
  DELETE_BATCH,
}

/**
 * 通知列表更新参数集合
 */
export interface IUpdateParam {
  /**
   * 触发更新的操作
   */
  updateType: UpdateType

  /**
   * 需要忽略的通知列表
   */
  ignoreNtfArr?: NotificationBase[]

  /**
   * 更新或删除的通知数据列表
   */
  updateNtfList?: NotificationBase[];

  /**
   * transform忽略执行
   */
  ignoreTransform?: boolean;
}

export interface INotificationListVm extends INotificationDataVm {
  /**
   * 获取主分区通知数据列表
   */
  mainNtfList: NotificationBase[];

  /**
   * 获取更多分区通知数据列表
   */
  moreNtfList: NotificationBase[];

  /**
   * 通知数据是否为空
   */
  isEmpty: boolean;

  /**
   * 展示的更多通知列表
   */
  displayedMoreNtfList: NotificationBase[];

  /**
   * 列表裁切
   */
  clipShape: PathAttribute | undefined;

  /**
   * Y轴偏移量，用于下拉跟手动效
   */
  translateY: number;

  /**
   * 松手回弹动效
   */
  reboundAnim: AnimateParam | null;

  /**
   * 通知列表容器外边距
   */
  margin: Margin;

  /**
   * 通知列表宽度
   */
  width: string;
  /**
   * 通知列表高度
   */
  height: string;
  /**
   * 通知列表缩放参数
   */
  scale?: ScaleOptions;

  /**
   * 通知列表layoutWeight
   */
  layoutWeight: number

  /**
   * 暂无通知文本高度
   */
  emptyTextHeight: string

  /**
   * 暂无通知文本偏移量
   */
  emptyTextOffset: Position;

  /**
   * 是否展示底部透明卡片
   */
  isShowBottomTransCard: boolean;

  /**
  * 底部透明卡片高度
  */
  transparentCardHeight: number;

  /**
   * 第一张卡片的位移
   */
  contentStartOffset: number;

  /**
   * 是否允许列表滑动
   */
  isScrollEnable: boolean;

  /**
   * 对齐规则
   */
  alignRules: LocalizedAlignRuleOptions;

  /**
   * 是否正在更新数据
   */
  isDataUpdating: boolean;

  /**
   * 是否组通知正在展开
   */
  isGroupExpanding: boolean;

  /**
   * 需要懒加载的通知
   */
  ntfCacheMap: Map<string, NotificationBase>;

  /**
   * 通知面板点击事件
   *
   * @param event 点击事件
   */
  onClick: (event: ClickEvent) => void;

  /**
   * 根据Index获取通知信息
   *
   * @param index 通知索引值
   * @returns 通知信息
   */
  getListItemByIndex(index: number, ignoreMoreHeader?: boolean): NotificationBase | undefined;

  /**
   * 是否更多通知header的index
   * @param index
   * @returns
   */
  isMoreHeaderIndex(index: number): boolean;

  /**
   * 根据通知信息获取index
   *
   * @param ntf 通知信息
   * @returns index
   */
  getListItemIndex(ntf: NotificationBase): number;

  /**
   * 获取通知列表最大index
   * @returns index
   */
  getMaxIndex(): number;

  /**
   * 获取列表项组件ID
   * @param ntf
   * @returns
   */
  getItemId(ntf: NotificationBase): string;

  /**
   * 列表高度变化
   *
   * @param size
   */
  onListSizeChange(size: SizeOptions): void;

  /**
   * 刷新通知
   */
  updateNtf(updateParam: IUpdateParam): void;

  /**
   * 更新组通知
   * @param ntf
   */
  updateGroup(ntf: NotificationBase): void;

  /**
   * 列表item尺寸变化
   */
  onListItemSizeChange(): void;

  /**
   * 是否是正在展开折叠的第一个更多通知
   */
  getIsFirstMoreNtfChanging(index: number): boolean;

  /**
   * 是否允许横滑面板切换双中心
   *
   * @param panelDownWindowY 触摸点Y
   * @param panelDownWindowX 触摸点X
   * @returns
   */
  isAllowPanHorizontal(panelDownWindowY: number, panelDownWindowX: number): boolean;

  /**
   * 更新空白卡片高度
   * @param isExtraNtfsCollapseStatusChanging 是否在更多通知折叠展开动效过程中
   */
  updateTransparentCardHeight(isExtraNtfsCollapseStatusChanging: boolean): void;

  /**
   * 刷新缓存数据
   * @param dropDownEvent
   */
  flushCacheMap(dropDownEvent: DropDownEvent): void;
}