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

import {
  LogDomain,
  LogHelper,
  LogWithHa,
  NotificationConfigEntity
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { SettingExceptionCode } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SettingExceptionCode';
import { osAccount } from '@kit.BasicServicesKit';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';

const TAG = 'NtfSearchController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

// 索引名称
const indexName: string = 'sysApp';
// 分页起始值
const offset: number = 0;
// 分页大小
const size: number = 100;
// 输出字段
const outFields = ['bundleName', 'appName', 'sourceChannel', 'appIndex'];
// 检索字段是应用名
const queryFieldName: string = 'appName';

/**
 * 默认用户ID
 */
const DEFAULT_USER_ID = 100;

export interface ResultItemInfo {
  bundleName: string,
  appName: string,
  sourceChannel: string,
  appIndex?: number
}

export interface ResultItemInfoTask {
  searchKey: string,
  resultList: ResultItemInfo[]
}

export class NtfSearchController {
  private accountManager?: osAccount.AccountManager;
  public userId: number = DEFAULT_USER_ID;

  init(): void {
    this.userId = this.getUserIdFromUid(ContextManager.context.applicationInfo.uid);

    log.showInfo('Init');
  }

  /**
   * 根据uid获取userId
   * @param uid
   * @returns
   */
  protected getUserIdFromUid(uid: number): number {
    if (!this.accountManager) {
      this.accountManager = osAccount.getAccountManager();
    }
    return this.accountManager.getOsAccountLocalIdForUidSync(uid);
  }

  /**
   * 提交并搜索
   * @param input
   * @returns
   */
  public async inputChangeEvent(input: string, searchChannel?: string): Promise<ResultItemInfoTask> {
    log.showInfo(`inputChangeEvent start, input: ${input}, searchChannel: ${searchChannel ?? 'undefined'}`);
    let resultList = await this.getSearchResult(input, searchChannel);
    let query: ResultItemInfoTask = {
      resultList: resultList,
      searchKey: input
    };
    log.showInfo(`inputChangeEvent end, result count: ${resultList.length}`);
    return query;
  }

  /**
   * 获取搜索结果
   * @param value
   * @returns
   */
  async getSearchResult(value: string, searchChannel?: string): Promise<ResultItemInfo[]> {
    try {
      log.showInfo(`getSearchResult start, value: ${value}, userId: ${this.userId}, searchChannel: ${searchChannel ?? 'undefined'}`);
      if (!value || value.trim().length === 0) {
        log.showInfo('getSearchResult: search value is empty, return empty list');
        return [];
      }

      const searchValue = value.trim();
      log.showInfo(`getSearchResult: searchValue after trim: ${searchValue}`);
      
      const predicates = NotificationConfigEntity.getPredicates()
        .inCondition({ userId: [this.userId, DEFAULT_USER_ID] })
        .equalTo({ isDeliver: false })
        .beginWrap()
        .like({ label: searchValue })
        .or()
        .like({ bundle: searchValue })
        .endWrap()
        .orderByAsc('sortTag');

      log.showInfo(`getSearchResult: query with predicates, userId: [${this.userId}, ${DEFAULT_USER_ID}], searchValue: ${searchValue}`);
      const liveViewAppList = await NotificationConfigEntity.queryList(predicates);
      log.showInfo(`getSearchResult: query result count: ${liveViewAppList.length}`);
      
      const filteredList = liveViewAppList.filter((config) => config.settingIgnore === false);
      log.showInfo(`getSearchResult: after filter settingIgnore=false, count: ${filteredList.length}`);
      
      const result = new Map<number, NotificationConfigEntity>();
      for (const item of filteredList) {
        if (result.has(item.uid)) {
          log.showInfo(`Delete repeat config for uid: ${item.uid}, bundle: ${item.bundle}`);
          result.get(item.uid)?.delete();
        }
        result.set(item.uid, item);
      }
      const appList = Array.from(result.values());
      log.showInfo(`getSearchResult: after deduplicate by uid, count: ${appList.length}`);

      const resultList: ResultItemInfo[] = appList.map((config) => {
        return {
          bundleName: config.bundle,
          appName: config.label,
          sourceChannel: searchChannel ?? '2',
          appIndex: config.appIndex
        } as ResultItemInfo
      });

      log.showInfo(`getSearchResult: final result count: ${resultList.length}`);
      if (resultList.length > 0) {
        log.showInfo(`getSearchResult: first result - bundleName: ${resultList[0].bundleName}, appName: ${resultList[0].appName}`);
      }
      return resultList;
    } catch (error) {
      LogWithHa.error(log, `getSearchResult faild code: ${error?.code}, message: ${error?.message}`,
        SettingExceptionCode.GET_SEARCH_RESULT_FAIL, error);
    }
    return [];
  }
}

