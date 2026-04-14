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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { accessibility } from '@kit.AccessibilityKit';
import { Singleton } from '../utils/Singleton';
import { ThreadSync } from '../messageChannel/ThreadSync';
import { ResourceVm } from './ResourceVm';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'AccessibilityVm');

@ThreadSync.VmDecorator
@ObservedV2
export class AccessibilityVm {
  @Singleton.decorate() 
  public static get instance(): AccessibilityVm { return new AccessibilityVm(); }

  /**
   * 是否启用无障碍模式
   */
  @Trace public isEnabled: boolean = false;

  public constructor() { }

  public async sendEventByResource(...resources: Resource[]): Promise<void> {
    if (!this.isEnabled) {
      return;
    }

    try {
      const text = resources.map((res) => ResourceVm.instance.getString(res)).join(' ');
      await this.sendEventByText(text);
    } catch (err) {
      log.showError(`sendEventByResource failed, Code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * 屏幕朗读播报指定文本
   *
   * @param text 播报文本
   * @param notInterrupt 是否不打断前一次播报，默认为false
   */
  public async sendEventByText(text: string, notInterrupt: boolean = false): Promise<void> {
    if (!this.isEnabled) {
      return;
    }

    try {
      await accessibility.sendAccessibilityEvent({
        type: notInterrupt ? 'announceForAccessibilityNotInterrupt' : 'announceForAccessibility',
        bundleName: 'com.ohos.sceneboard',
        triggerAction: 'click',
        textAnnouncedForAccessibility: text,
      });
    } catch (err) {
      log.showError(`sendEventByText failed, Code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * 屏幕朗读聚焦指定组件
   *
   * @param customId 聚焦组件id
   * @param notInterrupt 是否不打断前一次播报，默认为false
   */
  async requestFocusAccessibility(customId: string, notInterrupt: boolean = false): Promise<void> {
    if (!this.isEnabled) {
      return;
    }

    try {
      await accessibility.sendAccessibilityEvent({
        type: notInterrupt ? 'requestFocusForAccessibilityNotInterrupt' : 'requestFocusForAccessibility',
        bundleName: 'com.ohos.sceneboard',
        triggerAction: 'common',
        customId: customId,
      });
    } catch (err) {
      log.showError(`requestFocusAccessibility failed, Code is ${err.code}, message is ${err.message}`);
    }
  }
}