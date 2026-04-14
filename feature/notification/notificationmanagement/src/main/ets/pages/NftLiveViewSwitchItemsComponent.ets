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

import SwitchComponent from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/switchComponent';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { sSettingsUtil } from '@ohos/managementcomponent';
import {
  SettingsConstants,
  SettingsKeyConstants
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';

const TAG = 'ManagementComponent-NftLiveViewSwitchItemsComponent'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const showLiveViewPreviewTitle: Resource = $r('app.string.show_live_view_preview_when_screen_lock');

@Component
export default struct NftLiveViewSwitchItemsComponent {
  build() {
    Column() {
      this.buildNtfLiveViewDisplayPreviewItem();
    }
    .padding({ top: $r('app.float.noDisturb_margin_lf'), bottom: $r('app.float.noDisturb_margin_lf') })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius($r('app.float.ntf_setting_item_card_radius'))
  }

  /**
   * 锁定时显示实况预览
   */
  @Builder
  buildNtfLiveViewDisplayPreviewItem() {
    SwitchComponent({
      title: showLiveViewPreviewTitle,
      initializationAction: () => this.switchHideLiveViewNotificationInit(),
      settingAction: (params?: boolean) => {
        if (params !== undefined) {
          this.switchHideLiveViewNotificationContent(params);
        }
      }
    });
  }

  /**
   * 锁定时显示预览（隐藏实况内容的反义） 初始化
   * @returns
   */
  async switchHideLiveViewNotificationInit(): Promise<boolean> {
    return new Promise((resolve: (v: boolean) => void) => {
      const defValue: string = SettingsConstants.APP_LIVE_VIEW_HIDE_CONTENT_DEFAULT ? 'true' : 'false';
      const value = sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT, defValue);
      log.showInfo('switchHideLiveViewNotificationInit: [%{public}s]', value);
      resolve(value === 'false');
    });
  }

  /**
   * 切换 锁定时显示实况预览
   * @param on
   */
  switchHideLiveViewNotificationContent(on: boolean): void {
    let result: boolean = sSettingsUtil.setSecureValue(SettingsKeyConstants.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT, on ? 'false' : 'true');
    log.showInfo('switchHideLiveViewNotificationContent. on: [%{public}s], set value result: [%{public}s]', on, result);
    NtfSettingSysEventReporter.liveViewDisplayPreview({
      LIVE_VIEW_DISPLAY_PREVIEW: on ? 0 : 1
    });
  }
}