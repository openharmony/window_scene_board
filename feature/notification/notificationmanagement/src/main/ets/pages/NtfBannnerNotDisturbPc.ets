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
import { LabelToggleView } from './NotificationMgmtCompments';
import { StateValue } from '../vm/NotificationMgmtViewData';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  SettingsConstants,
  SettingsKeyConstants
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { sSettingsUtil } from '@ohos/managementcomponent';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = 'NtfBannerNotDisturb';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

@Component
export struct NtfBannerNotDisturbPc {
  @State showBanner: StateValue = new StateValue(true);
  @State isBannerHideContent: boolean = false;

  async aboutToAppear() {
    log.showInfo(`aboutToAppear NtfBannerNotDisturbPc`);
    // 获取横幅通知免打扰按钮当前状态
    this.getBannerNotDisturb();
    this.isBannerHideContent = await this.hideBannerContentInit();
  }

  @Builder
  buildHideContentView() {
    Row() {
      Column() {
        Text($r('app.string.hide_banner_content_title'))
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

      Toggle({ type: ToggleType.Switch, isOn: !this.isBannerHideContent })
        .selectedColor($r('sys.color.ohos_id_color_emphasize'))
        .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .width($r('app.float.toggle_comp_width'))
        .height($r('app.float.toggle_comp_height'))
        .margin({
          end: LengthMetrics.resource($r('app.float.switchComp_padding_r'))
        })
        .onChange((isOn) => {
          this.switchHideBannerContent(isOn);
        })
        .hoverEffect(HoverEffect.Auto)
    }
    .width('100%')
    .margin({ top: LengthMetrics.vp(6), bottom: LengthMetrics.vp(4) })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Stack() {
      Column() {
        LabelToggleView({
          label: $r('app.string.notification_not_banner'),
          state: this.showBanner,
          onChange: (isOn: boolean) => {
            this.setShowBanner(isOn)
          },
          properties: { height: 40, margin: { top: 4 } }
        });
        Divider()
          .height('1px')
          .strokeWidth('1px')
          .color($r('sys.color.comp_divider'))
          .margin({
            start: LengthMetrics.resource($r('app.float.toggle_label_text_indentation')),
            end: LengthMetrics.resource($r('app.float.switchComp_padding_r'))
          })
        this.buildHideContentView()
      }
      .border({
        color: $r('app.color.card_panel_bg'),
        radius: $r('app.float.mgmt_app_item_icon_radius')
      })
      .backgroundColor($r('app.color.card_panel_bg'))
    }
    .width('100%')
    .margin({
      top: $r('app.float.ntf_search_list_padding_bottom'),
      bottom: $r('app.float.ntf_search_list_padding_bottom')
    })
  }

  /**
   * 设置通知中心横幅通知屏蔽功能
   * @returns
   */
  private setShowBanner(isOn: boolean): void {
    this.showBanner.setState(isOn);
    try {
      NtfSettingSysEventReporter.bannerNotDisturb({ IS_ON: isOn ? 0 : 1 });
      sSettingsUtil.setSystemValue(SettingsKeyConstants.BANNER_NO_DISTURB, (!isOn).toString());
    } catch (err) {
      log.showError('setSystemValue error %{public}d: %{public}s', err.code, err.message);
    }
  }

  /**
   * 获取通知中心横幅通知屏蔽功能开关状态
   * @returns
   */
  private getBannerNotDisturb(): void {
    try {
      let isOnString: string = sSettingsUtil.getSystemValue(SettingsKeyConstants.BANNER_NO_DISTURB, 'false') ?? '';
      this.showBanner.setState(isOnString === 'false');
    } catch (err) {
      log.showError('getSystemValue error %{public}d: %{public}s', err.code, err.message);
    }
  }

  async hideBannerContentInit(): Promise<boolean> {
    return new Promise((resolve: (value: boolean | PromiseLike<boolean>) => void) => {
      const defValue: string = SettingsConstants.APP_NTF_CONFIG_HIDE_BANNER_CONTENT_DEFAULT;
      const value: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_BANNER_CONTENT, defValue) ?? '';
      log.showInfo('hideBannerContentInit: [%{public}s]', value);
      resolve(value === '1');
    });
  }

  switchHideBannerContent(on: boolean) {
    NtfSettingSysEventReporter.bannerNotificationHideManagement({ IS_HIDE_BANNER_CONTENT: on ? 0 : 1 });
    const result: boolean =
      sSettingsUtil.setSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_BANNER_CONTENT, on ? '0' : '1');
    log.showInfo('switchHideBannerContent: [%{public}s], result [%{public}s]', on, result);
  }
}

@Builder
export function buildNtfBannerNotDisturb() {
  NtfBannerNotDisturbPc();
}