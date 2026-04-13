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

import { DomainName, LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import settings from '@ohos.settings';
import type ctx from '@ohos.app.ability.common';
import accessibility from '@ohos.accessibility';
import { BusinessError } from '@ohos.base';

const TAG = 'AccessibilityManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const ACCESSIBILITY_SCREEN_READER_SETTING_KEY = 'accessibility_screenreader_enabled';

export class AccessibilityManager {
  private static INSTANCE?: AccessibilityManager;
  private context: ctx.Context;
  private currMode: boolean = false;

  public static init(context: ctx.Context): void {
    AccessibilityManager.INSTANCE = new AccessibilityManager(context);
    AccessibilityManager.INSTANCE.registerAccessibilityModeListener();
  }

  public static getInstance(): AccessibilityManager | undefined {
    if (AccessibilityManager.INSTANCE) {
      return AccessibilityManager.INSTANCE;
    }

    log.showError('Instance not init');
    return undefined;
  }

  constructor(context: ctx.Context) {
    this.context = context;
  }

  public registerAccessibilityModeListener(): void {
    this.refreshIsAccessibilityMode();
    try {
      settings.registerKeyObserver(this.context, ACCESSIBILITY_SCREEN_READER_SETTING_KEY, DomainName.SYS_UI,
        this.refreshIsAccessibilityMode);
    } catch (error) {
      log.error('Register accessibility mode error', error);
    }
  }

  private refreshIsAccessibilityMode = (): void => {
    try {
      const val = settings.getValueSync(this.context, ACCESSIBILITY_SCREEN_READER_SETTING_KEY, '0') === '1';
      this.currMode = val;
      log.showInfo('Mode change to %{public}s', val)
      AppStorage.setOrCreate('isAccessibilityMode', val);
    } catch (err) {
      log.error('Get accessibility screen reader enable error', err);
    }
  }

  public unRegisterAccessibilityModeListener(): void {
    try {
      settings.unregisterKeyObserver(this.context, ACCESSIBILITY_SCREEN_READER_SETTING_KEY, DomainName.SYS_UI);
    } catch (error) {
      log.error('Unregister accessibility mode error', error);
    }
  }

  public sendAccessibility(str?: string): void {
    log.showInfo('Send accessibility, message: %{public}s, currMode: %{public}s', str, this.currMode);
    if (!this.currMode || !str) {
      return;
    }

    let accessEventInfo: accessibility.EventInfo = ({
      type: 'announceForAccessibility',
      bundleName: 'com.ohos.sceneboard',
      triggerAction: 'click',
      textAnnouncedForAccessibility: str,
    });

    try {
      accessibility.sendAccessibilityEvent(accessEventInfo, (err: BusinessError) => {
        if (err) {
          log.showError(`Failed to send event, Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo(`Succeeded in send event`);
      });
    } catch (error) {
      log.error('sendAccessibilityEvent failed', error);
    }
  }

  public async requestFocusAccessibility(customId: string): Promise<void> {
    if (!this.currMode) {
      return;
    }

    try {
      await accessibility.sendAccessibilityEvent({
        type: 'requestFocusForAccessibility',
        bundleName: 'com.ohos.sceneboard',
        triggerAction: 'common',
        customId: customId,
      });
    } catch (err) {
      log.showError(`requestFocusAccessibility failed, Code is ${err.code}, message is ${err.message}`);
    }
  }
}