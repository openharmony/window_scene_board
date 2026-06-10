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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseNotification } from '@ohos/systemuicommon/src/main/ets/model/BaseNotification';
import { LiveExtendType, LiveType } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import {
  LiveNavigationTemplate,
  LiveOtherExtendData,
  LivePickUpTemplate,
  LiveScoreTemplate,
  LiveViewData, OtherBaseTemplate
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LiveFlightTemplate } from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveFlightTemplate';
import { LiveProgressTemplate } from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveProgressTemplate';
import { ParseNotificationErrorCode } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { ParseMaintenanceBase } from './ParseMaintenanceBase';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'ParseNotificationMaintenanceRecord');


/**
 * 通知解析运维打点
 */
export class ParseNotificationMaintenance extends ParseMaintenanceBase {

  protected fillLiveExt(entry: BaseNotification): void {
    this.ext.capsuleType = entry.liveViewData?.capsule?.type;
    this.ext.templateType = entry.liveViewData?.liveType;
    this.ext.typeCode = entry.liveViewData?.sysTypeCode;
    this.ext.extendType = ((entry?.liveViewData?.template as OtherBaseTemplate)?.getExtendData(LiveExtendType
      .TYPE_OTHER_EXTEND) as LiveOtherExtendData)?.type;
    this.ext.isMute = entry.liveViewData?.isMute;
    this.ext.liveEvent = entry.liveViewData?.event;
  }

  protected checkLiveView(entry: BaseNotification, request: notificationManager.NotificationRequest): void {
    if (!entry.isLiveType()) {
      return;
    }

    if (!entry.liveViewData) {
      this.addErrorCode(ParseNotificationErrorCode.LIVE_VIEW_ERROR);
      return;
    }

    if (entry.liveViewData.isLiveSystem()) {
      this.checkSystemLiveView(entry.liveViewData, request);
    } else {
      this.checkOtherLiveView(entry.liveViewData, request);
    }
  }

  private checkSystemLiveView(liveViewData: LiveViewData, request: notificationManager.NotificationRequest): void {
    const systemLiveView = request.content.systemLiveView;
    if (systemLiveView?.button?.iconsResource?.length) {
      const liveButtonData = liveViewData.getButtonData();
      if (!liveButtonData?.length || liveButtonData.some((button) => !button.icon)) {
        this.addErrorCode(ParseNotificationErrorCode.SYSTEM_LIVE_VIEW_BUTTON_ERROR);
      }
    }
  }

  private checkOtherLiveView(liveViewData: LiveViewData, request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    const template = liveViewData.template as OtherBaseTemplate;
    const extendData = template.getExtendData(LiveExtendType.TYPE_OTHER_EXTEND) as LiveOtherExtendData;

    if (extraInfo?.['CapsuleData.icon.res'] && !liveViewData.capsule?.icon) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_CAPSULE_ICON_ERROR);
    }
    if (extraInfo?.['ExtendData.pic.res'] && !extendData.pic) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_EXTEND_ICON_ERROR);
    }

    if (template.layoutType === LiveType.INVALID) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_INVALID_LAYOUT);
    } else if (template.layoutType === LiveType.PROGRESS) {
      this.checkProgressTemplate(template as LiveProgressTemplate, request);
    } else if (template.layoutType === LiveType.PICK_UP) {
      this.checkPickupTemplate(template as LivePickUpTemplate, request);
    } else if (template.layoutType === LiveType.FLIGHT) {
      this.checkFlightTemplate(template as LiveFlightTemplate, request);
    } else if (template.layoutType === LiveType.SCORE) {
      this.checkScoreTemplate(template as LiveScoreTemplate, request);
    } else if (template.layoutType === LiveType.NAVIGATION) {
      this.checkNavigationTemplate(template as LiveNavigationTemplate, request);
    }
  }

  private checkProgressTemplate(template: LiveProgressTemplate,
    request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    if (extraInfo?.['ProgressLayout.indicatorIcon.res'] && !template.indicatorIcon) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_PROGRESS_INDICATOR_ICON_ERROR);
    }
    if (extraInfo?.['ProgressLayout.nodeIcons.res'] &&
      (!template.nodeIcons || template.nodeIcons.some((node) => !node.icon))) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_PROGRESS_NODE_ICON_ERROR);
    }
  }

  private checkPickupTemplate(template: LivePickUpTemplate, request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    if (extraInfo?.['PickupLayout.descPic.res'] && !template.descPic) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_PICKUP_DESC_ICON_ERROR);
    }
  }

  private checkFlightTemplate(template: LiveFlightTemplate, request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    if (extraInfo?.['FlightLayout.spaceIcon.res'] && !template.spaceIcon) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_FLIGHT_SPACE_ICON_ERROR);
    }
  }

  private checkScoreTemplate(template: LiveScoreTemplate, request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    if (extraInfo?.['ScoreLayout.hostIcon.res'] && !template.hostIcon) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_SCORE_HOST_ICON_ERROR);
    }
    if (extraInfo?.['ScoreLayout.guestIcon.res'] && !template.guestIcon) {
      this.addErrorCode(ParseNotificationErrorCode.OTHER_LIVE_VIEW_SCORE_GUEST_ICON_ERROR);
    }
  }

  private checkNavigationTemplate(template: LiveNavigationTemplate,
    request: notificationManager.NotificationRequest): void {
    const extraInfo = request.content.liveView?.extraInfo;
    if (extraInfo?.['NavigationLayout.currentNavigationIcon.res'] && !template.currNavDirectionIcon) {
      this.addErrorCode(ParseNotificationErrorCode.NAVIGATION_LIVE_VIEW_CURRENT_ICON_ERROR);
    }
    if (extraInfo?.['NavigationLayout.navigationIcons.res'] &&
      (!template.navDirectionIcons || template.navDirectionIcons.some((n) => !n.icon))) {
      this.addErrorCode(ParseNotificationErrorCode.NAVIGATION_LIVE_VIEW_DIRECTION_ICONS_ERROR);
    }
  }
}