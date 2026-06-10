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
  INotificationLiveClickVm,
  INotificationVmInjector,
  NotificationVmInjector
} from '@ohos/systemuicommon/newIndex';
import { LiveExtensionType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '@ohos/systemuicommon/src/main/ets/live/model/LiveNotification';
import { LiveDropdownVmInjector } from '@ohos/systemuicommon/src/main/ets/live/variant/dropdown/LiveDropdownVmInjector';
import {
  LiveCardSystemDropdownVm
} from '@ohos/systemuicommon/src/main/ets/live/variant/dropdown/vm/LiveCardSystemDropdownVm';
import { LiveCardView } from '@ohos/systemuicommon/src/main/ets/live/view/LiveCardView';

/**
 * 通知中心2.0面板中的实况卡片
 */
@ComponentV2
export struct NotificationLiveCardView {
  @Consumer() ntfVmInjector: INotificationVmInjector = NotificationVmInjector.HOLDER;
  @Consumer() liveVmInjector: LiveDropdownVmInjector = LiveDropdownVmInjector.instance;
  @Param @Require live: LiveNotification;
  @Param @Require displayButtonsHashCode: string;

  @Monitor('displayButtonsHashCode')
  onDisplayButtonsHashCodeChanged() {
    LiveCardSystemDropdownVm.expandActionButtonMap.set(this.liveVmInjector.scene, this.displayButtonsHashCode);
  }

  @Computed get liveClickVm(): INotificationLiveClickVm | undefined {
    return this.ntfVmInjector.getNotificationLiveClickVm?.(this.live);
  }

  aboutToAppear(): void {
    if (this.liveClickVm) {
      if (this.live.card.isOtherCard() && this.live.card.extensionType !== LiveExtensionType.DEFAULT) {
        this.liveVmInjector.getCardOtherExtendVm(this.live).setHandleClickAction?.(this.liveClickVm.onExtendClick);
      }
      if (this.live.actionButtons?.length) {
        this.liveVmInjector.getLiveActionButtonVm(this.live).setHandleClickAction?.(this.liveClickVm.onButtonClick);
      }
    }
  }

  aboutToDisappear(): void {
    LiveCardSystemDropdownVm.expandActionButtonMap.delete(this.liveVmInjector.scene);
  }

  build() {
    LiveCardView({ live: this.live })
  }
}

