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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DragGridInfo } from '../../common/type/CommonTypes';
import { DragListener, DragListenerPriority } from '../../common/type/DragTypes';

const TAG = 'Drag-DragListenerManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);
const DEFAULT_KEY: string = 'default_dragListener_key';
const NOTIFY_DELAY_FOR_LOW_PRIORITY: number = 50;

/**
 * 拖拽状态监听管理类
 */
export class DragListenerManager {
  private dragListeners: Map<string, Set<DragListener>> = new Map();

  /**
   * 注册事件状态监听
   *
   * @param listener 拖拽事件监听器
   * @param key 拖拽元素标识
   * @returns 是否注册成功
   */
  public registerDragListener(listener: DragListener, key?: string): boolean {
    if (!listener) {
      log.showError('register error with empty listener');
      return false;
    }

    let realKey: string = key ?? DEFAULT_KEY;
    let value: Set<DragListener> = this.dragListeners.get(realKey);
    if (!value) {
      let set: Set<DragListener> = new Set();
      set.add(listener);
      this.dragListeners.set(realKey, set);
      return true;
    }

    if (value.has(listener)) {
      log.showWarn('register interrupt with repeated listener');
      return false;
    }
    value.add(listener);
    return true;
  }

  /**
   * 反注册事件状态监听
   *
   * @param listener 拖拽事件监听器
   * @param key 拖拽元素标识
   * @returns 是否反注册成功
   */
  public unregisterDragListener(listener: DragListener, key?: string): boolean {
    if (!listener) {
      log.showError('unregister error with empty listener');
      return false;
    }

    let realKey: string = key ?? DEFAULT_KEY;
    let value: Set<DragListener> = this.dragListeners.get(realKey);
    if (!value) {
      log.showWarn('unregister interrupt with unregistered listener');
      return false;
    }

    value.delete(listener);
    if (value.size === 0) {
      this.dragListeners.delete(realKey);
    }
    return true;
  }

  /**
   * 通知拖拽开始
   *
   * @param dragInfo 拖拽行为信息
   * @param key 拖拽元素标识
   */
  public notifyDragStart(dragInfo: DragGridInfo, key: string): void {
    let listeners: DragListener[][] = this.collectDragListeners(key);
    log.showInfo('start to notify dragStart for high priority listeners by: %{public}s', key);
    listeners[DragListenerPriority.HIGH].forEach((listener: DragListener) => this.triggerDragStart(dragInfo, listener));
    setTimeout(() => {
      log.showInfo('start to notify dragStart for low priority listeners by: %{public}s', key);
      listeners[DragListenerPriority.LOW].forEach(
        (listener: DragListener) => this.triggerDragStart(dragInfo, listener));
      log.showInfo('notify dragStart for low priority listeners success by: %{public}s', key);
    }, NOTIFY_DELAY_FOR_LOW_PRIORITY);
    log.showInfo('notify dragStart for high priority listeners success by: %{public}s', key);
  }

  /**
   * 通知拖拽结束
   *
   * @param dragInfo 拖拽行为信息
   * @param key 拖拽元素标识
   */
  public notifyDragEnd(dragInfo: DragGridInfo, key: string): void {
    let listeners: DragListener[][] = this.collectDragListeners(key);
    log.showInfo('start to notify dragEnd for high priority listeners by: %{public}s', key);
    listeners[DragListenerPriority.HIGH].forEach((listener: DragListener) => this.triggerDragEnd(dragInfo, listener));
    setTimeout(() => {
      log.showInfo('start to notify dragEnd for low priority listeners by: %{public}s', key);
      listeners[DragListenerPriority.LOW].forEach(
        (listener: DragListener) => this.triggerDragEnd(dragInfo, listener));
      log.showInfo('notify dragEnd for low priority listeners success by: %{public}s', key);
    }, NOTIFY_DELAY_FOR_LOW_PRIORITY);
    log.showInfo('notify dragEnd for high priority listeners success by: %{public}s', key);
  }

  private collectDragListeners(key: string): DragListener[][] {
    let validListeners: DragListener[][] = [[], []];
    this.dragListeners.get(DEFAULT_KEY)?.forEach((listener: DragListener) =>
      validListeners[listener.priority].push(listener));
    this.dragListeners.get(key)?.forEach((listener: DragListener) =>
      validListeners[listener.priority].push(listener));
    return validListeners;
  }

  private triggerDragStart(dragInfo: DragGridInfo, listener: DragListener): void {
    if (!listener.dragStart) {
      return;
    }
    try {
      listener.dragStart(dragInfo);
    } catch (err) {
      log.showError(`notifyDragStart err id:${listener.id} code:${err.code} msg:${err.message}`);
    }
  }

  private triggerDragEnd(dragInfo: DragGridInfo, listener: DragListener): void {
    if (!listener.dragEnd) {
      return;
    }
    try {
      listener.dragEnd(dragInfo);
    } catch (err) {
      log.showError(`notifyDragEnd err id:${listener.id} code:${err.code} msg:${err.message}`);
    }
  }

  /**
   * 拖拽状态监听管理类
   *
   * @returns 单例
   */
  static getInstance(): DragListenerManager {
    if (globalThis.DragListenerManager == null) {
      globalThis.DragListenerManager = new DragListenerManager();
    }
    return globalThis.DragListenerManager;
  }
}