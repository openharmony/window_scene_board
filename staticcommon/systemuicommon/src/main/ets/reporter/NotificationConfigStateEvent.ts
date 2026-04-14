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
import { NotificationSysEventReporter, NtfMoreSettingStateParams } from '../utils/NotificationSysEventReporter';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, sSettingsUtil } from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import {
  getDistributedDeviceList,
  isDistributedEnabled
} from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubNotificationDistribution';

const TAG = 'NotificationConfigStateEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const devLockStyle: string = SettingsConstants.APP_NTF_SCREEN_ON_DEFAULT ? 'true' : 'false';
const devLockPreview: string = SettingsConstants.APP_NTF_SCREEN_ON_DEFAULT ? 'true' : 'false';
const devLockLivePreview: string = SettingsConstants.APP_LIVE_VIEW_HIDE_CONTENT_DEFAULT ? 'true' : 'false';
const devScreenLightUp: string = SettingsConstants.APP_NTF_SCREEN_ON_DEFAULT ? 'true' : 'false';
const devHiddenBannerContent: string = SettingsConstants.APP_NTF_CONFIG_HIDE_BANNER_CONTENT_DEFAULT;
const devShowDesktopBadges: string = SettingsConstants.NTF_SHOW_DESKTOP_BADGES_DEFAULT ? 'true' : 'false';

export class NotificationConfigStateEvent {
  public report(): void {
    let distributeButtonState = false;
    let hasDistributed = false;
    this.hasDistributionSet().then(result => {
      distributeButtonState = result;
    });
    this.showNotificationDistributeButtonInit().then(result => {
      hasDistributed = result;
    });
    // 从数据库读取数据
    let params: NtfMoreSettingStateParams = {
      NTF_LOCK_STYLE: Number(sSettingsUtil.getSecureValue(SettingsKeyConstants.NTF_SCREEN_LOCK_STYLE, devLockStyle) === 'true'),
      IS_LOCK_PREVIEW_ON: Number(sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_CONTENT, devLockPreview) === 'false'),
      IS_LOCK_LIVE_PREVIEW_ON: Number(sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT, devLockLivePreview) === 'false'),
      IS_SCREEN_LIGHT_UP_ON: Number(sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SCREEN_ON, devScreenLightUp) === 'true'),
      IS_HIDDEN_BANNER_CONTENT_ON: Number(sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_BANNER_CONTENT, devHiddenBannerContent)),
      IS_SHOW_DESKTOP_BADEGS_ON: Number(sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES, devShowDesktopBadges) === 'true'),
      IS_DISTRIBUTE_BUTTON_ON: Number(distributeButtonState ? hasDistributed : false),
    };
    NotificationSysEventReporter.ntfMoreSettingState(params);
  }

  /**
   * 获取多屏协同开关状态
   */
  async showNotificationDistributeButtonInit(): Promise<boolean> {
    try {
      const result = await isDistributedEnabled(DeviceHelper.DEVICE_TYPE);
      log.showInfo(`distribution success, result is ${result}`);
      return result;
    } catch (e) {
      log.showError(`get distribution state error ${e}`);
      return false;
    }
  }

  /**
   * 获取设备是否进行过多屏协同
   * @returns 是否进行过多屏协同
   */
  async hasDistributionSet(): Promise<boolean> {
    try {
      const result = await getDistributedDeviceList();
      log.showInfo(`first distribute, ${result.length}`)
      return result.length !== 0;
    } catch (e) {
      log.showError(`get distribution state error ${e}`);
      return false;
    }
  }
}