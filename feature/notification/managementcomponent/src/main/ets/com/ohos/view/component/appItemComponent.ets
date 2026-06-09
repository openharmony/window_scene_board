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

import ConfigData from '../../common/constants';
import { LogDomain, LogHelper, LogWithHa } from '../../common/BasicCommon';
import { AppItem, AppLstComponentViewModel } from '../../vm/appLstComponentViewModel';
import { LengthMetrics } from '@ohos.arkui.node';
import { AppIconWithIndexSubIcon, EnterpriseConfig } from '../../common/BasicUiCommon';
import { NtfSettingRtlUtil } from '../../common/NtfSettingRtlUtil';
import { DeviceHelper } from '../../common/DeviceHelper';
import { NtfSettingSysEventReporter } from '../../common/NtfSettingSysEventReporter';
import { notificationManager } from '@kit.NotificationKit';
import { notificationSettingManager } from '../../manager/NotificationSettingManager';
import { SettingExceptionCode } from '../../common/SettingExceptionCode';

const TAG = 'ManagementComponent-AppItemComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const COMPONENT_ID_APP_ICON = TAG + '_Image_appIcon';
const COMPONENT_ID_APP_TITLE = TAG + '_Text_appTitle';
const COMPONENT_ID_NOTICE = TAG + '_Text_notice';
const COMPONENT_ID_APP_ARROW = TAG + '_Image_appArrow';
const APP_ITEM_ROW_HEIGHT = '72vp';
const META_SERVICE_ITEM_ROW_HEIGHT = '64vp';
const APP_LIST_BADGE_ICON_SIZE: number = 48;
const DEFAULT_BADGE_ICON_SIZE: number = 54;

const appIndexResourceMap: Map<number, Resource> = new Map([
  [1, $r('app.media.app_icon_clone_index_1')],
  [2, $r('app.media.app_icon_clone_index_2')],
  [3, $r('app.media.app_icon_clone_index_3')],
  [4, $r('app.media.app_icon_clone_index_4')],
  [5, $r('app.media.app_icon_clone_index_5')],
]);

@Component
export default struct AppItemComponent {
  @ObjectLink item: AppItem;

  /**
   * 权限描述默认值,先赋值空字符串占位，防止二次更新时抖动
   */
  @State itemDescribeDefaultText: Resource | string = ' ';
  @Prop isHover: boolean = false;
  private model: AppLstComponentViewModel = AppLstComponentViewModel.get();
  private isVisible: boolean = false;
  private appItemClick: (item: AppItem) => void = (item: AppItem) => {
  };

  build() {
    Flex({ alignItems: ItemAlign.Center }) {
      Row() {
        this.buildIconWithAppIndex()
        this.buildBundleInfo()
        Row() {
          this.buildItemRightComponentInAppList();
        }
        .align(Alignment.End);

        if (!this.item.isMetaService) {
          Divider()
            .vertical(true)
            .width($r('app.float.divider_stroke_width'))
            .height($r('app.float.app_item_divider_height'))
            .margin({ start: LengthMetrics.resource($r('app.float.app_item_divider_margin_left')) })
        }
      }
      .borderRadius($r('app.float.hovered_border_radius'))
      .stateStyles({
        focused: {
          .backgroundColor($r('sys.color.ohos_id_color_hover'))
          .border({ width: '2vp', color: $r('sys.color.interactive_focus') })
        },
        pressed: {
          .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
          .border({ width: 0 })
        },
        normal: {
          .backgroundColor(this.isHover ? $r('sys.color.ohos_id_color_hover') : Color.Transparent)
          .border({ width: 0 })
        }
      })
      .onClick(() => this.appItemClick(this.item))
      .constraintSize({
        minHeight: this.item.isMetaService ? META_SERVICE_ITEM_ROW_HEIGHT : APP_ITEM_ROW_HEIGHT,
      })
      .padding({
        start: LengthMetrics.resource($r('app.float.hover_Comp_margin_padding')),
        end: !this.item.isMetaService ? LengthMetrics.vp(0) :
        LengthMetrics.resource($r('app.float.hover_Comp_margin_padding'))
      })
      .layoutWeight(1)

      if (!this.item.isMetaService) {
        this.buildEnableToggle();
      }
    }
    .constraintSize({
      minHeight: this.item.isMetaService ? META_SERVICE_ITEM_ROW_HEIGHT : APP_ITEM_ROW_HEIGHT,
    })
    .width(ConfigData.WH_100_100)
    .id(`${this.item.appBundleName}_${this.item.appIndex}`)
  }

  @Builder
  buildItemRightComponentInAppList() {
    Image($r('app.media.ic_settings_arrow'))
      .draggable(false)
      .id(COMPONENT_ID_APP_ARROW)
      .width($r('app.float.itemComp_image_width'))
      .height($r('app.float.itemComp_image_height'))
      .fillColor($r('sys.color.ohos_id_color_fourth'))
      .visibility(Visibility.Visible)
      .rotate({ z: 1, angle: NtfSettingRtlUtil.getSystemRTL() ? 180 : 0})
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
          bottom: LengthMetrics.resource($r('app.float.appitem_label_margin_b')),
          start: LengthMetrics.resource($r('app.float.page_notice_info_label_margin')),
          end: LengthMetrics.resource($r('app.float.page_notice_info_label_margin'))
        })
        .constraintSize({
          minHeight: 21
        })
      if (!this.item.isMetaService) {
        Text(EnterpriseConfig.isHideBundle(this.item.appBundleName) ?
        this.itemDescribeDefaultText :
          (this.item.appSwitch ? this.item.itemDescribeText : this.itemDescribeDefaultText))
          .draggable(false)
          .id(COMPONENT_ID_NOTICE)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(2)
          .fontWeight(FontWeight.Regular)
          .textAlign(TextAlign.Start)
          .visibility(Visibility.Visible)
          .margin({
            start: LengthMetrics.resource($r('app.float.page_notice_info_label_margin'))
          })
          .constraintSize({
            minHeight: 19
          })
      }
    }
    .padding({
      top: $r('app.float.page_notice_title_margin_t'),
      bottom: $r('app.float.page_notice_title_margin_t')
    })
    .layoutWeight(1).alignItems(HorizontalAlign.Start)
  }

  @Builder buildIconWithAppIndex() {
    AppIconWithIndexSubIcon({
      appIcon: this.item.appIcon,
      index: this.item.appIndex,
      appIconId: COMPONENT_ID_APP_ICON,
      compMargin: undefined,
      appIconSize: LengthMetrics.resource($r('app.float.appitem_manage_icon_width')).value,
      needShowBadgeIcon: false,
    })
  }

  @Builder
  buildEnableToggle() {
    if (this.item.appSwitch !== undefined) {
      Toggle({
        type: ToggleType.Switch,
        isOn: EnterpriseConfig.isHideBundle(this.item.appBundleName) ? false : this.item.appSwitch
      })
        .enabled(this.getIsEnableChange())
        .selectedColor($r('sys.color.comp_background_emphasize'))
        .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .width($r('app.float.toggle_comp_width'))
        .height($r('app.float.toggle_comp_height'))
        .onChange((isOn) => this.allowStateChanged(isOn))
        .hoverEffect(DeviceHelper.isPC() ? HoverEffect.Auto : HoverEffect.None)
        .hitTestBehavior(HitTestMode.Block)
        .onVisibleAreaChange([0, 1], (isVisible: boolean, currentRatio: number) => this.isVisible = isVisible)
        .margin({
          start: LengthMetrics.resource($r('app.float.app_item_divider_margin_right')),
          end: LengthMetrics.resource($r('app.float.hover_Comp_margin_padding'))
        })
    }
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.querySlotInfo();
  }

  async querySlotInfo() {
    if (this.item.appSwitch === undefined) {
      await this.model.querySlotAndBadgeInfo(this.item.appUid);
    }
    this.itemDescribeDefaultText = $r('app.string.notification_tip_close');
  }

  private allowStateChanged(isOn: boolean): void {
    if (this.isVisible) {
      this.reportMgmtOperate(isOn);
    }
    this.setAllowState(isOn);
    if (isOn === false) {
      this.setPinTopState();
    }
  }

  private async reportMgmtOperate(isOn: boolean): Promise<void> {
    NtfSettingSysEventReporter.notificationSettingAppManagement({
      CREATOR_BUNDLE_NAME: this.item.appBundleName,
      SWITCH_ID: 'ALLOWED_BATCH',
      SWITCH_STATUS: isOn ? 0 : 1
    });
  }

  private async setAllowState(isOn: boolean): Promise<void> {
    try {
      log.showInfo(`SetAllowState to ${isOn} start.`);
      notificationManager.setNotificationEnable({ bundle: this.item.appBundleName, uid: this.item.appUid }, isOn);
    } catch (e) {
      LogWithHa.error(log, `SetAllowState to ${isOn} error by ${e.code}`, SettingExceptionCode.SET_NTF_SWITCH_FAIL, e,
        TAG);
    }
  }

  private async setPinTopState(): Promise<void> {
    try {
      log.showInfo('SetPinTopState to false start.')
      notificationSettingManager.setPinTopState(this.item.appUid, false)
    } catch (e) {
      LogWithHa.error(log, `SetPinTopState to false error by ${e.code}`, SettingExceptionCode.SET_PIN_TOP_STATE_FAIL, e,
        TAG);
    }
  }

  private getIsEnableChange(): boolean {
    if (EnterpriseConfig.isHideBundle(this.item.appBundleName)) {
      return false;
    }
    if (!DeviceHelper.isPC()) {
      return true;
    }
    const CLOCK_BUNDLE = 'com.ohos.clock';
    // PC时钟应用定制，通知使能开关置灰开启后不可关闭,如默认关闭也能打开
    return this.item.appBundleName !== CLOCK_BUNDLE || !this.item.appSwitch;
  }
}
