/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
  CheckEmptyUtils,
  CommonUtils,
  SingleContext
} from '@ohos/basicutils';
import {
  GlobalContext,
  rdbStoreHelper,
  IconResourceManager,
  BadgeColumns,
  BadgeEnums,
  RdbStoreConfig,
  DeviceHelper,
  GraphicUtils,
  HiDfxEventUtil,
  ResourceManager,
  ContextModifyUtils,
  sSettingsUtil
} from '@ohos/frameworkwrapper';
import { image } from '@kit.ImageKit';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { DownloadInfoItem } from '../constants/CommonConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { AppItemInfo } from '../bean/AppItemInfo';
import { DockItemInfo } from '../bean/DockItemInfo';
import { CardItemInfo } from '../bean/CardItemInfo';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import notificationManager from '@ohos.notificationManager';
import type BadgeItemInfo from '../bean/BadgeItemInfo';
import rdb from '@ohos.data.relationalStore';
import { rdbTaskPool } from './RdbTaskPool';
import GridLayoutInfoColumns, { GridLayoutInfoEnums } from './column/GridLayoutInfoColumns';
import GridLayoutItemInfoDB from '../entity/GridLayoutItemInfoDataBase';
import dataPreferences from '@ohos.data.preferences';
import type { SwiperItemInfo } from '../entity/SwiperItemInfo';
import IntelligentDiscoveryInfoColumns, { IntelligentDiscoveryInfoEnums } from '../bean/IntelligentDiscoveryInfoColumns';
import IntelligentImageColumns, { IntelligentImageEnums } from '../bean/IntelligentImageColumns';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import RecentDockInfoColumns from './column/RecentDockInfoColumns';
import IntelligentCardListColumns, { IntelligentCardListEnums } from '../bean/IntelligentCardListColumns';
import IntelligentCommonDataColumns, { IntelligentCommonDataEnums } from '../bean/IntelligentCommonDataColumns';
import { BusinessError } from '@ohos.base';
import {
  RDBErrorCode,
  ShortcutViewModel,
  DesktopLayoutState,
  SceneMsgEnum,
  DefaultDesktopLayoutInfo
} from '../TsIndex';
import { BaseIconInfo } from '../bean/BaseIconInfo';
import bundleManager from '@ohos.bundle.bundleManager';
import { BaseBundleInfo } from '../bean/BaseBundleInfo';
import { AppGridItemInfo } from '../bean/AppGridItemInfo';
import { PageUpdateItem } from '../bean/PageUpdateItem';
import { AppItemCardInfo } from '../bean/AppItemCardInfo';
import CardInfoColumns, { CardInfoEnums } from './column/CardInfoColumns';
import { util } from '@kit.ArkTS';
import { UpdateGirdLayoutReq } from '../bean/GridLayoutMapReplaceInfo';
import { PageIndexTypeInfoEnums } from './column/PageIndexTypeInfoColumns';
import PageIndexTypeInfo from '../bean/PageIndexTypeInfo';
import type common from '@ohos.app.ability.common';
import { contextConstant } from '@kit.AbilityKit';
import { FormCommonUtil } from '../utils/FormCommonUtil';

const TAG = 'RdbStoreManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_PAGE = 2;
const FORM_TRANSPARENT: string = '1';
const FORM_OPAQUE: string = '0';

/**
 * Wrapper class for rdb interfaces.
 */
export class RdbStoreManager {
  private mLayoutTableName: string = RdbStoreConfig.gridLayoutInfo.tableName;

  preferences: dataPreferences.Preferences | null = null;

  private debugStatus: number = 0;

  private constructor() {
  }

  /**
   * db manager instance
   *
   * @return rdbStoreManager instance
   */
  static getInstance(): RdbStoreManager {
    if (globalThis.RdbStoreManagerInstance == null) {
      globalThis.RdbStoreManagerInstance = new RdbStoreManager();
    }
    return globalThis.RdbStoreManagerInstance;
  }

  /**
   * initRdbConfig
   *
   * @returns Promise<void>
   */
  public async initRdbConfig(clearCache: () => void): Promise<void> {
    log.showInfo('initRdbConfig start');
    await rdbStoreHelper.initRdb(clearCache);
    this.setStartupStatus(true);
  }

  /**
   * 设置开机状态
   * @param status 是否正在开机
   */
  public setStartupStatus(status: boolean): void {
    rdbTaskPool.setStartupStatus(status);
  }

  /**
   * 获取数据库升级前起始版本号
   *
   * @returns number 起始版本号
   */
  public getRdbStartVersion(): number {
    return rdbStoreHelper.getRdbStartVersion();
  }

  /**
   * 获取数据库升级后最终版本号
   *
   * @returns number 最终版本号
   */
  public getRdbLatestVersion(): number {
    return rdbStoreHelper.getRdbLatestVersion();
  }

  /**
   * 更新布局表名
   */
  public updateLayoutTableName(desktopMode: number): void {
    log.showInfo('updateLayoutTableName with desktop mode %{public}d', desktopMode);
    if (desktopMode === DesktopLayoutState.HOME_LAUNCHER_MODE) {
      this.mLayoutTableName = RdbStoreConfig.gridLayoutInfo.tableName;
    } else if (desktopMode === DesktopLayoutState.PC_MODE_MODEL) {
      this.mLayoutTableName = RdbStoreConfig.pc_mode_gridLayoutInfo.tableName;
    } else {
      this.mLayoutTableName = RdbStoreConfig.simpleLayoutInfo.tableName;
    }
  }

  /**
   * 更新布局表名
   *
   * @param bundleName 表名name
   */
  public updateLayoutTableNameByName(name: string): void {
    log.showInfo(`updateLayoutTableName by name ${name}`);
    this.mLayoutTableName = name;
  }

  /**
   * 生成唯一id
   *
   * @returns 唯一id
   */
  public generateRandomUUID(isOuter?:boolean): string {
    return util.generateRandomUUID();
  }

  /**
   * 获取所有角标信息
   *
   * @returns 角标数组
   */
  public async getAllBadge(): Promise<BadgeItemInfo[]> {
    log.showInfo('getAllBadge start');
    return await this.getBadgeInner(undefined);
  }

  /**
   * 获取指定应用角标信息
   *
   * @param bundleName 应用bundleName
   * @returns 角标数组
   */
  public async getBadgeByBundle(bundleInfo: BaseBundleInfo | GridLayoutItemInfo): Promise<BadgeItemInfo[]> {
    log.showDebug(`getBadgeByBundle start ${bundleInfo.bundleName} ${bundleInfo.appIndex}`);
    if (this.ifStringIsNull(bundleInfo.bundleName)) {
      return [];
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(BadgeColumns.BUNDLE_NAME, bundleInfo.bundleName);
    conditions.set(BadgeColumns.APP_INDEX, bundleInfo.appIndex ?? 0);
    return await this.getBadgeInner(conditions);
  }

  /**
   * 获取已修复角标脏数据的应用列表
   *
   * @returns 已修复角标脏数据的应用列表
   */
  public async getFixedBundles(): Promise<Map<string, number>> {
    let bundleMap: Map<string, number> = new Map();
    let badgeInfos: BadgeItemInfo[] = await this.getBadgeInner(undefined);
    if (CheckEmptyUtils.isEmptyArr(badgeInfos)) {
      log.showWarn(`0 app has fixed`);
      return bundleMap;
    }
    badgeInfos.forEach(info => {
      bundleMap.set(`${info.bundleName}${info.appIndex ?? 0}`, info.fixed ?? 0);
    });
    log.showInfo(`${bundleMap.size} apps has fixed`);
    return bundleMap;
  }

  private async getBadgeInner(conditions?: Map<string, rdb.ValueType>): Promise<BadgeItemInfo[]> {
    return await rdbTaskPool.queryBadge(RdbStoreConfig.badge.tableName, conditions);
  }

  /**
   * 按应用插入角标信息
   *
   * @param bundleName bundleName
   * @param badgeNumber 角标数量
   * @param isShow 是否显示角标
   * @returns 是否成功
   */
  public async insertBadgeByBundle(bundleInfo: BaseBundleInfo, badgeNumber: number, isShow: boolean): Promise<boolean> {
    log.showInfo(`insertBadgeByBundle insert item isShow: ${isShow}, badgeNumber: ${badgeNumber}.`);
    let changeRows = 0;
    try {
      const insertBucket: rdb.ValuesBucket = {
        [BadgeEnums.BUNDLE_NAME]: bundleInfo.bundleName,
        [BadgeEnums.BADGE_NUMBER]: badgeNumber,
        [BadgeEnums.IS_SHOW]: isShow ? CommonConstants.BADGE_DISPLAY_SHOW : CommonConstants.BADGE_DISPLAY_HIDE,
        [BadgeEnums.USER_ID]: CommonConstants.DEFAULT_USER_ID,
        [BadgeEnums.APP_INDEX]: bundleInfo.appIndex ?? 0,
      };
      changeRows = await rdbTaskPool.insert(RdbStoreConfig.badge.tableName, insertBucket);
    } catch (err) {
      log.showError(`batchInsertOrUpdateAppCatInfo failed, code: ${err?.code}, message: ${err?.message}`);
    }
    log.showInfo(`insertBadgeByBundle insert: ${changeRows}`);
    return (changeRows !== CommonConstants.INVALID_VALUE);
  }

  /**
   * 更新应用角标异常数据更新状态
   *
   * @param bundleName 包名
   * @param appIndex 分身id
   * @param fixedType 修复类型 1：push 2：NMS
   * @returns
   */
  public async updateFixedTypeByBundle(bundleName: string, appIndex: number, fixedType: number): Promise<void> {
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(BadgeColumns.BUNDLE_NAME, bundleName);
    conditions.set(BadgeColumns.APP_INDEX, appIndex);
    const updateBucket: rdb.ValuesBucket = {
      [BadgeEnums.FIXED]: fixedType
    };
    let changeRows = await rdbTaskPool.update(RdbStoreConfig.badge.tableName, conditions, updateBucket);
    log.showWarn(`badge fixed type updated, affect ${changeRows}`);
  }

  /**
   * 按应用更新角标数量
   *
   * @param bundleName bundleName
   * @param badgeNum 角标数量
   * @returns 是否成功
   */
  public async updateBadgeNumByBundle(bundleInfo: BaseBundleInfo, badgeNum: number): Promise<boolean> {
    log.showWarn(`updateBadgeByBundle bundleName: ${JSON.stringify(bundleInfo)} badgeNum: ${badgeNum}`);
    if (badgeNum < 0 || this.ifStringIsNull(bundleInfo.bundleName) || !CheckEmptyUtils.checkStrIsEmpty(bundleInfo?.appInstanceKey)) {
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(BadgeColumns.BUNDLE_NAME, bundleInfo.bundleName);
    conditions.set(BadgeColumns.APP_INDEX, bundleInfo.appIndex ?? 0);
    const updateBucket: rdb.ValuesBucket = {
      [BadgeEnums.BADGE_NUMBER]: badgeNum
    };
    let changeRows = await rdbTaskPool.update(RdbStoreConfig.badge.tableName, conditions, updateBucket);
    if (changeRows >= 1) {
      log.showWarn(`updateBadgeByBundle updated, affect ${changeRows}`);
      return true;
    } else {
      log.showInfo(`updateBadgeByBundle changeRows < 1, affect ${changeRows}`);
      let displayFlag = false;
      let isNtfOn = false;
      try {
        let bundleOption: notificationManager.BundleOption = {
          bundle: bundleInfo.bundleName
        };
        if ((bundleInfo.appIndex ?? 0) > 0) {
          let cloneInfo = await bundleManager.getAppCloneBundleInfo(bundleInfo.bundleName, bundleInfo.appIndex,
            bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
          bundleOption.uid = cloneInfo?.appInfo?.uid;
          log.showInfo(`get uid: ${bundleOption.uid}`);
        }
        displayFlag = await notificationManager.isBadgeDisplayed(bundleOption);
        if (displayFlag) {
          isNtfOn = await notificationManager.isNotificationEnabled(bundleOption);
          log.showInfo('get notification enable succeed. value: [%{public}s]', isNtfOn);
        }
      } catch (error) {
        log.error('updateBadgeNumByBundle error', error);
      }
      let result = await this.insertBadgeByBundle(bundleInfo, badgeNum, displayFlag && isNtfOn);
      log.showWarn(`updateBadgeByBundle insert:${result}`);
      return result;
    }
  }

  /**
   * 按应用名更新是否显示角标
   *
   * @param bundleName bundleName
   * @param isShow 是否显示
   * @returns 是否成功
   */
  public async updateBadgeDisplayByBundle(bundleInfo: BaseBundleInfo, isShow: boolean): Promise<boolean> {
    log.showInfo('updateBadgeDisplayByBundle start');
    if (this.ifStringIsNull(bundleInfo.bundleName)) {
      log.showWarn(`invalid parameter, bundle: ${JSON.stringify(bundleInfo)}, display: ${isShow}`);
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(BadgeColumns.BUNDLE_NAME, bundleInfo.bundleName);
    conditions.set(BadgeColumns.APP_INDEX, bundleInfo.appIndex ?? 0);
    const updateBucket: rdb.ValuesBucket = {
      [BadgeEnums.IS_SHOW]: isShow ? CommonConstants.BADGE_DISPLAY_SHOW : CommonConstants.BADGE_DISPLAY_HIDE
    };
    let changeRows = await rdbTaskPool.update(RdbStoreConfig.badge.tableName, conditions, updateBucket);
    if (changeRows >= 1) {
      log.showInfo(`updateBadgeDisplayByBundle updated, affect ${changeRows}`);
      return true;
    } else {
      let result = await this.insertBadgeByBundle(bundleInfo, 0, isShow);
      log.showInfo(`updateBadgeDisplayByBundle insert:${result}`);
      return result;
    }
  }

  /**
   * 按应用删除角标数据
   *
   * @param bundleName bundleName
   * @returns 是否成功
   */
  public async deleteBadgeByBundle(bundleInfo: BaseBundleInfo): Promise<boolean> {
    log.showInfo('deleteBadgeByBundle start');
    if (this.ifStringIsNull(bundleInfo.bundleName)) {
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(BadgeColumns.BUNDLE_NAME, bundleInfo.bundleName);
    conditions.set(BadgeColumns.APP_INDEX, bundleInfo.appIndex ?? 0);
    const changeRows = await rdbTaskPool.delete(RdbStoreConfig.badge.tableName, conditions);
    if (changeRows >= 1) {
      log.showInfo(`deleteBadgeByBundle delete ok:${changeRows}`);
      return true;
    }
    return false;
  }

  /**
   * 批量更新应用分类信息
   *
   * @param appCatInfoList 待更新的应用分类信息列表
   * @returns 是否成功
   */
  // public async batchInsertOrUpdateAppCatInfo(appCatInfoList: appInfoManager.AppCategoryInfo[]): Promise<boolean> {
  //   log.showInfo(`batchInsertOrUpdateAppCatInfo appCatInfoList.length: ${appCatInfoList?.length}`);
  //   if (CheckEmptyUtils.isEmptyArr(appCatInfoList)) {
  //     return false;
  //   }
  //   try {
  //     await rdbStoreHelper.executeSql(RdbStoreConfig.appCategoryInfo.createTable);
  //     return await rdbTaskPool.batchInsertOrUpdateAppCatInfo(RdbStoreConfig.appCategoryInfo.tableName, appCatInfoList);
  //   } catch (err) {
  //     log.showError(`batchInsertOrUpdateAppCatInfo failed, code: ${err?.code}, message: ${err?.message}`);
  //   }
  //   return false;
  // }

  /**
   * 删除app_category_info数据表
   *
   * @returns 受影响行数
   */
  public async deleteAppCatInfoTable(): Promise<void> {
    log.showInfo('deleteAppCatInfoTable start');
    try {
      await rdbStoreHelper.executeSql(RdbStoreConfig.appCategoryInfo.dropTable);
    } catch (err) {
      log.showError(`deleteAppCatInfoTable failed, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  /**
   * 获取所有应用分类信息
   *
   * @returns 应用分类信息列表
   */
  // public async getAllAppCatInfo(): Promise<appInfoManager.AppCategoryInfo[]> {
  //   log.showInfo('getAllAppCatInfo start');
  //   let conditions: Map<string, rdb.ValueType> = new Map();
  //   return await rdbTaskPool.queryAppCatInfo(RdbStoreConfig.appCategoryInfo.tableName, conditions);
  // }

  /**
   * 获取所有卡片信息
   *
   * @returns 卡片列表
   */
  public async getAllFormInfos(isOuter?: boolean): Promise<CardItemInfo[]> {
    log.showInfo('getAllFormInfos start');
    return this.getAllFormInfoByTableName(this.getLayoutInfoTableName(isOuter));
  }

  public async getAllFormInfosPcMode(): Promise<CardItemInfo[]> {
    return this.getAllFormInfoByTableName(RdbStoreConfig.pc_mode_gridLayoutInfo.tableName);
  }

  private async getAllFormInfoByTableName(target: string): Promise<CardItemInfo[]> {
    log.showInfo(`query all from info from: ${target}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    return await rdbTaskPool.queryForm(target, conditions);
  }

  /**
   * 更新Intend信息
   *
   * @param infoId 元素infoId
   * @param intent 需要更新的intend
   * @param isOuter 是否外屏
   * @param isSimpleMode 是否简易模式
   * @returns 更新结果
   */
  public async updateIntendInfoByInfoId(infoId: string, intent: string, isOuter: boolean,
    isSimpleMode: boolean): Promise<boolean> {
    log.showInfo(`updateIntendInfoByInfoId start: isOuter = ${isOuter}; isSimpleMode = ${isSimpleMode}, infoId = ${infoId}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, infoId);
    let valuesBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.INTENT]: intent,
    };
    let gridLayoutInfo = RdbStoreConfig.gridLayoutInfo;
    if (isOuter) {
      gridLayoutInfo = RdbStoreConfig.outerGridLayoutInfo;
    } else if (isSimpleMode) {
      gridLayoutInfo = RdbStoreConfig.simpleLayoutInfo;
    }
    let changeRows: number = await rdbTaskPool.update(gridLayoutInfo.tableName, conditions, valuesBucket);
    log.showInfo(`updateIntendInfoByInfoId end: update rows = ${changeRows}`);
    return changeRows === 1;
  }

  /**
   * 更新应用的卡片信息
   *
   * @param bundleName 应用包名
   * @param appItemCardInfo 应用的卡片信息
   * @returns 是否成功
   */
  public async updateAppItemFormInfo(bundleName: string, appItemCardInfo: AppItemCardInfo): Promise<boolean> {
    log.showInfo(`updateAppItemFormInfo, bundleName: ${bundleName}, appName: ${appItemCardInfo?.appName}, appIndex: ${appItemCardInfo?.appIndex}, status: ${appItemCardInfo?.status}`);
    try {
      let conditions: Map<string, rdb.ValueType> = new Map();
      conditions.set(CardInfoColumns.BUNDLE_NAME, bundleName);
      let valuesBucket: rdb.ValuesBucket = {
        [CardInfoEnums.APP_NAME]: appItemCardInfo.appName,
        [CardInfoEnums.APP_INDEX]: appItemCardInfo.appIndex,
        [CardInfoEnums.CARDS]: JSON.stringify(appItemCardInfo.cards),
        [CardInfoEnums.STATUS]: appItemCardInfo.status
      };
      let changeRows: number = await rdbTaskPool.update(RdbStoreConfig.cardInfo.tableName, conditions, valuesBucket);
      log.showInfo(`updateAppItemFormInfo length: ${changeRows}`);
      if (changeRows <= 0) {
        valuesBucket = {
          [CardInfoEnums.BUNDLE_NAME]: appItemCardInfo.bundleName,
          [CardInfoEnums.APP_NAME]: appItemCardInfo.appName,
          [CardInfoEnums.APP_INDEX]: appItemCardInfo.appIndex,
          [CardInfoEnums.CARDS]: JSON.stringify(appItemCardInfo.cards),
          [CardInfoEnums.STATUS]: appItemCardInfo.status
        };
        changeRows = await rdbTaskPool.insert(RdbStoreConfig.cardInfo.tableName, valuesBucket);
        log.showInfo(`insertAppItemFormInfo length: ${changeRows}`);
      }
      return changeRows !== CommonConstants.INVALID_VALUE;
    } catch (err) {
      log.showWarn(`updateAppItemFormInfo fail: ${err?.message}, ${err?.code}`);
      return false;
    }
  }

  /**
   * 批量插入应用的卡片信息
   *
   * @param appItemCardInfoList 应用的卡片信息列表
   * @returns 是否成功
   */
  public async batchInsertAppItemFormInfo(appItemCardInfoList: AppItemCardInfo[]): Promise<boolean> {
    log.showInfo(`batchInsertAppItemFormInfo start, appItemCardInfoList length: ${appItemCardInfoList.length}`);
    let bucketList: rdb.ValuesBucket[] = appItemCardInfoList.map(item => {
      return {
        [CardInfoEnums.BUNDLE_NAME]: item.bundleName,
        [CardInfoEnums.APP_NAME]: item.appName,
        [CardInfoEnums.APP_INDEX]: item.appIndex,
        [CardInfoEnums.CARDS]: JSON.stringify(item.cards),
        [CardInfoEnums.STATUS]: item.status
      } as rdb.ValuesBucket;
    })
    try {
      let changeRows: number = await rdbTaskPool.batchInsert(RdbStoreConfig.cardInfo.tableName, bucketList);
      log.showInfo(`batchInsertAppItemFormInfo length: ${changeRows}`);
      return changeRows !== CommonConstants.INVALID_VALUE;
    } catch (err) {
      log.showWarn(`batchInsertAppItemFormInfo fail: ${err?.message}, ${err?.code}`);
      return false;
    }
  }

  /**
   * 批量更新card_info表中每条数据的status字段
   *
   * @param status 0:普通布局, 1:简易布局
   * @returns 是否成功
   */
  public async batchUpdateAppItemFormInfo(status: number): Promise<boolean> {
    log.showInfo(`batchUpdateAppItemFormInfo start, status: ${status}`);
    try {
      let conditions: Map<string, rdb.ValueType> = new Map();
      let valuesBucket: rdb.ValuesBucket = {
        [CardInfoEnums.STATUS]: status
      };
      let changeRows: number = await rdbTaskPool.update(RdbStoreConfig.cardInfo.tableName, conditions, valuesBucket);
      log.showInfo(`batchUpdateAppItemFormInfo length: ${changeRows}`);
      return changeRows !== CommonConstants.INVALID_VALUE;
    } catch (err) {
      log.showWarn(`batchUpdateAppItemFormInfo fail: ${err?.message}, ${err?.code}`);
      return false;
    }
  }

  /**
   * 删除应用的卡片信息
   *
   * @param bundleName 应用包名
   * @returns 是否成功
   */
  public async deleteAppItemFormInfo(bundleName: string): Promise<boolean> {
    log.showInfo(`deleteAppItemFormInfo start, bundleName: ${bundleName}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(CardInfoColumns.BUNDLE_NAME, bundleName);
    try {
      let changeRows: number = await rdbTaskPool.delete(RdbStoreConfig.cardInfo.tableName, conditions);
      return changeRows !== CommonConstants.INVALID_VALUE;
    } catch (err) {
      log.showWarn(`deleteAppItemFormInfo fail: ${err?.message}, ${err?.code}`);
      return false;
    }
  }

  /**
   * 删除card_info表中所有的卡片信息
   *
   * @returns 是否成功
   */
  public async deleteAllAppItemFormInfo(): Promise<boolean> {
    log.showInfo('deleteAllAppItemFormInfo start');
    let conditions: Map<string, rdb.ValueType> = new Map();
    try {
      let changeRows: number = await rdbTaskPool.delete(RdbStoreConfig.cardInfo.tableName, conditions);
      return changeRows !== CommonConstants.INVALID_VALUE;
    } catch (err) {
      log.showWarn(`deleteAllAppItemFormInfo fail: ${err?.message}, ${err?.code}`);
      return false;
    }
  }

  /**
   * 获取正常布局卡片信息
   *
   * @returns 卡片列表
   */
  public async getAllFormInfosInHomeMode(): Promise<CardItemInfo[]> {
    log.showInfo('getAllFormInfosInHomeMode start');
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    return await rdbTaskPool.queryForm(RdbStoreConfig.gridLayoutInfo.tableName, conditions);
  }

  /**
   * 获取所有卡片信息:非堆叠卡片
   *
   * @returns 卡片列表
   */
  public async getAllFormExceptStackInfos(isOuter?: boolean): Promise<CardItemInfo[]> {
    log.showInfo('getAllFormExceptStackInfos start');
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    conditions.set(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_DESKTOP);
    return await rdbTaskPool.queryForm(this.getLayoutInfoTableName(isOuter), conditions);
  }

  /**
   * 按ID获取所有卡片信息
   *
   * @param cardId 卡片ID
   * @returns 卡片列表
   */
  public async getFormInfoById(cardId: string): Promise<CardItemInfo[]> {
    log.showInfo(`getFormInfoById cardId ${cardId}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    conditions.set(GridLayoutInfoColumns.INFO_ID, cardId);
    return await rdbTaskPool.queryForm(this.getLayoutInfoTableName(), conditions);
  }

  /**
   * 按bundle_name获取卡片信息
   *
   * @param bundleName 包名
   * @returns 卡片列表
   */
  public async getCardItemInfoByFaInfo(bundleName: string, moduleName: string, formName: string, abilityName: string,
                                       dimension: number): Promise<CardItemInfo[]> {
    log.showInfo('getCardIdByBundleName bundleName %{public}s', bundleName);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    if (bundleName) {
      conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, bundleName);
    }
    if (moduleName) {
      conditions.set(GridLayoutInfoColumns.MODULE_NAME, moduleName);
    }
    if (formName) {
      conditions.set(GridLayoutInfoColumns.INFO_NAME, formName);
    }
    if (abilityName) {
      conditions.set(GridLayoutInfoColumns.ABILITY_NAME, abilityName);
    }
    if (dimension) {
      let mCardSize: number[] = CardItemInfo.getCardSize(dimension);
      let width = mCardSize[0];
      let height = mCardSize[1];
      conditions.set(GridLayoutInfoColumns.WIDTH, width);
      conditions.set(GridLayoutInfoColumns.HEIGHT, height);
    }
    return await rdbTaskPool.queryForm(this.getLayoutInfoTableName(), conditions);
  }

  /**
   * 按ID更新卡片信息
   *
   * @param cardItemInfo 更新信息
   * @returns 是否成功
   */
  public async updateFormInfoById(cardItemInfo: CardItemInfo, isOuter?: boolean, ctx?: SingleContext): Promise<boolean> {
    if (cardItemInfo === null || cardItemInfo === undefined) {
      return false;
    }
    log.showInfo(`updateFormInfoById start ${cardItemInfo.cardId}`);
    if (!cardItemInfo.cardId) {
      log.showWarn(`updateFormInfoById error cardItemInfo: ${JSON.stringify(cardItemInfo)}`);
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, cardItemInfo.cardId);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    const valuesBucket = CardItemInfo.toValuesBucket(cardItemInfo, ctx?.extendScreenId);
    let changeRows = await rdbTaskPool.update(this.getLayoutInfoTableName(isOuter), conditions, valuesBucket,
      SceneMsgEnum.RDB_UPDATE_FORM_INFO_BY_ID);
    if (changeRows === 1) {
      log.showInfo(`updateFormInfoById updated ok: ${changeRows}`);
      return true;
    } else {
      changeRows = await rdbTaskPool.insert(this.getLayoutInfoTableName(isOuter), valuesBucket,
        SceneMsgEnum.RDB_INSERT_FORM_INFO_BY_ID);
      log.showInfo(`updateFormInfoById insert: ${changeRows}`);
      if (changeRows < 1) {
        FormCommonUtil.reportCardOperateRDBError(cardItemInfo, SceneMsgEnum.RDB_INSERT_FORM_INFO_BY_ID);
      }
      return (changeRows !== CommonConstants.INVALID_VALUE);
    }
  }

  /**
   * 按卡片Id更新卡片配置信息
   *
   * @param cardItemInfo 卡片信息
   * @returns 是否成功
   */
  public async updateFormConfigInfo(cardItemInfo: CardItemInfo): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(cardItemInfo) || CheckEmptyUtils.checkStrIsEmpty(cardItemInfo.cardId)) {
      log.showWarn('updateFormConfigInfo cardItemInfo is invalid');
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, cardItemInfo.cardId);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, cardItemInfo.typeId);
    const updateBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.URI]: cardItemInfo.formConfigAbility,
      [GridLayoutInfoEnums.EXTEND2]: cardItemInfo.isTransparent ? FORM_TRANSPARENT : FORM_OPAQUE,
      [GridLayoutInfoEnums.INTENT]: cardItemInfo.intent ?? ''
    };
    let changeRows = await rdbTaskPool.update(this.getLayoutInfoTableName(), conditions, updateBucket);
    log.showInfo('updateFormConfigInfo update: %{public}d', changeRows);
    return true;
  }

  /**
   * 按位置更新卡片信息
   *
   * @param cardItemInfo 更新信息
   * @returns 是否成功
   */
  public async updateFormInfoByPosition(cardItemInfo: CardItemInfo | GridLayoutItemInfo, isOuter?: boolean): Promise<boolean> {
    log.showInfo(`updateFormInfoByPosition ${cardItemInfo?.isTransparent}`);
    if (cardItemInfo === null || cardItemInfo === undefined) {
      log.showWarn('updateFormInfoByPosition cardItemInfo == null');
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    conditions.set(GridLayoutInfoColumns.ROW, cardItemInfo.row);
    conditions.set(GridLayoutInfoColumns.COLUMN, cardItemInfo.column);
    conditions.set(GridLayoutInfoColumns.PAGE_INDEX, cardItemInfo.page);
    conditions.set(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_DESKTOP);
    const valuesBucket = CardItemInfo.toValuesBucket(cardItemInfo);
    let changeRows = await rdbTaskPool.update(this.getLayoutInfoTableName(isOuter), conditions, valuesBucket,
      SceneMsgEnum.RDB_UPDATE_FORM_INFO_BY_POSITION);
    log.showInfo('updateFormInfoByPosition update: %{public}d', changeRows);
    if (changeRows < 1) {
      if (CheckEmptyUtils.checkStrIsEmpty(cardItemInfo.cardId)) {
        log.showError(`invalid formId, cardItemInfo: ${JSON.stringify(cardItemInfo)}`);
        return false;
      }
      changeRows = await rdbTaskPool.insert(this.getLayoutInfoTableName(isOuter), valuesBucket,
        SceneMsgEnum.RDB_INSERT_FORM_INFO_BY_POSITION);
      log.showInfo(`updateFormInfoByPosition insert: ${changeRows}`);
      if (changeRows < 1) {
        FormCommonUtil.reportCardOperateRDBError(cardItemInfo, SceneMsgEnum.RDB_INSERT_FORM_INFO_BY_POSITION);
      }
      return (changeRows !== CommonConstants.INVALID_VALUE);
    }
    return changeRows >= 1;
  }

  /**
   * 通过主键删除桌面数据
   * @param layoutItem 桌面数据对象
   * @param isOuter 是否外屏
   * @returns 更新行数
   */
  public async deleteLayoutInfoById(layoutItem: GridLayoutItemInfo, isOuter?: boolean): Promise<number> {
    if (CheckEmptyUtils.isEmpty(layoutItem?.id)) {
      log.showWarn('deleteLayoutInfoById layoutItem is invalid');
      return -1;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.ID, layoutItem.id);
    let deleteRows = await rdbTaskPool.delete(this.getLayoutInfoTableName(isOuter), conditions);
    if (deleteRows < 1) {
      log.showError('deleteLayoutInfoById failed, id=%{public}d, bundle=%{public}s, ability=%{public}s, ' +
        'typeId=%{public}d, page=%{public}d, col=%{public}d, row=%{public}d', layoutItem.id, layoutItem.bundleName,
        layoutItem.abilityName, layoutItem.typeId, layoutItem.page, layoutItem.column, layoutItem.row);
    } else {
      log.showInfo(`deleteLayoutInfoById update:${deleteRows}, id=${layoutItem.id}`);
    }
    return deleteRows;
  }

  public getLayoutInfoTableName(isOuter?: boolean): string {
    if (isOuter === undefined) {
      if (launcherStatusUtil.getShowOutLauncherStatus()) {
        log.showInfo(`getOuterLayoutInfoTable`);
        return RdbStoreConfig.outerGridLayoutInfo.tableName;
      }
    }
    if (isOuter) {
      return RdbStoreConfig.outerGridLayoutInfo.tableName;
    }
    const cur: string = this.mLayoutTableName;
    log.showInfo(`getLayoutInfoTableName current: ${cur}`);
    return cur;
  }

  /**
   * 预置场景, 卡片ID从0变为有效值,按照container和bundleName更新卡片ID; 升级场景，用新的卡片ID更新旧的卡片ID
   * @param oldCardId 待更新卡片的旧的卡片ID
   * @param layoutItem 待更新的卡片的布局信息
   * @returns 更新是否成功
   */
  public async updateCardIdOfFormStack(oldCardId: string, layoutItem: GridLayoutItemInfo, isOuter?: boolean): Promise<boolean> {
    if (!layoutItem) {
      log.showError('updateCardIdOfFormStack layoutItem is invalid!');
      return false;
    }

    log.showWarn('updateCardIdOfFormStack new cardId: %{public}s, container: %{public}d, oldCardId: %{public}s.',
      layoutItem.cardId, layoutItem.container, oldCardId);

    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    if (!CheckEmptyUtils.checkStrIsEmpty(oldCardId)) {
      conditions.set(GridLayoutInfoColumns.INFO_ID, oldCardId);
    } else {
      conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, layoutItem.bundleName);
      if (layoutItem.container === CommonConstants.INVALID_VALUE) {
        // container无效、根据position去更新
        conditions.set(GridLayoutInfoColumns.ROW, layoutItem.row);
        conditions.set(GridLayoutInfoColumns.COLUMN, layoutItem.column);
        conditions.set(GridLayoutInfoColumns.PAGE_INDEX, layoutItem.page);
      } else {
        conditions.set(GridLayoutInfoColumns.CONTAINER, layoutItem.container);
      }
    }

    const valueBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.INFO_ID]: layoutItem.cardId,
      [GridLayoutInfoEnums.EXTEND1]: layoutItem.extend1
    };

    let changeRows = await rdbTaskPool.update(this.getLayoutInfoTableName(isOuter), conditions, valueBucket);
    if (changeRows < 1) {
      log.showError(`updateCardIdOfFormStack failed changeRows: ${changeRows}.`);
      return false;
    }

    return true;
  }

  /**
   * 更新快捷图标的布局数据库
   *
   * @param layoutItem待更新的快捷图标的布局信息
   * @returns 是否成功
   */
  public async updateShortcutItemInfo(layoutItem: GridLayoutItemInfo | DockItemInfo): Promise<boolean> {
    if (!layoutItem) {
      log.showError('updateShortcut layoutItem is invalid!');
      return false;
    }
    let keyName: string = AppItemInfo.getKeyName(layoutItem);
    log.showWarn(`updateShortcut keyName:${keyName}`);

    if (layoutItem.appIconId) {
      let image: string = await ShortcutViewModel.getInstance().getShortcutOriginImage(layoutItem as AppItemInfo);
      layoutItem.iconResource = image ?? layoutItem.iconResource;
    }
    if (layoutItem.appLabelId) {
      layoutItem.appName = await this.getAppNameFromResource(layoutItem);
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, layoutItem.bundleName);
    conditions.set(GridLayoutInfoColumns.APP_INDEX, layoutItem.appIndex);
    conditions.set(GridLayoutInfoColumns.SHORTCUT_ID, layoutItem.shortcutId);

    const valueBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.APP_ICON_ID]: layoutItem.appIconId,
      [GridLayoutInfoEnums.APP_LABEL_ID]: layoutItem.appLabelId,
      [GridLayoutInfoEnums.APP_STATUS]: layoutItem.appStatus,
      [GridLayoutInfoEnums.ICON_RESOURCE]: layoutItem.iconResource,
      [GridLayoutInfoEnums.INFO_NAME]: layoutItem.appName
    };

    let changeRows: number = await rdbTaskPool.update(this.getLayoutInfoTableName(), conditions, valueBucket);
    if (changeRows < 1) {
      log.showError(`updateShortcut failed changeRows: ${changeRows}.`);
      return false;
    }

    return true;
  }

  /**
   * 获取应用名
   * @param itemInfo
   * @returns 应用名称
   */
  private async getAppNameFromResource(itemInfo: GridLayoutItemInfo | DockItemInfo): Promise<string> {
    let appname: string = await ResourceManager.getInstance().getBundleStringByIdSync(itemInfo.appLabelId,
      itemInfo.bundleName, itemInfo.moduleName, itemInfo.appIndex);
    log.showWarn(`shortcut ${itemInfo.bundleName}_${itemInfo.appLabelId}_${itemInfo.appName} appname is ${appname}`);
    return appname ?? itemInfo.appName;
  }

  /**
   * 更新联系人异常快捷图标的布局数据库
   *
   * @param layoutItem待更新的快捷图标的布局信息
   * @returns 是否成功
   */
  public async updateContactShortcutItemInfo(layoutItem: GridLayoutItemInfo): Promise<boolean> {
    if (!layoutItem) {
      log.showError('updateContactShortcutItemInfo layoutItem is invalid!');
      return false;
    }
    let keyName: string = AppItemInfo.getKeyName(layoutItem);
    log.showWarn(`updateContactShortcutItemInfo keyName:${keyName}`);

    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, layoutItem.bundleName);
    conditions.set(GridLayoutInfoColumns.APP_INDEX, layoutItem.appIndex);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_SHORTCUT_ICON);

    const valueBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.SHORTCUT_ID]: layoutItem.shortcutId,
      [GridLayoutInfoEnums.APP_ICON_ID]: layoutItem.appIconId,
      [GridLayoutInfoEnums.APP_LABEL_ID]: layoutItem.appLabelId
    };

    let changeRows: number = await rdbTaskPool.update(this.getLayoutInfoTableName(), conditions, valueBucket);
    if (changeRows < 1) {
      log.showError(`updateShortcut failed changeRows: ${changeRows}.`);
      return false;
    }

    return true;
  }

  /**
   * 批量更新快捷图标的加桌上限
   *
   * @param limitItem 待更新的快捷图标的加桌上限信息
   * @returns 是否成功
   */
  public async batchUpdateShortcutItemLimitInfo(limitItems: GridLayoutItemInfo[], tableName: string): Promise<boolean> {
    if (CheckEmptyUtils.isEmptyArr(limitItems)) {
      log.showError('updateShortcut limitItems is invalid!');
      return false;
    }
    return await rdbTaskPool.batchUpdateLayoutInfoShortcutLimit(tableName, limitItems);
  }

  /**
   * 修复联系人快捷图标的布局数据库
   *
   * @param layoutItem待修复的快捷图标的布局信息
   * @returns 是否成功
   */
  public async correctShortcutItemInfo(layoutItem: GridLayoutItemInfo): Promise<boolean> {
    if (!layoutItem) {
      log.showError('correctShortcut layoutItem is invalid!');
      return false;
    }

    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, layoutItem.bundleName);
    conditions.set(GridLayoutInfoColumns.APP_INDEX, layoutItem.appIndex);
    conditions.set(GridLayoutInfoColumns.SHORTCUT_ID, layoutItem.shortcutId);

    const valueBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.INFO_NAME]: layoutItem.infoName,
      [GridLayoutInfoEnums.INTENT]: layoutItem.intent
    };

    let changeRows: number = await rdbTaskPool.update(this.getLayoutInfoTableName(), conditions, valueBucket);
    if (changeRows < 1) {
      log.showError(`correctShortcut failed changeRows: ${changeRows}.`);
      return false;
    }

    return true;
  }

  /**
   * 按ID删除卡片信息
   *
   * @param cardId id
   * @returns 是否成功
   */
  public async deleteFormInfoById(cardId: string, isOuter?: boolean): Promise<boolean> {
    log.showInfo(`deleteFormInfoById start, cardId is: ${cardId}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, cardId);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    const changeRows = await rdbTaskPool.delete(this.getLayoutInfoTableName(isOuter), conditions);
    if (changeRows === 1) {
      log.showInfo(`deleteFormInfoById delete ok: ${changeRows}`);
      return true;
    } else {
      log.showError(`deleteFormInfoById delete fail, cardId=${cardId}`);
      return false;
    }
  }

  /**
   * 按位置删除卡片信息
   *
   * @param page column row
   * @param isOuter 是否是外屏
   * @returns 是否成功
   */
  public async deleteFormInfoByPosition(page: number, column: number, row: number, isOuter: boolean): Promise<boolean> {
    log.showInfo(`deleteFormInfoByPosition start, page:${page} column:${column} row: ${row}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.PAGE_INDEX, page);
    conditions.set(GridLayoutInfoColumns.COLUMN, column);
    conditions.set(GridLayoutInfoColumns.ROW, row);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    const changeRows = await rdbTaskPool.delete(this.getLayoutInfoTableName(isOuter), conditions);
    if (changeRows === 1) {
      log.showInfo(`deleteFormInfoByPosition delete ok: ${changeRows}`);
      return true;
    } else {
      log.showError('deleteFormInfoByPosition delete fail');
      return false;
    }
  }

  /**
   * 按应用名删除卡片信息
   *
   * @param bundleName bundleName
   * @param typeId 可选参数，需要删除的元素类型，默认是所有类型
   * @param appIndex 可选参数，需要删除的分身id，默认相同bundle下的所有分身都会删除
   * @param shortcutId 可选参数，需要删除的快捷方式id，默认相同bundle下的所有快捷方式都会删除
   * @returns 是否成功
   */
  public async deleteInfoByBundle(bundleName: string, typeId?: number, appIndex?: number, isOuter?: boolean,
      shortcutId?: string): Promise<boolean> {
    log.showInfo(`deleteInfoByBundle start ${bundleName}${appIndex}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, bundleName);
    if (typeId) {
      conditions.set(GridLayoutInfoColumns.TYPE_ID, typeId);
    }
    if ((appIndex ?? 0) >= 0) {
      conditions.set(GridLayoutInfoColumns.APP_INDEX, appIndex);
    }
    if (shortcutId) {
      conditions.set(GridLayoutInfoColumns.SHORTCUT_ID, shortcutId);
    }
    const changeRows = await rdbTaskPool.delete(this.getLayoutInfoTableName(isOuter), conditions);
    log.showWarn('deleteInfoByBundle bundleName:%{public}s changeRows: %{public}d', bundleName, changeRows);
    return changeRows >= 1;
  }

  /**
   * 应用卸载后，也需要同步删除其他布局模式的表中应用数据
   *
   * @param bundleName bundleName
   *
   */
  public async deleteInfoFromOtherTable(bundleName: string): Promise<void> {
    log.showInfo(`deleteInfoByBundleName start ${bundleName}`);
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      return;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, bundleName);
    let desktopLayout: number = Number(sSettingsUtil.getValue(CommonConstants.SIMPLE_MODE_KEY, '0'));
    let tableName: string = desktopLayout === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL?
      RdbStoreConfig.gridLayoutInfo.tableName : RdbStoreConfig.simpleLayoutInfo.tableName;
    rdbTaskPool.delete(tableName, conditions).then((rows: Number) => {
      log.showWarn(`deleteItemsByBundleName: ${rows}`);
    }).catch((err) => {
      log.showError(`deleteItemsByBundleName failed, code is ${err?.code}, message is ${err?.message}`);
    });
  }

  /**
   * 按应用名删除外屏应用信息
   *
   * @param bundleName bundleName
   * @param appIndex 可选参数，需要删除的分身id，默认相同bundle下的所有分身都会删除
   * @returns 是否成功
   */
  public async deleteOuterInfoByBundle(bundleName: string, appIndex?: number, typeId: number = 0): Promise<boolean> {
    try {
      log.showInfo(`deleteOuterInfoByBundle start ${bundleName}${appIndex}`);
      let conditions: Map<string, rdb.ValueType> = new Map();
      conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, bundleName);
      conditions.set(GridLayoutInfoColumns.TYPE_ID, typeId);
      if ((appIndex ?? 0) >= 0) {
        conditions.set(GridLayoutInfoColumns.APP_INDEX, appIndex);
      }
      const changeRows = await rdbTaskPool.delete(this.getLayoutInfoTableName(true), conditions);
      if (changeRows >= 1) {
        log.showInfo('deleteOuterInfoByBundle delete ok: %{public}d', changeRows);
        return true;
      } else {
        log.showInfo('deleteOuterInfoByBundle delete failed: %{public}d', changeRows);
        return false;
      }
    } catch (error) {
      log.showError('deleteGridLayoutItemsByDeleteItem with error %{public}s', error.message);
      return false;
    }
  }

  /**
   * 按卡片bundleName、卡片名和容器删除堆叠里的卡片
   *
   * @param formItem 堆叠里的卡片
   * @param containerId 堆叠的container
   * @returns 是否成功
   */
  public async deleteFormInFormStackByNameAndContainer(formItem: GridLayoutItemInfo,
                                                       containerId: number): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(formItem)) {
      log.showWarn('cannot deleteForm in formStack as the formItem is empty ');
      return false;
    }
    log.showInfo('deleteFormInFormStackByNameAndContainer start, bundleName: %{public}s fromName: %{public}s ' +
      'container: %{public}d', formItem.bundleName, formItem.cardName, containerId);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, formItem.bundleName);
    conditions.set(GridLayoutInfoColumns.INFO_NAME, formItem.cardName);
    conditions.set(GridLayoutInfoColumns.CONTAINER, containerId);
    const changeRows = await rdbTaskPool.delete(this.mLayoutTableName, conditions);
    if (changeRows === 1) {
      log.showInfo(`deleteFormInFormStackByNameAndContainer delete ok: ${changeRows}`);
      return true;
    } else {
      log.showError('deleteFormInFormStackByNameAndContainer delete fail');
      return false;
    }
  }

  private ifStringIsNull(str: string | null | undefined): boolean {
    if (str === undefined || str === '' || str === null) {
      return true;
    }
    return false;
  }

  async updateSettings(key: string, value: dataPreferences.ValueType): Promise<boolean> {
    if (!this.preferences) {
      try {
        this.preferences = await dataPreferences.getPreferences(GlobalContext.getContext(), 'launcher_preferences');
      } catch (error) {
        log.error('updateSettings error', error);
      }
    }
    log.showInfo(`updateSettings key:${key} value:${value}`);
    this.preferences?.putSync(key, value);
    await this.preferences?.flush().then(() => {
      log.showInfo(`updateSettings ${key} to sp successs`);
    }).catch((e: Error) => {
      log.showInfo(`updateSettings ${key} to sp fail error: ${e?.message}`);
    });
    return false;
  }

  async querySettings(key: string, defaultVal: dataPreferences.ValueType):
    Promise<dataPreferences.ValueType | undefined> {
    // In the multi-process scenario, the cache needs to be cleared. Otherwise, the correct value cannot be obtained.
    if (globalThis.backupStatus) {
      try {
        dataPreferences.removePreferencesFromCacheSync(GlobalContext.getContext(), 'launcher_preferences');
      } catch (error) {
        log.error('querySettings error', error);
      }
      this.preferences = null;
    }
    if (!this.preferences) {
      try {
        this.preferences = await dataPreferences.getPreferences(GlobalContext.getContext(), 'launcher_preferences');
      } catch (error) {
        log.error('querySettings error', error);
      }
    }
    let value = this.preferences?.getSync(key, defaultVal).valueOf();
    return value;
  }

  private async genPreferences(functionTag: string): Promise<void> {
    if (!this.preferences) {
      let callback: Function = async (callbackContext: common.Context) => {
        try {
          callbackContext.area = contextConstant.AreaMode.EL1;
          this.preferences = await dataPreferences.getPreferences(callbackContext, 'launcher_preferences');
        } catch (error) {
          log.error('genPreferences error', error);
        }
      }
      await ContextModifyUtils.modifyTargetContextAsync(GlobalContext.getContext() as common.Context,
        contextConstant.AreaMode.EL1, callback, `${TAG}-${functionTag}`);
    }
  }

  async updateDesktopPageCount(value: dataPreferences.ValueType, isOuter?: boolean): Promise<boolean> {
    await this.genPreferences('updateDesktopPageCount');
    let key: string = desktopUtil.getPageCount(isOuter);
    if (key === CommonConstants.DESKTOP_PAGE_COUNT) {
      key = (this.mLayoutTableName === RdbStoreConfig.simpleLayoutInfo.tableName) ?
      CommonConstants.SIMPLE_DESKTOP_PAGE_COUNT : CommonConstants.DESKTOP_PAGE_COUNT;
    }
    log.showInfo(`updateSettings key:${key} value:${value}`);
    this.preferences?.putSync(key, value);
    await this.preferences?.flush().then(() => {
      log.showInfo(`updateSettings ${key} to sp successs`);
    }).catch((e: Error) => {
      log.showInfo(`updateSettings ${key} to sp fail error: ${e?.message}`);
    });
    return false;
  }

  async querySettingsPageCount(isOuter?: boolean): Promise<number> {
    // In the multi-process scenario, the cache needs to be cleared. Otherwise, the correct value cannot be obtained.
    if (GlobalContext.getInstance().getObject('backupStatus')) {
      try {
        dataPreferences.removePreferencesFromCacheSync(GlobalContext.getContext(), 'launcher_preferences');
      } catch (error) {
        log.error('querySettingsPageCount error', error);
      }
      this.preferences = null;
    }
    await this.genPreferences('querySettingsPageCount');
    let key: string = 'page_count';
    if (isOuter === undefined) {
        key = desktopUtil.getPageCount();

    }
    if (isOuter) {
      key = 'outer_page_count';
    } else {
      key = (this.mLayoutTableName === RdbStoreConfig.simpleLayoutInfo.tableName) ?
      CommonConstants.SIMPLE_DESKTOP_PAGE_COUNT : CommonConstants.DESKTOP_PAGE_COUNT;
    }
    let count = this.preferences?.getSync(key, DEFAULT_PAGE).valueOf() as number;
    log.showInfo(`querySettingsPageCount key:${key} count:${count}`);
    return count;
  }

  async querySettingsMaxFormCount(isOuter?: boolean): Promise<number> {
    if (!this.preferences) {
      try {
        this.preferences = await dataPreferences.getPreferences(GlobalContext.getContext(), 'launcher_preferences');
      } catch (error) {
        log.error('querySettingsMaxFormCount error', error);
      }
    }
    let key: string = 'max_form_count';
    if (isOuter) {
      key = 'outer_max_form_count';
    }
    try {
      let count = this.preferences?.getSync(key,
        DefaultDesktopLayoutInfo.getDefaultLayoutInfo().layoutDescription.maxForm).valueOf() as number;
      log.showInfo(`querySettingsMaxFormCount key:${key} count:${count}`);
      return count;
    } catch (error) {
      log.error('querySettingsMaxFormCount error', error);
      return DefaultDesktopLayoutInfo.getDefaultLayoutInfo().layoutDescription.maxForm;
    }
  }

  /**
   * 新增smartDock
   *
   * @param dockInfoList Dock列表
   * @param tableName 表名
   * @returns true:新增成功;false:新增失败
   */
  public async insertIntoSmartdock(dockInfoList: DockItemInfo[], tableName?: string): Promise<boolean> {
    log.showInfo(`insertIntoSmartdock dockInfoList: ${dockInfoList?.length}`);
    if (CheckEmptyUtils.isEmpty(dockInfoList)) {
      return false;
    }
    let insertList: DockItemInfo[] = [];
    for (let i = 0; i < dockInfoList.length; i++) {
      let item: DockItemInfo = dockInfoList[i];
      let insertItem: DockItemInfo = new DockItemInfo();
      this.updateDockInfoNameFromIconCache(item);
      insertItem.appId = item.appId;
      insertItem.itemType = item.itemType;
      insertItem.typeId = item.typeId;
      insertItem.bundleName = item.bundleName;
      insertItem.moduleName = item.moduleName;
      insertItem.abilityName = item.abilityName;
      insertItem.appIconId = item.appIconId;
      insertItem.appLabelId = item.appLabelId;
      insertItem.appName = item.appName;
      insertItem.iconId = item.iconId;
      insertItem.layoutInfo = item.layoutInfo;
      insertItem.callerName = item.callerName;
      insertItem.layoutInfo?.forEach((gridItems: GridLayoutItemInfo[]) => {
        this.updateGridInfoNameFromIconCache(gridItems);
        for (let i = 0; i < gridItems.length; i++) {
          gridItems[i] = GridLayoutUtil.mapProxyTypeGridLayout(gridItems[i]);
        }
      });
      insertItem.appStatus = item.appStatus;
      insertItem.iconResource = item.iconResource;
      insertItem.appIndex = item.appIndex;
      insertItem.shortcutId = item.shortcutId;
      insertItem.intent = item.intent;
      log.showDebug(`insertIntoSmartdock insertItem: ${JSON.stringify(insertItem)}`);
      insertList.push(insertItem);
    }
    let tName = this.getTableName(false, tableName);
    return await rdbTaskPool.insertIntoSmartdock(insertList, tName);
  }

  /**
   * 新增Dock的最近任务区
   *
   * @param recentDockList 最近任务区列表
   * @returns true:新增成功;false:新增失败
   */
  public async insertIntoRecentDock(recentDockList: DockItemInfo[]): Promise<boolean> {
    log.showInfo(`insertIntoRecentDock recentDockList: ${recentDockList?.length}`);
    if (CheckEmptyUtils.isEmpty(recentDockList)) {
      return false;
    }
    // 必须复制一份用来存入数据库，否则会有序列化异常
    let insertList: DockItemInfo[] = recentDockList.slice();
    return await rdbTaskPool.insertIntoRecentDock(insertList, RdbStoreConfig.recentDockInfo.tableName);
  }

  /**
   * Dock的最近任务区图标数量
   *
   * @param visibleCount 最近任务区列表数量
   * @returns true:新增成功;false:新增失败
   */
  public async insertIntoRecentDockInfo(visibleCount: number): Promise<boolean> {
    log.showInfo(`insertIntoRecentDockInfo visibleCount: ${visibleCount}`);
    if (CheckEmptyUtils.isEmpty(visibleCount)) {
      return false;
    }
    return await rdbTaskPool.insertIntoRecentDockInfo(visibleCount, RdbStoreConfig.recentDockLayoutInfo.tableName);
  }

  /**
   * delete recent dock all data
   *
   * @returns affected columns number
   */
  public async deleteAllRecentDockData(): Promise<number> {
    try {
      log.showInfo('delete recent dock data started');
      let condition: Map<string, rdb.ValueType> = new Map();
      return rdbTaskPool.delete(RdbStoreConfig.recentDockInfo.tableName, condition);
    } catch (err) {
      log.showError(`delete recent dock data failed, code is ${err.code}, message is ${err.message}`);
    }
    return 0;
  }

  /**
   * 删除dock元素
   *
   * @param bundleName bundleName
   * @returns 是否成功
   */
  public async deleteSmartDockItem(bundleName: string, appIndex?: number, shortcutId?: string, isOuter?: boolean): Promise<boolean> {
    log.showInfo(`deleteSmartDockItem start bundleName:${bundleName}, appIndex:${appIndex}, shortcutId:${shortcutId}`);
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, bundleName);
    conditions.set(GridLayoutInfoColumns.APP_INDEX, appIndex ?? 0);
    conditions.set(GridLayoutInfoColumns.SHORTCUT_ID, shortcutId ?? '');
    conditions.set(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_SMARTDOCK);
    const changeRows = await rdbTaskPool.delete(this.getLayoutInfoTableName(isOuter), conditions);
    if (changeRows >= 1) {
      log.showInfo(`deleteSmartDockItem delete ok:${changeRows}`);
      return true;
    }
    return false;
  }

  /**
   * 删除dock元素
   *
   * @param bundleName bundleName
   * @param appIndex appIndex
   * @returns 是否成功
   */
  public async deleteSmartDockByBundleAndAppIndex(bundleName: string, appIndex: number): Promise<boolean> {
    log.showInfo('deleteSmartDockByBundleAndAppIndex bundleName:' + bundleName + 'appIndex:' + appIndex);
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, bundleName);
    if (!CheckEmptyUtils.isEmpty(appIndex)) {
      conditions.set(GridLayoutInfoColumns.APP_INDEX, appIndex);
    }
    conditions.set(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_SMARTDOCK);
    const changeRows = await rdbTaskPool.delete(RdbStoreConfig.gridLayoutInfo.tableName, conditions);
    if (changeRows >= 1) {
      log.showInfo(`deleteSmartDockByBundleAndAppIndex delete ok:${changeRows}`);
      return true;
    }
    return false;
  }

  /**
   * 删除最近任务区元素
   *
   * @param bundleName bundleName
   * @returns 是否成功
   */
  public async deleteRecentDockByBundle(bundleName: string, appIndex: number): Promise<boolean> {
    log.showInfo('deleteRecentDockByBundle bundle name :' + bundleName);
    if (this.ifStringIsNull(bundleName)) {
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(RecentDockInfoColumns.BUNDLE_NAME, bundleName);
    conditions.set(RecentDockInfoColumns.APP_INDEX, appIndex);
    const changeRows = await rdbTaskPool.delete(RdbStoreConfig.recentDockInfo.tableName, conditions);
    if (changeRows >= 1) {
      log.showInfo(`deleteRecentDockByBundle delete success, the row number is :${changeRows}`);
      return true;
    }
    return false;
  }

  /**
   * delete form table
   * @returns Promise<void>
   */
  public async dropFormTable(): Promise<void> {
    log.showInfo('dropFormTable start');
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    const changeRows = await rdbTaskPool.delete(this.getLayoutInfoTableName(), conditions);
    if (changeRows > 0) {
      log.showInfo(`deleteFormInfoById delete rows ok: ${changeRows}`);
    }
  }

  /**
   * 查询smartDock元素，container = -101
   *
   * @returns smartDock元素列表
   */
  public async querySmartDock(isOuter?: boolean, tableName?: string): Promise<DockItemInfo[]> {
    log.showInfo('querySmartDock start');
    let tName = this.getTableName(isOuter, tableName);
    let dockItems: DockItemInfo[] = await rdbTaskPool.querySmartDock(tName);
    return dockItems;
  }

  /**
   * 查询应用中心数据
   * @returns 应用中心元素列表
   */
  public async queryAppCenter(): Promise<AppGridItemInfo[]> {
    log.showInfo('queryAppCenter start');
    return await rdbTaskPool.queryAppCenter(RdbStoreConfig.appCenterLayoutInfo.tableName);
  }

  /**
   * 查询Dock区的最近任务应用，container = -102
   *
   * @returns 最近任务应用列表
   */
  public async queryRecentDock(): Promise<DockItemInfo[]> {
    log.showInfo('queryRecentDock start');
    let dockItems: DockItemInfo[] = await rdbTaskPool.queryRecentDock(RdbStoreConfig.recentDockInfo.tableName);
    return dockItems;
  }

  /**
   * 查询Dock区的最近任务应用数量
   *
   * @returns 最近任务应用列表
   */
  public async queryRecentDockInfo(): Promise<number> {
    log.showInfo('queryRecentDockInfo start');
    let visibleCount: number = await rdbTaskPool.queryRecentDockInfo(RdbStoreConfig.recentDockLayoutInfo.tableName);
    return visibleCount;
  }

  booleanToNumber(data: boolean): number {
    return data ? 1 : 0;
  }

  numberToBoolean(data: number): boolean {
    return data === 1;
  }

  /**
   * 获取所有上滑卡片信息
   *
   * @returns 卡片列表
   */
  public async getAllSwiperFormInfo(): Promise<SwiperItemInfo[]> {
    log.showInfo('getAllSwiperFormInfo start');
    return await rdbTaskPool.querySwiperForm(RdbStoreConfig.formSwiper.tableName, undefined);
  }

  /**
   * 更新上滑卡片信息
   *
   * @return 是否成功
   */
  public async updateSwiperFormInfo(formItem: SwiperItemInfo): Promise<boolean> {
    log.showInfo('updateSwiperFormInfo start');
    if (formItem === null || formItem === undefined) {
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, formItem.bundleName);
    const valuesBucket = formItem.toValuesBucket();
    let changeRows = await rdbTaskPool.update(RdbStoreConfig.formSwiper.tableName, conditions, valuesBucket);
    if (changeRows >= 1) {
      log.showInfo(`updateSwiperFormInfo updated ok: ${changeRows}`);
      return true;
    } else {
      changeRows = await rdbTaskPool.insert(RdbStoreConfig.formSwiper.tableName, valuesBucket);
      log.showInfo(`updateSwiperFormInfo insert: ${changeRows}`);
      return (changeRows !== CommonConstants.INVALID_VALUE);
    }
  }

  /**
   * 更新分区文件夹及其子元素信息
   *
   * @return 是否成功
   */
  public async updateRegionFolderAndSubItemsInfo(folder: GridLayoutItemInfo): Promise<void> {
    if (!GridLayoutUtil.isValidLayoutItem(folder)) {
      log.showError(`updateRegionFolderAndSubItemsInfo fail, folder is not valid`);
      return;
    }
    log.showInfo(`updateRegionFolderAndSubItemsInfo start, id:${folder.infoId}`);
    await this.updateRegionFolderInfo(folder);
    await this.updateSubItemsInfo(folder);
  }

  private async updateRegionFolderInfo(folder: GridLayoutItemInfo): Promise<void> {
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, folder.infoId);
    const updateBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.INFO_NAME]: folder.infoName,
      [GridLayoutInfoEnums.URI]: folder.uri,
      [GridLayoutInfoEnums.FILE_TYPE]: folder.fileType,
      [GridLayoutInfoEnums.CONTAINER]: folder.container,
      [GridLayoutInfoEnums.WIDTH]: folder.area?.[0],
      [GridLayoutInfoEnums.HEIGHT]: folder.area?.[1],
      [GridLayoutInfoEnums.PAGE_INDEX]: folder.page,
      [GridLayoutInfoEnums.COLUMN]: folder.column,
      [GridLayoutInfoEnums.ROW]: folder.row,
      [GridLayoutInfoEnums.FILE_INO]: folder.ino,
      [GridLayoutInfoEnums.FILE_SIZE]: folder.size,
      [GridLayoutInfoEnums.FILE_CREATE_TIME]: folder.ctime,
      [GridLayoutInfoEnums.FILE_MODIFICATION_TIME]: folder.mtime,
    };
    let changeRows = await rdbTaskPool.update(this.getLayoutInfoTableName(), conditions, updateBucket);
    if (changeRows >= 1) {
      log.showInfo(`updateRegionFolderAndSubItemsInfo updated ok: ${changeRows}`);
    } else {
      let insertBucket = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(folder).toValuesBucket();
      changeRows = await rdbTaskPool.insert(this.getLayoutInfoTableName(), insertBucket);
      log.showInfo(`updateRegionFolderAndSubItemsInfo insert: ${changeRows}`);
    }
  }

  public async updateSubItemsInfo(folder: GridLayoutItemInfo, sceneMsg:string = SceneMsgEnum.RDB_DEFAULT_UPDATE): Promise<void> {
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, folder.infoId);
    let result = await rdbTaskPool.queryGridLayoutInfo(this.getLayoutInfoTableName(), conditions);
    if (CheckEmptyUtils.isEmptyArr(result)) {
      log.showWarn(`updateSubItemsInfo fail, folder not exit`);
      return;
    }
    const folderId = result[0].id;
    log.showInfo(`updateSubItemsInfo folderId: ${folderId}`);
    const subItems = folder.layoutInfo?.flat() ?? [];
    for (const subItem of subItems) {
      subItem.container = folderId;
      let tableName: string = this.getLayoutInfoTableName();
      const predicates = new rdb.RdbPredicates(tableName);
      predicates.notEqualTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_SMARTDOCK);
      predicates.equalTo(GridLayoutInfoColumns.TYPE_ID, subItem.typeId);
      let whereSql: string =
        `${GridLayoutInfoColumns.CONTAINER}!=${CommonConstants.CONTAINER_SMARTDOCK} AND ${GridLayoutInfoColumns.TYPE_ID}=${subItem.typeId}`;
      if (subItem.typeId === CommonConstants.TYPE_APP || subItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        predicates.equalTo(GridLayoutInfoColumns.BUNDLE_NAME, subItem.bundleName)
          .and().equalTo(GridLayoutInfoColumns.APP_INDEX, subItem.appIndex ?? 0)
          .and().equalTo(GridLayoutInfoColumns.SHORTCUT_ID, subItem.shortcutId ?? '');
        whereSql += (`${GridLayoutInfoColumns.BUNDLE_NAME}!=${subItem.bundleName} AND ${GridLayoutInfoColumns.APP_INDEX}=${subItem.appIndex ?? 0}
        AND ${GridLayoutInfoColumns.SHORTCUT_ID}=${subItem.shortcutId ?? ''}`);
      } else if (subItem.typeId === CommonConstants.TYPE_FILE_FOLDER) {
        predicates.equalTo(GridLayoutInfoColumns.FILE_INO, subItem.ino);
        whereSql += (`${GridLayoutInfoColumns.FILE_INO}!=${subItem.ino}`);
      }
      const updateBucket: rdb.ValuesBucket = {
        [GridLayoutInfoEnums.INFO_NAME]: subItem.infoName,
        [GridLayoutInfoEnums.URI]: subItem.uri,
        [GridLayoutInfoEnums.FILE_TYPE]: subItem.fileType,
        [GridLayoutInfoEnums.CONTAINER]: subItem.container,
        [GridLayoutInfoEnums.WIDTH]: subItem.area?.[0],
        [GridLayoutInfoEnums.HEIGHT]: subItem.area?.[1],
        [GridLayoutInfoEnums.PAGE_INDEX]: subItem.page,
        [GridLayoutInfoEnums.COLUMN]: subItem.column,
        [GridLayoutInfoEnums.ROW]: subItem.row,
        [GridLayoutInfoEnums.FILE_INO]: subItem.ino,
        [GridLayoutInfoEnums.FILE_SIZE]: subItem.size,
        [GridLayoutInfoEnums.FILE_CREATE_TIME]: subItem.ctime,
        [GridLayoutInfoEnums.FILE_MODIFICATION_TIME]: subItem.mtime,
        [GridLayoutInfoEnums.APP_ICON_ID]: subItem.appIconId,
        [GridLayoutInfoEnums.APP_LABEL_ID]: subItem.appLabelId,
      };
      let executeUpdateInfo: string =
        `UPDATE ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(updateBucket)} WHERE ${whereSql}`;
      let changeRows = await rdbTaskPool.updatePredicates(predicates, updateBucket, sceneMsg, tableName);
      if (changeRows >= 1) {
        log.showInfo(`updateSubItemsInfo update when ${sceneMsg}, executeUpdateInfo: ${executeUpdateInfo}, res=${changeRows}`);
      } else {
        let insertBucket = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(subItem).toValuesBucket();
        let executeInsertInfo: string = `INSERT INTO ${tableName} SET ${rdbStoreHelper.valuesBucketToStr(insertBucket)}`;
        changeRows = await rdbTaskPool.insert(this.getLayoutInfoTableName(), insertBucket);
        log.showInfo(`updateSubItemsInfo insert when ${sceneMsg}, executeInsertInfo: ${executeInsertInfo}, res=${changeRows}`);
      }
    }
  }

  async queryAppCenterInstallApp(): Promise<AppItemInfo[]> {
    const resultList: AppItemInfo[] = [];
    let resultSet: rdb.ResultSet | undefined = undefined;
    try {
      const predicates = new rdb.RdbPredicates(this.getLayoutInfoTableName());
      predicates.equalTo(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_APP).and()
        .equalTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.INVALID_VALUE).and()
        .greaterThan(GridLayoutInfoColumns.APP_STATUS, 0);
      resultSet = await rdbStoreHelper.query(predicates, []);
      while (resultSet && resultSet.goToNextRow()) {
        let appItemInfo: AppItemInfo = new AppItemInfo();
        appItemInfo.appName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INFO_NAME));
        appItemInfo.appIconId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_ICON_ID));
        appItemInfo.appLabelId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_LABEL_ID));
        appItemInfo.bundleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME));
        appItemInfo.abilityName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ABILITY_NAME));
        appItemInfo.moduleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.MODULE_NAME));
        appItemInfo.keyName = appItemInfo.bundleName + appItemInfo.abilityName + appItemInfo.moduleName;
        appItemInfo.downloadProgress =
          resultSet.getDouble(resultSet.getColumnIndex(GridLayoutInfoColumns.DOWNLOAD_PROGRESS));
        appItemInfo.appStatus = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_STATUS));
        appItemInfo.iconResource = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ICON_RESOURCE));
        appItemInfo.callerName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.CALLER_NAME));
        resultList.push(appItemInfo);
      }
    } catch (e) {
      log.showError(`queryDesktopApplication, code is ${e.code}, message is ${e.message}`);
    } finally {
      resultSet?.close();
      resultSet = undefined;
    }
    return resultList;
  }

  async queryDesktopApplication(isOuter?: boolean): Promise<AppItemInfo[]> {
    const resultList: AppItemInfo[] = [];
    try {
      const predicates = new rdb.RdbPredicates(this.getLayoutInfoTableName(isOuter));
      predicates.beginWrap().equalTo(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_APP)
        .or().equalTo(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_SHORTCUT_ICON)
        .endWrap()
        .and().equalTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_DESKTOP);
      let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, []);
      while (resultSet && resultSet.goToNextRow()) {
        let appItemInfo: AppItemInfo = new AppItemInfo();
        appItemInfo.appName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INFO_NAME));
        appItemInfo.appIconId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_ICON_ID));
        appItemInfo.appLabelId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_LABEL_ID));
        appItemInfo.bundleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME));
        appItemInfo.abilityName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ABILITY_NAME));
        appItemInfo.moduleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.MODULE_NAME));
        appItemInfo.downloadProgress = resultSet.getDouble(resultSet.getColumnIndex(GridLayoutInfoColumns.DOWNLOAD_PROGRESS));
        appItemInfo.appStatus = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_STATUS));
        appItemInfo.iconResource = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ICON_RESOURCE));
        appItemInfo.callerName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.CALLER_NAME));
        appItemInfo.typeId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.TYPE_ID));
        appItemInfo.appIndex = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_INDEX));
        appItemInfo.shortcutId = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.SHORTCUT_ID));
        appItemInfo.keyName = AppItemInfo.getKeyName(appItemInfo);
        resultList.push(appItemInfo);
      }
      resultSet?.close();
      resultSet = undefined;
    } catch (e) {
      log.showError('queryDesktopApplication error%{public}d:%{public}s', e.code, e.message);
    }
    log.showInfo(`queryDesktopApplication resultList length: ${resultList.length}`);
    return resultList;
  }

  async queryNotInstalledApplication(): Promise<string[]> {
    log.showInfo('queryNotInstalledApplication start');
    let appItems: string[] = await rdbTaskPool.queryNotInstalledApplication(this.getLayoutInfoTableName());
    return appItems;
  }

  ifDuplicatePosition(layoutInfo: GridLayoutItemInfo[], insertPositionInfo: number[], area: number[]): boolean {
    let mPositionInfo: number[][] = [];
    const pageIndex = 0;
    const rowIndex = 1;
    const columnIndex = 2;
    const positionLength = 3;
    const container = 4;
    if (insertPositionInfo && insertPositionInfo.length === positionLength) {
      log.showInfo(`ifDuplicatePosition insertPositionInfo: ${JSON.stringify(insertPositionInfo)}`);
      for (let j = 0; j < area[1]; j++) {
        for (let k = 0; k < area[0]; k++) {
          const position: number[] = [];
          position[pageIndex] = insertPositionInfo[pageIndex];
          position[rowIndex] = insertPositionInfo[rowIndex] + j;
          position[columnIndex] = insertPositionInfo[columnIndex] + k;
          position[container] = CommonConstants.CONTAINER_DESKTOP;
          mPositionInfo.push(position);
        }
      }
      log.showInfo(`ifDuplicatePosition insertPositionInfo: ${JSON.stringify(mPositionInfo)}`);
    }

    for (let i = 0; i < layoutInfo.length; i++) {
      let mArea = layoutInfo[i].area;
      if (!mArea) {
        continue;
      }
      for (let j = 0; j < mArea[1]; j++) {
        for (let k = 0; k < mArea[0]; k++) {
          const position: number[] = [];
          position[pageIndex] = (layoutInfo[i].page ?? -1);
          position[rowIndex] = (layoutInfo[i].row ?? 0) + j;
          position[columnIndex] = (layoutInfo[i].column ?? 0) + k;
          position[container] = (layoutInfo[i].container ?? -1);
          mPositionInfo.push(position);
        }
      }
    }
    for (let i = 0; i < mPositionInfo.length; i++) {
      for (let j = mPositionInfo.length - 1; j > 0 && j > i; j--) {
        if (mPositionInfo[i][pageIndex] === mPositionInfo[j][pageIndex] &&
          mPositionInfo[i][rowIndex] === mPositionInfo[j][rowIndex] &&
          mPositionInfo[i][columnIndex] === mPositionInfo[j][columnIndex] &&
          mPositionInfo[i][container] === mPositionInfo[j][container]) {
          log.showError(`ifDuplicatePosition error position: ${JSON.stringify(mPositionInfo[i])}`);
          return true;
        }
      }
    }
    return false;
  }

  /**
   *  delete gridlayout_info all data
   * @returns
   */
  public async deleteAllGridInfoData(isOuter?: boolean): Promise<number> {
    try {
      log.showError('delete gridInfo data started, isOuter=%{public}s', isOuter);
      let condition: Map<string, rdb.ValueType> = new Map();
      return rdbTaskPool.delete(this.getLayoutInfoTableName(isOuter), condition);
    } catch (err) {
      log.showError(`delete gridInfo data failed, code is ${err.code}, message is ${err.message}`);
    }
    return 0;
  }

  /**
   * 插入布局信息
   *
   * @param gridlayoutInfo 布局信息数组
   * @returns true:更新成功;false:更新失败
   */
  public async insertGridLayoutInfo(gridlayoutInfo: GridLayoutItemInfo[], isNeedCheckPosition: boolean = true,
                                    isOuter?: boolean, ctx?: SingleContext): Promise<boolean> {
    if (CheckEmptyUtils.isEmptyArr(gridlayoutInfo)) {
      HiDfxEventUtil.reportRDBAbnormal(RDBErrorCode.EMPTY_PARAM, `gridlayoutInfo is empty when insertGridLayoutInfo`);
      log.showError('insertGridLayoutInfo gridlayoutInfo is empty');
      return false;
    }
    log.showWarn(`insertGridLayoutInfo start, length=${gridlayoutInfo.length}, isOuter=${isOuter} isDisableInsert:${this.isDisableInsert()}. isNeedCheckPosition:${isNeedCheckPosition}`);
    if (this.isDisableInsert()) {
      HiDfxEventUtil.reportRDBAbnormal(RDBErrorCode.DISABLE_INSERT, `isDisableInsert is true when insertGridLayoutInfo`);
      log.showError('insertGridLayoutInfo isDisableInsert');
      return false;
    }
    if (isNeedCheckPosition && this.ifDuplicatePosition(gridlayoutInfo, [], [])) {
      HiDfxEventUtil.reportRDBAbnormal(RDBErrorCode.DUPLICATE_POSITION, 'gridlayoutInfo is Duplicate when insertGridLayoutInfo');
      log.showError('insertGridLayoutInfo gridlayoutInfo is Duplicate');
      return false;
    }
    this.updateGridInfoNameFromIconCache(gridlayoutInfo);
    let layoutInfo = gridlayoutInfo.filter(item => !(item.column === -1 || item.row === -1))
      .map((value: GridLayoutItemInfo) => GridLayoutUtil.mapProxyTypeGridLayout(value));
    return rdbTaskPool.insertGridLayoutInfo(this.getLayoutInfoTableName(isOuter), layoutInfo, undefined , ctx);
  }

  /**
   * 插入布局信息并回填写库id
   * @param gridlayoutInfo 布局信息
   * @param isOuter
   * @returns true:insert成功;false:insert失败
   */
  public async insertLayoutInfoNotExist(gridlayoutInfo: GridLayoutItemInfo, isOuter?: boolean): Promise<boolean> {
    if (this.isDisableInsert()) {
      log.showError('insertGridLayoutInfo isDisableInsert');
      return false;
    }
    if (!gridlayoutInfo) {
      log.showError('insertGridLayoutInfo gridlayoutInfo is empty');
      return false;
    }
    log.showWarn('insertGridLayoutInfo start, bundleName:%{public}s, isOuter:%{public}s',
      gridlayoutInfo.bundleName, isOuter);

    this.updateGridInfoNameFromIconCache([gridlayoutInfo]);
    let layoutInfo = GridLayoutUtil.mapProxyTypeGridLayout(gridlayoutInfo);
    let insertId: number = await rdbTaskPool.insertLayoutInfoNotExist(this.getLayoutInfoTableName(isOuter), layoutInfo);
    gridlayoutInfo.id = insertId;
    let insertFlag = insertId !== -1;
    if (!insertFlag) {
      log.showError('insertGridLayoutInfo failed, bundleName:%{public}s', gridlayoutInfo.bundleName);
    }
    return insertFlag;
  }

  /**
   * 新增应用中心元素到数据库
   * @param appCenterItems 应用中心元素列表
   */
  public async insertAppCenter(appCenterItems: AppGridItemInfo[]): Promise<boolean> {
    log.showInfo('insertAppCenter start %{public}d', appCenterItems?.length);
    if (CheckEmptyUtils.isEmptyArr(appCenterItems)) {
      log.showError('insertAppCenter appCenterItems is empty');
      return false;
    }
    return await rdbTaskPool.insertAppCenter(RdbStoreConfig.appCenterLayoutInfo.tableName, appCenterItems);
  }

  /**
   * 从图标信息缓存中获取图标名称更新至gridlayoutInfo中
   * @param gridlayoutInfo
   */
  private updateGridInfoNameFromIconCache(gridlayoutInfo: GridLayoutItemInfo[]): void {
    gridlayoutInfo.forEach((layoutInfo: GridLayoutItemInfo) => {
      if (layoutInfo.typeId !== CommonConstants.TYPE_APP &&
        layoutInfo.typeId !== CommonConstants.TYPE_FOLDER) {
        return;
      }
      if (layoutInfo.typeId === CommonConstants.TYPE_FOLDER) {
        layoutInfo.layoutInfo?.forEach((items: GridLayoutItemInfo[]) => {
          this.updateGridInfoNameFromIconCache(items);
        });
        return;
      }
      let appName = IconResourceManager.getInstance()
        .getCachedIconNameSync(layoutInfo.bundleName, layoutInfo.moduleName,
          layoutInfo.abilityName, layoutInfo.appIndex);
      log.showInfo(`updateGridInfoNameFromIconCache appName is ${appName} bundleName:${layoutInfo.bundleName}` +
        ` moduleName:${layoutInfo.moduleName} abilityName:${layoutInfo.abilityName} appIndex:${layoutInfo.appIndex}` +
        ` layoutInfo.appName:${layoutInfo.appName} layoutInfo.appLabelId:${layoutInfo.appLabelId})`);
      if (!CheckEmptyUtils.checkStrIsEmpty(appName)) {
        layoutInfo.appName = appName;
      }
      if (CheckEmptyUtils.checkStrIsEmpty(layoutInfo.appName)) {
        log.showWarn(`updateGridInfoNameFromIconCache ${layoutInfo.bundleName} appName is empty`);
      }
    });
  }

  /**
   * 将intent格式转换为Map，以便于更新其中的键值对
   * @param intentStr
   */
  private convertIntentStringToMap(intentStr: string): Map<string, string> {
    let JSONObj: Record<string, string> = {};
    let intentMap: Map<string, string> = new Map();
    try {
      JSONObj = JSON.parse(intentStr);
      intentMap = new Map(Object.entries(JSONObj));
    } catch {
      log.showError('intent字段非json格式');
    }
    return intentMap;
  }

  /**
   * 将更新好的intent由Map转换为string，以便于存储到数据库中
   * @param intentMap
   */
  private convertIntentMapToString(intentMap: Map<string, string>): string {
    return CommonUtils.mapToJonStr(intentMap);
  }

  /**
   * 从图标信息缓存中获取图标名称更新至DockItemInfo中
   * @param dockItemInfo
   */
  private updateDockInfoNameFromIconCache(dockItemInfo: DockItemInfo): void {
    if (dockItemInfo.itemType !== CommonConstants.TYPE_APP) {
      return;
    }
    let appName = IconResourceManager.getInstance()
      .getCachedIconNameSync(dockItemInfo.bundleName, dockItemInfo.moduleName,
        dockItemInfo.abilityName, dockItemInfo.appIndex);
    log.info(`updateDockInfoNameFromIconCache appName is ${appName}`);
    if (!CheckEmptyUtils.checkStrIsEmpty(appName)) {
      dockItemInfo.appName = appName;
    }
  }

  /**
   * 检查元素是否存在，不存在则插入布局信息
   *
   * @param item 布局信息
   * @returns true:插入成功;false:插入失败
   */
  public async insertGridLayoutInfoWithCheck(item: GridLayoutItemInfo, isOuter?: boolean): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showWarn('insertGridLayoutInfoWithCheck item null');
      return false;
    }
    log.showInfo(`insertGridLayoutInfoWithCheck ${item.bundleName} ${item.abilityName} ${item.moduleName}`);
    let isExist = await this.isElementExistInGridLayout(item.bundleName, item.abilityName, item.moduleName ?? '',
      item.appIndex, item.shortcutId, isOuter);
    if (isExist) {
      log.showInfo(`insertGridLayoutInfoWithCheck already Exist ${item.keyName}`);
      return false;
    }
    log.showInfo(`insertGridLayoutInfoWithCheck ${item.bundleName} ${isExist}`);
    return await this.insertGridLayoutInfo([item], true, isOuter);
  }

  /**
   * 检查并插入数据
   * @param item 桌面元素对象
   * @returns 插入结果
   */
  public async insertGridLayoutInfoIfNotExist(item: GridLayoutItemInfo, ctx?: SingleContext): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showWarn('insertGridLayoutInfoIfNotExist item null');
      return false;
    }
    log.showInfo(`insertGridLayoutInfoIfNotExist ${item.bundleName} ${item.abilityName} ${item.moduleName}`);
    const isExist: boolean = await this.checkIfItemExist(item);
    if (isExist) {
      log.showInfo(`insertGridLayoutInfoIfNotExist already Exist ${item.keyName}`);
      return false;
    }
    log.showInfo(`insertGridLayoutInfoIfNotExist ${item.bundleName} ${isExist}`);
    return await this.insertGridLayoutInfo([item], true, undefined, ctx);
  }

  /**
   * get folder container
   *
   * @param item item
   * @returns folder container
   */
  public async getContainerByFolderId(item: GridLayoutItemInfo): Promise<number | undefined> {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showWarn('getContainerByFolderId item null');
      return undefined;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, item.folderId);
    let result: GridLayoutItemInfo[] = await rdbTaskPool.queryAllGridLayoutInfo(this.mLayoutTableName, conditions);
    if (result && !CheckEmptyUtils.isEmptyArr(result)) {
      return result[0].id;
    }
    return 0;
  }

  /**
   * 查询全搜定位信息
   *
   * @returns 桌面布局信息
   */
  public async queryLocationInfoById(id: string): Promise<GridLayoutItemInfo | null> {
    if (CheckEmptyUtils.isEmpty(id)) {
      log.showWarn('queryKeyNameById id null');
      return null;
    }

    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.ID, id);
    let result: GridLayoutItemInfo[] = await rdbTaskPool.queryAllGridLayoutInfo(RdbStoreConfig.gridLayoutInfo.tableName, conditions);
    if (!CheckEmptyUtils.isEmptyArr(result)) {
      return result[0];
    }
    return null;
  }

  /**
   * 根据bundleName查询布局信息
   * @param bundleName 包名
   * @returns 根据包名查询到的布局信息集合
   */
  public async queryGridLayoutItemsByBundleName(bundleName: string): Promise<GridLayoutItemInfo[]> {
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn('queryGridLayoutItemsByBundleName bundleName is null');
      return [];
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, bundleName);
    return await rdbTaskPool.queryAllGridLayoutInfo(this.getLayoutInfoTableName(), conditions);
  }

  /**
   * 查询桌面布局
   *
   * @returns 桌面布局信息
   */
  public async queryGridLayoutInfo(isOuter?: boolean, ctx?: SingleContext, isOrNotOneScreen?: boolean): Promise<GridLayoutItemInfo[]> {
    log.showInfo(`rdb queryGridLayoutInfo start ${isOuter}`);
    let result: GridLayoutItemInfo[] = await rdbTaskPool.queryGridLayoutInfo(this.getLayoutInfoTableName(isOuter),
      undefined, ctx, isOrNotOneScreen);
    return result;
  }

  /**
   * 查询布局信息，包括dock
   *
   * @returns 桌面布局信息
   */
  public async queryAllGridLayoutInfo(): Promise<GridLayoutItemInfo[]> {
    log.showInfo('queryAllGridLayoutInfo start');
    let result: GridLayoutItemInfo[] = await rdbTaskPool.queryAllGridLayoutInfo(this.getLayoutInfoTableName(),
      undefined);
    return result;
  }

  /**
   * 查询当前页桌面布局
   *
   * @returns 桌面布局信息
   */
  public async queryGridLayoutInfoByPage(pageIndex: number): Promise<GridLayoutItemInfo[]> {
    log.showInfo(`queryGridLayoutInfoByPage start: ${pageIndex}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.PAGE_INDEX, pageIndex);
    return await rdbTaskPool.queryGridLayoutInfoByPage(this.getLayoutInfoTableName(), conditions);
  }

  /**
   * 查询首页桌面和dock栏应用
   *
   * @returns 首页桌面和dock栏应用信息
   */
  public async queryFirstPageAndDockApplication(): Promise<GridLayoutItemInfo[]> {
    return await rdbTaskPool.queryFirstPageAndDockApplication(this.getLayoutInfoTableName());
  }

  /**
   * 判断元素是否存在布局文件中，包含dock区
   *
   * @param bundleName bundleName
   * @param abilityName abilityName
   * @param moduleName moduleName
   * @param appIndex appIndex
   * @returns true:存在 false:不存在
   */
  public async isElementExistInGridLayout(bundleName: string, abilityName: string, moduleName: string,
    appIndex: number = 0, shortcutId?: string, isOuter?: boolean): Promise<boolean> {
    log.showInfo(`isElementExistInGridLayout ${bundleName} ${abilityName} ${moduleName} ${appIndex} ${shortcutId}`);
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn('isElementExistInGridLayout bundleName null');
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, bundleName);
    if (abilityName) {
      conditions.set(GridLayoutInfoColumns.ABILITY_NAME, abilityName);
    }
    if (moduleName) {
      conditions.set(GridLayoutInfoColumns.MODULE_NAME, moduleName);
    }
    if (!Number.isNaN(appIndex)) {
      conditions.set(GridLayoutInfoColumns.APP_INDEX, appIndex ?? 0);
    }
    conditions.set(GridLayoutInfoColumns.SHORTCUT_ID, shortcutId ?? '');
    let target = this.getLayoutInfoTableName(isOuter);
    log.showInfo(`isElementExistInGridLayout ${target}`);
    return await rdbTaskPool.isElementExistInGridLayout(target, conditions);
  }

  /**
   * 新增文件夹
   *
   * @param items 布局元素
   * @returns true:新增成功;false:新增失败
   */
  public async insertFolderLayout(folder: GridLayoutItemInfo, folderAppInfos: GridLayoutItemInfo[]): Promise<boolean> {
    let gridLayoutDB = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(folder);
    let line = await rdbTaskPool.insert(this.getLayoutInfoTableName(false), gridLayoutDB.toValuesBucket());
    log.showWarn(`insertFolderLayout start ${line}`);
    this.addInfoToFolder(folder.folderId ?? '', folderAppInfos);
    return true;
  }

  /**
   * 新增布局元素(仅自身，不带layoutInfo内元素)
   *
   * @param items 布局元素
   * @returns 新增数据的Id
   */
  public async insertItemWithoutLayoutInfo(item: GridLayoutItemInfo, isOuter: boolean = false): Promise<number> {
    const gridLayoutDB = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(item);
    const id = await rdbTaskPool.insert(this.getLayoutInfoTableName(isOuter), gridLayoutDB.toValuesBucket());
    log.showWarn(`insert GridLayoutItemInfo id:${id}`);
    return id;
  }

  /**
   * 新增文件夹
   *
   * @param folder 文件夹元素
   * @param isOuter 是否是小外屏桌面
   * @returns 文件夹主键id
   */
  public async insertFolderLayoutInfo(folder: GridLayoutItemInfo, isOuter: boolean = false): Promise<number> {
    const folderLayoutDB = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(folder);
    const id = await rdbTaskPool.insert(this.getLayoutInfoTableName(isOuter), folderLayoutDB.toValuesBucket());
    let buckets: rdb.ValuesBucket[] = [];
    if (!folder.layoutInfo) {
      log.showWarn(`insert FolderLayoutInfo id:${id}, layoutInfo is empty`);
      return id;
    }
    for (const layoutItems of folder.layoutInfo) {
      buckets = buckets.concat(layoutItems.filter(tempItem => {
          if (tempItem.typeId === CommonConstants.TYPE_ADD) {
            return false;
          }
          return true;
        }).map(tempItem => {
          tempItem.container = id;
          const gridLayoutDB = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(tempItem);
          return gridLayoutDB.toValuesBucket();
      }));
    }
    let changeRows = await rdbTaskPool.batchInsert(this.getLayoutInfoTableName(isOuter), buckets);
    log.showWarn(`insert FolderLayoutInfo id:${id}, changeRows:${changeRows}`);
    return id;
  }

  /**
   * 校验数据库中是否已存在该元素
   * @param item 桌面元素对象
   * @returns 检查结果
   */
  public async checkIfItemExist(item: GridLayoutItemInfo): Promise<boolean> {
    if (!item || !item.infoId) {
      log.showWarn('checkIfItemExist infoId null');
      return false;
    }
    log.showInfo(`checkIfItemExist ${item.bundleName} ${item.abilityName} ${item.moduleName}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, item.infoId);
    const target: string = this.getLayoutInfoTableName();
    log.showInfo(`checkIfItemExist ${target}`);
    return await rdbTaskPool.isElementExistInGridLayout(target, conditions);
  }

  /**
   * 新增卡片堆叠
   *
   * @param formStack 新增卡片堆叠
   * @param cardListInfos 新增卡片堆叠内卡片
   * @returns true:新增成功;false:新增失败
   */
  public async insertFormStackLayout(formStack: GridLayoutItemInfo,
    cardListInfos: GridLayoutItemInfo[], needInsertLayoutInfo: GridLayoutItemInfo[],
    isOuter?: boolean): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(formStack) || CheckEmptyUtils.isEmptyArr(cardListInfos)) {
      log.showWarn('insertFormStackLayout formStack or cardListInfos empty');
      return false;
    }
    let gridLayoutDB: GridLayoutItemInfoDB = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(formStack);
    let line: number = await rdbTaskPool.insert(this.getLayoutInfoTableName(isOuter), gridLayoutDB.toValuesBucket());
    log.showWarn(`insertFormStackLayout start: ${line}`);
    if (line === CommonConstants.INVALID_VALUE) {
      log.showError('insertFormStackLayout fail!');
      return false;
    }
    if (!CheckEmptyUtils.isEmptyArr(needInsertLayoutInfo)) {
      for (let i = 0; i < needInsertLayoutInfo.length; i++) {
        // 更新container
        needInsertLayoutInfo[i].container = line;
      }
      // 过滤需要插入数据库的数据
      cardListInfos = this.filterCard(needInsertLayoutInfo, cardListInfos);
      const mapList: GridLayoutItemInfo[] = needInsertLayoutInfo.map(
        item => GridLayoutUtil.mapProxyTypeGridLayout(item));
      await RdbStoreManager.getInstance().insertGridLayoutInfo(mapList, false, isOuter);
    }
    this.addInfoToFormStack(formStack, cardListInfos, line, isOuter);
    return true;
  }

  // 从 source 中过滤 target 中的数据
  private filterCard(target: GridLayoutItemInfo[], source: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    const ret: GridLayoutItemInfo[] = [];
    for (let j = 0; j < source.length; j++) {
      let isNeeded = true;
      for (let i = 0; i < target.length; i++) {
        if (GridLayoutUtil.checkGridItemEqual(target[i], source[j])) {
          // 过滤
          isNeeded = false;
          break;
        }
      }
      if (isNeeded) {
        ret.push(source[j]);
      }
    }
    return ret;
  }

  /**
   * 添加应用到文件夹
   * @param infoId 文件夹folderId
   * @param itemInfo 待添加应用信息
   */
  public async addInfoToFolder(infoId: string, itemInfo: GridLayoutItemInfo[]): Promise<void> {
    if (CheckEmptyUtils.isEmpty(infoId) || CheckEmptyUtils.isEmptyArr(itemInfo)) {
      log.showWarn('addInfoToFolder folder or itemInfo empty');
      return;
    }
    itemInfo = itemInfo.filter(info => {
      return info.typeId === CommonConstants.TYPE_APP || info.typeId === CommonConstants.TYPE_SHORTCUT_ICON ||
        info.typeId === CommonConstants.TYPE_FILE_FOLDER;
    });
    log.showInfo(`addInfoToFolder ${infoId}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, infoId);
    let result = await rdbTaskPool.queryGridLayoutInfo(this.getLayoutInfoTableName(false), conditions);
    if (!CheckEmptyUtils.isEmpty(result)) {
      log.showInfo(`addInfoToFolder item ${result[0].id}`);
      this.updateInfoPosition(itemInfo, 'addInfoToFolder', new ExtraInfo(result[0].id, undefined, false));
    } else {
      this.insertFolderLayout(result[0], itemInfo);
    }
  }

  /**
   * 根据InfoId查询itemInfo
   * @param infoId
   * @returns
   */
  public async queryItemByInfoId(infoId: string): Promise<GridLayoutItemInfo> {
    if (CheckEmptyUtils.isEmpty(infoId)) {
      log.showWarn('queryItemByInfoId: infoId is empty');
      return new GridLayoutItemInfo();
    }
    log.showInfo(`queryItemByInfoId infoId:${infoId}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, infoId);
    const result = await rdbTaskPool.queryGridLayoutInfo(this.getLayoutInfoTableName(), conditions);
    log.showInfo(`queryItemByInfoId result ${JSON.stringify(result)}`);
    return result.length > 0 ? result[0] : new GridLayoutItemInfo();
  }

  /**
   * 根据InfoId查询表中记录，仅包含记录本身，不包含内部layoutInfo
   *
   * @param infoId 文件夹folderId
   * @returns 查询结果
   */
  public async queryRecordByInfoId(infoId: string): Promise<GridLayoutItemInfo | undefined> {
    if (CheckEmptyUtils.isEmpty(infoId)) {
      log.showWarn('queryRecordByInfoId: infoId is empty');
      return undefined;
    }
    log.showInfo(`queryRecordByInfoId infoId: ${infoId}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, infoId);
    const result = await rdbTaskPool.queryItemRecords(this.getLayoutInfoTableName(), conditions);
    log.showInfo(`queryRecordByInfoId result: ${result.length}`);
    return result.length > 0 ? result[0] : new GridLayoutItemInfo();
  }

  /**
   * 添加应用到dock区的文件夹
   * @param infoId 文件夹folderId
   * @param itemInfo 待添加应用信息
   */
  public async addInfoToDockFolder(infoId: string, itemInfo: GridLayoutItemInfo[]): Promise<void> {
    if (CheckEmptyUtils.isEmpty(infoId) || CheckEmptyUtils.isEmptyArr(itemInfo)) {
      log.showWarn('addInfoToDockFolder folder or itemInfo empty');
      return;
    }
    itemInfo = itemInfo.filter(info => {
      return info.typeId === CommonConstants.TYPE_APP || info.typeId === CommonConstants.TYPE_SHORTCUT_ICON;
    });
    log.showDebug(`addInfoToDockFolder itemInfo: ${JSON.stringify(itemInfo)}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, infoId);
    let result = await rdbTaskPool.queryAllGridLayoutInfo(this.getLayoutInfoTableName(), conditions);
    if (!CheckEmptyUtils.isEmpty(result)) {
      log.showInfo(`addInfoToDockFolder item ${result[0].id}`);
      this.updateInfoPosition(itemInfo, 'addInfoToDockFolder', new ExtraInfo(result[0].id));
    } else {
      this.insertFolderLayout(result[0], itemInfo);
    }
  }

  /**
   * 添加卡片到卡片堆叠
   * @param formstack 卡片堆叠信息
   * @param itemInfo 待添加卡片信息
   * @param line 堆叠主键ID
   */
  public async addInfoToFormStack(formStack: GridLayoutItemInfo, itemInfo: GridLayoutItemInfo[],
                                  line: number = CommonConstants.INVALID_VALUE, isOuter?: boolean): Promise<void> {
    if (CheckEmptyUtils.isEmpty(formStack) || CheckEmptyUtils.isEmptyArr(itemInfo)) {
      log.showWarn('addInfoToFormStack formStack or itemInfo empty');
      return;
    }
    log.showWarn(`addInfoToFormStack ${formStack.infoId}, container: ${line}`);
    if (line === CommonConstants.INVALID_VALUE) {
      // 堆叠ID无效，主动从db查询一次
      let gridLayoutDB: GridLayoutItemInfoDB = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(formStack);
      let conditions: Map<string, rdb.ValueType> = new Map();
      conditions.set(GridLayoutInfoColumns.INFO_ID, gridLayoutDB.infoId);
      const result: GridLayoutItemInfo[] =
        await rdbTaskPool.queryGridLayoutInfo(this.getLayoutInfoTableName(isOuter), conditions);
      log.showWarn(`addInfoToFormStack, result: ${result?.[0]?.id}`);
      line = result?.[0]?.id ?? CommonConstants.INVALID_VALUE;
    }

    // 更新堆叠关联的卡片container
    if (line > 0) {
      this.updateInfoPosition(itemInfo, 'addInfoToFormStack', new ExtraInfo(line, undefined, isOuter));
    }
  }

  /**
   * 删除应用中心元素信息
   *
   * @param deleteItem 被删除的Icon信息
   * @param containId containId
   */
  public async deleteAppCenterItem(deleteItem: AppItemInfo): Promise<void> {
    if (CheckEmptyUtils.isEmpty(deleteItem)) {
      log.showWarn('deleteAppCenterItem: item empty');
      return;
    }
    log.showWarn(`deleteAppCenterItem bundleName: ${deleteItem.bundleName}, abilityName ${deleteItem.abilityName}, moduleName ${deleteItem.moduleName}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, deleteItem.bundleName);
    if (deleteItem.abilityName) {
      conditions.set(GridLayoutInfoColumns.ABILITY_NAME, deleteItem.abilityName);
    }
    if (deleteItem.moduleName) {
      conditions.set(GridLayoutInfoColumns.MODULE_NAME, deleteItem.moduleName);
    }
    conditions.set(GridLayoutInfoColumns.APP_INDEX, deleteItem.appIndex ?? 0);
    await rdbTaskPool.delete(RdbStoreConfig.appCenterLayoutInfo.tableName, conditions).then((rows: Number) => {
      log.showWarn(`deleteAppCenterItem: ${rows}`);
    }).catch((err: Error) => {
      log.showError(`deleteAppCenterItem failed, message is ${err?.message}`);
    });
  }

  /**
   * 删除布局信息
   *
   * @param deleteItem 被删除的Icon信息
   * @param containId containId
   */
  public async deleteGridLayoutByCondition(deleteItem: BaseIconInfo | GridLayoutItemInfo, containId?: number,
    isOuter?: boolean, sceneMsg: string = SceneMsgEnum.RDB_DELETE_GRID_LAYOUT_BY_CONDITION): Promise<void> {
    log.showWarn(`deleteGridLayoutByCondition bundleName:${deleteItem.bundleName}, ` +
      `abilityName:${deleteItem.abilityName}, moduleName ${deleteItem.moduleName}, appIndex ${deleteItem.appIndex}, ` +
      `shortcutId ${deleteItem.shortcutId}, containId ${containId}, isOuter ${isOuter}`);
    if (CheckEmptyUtils.isEmpty(deleteItem) || CheckEmptyUtils.isEmpty(deleteItem.bundleName)) {
      return;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    const container: number = containId ? containId : CommonConstants.CONTAINER_DESKTOP;
    conditions.set(GridLayoutInfoColumns.CONTAINER, container);
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, deleteItem.bundleName);
    if (deleteItem.abilityName) {
      conditions.set(GridLayoutInfoColumns.ABILITY_NAME, deleteItem.abilityName);
    }
    if (deleteItem.moduleName) {
      conditions.set(GridLayoutInfoColumns.MODULE_NAME, deleteItem.moduleName);
    }
    if (!CheckEmptyUtils.isEmpty(deleteItem.appIndex)) {
      conditions.set(GridLayoutInfoColumns.APP_INDEX, deleteItem.appIndex);
    }
    if (deleteItem.shortcutId) {
      conditions.set(GridLayoutInfoColumns.SHORTCUT_ID, deleteItem.shortcutId);
    }
    if (deleteItem.typeId !== undefined) {
      conditions.set(GridLayoutInfoColumns.TYPE_ID, deleteItem.typeId);
    }
    await rdbTaskPool.delete(this.getLayoutInfoTableName(isOuter), conditions, sceneMsg).then((rows: Number) => {
      log.showInfo(`deleteGridLayoutByCondition: ${rows}`);
    }).catch((err: Error) => {
      log.showError(`deleteGridLayoutByCondition: ${err}`);
    });
  }

  /**
   * 删除快捷菜单元素
   *
   * @param bundleName 包名
   * @param shortcutId 快捷方式Id
   * @param appIndex 应用索引
   * @param isOuter 是否外屏
   */
  public deleteShortcutItem(bundleName: string, shortcutId: string, appIndex: number, isOuter?: boolean): void {
    log.showWarn(`deleteShortcutItem bundleName:${bundleName}, shortcutId:${shortcutId}, appIndex:${appIndex}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, bundleName);
    conditions.set(GridLayoutInfoColumns.SHORTCUT_ID, shortcutId);
    conditions.set(GridLayoutInfoColumns.APP_INDEX, appIndex);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_SHORTCUT_ICON);
    rdbTaskPool.delete(this.getLayoutInfoTableName(isOuter), conditions).then((rows: number) => {
      log.showWarn(`deleteShortcutItem: ${rows}`);
    }).catch((err: Error) => {
      log.showError(`deleteShortcutItem: ${err}`);
    });
  }

  /**
   * 删除PC文件夹元素
   *
   * @param ino unique identifier
   * @returns true:删除成功;false:删除失败
   */
  public deleteFileFolderItem(ino: string): void {
    log.showWarn(`deleteFileFolderItem uri:${ino}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.FILE_INO, ino);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_FILE_FOLDER);
    rdbTaskPool.delete(this.getLayoutInfoTableName(), conditions).then((rows: number) => {
      log.showDebug(`deleteFileFolderItem: ${rows}`);
    }).catch((err: Error) => {
      log.showError(`deleteFileFolderItem: ${err}`);
    });
  }

  /**
   * 删除布局元素
   *
   * @param infoId infoId
   * @returns true:删除成功;false:删除失败
   */
  public async deleteItemByInfoId(infoId: string, isOuter?: boolean): Promise<void> {
    log.showWarn(`deleteItemByInfoId ${infoId}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, infoId);
    await rdbTaskPool.delete(this.getLayoutInfoTableName(isOuter), conditions).then((rows: number) => {
      log.showDebug(`deleteItemByInfoId: ${rows}`);
    }).catch((err: Error) => {
      log.showError(`deleteItemByInfoId: ${err}`);
    });
  }

  /**
   * 更新桌面元素位置信息
   *
   * @param itemInfo 目标元素
   * @param container 目标位置
   * @param isConvertToSmall 是否转变为小文件夹
   * @param isOuter 是否是外屏
   * @returns true 更新成功  false 更新失败
   */
  public async updateInfoPosition(itemInfo: GridLayoutItemInfo[], reason: string,
    extraInfo: ExtraInfo = new ExtraInfo()): Promise<boolean> {
    log.showWarn(`updateInfoPosition to ${extraInfo.container}`);
    if (itemInfo === null || itemInfo === undefined || itemInfo.length < 1) {
      log.showError('updateInfoPosition itemInfoArray null');
      return false;
    }
    for (let i = 0; i < itemInfo.length; i++) {
      if (!GridLayoutUtil.isValidLayoutItem(itemInfo[i])) {
        log.showError('updateInfoPosition itemInfo error! bundle=%{public}s, ability=%{public}s, typeId=%{public}d,' +
          'page=%{public}d, col=%{public}d, row=%{public}d', itemInfo[i]?.bundleName, itemInfo[i]?.abilityName,
          itemInfo[i]?.typeId, itemInfo[i]?.page, itemInfo[i]?.column, itemInfo[i]?.row);
        return false;
      }
    }
    let itemInfoList = this.mapProxyTypeGridLayout(itemInfo);
    return await rdbTaskPool.updateInfoPosition(this.getLayoutInfoTableName(extraInfo.isOuter), itemInfoList
      , extraInfo.container ? extraInfo.container : CommonConstants.CONTAINER_DESKTOP, undefined, reason,
      extraInfo.ctx);
  }

  /**
   * 更新元素信息到数据库,不区分桌面或者dock
   *
   * @param itemInfo 需要更新的元素信息
   * @returns true 更新成功  false 更新失败
   */
  public async updateAllInfoPosition(itemInfo: GridLayoutItemInfo[], ctx?: SingleContext): Promise<boolean> {
    if (itemInfo === null || itemInfo === undefined || itemInfo.length < 1) {
      log.showError('updateInfoPosition itemInfoArray null');
      return false;
    }
    log.showWarn('updateAllInfoPosition update info size: %{public}d', itemInfo.length);
    for (let i = 0; i < itemInfo.length; i++) {
      if (!GridLayoutUtil.isValidLayoutItem(itemInfo[i])) {
        log.showError('updateInfoPosition itemInfo error! bundle=%{public}s, ability=%{public}s, typeId=%{public}d,' +
          'page=%{public}d, col=%{public}d, row=%{public}d', itemInfo[i]?.bundleName, itemInfo[i]?.abilityName,
          itemInfo[i]?.typeId, itemInfo[i]?.page, itemInfo[i]?.column, itemInfo[i]?.row);
        return false;
      }
    }
    let itemInfoList = this.mapProxyTypeGridLayout(itemInfo);
    return await rdbTaskPool.updateInfoPosition(this.getLayoutInfoTableName(), itemInfoList, undefined,
      undefined,'updateAllInfoPosition', ctx);
  }

  private mapProxyTypeGridLayout(itemInfo: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let itemInfoList = itemInfo.map((item: GridLayoutItemInfo) => GridLayoutUtil.mapProxyTypeGridLayout(item));
    for (let index = 0; index < itemInfoList?.length; index++) {
      let gridItemInfo = itemInfoList[index] ?? new GridLayoutItemInfo();
      if (!gridItemInfo.layoutInfo){
        continue;
      }
      if (gridItemInfo.typeId !== CommonConstants.TYPE_FOLDER &&
        gridItemInfo.typeId !== CommonConstants.TYPE_FORM_STACK) {
        continue;
      }
      for (let i = 0; i < gridItemInfo.layoutInfo.length; i++) {
        for (let j = 0; j < gridItemInfo.layoutInfo[i].length; j++) {
          gridItemInfo.layoutInfo[i][j] = GridLayoutUtil.mapProxyTypeGridLayout(gridItemInfo.layoutInfo[i][j] ?? new GridLayoutItemInfo());
        }
      }
    }

    return itemInfoList;
  }

  /**
   * 批量更新卡片信息
   *
   * @param relationCards 卡片信息
   * @returns 是否成功
   */
  public async updateRelationFormInfoOfDb(relationCards: CardItemInfo[], isOuter?: boolean): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(relationCards)) {
      log.showWarn('updateRelationFormInfoOfDb relationCards is empty');
      return false;
    }
    let updateResult: boolean =
      await rdbTaskPool.updateRelationFormInfoOfDb(this.getLayoutInfoTableName(isOuter), relationCards);
    return updateResult;
  }

  /**
   * 批量删除卡片信息
   *
   * @param deleteIds 删除卡片id
   * @returns 是否成功
   */
  public async deleteRelationFormInfoOfDb(deleteIds: string[]): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(deleteIds)) {
      log.showWarn('deleteRelationFormInfoOfDb deleteIds is empty');
      return false;
    }
    let updateResult: boolean = await rdbTaskPool.deleteRelationFormInfoOfDb(this.getLayoutInfoTableName(), deleteIds);
    return updateResult;
  }

  /**
   * 批量更新布局元素位置
   *
   * @param gridItemList: 布局列表
   * @returns 是否成功
   */
  public async updateAppCenterItemPositions(gridItemList: AppGridItemInfo[]): Promise<boolean> {
    log.showWarn(`updateAppCenterItemPositions: ${gridItemList?.length}`);
    if (CheckEmptyUtils.isEmpty(gridItemList)) {
      log.showWarn('updateAppCenterItemPositions gridItemList is empty');
      return false;
    }
    for (let i = 0; i < gridItemList.length; i++) {
      if (!gridItemList[i] || CheckEmptyUtils.isEmpty(gridItemList[i].bundleName)) {
        log.showError('updateAppCenterItemPositions itemInfo error! bundle=%{public}s, ability=%{public}s, ' +
          'page=%{public}d, col=%{public}d, row=%{public}d', gridItemList[i]?.bundleName, gridItemList[i]?.abilityName,
          gridItemList[i]?.page, gridItemList[i]?.column, gridItemList[i]?.row);
        return false;
      }
    }
    return await rdbTaskPool.updateAppCenterItemPositions(RdbStoreConfig.appCenterLayoutInfo.tableName, gridItemList);
  }

  /**
   * 批量更新布局元素位置
   *
   * @param gridItemList: 布局列表
   * @returns 是否成功
   */
  public async updateAppCenterSys(gridItemList: AppGridItemInfo[]): Promise<boolean> {
    log.showWarn(`updateAppCenterItemPositions: ${gridItemList?.length}`);
    if (CheckEmptyUtils.isEmpty(gridItemList)) {
      log.showWarn('updateAppCenterItemPositions gridItemList is empty');
      return false;
    }
    for (let i = 0; i < gridItemList.length; i++) {
      if (!gridItemList[i] || CheckEmptyUtils.isEmpty(gridItemList[i].bundleName)) {
        log.showError('updateAppCenterItemPositions itemInfo error! bundle=%{public}s, ability=%{public}s, ' +
          'page=%{public}d, col=%{public}d, row=%{public}d', gridItemList[i]?.bundleName, gridItemList[i]?.abilityName,
          gridItemList[i]?.page, gridItemList[i]?.column, gridItemList[i]?.row);
        return false;
      }
    }
    return await rdbTaskPool.updateAppCenterItemSys(RdbStoreConfig.appCenterLayoutInfo.tableName, gridItemList);
  }

  /**
   * 批量更新布局元素位置
   *
   * @param gridItemList: 布局列表
   * @returns 是否成功
   */
  public async updateGridLayoutPositionBatch(gridItemList: GridLayoutItemInfo[], isOuter?: boolean): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(gridItemList)) {
      log.showWarn('updateGridLayoutBatch gridItemList is empty');
      return false;
    }
    for (let i = 0; i < gridItemList.length; i++) {
      if (!GridLayoutUtil.isValidLayoutItem(gridItemList[i])) {
        log.showError('updateGridLayoutPositionBatch itemInfo error! bundle=%{public}s, ability=%{public}s, typeId=%{public}d,' +
          'page=%{public}d, col=%{public}d, row=%{public}d', gridItemList[i]?.bundleName, gridItemList[i]?.abilityName,
          gridItemList[i]?.typeId, gridItemList[i]?.page, gridItemList[i]?.column, gridItemList[i]?.row);
        return false;
      }
    }
    let itemInfoList = this.mapProxyTypeGridLayout(gridItemList);
    return await rdbTaskPool.updateGridLayoutPositionBatch(this.getLayoutInfoTableName(isOuter), itemInfoList);
  }

  /**
   * 批量更新元素位置
   *
   * @param startPage 开始更新页数
   * @param endPage 结束更新页数
   * @param changeStep 更新步长
   * @returns true 更新成功
   */
  public async updateGridLayoutInfoPositionByPage(pageUpdateItems: PageUpdateItem[]): Promise<void> {
    let tableName: string = this.getLayoutInfoTableName();
    for (const pageUpdateItem of pageUpdateItems) {
      await rdbTaskPool.updateGridLayoutInfoPositionByPage(tableName, pageUpdateItem.startPage, pageUpdateItem.endPage,
        pageUpdateItem.step);
    }
  }

  /**
   * 批量更新布局元素位置
   *
   * @param updateReqGroup: 布局列表
   * @returns 是否成功
   */
  public async updateBatchGridLayoutWithMapReplaceGroup(updateReqGroup: UpdateGirdLayoutReq[][]): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(updateReqGroup)) {
      log.showWarn('updateBatchGridLayoutWithMapReplaceGroup updateReqGroup is empty');
      return;
    }
    await rdbTaskPool.updateBatchGridLayoutWithMapReplaceGroup(updateReqGroup);
  }

  /**
   * 根据infoid更新布局
   *
   * @param infoId 元素id
   * @param key 需要更新数据库的列名
   * @param value 需要更新的值
   * @returns 数据库操作码。-1为失败
   */
  public async updateGridInfoById(infoId: string, key: string, value: number | string | boolean): Promise<number> {
    if (CheckEmptyUtils.isEmpty(infoId) || CheckEmptyUtils.isEmpty(key)) {
      log.showWarn('updateGridLayoutBatch gridItemList is empty');
      return -1;
    }
    log.showWarn('updateGridInfoById start with:' + infoId);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, infoId);
    let valueBucket: rdb.ValuesBucket = { [key]: value };
    return await rdbTaskPool.update(this.getLayoutInfoTableName(), conditions, valueBucket);
  }

  /**
   * 更新布局
   *
   * @param item 更新布局信息
   * @returns 数据库操作码。-1为失败
   */
  public async updateGridInfo(item: GridLayoutItemInfo, isOuter?: boolean): Promise<number> {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showWarn('updateGridInfo gridItemList is empty');
      return -1;
    }
    log.showInfo('updateGridInfo bundleName: %{public}s, appIndex: : %{public}d, shortcutId: %{public}s',
      item.bundleName, item.appIndex, item.shortcutId);
    if (item.appIconId) {
      let image: string = await ShortcutViewModel.getInstance().getShortcutOriginImage(item as AppItemInfo);
      item.iconResource = image ?? item.iconResource;
    }
    if (item.appLabelId) {
      item.appName = await this.getAppNameFromResource(item);
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, item.bundleName);
    conditions.set(GridLayoutInfoColumns.APP_INDEX, item.appIndex);
    conditions.set(GridLayoutInfoColumns.SHORTCUT_ID, item.shortcutId);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, item.typeId);
    let valuesBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.APP_ICON_ID]: item.appIconId,
      [GridLayoutInfoEnums.APP_LABEL_ID]: item.appLabelId,
      [GridLayoutInfoEnums.APP_STATUS]: item.appStatus,
      [GridLayoutInfoEnums.ICON_RESOURCE]: item.iconResource,
      [GridLayoutInfoEnums.INFO_NAME]: item.appName
    };
    return await rdbTaskPool.update(this.getLayoutInfoTableName(isOuter), conditions, valuesBucket);
  }

  /**
   * 应用安装更新布局信息
   *
   * @param GridLayoutItemInfo 数据信息
   * @param tableName 传入的表名
   * @returns 数据库操作码。-1为失败
   */
  public async updateNewInstalledGridInfo(item: GridLayoutItemInfo, isOuter?: boolean, tableName?: string): Promise<number> {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showWarn('updateNewInstalledGridInfo item is empty');
      return -1;
    }
    if (this.debugStatus > 0 && item.appStatus === 0) {
      log.showError('updateNewInstalledGridInfo item is empty');
      return -1;
    }
    let tName = this.getTableName(isOuter, tableName);
    log.showWarn('appInstall updateNewInstalledApp bundleName: %{public}s, tName: %{public}s', item.bundleName, tName);
    return await rdbTaskPool.updateNewInstalledApp(tName, item);
  }

  private getTableName(isOuter?: boolean, tableName?: string): string {
    if (tableName) {
      return tableName;
    }
    return this.getLayoutInfoTableName(isOuter);
  }

  /**
   * 根据类型获取布局元素
   *
   * @param typeId: 布局列表
   * @returns 桌面元素列表
   */
  public async queryGridLayoutByType(typeId: number, isOuter?: boolean): Promise<GridLayoutItemInfo[]> {
    return await rdbTaskPool.queryGridLayoutByType(this.getLayoutInfoTableName(isOuter), typeId);
  }

  /**
   * 根据位置获取布局元素
   *
   * @param typeId: 布局列表
   * @returns 桌面元素列表
   */
  public async queryGridLayoutByContainer(container: number): Promise<GridLayoutItemInfo[]> {
    return await rdbTaskPool.queryGridLayoutByContainer(this.getLayoutInfoTableName(), container);
  }

  /**
   * 更新下载信息
   *
   * @param appInfo：应用信息
   * @returns 数据库操作码。CommonConstants.INVALID_VALUE为失败
   */
  public async updateDownloadInfo(appInfo: DownloadInfoItem): Promise<number> {
    if (!appInfo) {
      log.showError('updateDownloadInfo gridInfo is undefined');
      return CommonConstants.INVALID_VALUE;
    }
    return await rdbTaskPool.updateDownload(DeviceHelper.is2In1DevicePcType() ?
    this.getLayoutInfoTableName() : RdbStoreConfig.gridLayoutInfo.tableName, appInfo);
  }

  /**
   * 批量插入角标
   *
   * @param badgeItemInfoList
   * @returns insert badge result
   */
  public async batchInsertBadge(badgeItemInfoList: Array<BadgeItemInfo>): Promise<boolean> {
    log.showWarn('batchInsertBadge start');
    let result = false;
    try {
      await rdbStoreHelper.executeSql(RdbStoreConfig.badge.dropTable);
      await rdbStoreHelper.executeSql(RdbStoreConfig.badge.createTable);
      const buckets: rdb.ValuesBucket[] = [];
      for (const badgeItemInfo of badgeItemInfoList) {
        if (badgeItemInfo.userId === undefined || badgeItemInfo.isShow === undefined) {
          continue;
        }
        const bucket: rdb.ValuesBucket = {
          [BadgeEnums.BUNDLE_NAME]: badgeItemInfo.bundleName,
          [BadgeEnums.BADGE_NUMBER]: badgeItemInfo.badgeNumber,
          [BadgeEnums.IS_SHOW]: badgeItemInfo.isShow,
          [BadgeEnums.USER_ID]: badgeItemInfo.userId,
          [BadgeEnums.APP_INDEX]: badgeItemInfo.appIndex ?? 0
        };
        buckets.push(bucket);
      }
      let changeRows = await rdbTaskPool.batchInsert(RdbStoreConfig.badge.tableName, buckets);
      log.showInfo(`batchInsertBadge insert:${changeRows}`);
      result = (changeRows !== CommonConstants.INVALID_VALUE);
    } catch (e) {
      log.showError(`batchInsertBadge error: ${e?.message}`);
    }
    return result;
  }

  public isDisableInsert(): boolean {
    if (!globalThis) {
      log.showError('isDisableInsert globalThis invalid');
      return false;
    }
    let backupStatus: boolean = GlobalContext.getInstance().getObject('backupStatus') as boolean;
    let isBackupService: boolean = GlobalContext.getInstance().getObject('isBackupService') as boolean;
    log.showDebug(`isDisableInsert, isBackupService: ${isBackupService}, backupStatus:${backupStatus}`);
    if (isBackupService || !backupStatus) {
      return false;
    }
    return true;
  }

  async deleteIntelligentDiscoveryInfo(): Promise<void> {
    log.showInfo('deleteIntelligentDiscoveryInfo start');
    try {
      await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentDiscoveryInfo.dropTable);
    } catch (e) {
      log.showError(`deleteIntelligentDiscoveryInfo code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
  }

  async deleteIntelligentAllTables():Promise<void> {
    log.showInfo('deleteIntelligentAllTable start');
    try {
      await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentDiscoveryInfo.dropTable);
      await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentImage.dropTable);
      await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentCard.dropTable);
      await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentCommonData.dropTable);
    } catch (e) {
      log.showError(`deleteIntelligentAllTable code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
  }

  async insertIntelligentDiscoveryInfo(discoveryInfo: Array<rdb.ValuesBucket>): Promise<boolean> {
    log.showInfo('insertIntelligentDiscoveryInfo start');
    if (CheckEmptyUtils.isEmpty(discoveryInfo)) {
      log.showError('insertIntelligentDiscoveryInfo discoveryInfo is empty');
      return false;
    }
    let result: boolean = true;

    try {
      await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentDiscoveryInfo.dropTable);
      await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentDiscoveryInfo.createTable);
      log.showInfo('insertIntelligentDiscoveryInfo buckets ' + discoveryInfo.length);
      let changeRows = await rdbTaskPool.batchInsert(RdbStoreConfig.intelligentDiscoveryInfo.tableName, discoveryInfo);
      result = (changeRows !== CommonConstants.INVALID_VALUE);
    } catch (e) {
      log.showError(`insertIntelligentDiscoveryInfo code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
    return result;
  }

  async queryIntelligentDiscoveryInfo(): Promise<Array<rdb.ValuesBucket>> {
    log.showInfo('queryIntelligentDiscoveryInfo start');
    let buckets: Array<rdb.ValuesBucket> = [];
    try {
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.intelligentDiscoveryInfo.tableName);
      let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, []);
      if (!resultSet) {
        return buckets;
      }
      let isLast = resultSet.goToFirstRow();
      while (isLast) {
        let bucket: rdb.ValuesBucket = {
          [IntelligentDiscoveryInfoEnums.PARENT_ID]: resultSet.getString(resultSet.getColumnIndex(IntelligentDiscoveryInfoColumns.PARENT_ID)),
          [IntelligentDiscoveryInfoEnums.SERVICE_ID]: resultSet.getString(resultSet.getColumnIndex(IntelligentDiscoveryInfoColumns.SERVICE_ID)),
          [IntelligentDiscoveryInfoEnums.SERVICE_NAME]: resultSet.getString(resultSet.getColumnIndex(IntelligentDiscoveryInfoColumns.SERVICE_NAME)),
          [IntelligentDiscoveryInfoEnums.ICON_URL]: resultSet.getString(resultSet.getColumnIndex(IntelligentDiscoveryInfoColumns.ICON_URL)),
          [IntelligentDiscoveryInfoEnums.ABILITY_JUMP_URL]: resultSet.getString(resultSet.getColumnIndex(IntelligentDiscoveryInfoColumns.ABILITY_JUMP_URL)),
          [IntelligentDiscoveryInfoEnums.CANDIDATE_JUMP_URL]: resultSet.getString(resultSet
            .getColumnIndex(IntelligentDiscoveryInfoColumns.CANDIDATE_JUMP_URL)),
          [IntelligentDiscoveryInfoEnums.PRIORITY]: resultSet.getString(resultSet.getColumnIndex(IntelligentDiscoveryInfoColumns.PRIORITY)),
          [IntelligentDiscoveryInfoEnums.SUBTITLE_NAME]: resultSet.getString(resultSet.getColumnIndex(IntelligentDiscoveryInfoColumns.SUBTITLE_NAME)),
          [IntelligentDiscoveryInfoEnums.SUBTITLE_START_TIME]: resultSet.getString(resultSet
            .getColumnIndex(IntelligentDiscoveryInfoColumns.SUBTITLE_START_TIME)),
          [IntelligentDiscoveryInfoEnums.SUBTITLE_END_TIME]: resultSet.getString(resultSet.getColumnIndex(IntelligentDiscoveryInfoColumns.SUBTITLE_END_TIME)),
          [IntelligentDiscoveryInfoEnums.SHOW_TOAST]: resultSet.getString(resultSet.getColumnIndex(IntelligentDiscoveryInfoColumns.SHOW_TOAST)),
          [IntelligentDiscoveryInfoEnums.TOAST_INFO]: resultSet.getString(resultSet.getColumnIndex(IntelligentDiscoveryInfoColumns.TOAST_INFO)),
        };
        buckets.push(bucket);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
      resultSet = undefined;
    } catch (e) {
      log.showError(`queryIntelligentDiscoveryInfo code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
    return buckets;
  }

  /**
   * 删除资讯头图数据
   *
   * @param moduleName moduleName
   * @returns 是否成功
   */
  public async deleteFeedHeadPicByModuleName(moduleName: string): Promise<boolean> {
    log.showInfo('deleteFeedHeadPicByModuleName...');
    if (this.ifStringIsNull(moduleName)) {
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(IntelligentImageColumns.MODULE_NAME, moduleName);
    const changeRows = await rdbTaskPool.delete(RdbStoreConfig.intelligentImage.tableName, conditions);
    if (changeRows >= 1) {
      log.showInfo(`deleteFeedHeadPicByModuleName delete ok:${changeRows}`);
      return true;
    }
    return false;
  }

  async insertIntelligentImage(imageInfo: rdb.ValuesBucket): Promise<boolean> {
    log.showInfo('insertIntelligentImage start');
    if (CheckEmptyUtils.isEmpty(imageInfo) || CheckEmptyUtils.isEmpty(imageInfo.imageBase64)) {
      log.showError('insertIntelligentImage discoveryInfo is empty');
      return false;
    }
    let result: boolean = true;
    try {
      await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentImage.createTable);
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.intelligentImage.tableName);
      let changeRows: number = CommonConstants.INVALID_VALUE;
      if (imageInfo.moduleName === 'feedHeadPic') {
        // 资讯大图桌面数据库无需保存老数据, 只保存最近一次刷新的数据
        await this.deleteFeedHeadPicByModuleName(imageInfo.moduleName);
        let insertBucket: rdb.ValuesBucket = {
          [IntelligentImageEnums.MODULE_NAME]: imageInfo.moduleName,
          [IntelligentImageEnums.IMAGE_URL]: imageInfo.imageUrl,
          [IntelligentImageEnums.IMAGE_BASE64]: imageInfo.imageBase64,
          [IntelligentImageEnums.EXTRA_DATA]: imageInfo.extraData
        };
        changeRows = await rdbStoreHelper.insert(RdbStoreConfig.intelligentImage.tableName, insertBucket);
      } else {
        predicates.equalTo(IntelligentImageColumns.MODULE_NAME, imageInfo.moduleName as string)
          .and()
          .equalTo(IntelligentImageColumns.IMAGE_URL, imageInfo.imageUrl as string);
        let updateBucket: rdb.ValuesBucket = {
          [IntelligentImageEnums.IMAGE_BASE64]: imageInfo.imageBase64,
          [IntelligentImageEnums.EXTRA_DATA]: imageInfo.extraData
        };
        changeRows = await rdbStoreHelper.update(predicates, updateBucket);
        log.showInfo(`insertIntelligentImage updated changeRows: ${changeRows}`);
        if (changeRows !== 1) {
          let insertBucket: rdb.ValuesBucket = {
            [IntelligentImageEnums.MODULE_NAME]: imageInfo.moduleName,
            [IntelligentImageEnums.IMAGE_URL]: imageInfo.imageUrl,
            [IntelligentImageEnums.IMAGE_BASE64]: imageInfo.imageBase64,
            [IntelligentImageEnums.EXTRA_DATA]: imageInfo.extraData
          };
          changeRows = await rdbStoreHelper.insert(RdbStoreConfig.intelligentImage.tableName, insertBucket);
        }
      }
      log.showInfo(`insertIntelligentImage, moduleName: ${imageInfo.moduleName}, insert changeRows: ${changeRows}`);
      result = (changeRows !== CommonConstants.INVALID_VALUE);
    } catch (e) {
      log.showError(`insertIntelligentImage code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
    return result;
  }

  async queryIntelligentImageByUrl(url: string): Promise<rdb.ValuesBucket | undefined> {
    log.showInfo(`queryIntelligentImageByUrl start  ${url}`);
    let buckets: rdb.ValuesBucket | undefined;
    try {
      // 该表在插数据时建表, 有个逻辑在建表前有查询, 此时没表sql有个抛错, 为解决此错查之前先建表(建表语句有IF NOT EXISTS, 只有刷机滑入负一屏执行一次后就不会再执行)
      await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentImage.createTable);
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.intelligentImage.tableName);
      predicates.equalTo('image_url', url);
      let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, []);
      if (!resultSet) {
        return buckets;
      }
      let isLast = resultSet.goToFirstRow();
      while (isLast) {
        buckets = {
          [IntelligentImageEnums.MODULE_NAME]: resultSet.getString(resultSet.getColumnIndex(IntelligentImageColumns.MODULE_NAME)),
          [IntelligentImageEnums.IMAGE_URL]: resultSet.getString(resultSet.getColumnIndex(IntelligentImageColumns.IMAGE_URL)),
          [IntelligentImageEnums.IMAGE_BASE64]: resultSet.getString(resultSet.getColumnIndex(IntelligentImageColumns.IMAGE_BASE64)),
          [IntelligentImageEnums.EXTRA_DATA]: resultSet.getString(resultSet.getColumnIndex(IntelligentImageColumns.EXTRA_DATA))
        };
        if (!buckets) {
          break;
        }
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
      resultSet = undefined;
    } catch (e) {
      log.showError(`queryIntelligentImageByUrl code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
    return buckets;
  }

  async queryIntelligentImageByModule(moduleName: string): Promise<Array<rdb.ValuesBucket>> {
    log.showInfo(`queryIntelligentImageByModule, moduleName:${moduleName}`);
    let buckets: Array<rdb.ValuesBucket> = [];
    try {
      // 该表在插数据时建表, 有个逻辑在建表前有查询, 此时没表sql有个抛错, 为解决此错查之前先建表(建表语句有IF NOT EXISTS, 只有刷机滑入负一屏执行一次后就不会再执行)
      await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentImage.createTable);
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.intelligentImage.tableName);
      predicates.equalTo(IntelligentImageColumns.MODULE_NAME, moduleName);
      let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, []);
      if (!resultSet) {
        return buckets;
      }
      let isLast = resultSet.goToFirstRow();
      while (isLast) {
        let bucket: rdb.ValuesBucket = {
          [IntelligentImageEnums.MODULE_NAME]: moduleName,
          [IntelligentImageEnums.IMAGE_URL]: resultSet.getString(resultSet.getColumnIndex(IntelligentImageColumns.IMAGE_URL)),
          [IntelligentImageEnums.IMAGE_BASE64]: resultSet.getString(resultSet.getColumnIndex(IntelligentImageColumns.IMAGE_BASE64)),
          [IntelligentImageEnums.EXTRA_DATA]: resultSet.getString(resultSet.getColumnIndex(IntelligentImageColumns.EXTRA_DATA))
        };
        buckets.push(bucket);
        isLast = resultSet.goToNextRow();
      }
      log.showInfo(`queryIntelligentImageByModule, buckets length:${buckets?.length}`);
      resultSet.close();
      resultSet = undefined;
    } catch (e) {
      log.showError(`queryIntelligentImageByModule code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
    return buckets;
  }

  async queryIntelligentImageByModuleAndUrl(moduleName: string, imageUrl: string): Promise<Array<rdb.ValuesBucket>> {
    log.showInfo(`queryIntelligentImageByModuleAndUrl start ${moduleName}, imageUrl${imageUrl}}`);
    let buckets: Array<rdb.ValuesBucket> = [];
    try {
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.intelligentImage.tableName);
      predicates.equalTo(IntelligentImageColumns.MODULE_NAME, moduleName)
        .and()
        .equalTo(IntelligentImageColumns.IMAGE_URL, imageUrl);
      let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, []);
      if (!resultSet) {
        return buckets;
      }
      let isLast = resultSet.goToFirstRow();
      while (isLast) {
        let bucket: rdb.ValuesBucket = {
          [IntelligentImageEnums.MODULE_NAME]: moduleName,
          [IntelligentImageEnums.IMAGE_URL]: resultSet.getString(resultSet.getColumnIndex(IntelligentImageColumns.IMAGE_URL)),
          [IntelligentImageEnums.IMAGE_BASE64]: resultSet.getString(resultSet.getColumnIndex(IntelligentImageColumns.IMAGE_BASE64)),
          [IntelligentImageEnums.EXTRA_DATA]: resultSet.getString(resultSet.getColumnIndex(IntelligentImageColumns.EXTRA_DATA))
        };
        buckets.push(bucket);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
      resultSet = undefined;
    } catch (e) {
      log.showError(`queryIntelligentImageByModuleAndUrl code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
    return buckets;
  }

  /**
   * 向 IntelligentCommonData 表 插入/更新 数据
   * @param commonData 数据
   * @returns true - 成功, false - 失败
   */
  async insertIntelligentCommonData(commonData: rdb.ValuesBucket): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(commonData) || CheckEmptyUtils.isEmpty(commonData.value)) {
      log.showError('insertIntelligentCommonData, commonData empty');
      return false;
    }
    log.showInfo(`insertIntelligentCommonData, moduleName: ${commonData.moduleName}, keyName: ${commonData.keyName}, value: ${commonData.value}`);
    let result: boolean = false;
    try {
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.intelligentCommonData.tableName);
      let changeRows: number = CommonConstants.INVALID_VALUE;
      predicates.equalTo(IntelligentCommonDataColumns.MODULE_NAME, commonData.moduleName as string)
        .and()
        .equalTo(IntelligentCommonDataColumns.KEY_NAME, commonData.keyName as string);
      let updateBucket: rdb.ValuesBucket = {
        [IntelligentCommonDataEnums.VALUE]: commonData.value,
        [IntelligentCommonDataEnums.EXTRA_DATA]: commonData.extraData
      };
      // 有就更新
      changeRows = await rdbStoreHelper.update(predicates, updateBucket);
      log.showInfo(`insertIntelligentCommonData, updated changeRows: ${changeRows}`);
      if (changeRows !== 1) {
        // 没有就新加
        let insertBucket: rdb.ValuesBucket = {
          [IntelligentCommonDataEnums.MODULE_NAME]: commonData.moduleName,
          [IntelligentCommonDataEnums.KEY_NAME]: commonData.keyName,
          [IntelligentCommonDataEnums.VALUE]: commonData.value,
          [IntelligentCommonDataEnums.EXTRA_DATA]: commonData.extraData
        };
        changeRows = await rdbStoreHelper.insert(RdbStoreConfig.intelligentCommonData.tableName, insertBucket);
      }
      log.showInfo(`insertIntelligentCommonData, moduleName: ${commonData.moduleName}, insert changeRows: ${changeRows}`);
      result = (changeRows !== CommonConstants.INVALID_VALUE);
    } catch (e) {
      log.showError(`insertIntelligentCommonData code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
    return result;
  }

  /**
   * 依据 模块名、keyName 删除 IntelligentCommonData
   *
   * @param moduleName moduleName
   * @param keyName keyName
   * @returns 是否成功
   */
  public async deleteIntelligentCommonData(moduleName: string, keyName?: string): Promise<boolean> {
    log.showInfo(`deleteIntelligentCommonData, moduleName: ${moduleName}, keyName: ${keyName}`);
    if (this.ifStringIsNull(moduleName)) {
      log.showInfo('deleteIntelligentCommonData, moduleName empty');
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(IntelligentCommonDataColumns.MODULE_NAME, moduleName);
    conditions.set(IntelligentCommonDataColumns.KEY_NAME, keyName);
    const changeRows = await rdbTaskPool.delete(RdbStoreConfig.intelligentCommonData.tableName, conditions);
    if (changeRows >= 1) {
      log.showInfo(`deleteIntelligentCommonData, delete ok: ${changeRows}`);
      return true;
    }
    return false;
  }

  /**
   * 根据 moduleName、keyName 查询 IntelligentCommonData
   * @param moduleName
   * @param keyName
   * @returns 查询到的数据
   */
  async queryIntelligentCommonData(moduleName: string, keyName: string): Promise<rdb.ValuesBucket | undefined> {
    log.showInfo(`queryIntelligentCommonData, moduleName: ${moduleName}, keyName: ${keyName}`);
    let buckets: rdb.ValuesBucket | undefined;
    try {
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.intelligentCommonData.tableName);
      predicates.equalTo(IntelligentCommonDataColumns.MODULE_NAME, moduleName)
        .and()
        .equalTo(IntelligentCommonDataColumns.KEY_NAME, keyName as string);
      let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, []);
      if (!resultSet) {
        return buckets;
      }
      let isLast = resultSet.goToFirstRow();
      while (isLast) {
        buckets = {
          [IntelligentCommonDataEnums.MODULE_NAME]: resultSet.getString(resultSet.getColumnIndex(IntelligentCommonDataColumns.MODULE_NAME)),
          [IntelligentCommonDataEnums.KEY_NAME]: resultSet.getString(resultSet.getColumnIndex(IntelligentCommonDataColumns.KEY_NAME)),
          [IntelligentCommonDataEnums.VALUE]: resultSet.getString(resultSet.getColumnIndex(IntelligentCommonDataColumns.VALUE)),
          [IntelligentCommonDataEnums.EXTRA_DATA]: resultSet.getString(resultSet.getColumnIndex(IntelligentCommonDataColumns.EXTRA_DATA))
        };
        if (!buckets) {
          log.showError('queryIntelligentCommonData, resultSet get error');
          break;
        }
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
      resultSet = undefined;
    } catch (e) {
      log.showError(`queryIntelligentCommonData code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
    return buckets;
  }

  /**
   * 根据 moduleName 查询该模块全量 IntelligentCommonData
   * @param moduleName
   * @returns 查询到的全量数据(数组)
   */
  async queryIntelligentCommonDataByModule(moduleName: string): Promise<Array<rdb.ValuesBucket>> {
    log.showInfo(`queryIntelligentCommonDataByModule, moduleName: ${moduleName}`);
    let buckets: Array<rdb.ValuesBucket> = [];
    try {
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.intelligentCommonData.tableName);
      predicates.equalTo(IntelligentCommonDataColumns.MODULE_NAME, moduleName);
      let resultSet: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, []);
      if (!resultSet) {
        return buckets;
      }
      let isLast = resultSet.goToFirstRow();
      while (isLast) {
        let bucket: rdb.ValuesBucket = {
          [IntelligentCommonDataEnums.MODULE_NAME]: resultSet.getString(resultSet.getColumnIndex(IntelligentCommonDataColumns.MODULE_NAME)),
          [IntelligentCommonDataEnums.KEY_NAME]: resultSet.getString(resultSet.getColumnIndex(IntelligentCommonDataColumns.KEY_NAME)),
          [IntelligentCommonDataEnums.VALUE]: resultSet.getString(resultSet.getColumnIndex(IntelligentCommonDataColumns.VALUE)),
          [IntelligentCommonDataEnums.EXTRA_DATA]: resultSet.getString(resultSet.getColumnIndex(IntelligentCommonDataColumns.EXTRA_DATA))
        };
        buckets.push(bucket);
        isLast = resultSet.goToNextRow();
      }
      log.showInfo(`queryIntelligentCommonDataByModule, buckets length: ${buckets?.length}`);
      resultSet.close();
      resultSet = undefined;
    } catch (e) {
      log.showError(`queryIntelligentCommonDataByModule code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    }
    return buckets;
  }

  async updateIntelligentCardList(idNameInfo: string, cardList: Array<rdb.ValuesBucket>): Promise<void> {
    await rdbStoreHelper.executeSql(RdbStoreConfig.intelligentCard.createTable);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(IntelligentCardListColumns.NAME, idNameInfo);
    let valueBucket: rdb.ValuesBucket = {
      [IntelligentCardListEnums.NAME]: idNameInfo,
      [IntelligentCardListEnums.INTELLIGENT_DATA]: JSON.stringify(cardList)
    };
    let changeRows = await rdbTaskPool.update(RdbStoreConfig.intelligentCard.tableName, conditions, valueBucket);
    if (changeRows >= 1) {
      log.showInfo(`updateIntelligentCardList updated ok: ${changeRows}`);
      return;
    } else {
      changeRows = await rdbTaskPool.insert(RdbStoreConfig.intelligentCard.tableName, valueBucket);
      if (changeRows !== CommonConstants.INVALID_VALUE) {
        log.showError(`updateIntelligentCardList insert fail: ${changeRows}`);
        return;
      }
      log.showInfo(`updateIntelligentCardList insert: ${changeRows}`);
    }
  }

  async getIntelligentCardList(idNameInfo: string): Promise<string> {
    log.showInfo('getIntelligentCardList');
    let result: string = '';
    let res: rdb.ResultSet | undefined = undefined;
    try {
      let predicates = new rdb.RdbPredicates(RdbStoreConfig.intelligentCard.tableName).equalTo(IntelligentCardListColumns.NAME, idNameInfo);
      res = await rdbStoreHelper.query(predicates);
      if (!res) {
        return result;
      }
      let isLast = res.goToFirstRow();
      if (isLast) {
        result = res.getString(res.getColumnIndex(IntelligentCardListColumns.INTELLIGENT_DATA));
      }
    } catch (e) {
      log.showError(`getIntelligentCardList code: ${(e as BusinessError)?.code},
      message: ${(e as BusinessError)?.message}`);
    } finally {
      res?.close();
    }
    return result;
  }

  /**
   * 按卡片Id更新卡片信息
   *
   * @param cardItemInfo 更新信息
   * @param cardId 卡片id
   * @returns 是否成功
   */
  public async updateExtend1ByCardId(extend1: string, cardId: string, isOuter?: boolean): Promise<boolean> {
    if (CheckEmptyUtils.checkStrIsEmpty(extend1)) {
      log.showWarn('updateExtend1ByCardId extend1 is invalid');
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, cardId);
    const updateBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.EXTEND1]: extend1
    };
    let changeRows = await rdbTaskPool.update(this.getLayoutInfoTableName(isOuter), conditions, updateBucket);
    log.showInfo('updateExtend1ByCardId update: %{public}d, cardId: %{public}s', changeRows, cardId);
    return true;
  }

  /**
   * 根据ability以及元素类型，更新桌面布局表中的info_name信息
   * @param appName
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @param typeId
   * @returns
   */
  public async updateAppNameByAbilityInfoAndType(appName: string, bundleName: string,
                                                 moduleName: string, abilityName: string, typeId: number, appIndex?: number, isOuter?:boolean): Promise<void> {
    if (CheckEmptyUtils.checkStrIsEmpty(appName)) {
      log.showWarn('updateAppNameByAbilityInfoAndType appName is empty.');
      return;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, bundleName);
    conditions.set(GridLayoutInfoColumns.MODULE_NAME, moduleName);
    conditions.set(GridLayoutInfoColumns.ABILITY_NAME, abilityName);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, typeId);
    conditions.set(GridLayoutInfoColumns.APP_INDEX, appIndex ?? 0);
    const updateBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.INFO_NAME]: appName
    };
    rdbTaskPool.update(this.getLayoutInfoTableName(isOuter), conditions, updateBucket);
  }

  /**
   * 根据infoId更新文件夹的intent信息
   *
   * @param infoId 文件夹Id
   * @param intent 文件夹的intent信息
   */
  public async updateFolderIntentByInfoId(infoId: string, intent: string): Promise<void> {
    if (CheckEmptyUtils.checkStrIsEmpty(infoId) || CheckEmptyUtils.checkStrIsEmpty(intent)) {
      log.showWarn('updateFolderIntentByInfoId, infoId or intent is empty.');
      return;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, infoId);
    let updateBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.EXTEND1]: '',
      [GridLayoutInfoEnums.INTENT]: intent
    };
    rdbTaskPool.update(this.mLayoutTableName, conditions, updateBucket);
  }

  /**
   * 根据folderContainer更新文件夹内应用在桌面布局表中的intent信息
   *
   * @param folderContainer 应用所在文件夹container
   * @param intent 应用的intent信息
   */
  public async updateAppItemIntentByInfoId(folderContainer: number, intent: string): Promise<void> {
    if (CheckEmptyUtils.checkStrIsEmpty(intent)) {
      log.showWarn('updateAppItemIntentByInfoId, intent is empty.');
      return;
    }
    //修改文件夹内app信息
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.CONTAINER, folderContainer);
    let updateBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.KIND_ID]: '',
      [GridLayoutInfoEnums.INTENT]: intent
    };
    rdbTaskPool.update(this.mLayoutTableName, conditions, updateBucket);
  }

  /**
   * 批量更新空白页信息
   *
   * @param blankPageList 空白页信息
   * @returns 是否成功
   */
  public async updatePageIndexTypeInfoOfDb(blankPageList: PageIndexTypeInfo[], isSimpleMode: boolean, isOuter: boolean): Promise<boolean> {
    log.showWarn('batchInsertPageIndexTypeInfo start');
    let result = false;
    try {
      let pageIndexTypeInfo = RdbStoreConfig.pageIndexTypeInfo;
      if (isOuter) {
        pageIndexTypeInfo = RdbStoreConfig.outerPageIndexTypeInfo;
      } else if (isSimpleMode) {
        pageIndexTypeInfo = RdbStoreConfig.simplePageIndexTypeInfo;
      }
      await rdbStoreHelper.executeSql(pageIndexTypeInfo.dropTable);
      await rdbStoreHelper.executeSql(pageIndexTypeInfo.createTable);
      const buckets: rdb.ValuesBucket[] = [];
      for (const blankPage of blankPageList) {
        log.showInfo(`batchInsertPageIndexTypeInfo ${blankPage.pageIndex}, ${blankPage.type}`);
        const bucket: rdb.ValuesBucket = {
          [PageIndexTypeInfoEnums.PAGE_INDEX]: blankPage.pageIndex,
          [PageIndexTypeInfoEnums.TYPE]: blankPage.type,
        };
        buckets.push(bucket);
      }
      log.showInfo(`batchInsertPageIndexTypeInfo buckets ${JSON.stringify(buckets)}`);
      let changeRows = await rdbTaskPool.batchInsert(pageIndexTypeInfo.tableName, buckets);
      log.showInfo(`batchInsertPageIndexTypeInfo insert:${changeRows}`);
      result = (changeRows !== CommonConstants.INVALID_VALUE);
    } catch (e) {
      log.showError(`batchInsertPageIndexTypeInfo error: ${e?.message}`);
    }
    return result;
  }

  /**
   * 查询空白页信息
   *
   * @returns 桌面布局信息
   */
  public async queryAllPageIndexTypeInfo(isSimpleMode: boolean, isOuter: boolean): Promise<PageIndexTypeInfo[]> {
    log.showInfo('queryAllPageIndexTypeInfo start');
    let pageIndexTypeInfo = RdbStoreConfig.pageIndexTypeInfo;
    if (isOuter) {
      pageIndexTypeInfo = RdbStoreConfig.outerPageIndexTypeInfo;
    } else if (isSimpleMode) {
      pageIndexTypeInfo = RdbStoreConfig.simplePageIndexTypeInfo;
    }
    let result: PageIndexTypeInfo[] = await rdbTaskPool.queryPageIndexTypeInfo(
      pageIndexTypeInfo.tableName, undefined);
    return result;
  }

  /**
   * 插入外屏应用分类名单
   *
   * @param insertBucketList 待插入的名单
   * @returns 插入数量
   */
  public async insertOuterAppCategorizeData(insertBucketList: Array<rdb.ValuesBucket>): Promise<void> {
    // 初始化表
    await rdbStoreHelper.executeSql(RdbStoreConfig.outerAppCategorize.dropTable);
    await rdbStoreHelper.executeSql(RdbStoreConfig.outerAppCategorize.createTable);
    let num: number = await rdbTaskPool.batchInsert(RdbStoreConfig.outerAppCategorize.tableName, insertBucketList);
    log.showInfo(`insertOuterAppCategorizeData num: ${num}`);
  }

  /**
   * 获取新形态小折叠外屏所有应用分类
   *
   * @returns 所有分类名单列表
   */
  public async queryOuterAllAppCategorize(): Promise<Map<string, string[]>> {
    return await rdbTaskPool.queryOuterAppCategorize(RdbStoreConfig.outerAppCategorize.tableName);
  }

  /**
   * 根据info_id和container删除布局元素
   *
   * @param items 被删除的布局信息
   * @returns true:删除成功;false:删除失败
   */
  public async deleteItemsByInfoIdAndContainer(items: GridLayoutItemInfo[], isOuter?: boolean): Promise<boolean> {
    log.showWarn(`deleteItemsByInfoIdAndContainer count ${items.length}`);
    if (CheckEmptyUtils.isEmptyArr<GridLayoutItemInfo>(items)) {
      log.showWarn('deleteItemsByInfoIdAndContainer items is empty.');
      return false;
    }
    // task pool args serialize
    let proxyItems = items.map((item) => GridLayoutUtil.mapProxyTypeGridLayout(item));
    const deleteResult: boolean =
      await rdbTaskPool.deleteItemsByInfoIdAndContainer(RdbStoreConfig.gridLayoutInfo.tableName, proxyItems);
    return deleteResult;
  }

  /**
   * 设置debug状态
   *
   * @param debugStatus
   */
  public setDebugStatus(debugStatus: number):void {
    this.debugStatus = debugStatus;
  }
}

export class ExtraInfo {
  public container?: number;
  public isConvertToSmall?: boolean;
  public isOuter?: boolean;
  public ctx?: SingleContext;

  constructor(container?: number, isConvertToSmall?: boolean, isOuter?: boolean, ctx?: SingleContext) {
    if (!CheckEmptyUtils.isEmpty(isConvertToSmall)) {
      this.isConvertToSmall = isConvertToSmall;
    }
    if (!CheckEmptyUtils.isEmpty(isOuter)) {
      this.isOuter = isOuter;
    }
    if (!CheckEmptyUtils.isEmpty(ctx)) {
      this.ctx = ctx;
    }
    if (!CheckEmptyUtils.isEmpty(container)) {
      this.container = container;
    }
  }
}