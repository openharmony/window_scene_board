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
import { ScreenLockFloatingTipAdapter } from '../../../../adapter/ScreenLockFloatingTipAdapter';
import { BannerVm } from '../../../../vm/BannerVm';
import { DeviceInfoVm } from '../../../../vm/DeviceInfoVm';
import { EnvVm } from '../../../../vm/EnvVm';
import { ResourceVm } from '../../../../vm/ResourceVm';
import { LiveStyle } from '../../../constants/LiveStyle';
import { ClickNotificationMaintenance } from '../../../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../../../maintenance/StatisticsConstants';
import { SystemUIUseScene } from '../../../../constants/SystemuiConstants';
import { bannerMgr } from '../../../../banner/phone/BannerManager';
import { SceneSessionAdapter } from '../../../../adapter/SceneSessionAdapter';
import { ILiveCardListItemVm } from '../../../interface/ILiveCardListItemVm';
import { LiveCardListItemVm } from '../../../vm/LiveCardListItemVm';
import { LiveNotification } from '../../../model/LiveNotification';
import { LiveHiSysEvent } from '../../../sysEvent/LiveHiSysEvent';

const CARD_SCALE_RATE = 0.9;

@ObservedV2
export class PocketLiveCardListItemVm extends LiveCardListItemVm implements ILiveCardListItemVm {
  protected readonly TAG: string = 'PocketLiveCardListItemVm';

  private envVm = EnvVm.instance;
  private deviceInfoVm = DeviceInfoVm.instance;
  @Trace private itemHeight: number = 0;

  @Computed public get marginBottom(): number {
      return LiveStyle.CARD_LIST_SPACE;
    return LiveStyle.CARD_LIST_SPACE - (this.itemHeight - this.itemHeight * CARD_SCALE_RATE);
  }
  @Computed public get cardWidth(): number {
    return BannerVm.instance.cardListWidth;
  }
  @Computed public get cardScale(): ScaleOptions | undefined {
    return undefined;
  }
  @Computed public get gesture(): GestureGroupHandler {
    return new GestureGroupHandler({
      mode: GestureMode.Exclusive,
      gestures: [new TapGestureHandler({ count: 1 }).onAction(() => this.onClick())]
    });
  };

  public async onLockedSingleClick(): Promise<void> {
    const menuVm = this.vmInjector.getCardMenuVm(this.live);
    this.log.showWarn(`onLockedSingleClick for ${this.live.hashCode}, containerOffsetX: ${this.containerOffsetX}`);
    if (menuVm && this.containerOffsetX) {
      menuVm.reset('self');
      return;
    }
    ScreenLockFloatingTipAdapter.showLiveListTip();
  }

  public async onLockedDoubleClick(): Promise<void> {
    const menuVm = this.vmInjector.getCardMenuVm(this.live);
    this.log.showWarn(`onLockedDoubleClick for ${this.live.hashCode}, containerOffsetX: ${this.containerOffsetX}`);
    if (menuVm && this.containerOffsetX) {
      menuVm.reset('self');
      return;
    }
    ScreenLockFloatingTipAdapter.hideLiveListTip();
    await this.startWantAgent();
  }

  public onSizeChange(size: SizeOptions): void {
    this.itemHeight = size.height as number;
  }

  public async startWantAgent(): Promise<void> {
    ClickNotificationMaintenance.saveInfo({
      data: this.live,
      clickRegion: ClickRegion.NTF_MAIN,
      scene: SystemUIUseScene.LIVE,
    });
    if (await this.tryOpenFloating(this.live)) {
      return;
    }

    let isNeedCollapseCard = false;

    const isStartApp = await this.vmInjector.getStarterVm().startCardWantAgent({
      cardVm: this,
      wantAgent: this.live.wantAgent,
      wantAgentInfo: this.live.wantAgentInfo,
      onStartApp: () => {
        this.vmInjector.getSwitchVm().isCollapsing = true;
        bannerMgr.releasePanelLiveList();
      }
    });
    if (isStartApp) {
      LiveHiSysEvent.reportLiveClickAppEvent(this.live, 5, await SceneSessionAdapter.getIsMidScene());
    }
    if (!isStartApp.start || isNeedCollapseCard) {
      return;
    }
    this.vmInjector.getSwitchVm().hidePanel();
    this.vmInjector.getCapsuleListVm().toggleCapsuleList();
  };

  /**
   *
   */
  protected async tryOpenFloating(live: LiveNotification): Promise<boolean> {
    return super.tryOpenFloating(live);
  }
}