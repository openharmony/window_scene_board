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
import { EvtBus, PluginSlot, RequestWindowEvent } from '@ohos/frameworkwrapper';
import { NotificationType } from '../common/NotificationType';
import { ntfSettingsDC as NtfSettingsDC } from '../controller/NtfSettingsDialogController';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';

const TAG = 'SysUI_NotificationPanelManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知面板API管理，实际归属于 ./NotificationManager 该类。
 *
 * @since 2023-09-27
 */
export class NotificationPanelManager {
  /**
   * 请求收起通知面板
   *
   * @param ntfType 面板类型
   * @param isAnim 是否动画收起
   */
  public static collapseNtfPanel(ntfType: number, isAnim: boolean): void {
    // PC通知面板收起
    if (ntfType === NotificationType.TYPE_PC) {
      let pcPanelName = PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL;
      let event = RequestWindowEvent.create(pcPanelName, RequestWindowEvent.REQUEST_HIDE);
      event.hasWindowAnim = isAnim;
      EvtBus.post(RequestWindowEvent, event);
      return;
    }
    // 下拉面板收起
    if (ntfType === NotificationType.TYPE_PHONE_DROPDOWN) {
      DropDownPanelManager.postRequestHideWindow(isAnim);
    }
  }

  /**
   * 延迟收起通知面板
   *
   * @param ntfType 面板类型
   * @param isAnim 是否动画收起
   */
  public static collapseNtfPanelWithDelay(ntfType: number, delay: number): void {
    if (ntfType === NotificationType.TYPE_PHONE_DROPDOWN) {
      // 当前有弹窗，不收起
      if (NtfSettingsDC.isShowing(NotificationType.TYPE_PHONE_DROPDOWN)) {
        log.showError('hideDropDownWindow NtfSettingsDialog show return');
        return;
      }
      DropDownPanelManager.animDelayToDismiss(delay);
    }
  }
}