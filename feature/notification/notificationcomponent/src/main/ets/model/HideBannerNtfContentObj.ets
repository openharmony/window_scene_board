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

const TAG = 'SysUI_HideBannerNtfContentObj';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

class HideBannerNtfContentObj {
  public hasFaceData: boolean;
  public isFaceOpen: number;
  private isHiddenContent: number;
  private hiddenContentListeners: Set<(data: boolean) => void> = new Set();

  constructor() {
    this.hasFaceData = false;
    this.isFaceOpen = 1;
    this.isHiddenContent = 0;
  }

  updateFaceData(hasFaceData: boolean): void {
    this.hasFaceData = hasFaceData;
  }

  updateFaceOpen(isFaceOpen: number): void {
    this.isFaceOpen = isFaceOpen;
  }

  updateHiddenContent(isHiddenContent: number): void {
    if (this.isHiddenContent === isHiddenContent) {
      return;
    }
    this.isHiddenContent = isHiddenContent;
    for (const listener of this.hiddenContentListeners.values()) {
      try {
        listener(this.getIsHiddenContent());
      } catch (e) {
        log.error(`Trigger change event for HiddenContent error:`, e);
      }
    }
  }

  isUseSwing(): boolean {
    return false;
  }

  /**
   * 是否全局隐藏横幅通知内容
   * @returns
   */
  public getIsHiddenContent(): boolean {
    return this.isHiddenContent === 1;
  }

  public registerHiddenContentChangedEvent(listener: (data: boolean) => void): void {
    this.hiddenContentListeners.add(listener);
  }

  public unregisterHiddenContentChangedEvent(listener: (data: boolean) => void): void {
    this.hiddenContentListeners.delete(listener);
  }
}
// 单例
export let hideBannerNtfContentObj: HideBannerNtfContentObj = SingletonHelper.getInstance(HideBannerNtfContentObj, TAG);