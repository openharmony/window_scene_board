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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DropAnimationParam } from '../bean/DropAnimationParam';
import { DropAnimationDestination } from '../config/DropAnimationConfig';
import { DropAnimationListener } from './DropAnimationListener';

const TAG: string = 'DropAnimationObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 落位动效监听管理
 */
class DropAnimationObserver {
  private dropAnimationListenersWithoutKey: Set<DropAnimationListener> = new Set();
  private dropAnimationListenersWithKey: Map<string, Set<DropAnimationListener>> = new Map();

  /**
   * 注册落位动效监听器
   *
   * @param listener 落位动效监听器
   * @param key 对应落位元素的标识符
   */
  public registerDropAnimationListener(listener: DropAnimationListener, key?: string): void {
    if (key == null) {
      this.dropAnimationListenersWithoutKey.add(listener);
    } else if (this.dropAnimationListenersWithKey.has(key)) {
      this.dropAnimationListenersWithKey.get(key).add(listener);
    } else {
      let set: Set<DropAnimationListener> = new Set();
      set.add(listener);
      this.dropAnimationListenersWithKey.set(key, set);
    }
  }

  /**
   * 解注册落位动效监听器
   *
   * @param listener 落位动效监听器
   * @param key 对应落位元素的标识符
   */
  public unregisterDropAnimationListener(listener: DropAnimationListener, key?: string): void {
    if (key == null) {
      this.dropAnimationListenersWithoutKey.delete(listener);
    } else {
      let set = this.dropAnimationListenersWithKey.get(key);
      if (set == null) {
        return;
      }
      set.delete(listener);
      if (set.size === 0) {
        this.dropAnimationListenersWithKey.delete(key);
      }
    }
  }

  /**
   * 获取落位动效监听器的数量，key为空时返回不带key监听器的数量，key非空时返回监听对应key的监听器的数量
   *
   * @param key 落位元素的标识符
   * @returns 落位动效监听器的数量
   */
  public getListenerCount(key?: string): number {
    if (key == null) {
      return this.dropAnimationListenersWithoutKey.size;
    } else {
      return this.dropAnimationListenersWithKey.get(key)?.size ?? 0;
    }
  }

  /**
   * 触发落位动效开始的监听回调
   *
   * @param target 落位动效的终点位置
   * @param param 落位动效参数
   * @param isMultiDrop 是否是多个元素的落位动效
   */
  public triggerAnimationStart(target: DropAnimationDestination, param: DropAnimationParam, isMultiDrop: boolean):
    void {
    log.showInfo(`triggerAnimationStart target:${target} key:${param.key} isMultiDrop:${isMultiDrop}`);
    this.dropAnimationListenersWithoutKey.forEach((listener) =>
      listener.onDropAnimationStart?.(target, param, isMultiDrop));
    this.dropAnimationListenersWithKey.get(param.key)?.forEach((listener) =>
      listener.onDropAnimationStart?.(target, param, isMultiDrop));
  }

  /**
   * 触发落位动效结束的监听回调
   *
   * @param target 落位动效的终点位置
   * @param param 落位动效参数
   * @param isMultiDrop 是否是多个元素的落位动效
   * @param isCancel 落位动效是否被取消
   */
  public triggerAnimationEnd(target: DropAnimationDestination, param: DropAnimationParam, isMultiDrop: boolean,
    isCancel: boolean): void {
    log.showInfo(`triggerAnimationEnd target:${target} key:${param.key} isMultiDrop:${isMultiDrop}` +
      ` isCancel:${isCancel}`);
    this.dropAnimationListenersWithoutKey.forEach((listener) =>
      listener.onDropAnimationEnd?.(target, param, isMultiDrop, isCancel));
    this.dropAnimationListenersWithKey.get(param.key)?.forEach((listener) =>
      listener.onDropAnimationEnd?.(target, param, isMultiDrop, isCancel));
  }
}

export const dropAnimationObserver: DropAnimationObserver = SingletonHelper.getInstance(DropAnimationObserver, TAG);