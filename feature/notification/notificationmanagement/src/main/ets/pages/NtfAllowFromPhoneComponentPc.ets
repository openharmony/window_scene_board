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
import { LengthMetrics } from '@kit.ArkUI';
import { DeviceHelper } from '@ohos/managementcomponent';
import { LogDomain, LogHelper, LogWithHa } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { SettingExceptionCode } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SettingExceptionCode';
import {
  isDistributedEnabled,
  setDistributedEnabled
} from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubNotificationDistribution';

const TAG = 'ManagementComponent-NtfAllowFromPhoneComponentPc'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 设备类型,这样写以适配多屏协同处设置，会在之后更改为DeviceHelper.DEVICE_TYPE
 */
const NOTIFICATION_DISTRIBUTE_TITLE: Resource = $r('app.string.allow_notification_distribution');

/**
 * 普通通知多屏协同通知开关 PC
 */
@Component
export default struct NtfAllowFromPhoneComponentPc {
  @State ntfAllowFromPhoneSetting: boolean = false;

  async aboutToAppear() {
    log.showInfo(`aboutToAppear NtfAllowFromPhoneComponentPc`);
    // 获取普通通知多屏协同通知开关当前状态
    this.showNotificationDistributeButtonInit();
  }

  build() {
    Stack() {
      Row() {
        Column() {
          Text($r('app.string.allow_notification_distribution'))
            .draggable(false)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontWeight(FontWeight.Medium)
            .margin({
              start: LengthMetrics.resource($r('app.float.toggle_label_text_indentation')),
              top: LengthMetrics.vp(6),
              bottom: LengthMetrics.vp(6)
            })
        }
        .alignItems(HorizontalAlign.Start)
        .width('80%')

        Toggle({ type: ToggleType.Switch, isOn: this.ntfAllowFromPhoneSetting})
          .selectedColor($r('sys.color.ohos_id_color_emphasize'))
          .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
          .width($r('app.float.toggle_comp_width'))
          .height($r('app.float.toggle_comp_height'))
          .margin({
            end: LengthMetrics.resource($r('app.float.switchComp_padding_r')),
            top: LengthMetrics.vp(6),
            bottom: LengthMetrics.vp(6)
          })
          .onChange((isOn) => {
            this.switchNotificationDistributeButton(isOn);
          })
          .hoverEffect(HoverEffect.Auto)
      }
      .width('100%')
      .margin({ top: LengthMetrics.vp(8), bottom: LengthMetrics.vp(8) })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
  }

  /**
   * 多屏协同开关 初始化
   */
  async showNotificationDistributeButtonInit(): Promise<boolean> {
    try {
      const result = await isDistributedEnabled(DeviceHelper.DEVICE_TYPE);
      log.showInfo(`distribution success, result is ${result}`);
      this.ntfAllowFromPhoneSetting = result;
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

@Builder
export function buildAllowNtfFromPhonePc() {
  NtfAllowFromPhoneComponentPc();
}