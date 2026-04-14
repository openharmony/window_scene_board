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
import { HaReportBase, REPORT_TYPE } from './HaReportBase';
import { MaintenanceRecordType, MaintenanceReportInfo } from '../MaintenanceModel';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'HaReporter');

const EVENT_NAME = 'SYSTEM_UI_NOTIFICATION';

/**
 * HA打点上报处理
 */
export class HaReporter {
  /* HA事件的字段 */
  private static readonly HA_EVENT_PARAM: string[] = ['operationType', 'notificationStatus', 'ntfType', 'hashCode',
    'creatorBundleName', 'errorCodes', 'pushData', 'detailType', 'agentBundleName', 'slotType', 'privilege', 'typeCode',
    'templateType', 'capsuleType', 'extendType', 'liveVersion', 'liveType', 'isEnd', 'liveDuration', 'stage', 'liveEvent',
    'remindFlags', 'notificationControlFlags', 'isOngoing', 'deliveryTime', 'isKeyGuard', 'focusMode', 'ringMode',
    'appIndex', 'isAlertOnce'];

  /* 代码字段映射到HA打点字段 */
  private static readonly PARAM_KEY_MAP: Map<string, string> = new Map([
    /* 公共 */
    ['bundleName', 'creatorBundleName'],
    ['moreInfo', 'notificationStatus'],
    /* 通知接收 */
    ['isUpdate', 'detailType'],
    ['version', 'liveVersion'],
    /* 通知点击 */
    ['clickRegion', 'detailType'],
    ['clickType', 'typeCode'],
    ['buttonName', 'agentBundleName'],
    ['scene', 'extendType'],
    ['isAutoDelete', 'isEnd'],
    ['source', 'templateType'],
    /* 通知删除 */
    ['deleteType', 'detailType'],
    /* 通知提醒 */
    ['toneAllow', 'detailType'],
    ['vibrationAllow', 'privilege'],
    ['customSound', 'typeCode'],
    ['code', 'extendType'],
    ['message', 'templateType'],
    ['type', 'stage'],
    /* 通知显示 */
    ['isShowHeadsUp', 'detailType'],
    ['isHeadsUpStick', 'privilege'],
    ['isRemoveAllowed', 'extendType'],
    /* 提醒 */
    ['reason', 'detailType'],
    ['type', 'typeCode'],
    /* 接口异常 */
    ['desc', 'extendType'],
    ['stack', 'detailType'],
    /* 音量面板 */
    ['volumeType', 'detailType'],
    ['volume', 'extendType'],
    ['updateUi', 'privilege'],
    ['volumePanelNeedShow', 'typeCode'],
    ['displayName', 'agentBundleName'],
    ['deviceType', 'templateType'],
    /* 默认异常 */
    ['event', 'detailType'],
    ['subType', 'extendType'],
    ['subCode', 'typeCode'],
    /* 比翎 */
    ['subscribeTime', 'typeCode'],
    ['toggleState', 'extendType'],
    ['reportResult', 'privilege'],
    ['reportTime', 'agentBundleName'],
    ['displayState', 'capsuleType'],
    ['displayTime', 'detailType'],
    ['operationState', 'templateType'],
    ['operationTime', 'liveVersion'],
    /* 状态栏 */
    ['areaStr', 'detailType'],
    ['avoidHeight', 'extendType'],
    ['cutoutInfo', 'templateType'],
  ]);

  /* 需要上报运营的事件 */
  private static OPERATION_EVENT_TYPE: Set<MaintenanceRecordType> = new Set([
    MaintenanceRecordType.NOTIFICATION_RECEIVE,
    MaintenanceRecordType.NOTIFICATION_CLICK,
    MaintenanceRecordType.NOTIFICATION_DELETE
  ]);

  /* 不合并事件 */
  private static CAN_NOT_MERGE_EVENT: Set<MaintenanceRecordType> = new Set([
    MaintenanceRecordType.INTERFACE_EXCEPTION,
  ]);

  /* Map<上报类型, [打点信息]> */
  protected reportInfoMap: Map<MaintenanceRecordType, Record<string, string>[]> = new Map();

  public async report(reportInfo: MaintenanceReportInfo[]): Promise<void> {
    reportInfo.forEach((info) => this.addHaInfo(info.operationType, this.convertInfo(info)));
    this.reportInfoMap.forEach((infos, type) => {
      if (!infos.length) {
        return;
      }
      log.showInfo(`start report event (${type}), size ${infos.length}`);
      const reportType = HaReporter.OPERATION_EVENT_TYPE.has(type) ?
        [REPORT_TYPE.OPERATION, REPORT_TYPE.MAINTENANCE] : [REPORT_TYPE.MAINTENANCE];
      if (HaReporter.CAN_NOT_MERGE_EVENT.has(type)) {
        infos.forEach((info) => HaReportBase.get().reportHa(EVENT_NAME, reportType, info));
        return;
      }
      HaReportBase.get().reportHa(EVENT_NAME, reportType, this.mergeInfo(infos));
    });
  }

  protected addHaInfo(type: MaintenanceRecordType, info: Record<string, string>): void {
    if (!this.reportInfoMap.has(type)) {
      this.reportInfoMap.set(type, [info]);
      return;
    }
    this.reportInfoMap.get(type)?.push(info);
  }

  private mergeInfo(infos: Record<string, string>[]): Record<string, string> {
    const mergeInfo: Record<string, string> = {};
    const baseInfo = infos[0];
    // 遍历所有属性，如果每条打点某个属性都一致，合并上报
    // 如果有属性不一致，每个属性都上报，属性之间用|分割
    for (const key of HaReporter.HA_EVENT_PARAM) {
      const baseValue = baseInfo[key] ?? '';
      let mergeValue: string | undefined = undefined;
      let allSame = true; // 是否所有打点该字段都相同
      let allEmpty = true; // 是否所有打点该字段都为空
      for (const info of infos) {
        const value = (info[key] ?? '').replaceAll('\|', '_');
        // 属性之间用|分割
        mergeValue = mergeValue === undefined ? value : (mergeValue + '|' + value);
        if (value) {
          allEmpty = false;
        }
        if (value !== baseValue) {
          allSame = false;
        }
      }
      // 如果属性都一致，只上报一个值
      if (allSame) {
        mergeValue = baseValue;
      }
      if (!allEmpty) {
        mergeInfo[key] = mergeValue as string;
      }
    }
    mergeInfo.mergeNum = String(infos.length);
    return mergeInfo;
  }

  /**
   * 转换到HA上报字段
   * @param reportInfo 上报信息
   * @returns
   */
  protected convertInfo(reportInfo: MaintenanceReportInfo): Record<string, string> {
    const haInfo: Record<string, string> = {};
    haInfo.operationType = this.convertToString(reportInfo.operationType);
    if (!reportInfo.ext) {
      return haInfo;
    }
    for (const key of Object.keys(reportInfo.ext)) {
      const haKey = HaReporter.PARAM_KEY_MAP.get(key) ?? key;
      Reflect.set(haInfo, haKey, this.convertToString(Reflect.get(reportInfo.ext, key)));
    }
    if (!haInfo.deliveryTime) {
      haInfo.deliveryTime = reportInfo.eventTime;
    } else {
      // 通知提醒已有deliveryTime, 使用focusMode字段存事件上报时间
      haInfo.focusMode = reportInfo.eventTime;
    }
    return haInfo;
  }

  protected convertToString(value: Object): string {
    if (typeof value === 'string') {
      return value;
    } else if (typeof value === 'number' || typeof value === 'boolean') {
      return String(value);
    }
    return JSON.stringify(value);
  }
}