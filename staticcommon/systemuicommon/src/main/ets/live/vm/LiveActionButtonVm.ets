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

import { BannerPanelType } from '../../banner/common/info/BannerState';
import { bannerMgr } from '../../banner/phone/BannerManager';
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { ClickNotificationMaintenance } from '../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../maintenance/StatisticsConstants';
import { NotificationAction } from '../../model/NotificationContent';
import { ResourceVm } from '../../vm/ResourceVm';
import { ILiveActionButtonVm } from '../interface/ILiveActionButtonVm';
import { LiveCardOtherModel } from '../model/LiveCardOtherModel';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { LiveItemBaseVm } from './LiveBaseVm';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveCardFloatingWantAgentParams } from '../interface/ILiveCardFloatingVm';
import { sharedData } from '../../model/SendableData';

/**
 * 实况关联服务按钮VM
 */
@ObservedV2
export class LiveActionButtonVm extends LiveItemBaseVm implements ILiveActionButtonVm {
  protected readonly TAG: string = 'LiveActionButtonVm';
  public backgroundColor: ResourceColor = $r('app.color.theme_ntf_phone_action_bg_color');
  @Trace public backgroundColors: Array<ResourceColor> = [];
  public fontSize: Length = $r('sys.float.ohos_id_text_size_sub_title3');

  get fontColor(): ResourceColor {
    return $r('sys.color.ohos_id_color_text_secondary_dark');
  }

  @Computed
  get card(): LiveCardOtherModel {
    return this.live.card as LiveCardOtherModel;
  }

  @Computed
  get actionButtons(): Array<NotificationAction> {
    if (this.live.card.isSystemCard()) {
      return this.live.actionButtons ?? [];
    }
    return this.card.serviceButtons;
  }

  @Computed
  get isShowActionButtons(): boolean {
    return this.actionButtons.length !== 0;
  }

  @Computed
  get lineHeight(): Length {
    return ResourceVm.instance.getLiveFontSize($r('app.float.live_view_card_text_line_height'));
  }

  @Computed
  get dividerFgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector?.getColorVm()?.dividerFgBrightness;
  }

  public getDividerVisible(): Visibility {
    for (let button of this.actionButtons) {
      if (button.actionTitle) {
        return Visibility.Visible;
      }
    }
    return Visibility.None;
  }

  handleTouchEvent(event: TouchEvent, index: number): void {
    if (!event) {
      return;
    }
    if (TouchType.Down === event.type) {
      this.backgroundColors[index] = $r('sys.color.ohos_id_color_hover');
    } else if (TouchType.Move == event.type) {
      if (!this.isTouchInArea(event.touches[0], event.target.area)) {
        this.backgroundColors = [];
      }
    } else {
      this.backgroundColors = [];
    }
  }

  private isTouchInArea(touch: TouchObject, area: Area): boolean {
    return touch.x >= 0 && touch.x <= area.width && touch.y >= 0 && touch.y <= area.height;
  }

  hasClickEvent(index: number): boolean {
    if (this.actionButtons[index]?.wantAgent) {
      return true;
    }
    if (this.live.isCollaNotification) {
      return true;
    }
    return false;
  }

  public handleClickEvent = async (index: number) => {
    const menuVm = this.vmInjector.getCardMenuVm(this.live);
    const itemVm = this.vmInjector.getCardListItemVm(this.live);
    if (menuVm && itemVm.containerOffsetX) {
      menuVm.reset('self');
      return;
    }
    if (!this.actionButtons[index]?.wantAgent && !this.live.isCollaNotification) {
      return;
    }
    ClickNotificationMaintenance.saveInfo({
      data: this.live,
      clickRegion: ClickRegion.SERVICE_BUTTON,
      scene: SystemUIUseScene.LIVE,
      buttonName: this.actionButtons[index]?.actionTitle,
    });
    this.log.showInfo(`triggerServiceButtonWant for ${this.live.hashCode}_serviceButton_${index}`);
    const isHeadsUp = bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP);
    LiveHiSysEvent.reportServiceButtonClickEvent(this.live, index, isHeadsUp ? 3 : 5);

    const floatingVm = this.vmInjector.getCardFloatingVm(this.live);
    const params: LiveCardFloatingWantAgentParams = { wantAgent: this.actionButtons[index]?.wantAgent };
    if (await floatingVm.canOpenFloating(params)) {
      sharedData.isExecuting = true;
      floatingVm.startFloatingForClick(params);
      floatingVm.runCardHideAnimation(() => {
        this.vmInjector.getCardListVm().listOpacity = 0;
      }).then(() => {
        this.log.showInfo(`Start floating app ${this.live.key} end`);
        sharedData.isExecuting = false;
        this.vmInjector.getSwitchVm().hidePanel();
        this.vmInjector.getCapsuleListVm().toggleCapsuleList();
      });
      return;
    }

    const isStartApp = await this.vmInjector.getStarterVm().startCardWantAgent({
      wantAgent: this.actionButtons[index]?.wantAgent,
      cardVm: this.vmInjector.getCardListItemVm(this.live),
      onStartApp: () => {
        bannerMgr.releasePanelLiveList();
        bannerMgr.requestPanelCapsuleList();
      },
      operationInfo: {
        operationType: LiveStyle.DISTRIBUTE_OPERATION_BUTTON_JUMP,
        buttonIndex: index + 1,
      }
    });

    if (!isStartApp.start) {
      return;
    }
    LiveHiSysEvent.reportLiveClickAppEvent(this.live, isHeadsUp ? 3 : 5);
    this.vmInjector.getSwitchVm().hidePanel();
  }
}