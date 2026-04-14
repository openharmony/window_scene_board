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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseNotification } from '../model/BaseNotification';
import { notificationManager, notificationSubscribe } from '@kit.NotificationKit';
import { NotificationMaintenance, NotificationMaintenanceExt } from './NotificationMaintenance';
import { MaintenanceRecordType } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceModel';
import { LiveViewData } from '../liveview/data/LiveViewData';
import { StatisticsMaintenance } from './StatisticsMaintenance';
import { SystemuiConstants } from '../constants/SystemuiConstants';
import { DeleteNotificationType, ExternalDeleteReason } from './StatisticsConstants';
import { CompatibleNotification } from './MaintenanceCompatibleUtils';
import { NotificationBase } from '../model/NotificationBase';
import { LiveNotification } from '../live/model/LiveNotification';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'DeleteNotificationMaintenance');

/**
 * 通知删除错误码，1000-2000
 */
export enum DeleteNotificationErrorCode {
  /* 调用ANS删除后回调超时 */
  ANS_CALLBACK_TIMEOUT = 1000,
  /* 调用ANS的删除回调没有返回该条通知 */
  ANS_NO_CALLBACK = 1001,
  /* 实况胶囊超时未更新 */
  CAPSULE_UPDATE_TIMEOUT = 1002,
  /* 通知删除失败,hashCode为空 */
  NTF_HASHCODE_INVALID_FAIL = 1003,
  /* 通知删除失败 */
  NTF_CANCEL_FAIL = 1004,
  /* 通知对象不可用 */
  NTF_INVALID_FAIL = 1005,
  /* 实况卡片删除失败,hashCode为空 */
  LIVE_VIEW_HASHCODE_INVALID_FAIL = 1006,
  /* 实况卡片删除失败 */
  LIVE_VIEW_CANCEL_FAIL = 1007,
  /* 实况卡片对象不可用 */
  LIVE_VIEW_INVALID_FAIL = 1008,
  /* 消息超过通知中心数量限制删除 */
  EXCEED_MAX_NUMBER_DELETE = 1009,
  /* 实况卡片超过4h未更新 */
  LIVE_BANNER_OVER_FOUR_HOURS = 1010,
  /* 实况卡片超过8h */
  LIVE_BANNER_OVER_EIGHT_HOURS = 1011,
  /* SA取消通知 */
  SA_CANCEL_NTF = 1012,
  /* 长时任务10min不更新删除 */
  LONG_TIME_OVER_10_MIN = 1013,
  /* 长时任务15min不更新删除 */
  LONG_TIME_OVER_15_MIN = 1014,
  /* 长时任务30min兜底删除 */
  LONG_TIME_OVER_30_MIN = 1015,
}

export interface DeleteInfo {
  deleteType?: DeleteNotificationType;
  isInGroup?: boolean;
}

interface DeleteNotificationMaintenanceExt extends NotificationMaintenanceExt {
  deleteType?: DeleteNotificationType;
  isInGroup?: boolean;
}

export class DeleteNotificationMaintenance extends NotificationMaintenance<DeleteNotificationMaintenanceExt> {
  private static readonly DELETE_CHECK_TIMEOUT: number = 1000;
  // 胶囊超时、通知超限制不算异常删除
  private static readonly NORMAL_ERROR_CODE: Set<DeleteNotificationErrorCode> =
    new Set([DeleteNotificationErrorCode.CAPSULE_UPDATE_TIMEOUT, DeleteNotificationErrorCode.EXCEED_MAX_NUMBER_DELETE]);

  private static REASON_TO_ERROR_MAP: Map<number, DeleteNotificationErrorCode> = new Map([
    [ExternalDeleteReason.APP_CANCEL_AS_BUNELE_REASON_DELETE, DeleteNotificationErrorCode.SA_CANCEL_NTF],
    [ExternalDeleteReason.TRIGGER_EIGHT_HOUR_REASON_DELETE, DeleteNotificationErrorCode.LIVE_BANNER_OVER_EIGHT_HOURS],
    [ExternalDeleteReason.TRIGGER_FOUR_HOUR_REASON_DELETE, DeleteNotificationErrorCode.LIVE_BANNER_OVER_FOUR_HOURS],
    [ExternalDeleteReason.TRIGGER_TEN_MINUTES_REASON_DELETE, DeleteNotificationErrorCode.LONG_TIME_OVER_10_MIN],
    [ExternalDeleteReason.TRIGGER_FIFTEEN_MINUTES_REASON_DELETE, DeleteNotificationErrorCode.LONG_TIME_OVER_15_MIN],
    [ExternalDeleteReason.TRIGGER_THIRTY_MINUTES_REASON_DELETE, DeleteNotificationErrorCode.LONG_TIME_OVER_30_MIN],
  ]);

  private static timerMap: Map<number, [CompatibleNotification[], DeleteNotificationType]> = new Map();
  private static ntfMap: Map<string, DeleteInfo> = new Map();

  private constructor(ntf: CompatibleNotification, deleteType: DeleteNotificationType, isInGroup: boolean) {
    super(MaintenanceRecordType.NOTIFICATION_DELETE);
    this.ext.deleteType = deleteType;
    this.ext.isInGroup = isInGroup;
    this.fillCommonExt(ntf);
  }

  /**
   * 将通知删除类型、是否在组通知中加入ntfMap中
   */
  public static addNtfMap(ntfEntry: CompatibleNotification[], deleteType: DeleteNotificationType, isInGroup: boolean): void {
    for (const ntfItem of ntfEntry) {
      DeleteNotificationMaintenance.ntfMap.set(ntfItem.hashCode, {
        deleteType: deleteType,
        isInGroup: isInGroup,
      });
    }
    DeleteNotificationMaintenance.startTimer(ntfEntry, deleteType, isInGroup);
  }

  /**
   * 手动删除通知
   */
  public static manualDelete(ntfList: CompatibleNotification[], info?: DeleteInfo,
    errorCode?: DeleteNotificationErrorCode): void {
    let deleteInfo = info;
    // 无info时从map中查询
    if (!deleteInfo) {
      deleteInfo = DeleteNotificationMaintenance.getDeleteInfo(ntfList);
    }
    if (!deleteInfo) {
      log.showInfo('Cant find deleteInfo');
      return;
    }
    DeleteNotificationMaintenance.checkErrorToReport(ntfList, deleteInfo.deleteType, deleteInfo.isInGroup, errorCode);
  }

  /**
   * 获取删除时信息
   */
  public static getDeleteInfo(ntfList: CompatibleNotification[]): DeleteInfo | undefined {
    let deleteInfo: DeleteInfo | undefined = undefined;
    for (const ntfItem of ntfList) {
      deleteInfo = DeleteNotificationMaintenance.ntfMap.get(ntfItem?.hashCode) ?? deleteInfo;
      DeleteNotificationMaintenance.ntfMap.delete(ntfItem?.hashCode);
    }
    return deleteInfo;
  }

  /**
   * 如果有错误直接上报
   */
  private static checkErrorToReport(ntfList: CompatibleNotification[], deleteType: DeleteNotificationType,
    isInGroup: boolean, errorCode?: DeleteNotificationErrorCode): void {
    // 有errorCode直接上报
    if (errorCode) {
      DeleteNotificationMaintenance.doReport(ntfList, deleteType, errorCode, isInGroup);
      if (!DeleteNotificationMaintenance.NORMAL_ERROR_CODE.has(errorCode)) {
        StatisticsMaintenance.get().deleteNtf(false, ntfList);
      } else if (errorCode === DeleteNotificationErrorCode.CAPSULE_UPDATE_TIMEOUT) {
        StatisticsMaintenance.get().deleteNtf(true, ntfList, ExternalDeleteReason.LIVE_CAPSULE_HIDE);
      }
    }
  }

  /**
   * 启动定时器，2s内未返回ANS删除，则上报打点
   * @param ntfList
   * @param deleteType
   * @param isInGroup
   */
  private static startTimer(ntfList: CompatibleNotification[], deleteType: DeleteNotificationType, isInGroup: boolean): void {
    const reportNtf = ntfList.slice();
    const timerId = setTimeout(() => {
      DeleteNotificationMaintenance.doReport(reportNtf, deleteType,
        DeleteNotificationErrorCode.ANS_CALLBACK_TIMEOUT, isInGroup);
      DeleteNotificationMaintenance.timerMap.delete(timerId);
      StatisticsMaintenance.get().deleteNtf(false, reportNtf);
      reportNtf.forEach(ntf => DeleteNotificationMaintenance.ntfMap.delete(ntf.hashCode));
    }, DeleteNotificationMaintenance.DELETE_CHECK_TIMEOUT);
    DeleteNotificationMaintenance.timerMap.set(timerId, [reportNtf, deleteType]);
    log.showInfo(`current ntfMap size ${DeleteNotificationMaintenance.ntfMap.size}, timerMap size ${DeleteNotificationMaintenance.timerMap.size}`);
  }

  /**
   * 手动删除实况
   */
  public static manualDeleteLiveView(liveViewData: LiveViewData,
    deleteType: DeleteNotificationType, errorCode?: DeleteNotificationErrorCode): void {
    const ntfEntry = new BaseNotification();
    ntfEntry.creatorBundleName = liveViewData?.creatorBundleName;
    ntfEntry.hashCode = liveViewData?.hashCode;
    ntfEntry.slotType = notificationManager.SlotType.LIVE_VIEW;
    ntfEntry.contentType = liveViewData?.isLiveSystem() ?
      notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW :
      notificationManager.ContentType.NOTIFICATION_CONTENT_LIVE_VIEW;
    ntfEntry.liveViewData = liveViewData;
    ntfEntry.isFromPush = liveViewData?.agentBundle?.bundle === SystemuiConstants.PUSH_BUNDLE_NAME;
    DeleteNotificationMaintenance.startTimer([ntfEntry], deleteType, false);
    DeleteNotificationMaintenance.checkErrorToReport([ntfEntry], deleteType, false, errorCode);
  }

  /**
   * 单条通知删除回调
   */
  public static cancelCallback(cancelData: notificationSubscribe.SubscribeCallbackData): void {
    DeleteNotificationMaintenance.cancelCallbackBatch([cancelData]);
  }

  /**
   * 多条通知删除回调
   */
  public static async cancelCallbackBatch(cancelDataList: Array<notificationSubscribe.SubscribeCallbackData>): Promise<void> {
    try {
      if (!cancelDataList) {
        return;
      }
      const timerId: number | undefined = DeleteNotificationMaintenance.findTimer(cancelDataList);
      if (!timerId) {
        log.showInfo('Cant find timerId');
        DeleteNotificationMaintenance.checkOtherDelete(cancelDataList);
        return;
      }
      clearTimeout(timerId);
      const typeConfig: [CompatibleNotification[], DeleteNotificationType] =
        DeleteNotificationMaintenance.timerMap.get(timerId);
      DeleteNotificationMaintenance.timerMap.delete(timerId);
      if (!typeConfig) {
        log.showInfo('Cant find typeConfig');
        return;
      }
      const expectCallbackList: CompatibleNotification[] = typeConfig[0];
      // 查找未收到回调的通知
      const noCallbackList: CompatibleNotification[] = [];
      const hasCallBackList: CompatibleNotification[] = [];
      expectCallbackList.forEach((entry) => {
        if (cancelDataList.some(cancelData => cancelData.request?.hashCode === entry.hashCode)) {
          hasCallBackList.push(entry);
        } else {
          noCallbackList.push(entry);
        }
        DeleteNotificationMaintenance.ntfMap.delete(entry.hashCode);
      });
      if (noCallbackList.length) {
        this.doReport(noCallbackList, typeConfig[1], DeleteNotificationErrorCode.ANS_NO_CALLBACK, false);
        StatisticsMaintenance.get().deleteNtf(false, noCallbackList);
      }
      this.doReport(hasCallBackList, typeConfig[1], undefined, false);
      StatisticsMaintenance.get().deleteNtf(true, hasCallBackList, typeConfig[1]);
    } catch (e) {
      log.error(`cancel callback fault, error message: ${e}`);
    }
  }

  /**
   * 通过hashCode查找timerId
   */
  private static findTimer(cancelDataList: Array<notificationSubscribe.SubscribeCallbackData>): number | undefined {
    for (const callbackData of cancelDataList) {
      const hashCode: string = callbackData.request?.hashCode;
      for (const timer of DeleteNotificationMaintenance.timerMap.keys()) {
        const ntfEntryList: CompatibleNotification[] = DeleteNotificationMaintenance.timerMap.get(timer)[0] ?? [];
        if (ntfEntryList.some(ntfEntry => hashCode === ntfEntry.hashCode)) {
          return timer;
        }
      }
    }
    return undefined;
  }

  /**
   * 删除多通知打点上报
   */
  private static doReport(ntfList: CompatibleNotification[], deleteType: number,
    errorCode: DeleteNotificationErrorCode, isInGroup: boolean): void {
    for (const ntfItem of ntfList) {
      const deleteNotificationMaintenance = new DeleteNotificationMaintenance(ntfItem, deleteType, isInGroup);
      if (errorCode) {
        deleteNotificationMaintenance.addErrorCode(errorCode);
      }
      deleteNotificationMaintenance.report();
    }
  }

  /**
   * 统计并检查外部触发的删除
   * @param cancelDataList
   */
  private static checkOtherDelete(cancelDataList: Array<notificationSubscribe.SubscribeCallbackData>): void {
    for (const cancelData of cancelDataList) {
      if (!cancelData) {
        continue;
      }
      const ntf = cancelData.request?.notificationSlotType === notificationManager.SlotType.LIVE_VIEW ?
        new LiveNotification : new NotificationBase();
      ntf.creatorBundleName = cancelData.request?.creatorBundleName;
      ntf.hashCode = cancelData.request?.hashCode;
      ntf.isFromPush = cancelData.request?.agentBundle?.bundle === SystemuiConstants.PUSH_BUNDLE_NAME;
      ntf.contentType = cancelData.request?.content?.notificationContentType;
      if (ntf.isFromPush) {
        ntf.pushData = cancelData.request?.unifiedGroupInfo?.extraInfo?.pushData;
      }
      StatisticsMaintenance.get().deleteNtf(true, [ntf], cancelData.reason);

      const errorCode = DeleteNotificationMaintenance.REASON_TO_ERROR_MAP.get(cancelData.reason);
      DeleteNotificationMaintenance.doReport([ntf], cancelData.reason ?? DeleteNotificationType.OTHER_DELETE, errorCode, false);
    }
  }
}