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

import { notificationManager } from '@kit.NotificationKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { LiveCardFlightModel } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCardFlightModel';
import { LiveCardNavigationModel } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCardNavigationModel';
import { LiveCardPickupModel } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCardPickupModel';
import { LiveCardProgressModel } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCardProgressModel';
import { LiveCardScoreModel } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCardScoreModel';
import { LiveCardSystemModel } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCardSystemModel';
import { LiveNotification } from '@ohos/systemuicommon/src/main/ets/live/model/LiveNotification';
import { ParseNotificationErrorCode } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { NotificationBase } from '@ohos/systemuicommon/src/main/ets/model/NotificationBase';
import { ParseMaintenanceBase } from './ParseMaintenanceBase';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'ParseNewNotificationMaintenance');

/**
 * 通知解析运维打点（new）
 */
export class ParseNewNotificationMaintenance extends ParseMaintenanceBase {
  protected fillLiveExt(ntf: NotificationBase, moreInfo: Record<string, Object>): void {
    if (ntf.isLiveView()) {
      this.ext.capsuleType = ntf.capsule?.capsuleType;
      this.ext.templateType = ntf.card?.cardType;
      this.ext.typeCode = ntf.typeCode;
      this.ext.liveType = ntf.type;
      this.ext.isEnd = ntf.isEnd;
      this.ext.liveDuration = ntf.duration;
      this.ext.stage = ntf.stage;
      if (!ntf.isSoundEnable && !ntf.isVibrationEnable) {
        this.ext.ringMode = 0;
      }
      if (!ntf.isHeadsUp && !ntf.isFlip()) {
        this.ext.remindFlags = 0;
      } else if (ntf.isFlip()) {
        this.ext.remindFlags = 1;
      } else if (ntf.isHeadsUp && !ntf.isHeadsUpStick) {
        this.ext.remindFlags = 2;
      } else if (ntf.isHeadsUp && ntf.isHeadsUpStick) {
        this.ext.remindFlags = 3;
      }
      if (ntf.card?.isOtherCard()) {
        this.ext.extendType = ntf.card.extensionType;
        this.ext.liveEvent = ntf.card.event;
        if (ntf.card.serviceButtons.length) {
          moreInfo.serviceButtons = ntf.card.serviceButtons.map(item => item.actionTitle);
        }
      }
    }
  }

  protected checkLiveView(ntf: NotificationBase, request: notificationManager.NotificationRequest): void {
    if (!ntf.isLiveView()) {
      return;
    }

    if (!ntf.card) {
      this.addErrorCode(ParseNotificationErrorCode.LIVE_VIEW_ERROR);
      return;
    }

    if (ntf.card.isSystemCard()) {
      this.checkSystemLiveView(ntf.card, request);
    } else {
      this.checkOtherLiveView(ntf, request);
    }
  }

  private checkSystemLiveView(liveCard: LiveCardSystemModel, request: notificationManager.NotificationRequest): void {
    const systemLiveView = request.content.systemLiveView;
    if (systemLiveView?.button?.iconsResource?.length) {
      const liveButtonData = liveCard.buttons;
      if (!liveButtonData?.length || liveButtonData.some((button) => !button.lightIcon)) {
        this.addErrorCode(ParseNotificationErrorCode.SYSTEM_LIVE_VIEW_BUTTON_ERROR);
      }
    }
  }

  private checkOtherLiveView(liveNtf: LiveNotification, request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    const card = liveNtf.card;
    const extendPic = card?.isOtherCard() ? card?.extensionPic : undefined;

    if (extraInfo?.['CapsuleData.icon.res'] && !liveNtf.capsule?.icon) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_CAPSULE_ICON_ERROR);
    }
    if (extraInfo?.['ExtendData.pic.res'] && !extendPic) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_EXTEND_ICON_ERROR);
    }

    if (card?.isProgressCard()) {
      this.checkProgressTemplate(card, request);
    } else if (card?.isPickupCard()) {
      this.checkPickupTemplate(card, request);
    } else if (card?.isFlightCard()) {
      this.checkFlightTemplate(card, request);
    } else if (card?.isScoreCard()) {
      this.checkScoreTemplate(card, request);
    } else if (card?.isNavigationCard()) {
      this.checkNavigationTemplate(card, request);
    } else {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_INVALID_LAYOUT);
    }
  }

  private checkProgressTemplate(model: LiveCardProgressModel, request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    if (extraInfo?.['ProgressLayout.indicatorIcon.res'] && !model.layoutIndicatorIcon) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_PROGRESS_INDICATOR_ICON_ERROR);
    }
    if (extraInfo?.['ProgressLayout.nodeIcons.res'] &&
      (!model.layoutNodeIcons || model.layoutNodeIcons.some((icon) => !icon))) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_PROGRESS_NODE_ICON_ERROR);
    }
  }

  private checkPickupTemplate(model: LiveCardPickupModel, request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    if (extraInfo?.['PickupLayout.descPic.res'] && !model.layoutDescPic) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_PICKUP_DESC_ICON_ERROR);
    }
  }

  private checkFlightTemplate(model: LiveCardFlightModel, request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    if (extraInfo?.['FlightLayout.spaceIcon.res'] && !model.layoutSpaceIcon) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_FLIGHT_SPACE_ICON_ERROR);
    }
  }

  private checkScoreTemplate(model: LiveCardScoreModel, request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    if (extraInfo?.['ScoreLayout.hostIcon.res'] && !model.layoutHostIcon) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_SCORE_HOST_ICON_ERROR);
    }
    if (extraInfo?.['ScoreLayout.guestIcon.res'] && !model.layoutGuestIcon) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_SCORE_GUEST_ICON_ERROR);
    }
  }

  private checkNavigationTemplate(model: LiveCardNavigationModel,
    request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    if (extraInfo?.['NavigationLayout.currentNavigationIcon.res'] && !model.layoutCurrentNavigationIcon) {
      this.addErrorCode(ParseNotificationErrorCode.NAVIGATION_LIVE_VIEW_CURRENT_ICON_ERROR);
    }
    if (extraInfo?.['NavigationLayout.navigationIcons.res'] &&
      (!model.layoutNavigationIcons || model.layoutNavigationIcons.some((icon) => !icon))) {
      this.addErrorCode(ParseNotificationErrorCode.NAVIGATION_LIVE_VIEW_DIRECTION_ICONS_ERROR);
    }
  }
}