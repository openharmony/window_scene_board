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

import rdb from '@ohos.data.relationalStore';
import RdbStoreConfig from './RdbStoreConfig';
import util from '@ohos.util';
import type Context from '@ohos.app.ability.common';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '../../utils/GlobalContext';
import type ctx from '@ohos.app.ability.common';
import { SCBConstants } from '@ohos/commonconstants';
import { HiDfxEventUtil } from '../../hisysevent/HiDfxEventUtil';
import type common from '@ohos.app.ability.common';
import { contextConstant } from '@kit.AbilityKit';
import { ContextModifyUtils } from '../../utils/ContextModifyUtils';
import { CommonUtils } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { settings } from '@kit.BasicServicesKit';
import DeviceInfo from '@ohos.deviceInfo';
import { DBErrorCode } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { HashSet } from '@kit.ArkTS';

const TAG = 'RdbStoreHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const LAUNCHER_DB_SQL_VERSION = 'launcher_db_sql_version';
const DEVICE_DISTRIBUTION_OS_API_VERSION = 'device_distribution_os_api_version';
const SCHEMA_VERSION = '2.1';
const GRIDLAYOUT_INFO = 'gridlayout_info';
const SPLIT_LENGTH = 500;

/**
 * db helper provide basic db operation include init, and upgrade
 */
export class RdbStoreHelper {
  private mRdbStore: rdb.RdbStore;

  private mStartVersion: number;
  private mLatestVersion: number;
  private mSqlVersion: number;
  private mLatestSqlVersion: number;

  constructor() {
  }

  /**
   * db helper instance
   *
   * @return rdbStoreHelper instance
   */
  public static getInstance(): RdbStoreHelper {
    if (globalThis.RdbStoreHelperInstance == null) {
      globalThis.RdbStoreHelperInstance = new RdbStoreHelper();
    }
    return globalThis.RdbStoreHelperInstance;
  }

  private getUpgradeSqlVersion(): number {
    let sqlVersion: number = 0;
    let deviceVersion: string = '';
    let currentDeviceVersion: string = '';
    try {
      deviceVersion = settings.getValueSync((GlobalContext.getContext()), DEVICE_DISTRIBUTION_OS_API_VERSION, '');
      currentDeviceVersion = DeviceInfo.distributionOSApiVersion.toString();
      if (CheckEmptyUtils.isEmpty(currentDeviceVersion)) {
        // 异常场景：从DeviceInfo获取数据为空。提交异常打点，为保证数据不丢失，小版本从0开始。
        log.showError(`getUpgradeSqlVersion get currentDeviceVersion:${currentDeviceVersion} is empty and reutn sqlVersion 0!`);
        HiDfxEventUtil.reportRDBAbnormal(DBErrorCode.DEVICE_VERSION_GET_FAILED, `DeviceInfo distributionOSVersion:${currentDeviceVersion} is empty`);
        settings.setValueSync((GlobalContext.getContext()), LAUNCHER_DB_SQL_VERSION, sqlVersion.toString(), settings.domainName.USER_PROPERTY);
        return sqlVersion;
      }
      if (CheckEmptyUtils.isEmpty(deviceVersion) || deviceVersion !== currentDeviceVersion) {
        // 第一次赋值或者设备版本不一致时，保证数据不丢失，冗余操作，小版本从0开始。
        settings.setValueSync((GlobalContext.getContext()), DEVICE_DISTRIBUTION_OS_API_VERSION, currentDeviceVersion);
        settings.setValueSync((GlobalContext.getContext()), LAUNCHER_DB_SQL_VERSION, sqlVersion.toString(), settings.domainName.USER_PROPERTY);
        return sqlVersion;
      }
      // 设备版本一致，判定非升级场景，正常从SettingData中读取。
      sqlVersion = Number.parseInt(settings.getValueSync((GlobalContext.getContext()), LAUNCHER_DB_SQL_VERSION, '0', settings.domainName.USER_PROPERTY));
    } catch (error) {
      log.showError(`getSqlVersion error, code: ${error?.code}, message: ${error?.message}`);
    } finally {
      log.showWarn(`getSqlVersion deviceVersion:${deviceVersion},currentDeviceVersion：${currentDeviceVersion},sqlVersion:${sqlVersion}`);
    }
    return sqlVersion;
  }

  /**
   * init db config and create or upgrade db
   *
   * @returns void
   */
  public async initRdb(clearCache: () => void): Promise<void> {
    log.showInfo('initRdbConfig start');
    let createResult = await this.createRdbStore(GlobalContext.getContext());
    if (createResult) {
      this.mStartVersion = this.mRdbStore.version;
      this.mSqlVersion = this.getUpgradeSqlVersion();
      let upgradeSqlList: string[] = await this.getUpgradeSql(this.mStartVersion, this.mSqlVersion);
      log.showInfo(`currentVersion: ${this.mStartVersion}.${this.mSqlVersion}, mLatestVersion: ${this.mLatestVersion}.${this.mLatestSqlVersion}, upgradeSqlList:${upgradeSqlList.length}`);
      if (upgradeSqlList.length > 0) {
        await this.upgrade(upgradeSqlList);
        if (this.mStartVersion === 1) {
          // 新老数据库切换时，需要同步清理缓存文件
          clearCache?.();
        }
      } else {
        log.showInfo('db version not change');
      }
    } else {
      log.showError('createRdbStore error rebuild db');
      HiDfxEventUtil.reportLauncherDbAbnormal();
      try {
        await rdb.deleteRdbStore(GlobalContext.getContext(), RdbStoreConfig.dbName);
      } catch (error) {
        log.showError(`initRdb deleteRdbStore error, code: ${error?.code}, message: ${error?.message}`);
      }
      await this.initRdb(clearCache);
      log.showInfo('rebuild db end');
    }
  }

  /**
   * getRdbStore
   *
   * @returns rdb.RdbStore rdbStore
   */
  public getRdbStore(): rdb.RdbStore {
    if (this.mRdbStore === undefined) {
      log.showWarn('this.mRdbStore is undefined');
    }
    return this.mRdbStore;
  }

  /**
   * 获取数据库升级前起始版本号
   *
   * @returns number 起始版本号
   */
  public getRdbStartVersion(): number {
    return this.mStartVersion;
  }

  /**
   * 获取数据库升级后最终版本号
   *
   * @returns number 最终版本号
   */
  public getRdbLatestVersion(): number {
    return this.mLatestVersion;
  }

  /**
   * createRdbStore
   *
   * @returns Promise<void>
   */
  public async createRdbStore(context: Context.BaseContext): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(context)) {
      log.showError('createRdbStore context is undefined');
      return false;
    }

    let result = true;
    if (this.mRdbStore !== undefined) {
      log.showInfo('createRdbStore -> rdbStore exist');
      return result;
    }

    let callback: Function = async (callbackContext: common.Context) => {
      try {
        callbackContext.area = contextConstant.AreaMode.EL1;
        // @ts-ignore
        this.mRdbStore = await rdb.getRdbStore(callbackContext, {
          name: RdbStoreConfig.dbName,
          securityLevel: rdb.SecurityLevel.S1,
          // @ts-ignore
          haMode: rdb.HAMode.MAIN_REPLICA,
          allowRebuild: true,
          isSearchable: true,
        });
        log.showWarn(`createRdbStore -> getRdbStore with schema version ${SCHEMA_VERSION} success, area=${callbackContext.area}`);
        return;
      } catch (error) {
        log.showError(`createRdbStore catch error, code: ${error?.code}, message: ${error?.message}`);
        result = false;
      }
    };
    await ContextModifyUtils.modifyTargetContextAsync(context as common.Context, contextConstant.AreaMode.EL1, callback,
      `${TAG}-createRdbStore`);
    return result;
  }

  private async upgrade(upgradeSqlList: string[]): Promise<void> {
    for (const element of upgradeSqlList) {
      try {
        await this.mRdbStore.executeSql(element);
      } catch (err) {
        log.showError(`upgrade failed execute ${element}, code: ${err?.code}, message: ${err?.message}`);
      }
    }
    try {
      this.mRdbStore.version = this.mLatestVersion;
      settings.setValueSync((GlobalContext.getContext()), LAUNCHER_DB_SQL_VERSION, this.mLatestSqlVersion.toString(), settings.domainName.USER_PROPERTY);
      let newSqlVersion = Number.parseInt(settings.getValueSync((GlobalContext.getContext()), LAUNCHER_DB_SQL_VERSION, '0', settings.domainName.USER_PROPERTY));
      log.showInfo(`upgrade success, newest version:${this.mRdbStore.version}.${newSqlVersion}`);
    } catch (err) {
      HiDfxEventUtil.reportRDBAbnormal(err?.code, err?.message);
      log.showError(`upgrade version failed, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  private async getUpgradeSql(startVersion: number, startSqlVersion: number): Promise<string[]> {
    let upgradeSqlList: string[] = [];
    let resourceManager = GlobalContext.getContext().resourceManager;
    try {
      log.showInfo('read upgrade from json');
      await resourceManager?.getRawFileContent('upgrade.json').then(value => {
        let textDecoder = new util.TextDecoder('utf-8', {
          ignoreBOM: true
        });
        const configFromFile = textDecoder.decodeWithStream(value, {
          stream: false
        });
        let upgradeInfoList: UpgradeInfo[] = JSON.parse(configFromFile).upgrade;
        this.mLatestVersion = startVersion;
        this.mLatestSqlVersion = startSqlVersion;
        upgradeInfoList.forEach(upgradeInfo => {
          if (this.needAddSql(startVersion, startSqlVersion, upgradeInfo)) {
            upgradeSqlList = upgradeSqlList.concat(upgradeInfo.sqlList);
            this.mLatestVersion = upgradeInfo.version;
            this.mLatestSqlVersion = upgradeInfo.sqlVersion;
          }
        });
      });
    } catch (e) {
      log.showError(`read upgrade from json error, code: ${e?.code}, message: ${e?.message}`);
      HiDfxEventUtil.reportRDBAbnormal(e?.code, e?.message);
    }
    log.showInfo(`read upgrade end, length : ${upgradeSqlList.length}`);
    return upgradeSqlList;
  }

  /**
   * 检查是否应执行
   * @param rdbVersion 本地数据库版本（大版本）
   * @param sqlVersion 本地sql版本（小版本）
   * @param upgradeInfo Sql
   * @returns
   */
  private needAddSql(rdbVersion: number, sqlVersion: number, upgradeInfo: UpgradeInfo): boolean {
    if (CheckEmptyUtils.isEmpty(upgradeInfo)) {
      return false;
    }
    if (CheckEmptyUtils.isEmpty(upgradeInfo.sqlVersion)) {
      upgradeInfo.sqlVersion = 0;
    }
    if (upgradeInfo.version > rdbVersion) {
      return true;
    }
    if (upgradeInfo.version === rdbVersion && upgradeInfo.sqlVersion > sqlVersion) {
      return true;
    }
    return false;
  }

  /**
   * 插入数据
   *
   * @param target 表名
   * @param valuesBucket 数据
   * @returns 插入行数
   */
  public async insert(target: string, valuesBucket: rdb.ValuesBucket, context?: Context.BaseContext,
    sceneMsg?: string, isDoRestore?: boolean, retryTimes: number = 0): Promise<number> {
    if (this.mRdbStore === undefined) {
      await this.createRdbStore(context);
    }
    if (CheckEmptyUtils.isEmpty(valuesBucket) || this.mRdbStore === undefined) {
      log.showWarn(`empty valuesBucket when ${sceneMsg} while insert or mRdbStore undefined`);
      return SCBConstants.INVALID_VALUE;
    }
    try {
      return await this.mRdbStore?.insert(target, valuesBucket, rdb.ConflictResolution.ON_CONFLICT_REPLACE);
    } catch (error) {
      log.showError(`insert ${target} error when ${sceneMsg}, code: ${error?.code}, message: ${error?.message}`);
      HiDfxEventUtil.reportRDBAbnormal(error?.code, error?.message, sceneMsg, target);
      if (await this.needRetry(error?.code, retryTimes)) {
        retryTimes++;
        return await this.insert(target, valuesBucket, context, sceneMsg, isDoRestore, retryTimes);
      }
      if (!isDoRestore && await this.doRestore(Number(error.code), this.mRdbStore)) {
        return await this.insert(target, valuesBucket, context, sceneMsg, true, retryTimes);
      }
    }
    return SCBConstants.INVALID_VALUE;
  }

  private async needRetry(errorCode: number, retryTimes: number): Promise<boolean> {
    if (retryTimes >= NumberConstants.RDB_ERROR_RETRY_TIMES_LIMIT) {
      return false;
    }
    if (errorCode === RdbStoreConfig.errorCode.DATABASE_BUSY_BY_OTHER_PROCESSES) {
      await CommonUtils.sleep(NumberConstants.RDB_ERROR_RETRY_WAIT_MILLISECONDS);
      return true;
    }
    if (errorCode === RdbStoreConfig.errorCode.DATABASE_BUSY_BY_OTHER_THREADS) {
      await CommonUtils.sleep(NumberConstants.RDB_ERROR_RETRY_WAIT_MILLISECONDS);
      return true;
    }
    if (errorCode === RdbStoreConfig.errorCode.MEMORY_APPLY_FAILED) {
      return true;
    }
    if (errorCode === RdbStoreConfig.errorCode.IO_ACCESS_FAILED) {
      await CommonUtils.sleep(NumberConstants.RDB_ERROR_RETRY_WAIT_MILLISECONDS);
      return true;
    }
    if (errorCode === RdbStoreConfig.errorCode.DATABASE_NO_RESPONSE) {
      await CommonUtils.sleep(NumberConstants.RDB_ERROR_RETRY_WAIT_MILLISECONDS);
      return true;
    }
    if (errorCode === RdbStoreConfig.errorCode.WAL_FILE_LIMIT) {
      await CommonUtils.sleep(NumberConstants.RDB_ERROR_RETRY_WAIT_MILLISECONDS);
      return true;
    }
    return false;
  }

  /**
   * 批量插入
   *
   * @param target 表名
   * @param insertBucketList 插入到表中的一组数据
   * @returns 返回插入的数据个数
   */
  public async batchInsert(target: string, insertBucketList: Array<rdb.ValuesBucket>, context?: Context.BaseContext,
    sceneMsg?: string, isDoRestore?: boolean, retryTimes: number = 0): Promise<number> {
    if (this.mRdbStore === undefined) {
      await this.createRdbStore(context);
    }
    if (CheckEmptyUtils.isEmpty(insertBucketList) || this.mRdbStore === undefined) {
      log.showWarn('empty valuesBucket while batchInsert or mRdbStore undefined');
      return SCBConstants.INVALID_VALUE;
    }
    try {
      return await this.mRdbStore.batchInsert(target, insertBucketList);
    } catch (e) {
      log.showError(`insertBatch ${target} error when ${sceneMsg}, code: ${e?.code}, message: ${e?.message}`);
      HiDfxEventUtil.reportRDBAbnormal(e?.code, e?.message, sceneMsg, target);
      if (await this.needRetry(e?.code, retryTimes)) {
        retryTimes++;
        return await this.batchInsert(target, insertBucketList, context, sceneMsg, isDoRestore, retryTimes);
      }
      if (!isDoRestore && await this.doRestore(Number(e.code), this.mRdbStore)) {
        return await this.batchInsert(target, insertBucketList, context, sceneMsg, true, retryTimes);
      }
    }
    return SCBConstants.INVALID_VALUE;
  }

  /**
   * 查询某张表所有数据
   *
   * @param tableName 表的名称
   * @return 查询结果集
   */
  public async queryAll(tableName, context?: Context.BaseContext): Promise<rdb.ResultSet> {
    return await this.query(new rdb.RdbPredicates(tableName), [], context);
  }

  /**
   * 根据指定条件查询数据
   *
   * @param predicates 查询条件
   * @param columns 字段列表
   * @return 查询结果集
   */
  public async query(predicates: rdb.RdbPredicates, columns?: Array<string>, context?: Context.BaseContext,
    isDoRestore?: boolean, retryTimes: number = 0): Promise<rdb.ResultSet> {
    if (this.mRdbStore === undefined) {
      await this.createRdbStore(context);
    }
    try {
      let result = await this.mRdbStore?.query(predicates, columns);
      return await this.checkQueryResult(result, predicates, columns, context, isDoRestore, retryTimes);
    } catch (error) {
      log.showError(`query error, code: ${error?.code}, message: ${error?.message}`);
      HiDfxEventUtil.reportRDBAbnormal(error?.code, error?.message);
    }
    return undefined;
  }

  /**
   * 查询表中是否存在指定条件的数据
   *
   * @param predicates 查询条件
   * @return 查询结果集
   */
  public async isExistData(predicates: rdb.RdbPredicates, context?: Context.BaseContext): Promise<boolean> {
    if (this.mRdbStore === undefined) {
      await this.createRdbStore(context);
    }
    predicates.limitAs(1);
    let resultSet: rdb.ResultSet | undefined = undefined;
    let ret: boolean = false;
    try {
      resultSet = await this.mRdbStore?.query(predicates, []);
      ret = resultSet && resultSet.rowCount > 0;
    } catch (error) {
      log.showError(`query error, code: ${error?.code}, message: ${error?.message}`);
      HiDfxEventUtil.reportRDBAbnormal(error?.code, error?.message);
    } finally {
      resultSet?.close();
    }
    return ret;
  }

  /**
   * 通过 sql 查询数据
   *
   * @param sql 待查询的 sql
   * @returns 查询后的结果集
   */
  public async querySql(sql: string, context?: Context.BaseContext, isDoRestore?: boolean): Promise<rdb.ResultSet> {
    if (this.mRdbStore === undefined) {
      await this.createRdbStore(context);
    }
    try {
      return await this.mRdbStore?.querySql(sql);
    } catch (error) {
      log.showError(`query by sql error, code: ${error?.code}, message: ${error?.message}`);
      HiDfxEventUtil.reportRDBAbnormal(error?.code, error?.message);
      if (!isDoRestore && await this.doRestore(Number(error.code), this.mRdbStore)) {
        return await this.querySql(sql, context, true);
      }
    }
    return undefined;
  }

  /**
   * 执行sql语句
   *
   * @param sql  sql语句
   * @returns 查询后的结果集
   */
  public async executeSql(sql: string, bindArgs?: Array<rdb.ValueType>, context?: Context.BaseContext,
    isDoRestore?: boolean, retryTimes: number = 0): Promise<void> {
    if (this.mRdbStore === undefined) {
      await this.createRdbStore(context);
    }
    try {
      return await this.mRdbStore?.executeSql(sql, bindArgs);
    } catch (error) {
      log.showError(`execute sql error, code: ${error?.code}, message: ${error?.message}`);
      if (sql.includes(GRIDLAYOUT_INFO)) {
        HiDfxEventUtil.reportRDBAbnormal(error?.code, error?.message, GRIDLAYOUT_INFO);
      }
      if (await this.needRetry(error?.code, retryTimes)) {
        retryTimes++;
        return await this.executeSql(sql, bindArgs, context, isDoRestore, retryTimes);
      }
      if (!isDoRestore && await this.doRestore(Number(error.code), this.mRdbStore)) {
        return await this.executeSql(sql, bindArgs, context, true, retryTimes);
      }
    }
    return undefined;
  }

  /**
   * 根据条件更新数据库
   *
   * @param predicates 更新条件
   * @param valueBucket 更新的数据
   * @return 受影响的行数
   */
  public async update(predicates: rdb.RdbPredicates, valuesBucket: rdb.ValuesBucket, context?: Context.BaseContext,
    sceneMsg?: string, isDoRestore?: boolean, retryTimes: number = 0, tableName?: string): Promise<number> {
    if (this.mRdbStore === undefined) {
      await this.createRdbStore(context);
    }
    if (CheckEmptyUtils.isEmpty(valuesBucket) || this.mRdbStore === undefined) {
      log.showWarn('empty valuesBucket while update or mRdbStore undefined');
      return SCBConstants.INVALID_VALUE;
    }
    try {
      return await this.mRdbStore.update(valuesBucket, predicates);
    } catch (error) {
      log.showError(`update error when ${sceneMsg}, code: ${error?.code}, message: ${error?.message}`);
      HiDfxEventUtil.reportRDBAbnormal(error?.code, error?.message, sceneMsg, tableName);
      if (await this.needRetry(error?.code, retryTimes)) {
        retryTimes++;
        return await this.update(predicates, valuesBucket, context, sceneMsg, isDoRestore, retryTimes, tableName);
      }
      if (!isDoRestore && await this.doRestore(Number(error.code), this.mRdbStore)) {
        return await this.update(predicates, valuesBucket, context, sceneMsg, true, retryTimes, tableName);
      }
    }
    return SCBConstants.INVALID_VALUE;
  }

  /**
   * 根据条件删除数据
   *
   * @param predicates 删除条件
   * @return 受影响的行数
   */
  public async delete(predicates: rdb.RdbPredicates, context?: Context.BaseContext, sceneMsg?: string,
    isDoRestore?: boolean, retryTimes: number = 0, tableName?: string): Promise<number> {
    if (this.mRdbStore === undefined) {
      await this.createRdbStore(context);
    }
    if (CheckEmptyUtils.isEmpty(predicates) || this.mRdbStore === undefined) {
      log.showWarn('empty predicates while delete or mRdbStore undefined');
      return SCBConstants.INVALID_VALUE;
    }
    try {
      return await this.mRdbStore.delete(predicates);
    } catch (error) {
      log.showError(`delete error when ${sceneMsg}, code: ${error?.code}, message: ${error?.message}`);
      HiDfxEventUtil.reportRDBAbnormal(error?.code, error?.message, sceneMsg, tableName);
      if (await this.needRetry(error?.code, retryTimes)) {
        retryTimes++;
        return await this.delete(predicates, context, sceneMsg, isDoRestore, retryTimes, tableName);
      }
      if (!isDoRestore && await this.doRestore(Number(error.code), this.mRdbStore)) {
        return await this.delete(predicates, context, sceneMsg, true, retryTimes, tableName);
      }
    }
    return SCBConstants.INVALID_VALUE;
  }

  /**
   * 从备库还原数据库
   * @param backupName 备库名称
   */
  public async doRestore(errorCode: number, rdbRestore: rdb.RdbStore): Promise<boolean> {
    try {
      if (errorCode === RdbStoreConfig.errorCode.DATABASE_CORRUPTED) {
        HiDfxEventUtil.reportLauncherDbAbnormal();
        // @ts-ignore
        await rdbRestore.restore();
        log.showInfo('doRestore from slave db successfully');
        return true;
      }
    } catch (error) {
      log.error('restore error :', error);
      return false;
    }
    return false;
  }

  private async checkQueryResult(result: rdb.ResultSet, predicates: rdb.RdbPredicates,
    columns?: Array<string>, context?: Context.BaseContext, isDoRestore?: boolean,
    retryTimes: number = 0): Promise<rdb.ResultSet> {
    if (result?.rowCount === -1) {
      try {
        result?.isColumnNull(0);
      } catch (e) {
        log.showError(`query result error, code: ${e?.code}, message: ${e?.message}`);
        HiDfxEventUtil.reportRDBAbnormal(e?.code, e?.message);
        if (await this.needRetry(e?.code, retryTimes)) {
          retryTimes++;
          return await this.query(predicates, columns, context, isDoRestore, retryTimes);
        }
        if (!isDoRestore && await this.doRestore(Number(e.code), this.mRdbStore)) {
          return await this.query(predicates, columns, context, true, retryTimes);
        }
      }
    }
    return result;
  }

  /**
   * 释放rdbStore
   */
  public release(): void {
    try {
      this.mRdbStore?.close();
      this.mRdbStore = undefined;
      log.showInfo('rdbStore release');
    } catch (e) {
      log.showError(`close rdbStore error, code: ${e?.code}`);
    }
  }

  /**
   * 转换valuesBucket为可读字符串
   *
   * @param valuesBucket
   * @returns string
   */
  public valuesBucketToStr(valuesBucket: rdb.ValuesBucket, filterSet: HashSet<string> = null): string {
    let valuesBucketStr = '';
    if (CheckEmptyUtils.isEmpty(valuesBucket)) {
      return valuesBucketStr;
    }
    try {
      Object.entries(valuesBucket).forEach(([key, value]) => {
        if (!CheckEmptyUtils.isEmpty(filterSet) && !filterSet.has(key)) {
          return;
        }
        valuesBucketStr += (`${key}=${value},`);
      });
      return valuesBucketStr;
    } catch (e) {
      log.showError(`valuesBucketToStr error:${e?.message}`);
    }
    return valuesBucketStr;
  }

  /**
   * 转换condition为可读字符串
   *
   * @param conditionMap
   * @returns string
   */
  public conditionsToStr(conditionMap: Map<string, rdb.ValueType>): string {
    let conditionStr = '';
    if (CheckEmptyUtils.isEmpty(conditionMap)) {
      return conditionStr;
    }
    try {
      conditionMap.forEach((key, value) => {
        conditionStr += `${value}=${key} AND `;
      });
      return conditionStr;
    } catch (e) {
      log.showError(`conditionsToStr error:${e?.message}`);
    }
    return conditionStr;
  }

  /**
   * 打印sql日志
   *
   * @param functionName 方法名
   * @param sceneMsg 场景
   * @param executeSql sql
   * @param res 执行结果
   */
  public printExecuteSql(functionName: string, sceneMsg: string, executeInfo: string, res?: number): void {
    try {
      if (!CheckEmptyUtils.isEmpty(executeInfo)) {
        const sqlId: string = new Date().getTime().toString();
        let printStr: string[] = this.splitStringByLength(executeInfo, SPLIT_LENGTH);
        printStr.forEach((str) => {
          log.showInfo(`${functionName}_${sqlId} when ${sceneMsg}, executeInfo: ${str}, res = ${res}`);
        })
      } else {
        log.showError(`${functionName} when ${sceneMsg}, executeInfo: ${executeInfo}, res = ${res}`);
      }
    } catch (error) {
      log.showError(`printExecuteSql error, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  private splitStringByLength(str: string, length: number): string[] {
    if (length <= 0) {
      return [str];
    }
    const result: string[] = [];
    for (let i = 0; i < str.length; i += length) {
      result.push(str.substring(i, i + length));
    }
    return result;
  }

  /**
   * 根据当前版本数据库升级文件，获取当前数据库版本号
   *
   * @returns 当前数据库版本号
   */
  public async getDbVersionByUpgradeFile(): Promise<number> {
    let resourceManager = GlobalContext.getContext().resourceManager;
    let curDbVersion: number = 0;
    try {
      let upgradeContent = await resourceManager?.getRawFileContent('upgrade.json');
      let textDecoder = util.TextDecoder.create('utf-8', {
        ignoreBOM: true
      });
      const configFromFile = textDecoder.decodeToString(upgradeContent, {
        stream: false
      });
      let upgradeInfoList: UpgradeInfo[] = JSON.parse(configFromFile).upgrade;
      upgradeInfoList.forEach(upgradeInfo => {
        if (upgradeInfo.version > curDbVersion) {
          curDbVersion = upgradeInfo.version;
        }
      });
    } catch (e) {
      log.showError(TAG, `getCurDbVersion from json error, code: ${e?.code}, message: ${e?.message}`);
    }
    log.showInfo(TAG, `getCurDbVersion default: ${curDbVersion}`);
    return curDbVersion;
  }
}

class UpgradeInfo {
  /**
   * 数据库版本,与this.mRdbStore.version版本相同
   * 如 this.mRdbStore.version 小于 version,则执行该语句
   * 场景:升级
   */
  version: number;
  /**
   * sql语句版本, 本机的值保存在Number.parseInt(settings.getValueSync((GlobalContext.getContext()), 'launcher_db_sql_version', '0'))
   * 如 this.mRdbStore.version 与version 相同,且 launcher_db_sql_version,小于sqlVersion,则执行该语句
   * 场景:克隆
   */
  sqlVersion: number = 0;
  description: string;
  sqlList: string[];
}

export const rdbStoreHelper: RdbStoreHelper = RdbStoreHelper.getInstance();
