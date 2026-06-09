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

import { DropdownVm } from '../../../../vm/DropdownVm';
import { SystemUIUseScene } from '../../../../constants/SystemuiConstants';
import { ClickNotificationMaintenance } from '../../../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../../../maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../../../sysEvent/LiveHiSysEvent';
import { LiveActionButtonVm } from '../../../vm/LiveActionButtonVm';
import { LiveStyle } from '../../../constants/LiveStyle';
import { LiveCardFloatingWantAgentParams } from '../../../interface/ILiveCardFloatingVm';

/**
 * 三方实况按钮VM
 */
@ObservedV2
export class LiveActionButtonDropdownVm extends LiveActionButtonVm {
  protected readonly TAG: string = 'LiveActionButtonDropdownVm';

  get fontColor(): ResourceColor {
    return $r('sys.color.ohos_id_color_text_secondary');
  }

  public handleClickEvent = async (index: number) => {
    if (!this.actionButtons[index]?.wantAgent && !this.live.isCollaNotification) {
      return;
    }
    ClickNotificationMaintenance.saveInfo({
      data: this.live,
      clickRegion: ClickRegion.SERVICE_BUTTON,
      scene: SystemUIUseScene.DROPDOWN,
      buttonName: this.actionButtons[index]?.actionTitle,
    });
    this.log.showInfo(`triggerServiceButtonWant for ${this.live.hashCode}_serviceButton_${index}`);
    LiveHiSysEvent.reportServiceButtonClickEvent(this.live, index, 4);

    const floatingVm = this.vmInjector.getCardFloatingVm(this.live);
    const params: LiveCardFloatingWantAgentParams = { wantAgent: this.actionButtons[index]?.wantAgent };
    if (await floatingVm.canOpenFloating(params)) {
      floatingVm.startFloatingForClick(params);
      DropdownVm.instance.hidePanel(true);
      return;
    }

    const isStartApp = await this.vmInjector.getStarterVm().startCardWantAgent({
      wantAgent: this.actionButtons[index]?.wantAgent,
      cardVm: this.vmInjector.getCardListItemVm(this.live),
      operationInfo: {
        operationType: LiveStyle.DISTRIBUTE_OPERATION_BUTTON_JUMP,
        buttonIndex: index + 1,
      }
    });
    if (isStartApp.start) {
      LiveHiSysEvent.reportLiveClickAppEvent(this.live, 4);
      DropdownVm.instance.hidePanel(false);
    }
  }

  public setHandleClickAction = (callback: (index: number) => Promise<void>) => {
    this.handleClickEvent = callback;
  }
}