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

import { LengthMetrics } from '@ohos.arkui.node';
import { DeviceHelper, EvtBus } from '@ohos/managementcomponent';
import {
  LogDomain,
  LogHelper,
  LogWithHa,
  NotificationConfigEvent
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { PageConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import lazy { HiDfxEventUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/HiDfxEventUtil';
import lazy {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { SettingExceptionCode } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SettingExceptionCode';
import { NtfSettingJumpEvent as JumpEvt } from '@ohos/managementcomponent/src/main/ets/com/ohos/event/NtfSettingEvent';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import ItemComponent from '@ohos/managementcomponent/src/main/ets/com/ohos/view/component/itemComponent';
import {
  getDistributedDeviceList
} from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubNotificationDistribution';
import NotificationDistributeComponent from './NotificationDistributeComponent';

const TAG = 'NotificationManagement-Main-SettingsComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const COMPONENT_ID_MANAGER = TAG + '_Text_manager';
const ENTER_PAGE = 1;
const LIVE_VIEW_TITLE_CLICKED = 1;

// 通知和状态栏页面，点击动态加载事件延迟发送，避免无按压效果问题
const DELAY_POST_DYNAMIC_IMPORT_EVENT = 5;

/* 全场景开关条目出现事件的key */
const NTF_DISTRIBUTION_BUTTON_EVENT = 'notification.event.DISTRIBUTED_DEVICE_TYPES_CHANGE';

/**
 * 通知和状态栏导航栏，即'通知和状态'页面中，标题栏到应用列表之间的内容
 */
@Component
export struct NavRouterComponents {
  @State statusBarTitle: Resource = $r('app.string.status_bar_title');
  @State liveViewTitle: Resource = $r('app.string.live_view_title');
  @State moreNtfSettingTitle: Resource = $r('app.string.more_ntf_setting');
  @Provide itemHoverIdx: number = -1;
  @State isPcImportLoaded: boolean = false;
  @BuilderParam pcBannerSettingBuilder: () => void;
  @BuilderParam pcAllowNtfFromPhoneSettingBuilder: () => void;
  @Consume('pageInfos') pageInfos: NavPathStack;
  /**
   * 是否展示协同开关
   */
  @State isDistributionSetBefore: boolean = false;

  aboutToAppear(): void {
    if (DeviceHelper.isPC()) {
      this.initPcModules();
    }
    this.hasDistributionSet().then(result => {
      this.isDistributionSetBefore = result;
    });
    notificationSettingManager.subscribeDistributionChangeEvent(this.onDistributionButtonChange);
  }

  aboutToDisappear(): void {
    log.showInfo(`NavRouterComponents aboutToDisappear`);
    notificationSettingManager.unsubscribeChangeEvent(this.onDistributionButtonChange);
  }

  async hasDistributionSet(): Promise<boolean> {
    try {
      const result = await getDistributedDeviceList();
      log.showInfo(`first distribute, ${result.length}`)
      return result.length !== 0;
    } catch (e) {
      LogWithHa.error(log, `get distribution state error ${e}`,
        SettingExceptionCode.GET_FIRST_DISTRIBUTION_STATE_FAIL, e);
      return false;
    }
  }

  private onDistributionButtonChange = (event: NotificationConfigEvent): void => {
    if (event[0] === NTF_DISTRIBUTION_BUTTON_EVENT) {
      this.isDistributionSetBefore = true;
    }
  }

  build() {
    Column() {
      if (!DeviceHelper.isPC()) {
        List() {
          this.buildStatusBarAndNtfSetting()
        }
        .divider({
          strokeWidth: '1px',
          color: $r('sys.color.comp_divider'),
          startMargin: $r('app.float.hover_Comp_margin_padding'),
          endMargin: $r('app.float.hover_item_padding_or_margin')
        })
        .width('100%')
        .backgroundColor($r('sys.color.comp_background_list_card'))
        .borderRadius($r('sys.float.corner_radius_level10'))
        .padding({
          left: $r('app.float.hover_item_padding_or_margin'),
          right: $r('app.float.hover_item_padding_or_margin'),
          top: $r('app.float.hover_item_padding_or_margin'),
          bottom: $r('app.float.hover_item_padding_or_margin')
        })
      } else if (this.isPcImportLoaded) {
        this.pcBannerSettingBuilder();

        if (this.isDistributionSetBefore) {
          Column() {
            this.pcAllowNtfFromPhoneSettingBuilder();
          }
          .border({
            color: $r('app.color.card_panel_bg'),
            radius: $r('app.float.mgmt_app_item_icon_radius')
          })
          .backgroundColor($r('app.color.card_panel_bg'))
          .margin({ top: $r('app.float.page_notice_title_margin_t') })
        }
      }
      this.buildNtfMgmtLabel()
    }
  }

  @Builder buildListItem(title: Resource, index: number, callback: () => void) {
    ListItem() {
      ItemComponent({ title, value: '' })
    }
    .borderRadius($r('sys.float.corner_radius_level8'))
    .stateStyles({
      focused: {
        .backgroundColor($r('sys.color.ohos_id_color_hover'))
      },
      pressed: {
        .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
      },
      normal: {
        .backgroundColor(this.itemHoverIdx === index ? $r('sys.color.ohos_id_color_hover') : Color.Transparent)
      }
    })
    .constraintSize({ minHeight: $r('app.float.itemComp_height') })
    .onHover((isHover?: boolean) => {
      if (isHover !== undefined) {
        this.itemHoverIdx = isHover ? index : -1;
      }
    })
    .onClick(callback)
  }

  @Builder
  buildStatusBarAndNtfSetting() {
    this.buildListItem(this.statusBarTitle, 0, () => {
      log.showInfo('StatusBar click');
      this.statusBarClickReport();
      this.delayJump(PageConstants.STATUS_BAR_SETTING_NAME);
    })

    if (!DeviceHelper.isPC()) {
      this.buildListItem(this.liveViewTitle, 1, () => {
        log.showInfo('LiveViewSetting click');
        this.liveViewReport();
        this.delayJump(PageConstants.NTF_LIVE_VIEW_SWITCH_PAGE_NAME);
      })
      this.buildListItem(this.moreNtfSettingTitle, 2, () => {
        log.showInfo('MoreNtfSetting click');
        this.ntfMoreSettingClickReport();
        this.delayJump(PageConstants.NTF_MORE_SETTING_NAME);
      })
    }
  }

  private delayJump(pageName: string): void {
    setTimeout(() => {
      this.setFromNtfAndStatusBar();
      EvtBus.post(JumpEvt, new JumpEvt(JumpEvt.PAGE_JUMP, pageName));
    }, DELAY_POST_DYNAMIC_IMPORT_EVENT);
  }

  /**
   * 点击场景肯定是从通知中心过来的
   */
  private setFromNtfAndStatusBar(): void {
    const pageContext = PageStorages.getPageContext();
    if (pageContext) {
      pageContext.isFromHome = true;
    }
  }

  /**
   * 通知管理Label
   */
  @Builder
  private buildNtfMgmtLabel() {
    Row() {
      Text($r('app.string.notifications'))
        .draggable(false)
        .id(COMPONENT_ID_MANAGER)
        .fontColor($r('app.color.app_color_text_secondary'))
        .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
        .maxFontScale(2)
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi-Medium');
    }
    .alignItems(VerticalAlign.Bottom)
    .width('100%')
    .constraintSize({
      minHeight: $r('app.float.page_phrases_height')
    })
    .padding({ start: LengthMetrics.resource($r('sys.float.ohos_id_default_padding_start')), bottom: LengthMetrics.vp(8) })
  }

  private async liveViewReport(): Promise<void> {
    try {
      NtfSettingSysEventReporter.reportNtfSettingModuleClickEvent(LIVE_VIEW_TITLE_CLICKED);
    } catch (error) {
      log.error(`liveViewClickReport error: `, error);
    }
  }

  private async statusBarClickReport(): Promise<void> {
    try {
      HiDfxEventUtil.reportNotificationManagementStatusBar(ENTER_PAGE);
      NtfSettingSysEventReporter.notificationSettingStatusBar();
    } catch (error) {
      log.error(`statusBarClickReport error: `, error);
    }
  }

  private async ntfMoreSettingClickReport(): Promise<void> {
    try {
      NtfSettingSysEventReporter.notificationMoreSetting();
    } catch (error) {
      log.error(`ntfMoreSettingClickReport error: `, error);
    }
  }

  private async initPcModules(): Promise<void> {
    try {
      // 设置横幅通知
      const mod = await import('./NtfBannnerNotDisturbPc');
      this.pcBannerSettingBuilder = mod.buildNtfBannerNotDisturb;

      // 设置-允许来自手机的通知
      const mode = await import('./NtfAllowFromPhoneComponentPc');
      this.pcAllowNtfFromPhoneSettingBuilder = mode.buildAllowNtfFromPhonePc;

      this.isPcImportLoaded = true;
      log.showInfo('Init lazy PC success');
    } catch (e) {
      log.error('Init lazy PC error:', e);
    }
  }
}