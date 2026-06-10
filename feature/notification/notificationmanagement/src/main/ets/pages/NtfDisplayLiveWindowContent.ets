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
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { sSettingsUtil } from '@ohos/managementcomponent';
import {
  SettingsConstants,
  SettingsKeyConstants
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import ntfMngSelectComponent
  from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/ntfMngSelectComponent';
import { NotificationMgmtViewData } from '../vm/NotificationMgmtViewData';

const TAG = 'ManagementComponent-NtfDisplayLivWindowContent'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const displayLiveWindowContent: Resource | string = $r('app.string.display_live_window_content');
const displayLiveWindowTip: Resource | string = $r('app.string.display_live_window_content_tip');
const selectOptions: Resource[] = [$r('app.string.always_display'), $r('app.string.display_when_unlocked')];

@Component
export default struct NtfDisplayLiveWindowContent {
  @State viewData: NotificationMgmtViewData = new NotificationMgmtViewData();

  build() {
    Column() {
      this.buildNtfDisplayLiveWindowContentItem();
      this.buildNtfDisplayLiveWindowContentTxt();
    }
  }

  @Builder
  buildNtfDisplayLiveWindowContentItem() {
    ntfMngSelectComponent({
      title: displayLiveWindowContent,
      selectOptions: selectOptions,
      initializationAction: () => this.selectNtfDisplayLiveWindowContentInit(),
      settingAction: (params?: number) => {
        if (params != undefined) {
          this.selectNtfDisplayLiveWindowContent(params);
        }
      }
    })
      .padding({ top: $r('app.float.noDisturb_margin_lf'), bottom: $r('app.float.noDisturb_margin_lf') })
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .borderRadius($r('app.float.ntf_setting_item_card_radius'))
  }

  @Builder
  buildNtfDisplayLiveWindowContentTxt() {
    Row() {
      Text(displayLiveWindowTip) {
      }
      .width('100%')
      .fontSize(12)
      .maxFontScale(2)
      .fontFamily('HarmonyHeiTi')
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .fontWeight(FontWeight.Regular)
      .constraintSize({ minHeight: $r('app.float.ntf_hide_banner_txt_lineHeight') })
    }
    .margin({ top: $r('app.float.ntf_hide_banner_txt_margin') })
    .width('100%')
    .padding({
      left: $r('app.float.ntf_hide_banner_txt_padding'),
      right: $r('app.float.ntf_hide_banner_txt_padding')
    })
  }

  /**
   * 展示实况窗内容 初始化
   */
  async selectNtfDisplayLiveWindowContentInit(): Promise<boolean> {
    return new Promise((resolve: (v: boolean) => void) => {
      const defValue: string = SettingsConstants.APP_LIVE_VIEW_HIDE_CONTENT_DEFAULT ? 'true' : 'false';
      const value = sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT, defValue);
      log.showInfo('switchHideLiveViewNotificationInit: [%{public}s]', value);
      resolve(value === 'false');
    });
  }

  /**
   * 切换 展示实况窗内容
   */
  selectNtfDisplayLiveWindowContent(on: number): void {
    let result: boolean =
      sSettingsUtil.setSecureValue(SettingsKeyConstants.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT, on ? 'true' : 'false');
    log.showInfo('switchHideLiveViewNotificationContent. on: [%{public}s], set value result: [%{public}s]', on, result);
    NtfSettingSysEventReporter.liveViewDisplayPreview({
      LIVE_VIEW_DISPLAY_PREVIEW: on ? 1 : 0,
    });
  }
}