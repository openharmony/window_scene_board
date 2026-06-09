/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
// @ts-ignore
import SearchClient from '@ohos.fusionsearchclient';
import GlobalSearchConfig from '../configs/GlobalSearchConfig';
import { SearchItemInfo } from '../bean/SearchItemInfo';

const TAG = 'GlobalSearchStoreManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Wrapper class for rdb interfaces.
 */
export class GlobalSearchStoreManager {

  private constructor() {
  }

  /**
   * db manager instance
   *
   * @return rdbStoreManager instance
   */
  static getInstance(): GlobalSearchStoreManager {
    if (globalThis.GlobalSearchStoreManager == null) {
      globalThis.GlobalSearchStoreManager = new GlobalSearchStoreManager();
    }
    return globalThis.GlobalSearchStoreManager;
  }

  /**
   * search app data
   *
   * @param {string} bundleName
   * @return {object} searchRecords
   */
  async searchApp(bundleName: string): Promise<SearchItemInfo[]> {
    log.showInfo('start searchRecord......');
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn('bundleName is null');
      return [];
    }
    //构造搜索query
    let searchQuery = new SearchClient.Query();
    searchQuery.setIndexName(GlobalSearchConfig.indexName);
    let queryValues = new Array();
    queryValues[0] = bundleName;
    searchQuery.query(GlobalSearchConfig.bundleName, queryValues, GlobalSearchConfig.term);
    searchQuery.sizeAs(1);
    let outFieldNames = GlobalSearchConfig.outFieldNames;
    searchQuery.outFields(outFieldNames);
    // 获取检索结果
    let searchManager = await SearchClient.createSearchSession();
    let searchResult = await searchManager.search(searchQuery);
    let searchRecords = searchResult?.records || [];
    log.showInfo(`searchRecords length is ${searchRecords.length}`);
    return searchRecords;
  }

  /**
   * batch insert data
   *
   * @param {array} SearchItemInfo[]
   */
  async insertSysAppBatch(searchItemList: SearchItemInfo[]): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(searchItemList)) {
      log.showWarn('appInfo or bundleName is null');
      return;
    }
    // 开始插入数据
    let dataManager = await SearchClient.getIndexManager();
    await dataManager.insert(GlobalSearchConfig.indexName, searchItemList).then(data => {
      log.showInfo('insert success');
    }).catch(error => {
      log.showError(`error: ${error}`);
    });
  }

  /**
   * batch update data
   *
   * @param {array} SearchItemInfo[]
   */
  async updateSysAppBatch(searchItemList: SearchItemInfo[]): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(searchItemList)) {
      log.showWarn('appInfo or bundleName is null');
      return;
    }
    // 开始更新数据
    let dataManager = await SearchClient.getIndexManager();
    try {
      await dataManager.update(GlobalSearchConfig.indexName, searchItemList);
      log.showInfo('update success');
    } catch (error) {
      log.showError(`error: ${error}`);
    }
  }

  /**
   * batch delete data
   *
   * @param {array} SearchItemInfo[]
   */
  async deleteRecordBatch(searchItemList: SearchItemInfo[]): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(searchItemList)) {
      log.showWarn('appInfo or bundleName is null');
      return;
    }
    let dataManager = await SearchClient.getIndexManager();
    await dataManager.delete(GlobalSearchConfig.indexName, searchItemList).then(data => {
      log.showInfo('deleteRecordBatch success' );
    }).catch(error => {
      log.error('error: ', error);
    });
  }

  async releaseService(): Promise<void> {
    try {
      SearchClient.releaseService();
    } catch (error) {
      log.error('releaseService error: ', error);
    }
  }
}