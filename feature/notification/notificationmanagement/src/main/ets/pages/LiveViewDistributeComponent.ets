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
import { DeviceHelper } from '@ohos/managementcomponent';
import NtfManager from '@ohos.notificationManager';
import { SettingExceptionCode } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SettingExceptionCode';

const TAG = 'ManagementComponent-LiveViewDistributeComponent'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const LIVE_VIEW_DISTRIBUTE_TITLE: Resource = $r('app.string.allow_live_view_distribution');

/**
 * 实况窗多屏协同通知开关
 */
@Component
export default struct LiveViewDistributeComponent {
  build() {
    Column() {
      this.buildLiveViewDistributeButton();
    }
    .padding({ top: $r('app.float.noDisturb_margin_lf'), bottom: $r('app.float.noDisturb_margin_lf') })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('app.float.ntf_setting_item_card_radius'))
  }

  /**
   * 实况窗多屏协同开关
   */
  @Builder
  buildLiveViewDistributeButton() {
    SwitchComponent({
      title: LIVE_VIEW_DISTRIBUTE_TITLE,
      isDistributed: true,
      initializationAction: () => this.switchInit(),
      settingAction: (params?: boolean) => {
        if (params !== undefined) {
          this.switchDistributeButton(params);
        }
      }
    });
  }

  /**
   * 实况窗多屏协同开关 初始化
   */
  async switchInit(): Promise<boolean> {
    try {
      const result =
        await NtfManager.isDistributedEnabledBySlot(NtfManager.SlotType.LIVE_VIEW, DeviceHelper.DEVICE_TYPE);
      log.showInfo(`liveview distribution success, result is ${result}`);
      return result;
    } catch (e) {
      LogWithHa.error(log, `get distribution state error ${e}`,
        SettingExceptionCode.GET_LIVE_VIEW_DISTRIBUTION_STATE_FAIL, e);
      return false;
    }
  }

  /**
   * 切换 实况窗多屏协同开关
   * @param on
   */
  async switchDistributeButton(on: boolean): Promise<void> {
    try {
      await NtfManager.setDistributedEnabledBySlot(NtfManager.SlotType.LIVE_VIEW, DeviceHelper.DEVICE_TYPE, on);
      NtfSettingSysEventReporter.NotificationLiveViewDistributionButtonParams({
        IS_LIVE_VIEW_DISTRIBUTE_ON: on ? 0 : 1
      });
      log.showInfo('SwitchLiveViewDistributeButton: result [%{public}s]', on);
    } catch (e) {
      LogWithHa.error(log, `Set liveview distribution state error ${e}`,
        SettingExceptionCode.SET_LIVE_VIEW_DISTRIBUTION_STATE_FAIL, e);
    }
  }
}