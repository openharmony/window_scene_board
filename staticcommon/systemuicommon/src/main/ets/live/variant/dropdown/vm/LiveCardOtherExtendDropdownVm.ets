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

import { SystemUIUseScene } from '../../../../constants/SystemuiConstants';
import { NotificationType } from '../../../../constants/NotificationType';
import { ClickNotificationMaintenance } from '../../../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../../../maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../../../sysEvent/LiveHiSysEvent';
import { LiveCardOtherExtendVm } from '../../../vm/LiveCardOtherExtendVm';
import { BrightnessOptionUtils } from '../../../../template/newStyle/BrightnessOptionUtils';
import { DropdownVm } from '../../../../vm/DropdownVm';
import { LiveStyle } from '../../../constants/LiveStyle';
import { LiveCardFloatingWantAgentParams } from '../../../interface/ILiveCardFloatingVm';

@ObservedV2
export class LiveCardOtherExtendDropdownVm extends LiveCardOtherExtendVm {
  get textColor(): ResourceColor | undefined {
    return $r('sys.color.ohos_id_color_text_secondary');
  }

  @Computed get fontFgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().fontFgBrightness;
  }

  @Computed get buttonBgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().remainderBgBrightness;
  }

  @Computed get weatherButtonBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().weatherButtonBrightness;
  }

  @Computed
  get weatherButtonBgColor(): ResourceColor | string | undefined {
    return $r('app.color.theme_ntf_phone_remaind_bg_color');
  }

  protected triggerExtendWant = async (): Promise<void> => {
    if (!this.card.extensionWantAgent && !this.live.isCollaNotification) {
      return;
    }
    this.log.showInfo(`triggerExtendWant for ${this.live.hashCode}`);
    ClickNotificationMaintenance.saveInfo({
      data: this.live,
      clickRegion: ClickRegion.SUB_AREA,
      scene: SystemUIUseScene.DROPDOWN,
    });

    const floatingVm = this.vmInjector.getCardFloatingVm(this.live);
    const params: LiveCardFloatingWantAgentParams = { wantAgent: this.card.extensionWantAgent };
    if (await floatingVm.canOpenFloating(params)) {
      floatingVm.startFloatingForClick(params);
      DropdownVm.instance.hidePanel(true);
      return;
    }

    const isStartApp = await this.vmInjector.getStarterVm().startCardWantAgent({
      wantAgent: this.card.extensionWantAgent,
      cardVm: this.vmInjector.getCardListItemVm(this.live),
      operationInfo: {
        operationType: LiveStyle.DISTRIBUTE_OPERATION_BUTTON_JUMP,
        buttonIndex: 0,
      }
    });
    LiveHiSysEvent.reportClickExtendEvent(this.live, NotificationType.TYPE_PHONE_DROPDOWN);
    if (isStartApp.start) {
      LiveHiSysEvent.reportLiveClickAppEvent(this.live, 4);
      DropdownVm.instance.hidePanel(false);
    }
  }

  public setHandleClickAction = (callback: () => Promise<void>) => {
    this.triggerExtendWant = callback;
  }
}