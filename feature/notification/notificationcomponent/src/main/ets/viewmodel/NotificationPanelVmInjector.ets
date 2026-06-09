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

import {
  INotificationCardVm,
  INotificationClearButtonVm,
  INotificationHeaderVm,
  INotificationListVm,
  INotificationListScrollerVm,
  INotificationMoreVm,
  INotificationPanelVm,
  NotificationVmInjector,
  INotificationNormalGroupVm,
  INotificationNormalVm,
  INotificationSwipeVm,
  INotificationSettingDialogVm,
  INotificationMenuVm,
  INotificationStarterVm,
  PinTopVm,
  INotificationPinTopLimitDialogVm,
  INotificationTimeVm,
  INotificationMoreHeaderVm,
  INotificationActionButtonVm,
  INotificationCardFloatingVm,
  INotificationLiveClickVm,
  INotificationDataPlanVm,
} from '@ohos/systemuicommon/newIndex';
import {
  NormalNotification,
  NotificationBase,
  LiveNotification,
  SystemUIUseScene
} from '@ohos/systemuicommon/newTsIndex';
import {
  INotificationPrivacyVm
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationPrivacyVm';
import { ViewName } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import {
  INotificationSilenceVm
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationSilenceVm';
import { NotificationSilenceVm } from '@ohos/systemuicommon/src/main/ets/vm/NotificationSilenceVm';
import { NotificationActionButtonVm } from './NotificationActionButtonVm';
import { NotificationCardFloatingVm } from './NotificationCardFloatingVm';
import { NotificationCardVm } from './NotificationCardVm';
import { NotificationClearButtonVm } from './NotificationClearButtonVm';
import { NotificationHeaderVm } from './NotificationHeaderVm';
import { NotificationListScrollerVm } from './NotificationListScrollerVm';
import { NotificationListVm } from './NotificationListVm';
import { NotificationMenuVm } from './NotificationMenuVm';
import { NotificationMoreHeaderVm } from './NotificationMoreHeaderVm';
import { NotificationLiveClickVm } from './NotificationLiveClickVm';
import { NotificationMoreVm } from './NotificationMoreVm';
import { NotificationNormalGroupVm } from './NotificationNormalGroupVm';
import { NotificationNormalVm } from './NotificationNormalVm';
import { NotificationPanelVm } from './NotificationPanelVm';
import { NotificationPrivacyVm } from './NotificationPrivacyVm';
import { NotificationSettingDialogVm } from './NotificationSettingDialogVm';
import { NotificationStarterVm } from './NotificationStarterVm';
import { NotificationSwipeVm } from './NotificationSwipeVm';
import { NotificationTimeVm } from './NotificationTimeVm';
import { NotificationDataPlanVm } from './NotificationDataPlanVm';

export class NotificationPanelVmInjector extends NotificationVmInjector {
  public scene = SystemUIUseScene.DROPDOWN;

  public viewName = ViewName.DROPDOWN_VIEW;

  getPanelVm(): INotificationPanelVm {
    return this.getVm(NotificationPanelVm.name, () => new NotificationPanelVm(this));
  }

  getListVm(): INotificationListVm {
    return this.getVm(NotificationListVm.name, () => new NotificationListVm(this));
  }

  getListScrollerVm(): INotificationListScrollerVm {
    return this.getVm(NotificationListScrollerVm.name, () => new NotificationListScrollerVm(this));
  }

  getClearButtonVm(): INotificationClearButtonVm {
    return this.getVm(NotificationClearButtonVm.name, () => new NotificationClearButtonVm(this));
  }

  getCardVm(ntf: NotificationBase): INotificationCardVm {
    return this.getVm(this.getKey(NotificationCardVm, ntf), () => new NotificationCardVm(this, ntf));
  }

  getCardFloatingVm(ntf: NotificationBase): INotificationCardFloatingVm {
    return this.getVm(this.getKey(NotificationCardFloatingVm, ntf), () => new NotificationCardFloatingVm(this, ntf));
  }

  getNormalGroupVm(ntf: NotificationBase): INotificationNormalGroupVm {
    return this.getVm(this.getKey(NotificationNormalGroupVm, ntf), () => new NotificationNormalGroupVm(this, ntf));
  }

  getNormalVm(ntf: NormalNotification): INotificationNormalVm {
    return this.getVm(this.getKey(NotificationNormalVm, ntf), () => new NotificationNormalVm(this, ntf));
  }

  getPrivacyVm(ntf: NotificationBase): INotificationPrivacyVm {
    return this.getVm(this.getKey(NotificationPrivacyVm, ntf), () => new NotificationPrivacyVm(this, ntf))
  }

  getActionButtonVm(ntf: NormalNotification): INotificationActionButtonVm {
    return this.getVm(this.getKey(NotificationActionButtonVm, ntf), () => new NotificationActionButtonVm(this, ntf));
  }

  getMoreVm(): INotificationMoreVm {
    return this.getVm(NotificationMoreVm.name, () => new NotificationMoreVm(this));
  }

  getHeaderVm(): INotificationHeaderVm {
    return this.getVm(NotificationHeaderVm.name, () => new NotificationHeaderVm(this));
  }

  getSwipeVm(ntf: NotificationBase): INotificationSwipeVm {
    return this.getVm(this.getKey(NotificationSwipeVm, ntf), () => new NotificationSwipeVm(this, ntf));
  }

  getMenuVm(ntf: NotificationBase): INotificationMenuVm {
    return this.getVm(this.getKey(NotificationMenuVm, ntf), () => new NotificationMenuVm(this, ntf));
  }

  getStarterVm(): INotificationStarterVm {
    return this.getVm(NotificationStarterVm.name, () => new NotificationStarterVm(this));
  }

  getTimeVm(ntf: NotificationBase): INotificationTimeVm {
    return this.getVm(this.getKey(NotificationTimeVm, ntf), () => new NotificationTimeVm(this, ntf));
  }

  getSettingDiagVm(): INotificationSettingDialogVm {
    return this.getVm(NotificationSettingDialogVm.name, () => new NotificationSettingDialogVm(this));
  }
  getSilenceVm(): INotificationSilenceVm {
    return this.getVm(NotificationSilenceVm.name, () => new NotificationSilenceVm(this));
  }
  getPinTopDialogVm(): INotificationPinTopLimitDialogVm {
    return this.getVm(PinTopVm.name, () => new PinTopVm(this));
  }

  getNotificationMoreHeaderVm(): INotificationMoreHeaderVm {
    return this.getVm(NotificationMoreHeaderVm.name, () => new NotificationMoreHeaderVm(this));
  }

  getNotificationLiveClickVm(ntf: LiveNotification): INotificationLiveClickVm {
    return this.getVm(this.getKey(NotificationLiveClickVm, ntf), () => new NotificationLiveClickVm(this, ntf));
  }

  getDataPlanVm(): INotificationDataPlanVm {
    return this.getVm(NotificationDataPlanVm.name, () => new NotificationDataPlanVm(this));
  }
}