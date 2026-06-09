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
import accessibility from '@ohos.accessibility';
import { BusinessError } from '@ohos.base';
import { SCBConstants } from '@ohos/commonconstants';
import { GlobalContext } from './GlobalContext';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { settingsDataManager } from '../setting/SettingsDataManager';

const TAG: string = 'AccessibilityManager';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const ACCESSIBILITY_SCREEN_READER_SETTING_KEY = 'accessibility_screenreader_enabled';

export class AccessibilityManager {
  // 是否开启了无障碍屏幕朗读
  private isAccessibilityScreenReaderEnable: boolean = false;

  // 事件是否注册成功
  private isListenerHasRegistered: boolean = false;

  private accessibilityChangeCallbacks: Map<string, Function> = new Map<string, Function>();

  static getInstance(): AccessibilityManager {
    if (globalThis.accessibilityManager == null) {
      log.showInfo('AccessibilityManager getInstance');
      globalThis.accessibilityManager = new AccessibilityManager();
    }
    return globalThis.accessibilityManager;
  }

  /**
   * 获取是否开启无障碍模式
   *
   */
  public getIsAccessibilityMode(): boolean {
    return this.isAccessibilityScreenReaderEnable;
  }


  /**
   * 注册无障碍模式变化监听
   *
   */
  public initAccessibilityModeListener(): void {
    try {
      const newStatus: boolean = settingsDataManager
        .getValue(null, ACCESSIBILITY_SCREEN_READER_SETTING_KEY, '0') === '1';

      this.updateAccessibilityMode(newStatus);

      if (!this.isListenerHasRegistered) {
        this.isListenerHasRegistered = settingsDataManager.registerKeyObserver(
          ACCESSIBILITY_SCREEN_READER_SETTING_KEY,
          () => {
            let newValue = settingsDataManager
              .getValue(null, ACCESSIBILITY_SCREEN_READER_SETTING_KEY, '0');
            const newStatus: boolean = newValue === '1';
            log.showInfo(`accessibilityStateChange: type ${typeof newValue} value ${newValue}`);
            this.updateAccessibilityMode(newStatus);
          });
      }
    } catch (err) {
      log.showError(`initAccessibilityModeListener error ${err?.message}`);
    }

  }

  private updateAccessibilityMode(newStatus: boolean): void {
    if (newStatus === this.isAccessibilityScreenReaderEnable) {
      return;
    }
    log.showInfo(`updateAccessibilityMode: ${newStatus}`);
    this.isAccessibilityScreenReaderEnable = newStatus;
    this.notifyAccessibilityChange();
    AppStorage.setOrCreate('isAccessibilityMode', newStatus);
    GlobalContext.getContext()?.eventHub.emit(SCBConstants.IS_ACCESSIBILITY_MODE_OPEN, newStatus);
  }

  /**
   * 发送屏幕朗读事件
   */
  private sendAccessibilityEvent(eventInfo: accessibility.EventInfo, type: string, from: string = ''): void {
    try {
      accessibility.sendAccessibilityEvent(eventInfo, (err: BusinessError) => {
        if (err) {
          log.showError('%{public}s Failed to send event, Code is %{public}s, message is %{public}s', from, err.code,
            err.message);
          return;
        }
        log.showInfo(`%{public}s Succeeded to send event, eventInfo is %{public}s`, from, eventInfo);
      });
    } catch (error) {
      log.showError(`%{public}s %{public}s failed`, from, type);
    }
  }

  /**
   * 在无障碍模式下主动播报信息
   *
   * @param textAnnouncedForAccessibility 主动播报信息 string
   * @param from string
   *
   */
  public sendTextAnnouncedForAccessibility(textAnnouncedForAccessibility: string, from: string = ''): void {
    let accessEventInfo: accessibility.EventInfo = ({
      type: 'announceForAccessibility',
      bundleName: 'com.ohos.sceneboard',
      triggerAction: 'common',
      textAnnouncedForAccessibility,
    });

    this.sendAccessibilityEvent(accessEventInfo, 'announceForAccessibility', from);
  }

  /**
   * 在无障碍模式下主动聚焦
   * @param customId 待聚焦组件id
   * @param from string
   */
  public requestFocusForAccessibility(customId: string, from: string = ''): void {
    let eventInfo: accessibility.EventInfo = ({
      type: 'requestFocusForAccessibility',
      bundleName: 'com.ohos.sceneboard',
      triggerAction: 'common',
      customId,
    });

    this.sendAccessibilityEvent(eventInfo, 'requestFocusForAccessibility', from);
  }

  /**
   * 在无障碍模式主动聚焦
   *
   * @param customId 主动聚焦组件Id
   * @param isInterrupt 是否打断上次播报
   */
  public requestFocusAccessibility(customId: string, isInterrupt: boolean = true): void {
    let eventInfo: accessibility.EventInfo = ({
      type: isInterrupt ? 'requestFocusForAccessibility' : 'requestFocusForAccessibilityNotInterrupt',
      bundleName: 'com.ohos.sceneboard',
      triggerAction: 'common',
      customId: customId,
    });

    try {
      accessibility.sendAccessibilityEvent(eventInfo, (err: BusinessError) => {
        if (err) {
          log.showError(`failed to send event, Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo(`succeeded in send event, eventInfo is ${eventInfo}`);
      });
    } catch (error) {
      log.showError('sendAccessibilityEvent failed');
    }
  }

  /**
   * 注册无障碍模式变化通知回调
   * @param registerTag
   * @param callback
   */
  public registerAccessibilityChangeCallback(registerTag: string, callback: Function): void {
    if (this.accessibilityChangeCallbacks.has(registerTag)) {
      log.showWarn(`RegisterTag ${registerTag} has been registered!`);
      return;
    }
    if (!registerTag || !callback) {
      log.showWarn(`Invalid tag or function!`);
      return;
    }
    this.accessibilityChangeCallbacks.set(registerTag, callback);
    log.showInfo(`RegisterTag ${registerTag} is registered successfully.`);
  }

  /**
   * 取消注册无障碍模式变化通知回调
   * @param registerTag
   */
  public unRegisterAccessibilityChangeCallback(registerTag: string, callback: Function): void {
    if (!this.accessibilityChangeCallbacks.has(registerTag) || this.accessibilityChangeCallbacks.get(registerTag) !== callback) {
      log.showWarn(`The callback function does not match, cannot to unregister.`);
      return;
    }
    if (this.accessibilityChangeCallbacks.delete(registerTag)) {
      log.showInfo(`RegisterTag ${registerTag} is deleted successfully.`);
    }
  }

  // 通知注册方无障碍模式发生变化
  private notifyAccessibilityChange(): void {
    this.accessibilityChangeCallbacks.forEach((callback: Function, tag: string) => {
      try {
        callback();
        log.showInfo(`The callback function ${tag} is executed`);
      } catch(error) {
        log.showError(`The callback function occurred error: ${error?.code}, ${error?.message}`);
      }
    })
  }
}