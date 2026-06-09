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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import type { BusinessError } from '@ohos.base';
import type { NotificationEntry } from './NotificationEntry';
import { LogDomain, LogHelper, ArrayUtils, CommonUtils } from '@ohos/basicutils';
import { MemoryInfoUtil } from '@ohos/frameworkwrapper';
import type { NotificationBase } from '@ohos/systemuicommon/src/main/ets/model/NotificationBase';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';

const TAG: string = 'NotificationListLimiter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export const SINGLE_APP_LIMIT: number = 24;

const MEMORY_SIZE: number = MemoryInfoUtil.getMemoryTotalSize();

const NTF_COUNT_LIMIT_LESS_4G: number = 50;

const NTF_COUNT_LIMIT_4G: number = 70;

const NTF_COUNT_LIMIT_MORE_4G: number = 90;

// 4G is the memory base
const MEM_SIZE_BASE: number = 4 * 1024 * 1024 * 1024;

// 0.5G is memory offset
const MEM_SIZE_OFFSET: number = 512 * 1024 * 1024;

// 用增不折叠消息数量默认值
export const CAMPAIGN_NO_FOLDS_MAX_NUM_DEFAULT: number = 5;

/**
 * 限制通知列表通知条数
 *
 * @since 2023-03-20
 */
export default class NotificationListLimiter<T extends NotificationEntry | NotificationBase = NotificationEntry> {
  private readonly notificationLimit: number = NotificationListLimiter.getNtfLimit();

  /**
   * 用增不折叠消息最大数量
   */
  private campaignNoFoldsMaxNum: number = this.initCampaignNoFoldsMaxNum();

  /**
   * 初始化用增不折叠消息最大数量值
   *
   * @returns 用增不折叠消息最大数量值
   */
  public initCampaignNoFoldsMaxNum(): number {
    let maxNum: number = CAMPAIGN_NO_FOLDS_MAX_NUM_DEFAULT;
    try {
      maxNum = Number(systemParameterEnhance.getSync('const.campaign.no_folds_max_num',
        String(CAMPAIGN_NO_FOLDS_MAX_NUM_DEFAULT)));
    } catch (err) {
      log.showError(`initCampaignNoFoldsMaxNum create error:${err}`);
    }
    return maxNum;
  }

  constructor() {
    log.showInfo(`total limit: ${this.notificationLimit}, app limit: ${SINGLE_APP_LIMIT}`);
  }

  /**
   * 删除超限通知，返回删除的通知集合
   *
   * @param notificationMap 通知全集
   * @return 删除的通知集合
   */
  limit(notificationMap?: Map<string, T>[]): Array<T> {
    let deleteItems: T[] = [];
    const validMaps = notificationMap?.filter(it => !CommonUtils.isInvalid(it)) ?? [];

    if (validMaps.length > 0) {
      this.limitByApplication(validMaps, deleteItems);
      this.limitTotal(validMaps, deleteItems);
      let campaignNtfListForDelete = this.limitNoGroupNumForCampaignNtf(validMaps);
      if (campaignNtfListForDelete && campaignNtfListForDelete.length > 0) {
        deleteItems.push(...campaignNtfListForDelete);
      }
    }

    return deleteItems;
  }

  /**
   * 限制同一个APP的用增不折叠展示的消息数量
   *
   * @param notificationMap 消息通知集合
   * @returns 多余的待删除的用增不折叠展示的消息集合
   */
  public limitNoGroupNumForCampaignNtf(notificationMap: Map<string, T>[]): Array<T> {
    let listForDelete: T[] = [];
    if (!notificationMap || notificationMap.length === 0) {
      log.showInfo(`notificationMap is empty`);
      return listForDelete;
    }
    let noGroupCampaignNtfList: T[] = [];
    // 1.过滤出所有的用增不置顶不分组的消息列表
    notificationMap.forEach((entryMap, hashCode) => {
      noGroupCampaignNtfList.push(...this.filterNoGroupCampaignNtfList(entryMap));
    });
    if (noGroupCampaignNtfList.length === 0) {
      log.showInfo(`noGroupCampaignNtfList is empty`);
      return listForDelete;
    }
    // 2.按照creatorUid分组
    let campaignNtfNoGroupMap: Map<number, T[]> = this.groupNtfListByCreatorUid(noGroupCampaignNtfList);
    if (campaignNtfNoGroupMap.size === 0) {
      return listForDelete;
    }
    // 3.遍历每个分组，倒序排序，移除超过最大数量限制数量的通知
    campaignNtfNoGroupMap.forEach((noGroupArray, uid) => {
      if (noGroupArray.length <= this.campaignNoFoldsMaxNum) {
        return;
      }
      noGroupArray.sort((a, b) => {
        return b.deliveryTime - a.deliveryTime;
      });
      // 4、如果超过最大数量限制，则按时间倒序，移除掉最早的多余的通知
      for (let index = this.campaignNoFoldsMaxNum; index < noGroupArray.length; index++) {
        log.showInfo(`need del ntf of campaign:${noGroupArray[index].groupName}}`);
        listForDelete.push(noGroupArray[index]);
      }
    });
    return listForDelete;
  }

  /**
   * 过滤出不折叠展示的用增消息
   *
   * @param entryMap 通知消息列表
   * @returns
   */
  private filterNoGroupCampaignNtfList(entryMap: Map<string, T>): Array<T> {
    let noGroupCampaignNtfList: T[] = [];
    if (entryMap.size === 0) {
      log.showInfo(`entryMap is empty`);
      return noGroupCampaignNtfList;
    }
    entryMap.forEach(entryTmp => {
      // 用增消息 + 非置顶标识 + 不折叠（指定了分组名的消息）
      log.showInfo(`controlFlag:${entryTmp.controlConfig?.flags}, groupName:${entryTmp.groupName}`);
      if (entryTmp.controlConfig.isNoTopCampaignNtf() && !entryTmp.isDefaultGroupName()) {
        noGroupCampaignNtfList.push(entryTmp);
      }
    });
    return noGroupCampaignNtfList;
  }

  /**
   * 根据creatorUid 分组通知消息
   *
   * @param noGroupCampaignNtfList 不分组展示的用增通知消息列表
   * @returns 不分组的用增通知消息键值对 uid -> NotificationEntry[]
   */
  private groupNtfListByCreatorUid(noGroupCampaignNtfList: T[]): Map<number, T[]> {
    let ntfGroupMapByCreatorUid: Map<number, T[]> = new Map();
    if (noGroupCampaignNtfList.length === 0) {
      log.showInfo(`ntfGroupMapByCreatorUid is empty`);
      return ntfGroupMapByCreatorUid;
    }
    noGroupCampaignNtfList.forEach((entry: T) => {
      if (ntfGroupMapByCreatorUid.has(entry.creatorUid)) {
        ntfGroupMapByCreatorUid.get(entry.creatorUid)?.push(entry);
      } else {
        let tmpArray: T[] = [entry];
        ntfGroupMapByCreatorUid.set(entry.creatorUid, tmpArray);
      }
    });
    return ntfGroupMapByCreatorUid;
  }

  /**
   * 按App删除超过单个App最大数量限制限通知，返回删除的通知集合
   *
   * @param notificationMap 通知全集
   * @param deleteItems 存放删除的通知
   */
  private limitByApplication(
    notificationMap: Map<string, T>[],
    deleteItems: Array<T>
  ): void {
    let notificationArray: T[] = [];
    notificationMap.forEach((item) => {
      for (let value of item.values()) {
        notificationArray.push(value);
      }
    });
    let applicationMap: Map<number, Array<T>> = new Map();
    notificationArray.forEach((item: T) => {
      if (!applicationMap.get(item.creatorUid ?? 0)) {
        applicationMap.set(item.creatorUid ?? 0, []);
      }
      applicationMap.get(item.creatorUid ?? 0)?.push(item);
    });
    let limit: number = SINGLE_APP_LIMIT;
    applicationMap.forEach((value: Array<T>, key: number) => {
      log.showInfo(`key:${key} value:${value.length}`);
      if (value.length > limit) {
        this.sortNotification(value);
        let deleteArr: T[] = value.splice(limit, value.length - limit);
        if (!ArrayUtils.isEmpty(deleteArr)) {
          deleteItems.push(...deleteArr);
          log.showInfo(`app: ${key}, after splice length = ${applicationMap.get(key)?.length}`);
        }
      }
    });
    deleteItems.forEach((item) => {
      notificationMap.forEach((ntfGroup) => {
        ntfGroup.delete(item.hashCode ?? '');
      });
    });
  }

  /**
   * 删除超过总数限制的通知
   *
   * @param notificationMap 通知全集
   * @param deleteItems 存放删除的通知
   */
  private limitTotal(
    notificationMap: Map<string, T>[],
    deleteItems: Array<T>
  ): void {
    let limit = this.notificationLimit;
    let totalSize = 0;
    notificationMap.forEach((item) => {
      totalSize += item.size;
    });
    if (totalSize <= limit) {
      return;
    }
    let ntfArray: T[] = [];
    notificationMap.forEach((item) => {
      for (let value of item.values()) {
        ntfArray.push(value);
      }
    });
    if (ArrayUtils.isEmpty(ntfArray) || ntfArray.length <= limit) {
      return;
    }
    this.sortNotification(ntfArray);
    let deleteArray: T[] = ntfArray.splice(limit, ntfArray.length - limit);
    if (ArrayUtils.isEmpty(ntfArray)) {
      return;
    }
    deleteArray.forEach((item) => {
      notificationMap.forEach((ntfGroup) => {
        ntfGroup.delete(item.hashCode ?? '');
      });
    });
    deleteItems.push(...deleteArray);
  }

  private sortNotification(notificationArray: Array<T>): void {
    if (ArrayUtils.isEmpty(notificationArray)) {
      return;
    }
    notificationArray.sort((entryA, entryB): number => {
      // 不可删除的通知排序靠前
      if (entryA.isRemoveAllowed !== entryB.isRemoveAllowed) {
        return !entryA.isRemoveAllowed ? -1 : 1;
      }
      // ongoing通知排序靠前
      if (entryA.isOngoing !== entryB.isOngoing) {
        return entryA.isOngoing ? -1 : 1;
      }
      if (entryA.isDisplayAtTop !== entryB.isDisplayAtTop) {
        return entryA.isDisplayAtTop ? -1 : 1;
      }
      // ongoing、普通通知按时间排序
      return (entryB.deliveryTime ?? 0) - (entryA.deliveryTime ?? 0);
    });
  }

  private static getNtfLimit(): number {
    let ntfItemMaxNum = NTF_COUNT_LIMIT_MORE_4G;
    try {
      let maxNumStr = systemParameterEnhance.getSync('const.systemui.notification_count');
      ntfItemMaxNum = parseInt(maxNumStr);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      LogWithHa.warn(log, `read config file failed, error code: ${code}, message: ${message}.`,
        NotificationExceptionCode.SYS_PARAM_ERROR, error);
    }

    if (MEMORY_SIZE < (MEM_SIZE_BASE - MEM_SIZE_OFFSET)) {
      return Math.min(NTF_COUNT_LIMIT_LESS_4G, ntfItemMaxNum);
    } else if (MEMORY_SIZE < (MEM_SIZE_BASE + MEM_SIZE_OFFSET)) {
      return Math.min(NTF_COUNT_LIMIT_4G, ntfItemMaxNum);
    } else {
      return ntfItemMaxNum;
    }
  }
}