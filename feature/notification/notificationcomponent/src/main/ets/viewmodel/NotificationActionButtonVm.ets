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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { NotificationSysEventReporter } from '@ohos/systemuicommon';
import {
  DropDownPanelManager,
  DropdownVm,
  INotificationActionButtonVm, INotificationCardVm, NotificationItemBaseVm } from '@ohos/systemuicommon/newIndex';
import { NormalNotification, SystemUIUseScene } from '@ohos/systemuicommon/newTsIndex';
import {
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { NotificationAction } from '@ohos/systemuicommon/src/main/ets/model/NotificationContent';
import {
  NotificationCardFloatingWantAgentParams,
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationCardFloatingVm';

const TAG = 'NotificationActionButtonVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

@ObservedV2
export class NotificationActionButtonVm extends NotificationItemBaseVm<NormalNotification>
implements INotificationActionButtonVm {
  public bgColor = $r('app.color.theme_ntf_phone_action_bg_color');

  @Trace public touchedIndex: number = -1;
  @Trace public isReplying: boolean = false;
  @Trace public replyAction?: NotificationAction;
  @Trace public replyContent: string = '';
  /**
   * 按钮文本字体颜色
   */
  @Computed
  get fontColor(): ResourceColor | undefined {
    return this.vmInjector.getColorVm().fontColor;
  }
  /**
   * 按钮文本字体背景提亮参数
   */
  @Computed
  get fontFgBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().fontFgBrightness;
  }

  /**
   * 按钮文本透明度
   */
  get fontOpacity(): number | undefined {
    return undefined;
  }

  private replyButtonIndex?: number = -1;

  private hasReportHiEvent: boolean = false;

  async onClickActionButton(action: NotificationAction, buttonIndex?: number, isInGroup?: boolean): Promise<void> {
    log.showInfo(`Click for action ${action.actionTitle}`);
    if (action.userInputKey) {
      this.replyAction = action;
      this.replyButtonIndex = buttonIndex;
      return;
    }
    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: ClickRegion.CONTENT_BUTTON,
    });

    const floatingVm = this.vmInjector.getCardFloatingVm(this.ntf);
    const params: NotificationCardFloatingWantAgentParams = { wantAgent: action.wantAgent };
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
      wantAgent: action.wantAgent,
      triggerInfo: { code: 0 },
      operationInfo: {
        actionName: action.actionTitle,
        buttonIndex
      }
    });
    NotificationSysEventReporter.notificationClickButton({
      DISPLAY_SCENE: this.vmInjector.scene === SystemUIUseScene.BANNER ? 3 : 4,
      IS_LIVE: 1,
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      NOTIFICATION_ID: this.ntf?.id,
      NOTIFICATION_SLOT_TYPE: this.ntf?.slotType,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      BUTTON_INDEX: buttonIndex,
      IS_IN_GROUP: isInGroup ? 1 : 0,
      IS_IN_AGGREGATE: 0,
      NOTIFICATION_CONTROL_FLAGS: this.ntf?.controlConfig?.flags,
      TRACE_ID: this.ntf?.traceId
    });
  }

  public onInputChange = (value: string): void => {
    this.replyContent = value;
    if (!this.hasReportHiEvent) {
      this.hasReportHiEvent = true;
      HiDfxEventUtil.reportNotificationReplyInputContent(this.ntf.creatorBundleName, this.ntf.id);
    }
  };

  public onClickReply = (): void => {
    if (!this.replyAction) {
      return;
    }
    this.isReplying = true;
    HiDfxEventUtil.reportNotificationReplySend(this.ntf.creatorBundleName, this.ntf.id);
    ClickNotificationMaintenance.saveInfo({
      data: this.ntf,
      clickRegion: ClickRegion.CONTENT_BUTTON,
    });
    const groupNtf = this.vmInjector.getListVm()?.getGroupNtf(this.ntf);
    const groupCardVm = groupNtf ? this.vmInjector.getCardVm(groupNtf) : undefined;
    this.vmInjector.getStarterVm().startWantAgent({
      groupNtf,
      groupCardVm,
      cardVm: this.getCardVm(),
      wantAgent: this.replyAction.wantAgent,
      triggerInfo: { code: 0, extraInfo: { key: this.replyAction.userInputKey, data: this.replyContent } },
      operationInfo: {
        actionName: this.replyAction.actionTitle,
        buttonIndex: this.replyButtonIndex
      }
    });
  };

  getCardVm(): INotificationCardVm {
    return this.vmInjector.getCardVm(this.ntf);
  }

  /**
   * 处理触摸事件
   * 1. 触摸按下时 显示背景色;
   * 2. 触摸后移动到组件外时 不显示背景色; 且再移回组件区域也不重新显示背景色
   * 3. 触摸抬起\取消\或其他情况 不显示背景色;
   *
   * @param event 触摸事件
   */
  onTouchEvent(event: TouchEvent, index: number): void {
    if (!event) {
      return;
    }
    if (TouchType.Down === event.type) {
      this.touchedIndex = index;
    } else if (TouchType.Move === event.type) {
      if (!(event.touches[0].x >= 0 && event.touches[0].x <= event.target.area.width &&
        event.touches[0].y >= 0 && event.touches[0].y <= event.target.area.height)) {
        this.touchedIndex = -1;
      }
    } else {
      this.touchedIndex = -1;
    }
    event.stopPropagation();
  }


  /**
   * 获取下挂按钮id
   *
   * @param index 按钮索引
   * @returns id 按钮id
   */
  getActionButtonId(index: number): string {
    return this.vmInjector.getId(`${TAG}_${this.ntf.hashCode}_button[${index}]`);
  }
}