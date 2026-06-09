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
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { NtfSettingSysEventReporter }
  from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { sSettingsUtil, HiDfxEventUtil } from '@ohos/managementcomponent';
import {
  SettingsConstants,
  SettingsKeyConstants
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';

const TAG = 'ManagementComponent-NftMgmtSwitchItemsComponent'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const screenLockNtfStyle: Resource = $r('app.string.lock_screen_notification_style');
const screenOnTitle: Resource = $r('app.string.wake_screen_when_receive_notification');

@Component
export default struct NtfMgmtSwitchItemsComponent {
  build() {
    Column() {
      this.buildNtfMgmtScreenOnItem();
    }
    .padding({ top: $r('app.float.noDisturb_margin_lf'), bottom: $r('app.float.noDisturb_margin_lf') })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('app.float.ntf_setting_item_card_radius'))
  }

  /**
   * 锁屏上显示为列表
   */
  @Builder
  buildNtfScreenLockStyleItem() {
    SwitchComponent({
      title: screenLockNtfStyle,
      initializationAction: () => this.ntfScreenLockUpperStyleInit(),
      settingAction: (params?: boolean) => {
        if (params != undefined) {
          this.switchNtfScreenLockStyle(params);
        }
      }
    });
  }

  /**
   * 收到通知自动亮屏
   */
  @Builder
  buildNtfMgmtScreenOnItem() {
    SwitchComponent({
      title: screenOnTitle,
      initializationAction: () => this.switchScreenOnWhenNotifiedInit(),
      settingAction: (params?: boolean) => {
        if (params != undefined) {
          this.switchScreenOnWhenNotified(params);
        }
      }
    });
  }

  /**
   * 收到通知自动亮屏 初始化
   */
  async switchScreenOnWhenNotifiedInit(): Promise<boolean> {
    return new Promise((resolve: (value: boolean | PromiseLike<boolean>) => void) => {
      const devValue: string = SettingsConstants.APP_NTF_SCREEN_ON_DEFAULT ? 'true' : 'false';
      let value = sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SCREEN_ON, devValue);
      log.showInfo('SwitchScreenOnWhenNotifiedInit: [%{public}s]', value);
      resolve(value === 'true');
    });
  }

  /**
   * 切换 收到通知自动亮屏
   * @param on
   */
  switchScreenOnWhenNotified(on: boolean): void {
    let result: boolean = sSettingsUtil.setSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SCREEN_ON, on ? 'true' : 'false');
    log.showInfo('SwitchScreenOnWhenNotified: [%{public}s], result [%{public}s]', on, result);
    HiDfxEventUtil.reportWakeScreen(on ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE);
    NtfSettingSysEventReporter.notificationScreenManagement({
      OPERATE_METHOD: on ? 0 : 1
    });
  }

  /**
   * 锁定时显示预览（原来的隐藏通知内容的反义） 初始化
   * @returns
   */
  async switchHideNotificationInit(): Promise<boolean> {
    return new Promise((resolve: (value: boolean | PromiseLike<boolean>) => void) => {
      const defValue: string = SettingsConstants.APP_NTF_HIDE_CONTENT_DEFAULT ? 'true' : 'false';
      const value = sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_CONTENT, defValue);
      log.showInfo('SwitchHideNotificationInit: [%{public}s]', value);
      resolve(value === 'false');
    });
  }

  /**
   * 切换 锁定时显示预览（原来的隐藏通知内容的反义）
   * @param on
   */
  switchHideNotificationContent(on: boolean): void {
    on = !on;
    let result: boolean = sSettingsUtil.setSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_CONTENT, on ? 'true' : 'false');
    log.showInfo('SwitchHideNotificationContent. on: [%{public}s], set value result: [%{public}s]', on, result);
    HiDfxEventUtil.reportHideNotificationContent(on ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE);
    NtfSettingSysEventReporter.notificationDisplayPreview({
      NTF_MORE_SETTING_DISPLAY_PREVIEW: on ? 1 : 0
    });
  }

  /**
   * 锁屏时显示为列表 初始化
   * @returns
   */
  async ntfScreenLockUpperStyleInit(): Promise<boolean> {
    return new Promise((resolve: (value: boolean | PromiseLike<boolean>) => void) => {
      const devValue: string = SettingsConstants.NTF_LOCK_SCREEN_STYLE_UPPER ? 'true' : 'false';
      let value = sSettingsUtil.getSecureValue(SettingsKeyConstants.NTF_SCREEN_LOCK_STYLE, devValue);
      log.showInfo('switchNtfScreenLockStyleInit: [%{public}s]', value);
      resolve(value === 'true');
    });
  }

  /**
   * 切换 锁屏时显示为列表，设置是否高位显示锁屏通知
   * @param on
   */
  switchNtfScreenLockStyle(on: boolean): void {
    let result: boolean = sSettingsUtil.setSecureValue(SettingsKeyConstants.NTF_SCREEN_LOCK_STYLE, on ? 'true' : 'false');
    log.showInfo('switchNtfScreenLockStyle: [%{public}s], result [%{public}s]', on, result);
  }
}