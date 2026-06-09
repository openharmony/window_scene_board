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
import { AccessibilityManager } from '@ohos/frameworkwrapper';
import accessibility from '@ohos.accessibility';
import { BusinessError } from '@ohos.base';
import { CommonExceptionCode } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionCode';

const TAG: string = 'AccessibilityUtil';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class AccessibilityUtil {
  /**
   * 判断当前是否在无障碍模式下
   */
  public static isAccessibilityMode(): boolean {
    return AccessibilityManager.getInstance().getIsAccessibilityMode();
  }

  /**
   * 在无障碍模式下主动播报信息
   *
   * @param bundleName 主动播报信息
   *
   */
  public static sendAccessibility(textAnnouncedForAccessibility?: string): void {
    let accessEventInfo: accessibility.EventInfo = ({
      type: 'announceForAccessibility',
      bundleName: 'com.ohos.sceneboard',
      triggerAction: 'click',
      textAnnouncedForAccessibility: '',
    });
    accessEventInfo.textAnnouncedForAccessibility = textAnnouncedForAccessibility;
    log.showInfo(`sendAccessibility textAnnouncedForAccessibility ${accessEventInfo.textAnnouncedForAccessibility}`);
    try {
      accessibility.sendAccessibilityEvent(accessEventInfo, (err: BusinessError) => {
        if (err) {
          log.showError(`failed to send event, Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo(`Succeeded in send event, eventInfo is ${accessEventInfo}`);
      });
    } catch (error) {
      log.showError('sendAccessibilityEvent failed');
    }
  }

  /**
   * 在无障碍模式主动聚焦
   *
   * @param bundleName 主动播报信息
   *
   */
  public static requestFocusAccessibility(customId: string): void {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      return;
    }
    let eventInfo: accessibility.EventInfo = ({
      type: 'requestFocusForAccessibility',
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
        log.showInfo(`Succeeded in send event, eventInfo is ${eventInfo}`);
      });
    } catch (error) {
      log.error(log, 'sendAccessibilityEvent failed', CommonExceptionCode.REQUEST_FOCUS_FAIL);
    }
  }
}