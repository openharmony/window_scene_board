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
import SwitchComponent from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/switchComponent';
import { LogDomain, LogHelper, LogWithHa } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { SettingExceptionCode } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SettingExceptionCode';
import {
  isDistributedEnabled,
  setDistributedEnabled
} from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubNotificationDistribution';
import { DeviceHelper } from '@ohos/managementcomponent';

const TAG = 'ManagementComponent-NotificationDistributeComponent'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const NOTIFICATION_DISTRIBUTE_TITLE: Resource = $r('app.string.allow_notification_distribution');

/**
 * 普通通知多屏协同通知开关
 */
@Component
export default struct NotificationDistributeComponent {
  build() {
    Column() {
      this.buildNotificationDistributeButton();
    }
    .padding({ top: $r('app.float.noDisturb_margin_lf'), bottom: $r('app.float.noDisturb_margin_lf') })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('app.float.ntf_setting_item_card_radius'))
  }

  /**
   * 多屏协同开关
   */
  @Builder
  buildNotificationDistributeButton() {
    SwitchComponent({
      title: NOTIFICATION_DISTRIBUTE_TITLE,
      isDistributed: true,
      initializationAction: () => this.showNotificationDistributeButtonInit(),
      settingAction: (params?: boolean) => {
        if (params !== undefined) {
          this.switchNotificationDistributeButton(params);
        }
      }
    });
  }

  /**
   * 多屏协同开关 初始化
   */
  async showNotificationDistributeButtonInit(): Promise<boolean> {
    try {
      const result = await isDistributedEnabled(DeviceHelper.DEVICE_TYPE);
      log.showInfo(`distribution success, result is ${result}`);
      return result;
    } catch (e) {
      LogWithHa.error(log, `get distribution state error ${e}`,
        SettingExceptionCode.GET_DISTRIBUTION_STATE_FAIL, e);
      return false;
    }
  }

  /**
   * 切换 多屏协同开关
   * @param on
   */
  async switchNotificationDistributeButton(on: boolean): Promise<void> {
    try {
      await setDistributedEnabled(on, DeviceHelper.DEVICE_TYPE)
      NtfSettingSysEventReporter.NotificationDistributionButton({
        IS_DISTRIBUTE_BUTTON_ON: on ? 0 : 1
      });
      log.showInfo('SwitchNotificationDistributeButton: result [%{public}s]', on);
    } catch (e) {
      LogWithHa.error(log, `Set distribution state error ${e}`,
        SettingExceptionCode.SET_DISTRIBUTION_STATE_FAIL, e);
    }
  }
}