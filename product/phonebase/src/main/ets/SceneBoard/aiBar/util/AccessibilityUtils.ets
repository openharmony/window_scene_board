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
import { ResUtils } from '@ohos/windowscene';
import { AccessibilityManager } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { accessibility } from '@kit.AccessibilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'AccessibilityUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 桌面组件拖拽适配无障碍朗读工具类
 */
export class AccessibilityUtils {
  /**
   * 判断是否处于无障碍模式
   * @returns
   */
  public static isAccessibilityMode(): boolean {
    return AccessibilityManager.getInstance().getIsAccessibilityMode();
  }

  /**
   * 无障碍模式播报拖入导航条拖拽热区（纯文本）
   */
  public static textAnnouncedForDragEnterAIBar(): void {
    if (AccessibilityUtils.isAccessibilityMode()) {
      let announcedText: string = ResUtils.getInnerString($r('app.string.drag_to_voice_reminder'));
      if (!announcedText) {
        log.showError('announcedText is empty');
        return;
      }
      AccessibilityUtils.sendAccessibilityText(announcedText, 'textAnnouncedForDragEnterAIBar');
    }
  }

  /**
   * 在无障碍模式下主动播报信息
   * @param announcedText  播报的信息
   * @param from  播报来自哪里
   */
  private static sendAccessibilityText(announcedText: string, from: string): void {
    let accessEventInfo: accessibility.EventInfo = ({
      type: 'announceForAccessibility',
      bundleName: 'com.ohos.sceneboard',
      triggerAction: 'common',
      textAnnouncedForAccessibility: announcedText,
    });
    log.showInfo(`%{public}s sendAccessibilityText textAnnouncedForAccessibility %{public}s`,
      from, accessEventInfo.textAnnouncedForAccessibility);
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
}