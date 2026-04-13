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

/**
 * 组通知与子通知共享数据:关闭组通知、子通知滑动
 * ps：无法使用Provide/State场景
 */
export default class GroupChildNtfDataChannel {
  private groupCollapseCallback: (() => void) | null = null;
  private groupTranslateCallbacks: Set<Function> | null = null;
  private groupTranslateX: number = 0;

  constructor() {
    this.groupTranslateCallbacks = new Set<Function>();
  }

  setGroupCollapseCallback(callback: () => void): void {
    this.groupCollapseCallback = callback;
  }

  registerGroupTranslateCallback(callback: (tranX: number) => void): void {
    if (callback == null) {
      return;
    }
    // 避免组通知先侧滑再展开子通知，此时组通知已滑动过
    callback(this.groupTranslateX);
    if (this.groupTranslateCallbacks && !this.groupTranslateCallbacks.has(callback)) {
      this.groupTranslateCallbacks.add(callback);
    }
  }

  unRegisterGroupTranslateCallback(callback: (tranX: number) => void): void {
    if (this.groupTranslateCallbacks && callback && this.groupTranslateCallbacks.has(callback)) {
      this.groupTranslateCallbacks.delete(callback);
    }
  }

  collapseGroupNtf(): void {
    if (this.groupCollapseCallback) {
      this.groupCollapseCallback();
    }
  }

  groupTranslateXChanged(translateX: number): void {
    this.groupTranslateX = translateX;
    this.groupTranslateCallbacks?.forEach((callback: Function) => {
      if (callback) {
        callback(translateX);
      }
    })
  }

  destroyCallbacks(): void {
    this.groupCollapseCallback = null;
    this.groupTranslateCallbacks?.clear();
    this.groupTranslateCallbacks = null;
    this.groupTranslateX = 0;
  }
}
