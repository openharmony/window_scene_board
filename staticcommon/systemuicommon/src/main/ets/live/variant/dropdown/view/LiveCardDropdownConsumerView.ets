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
import { LiveDropdownVmInjector } from '../LiveDropdownVmInjector';
import { LiveNotification } from '../../../model/LiveNotification';
import { LiveCardSystemDropdownVm } from '../vm/LiveCardSystemDropdownVm';
import { LiveCardView } from '../../../view/LiveCardView';
import { ILiveCardListItemVm } from '../../../interface/ILiveCardListItemVm';

/**
 * 通知中心2.0面板中的实况卡片
 */
@ComponentV2
export struct LiveCardDropdownConsumerView {
  @Consumer() liveVmInjector: LiveDropdownVmInjector = LiveDropdownVmInjector.instance;
  @Param @Require live: LiveNotification;
  @Param @Require displayButtonsHashCode: string;

  @Computed
  get itemVm(): ILiveCardListItemVm | undefined {
    return this.live ? this.liveVmInjector.getCardListItemVm(this.live) : undefined;
  }

  @Monitor('displayButtonsHashCode')
  onDisplayButtonsHashCodeChanged() {
    LiveCardSystemDropdownVm.expandActionButtonMap.set(this.liveVmInjector.scene, this.displayButtonsHashCode);
  }

  aboutToDisappear(): void {
    LiveCardSystemDropdownVm.expandActionButtonMap.delete(this.liveVmInjector.scene);
  }

  build() {
    if (this.itemVm) {
      Stack() {
        LiveCardView({ live: this.live })
      }
      .id(this.itemVm.componentId)
    }
  }
}

