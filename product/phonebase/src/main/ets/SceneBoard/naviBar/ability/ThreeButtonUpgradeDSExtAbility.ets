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

import DataShareExtensionAbility from '@ohos.application.DataShareExtensionAbility';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import type Want from '@ohos.app.ability.Want';
import type { AsyncCallback, BusinessError } from '@ohos.base';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import rdb from '@ohos.data.relationalStore';
import contextConstant from '@ohos.app.ability.contextConstant';
import dataShare from '@ohos.data.dataShare';
import { ThreeButtonUpgradeConstants } from '../ThreeButtonUpgradeConstants';
import settings from '@ohos.settings';
import { CommonConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { SCBGestureNavSetMgr } from '@ohos/componenthelper';
import { naviBarSettingsDataMgr } from '../settings/preference/NaviBarSettingsDataMgr';

const TAG: string = 'ThreeButtonUpgradeDSExtAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 三键导航升级向导提供给OOBE拉起
 */
export default class ThreeButtonUpgradeDSExtAbility extends DataShareExtensionAbility {
  private mRdbStore: rdb.RdbStore | undefined;

  onCreate(want: Want, callback: AsyncCallback<void>): void {
    if (CheckEmptyUtils.isEmpty(want)) {
      log.showError('want is null');
      callback(null);
      return;
    }
    log.showInfo(`want abilityName: ${want.abilityName}`);
    // 设定数据加密等级
    this.context.area = contextConstant.AreaMode.EL1;
  }

  private returnOnCallback(callback: AsyncCallback<Object>, logInfo: string, resultSet: rdb.ResultSet | null): void {
    log.showInfo(`callback reason is: ${logInfo}`);
    callback?.(null, resultSet);
  }

  private returnByResultSet(callback: AsyncCallback<Object>, resultSet: rdb.ResultSet | null): void {
    if (resultSet) {
      this.returnOnCallback(callback, 'ResultSet is null', resultSet);
    } else {
      this.returnOnCallback(callback, 'ResultSet not null', null);
    }
    this.mRdbStore?.close();
  }

  async query(uri: string, predicates: dataSharePredicates.DataSharePredicates, columns: Array<string>,
    callback: AsyncCallback<Object>): Promise<void> {
    try {
      if (CheckEmptyUtils.isEmpty(this.context)) {
        this.returnOnCallback(callback, 'context is null', null);
        return;
      }
      await this.initRdbStore(this.context);
      if (CheckEmptyUtils.isEmpty(this.mRdbStore)) {
        this.returnOnCallback(callback, 'rdbStore  is null', null);
        return;
      }
      if (!(await this.initThreeButtonDb())) {
        await this.deleteDb(predicates, ThreeButtonUpgradeConstants.TBL_NAME);
        this.returnOnCallback(callback, 'initThreeButtonDb error', null);
        return;
      }
      if (!(await this.deleteDb(predicates, ThreeButtonUpgradeConstants.TBL_NAME))) {
        this.returnOnCallback(callback, 'deleteDb error', null);
        return;
      }
      if (!(await this.insertDb())) {
        this.returnOnCallback(callback, 'insertDb error', null);
        return;
      }
      this.mRdbStore?.commit();
      let firstResultSet: rdb.ResultSet | null =
        await this.queryDb(predicates, ThreeButtonUpgradeConstants.TBL_NAME, columns);
      if (firstResultSet?.rowCount !== CommonConstants.INVALID_VALUE) {
        this.returnByResultSet(callback, firstResultSet);
        return;
      }
      // 异常重试
      setTimeout(async () => {
        let secondResultSet: rdb.ResultSet | null =
          await this.queryDb(predicates, ThreeButtonUpgradeConstants.TBL_NAME, columns);
        this.returnByResultSet(callback, secondResultSet);
        return;
      }, 500);
    } catch (err) {
      this.returnOnCallback(callback, `query err: ${err.message}`, null);
    }
  }

  private async queryDb(predicates: dataSharePredicates.DataSharePredicates, tableName: string,
    columns?: Array<string>): Promise<rdb.ResultSet | null> {
    if (CheckEmptyUtils.isEmpty(predicates)) {
      log.showWarn('predicates is null');
      return null;
    }
    if (CheckEmptyUtils.isEmpty(tableName)) {
      log.showWarn('tableName is null');
      return null;
    }
    try {
      let resultSet: rdb.ResultSet | undefined = await this.mRdbStore?.query(tableName, predicates, columns);
      if (!resultSet) {
        return null;
      }
      log.showInfo(`query resultSet ${resultSet.rowCount}`);
      return resultSet;
    } catch (err) {
      log.showError(`query error ${err.message}`);
      return null;
    }
  }

  private async initThreeButtonDb(): Promise<boolean> {
    try {
      return await this.executeSql(ThreeButtonUpgradeConstants.CREATE_TBL_SQL);
    } catch (err) {
      log.showError(`initThreeButtonDb error: ${err.message}`);
      return false;
    }
  }

  private async initRdbStore(context: Context): Promise<void> {
    try {
      this.mRdbStore = await rdb.getRdbStore(context, {
        name: ThreeButtonUpgradeConstants.THREE_BUTTON,
        securityLevel: rdb.SecurityLevel.S1
      });
      log.showInfo('initRdbStore success');
    } catch (error) {
      log.showError(`initRdbStore error reson: ${error}`);
    }
  }

  private executeSql(sql: string): Promise<boolean> {
    return new Promise((resolve) => {
      if (CheckEmptyUtils.isEmpty(sql)) {
        log.showInfo('sql is null');
        resolve(false);
        return;
      }
      if (CheckEmptyUtils.isEmpty(this.mRdbStore)) {
        log.showInfo('rdbStore is null');
        resolve(false);
        return;
      }
      try {
        this.mRdbStore?.executeSql(sql, (err) => {
          resolve(CheckEmptyUtils.isEmpty(err) ? true : false);
        });
        log.showInfo('executeSql success');
      } catch (err) {
        log.showError(`executeSql err: ${err?.message}`);
        resolve(false);
      }
    });
  }

  private async deleteDb(predicates: dataSharePredicates.DataSharePredicates, tableName: string): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(predicates)) {
      log.showInfo('invalid predicates');
      return false;
    }
    if (CheckEmptyUtils.isEmpty(tableName)) {
      log.showInfo('tableName is null');
      return false;
    }
    let ret = await this.mRdbStore?.delete(tableName, predicates).catch((error: BusinessError) => {
      log.showError(`delete error. Cause: ${error.message}`);
      return false;
    });
    log.showInfo(`delete result: ${ret}`);
    return ret !== CommonConstants.INVALID_VALUE;
  }

  private async insertDb(): Promise<boolean> {
    const isDoubleToSingle = this.isUpgradeFromDual();
    const isThreeButtonUpgrade = this.isThreeButtonUpgrade();
    const isVisible: boolean = isDoubleToSingle && isThreeButtonUpgrade;
    if (isDoubleToSingle && SCBGestureNavSetMgr.isSupportFloatNavigation()) {
      try {
        let threeButtonUpgrade = isThreeButtonUpgrade ? CommonConstants.SYSTEM_NAVIGATION_FLOATING :
        CommonConstants.SYSTEM_NAVIGATION_GESTURE;
        await settings.setValue(getContext(), CommonConstants.FLOATING_NAVIGATION_KEY, threeButtonUpgrade,
          settings.domainName.USER_PROPERTY);

        // 系统迁移，Back键位置处理
        if (threeButtonUpgrade === CommonConstants.SYSTEM_NAVIGATION_FLOATING) {
          // 当前开启了悬浮三键，获取当前的Back返回键位置
          naviBarSettingsDataMgr.checkFloatingNavigationExchangeButton();
        }
      } catch (e) {
        log.showError(`setValue is error ${e?.message}`);
      }
    }
    log.showInfo(`isDoubleToSingle: ${isDoubleToSingle}, isThreeButtonUpgrade ${isThreeButtonUpgrade},` +
      `isSupportFloatNavigation is ${SCBGestureNavSetMgr.isSupportFloatNavigation()}`);
    let valueBucket: rdb.ValuesBucket = {
      'bundleName': ThreeButtonUpgradeConstants.BUNDLE_NAME,
      'abilityName': ThreeButtonUpgradeConstants.UI_ABILITY,
      'isVisible': isVisible
    };
    const isInsertSuccess =
      await this.mRdbStore?.insert(ThreeButtonUpgradeConstants.TBL_NAME, valueBucket,
        rdb.ConflictResolution.ON_CONFLICT_REPLACE);
    log.showInfo(`isInsertSuccess ${isInsertSuccess}`);
    return isInsertSuccess !== CommonConstants.INVALID_VALUE;
  }

  private isUpgradeFromDual(): boolean {
    let upgradeFromDual = '';
    try {
      upgradeFromDual = settings.getValueSync(getContext(), ThreeButtonUpgradeConstants.UPGRADE_FROM_DUAL, '',
        settings.domainName.USER_SECURITY)
      log.showInfo(`upgradeFromDual is: ${upgradeFromDual}`);
    } catch (e) {
      log.showError(`isUpgradeFromDual error, code: ${e?.code}, msg: ${e?.message}`);
    }
    return upgradeFromDual === '1';
  }

  private async checkMigrateClient(): Promise<boolean> {
    try {
      let dsProxyHelper =
        await dataShare.createDataShareHelper(this.context, ThreeButtonUpgradeConstants.MIGRATE_CLIENT_QUERY_URI);
      if (dsProxyHelper === null) {
        return false;
      }
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('bundleName', ThreeButtonUpgradeConstants.MIGRATE_CLIENT_BUNDLE_NAME)
        .equalTo('isVisible', '1')
        .limit(1, 0);
      let result = await dsProxyHelper.query(ThreeButtonUpgradeConstants.MIGRATE_CLIENT_QUERY_URI, predicates, ['*']);
      log.showInfo(`checkMigrateClient result ${result.rowCount}`);
      return (result?.rowCount ?? 0) > 0;
    } catch (error) {
      log.showError(`checkMigrateClient error message ${error}`);
      return false;
    }
  }

  private isThreeButtonUpgrade(): boolean {
    // 1:手势导航  非1:三键导航
    let oldNavigationType: string = '1';
    try {
      oldNavigationType = settings.getValueSync(this.context as Context,
        ThreeButtonUpgradeConstants.OLD_NAVIGATION_TYPE_KEY, '1', settings.domainName.USER_SECURITY);
    } catch (error) {
      log.showError(`isThreeButtonUpgrade error message ${error}`);
    }
    return oldNavigationType !== '1';
  }
}