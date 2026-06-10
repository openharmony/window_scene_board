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

import ConfigData from '../common/constants';
import { LengthMetrics } from '@ohos.arkui.node';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { AppIconWithIndexSubIcon } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import notificationManager from '@ohos.notificationManager';
import { AppItem } from '@ohos/managementcomponent/src/main/ets/com/ohos/vm/appLstComponentViewModel';
import lazy { NtfSettingSysEventReporter } from
  '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';

const TAG = 'ManagementComponent-AppLiveViewItemComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const COMPONENT_ID_APP_ICON = TAG + '_Image_appIcon';
const COMPONENT_ID_APP_TITLE = TAG + '_Text_appTitle';
const COMPONENT_ID_NOTICE = TAG + '_Text_notice';

@Component
export default struct AppLiveViewItemComponent {
  @ObjectLink item: AppItem;
  /**
   * 权限描述默认值,先赋值空字符串占位，防止二次更新时抖动
   */
  @State itemDescribeDefaultText: Resource | string = ' ';

  build() {
    Row() {
      this.buildIconWithAppIndex();
      this.buildBundleInfo();

      Row() {
        Toggle({ type: ToggleType.Switch, isOn: this.item.appLiveViewSwitch?.isOn() })
          .selectedColor($r('sys.color.comp_background_emphasize'))
          .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
          .width($r('app.float.toggle_comp_width'))
          .height($r('app.float.toggle_comp_height'))
          .margin({})
          .onChange((isOn) => {
            log.showInfo('Toggle onChange data:%{public}s', isOn);
            if (isOn === this.item.appLiveViewSwitch?.isOn()) {
              return;
            }
            this.item.appLiveViewSwitch?.setState(isOn);
            this.onChange(isOn);
          })
      }
      .align(Alignment.End);
    }
    .constraintSize({
      minHeight: $r('app.float.ntf_setting_live_view_app_item_height')
    })
    .width(ConfigData.WH_100_100)
    .id(`${this.item.appBundleName}_${this.item.appIndex}`);
  }

  async onChange(isOn: boolean) {
    await this.setLiveViewEnable(isOn);
    this.reportClickLiveViewSwitch(isOn);
  }

  private async reportClickLiveViewSwitch(isOn: boolean): Promise<void> {
    try {
      NtfSettingSysEventReporter.reportClickLiveViewSwitch(this.item?.appBundleName, isOn, 'Notification');
    } catch (error) {
      log.error(`ClickLiveViewSwitchReport error: `, error);
    }
  }

  async setLiveViewEnable(isOn: boolean) {
    try {
      log.showInfo(`Set live view enable begin: ${this.item?.appBundleName}, ${this.item?.appUid}, ${isOn}`);
      await notificationManager.setNotificationEnableSlot({
        bundle: this.item?.appBundleName,
        uid: this.item?.appUid
      }, notificationManager.SlotType.LIVE_VIEW, isOn, true);
      log.showInfo(`Set live view enable success: ${this.item?.appBundleName}, ${this.item?.appUid}, ${isOn}`);
    } catch (e) {
      log.error(`Set live view enable failed: ${this.item?.appBundleName}, ${this.item?.appUid}, ${isOn}, error:`, e);
    }
  }

  @Builder
  buildBundleInfo() {
    Column() {
      Text(this.item.appTitle)
        .draggable(false)
        .id(COMPONENT_ID_APP_TITLE)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .maxFontScale(2)
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .margin({
          bottom: $r('app.float.appitem_label_margin_b'),
          left: $r('app.float.page_notice_info_label_margin'),
          right: $r('app.float.page_notice_info_label_margin')
        })
        .constraintSize({
          minHeight: 21
        })
        .accessibilityLevel('no')
    }
    .padding({
      top: $r('app.float.page_notice_title_margin_t'),
      bottom: $r('app.float.page_notice_title_margin_t')
    })
    .layoutWeight(1).alignItems(HorizontalAlign.Start);
  }

  @Builder
  buildIconWithAppIndex() {
    AppIconWithIndexSubIcon({
      appIcon: this.item.appIcon,
      index: this.item.appIndex,
      appIconId: COMPONENT_ID_APP_ICON,
      appIconSize: LengthMetrics.resource($r('app.float.appitem_manage_icon_width')).value
    })
  }
}
