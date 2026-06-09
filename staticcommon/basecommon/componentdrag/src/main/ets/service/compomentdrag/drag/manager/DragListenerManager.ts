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
import { DragListener } from '../../common/type/DragTypes';
import { SingletonHelper } from '@ohos/basicutils';

const TAG = 'Drag-DragListenerManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);
const DEFAULT_KEY: string = 'default_dragListener_key';

/**
 * 拖拽状态监听管理类
 *
 * @since 2024/04/10
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
    this.dragListeners.get(DEFAULT_KEY)?.forEach((listener: DragListener) => {
      listener.dragStart?.(dragInfo);
    });
    this.dragListeners.get(key)?.forEach((listener: DragListener) => {
      listener.dragStart?.(dragInfo);
    });
    log.showInfo(`notify dragStart success by key: ${key}`);
  }

  /**
   * 通知拖拽结束
   *
   * @param dragInfo 拖拽行为信息
   * @param key 拖拽元素标识
   */
  public notifyDragEnd(dragInfo: DragGridInfo, key: string): void {
    this.dragListeners.get(DEFAULT_KEY)?.forEach((listener: DragListener) => {
      listener.dragEnd?.(dragInfo);
    });
    this.dragListeners.get(key)?.forEach((listener: DragListener) => {
      listener.dragEnd?.(dragInfo);
    });
    log.showInfo(`notify dragEnd success by key: ${key}`);
  }
}

export const dragListenerManager: DragListenerManager = SingletonHelper.getInstance(DragListenerManager, TAG);