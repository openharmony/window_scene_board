/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

const TAG = 'FocusViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面焦点管理类,负责功能：
 * 1.当前获焦组件管理
 * 3.待添加...
 */
export class FocusViewModel {
  // 默认焦点组件ID
  static DEFAULT_FOCUS: string = 'Desktop';

  private static instance: FocusViewModel;


  // 桌面可获焦组件集合，key: 桌面元素key值
  private desktopFocusedMap: Map<string, Set<FocusEventListener>> = new Map();

  static getInstance(): FocusViewModel {
    if (!FocusViewModel.instance) {
      FocusViewModel.instance = new FocusViewModel();
    }
    return FocusViewModel.instance;
  }

  /**
   * 设置桌面元素组件获焦
   * @param key 组件id
   * @param isFocused 是否获焦
   * @returns 设置获焦是否成功
   */
  setFocus(key: string, isFocused: boolean): boolean {
    if (!this.desktopFocusedMap.has(key)) {
      log.showWarn(`setFocus failed. No such a key(${key}) in desktopFocusedMap`);
      return false;
    }
    this.desktopFocusedMap.get(key)?.forEach(listener => listener.onFocusedEvent(isFocused));
    return true;
  }

  /**
   * 注册响应获焦事件监听器
   * @param key 组件key值
   * @param listener
   * @param listener
   */
  registerFocusEventListener(key: string, listener: FocusEventListener): void {
    let listeners = this.desktopFocusedMap.get(key);
    if (!listeners) {
      listeners = new Set();
      this.desktopFocusedMap.set(key, listeners);
    }
    listeners.add(listener);
  }

  /**
   * 注销监听器
   * @param key
   */
  unregisterFocusEventListener(key: string, listener: FocusEventListener): void {
    let result = this.desktopFocusedMap.get(key)?.delete(listener);
  }
}

export interface FocusEventListener {
  onFocusedEvent(isFocused: boolean): void;
}