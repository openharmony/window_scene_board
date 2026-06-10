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

import { NotificationEntry } from '../model/NotificationEntry';
import { ntfMgr } from '../model/NotificationManager';
import { CommonUtils, ArrayUtils } from '@ohos/basicutils';

/**
 * 关闭按钮监听集
 */
class NtfCloseListeners {
  /**
   * 键值
   */
  public readonly mapKey: string;

  /**
   * 通知条目hover状态监听器集
   */
  public itemHoverListeners: Set<OnItemHoverChangeListener> = new Set;

  /**
   * 通知条目位置监听器集
   */
  public itemPositionListeners: Set<OnItemPositionChangeListener> = new Set;

  /**
   * close按钮hover状态监听器集
   */
  public pcCloseHoverListeners: Set<OnPcCloseHoverChangeListener> = new Set;

  /**
   * 构造
   *
   * @param mapKey 键值
   */
  constructor(mapKey: string) {
    this.mapKey = mapKey;
  }

  /**
   * 是否所有集合已清空
   *
   * @return true 空集合
   */
  isListenersEmpty(): boolean {
    return (ArrayUtils.isEmpty(this.itemHoverListeners) &&
      ArrayUtils.isEmpty(this.itemPositionListeners) &&
      ArrayUtils.isEmpty(this.pcCloseHoverListeners));
  }
}

/**
 * 关闭按钮状态集
 */
class NtfCloseStates {
  /**
   * 键值
   */
  public readonly mapKey: string;

  /**
   * 通知条目hover状态
   */
  public isItemHover: boolean | null = null;

  /**
   * 通知条目位置
   */
  public itemArea: Area | null = null;

  /**
   * 通知条目横向平移
   */
  public itemTranX: number | null = null;

  /**
   * 通知条目横滑动画
   */
  public itemTranAnim: AnimateParam | null = null;

  /**
   * close按钮hover状态
   */
  public isPcCloseHover: boolean | null = null;

  /**
   * 构造
   *
   * @param mapKey 键值
   */
  constructor(mapKey: string) {
    this.mapKey = mapKey;
  }

  /**
   * 是否所有状态已清空
   *
   * @return true 空状态
   */
  isStatesEmpty(): boolean {
    return (
        CommonUtils.isInvalid(this.isItemHover) &&
        CommonUtils.isInvalid(this.itemArea) &&
        CommonUtils.isInvalid(this.itemTranX) &&
        CommonUtils.isInvalid(this.isPcCloseHover) &&
        CommonUtils.isInvalid(this.itemTranAnim)
    );
  }
}

/**
 * PC面板通知hover时右上角close按钮数据处理
 *
 * @since 2023-01-10
 */
export class NtfPcCloseVM {
  /**
   * 监听器集
   * 组通知 groupKey => 监听器集
   * 单通知 hashCode => 监听器集
   */
  private allListeners: Map<string, NtfCloseListeners> = new Map();

  /**
   * 缓存状态集
   */
  private allStates: Map<string, NtfCloseStates> = new Map();

  /**
   * 注册通知条目hover状态监听
   *
   * @param entry 通知条目映射
   * @param listener 监听器
   */
  registerOnItemHoverChangeListener(entry: NotificationEntry, listener: OnItemHoverChangeListener): void {
    if (CommonUtils.isInvalid(entry) || CommonUtils.isInvalid(listener)) {
      return;
    }
    let mapKey = this.getMapKey(entry);
    let listeners = this.getOrCreateListeners(mapKey);
    if (CommonUtils.isInvalid(listeners.itemHoverListeners)) {
      listeners.itemHoverListeners = new Set();
    }
    listeners.itemHoverListeners.add(listener);
    let isHovered = this.allStates.get(mapKey)?.isItemHover;
    // 注册时回调当前结果
    this.notifyItemHoverChange(isHovered as boolean, listener);
  }

  /**
   * 注销通知条目hover监听
   *
   * @param entry 通知条目映射
   * @param listener 监听器
   */
  unregisterOnItemHoverChangeListener(entry: NotificationEntry, listener: OnItemHoverChangeListener): void {
    let listeners = this.allListeners.get(this.getMapKey(entry));
    listeners?.itemHoverListeners?.delete(listener);
    this.checkClearListeners(listeners as NtfCloseListeners);
  }

  /**
   * 注册通知条目位置监听
   *
   * @param entry 通知条目映射
   * @param listener 监听器
   */
  registerOnItemPositionChangeListener(entry: NotificationEntry, listener: OnItemPositionChangeListener): void {
    if (CommonUtils.isInvalid(entry) || CommonUtils.isInvalid(listener)) {
      return;
    }
    let mapKey = this.getMapKey(entry);
    let listeners = this.getOrCreateListeners(mapKey);
    if (CommonUtils.isInvalid(listeners.itemPositionListeners)) {
      listeners.itemPositionListeners = new Set();
    }
    listeners.itemPositionListeners.add(listener);
    let states = this.allStates.get(mapKey)
    // 注册时回调当前结果
    this.notifyItemAreaChange(states?.itemArea as Area, listener);
    this.notifyItemTranXChange(states?.itemTranX as number, listener);
  }

  /**
   * 注销通知条目位置监听
   *
   * @param entry 通知条目映射
   * @param listener 监听器
   */
  unregisterOnItemPositionChangeListener(entry: NotificationEntry, listener: OnItemPositionChangeListener): void {
    let listeners = this.allListeners.get(this.getMapKey(entry));
    listeners?.itemPositionListeners?.delete(listener);
    this.checkClearListeners(listeners as NtfCloseListeners);
  }

  /**
   * 注册close按钮hover转台监听
   *
   * @param entry 通知条目映射
   * @param listener 监听器
   */
  registerOnPcCloseHoverChangeListener(entry: NotificationEntry, listener: OnPcCloseHoverChangeListener): void {
    if (CommonUtils.isInvalid(entry) || CommonUtils.isInvalid(listener)) {
      return;
    }
    let mapKey = this.getMapKey(entry);
    let listeners = this.getOrCreateListeners(mapKey);
    if (CommonUtils.isInvalid(listeners.pcCloseHoverListeners)) {
      listeners.pcCloseHoverListeners = new Set();
    }
    listeners.pcCloseHoverListeners.add(listener);
    let isHovered = this.allStates.get(mapKey)?.isPcCloseHover;
    // 注册时回调当前结果
    this.notifyPcCloseHoverChange(isHovered as boolean, listener);
  }

  /**
   * 注销close按钮hover状态监听
   *
   * @param entry 通知条目映射
   * @param listener 监听器
   */
  unregisterOnPcCloseHoverChangeListener(entry: NotificationEntry, listener: OnPcCloseHoverChangeListener): void {
    let listeners = this.allListeners.get(this.getMapKey(entry));
    listeners?.pcCloseHoverListeners?.delete(listener);
    this.checkClearListeners(listeners as NtfCloseListeners);
  }

  /**
   * 设置通知条目hover状态
   *
   * @param entry 通知条目映射
   * @param isHover 是否hover
   */
  setItemHoverState(entry: NotificationEntry, isHover: boolean): void {
    let mapKey = this.getMapKey(entry);
    this.getOrCreateStates(mapKey).isItemHover = isHover;
    this.allListeners.get(mapKey)?.itemHoverListeners?.forEach((listener: OnItemHoverChangeListener) => {
      this.notifyItemHoverChange(isHover, listener);
    });
  }

  /**
   * 移除通知条目hover状态缓存
   *
   * @param entry 通知条目映射
   */
  removeItemHoverCache(entry: NotificationEntry): void {
    // 移除后通知hover状态切换
    this.setItemHoverState(entry, false);
    let states = this.allStates.get(this.getMapKey(entry));
    if (!CommonUtils.isInvalid(states)) {
      (states as NtfCloseStates).isItemHover = null;
      this.checkClearStates(states as NtfCloseStates);
    }
  }

  /**
   * 设置通知条目位置
   *
   * @param entry 通知条目映射
   * @param itemArea 条目位置
   */
  setItemArea(entry: NotificationEntry, itemArea: Area | null): void {
    let mapKey = this.getMapKey(entry);
    if (itemArea) {
      this.getOrCreateStates(mapKey).itemArea = itemArea;
      this.allListeners.get(mapKey)?.itemPositionListeners?.forEach((listener: OnItemPositionChangeListener) => {
        this.notifyItemAreaChange(itemArea, listener);
      })
    };
  }

  /**
   * 移除通知条目位置缓存
   *
   * @param entry 通知条目映射
   */
  removeItemAreaCache(entry: NotificationEntry): void {
    // 移除后通知area切换
    this.setItemArea(entry, null);
    let states = this.allStates.get(this.getMapKey(entry));
    if (!CommonUtils.isInvalid(states)) {
      (states as NtfCloseStates).itemArea = null;
      this.checkClearStates(states as NtfCloseStates);
    }
  }

  /**
   * 设置通知条目平移
   *
   * @param entry 通知条目映射
   * @param tranX 条目平移
   */
  setItemTranX(entry: NotificationEntry, tranX: number): void {
    let mapKey = this.getMapKey(entry);
    this.getOrCreateStates(mapKey).itemTranX = tranX;
    this.allListeners.get(mapKey)?.itemPositionListeners?.forEach((listener: OnItemPositionChangeListener
    ) => {
      this.notifyItemTranXChange(tranX, listener);
    });
  }

  /**
   * 移除通知条目平移缓存
   *
   * @param entry 通知条目映射
   */
  removeItemTranXCache(entry: NotificationEntry): void {
    // 移除后通知tranX切换
    this.setItemTranX(entry, 0);
    let states = this.allStates.get(this.getMapKey(entry));
    if (!CommonUtils.isInvalid(states)) {
      states!.itemTranX = null;
      this.checkClearStates(states!);
    }
  }

  /**
   * 设置通知条目平移动画
   *
   * @param entry 通知条目映射
   * @param tranAnim 条目平移动画
   */
  setItemTranAnim(entry: NotificationEntry, tranAnim: AnimateParam | null): void {
    let mapKey = this.getMapKey(entry);
    this.getOrCreateStates(mapKey).itemTranAnim = tranAnim;
    this.allListeners.get(mapKey)?.itemPositionListeners?.forEach((listener: OnItemPositionChangeListener) => {
      listener.onItemTranslateAnimChange(tranAnim!);
    });
  }

  /**
   * 移除通知条目平移动画
   *
   * @param entry 通知条目映射
   */
  removeItemTranAnimCache(entry: NotificationEntry): void {
    // 移除后通知动画切换
    this.setItemTranAnim(entry, null);
    let states = this.allStates.get(this.getMapKey(entry));
    if (!CommonUtils.isInvalid(states)) {
      states!.itemTranAnim = null;
      this.checkClearStates(states!);
    }
  }

  /**
   * 设置close按钮hover状态
   *
   * @param entry 通知条目映射
   * @param isHover 是否hover
   */
  setPcCloseHoverState(entry: NotificationEntry, isHover: boolean): void {
    let mapKey = this.getMapKey(entry);
    this.getOrCreateStates(mapKey).isPcCloseHover = isHover;
    this.allListeners.get(mapKey)?.pcCloseHoverListeners?.forEach((listener: OnPcCloseHoverChangeListener) => {
      this.notifyPcCloseHoverChange(isHover, listener);
    });
  }

  /**
   * 移除close按钮hover状态缓存
   *
   * @param entry 通知条目映射
   */
  removePcCloseHoverCache(entry: NotificationEntry): void {
    // 移除后close按钮hover状态切换
    this.setPcCloseHoverState(entry, false);
    let states = this.allStates.get(this.getMapKey(entry));
    if (!CommonUtils.isInvalid(states)) {
      states!.isPcCloseHover = null;
      this.checkClearStates(states!);
    }
  }

  /**
   * 删除通知
   *
   * @param entry 通知数据
   */
  deleteNtfByClose(entry: NotificationEntry): void {
    ntfMgr.removeNtfEntryByCancel(entry);
  }

  /**
   * 通知条目hover状态回调
   *
   * @param isHover 是否hover
   * @param listener 监听器
   */
  private notifyItemHoverChange(isHover: boolean, listener: OnItemHoverChangeListener): void {
    listener?.onItemHoverChange(CommonUtils.isInvalid(isHover) ? false : isHover);
  }

  /**
   * 通知条目位置Area回调
   *
   * @param itemArea 条目位置
   * @param listener 监听器
   */
  private notifyItemAreaChange(itemArea: Area, listener: OnItemPositionChangeListener): void {
    // itemArea会有null场景
    listener?.onItemAreaChange(itemArea);
  }

  /**
   * 通知条目位置平移回调
   *
   * @param tranX 条目平移距离
   * @param listener 监听器
   */
  private notifyItemTranXChange(tranX: number, listener: OnItemPositionChangeListener): void {
    listener?.onItemTranslateXChange(CommonUtils.isInvalid(tranX) ? 0 : tranX);
  }

  /**
   * close按钮hover状态回调
   *
   * @param isHover 是否hover
   * @param listener 监听器
   */
  private notifyPcCloseHoverChange(isHover: boolean, listener: OnPcCloseHoverChangeListener): void {
    listener?.onPcCloseHoverChange(CommonUtils.isInvalid(isHover) ? false : isHover);
  }

  /**
   * 获取监听器集
   *
   * @param mapKey 键值
   * @return 监听器集
   */
  private getOrCreateListeners(mapKey: string): NtfCloseListeners {
    let listeners = this.allListeners.get(mapKey);
    if (CommonUtils.isInvalid(listeners)) {
      listeners = new NtfCloseListeners(mapKey);
      this.allListeners.set(mapKey, listeners);
    }
    return listeners as NtfCloseListeners;
  }

  /**
   * 获取状态集
   *
   * @param mapKey 键值
   * @return 状态集
   */
  private getOrCreateStates(mapKey: string): NtfCloseStates {
    let states = this.allStates.get(mapKey);
    if (CommonUtils.isInvalid(states)) {
      states = new NtfCloseStates(mapKey);
      this.allStates.set(mapKey, states);
    }
    return states!;
  }

  /**
   * 检测监听器集是否可清除
   *
   * @param listeners 监听器集
   */
  private checkClearListeners(listeners: NtfCloseListeners): void {
    if (CommonUtils.isInvalid(listeners)) {
      return;
    }
    if (listeners.isListenersEmpty()) {
      this.allListeners.delete(listeners.mapKey);
    }
  }

  /**
   * 检测状态集是否可清除
   *
   * @param states 状态集
   */
  private checkClearStates(states: NtfCloseStates): void {
    if (CommonUtils.isInvalid(states)) {
      return;
    }
    if (states.isStatesEmpty()) {
      this.allStates.delete(states.mapKey);
    }
  }

  /**
   * 获取map使用的键值
   *
   * @param entry 通知数据
   * @return 键值
   */
  private getMapKey(entry: NotificationEntry): string {
    if (CommonUtils.isInvalid(entry)) {
      return '';
    }
    // 组通知取groupKey，单通知hashCode
    return entry.isGroup ? entry.getGroupKey() : entry.hashCode;
  }
}

/**
 * 通知条目hover状态监听器
 */
export interface OnItemHoverChangeListener {
  /**
   * 通知条目hover状态变化回调
   *
   * @param isHover 当前hover状态
   */
  onItemHoverChange(isHover: boolean): void;
}

/**
 * 通知条目位置变化监听器
 */
export interface OnItemPositionChangeListener {
  /**
   * 通知条目当前位置回调
   *
   * @param newArea 最新位置
   */
  onItemAreaChange(newArea: Area): void;

  /**
   * 通知条目X方向平移回调
   *
   * @param tranX 横向平移距离
   */
  onItemTranslateXChange(tranX: number): void;

  /**
   * 通知条目横滑动效
   *
   * @param tranAnim 横滑动画
   */
  onItemTranslateAnimChange(tranAnim: AnimateParam): void;
}

/**
 * 通知右上角close按钮hover状态监听器
 */
export interface OnPcCloseHoverChangeListener {
  /**
   * close按钮hover状态变化回调
   *
   * @param isHover 当前hover状态
   */
  onPcCloseHoverChange(isHover: boolean): void;
}