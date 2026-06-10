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
import { ILiveVmInjector } from '../../interface/ILiveVmInjector';
import { LiveVmInjector } from '../../LiveVmInjector';
import { ILiveOverlayVm } from '../../interface/ILiveOverlayVm';
import { LiveOverlayVm } from '../../vm/LiveOverlayVm';
import { LiveNotification } from '../../model/LiveNotification';
import { PocketLiveVmFactory } from './PocketLiveVmFactory';
import { ILiveCapsuleListVm } from '../../interface/ILiveCapsuleListVm';
import { PocketLiveCapsuleListVm } from './vm/PocketLiveCapsuleListVm';
import { PocketLiveCardListVm } from './vm/PocketLiveCardListVm';
import { ILiveCardListVm } from '../../interface/ILiveCardListVm';
import { PocketLiveCardListItemVm } from './vm/PocketLiveCardListItemVm';
import { ILiveCardListItemVm } from '../../interface/ILiveCardListItemVm';
import { ILiveCardSystemVm } from '../../interface/ILiveCardSystemVm';
import { PocketLiveCardSystemVm } from './vm/PocketLiveCardSystemVm';
import { ILiveCardOtherVm } from '../../interface/ILiveCardOtherVm';
import { PocketLiveCardOtherVm } from './vm/PocketLiveCardOtherVm';
import { ILiveCardNavigationVm } from '../../interface/ILiveCardNavigationVm';
import { PocketLiveCardNavigationVm } from './vm/PocketLiveCardNavigationVm';
import { ILiveCapsuleMarqueeVm } from '../../interface/ILiveCapsuleMarqueeVm';
import { PocketLiveCapsuleMarqueeVm } from './vm/PocketLiveCapsuleMarqueeVm';
import { ILiveCardMediaPlayerVm } from '../../interface/ILiveCardMediaPlayerVm';
import { PocketLiveCardMediaPlayerVm } from './vm/PocketLiveCardMediaPlayerVm';
import { ILiveSwitchVm } from '../../interface/ILiveSwitchVm';
import { PocketLiveSwitchVm } from './vm/PocketLiveSwitchVm';
import { ILiveHeadsUpCommonCardVm } from '../../interface/ILiveHeadsUpCommonCardVm';
import { PocketLiveHeadsUpCommonCardVm } from './vm/PocketLiveHeadsUpCommonCardVm';
import { ILiveRemindVm } from '../../interface/ILiveRemindVm';
import { PocketLiveRemindVm } from './vm/PocketLiveRemindVm';
import { ILiveHeadsUpVm } from '../../interface/ILiveHeadsUpVm';
import { PocketLiveHeadsUpVm } from './vm/PocketLiveHeadsUpVm';
import { PocketLiveStarterVm } from './vm/PocketLiveStarterVm';
import { ILiveStarterVm } from '../../interface/ILiveStarterVm';

export class PocketLiveVmInjector extends LiveVmInjector implements ILiveVmInjector {
  protected liveVmFactory = new PocketLiveVmFactory();

  public getOverlayVm(): ILiveOverlayVm {
    return this.getVm(LiveOverlayVm.name, () => new LiveOverlayVm(this));
  }

  public getCapsuleListVm(): ILiveCapsuleListVm {
    return this.getVm(PocketLiveCapsuleListVm.name, () => new PocketLiveCapsuleListVm(this));
  }

  public getCardListVm(): ILiveCardListVm {
    return this.getVm(PocketLiveCardListVm.name, () => new PocketLiveCardListVm(this));
  }

  public getCardListItemVm(live: LiveNotification): ILiveCardListItemVm {
    return this.getVm(this.getKey(PocketLiveCardListItemVm, live), () => new PocketLiveCardListItemVm(this, live));
  }

  public getCardSystemVm(live: LiveNotification): ILiveCardSystemVm {
    return this.getVm(this.getKey(PocketLiveCardSystemVm, live), () => new PocketLiveCardSystemVm(this, live));
  }

  public getCardOtherVm(live: LiveNotification): ILiveCardOtherVm {
    return this.getVm(this.getKey(PocketLiveCardOtherVm, live), () => new PocketLiveCardOtherVm(this, live));
  }

  public getCardNavigationVm(live: LiveNotification): ILiveCardNavigationVm {
    return this.getVm(this.getKey(PocketLiveCardNavigationVm, live), () => new PocketLiveCardNavigationVm(this, live));
  }

  public getCardMediaPlayerVm(live: LiveNotification): ILiveCardMediaPlayerVm {
    return this.getVm(this.getKey(PocketLiveCardMediaPlayerVm, live), () => new PocketLiveCardMediaPlayerVm(this, live))
  }

  public getCapsuleMarqueeVm(live: LiveNotification): ILiveCapsuleMarqueeVm {
    return this.getVm(this.getKey(PocketLiveCapsuleMarqueeVm, live), () => new PocketLiveCapsuleMarqueeVm(this, live));
  }

  public getSwitchVm(): ILiveSwitchVm {
    return this.getVm(PocketLiveSwitchVm.name, () => new PocketLiveSwitchVm(this));
  }

  public getLiveHeadsUpCommonCardVm(): ILiveHeadsUpCommonCardVm {
    return this.getVm(PocketLiveHeadsUpCommonCardVm.name, () => new PocketLiveHeadsUpCommonCardVm(this));
  }

  public getLiveRemindVm(): ILiveRemindVm {
    return this.getVm(PocketLiveRemindVm.name, () => new PocketLiveRemindVm(this));
  }

  public getLiveHeadsUpVm(): ILiveHeadsUpVm {
    return this.getVm(PocketLiveHeadsUpVm.name, () => new PocketLiveHeadsUpVm(this));
  }

  public getStarterVm(): ILiveStarterVm {
    return this.getVm(PocketLiveStarterVm.name, () => new PocketLiveStarterVm(this));
  }
}