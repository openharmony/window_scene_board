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
import { NotificationBannerVm } from './NotificationBannerVm';
import { NotificationCardFloatingVm } from '../../../viewmodel/NotificationCardFloatingVm';
import { BannerNotificationStarterVm } from './BannerNotificationStarterVm';
import { NotificationNormalBannerVm } from './BannerNotificationNormalVm';
import { NotificationTimeVm } from '../../../viewmodel/NotificationTimeVm';
import { NotificationBannerCardVm } from './NotificationBannerCardVm';
import { NotificationBannerSwipeVm } from './NotificationBannerSwipeVm';
import { NotificationActionButtonBannerVm } from './NotificationActionButtonBannerVm';
import { NotificationVerticalSwipeVm } from './NotificationVerticalSwipeVm';
import { NotificationPanelVm } from '../../../viewmodel/NotificationPanelVm';
import { NotificationPrivacyVm } from '../../../viewmodel/NotificationPrivacyVm';
import {
  INotificationCardFloatingVm,
  INotificationImmersiveVm,
  INotificationVerticalSwipeVm,
  NotificationVmInjector } from '@ohos/systemuicommon/newIndex';
import { SystemUIUseScene, NotificationBase, NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import { INotificationNormalVm, INotificationTimeVm, INotificationCardVm, INotificationSwipeVm,
  INotificationPanelVm, INotificationStarterVm, INotificationActionButtonVm } from '@ohos/systemuicommon/newIndex';
import {
  INotificationPrivacyVm
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationPrivacyVm';
import { NotificationImmersiveVm } from '../../../viewmodel/NotificationImmersiveVm';
import { ViewName } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

export class NotificationBannerVmInjector extends NotificationVmInjector {
  public scene = SystemUIUseScene.BANNER;

  public viewName = ViewName.BANNER_VIEW;

  getBannerVm(): NotificationBannerVm {
    return this.getVm(NotificationBannerVm.name, () => new NotificationBannerVm(this));
  }

  getImmersiveVm(): INotificationImmersiveVm {
    return this.getVm(NotificationImmersiveVm.name, () => new NotificationImmersiveVm(this));
  }

  getNormalVm(ntf: NormalNotification): INotificationNormalVm {
    return this.getVm(this.getKey(NotificationNormalBannerVm, ntf), () => new NotificationNormalBannerVm(this, ntf));
  }

  getTimeVm(ntf: NotificationBase): INotificationTimeVm {
    return this.getVm(this.getKey(NotificationTimeVm, ntf), () => new NotificationTimeVm(this, ntf));
  }

  getCardVm(ntf: NotificationBase): INotificationCardVm {
    return this.getVm(this.getKey(NotificationBannerCardVm, ntf), () => new NotificationBannerCardVm(this, ntf));
  }

  getCardFloatingVm(ntf: NotificationBase): INotificationCardFloatingVm {
    return this.getVm(this.getKey(NotificationCardFloatingVm, ntf), () => new NotificationCardFloatingVm(this, ntf));
  }

  getSwipeVm(ntf: NotificationBase): INotificationSwipeVm | undefined {
    return this.getVm(this.getKey(NotificationBannerSwipeVm, ntf), () => new NotificationBannerSwipeVm(this, ntf));
  }

  getPanelVm(): INotificationPanelVm {
    return this.getVm(NotificationPanelVm.name, () => new NotificationPanelVm(this));
  }

  getStarterVm(): INotificationStarterVm {
    return this.getVm(BannerNotificationStarterVm.name, () => new BannerNotificationStarterVm(this));
  }

  getActionButtonVm(ntf: NormalNotification): INotificationActionButtonVm {
    return this.getVm(this.getKey(NotificationActionButtonBannerVm, ntf),
      () => new NotificationActionButtonBannerVm(this, ntf));
  }

  getVerticalSwipeVm(): INotificationVerticalSwipeVm | undefined {
    return this.getVm(NotificationVerticalSwipeVm.name, () => new NotificationVerticalSwipeVm(this));
  }

  getPrivacyVm(ntf: NotificationBase): INotificationPrivacyVm {
    return this.getVm(this.getKey(NotificationPrivacyVm, ntf), () => new NotificationPrivacyVm(this, ntf))
  }
}