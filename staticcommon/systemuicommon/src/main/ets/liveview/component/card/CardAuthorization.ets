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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { LiveUseScene, LiveViewCommonConstants } from '../../common/LiveConstants';
import { LiveViewData } from '../../data/LiveViewData';
import notificationManager from '@ohos.notificationManager';
import { DarkModeState, StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { NotificationSysEventReporter } from '../../../utils/NotificationSysEventReporter';
import { fontScaleManager } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleManager';
import { FontScaleState } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleState';
import { immersiveKgMgr } from '../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { NotificationType } from '../../../constants/NotificationType';
import { CardButtonComponent } from './SystemComponent/CardButtonComponent';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '../../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../../maintenance/StatisticsConstants';
import { OuterHomeVm } from '../../../../ets/vm/OuterHomeVm';
import { SystemUICcmConfig } from '../../../utils/SystemUICcmConfig';
import { NotificationDataManager } from '../../../manager/NotificationDataManager';
import { messageChannel } from '../../../messageChannel/MessageChannel';
import { MetaServiceConnect } from '../../../manager/MetaServiceConnect';
import { EvtBus } from '@ohos/frameworkwrapper';
import { NotificationListenerEntryCancelEvent } from '../../../event/NotificationEvent';
import { OtherBaseTemplate } from '../../../TsIndex';
const TAG = LiveViewCommonConstants.LOG_PREFIX + 'CardAuthorization';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const AUTH_TITLE_OPACITY_AOD = 0.4;
const AUTH_DIVIDER_OPACITY_AOD = 0.1;
const AUTH_DIVIDER_OPACITY_NORMAL = 0.6;
/**
 * 卡片授权提示
 */
@Component
export struct CardAuthorization {
  @ObjectLink dataTemplate: OtherBaseTemplate;

  @ObjectLink baseData: LiveViewData;

  @State darkModeState: DarkModeState = baseStateMgr.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @State outerHomeVm: OuterHomeVm = OuterHomeVm.get();

  useScene: LiveUseScene = LiveUseScene.SCENE_NTF_CENTER;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Column() {
      Text($r('app.string.live_view_authorization_tip'))
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .opacity(1)
        .fontSize(this.fontScaleState.getScaleSize($r('app.float.live_view_card_tip_font_size'),
          this.outerHomeVm.isIgnoreFontScaleState))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Center)
        .lineHeight(this.fontScaleState.getScaleSize($r('app.float.live_view_card_tip_line_height'),
          this.outerHomeVm.isIgnoreFontScaleState))

      this.buildButtonLayout();
    }
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .padding({
        top: $r('app.float.live_view_tip_padding_top')
      })
      .brightness((this.darkModeState.isDarkMode ? 1.04 : 0.95))
      .backgroundColor(undefined)
      // 点击卡片授权提示区域不跳转至应用
      .onClick(() => {})
  }

  @Builder
  buildButtonLayout() {
    Row() {
      CardButtonComponent({
        text: $r('app.string.live_view_authorization_reject'),
        onClickAction: () => {
          this.onAuthorization(false);
        }
      });

      Divider()
        .vertical(true)
        .height($r('app.float.live_view_card_button_line_height_vp'))
        .color($r('sys.color.ohos_id_color_text_primary'))
        .opacity(AUTH_DIVIDER_OPACITY_NORMAL)

      CardButtonComponent({
        text: $r('app.string.live_view_authorization_confirm'),
        onClickAction: () => {
          this.onAuthorization(true);
        }
      });
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(ResUtils.getNumber($r('app.float.live_view_card_tip_line_height')) *
    this.fontScaleState.getFontScale(this.outerHomeVm.isIgnoreFontScaleState) + 2 * ResUtils.getNumber($r('app.float.live_view_button_margin_top')))
  }

  async onAuthorization(enabled: boolean): Promise<void> {
    if (this.dataTemplate.isInstallMetaSer) {
      await this.doOnAuthorization(enabled);
    } else {
      if (enabled) {
        this.baseData.showAuthorization = false;
      } else {
        this.closeUninstallMetaServiceLive()
      }
    }
  }

  async doOnAuthorization(enabled: boolean): Promise<void> {
    const bundle = this.baseData.creatorBundleName;
    const uid = this.baseData.creatorUid;
    try {
      log.showInfo(`Authrization begin for ${bundle}, ${uid}, ${enabled}`);
      await notificationManager.setNotificationEnableSlot(
        { bundle, uid }, notificationManager.SlotType.LIVE_VIEW, enabled, true);
      log.showInfo(`Authrization success for ${bundle}, ${uid}, ${enabled}`);
      this.baseData.showAuthorization = false;
      if (SystemUICcmConfig.instance.isEnabledLive2) {
        NotificationDataManager.instance.updateAuthorization(this.baseData.hashCode);
        messageChannel.sendMessage('updateAuthorization', this.baseData.hashCode);
      }
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.AUTH_FINISH, {
        data: this.baseData,
        clickRegion: enabled ? ClickRegion.AUTH_ACCEPT : ClickRegion.AUTH_REJECT,
      });
      NotificationSysEventReporter.liveViewAcceptButton({
        CREATOR_BUNDLE_NAME: this.baseData?.creatorBundleName,
        NOTIFICATION_ID: this.baseData?.id,
        ACCEPT: enabled ? 1 : 0,
        DISPLAY_SCENE: this.useScene === LiveUseScene.SCENE_NTF_CENTER ? 4 : 2
      });
    } catch (e) {
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.AUTH_FAIL, {
        data: this.baseData,
        clickRegion: enabled ? ClickRegion.AUTH_ACCEPT : ClickRegion.AUTH_REJECT,
      });
      log.error(`Authrization faield for ${bundle}, ${uid}, ${enabled}:`, e);
    }
  }

  // 调用元服务接口，实现未安装实况关闭功能
  private closeUninstallMetaServiceLive(): void {
    MetaServiceConnect.instance.collectMetaSerciveLiveChange('', this.baseData.creatorBundleName)
    this.deleteUninstallMetaServiceLive()
  }

  // 发送事件执行删除通知操作
  private deleteUninstallMetaServiceLive() {
    EvtBus.post(NotificationListenerEntryCancelEvent,
      new NotificationListenerEntryCancelEvent(this.baseData.hashCode, this.baseData.creatorUserId));
  }
}
