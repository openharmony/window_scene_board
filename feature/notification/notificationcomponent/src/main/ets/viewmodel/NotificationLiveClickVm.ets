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

import { WantAgent } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  ClickNotificationMaintenance,
  ClickRegion,
  NotificationAction,
  NotificationWantAgentInfo
} from '@ohos/systemuicommon';
import {
  ASCFWindowMgrAdapter,
  DropdownVm,
  INotificationCardVm,
  INotificationLiveClickVm,
  LiveNotification,
  NotificationItemBaseVm
} from '@ohos/systemuicommon/newIndex';
import { SystemUIUseScene, WantAgentUtil } from '@ohos/systemuicommon/newTsIndex';
import { LiveHiSysEvent } from '@ohos/systemuicommon/src/main/ets/live/sysEvent/LiveHiSysEvent';
import {
  NotificationCardFloatingWantAgentParams
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationCardFloatingVm';
import { NotificationType } from '../common/NotificationType';
import { NotificationNormalVm } from './NotificationNormalVm';

const TAG = 'NotificationLiveClickVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

@ObservedV2
export class NotificationLiveClickVm extends NotificationItemBaseVm<LiveNotification>
implements INotificationLiveClickVm {
  getCardVm(): INotificationCardVm {
    return this.vmInjector.getCardVm(this.ntf);
  }

  /**
   * 通知卡片辅助区点击
   */
  public onExtendClick = async () => {
    if (!this.ntf.card.isOtherCard()) {
      return;
    }

    if (!this.ntf.card.extensionWantAgent && !this.ntf.isCollaNotification) {
      return;
    }
    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: ClickRegion.SUB_AREA,
      scene: SystemUIUseScene.DROPDOWN,
    });
    log.showInfo(`triggerExtendWant for ${this.ntf.hashCode}`);

    this.onItemClick(this.ntf.card.extensionWantAgent ?? this.ntf.wantAgent);

    LiveHiSysEvent.reportClickExtendEvent(this.ntf, NotificationType.TYPE_PHONE_DROPDOWN);
    LiveHiSysEvent.reportLiveClickAppEvent(this.ntf, 4);
  };

  /**
   * 通知卡片关联服务按钮点击
   *
   * @param index 被点击的关联服务按钮的索引
   */
  public onButtonClick = async (index: number) => {
    let actionButtons: NotificationAction[] = [];
    if (this.ntf.card.isSystemCard()) {
      actionButtons = this.ntf.actionButtons ?? [];
    } else if (this.ntf.card.isOtherCard()) {
      actionButtons = this.ntf.card.serviceButtons;
    }

    if (!actionButtons[index]?.wantAgent && !this.ntf.isCollaNotification) {
      return;
    }
    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: ClickRegion.SERVICE_BUTTON,
      scene: SystemUIUseScene.DROPDOWN,
      buttonName: actionButtons[index]?.actionTitle,
    });
    log.showInfo(`triggerServiceButtonWant for ${this.ntf.hashCode}_serviceButton_${index}`);

    this.onItemClick(actionButtons[index]?.wantAgent ?? this.ntf.wantAgent);

    LiveHiSysEvent.reportServiceButtonClickEvent(this.ntf, index, 4);
    LiveHiSysEvent.reportLiveClickAppEvent(this.ntf, 4);
  }

  /**
   * 通知卡片实况点击，提取函数供子类重写
   */
  protected async onItemClick(wantAgent: WantAgent): Promise<void> {
    // 左滑显示的卡片点击时，重置回原位置
    const swipeVm = this.vmInjector.getSwipeVm(this.ntf);
    if (swipeVm?.offsetX !== 0) {
      swipeVm?.resetOffsetX(true);
      return;
    }

    const wantAgentInfo: NotificationWantAgentInfo | undefined = await WantAgentUtil.parseWantAgentInfo(wantAgent);
    const floatingVm = this.vmInjector.getCardFloatingVm(this.ntf);
    const params: NotificationCardFloatingWantAgentParams = { wantAgent: wantAgent };
    if (await floatingVm.canOpenFloating(params)) {
      floatingVm.startFloatingForClick(params);
      DropdownVm.instance.hidePanel(true);
      return;
    }

    const groupNtf = this.vmInjector.getListVm()?.getGroupNtf(this.ntf);
    const groupCardVm = groupNtf ? this.vmInjector.getCardVm(groupNtf) : undefined;

    this.vmInjector.getStarterVm().startWantAgent({
      groupNtf,
      groupCardVm,
      cardVm: this.getCardVm(),
      wantAgent: wantAgent,
      wantAgentInfo: wantAgentInfo,
      triggerInfo: { code: 0 },
      operationInfo: { buttonIndex: -1, }
    });

    NotificationNormalVm.hideActionButtons(this.vmInjector.scene);
  }
}