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

import { LogDomain, CheckEmptyUtils, PixelMapUtil, Logger } from '@ohos/basicutils';
import { IconCacheInterface } from '../IconCacheInterface';
import IconInfo, { IconDatabaseColumn, IconPicType } from '../IconInfo';
import rdb from '@ohos.data.relationalStore';
import RdbStoreConfig from '../../service/db/RdbStoreConfig';
import { GlobalContext } from '../../utils/GlobalContext';
import bundleManager from '@ohos.bundle.bundleManager';
import commonBundleManager from '../../manager/CommonBundleManager';
import type Context from '@ohos.app.ability.common';
import { image } from '@kit.ImageKit';
import { GraphicUtils } from '../GraphicsUtils';
import type common from '@ohos.app.ability.common';
import { contextConstant } from '@kit.AbilityKit';
import { ContextModifyUtils } from './../../utils/ContextModifyUtils';
import { IconExtendParam } from '../IconExtendParam';
import { HashMap } from '@kit.ArkTS';
import { DataTaskPool } from '../fwk/DataTaskPool';

const TAG = 'DbCache';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

export class DbCache implements IconCacheInterface {
  private mRdbStore: rdb.RdbStore;
  private static sInstance: DbCache;

  static getInstance(): DbCache {
    if (!DbCache.sInstance) {
      DbCache.sInstance = new DbCache();
    }
    return DbCache.sInstance;
  }

  private getTableName(): string {
    return RdbStoreConfig.iconInfo.tableName;
  }

  async getCombIcon(bundleName: string, moduleName: string, abilityName: string, param: IconExtendParam):
    Promise<IconInfo> {
    let iconInfo = new IconInfo();
    if (this.noCacheDb(param.appIndex, moduleName, abilityName, param.hasBorder)) {
      // 只有分身应用appIndex大于0，分身应用图标只存缓存不存数据库
      return iconInfo;
    }
    log.showInfo(TAG, `getCombIconFromDb ${bundleName}, tableName ${this.getTableName()}`);
    return await this.getIconResource(bundleName, moduleName, abilityName, param.appIndex, true);
  }

  private noCacheDb(appIndex: number, moduleName: string, abilityName: string, hasBorder: boolean): boolean {
    return appIndex > 0 ||
      (CheckEmptyUtils.checkStrIsEmpty(moduleName) && CheckEmptyUtils.checkStrIsEmpty(abilityName) && !hasBorder);
  }

  getCombIconSync(bundleName: string, moduleName: string, abilityName: string, appIndex?: number): image.PixelMap {
    return undefined;
  }

  async getIconResource(bundleName: string, moduleName: string, abilityName: string,
                        appIndex?: number, combIconFlag?: boolean): Promise<IconInfo> {
    if (appIndex > 0) {
      return undefined;
    }
    moduleName = moduleName ?? '';
    abilityName = abilityName ?? '';
    let resultSet = undefined;
    let resultIcon: IconInfo = new IconInfo();
    if (this.mRdbStore === undefined && !(await this.createRdbStore())) {
      return resultIcon;
    }
    log.showInfo(TAG, `getIconResource ${bundleName} ${moduleName} ${abilityName}, tableName: ${this.getTableName()}`);
    try {
      let predicates = new rdb.RdbPredicates(this.getTableName());
      // 按照列升序查询
      predicates.equalTo(IconDatabaseColumn.BUNDLE_NAME, bundleName)
        .and()
        .equalTo(IconDatabaseColumn.MODULE_NAME, moduleName)
        .and()
        .equalTo(IconDatabaseColumn.ABILITY_NAME, abilityName);
      resultSet = await this.mRdbStore?.query(predicates);
      while (resultSet.goToNextRow()) {
        resultIcon.combinePic = resultSet.getString(resultSet.getColumnIndex(IconDatabaseColumn.COMBINE_PIC));
        if (combIconFlag) {
          resultIcon.combinePicSrc = await GraphicUtils.changeBase64ToPixel(resultIcon.combinePic);
          PixelMapUtil.addName(resultIcon.combinePicSrc, 'DbCache_getIconResource');
        }
        resultIcon.appVersion = resultSet.getString(resultSet.getColumnIndex(IconDatabaseColumn.APP_VERSION));
        resultIcon.adaptivePic.push(resultSet.getString(resultSet.getColumnIndex(IconDatabaseColumn.BACK_PIC)));
        resultIcon.adaptivePic.push(resultSet.getString(resultSet.getColumnIndex(IconDatabaseColumn.FORE_PIC)));
        resultIcon.iconType = <IconPicType> resultSet.getString(resultSet.getColumnIndex(IconDatabaseColumn.ICON_TYPE));
        log.showWarn(TAG, `getCombIcon bundleName: ${bundleName}, ${moduleName}, ${abilityName}, combinePicLength:${resultIcon.combinePic?.length}`);
      }
      resultSet.close();
      resultSet = null;
      log.showInfo(TAG, 'getIconResource resultSet closed');
    } catch (e) {
      log.showError(TAG, `getIconResource error:${e}`);
    } finally {
      if (!CheckEmptyUtils.isEmpty(resultSet)) {
        resultSet.close();
        resultSet = null;
        log.showInfo(TAG, 'getIconResource resultSet closed');
      }
    }
    return resultIcon;
  }

  // 避免在子线程中调用此方法
  async setIconResource(bundleName: string, moduleName: string, abilityName: string, iconInfo: IconInfo,
    param: IconExtendParam): Promise<void> {
    if (this.noCacheDb(param.appIndex, moduleName, abilityName, param.hasBorder) ||
        CheckEmptyUtils.checkStrIsEmpty(iconInfo.combinePic)) {
      log.showWarn(TAG, `not need set to dbcache, icon is empty:${CheckEmptyUtils.checkStrIsEmpty(iconInfo.combinePic)}`);
      return;
    }
    moduleName = moduleName ?? '';
    abilityName = abilityName ?? '';
    if (this.mRdbStore === undefined && !(await this.createRdbStore())) {
      return;
    }
    let appVersion = await this.getVersionByBundleName(bundleName);
    if (CheckEmptyUtils.isEmpty(appVersion)) {
      appVersion = '';
    }
    let insertIconInfo = {
      [IconDatabaseColumn.BUNDLE_NAME]: bundleName,
      [IconDatabaseColumn.MODULE_NAME]: moduleName,
      [IconDatabaseColumn.ABILITY_NAME]: abilityName,
      [IconDatabaseColumn.ICON_TYPE]: iconInfo.iconType,
      [IconDatabaseColumn.FORE_PIC]: iconInfo.adaptivePic[1],
      [IconDatabaseColumn.BACK_PIC]: iconInfo.adaptivePic[0],
      [IconDatabaseColumn.COMBINE_PIC]: iconInfo.combinePic,
      [IconDatabaseColumn.APP_VERSION]: appVersion,
    };
    try {
      await this.mRdbStore?.executeSql(RdbStoreConfig.iconInfo.createTable);
      let changeRows =
        await this.mRdbStore?.insert(this.getTableName(), insertIconInfo,
          rdb.ConflictResolution.ON_CONFLICT_REPLACE);
      const combinePicLength = iconInfo.combinePic?.length;
      const foregroundLength = iconInfo.adaptivePic[1]?.length;
      const backgroundLength = iconInfo.adaptivePic[0]?.length;
      log.showWarn(TAG, `setIconResource, tableName: ${this.getTableName()} insert: ${changeRows} iconInfo.iconType ${iconInfo.iconType},` +
        `bundleName ${bundleName} combinePicLength:${combinePicLength}, ` +
        `foregroundLength:${foregroundLength}, backgroundLength:${backgroundLength}`);
    } catch (e) {
      log.showError(TAG, `insert error: ${e}, bundleName: ${bundleName}, ${moduleName}, ${abilityName}`);
    }
  }

  public async setIconResourceBatch(iconInfos: IconInfo[]): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(iconInfos)) {
      log.showWarn(TAG, 'iconInfos is empty!');
      return;
    }
    if (this.mRdbStore === undefined && !(await this.createRdbStore())) {
      return;
    }
    for (let iconInfo of iconInfos) {
      if (CheckEmptyUtils.checkStrIsEmpty(iconInfo.combinePic)) {
        log.showWarn(TAG, `combinePic is empty. bundleName is ${iconInfo.bundleName}`);
        continue;
      }
      let appVersion = await this.getVersionByBundleName(iconInfo.bundleName);
      if (CheckEmptyUtils.isEmpty(appVersion)) {
        appVersion = '';
      }
      let insertIconInfo = {
        [IconDatabaseColumn.BUNDLE_NAME]: iconInfo.bundleName,
        [IconDatabaseColumn.MODULE_NAME]: iconInfo.moduleName ?? '',
        [IconDatabaseColumn.ABILITY_NAME]: iconInfo.abilityName ?? '',
        [IconDatabaseColumn.ICON_TYPE]: iconInfo.iconType,
        [IconDatabaseColumn.FORE_PIC]: iconInfo.adaptivePic[1],
        [IconDatabaseColumn.BACK_PIC]: iconInfo.adaptivePic[0],
        [IconDatabaseColumn.COMBINE_PIC]: iconInfo.combinePic,
        [IconDatabaseColumn.APP_VERSION]: appVersion,
      };
      try {
        let tableName: string = RdbStoreConfig.iconInfo.tableName;
        let changeRows =
          await this.mRdbStore?.insert(tableName, insertIconInfo, rdb.ConflictResolution.ON_CONFLICT_REPLACE);
        const combinePicLength = iconInfo.combinePic?.length;
        const foregroundLength = iconInfo.adaptivePic[1]?.length;
        const backgroundLength = iconInfo.adaptivePic[0]?.length;
        log.showWarn(TAG, `setIconResourceBatch, tableName: ${tableName} insert: ${changeRows} iconInfo.iconType ${iconInfo.iconType},` +
          `bundleName ${iconInfo.bundleName} combinePicLength:${combinePicLength}, ` +
          `foregroundLength:${foregroundLength}, backgroundLength:${backgroundLength}`);
      } catch (e) {
        log.showError(TAG, `insert error: ${e}, bundleName: ${iconInfo.bundleName}, ${iconInfo.moduleName}, ${iconInfo.abilityName}`);
      }
    }
  }

  public async setIconResourceArray(iconInfos: IconInfo[], batchId: number, allFinished: () => void): Promise<void> {
    log.showWarn(TAG, 'setIconResourceArray info size: %{public}d, batchId: %{public}d', iconInfos.length, batchId);
    DataTaskPool.getInstance().startBatchInsertInfo(iconInfos, batchId, allFinished);
  }

  async getIconByBundles(bundles: Array<string>, queryOnlyByBundleName: boolean = false): Promise<HashMap<string, string>> {
    let result: HashMap<string, string> = new HashMap();

    if (this.mRdbStore === undefined && !(await this.createRdbStore())) {
      log.showWarn(TAG, `db init unfinished!`);
      return result;
    }

    let resultSet = undefined;
    try {
      let predicates = new rdb.RdbPredicates(RdbStoreConfig.iconInfo.tableName);
      // 按照列升序查询
      if (queryOnlyByBundleName) {
        predicates.in(IconDatabaseColumn.BUNDLE_NAME, bundles);
      } else {
        predicates.in(IconDatabaseColumn.BUNDLE_NAME, bundles)
          .and().equalTo(IconDatabaseColumn.MODULE_NAME, '')
          .and().equalTo(IconDatabaseColumn.ABILITY_NAME, '');
      }

      resultSet = await this.mRdbStore?.query(predicates);
      while (resultSet.goToNextRow()) {
        result.set(resultSet.getString(resultSet.getColumnIndex(IconDatabaseColumn.BUNDLE_NAME)),
          resultSet.getString(resultSet.getColumnIndex(IconDatabaseColumn.COMBINE_PIC)));
      }
      log.showWarn(TAG, `query from db, bundles length ${bundles.length} result length ${result.length} resultSet ${resultSet?.rowCount}`);
      resultSet.close();
      resultSet = null;
    } catch (e) {
      log.showError(TAG, `getIconResource error:${e}`);
    } finally {
      if (!CheckEmptyUtils.isEmpty(resultSet)) {
        resultSet.close();
        resultSet = null;
      }
    }
    return result;
  }

  private async getVersionByBundleName(bundleName:string): Promise<string> {
    let bundleInfo: bundleManager.BundleInfo = await commonBundleManager.getBundleInfoByBundleName(bundleName);
    return bundleInfo?.versionName;
  }

  async deleteAllCache(): Promise<void> {
    log.showWarn(TAG, 'deleteAllDbCache start');
    if (this.mRdbStore === undefined && !(await this.createRdbStore())) {
      log.showWarn(TAG, 'db init unfinished! deleteAllDbCache failed!');
      return;
    }
    await this.mRdbStore?.executeSql(RdbStoreConfig.iconInfo.dropTable);
    log.showWarn(TAG, 'deleteAllDbCache end');
  }

  async deleteCache(bundleName: string): Promise<void> {
    if (this.mRdbStore === undefined && !(await this.createRdbStore()) || CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn(TAG, `delete dbcache failed, bundleName: ${bundleName}`);
      return;
    }
    try {
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.iconInfo.tableName);
      predicates.equalTo(IconDatabaseColumn.BUNDLE_NAME, bundleName);
      const changeRows = await this.mRdbStore?.delete(predicates);
      if (changeRows >= 1) {
        log.showWarn(TAG, `deleteIconResourceByBundle delete success, the row number is :${changeRows}`);
      }
    } catch (e) {
      log.showError(TAG, `deleteCache catch error: ${e}`);
    }
  }

  /**
   * createRdbStore
   *
   * @returns Promise<void>
   */
  public async createRdbStore(): Promise<boolean> {
    let context = GlobalContext.getInstance().getObject('desktopContext') as Context.BaseContext;
    if (CheckEmptyUtils.isEmpty(context)) {
      log.showError(TAG, 'createRdbStore context is undefined');
      return false;
    }
    let result = true;
    if (this.mRdbStore !== undefined) {
      log.showInfo(TAG, 'createRdbStore -> rdbStore exist');
      return result;
    }

    let callback: Function = async (callbackContext: common.Context) => {
      try {
        // @ts-ignore
        this.mRdbStore = await rdb.getRdbStore(callbackContext, {
          name: RdbStoreConfig.dbName,
          securityLevel: rdb.SecurityLevel.S1,
          // @ts-ignore
          haMode: rdb.HAMode.MAIN_REPLICA,
          allowRebuild: true,
          isSearchable: true
        });
        log.showInfo(TAG, 'createRdbStore -> getRdbStore success');
      } catch (error) {
        log.showError(TAG, `createRdbStore catch error: ${error}`);
        result = false;
      }
    };
    await ContextModifyUtils.modifyTargetContextAsync(context as common.Context, contextConstant.AreaMode.EL1,
      callback, `${TAG}-createRdbStore`);
    return result;
  }

  async setIconNameResource(bundleName: string, moduleName: string, abilityName: string,
    appName: string, appIndex?: number): Promise<void> {
  }
}

export const dbCache = DbCache.getInstance();