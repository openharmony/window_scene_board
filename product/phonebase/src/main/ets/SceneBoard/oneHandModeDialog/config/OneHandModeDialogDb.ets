/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import rdb from '@ohos.data.relationalStore';
import taskPool from '@ohos.taskpool';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, rdbStoreHelper } from '@ohos/frameworkwrapper';
import { BaseBundleInfo } from '@ohos/launchercommon/src/main/ets/bean/BaseBundleInfo';
import type Context from '@ohos.app.ability.common';
import { OneHandDialogConstants } from './OneHandModeDialogConstants';

const TAG: string = 'OneHandModeDialogDb';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class OneHandModeDialogDb {
  private static instance?: OneHandModeDialogDb;
  private popupCountCache?: Map<string, number>;

  private constructor() {
    this.initDb();
  }

  private async doTask(name: string, func: Function, ...args: Object[]): Promise<Object | undefined> {
    try {
      let context = GlobalContext.getContext();
      args.push(context);
      log.showWarn(`doTask start name: ${name}`);
      const dbTask = new taskPool.Task(name, func, ...args);
      return await taskPool.execute(dbTask);
    } catch (err) {
      log.showError(`doTask[${func.name}] name:[${name}] error ${err?.code}: ${err?.message}`);
    }
    return undefined;
  }

  private async initDb(): Promise<void> {
    rdbStoreHelper.executeSql(OneHandDialogConstants.CREATE_TABLE);
  }

  public async getOpenOneHandModeCount(): Promise<number> {
    if (!this.popupCountCache) {
      this.popupCountCache = await this.doTask('getDialogPopupCount', getAllPopupCount) as Map<string, number>;
    }
    return this.popupCountCache.get(OneHandDialogConstants.OPEN_ONE_HAND_MODE_NUM) ?? 0;
  }

  public async getDialogPopupCount(bundleInfo: BaseBundleInfo): Promise<number> {
    if (!this.popupCountCache) {
      this.popupCountCache = await this.doTask('getDialogPopupCount', getAllPopupCount) as Map<string, number>;
    }
    return this.popupCountCache.get(bundleInfo.bundleName) ?? 0;
  }

  public async setDialogPopupCount(bundleInfo: BaseBundleInfo, count: number): Promise<boolean> {
    if (!this.popupCountCache) {
      this.popupCountCache = new Map();
    }
    log.showInfo(`setDialogPopupCount bundleName: ${bundleInfo.bundleName}, count: ${count}`);
    this.popupCountCache.set(bundleInfo.bundleName, count);
    return (await this.doTask('setDialogPopupCount', setDialogPopupCount, bundleInfo, count)) as boolean;
  }

  public async deleteWithBundleInfo(bundleInfo: BaseBundleInfo): Promise<void> {
    this.popupCountCache?.delete(bundleInfo.bundleName);
    log.showInfo(`deleteWithBundleInfo bundleName: ${bundleInfo.bundleName}`);
    this.doTask('deleteWithBundleInfo', deleteWithBundleInfo, bundleInfo);
  }

  public static getInstance(): OneHandModeDialogDb {
    if (OneHandModeDialogDb.instance === undefined) {
      OneHandModeDialogDb.instance = new OneHandModeDialogDb();
    }
    return OneHandModeDialogDb.instance;
  }
}

async function getAllPopupCount(context: Context.BaseContext): Promise<Map<string, number>> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  let ret: Map<string, number> = new Map();
  try {
    let resultSet = await rdbStoreHelper.queryAll(OneHandDialogConstants.TABLE_NAME, context);
    while (resultSet.goToNextRow()) {
      let bundleName: string = resultSet.getString(resultSet.getColumnIndex(OneHandDialogConstants.BUNDLE_NAME));
      let popupCount: number = resultSet.getLong(resultSet.getColumnIndex(OneHandDialogConstants.POPUP_COUNT));
      ret.set(bundleName, popupCount);
    }
    resultSet.close();
    log.showInfo(`getDialogPopupCount: ${ret.size}`);
  } catch (err) {
    log.showError(`getDialogPopupCount err: ${err?.code}`);
  }
  return ret;
}

async function setDialogPopupCount(bundleInfo: BaseBundleInfo, count: number,
  context: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  let ret: boolean = false;
  try {
    let valuesBucket: rdb.ValuesBucket = {
      ['bundleName']: bundleInfo.bundleName,
      ['popupCount']: count,
    };
    let executeResult: number = 0;
    const predicates = new rdb.RdbPredicates(OneHandDialogConstants.TABLE_NAME);
    predicates.and().equalTo(OneHandDialogConstants.BUNDLE_NAME, bundleInfo.bundleName);
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    if (resultSet.goToNextRow()) {
      log.showInfo('setDialogPopupCount update');
      executeResult = await rdbStoreHelper.update(predicates, valuesBucket, context);
    } else {
      log.showInfo('setDialogPopupCount insert');
      executeResult = await rdbStoreHelper.insert(OneHandDialogConstants.TABLE_NAME, valuesBucket, context);
    }
    ret = executeResult > 0;
    log.showInfo(`setDialogPopupCount ret: ${ret}, executeRet: ${executeResult}`);
  } catch (err) {
    log.showError(`setDialogPopupCount err: ${err?.code}`);
  }
  return ret;
}

async function deleteWithBundleInfo(bundleInfo: BaseBundleInfo, context: Context.BaseContext): Promise<void> {
  'use concurrent';
  const predicates = new rdb.RdbPredicates(OneHandDialogConstants.TABLE_NAME);
  predicates.and().equalTo(OneHandDialogConstants.BUNDLE_NAME, bundleInfo.bundleName);
  await rdbStoreHelper.delete(predicates, context);
}
