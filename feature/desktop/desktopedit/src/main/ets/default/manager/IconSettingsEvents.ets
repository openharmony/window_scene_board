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

import CommonEventManager from '@ohos.commonEventManager';
import { DesktopManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { LogDomain, Logger, SingletonHelper } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';

const TAG = 'IconSettingsEvents';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 *  图标编辑应用完成公共事件
 */
const EVENT_APPLY_ICONS_SETTINGS: string = 'custom.event.APPLY_ICONS_SETTINGS';

/**
 *  图标编辑公共事件订阅工具类
 */
export class IconSettingsEvents {
  private static instance: IconSettingsEvents;
  private subscriber?: CommonEventManager.CommonEventSubscriber;

  public static getInstance(): IconSettingsEvents {
    if (!IconSettingsEvents.instance) {
      IconSettingsEvents.instance = new IconSettingsEvents();
    }
    return IconSettingsEvents.instance;
  }

  /**
   *  注册图标编辑公共事件订阅
   */
  public createSubscriber(): void {
    let subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
      events: [EVENT_APPLY_ICONS_SETTINGS],
      publisherBundleName: SCBConstants.SCENE_BOARD_PKG,
    };
    CommonEventManager.createSubscriber(subscribeInfo).then((commonEventSubscriber) => {
      this.subscriber = commonEventSubscriber;
      this.subscribeEvent();
      log.showInfo(TAG, 'Succeeded in creating subscriber.');
    }).catch((err: Error) => {
      log.showInfo(TAG, `Failed to create subscriber. ${err.message}`);
    });
  }

  /**
   *  反注册图标编辑公共事件订阅
   */
  public unSubscribeEvent(): void {
    try {
      CommonEventManager.unsubscribe(this.subscriber);
    } catch (error) {
      log.showError(TAG, `Failed to unSubscribeBackEvent. Code is ${error?.code}, message is ${error?.message}`);
    }
  }

  private subscribeEvent(): void {
    try {
      CommonEventManager.subscribe(this.subscriber, (err, data) => {
        if (err) {
          log.showInfo(TAG, `Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo(TAG, `event subscribe --- ${data.event}`);
        if (data.event === EVENT_APPLY_ICONS_SETTINGS) {
          DesktopManager.getInstance().saveDesktopParam();
        }
      });
    } catch (error) {
      log.showError(TAG, `subscribe failed, code is ${error?.code}, message is ${error?.message}`);
    }
  }
}