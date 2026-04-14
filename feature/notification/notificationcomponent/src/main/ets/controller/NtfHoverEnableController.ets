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

import { SingletonHelper } from '@ohos/basicutils';

const TAG = 'NtfHoverEnableController';

/**
 * Ntf hover enable controller.
 *
 * @since 2023-11-26
 */
class NtfHoverEnableController {

  private isHoverEnable: boolean = true;
  private isItemHover: boolean = true;

  /**
   * Ntf items, include all group and single item in NotificationListContentPc#ntfList.
   */
  private hoverEnableCallbacks: Set<HoverEnableCallback> = new Set();

  registerHoverEnableCallback(callback: HoverEnableCallback): void {
    this.hoverEnableCallbacks.add(callback);
  }

  unregisterHoverEnableCallback(callback: HoverEnableCallback): void {
    this.hoverEnableCallbacks.delete(callback);
  }

  hoverEnable(enable: boolean): void {
    this.isHoverEnable = enable;
    this.hoverEnableCallbacks.forEach((callback: HoverEnableCallback) => {
      callback.onHoverEnable(this.isHoverEnable);
    });
  }

  setItemHover(enable: boolean): void {
    this.isItemHover = enable;
    this.hoverEnableCallbacks.forEach((callback: HoverEnableCallback) => {
      callback.onHoverEnable(this.isHoverEnable);
    });
  }

  getItemHover(): boolean {
    return this.isItemHover;
  }

  getHoverEnable(): boolean {
    return this.isHoverEnable;
  }
}

export interface HoverEnableCallback {
  onHoverEnable(isHoverEnable: boolean): void;
}

// 单例
export let ntfHoverEC: NtfHoverEnableController = SingletonHelper.getInstance(NtfHoverEnableController, TAG);