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

import { LiveNotification } from '../model/LiveNotification';
import { LiveItemBaseVm } from './LiveBaseVm';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ILiveCardAuthorizationVm } from '../interface/ILiveCardAuthorizationVm';
import { notificationManager } from '@kit.NotificationKit';
import { LiveCardOtherModel } from '../model/LiveCardOtherModel';
import { LiveStyle } from '../constants/LiveStyle';
import { ResourceVm } from '../../vm/ResourceVm';
import { EnvVm } from '../../vm/EnvVm';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import {
  ClickMaintenanceInfo,
  ClickNotificationErrorCode,
  ClickNotificationMaintenance } from '../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../maintenance/StatisticsConstants';
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { NotificationDataManager } from '../../manager/NotificationDataManager';
import { MetaServiceConnect } from '../../manager/MetaServiceConnect';

const TAG = 'LiveCardAuthorizationVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCardAuthorizationVm extends LiveItemBaseVm implements ILiveCardAuthorizationVm {
  @Trace public isLeftActionPressed: boolean = false;
  @Trace public isRightActionPressed: boolean = false;
  @Trace public isShowAuthorizationZone: boolean = false;

  public showAuthorizationTip: boolean = false;
  public buttonTextOpacity: number = 0.6;
  public buttonTextFontSize: Length = $r('app.float.live_view_card_button_font_size');
  @Computed get buttonTextLineHeight(): Length {
    return ResourceVm.instance.getLiveFontSize($r('app.float.live_view_card_button_line_height'));
  }
  @Computed get buttonHeight(): Length {
    return 2 * ResourceVm.instance.getNumber($r('app.float.live_view_button_margin_top')) +
      ResourceVm.instance.getNumber($r('app.float.live_view_card_tip_line_height')) *
      ResourceVm.instance.getLiveFontScale();
  }
  public textFontSize: Length = $r('app.float.live_view_card_tip_font_size');
  @Computed get maxFontScale(): number {
    return ResourceVm.instance.getLiveFontScale(ResourceVm.DEFAULT_MAX_SCALE);
  }
  @Computed get textLineHeight(): Length {
    return ResourceVm.instance.getLiveFontSize($r('app.float.live_view_card_tip_line_height'));
  }
  @Computed get brightness(): number {
    return EnvVm.instance.isDarkMode ? 1.04 : 0.95;
  }

  @Computed get cardAuthorizationTip(): ResourceStr {
    return (!this.live?.isInstallMetaSer || this.live.isAtomicServiceFromPush) ?
      $r('app.string.meta_service_live_view_authorization_tip') :
      $r('app.string.live_view_authorization_tip');
  }

  constructor(vmInjector: ILiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.isShowAuthorizationZone = (live.card as LiveCardOtherModel).isShowAuthorization;
  }

  get dividerColor(): ResourceColor {
    return $r('sys.color.ohos_id_color_text_primary');
  }

  get dividerOpacity(): number {
    return 0.6;
  }

  get buttonTextFontColor(): ResourceColor {
    return $r('sys.color.ohos_id_color_text_primary');
  }

  get textFontColor(): ResourceColor {
    return LiveStyle.SYS_TEXT_COLOR_SECONDARY;
  }

  @Computed public get isShowAuthorization(): boolean {
    return this.isShowAuthorizationZone && this.showAuthorizationTip;
  }

  // 调用元服务接口，实现未安装实况关闭功能
  public unstallMetaSerciveLiveChange(): void {
    MetaServiceConnect.instance.collectMetaSerciveLiveChange('', this.live.creatorBundleName)
    NotificationDataManager.instance.removeLiveView([this.live]);
  }

  public async onAuthorizationChange(enable: boolean): Promise<void> {
    const bundle = this.live.creatorBundleName;
    const uid = this.live.creatorUid;
    const clickInfo: ClickMaintenanceInfo = {
      data: this.live,
      clickRegion: enable ? ClickRegion.AUTH_ACCEPT : ClickRegion.AUTH_REJECT,
    };
     if (!this.live.isInstallMetaSer) {
      if (enable) {
        this.isShowAuthorizationZone = false
      }else {
        this.unstallMetaSerciveLiveChange()
      }
    } else {
      try {
        log.showInfo(`Authrization begin for ${bundle}, ${uid}, ${enable}`);
        await notificationManager.setNotificationEnableSlot(
          { bundle, uid }, notificationManager.SlotType.LIVE_VIEW, enable, true);
        log.showInfo(`Authrization success for ${bundle}, ${uid}, ${enable}`);
        this.isShowAuthorizationZone = false;
        NotificationDataManager.instance.updateAuthorization(this.live.hashCode);
        ClickNotificationMaintenance.reportClick(undefined, clickInfo);
      } catch (e) {
        log.error(`Authrization faield for ${bundle}, ${uid}, ${enable}:`, e);
        ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.AUTH_FAIL, clickInfo);
      }
      LiveHiSysEvent.reportLiveAcceptButton(this.live, enable, SystemUIUseScene.DROPDOWN);
    }
  }

  public onTouchEvent(event: TouchEvent, button: string): void {
    if (!event) {
      return;
    }
    if (TouchType.Down === event.type) {
      if (button === 'left') {
        this.isLeftActionPressed = true;
      } else {
        this.isRightActionPressed = true;
      }
    } else if (TouchType.Move == event.type) {
      if (!this.isTouchInArea(event.touches[0], event.target.area)) {
        if (button === 'left') {
          this.isLeftActionPressed = false;
        } else {
          this.isRightActionPressed = false;
        }
      }
    } else {
      this.isLeftActionPressed = false;
      this.isRightActionPressed = false;
    }
    log.showInfo(`Touch Authorization ${this.isLeftActionPressed},  ${this.isRightActionPressed}`)
  }

  private isTouchInArea(touch: TouchObject, area: Area): boolean {
    return touch.x >= 0 && touch.x <= area.width && touch.y >= 0 && touch.y <= area.height;
  }
}