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
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { sSettingsUtil, HiDfxEventUtil } from '@ohos/managementcomponent';
import {
  SettingsConstants,
  SettingsKeyConstants
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';

const TAG = 'ManagementComponent-NftBadgeSwitchItemsComponent'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const badgeSwitchTitle: Resource = $r('app.string.show_desktop_badges');

@Component
export default struct NftBadgeSwitchItemsComponent {
  build() {
    Column() {
      this.buildNtfBadgeSwitchItem();
    }
    .padding({ top: $r('app.float.noDisturb_margin_lf'), bottom: $r('app.float.noDisturb_margin_lf') })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('app.float.ntf_setting_item_card_radius'))
  }

  /**
   * 显示桌面角标
   */
  @Builder
  buildNtfBadgeSwitchItem() {
    SwitchComponent({
      title: badgeSwitchTitle,
      initializationAction: () => this.ShowDesktopBadgeSwitchWhenNotifiedInit(),
      settingAction: (params?: boolean) => {
        if (params !== undefined) {
          this.SwitchShowDesktopBadgeWhenNotified(params);
        }
      }
    });
  }

  /**
   * 显示桌面角标 初始化
   */
  async ShowDesktopBadgeSwitchWhenNotifiedInit(): Promise<boolean> {
    return new Promise((resolve: (value: boolean | PromiseLike<boolean>) => void) => {
      const devValue: string = SettingsConstants.NTF_SHOW_DESKTOP_BADGES_DEFAULT ? 'true' : 'false';
      let value = sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES, devValue);
      log.showInfo('BadgeSwitchWhenNotifiedInit: [%{public}s]', value);
      resolve(value === 'true');
    });
  }

  /**
   * 切换 显示桌面角标开关
   * @param on
   */
  SwitchShowDesktopBadgeWhenNotified(on: boolean): void {
    let result: boolean =
      sSettingsUtil.setSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES, on ? 'true' : 'false');
    log.showInfo('switchShowDesktopBadgesWhenNotified: [%{public}s], result [%{public}s]', on, result);
    HiDfxEventUtil.reportShowDesktopBadges(on ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE);
    NtfSettingSysEventReporter.notificationShowDesktopBadge({
      OPERATE_METHOD: on ? 0 : 1
    });
  }
}