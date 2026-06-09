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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { AccessibilityPageShowHide } from './AccessibilityData';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '../maintenance/CommonExceptionCode';
import { AccessibilityVm } from '../vm/AccessibilityVm';

const TAG: string = 'SystemUI-AccessibilityUtil';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class AccessibilityUtil {

  /**
   * 判断当前是否在无障碍模式下
   */
  public static isAccessibilityMode(): boolean {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return AppStorage.get<boolean>('isAccessibilityMode')!;
    } else {
      return AccessibilityVm.instance.isEnabled;
    }
  }

  /**
   * 在无障碍模式下主动播报信息
   *
   * @param bundleName 主动播报信息
   *
   */
  public static sendAccessibility(textAnnouncedForAccessibility: string): void {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      return;
    }
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
      LogWithHa.error(log, 'sendAccessibilityEvent failed', CommonExceptionCode.ACCESS_SEND_FAIL);
    }
  }

  public static sendControlCenterAccessibility(pageState: number): void {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      log.showInfo(`isAccessibilityMode  ${AccessibilityUtil.isAccessibilityMode()}`);
      return;
    }
    if (pageState === AccessibilityPageShowHide.SHOW) {
      AccessibilityUtil.sendAccessibility(ResUtils.getInnerString($r('app.string.control_center')));
    }
  }

  public static sendControlCenterToggleClickAccessibility(textAnnouncedForAccessibility: string): void {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      log.showInfo(`isAccessibilityMode  ${AccessibilityUtil.isAccessibilityMode()}`);
      return;
    }
    AccessibilityUtil.sendAccessibility(textAnnouncedForAccessibility);
  }

  public static sendAccessibilityByResource(resource: Resource): void {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      log.showInfo(`isAccessibilityMode  ${AccessibilityUtil.isAccessibilityMode()}`);
      return;
    }
    try {
      AccessibilityUtil.sendAccessibility(ResUtils.getInnerString(resource));
    } catch (err) {
      LogWithHa.error(log, `failed to send event, message is ${err.message}`, CommonExceptionCode.ACCESS_SEND_RESOURCE);
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
      LogWithHa.error(log, 'sendAccessibilityEvent failed', CommonExceptionCode.REQUEST_FOCUS_FAIL);
    }
  }

  public static sendNotificationPanelAccessibility(pageState: number, customId: string = 'NtfPanelHeadertimeView'): void {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      log.showInfo(`isAccessibilityMode  ${AccessibilityUtil.isAccessibilityMode()}`);
      return;
    }
    if (pageState === AccessibilityPageShowHide.SHOW) {
      AccessibilityUtil.sendAccessibility(ResUtils.getInnerString($r('app.string.ntf_center_title')));
      AccessibilityUtil.requestFocusAccessibility(customId);
    }
  }
}