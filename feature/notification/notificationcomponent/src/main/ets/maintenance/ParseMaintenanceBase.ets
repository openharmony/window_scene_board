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
import { notificationManager } from '@kit.NotificationKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationMaintenance, NotificationMaintenanceExt } from '@ohos/systemuicommon/src/main/ets/maintenance/NotificationMaintenance';
import { CapsuleType, LiveExtendType, LiveType, SysTypeCode } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import { MaintenanceRecordType } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceModel';
import { NotificationCreatorType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { StatisticsMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsMaintenance';
import { ParseNotificationErrorCode } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import {
    CompatibleNotification,
    MaintenanceCompatibleUtils
} from '@ohos/systemuicommon/src/main/ets/maintenance/MaintenanceCompatibleUtils';
import { NotificationBase } from '@ohos/systemuicommon/src/main/ets/model/NotificationBase';
import { LiveNotification } from '@ohos/systemuicommon/src/main/ets/live/model/LiveNotification';
import { NormalNotification } from '@ohos/systemuicommon/src/main/ets/model/NormalNotification';
import { LiveCapsuleType,
  LiveCardType,
  LiveExtensionType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import viewMgrPolicy, { ViewType } from '@ohos/frameworkwrapper/src/main/ets/manager/view/ViewManagerPolicy';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { BusinessError } from '@kit.BasicServicesKit';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'ParseMaintenanceBase');

/**
 * 通知特权
 */
export enum NotificationMaintenancePrivilege {
  SMALL_ICON = 0,
  SETTING_IGNORE = 1,
  NON_REMOVABLE = 2,
}

export interface ParseNotificationMaintenanceExt extends NotificationMaintenanceExt {
  /* 是否更新通知 */
  isUpdate?: boolean;
  /* 通知代理者包名 */
  agentBundleName?: string;
  /* 通知类型 */
  slotType?: notificationManager.SlotType;
  /* 通知使用的特权 */
  privilege?: NotificationMaintenancePrivilege[];
  /* 实况通知业务类型 */
  typeCode?: SysTypeCode;
  /* 实况通知模板类型 */
  templateType?: LiveType | LiveCardType;
  /* 实况通知胶囊类型 */
  capsuleType?: CapsuleType | LiveCapsuleType;
  /* 实况通知扩展区类型 */
  extendType?: LiveExtendType | LiveExtensionType;
  /* 实况通知版本号 */
  version?: number;
  /* 实况类型(0-进度类，1-即时，2-长时) */
  liveType?: number;
  /* 实况数据是否已结束，结束后不在胶囊和锁屏上显示 */
  isEnd?: boolean;
  /* 实况持续时间 */
  liveDuration?: number;
  /* 实况阶段 */
  stage?: number;
  /* 实况场景 */
  liveEvent?: string;
  /* 通知提醒标志位remindFlags */
  remindFlags?: number;
  /* 通知控制字段 */
  notificationControlFlags?: number;
  /* 是否正在进行通知 */
  isOngoing?: boolean;
  /* 通知发送时间 */
  deliveryTime?: number;
  /* 是否锁屏 */
  isKeyGuard?: boolean;
  /* 是否勿扰模式 */
  focusMode?: boolean;
  /* 响铃模式 */
  ringMode?: number;
  /* 分身id */
  appIndex?: number;
  /* 是否仅提醒一次 */
  isAlertOnce?: boolean;
  /* 实况是否静默 */
  isMute?: boolean;
}

/**
 * 通知解析运维打点
 */
export abstract class ParseMaintenanceBase extends NotificationMaintenance<ParseNotificationMaintenanceExt> {
  constructor(isUpdate: boolean) {
    super(MaintenanceRecordType.NOTIFICATION_RECEIVE);
    this.ext.isUpdate = isUpdate;
  }

  public init(entry: CompatibleNotification, request: notificationManager.NotificationRequest): ParseMaintenanceBase {
    try {
      this.fillExt(entry, request);
      this.checkApp(entry);
      this.checkWantAgent(entry, request);
      this.checkResource(entry, request);
      this.checkLiveView(entry, request);
      this.checkPossibleError(entry);
      this.checkParseResult(entry);
    } catch (e) {
      log.showError(`Init error, type: ${this.recordType}, hashCode: ${request.hashCode}, message: ${e.message}`);
    }
    return this;
  }

  /**
   * 解析异常
   * @param request
   */
  public reportParseFailed(request?: notificationManager.NotificationRequest, err?: Error,
    currentUserId?: number): void {
    try {
      const ntf = request?.notificationSlotType === notificationManager.SlotType.LIVE_VIEW ?
        new LiveNotification() : new NormalNotification();
      ntf.hashCode = request?.hashCode ?? '';
      ntf.creatorBundleName = request?.creatorBundleName ?? '';
      ntf.pushData = request?.unifiedGroupInfo?.extraInfo?.pushData;
      this.fillCommonExt(ntf);
      this.ext.slotType = request?.notificationSlotType;
      this.ext.agentBundleName = request?.agentBundle?.bundle;
      // 更多信息，json上报
      const moreInfo: Record<string, Object | undefined> = {};
      moreInfo.userId = request?.creatorUserId;
      moreInfo.currentUserId = currentUserId;
      moreInfo.creatorUid = request?.creatorUid;
      moreInfo.innerCode = (err as BusinessError)?.code;
      moreInfo.message = (err as BusinessError)?.message;
      this.ext.moreInfo = JSON.stringify(moreInfo);
      this.addErrorCode(ParseNotificationErrorCode.PARSE_FAILED);
      this.report();
    } catch (e) {
      log.showError(`report error, type: ${this.recordType}, hashCode: ${request?.hashCode}, message: ${e.message}`);
    }
  }

  /**
   * 填充通知打点详细信息的公共字段
   * @param entry
   * @param request
   */
  private fillExt(entry: CompatibleNotification, request: notificationManager.NotificationRequest): void {
    super.fillCommonExt(entry);
    this.ext.remindFlags = request.notificationFlags?.reminderFlags;
    this.ext.notificationControlFlags = request.notificationControlFlags;
    this.ext.agentBundleName = entry.agentBundle?.bundle;
    this.ext.slotType = entry.slotType;
    this.ext.version = SystemUICcmConfig.instance.isEnabledLive2 ? 1 : 0;
    this.ext.privilege = this.getPrivilege(entry);
    this.ext.isOngoing = entry.isOngoing;
    this.ext.deliveryTime = entry.deliveryTime;
    this.ext.isKeyGuard = viewMgrPolicy.isViewShowing(ViewType.KEYGUARD);
    this.ext.ringMode = StatisticsMaintenance.get().getRingMode();
    this.ext.appIndex = entry.appIndex;
    this.ext.isAlertOnce = entry.isAlertOnce;
    this.fillExtMoreInfo(entry);
  }

  protected abstract fillLiveExt(entry: CompatibleNotification, moreInfo: Record<string, Object>): void;

  protected fillExtMoreInfo(entry: CompatibleNotification): void {
    const moreInfo: Record<string, Object> = {};
    this.fillLiveExt(entry, moreInfo);
    if (entry.creatorUserId) {
      moreInfo.userId = entry.creatorUserId;
    }
    moreInfo.isShow = StatisticsMaintenance.get().getIsShow();
    if (entry.channelId) {
      moreInfo.channelId = entry.channelId;
    }
    if (entry.traceId) {
      moreInfo.traceId = entry.traceId;
    }
    moreInfo.soundDuration = entry.soundDuration ?? 0;
    if (entry.classification) {
      moreInfo.class = entry.classification;
    }
    moreInfo.isProtected =
      Number(StatisticsMaintenance.get().protectedAppSet.has(`${entry.creatorBundleName}_${entry.appIndex}`));
    moreInfo.isCollaNtf = entry instanceof NotificationBase ? entry.isCollaNotification : false;
    this.ext.moreInfo = JSON.stringify(moreInfo);
  }

  /**
   * 获取通知的特权
   * @param entry
   * @returns
   */
  private getPrivilege(entry: CompatibleNotification): NotificationMaintenancePrivilege[] | undefined {
    const privilege: NotificationMaintenancePrivilege[] = [];
    if (entry?.isFromSystemApp && entry.smallIcon) {
      privilege.push(NotificationMaintenancePrivilege.SMALL_ICON);
    }
    if (entry?.isSettingIgnore) {
      privilege.push(NotificationMaintenancePrivilege.SETTING_IGNORE);
    }
    if (!entry.isRemoveAllowed) {
      privilege.push(NotificationMaintenancePrivilege.NON_REMOVABLE);
    }
    return privilege.length ? privilege : undefined;
  }

  private checkApp(entry: CompatibleNotification): void {
    if (entry.creatorType === NotificationCreatorType.SA) {
      if (!entry.smallIcon && !entry.appIcon) {
        this.addErrorCode(ParseNotificationErrorCode.NO_SA_ICON);
      }
    } else {
      if (!entry.appIcon) {
        this.addErrorCode(ParseNotificationErrorCode.NO_APP_ICON);
      }
    }

    if (!entry.appLabel) {
      this.addErrorCode(ParseNotificationErrorCode.NO_APP_LABEL);
    }

    if (!entry.creatorBundleName) {
      this.addErrorCode(ParseNotificationErrorCode.NO_BUNDLE);
    }

    if (!entry.creatorUid) {
      this.addErrorCode(ParseNotificationErrorCode.NO_UID);
    }
  }

  private checkWantAgent(entry: CompatibleNotification, request: notificationManager.NotificationRequest): void {
    if (!request.wantAgent) {
      this.addErrorCode(ParseNotificationErrorCode.NO_WANTAGENT);
      return;
    }
    if (!entry.wantAgentInfo) {
      this.addErrorCode(ParseNotificationErrorCode.NO_WANTAGENT_INFO);
      return;
    }
    if (!entry.wantAgentInfo.bundleName) {
      this.addErrorCode(ParseNotificationErrorCode.WANTAGENT_NO_BUNDLE);
    }
    if (!entry.wantAgentInfo.want) {
      this.addErrorCode(ParseNotificationErrorCode.WANTAGENT_NO_WANT);
    }
  }

  private checkResource(entry: CompatibleNotification, request: notificationManager.NotificationRequest): void {
    if (request.sound && !MaintenanceCompatibleUtils.getSoundDescriptor(entry)) {
      this.addErrorCode(ParseNotificationErrorCode.CUSTOM_SOUND_ERROR);
    }
  }

  /**
   * 校验实况数据
   * @param entry
   * @param request
   */
  protected abstract checkLiveView(entry: CompatibleNotification,
    request: notificationManager.NotificationRequest): void;

  private checkPossibleError(entry: CompatibleNotification): void {
    if (MaintenanceCompatibleUtils.getSoundDescriptor(entry) &&
      (!entry.controlConfig.isExtraScreenOn() || !entry.controlConfig.isCustomVibration())) {
      this.addErrorCode(ParseNotificationErrorCode.CUSTOM_RING_BUT_NO_OTHER_CONTROL);
    }
    if (entry.deliveryTime ?? 0 > Date.now()) {
      this.addErrorCode(ParseNotificationErrorCode.DELIVERY_TIME_INVALID);
    }
  }

  private checkParseResult(entry: CompatibleNotification): void {
    if (this.ext.errorCodes?.length) {
      StatisticsMaintenance.get().receiveNtf(false, entry, this.ext.isUpdate, this.ext.isKeyGuard, this.ext.errorCodes);
    } else {
      StatisticsMaintenance.get().receiveNtf(true, entry, this.ext.isUpdate, this.ext.isKeyGuard);
    }
  }
}