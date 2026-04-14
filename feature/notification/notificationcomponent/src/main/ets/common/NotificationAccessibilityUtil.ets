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
import accessibility from '@ohos.accessibility';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { AccessibilityManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionCode';

const TAG: string = 'Notification-AccessibilityUtil';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NotificationAccessibilityUtil {

  /**
   * 判断当前是否在无障碍模式下
   */
  private static isAccessibilityMode(): boolean {
    return AccessibilityManager.getInstance().getIsAccessibilityMode();
  }

  /**
   * 在无障碍模式下主动播报信息
   *
   * @param textAnnouncedForAccessibility 主动播报信息
   *
   */
  private static sendAccessibility(textAnnouncedForAccessibility: string): void {
    if (!NotificationAccessibilityUtil.isAccessibilityMode()) {
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
      accessibility.sendAccessibilityEvent(accessEventInfo);
      log.showInfo(`Succeeded in send event, eventInfo is ${accessEventInfo}`);
    } catch (err) {
      LogWithHa.error(log, `sendAccessibilityEvent failed to send event, Code is ${err.code}, message is ${err.message}`,
        CommonExceptionCode.ACCESS_SEND_FAIL);
    }
  }

  /**
   * 获取组件滑动的无障碍播报描述
   *
   * @param isAccessibilityMode 当前是否为无障碍模式
   * @param isSwiped 是否已经滑动
   * @returns 是无障碍模式时返回对应场景的Description，非无障碍模式时返回空串，播放默认文本
   */
  public static getSwipeDescription(isAccessibilityMode: boolean, isSwiped: boolean): string {
    if (!isAccessibilityMode) {
      log.showInfo('GetSwipeDescription when disable model');
      return '';
    }
    // 已展开时，仅播报收起tip
    if (isSwiped) {
      return ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_collapse_tips'));
    } else {
      return [
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_click')),
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_focused_action_tips'))].join(' ');
    }
  }

  // 通知卡片滑动结束后发送的语音播报内容
  public static sendNtfSwipeAccessibility(offsetX: number): void {
    if (!NotificationAccessibilityUtil.isAccessibilityMode()) {
      log.showInfo(`isAccessibilityMode ${NotificationAccessibilityUtil.isAccessibilityMode()}`);
      return;
    }
    const isRTL = RTLUtil.isRTL();
    const isToExpand = (isRTL && offsetX > 0) || (!isRTL && offsetX < 0);
    if (isToExpand) {
      // 展开更多操作后，播报更多操作已展开 和 右滑隐藏更多操作
      NotificationAccessibilityUtil.sendAccessibility([
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_swipe_left_text')),
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_collapse_tips'))].join(' '));
    } else {
      NotificationAccessibilityUtil.sendAccessibility(
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_swipe_right_text')));
    }
  }

  public static sendNtfRemoveAccessibility(isRemoveEntry: boolean): void {
    if (!NotificationAccessibilityUtil.isAccessibilityMode()) {
      log.showInfo(`isAccessibilityMode ${NotificationAccessibilityUtil.isAccessibilityMode()}`);
      return;
    }
    log.showInfo(`isRemoveEntry: ${isRemoveEntry}`);
    if (isRemoveEntry) {
      NotificationAccessibilityUtil.sendAccessibility(
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_swipe_remove_text')));
    }
  }
}