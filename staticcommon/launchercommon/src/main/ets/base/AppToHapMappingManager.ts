/**
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, CommonUtils, FileUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { AppItemInfo, AppModel } from '../TsIndex';
import { AppFoundationServiceExtensionManager, MappingInfo } from '../manager/AppFoundationServiceExtensionManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'AppToHapMappingManager');
const MAPPING_KEY: string = 'mapping';
const LAST_UPDATE_TIME_KEY: string = 'lastUpdateTime';
const PREFERENCES_FILE_NAME: string = 'mappingFile';
const DELIVERY_APP_STRATEGY_FILE_NAME: string = 'delivery_app_strategy.json';
const LOCAL_PATH_PREFIX = '/';
const DAY_IN_MILLIS = 1000 * 60 * 60 * 24;
const APP_LEAVE_LAKE_BLOCK_TYPE: string = 'block';
const APP_LEAVE_GRAY_TYPE: string = 'gray';
const APP_LEAVE_TRUST_TYPE: string = 'trust';

export class AppToHapMappingManager {
  private static sInstance: AppToHapMappingManager;
  private mMapping: Map<string, AppToHapDetail> = new Map();
  private mLastUpdateTime: number = 0;
  private mRecordMap: Map<string, AppShowDialogDetail> = new Map();
  private mappingPreferences: preferences.Preferences | null = null;
  private appToHapPolicyMap: Map<string, AppToHapPolicyStrategy> = new Map();

  private constructor() {
    this.init();
  };

  private init(): void {
    let options: preferences.Options = { name: PREFERENCES_FILE_NAME };
    try {
      this.mappingPreferences = preferences.getPreferencesSync(GlobalContext.getInstance()
        .getObject('desktopContext') as common.ApplicationContext, options);
    } catch (error) {
      log.showError('getPreferences with error %{public}s', error.message);
    }
    if (this.mappingPreferences == null) {
      return;
    }
    this.mLastUpdateTime = this.mappingPreferences.getSync(LAST_UPDATE_TIME_KEY, 0) as number;
    log.showInfo('init mLastUpdateTime: %{public}d', this.mLastUpdateTime);
    this.mRecordMap = this.getMyRecordMapFromSP();
    this.mMapping = this.getMappingFromSP();
    this.initAppToHapPolicyMap();
  }

  private getMyRecordMapFromSP(): Map<string, AppShowDialogDetail> {
    let allKeys: string[] = Object.keys(this.mappingPreferences?.getAllSync());
    if (CheckEmptyUtils.isEmptyArr(allKeys)) {
      log.warn('getMyRecordMapFromSP allKeys is empty');
      return this.mRecordMap;
    }
    allKeys.forEach(bundle => {
      log.showInfo('getMyRecordMapFromSP allKeys.forEach: %{public}s', bundle);
      if (bundle !== MAPPING_KEY && bundle !== LAST_UPDATE_TIME_KEY) {
        let appShowDialogDetailString: string = this.mappingPreferences?.getSync(bundle, '') as string;
        let appShowDialogDetail: AppShowDialogDetail;
        if (!isNaN(Number(appShowDialogDetailString))) {
          appShowDialogDetail =
            { lastShowDialogTime: Number(appShowDialogDetailString), showDialogCount: 1, increasingFlag: 1 };
        } else {
          try {
            appShowDialogDetail = JSON.parse(appShowDialogDetailString) as AppShowDialogDetail;
          } catch (e) {
            appShowDialogDetail = { lastShowDialogTime: 0, showDialogCount: 1, increasingFlag: 1 };
            log.showError('JSON.parse appShowDialogDetail error:' + e);
          }
        }
        this.mRecordMap.set(bundle, appShowDialogDetail);
      }
    });
    log.showInfo('getMyRecordMapFromSP mRecordMap: %{public}d', this.mRecordMap.size);
    return this.mRecordMap;
  }

  private getMappingFromSP(): Map<string, AppToHapDetail> {
    let jsonStr = this.mappingPreferences?.getSync(MAPPING_KEY, '') as string;
    log.showInfo('getMappingFromSP jsonStr: %{public}s', jsonStr);
    let map: Map<string, Object> = CommonUtils.jsonStrToMap(jsonStr);
    map.forEach((value, key) => {
      if (CommonUtils.isString(value)) {
        this.mMapping.set(key, { bundleName: value as string });
      } else {
        this.mMapping.set(key, value as AppToHapDetail);
      }
    });
    log.showInfo('getMappingFromSP mMapping: %{public}d', this.mMapping.size);
    return this.mMapping;
  }

  private saveMyMapping(map: Map<string, AppToHapDetail>): void {
    let item: Record<string, Object> = {};
    map.forEach((value, key) => {
      if (!CheckEmptyUtils.isEmpty(key)) {
        item[key] = value;
      }
    });
    let mapJsonStr = JSON.stringify(item);
    this.mappingPreferences?.putSync(MAPPING_KEY, mapJsonStr);
    this.mappingPreferences?.flush();
  }

  private saveMyLastUpdateTime(time: number): void {
    this.mLastUpdateTime = time;
    this.mappingPreferences?.putSync(LAST_UPDATE_TIME_KEY, time);
    this.mappingPreferences?.flush();
  }

  private saveMyRecordMap(bundleName: string, lastAlertDialogTime: number): void {
    if (this.mRecordMap.has(bundleName)) {
      let appShowDialogDetail: AppShowDialogDetail = this.mRecordMap.get(bundleName) as AppShowDialogDetail;
      appShowDialogDetail.lastShowDialogTime = lastAlertDialogTime;
      if (appShowDialogDetail.showDialogCount) {
        appShowDialogDetail.showDialogCount = appShowDialogDetail.showDialogCount + 1;
      }
      if (appShowDialogDetail.increasingFlag) {
        appShowDialogDetail.increasingFlag = appShowDialogDetail.increasingFlag + 1;
      }
    } else {
      this.mRecordMap.set(bundleName, { lastShowDialogTime: lastAlertDialogTime, showDialogCount: 1, increasingFlag: 1 });
    }
    this.mappingPreferences?.putSync(bundleName, JSON.stringify(this.mRecordMap.get(bundleName)));
    this.mappingPreferences?.flush();
  }

  static getInstance(): AppToHapMappingManager {
    if (!AppToHapMappingManager.sInstance) {
      AppToHapMappingManager.sInstance = new AppToHapMappingManager();
    }
    return AppToHapMappingManager.sInstance;
  }

  public getMapping(): Map<string, string> {
    let mapping: Map<string, string> = new Map();
    this.mMapping.forEach((value, key) => {
      mapping.set(key, value.bundleName);
    });
    return mapping;
  }

  private isUninstalled(hapName: string): boolean {
    return AppModel.getInstance().getAppInfoByBundleName(hapName) === undefined;
  }

  /**
   * 应用是否强制更新/卸载
   * @param bundleName 应用包名
   * @returns 是否强制更新/卸载
   */
  public isForceUpdate(bundleName: string): boolean {
    let appToHapDetail: AppToHapDetail | undefined = this.mMapping.get(bundleName);
    if (!appToHapDetail || CheckEmptyUtils.checkStrIsEmpty(appToHapDetail.bundleName)) {
      return false;
    }
    let policyStrategy: AppToHapPolicyStrategy | undefined = this.appToHapPolicyMap.get(bundleName);
    if (!policyStrategy && appToHapDetail.mappingType) {
      policyStrategy = this.appToHapPolicyMap.get(appToHapDetail.mappingType);
    }
    let isForceUpdate: boolean = (policyStrategy && policyStrategy.forceUpdate === true) ?? false;
    log.showInfo('isForceUpdate: %{public}s', isForceUpdate);
    return isForceUpdate;
  }

  /**
   * 已安装应用弹框类型
   *
   * @param bundleName 应用包名
   * @returns 弹框类型
   */
  public getInstalledDialogType(bundleName: string): InstalledDialogType {
    let appToHapDetail: AppToHapDetail | undefined = this.mMapping.get(bundleName);
    if (!appToHapDetail || CheckEmptyUtils.checkStrIsEmpty(appToHapDetail.bundleName)) {
      return InstalledDialogType.OPEN;
    }
    let policyStrategy: AppToHapPolicyStrategy | undefined = this.appToHapPolicyMap.get(bundleName);
    if (!policyStrategy && appToHapDetail.mappingType) {
      policyStrategy = this.appToHapPolicyMap.get(appToHapDetail.mappingType);
    }
    if (!policyStrategy || CheckEmptyUtils.checkStrIsEmpty(String(policyStrategy.installedDialogType))) {
      log.showInfo(`installedDialogType is not exit`);
      return InstalledDialogType.OPEN;
    }
    let installedDialogType: InstalledDialogType = Number(policyStrategy.installedDialogType);
    if (isNaN(installedDialogType) || installedDialogType < 0 || installedDialogType > 2) {
      installedDialogType = InstalledDialogType.OPEN;
    }
    log.showInfo(`installedDialogType: ${installedDialogType}`);
    return installedDialogType;
  }

  /**
   * 校验弹框频率和次数
   * @param appShowDialogDetail
   * @param policyStrategy
   * @returns
   */
  private checkRemindFrequencyAndCount(appShowDialogDetail: AppShowDialogDetail | undefined,
    policyStrategy: AppToHapPolicyStrategy): boolean {
    let showDialogCount: number = appShowDialogDetail?.showDialogCount ?? 0;
    let lastShowDialogTime: number = appShowDialogDetail?.lastShowDialogTime ?? 0;
    // 最大提醒次数默认-1（不限制次数）
    let remindMaxCount: number = policyStrategy.remindMaxCount ?? -1;
    let checkRemindCount: boolean = remindMaxCount === -1 || showDialogCount < remindMaxCount;
    // 提醒频率默认为一天
    let remindFrequency: string = !policyStrategy.remindFrequency &&
      CheckEmptyUtils.checkStrIsEmpty(policyStrategy.remindFrequency) ? '1' : (policyStrategy.remindFrequency ?? '1');
    log.showInfo('checkRemindFrequencyAndCount remindMaxCount: %{public}d, remindFrequency: %{public}s', remindMaxCount,
      remindFrequency);
    let checkRemindFrequency: boolean = false;
    if (!isNaN(Number(remindFrequency))) {
      checkRemindFrequency = lastShowDialogTime < this.minusDays(new Date(), Number(remindFrequency));
    } else if (!isNaN(Number(remindFrequency.replace('d', '')))) {
      let increasingFlag: number = appShowDialogDetail?.increasingFlag ?? 0;
      checkRemindFrequency =
        lastShowDialogTime < this.minusDays(new Date(), Number(remindFrequency.replace('d', '')) * increasingFlag);
    }
    log.showInfo('checkRemindFrequencyAndCount checkRemindCount: %{public}s, checkRemindFrequency: %{public}s',
      checkRemindCount, checkRemindFrequency);
    return checkRemindCount && checkRemindFrequency;
  }

  private firstQueryMapping(): boolean {
    return this.mLastUpdateTime === 0;
  }

  private isQueryMappingAfter24Hours(): boolean {
    let isQueryMappingAfter24Hours: boolean = this.mLastUpdateTime < this.minusDays(new Date(), 1);
    log.showInfo('isQueryMappingAfter24Hours isQueryMappingAfter24Hours : %{public}s', isQueryMappingAfter24Hours);
    return isQueryMappingAfter24Hours;
  }

  /**
   *  查询映射关系
   * @returns
   */
  public async queryCloudAppMappingAndPersist(): Promise<void> {
    if (!this.firstQueryMapping() && !this.isQueryMappingAfter24Hours()) {
      log.showInfo('queryCloudAppMappingAndPersist not match query condition');
      return;
    }
    let map = new Map<string, AppToHapDetail>();
    let appServiceManager: AppFoundationServiceExtensionManager = AppFoundationServiceExtensionManager.getInstance();
    let totalAppArr: AppItemInfo[] = AppModel.getInstance().getAppList();
    let deliverPackageNameArr: string[] = [];
    totalAppArr.forEach(item => {});
    await appServiceManager.queryAppMappingInfo(deliverPackageNameArr);
    let relationMap: Map<string, MappingInfo> = appServiceManager.getohosAppMappingInfoMap();
    log.showInfo('queryAppMappingInfo res.length : %{public}d', relationMap.size);
    if (appServiceManager.queryMappingResult()) {
      relationMap.forEach((value, key) => {
        if (CheckEmptyUtils.isEmptyArr(value.harmonyInfos)) {
          log.showWarn('queryAppMappingInfo res.length : %{public}s value is empty', key);
          return;
        }
        let bundleName: string = value.harmonyInfos[0].bundleName;
        let isGray: boolean = (value.type & 1 << 13) > 0;
        if (isGray) {
          this.setMappingInfo(map, key, bundleName, APP_LEAVE_GRAY_TYPE);
        } else {
          this.setMappingInfo(map, key, bundleName, APP_LEAVE_LAKE_BLOCK_TYPE);
        }
      });
      this.mMapping = map;
      this.saveMyMapping(map);
    }
    this.saveMyLastUpdateTime(new Date().getTime());
  }

  private setMappingInfo(map: Map<string, AppToHapDetail>, key: string, bundleName: string,
    appToHapPolicyType: string): void {
    log.showInfo('queryAppMappingInfo packageName: %{public}s, bundleName: %{public}s, appToHapPolicyType:%{public}d',
      key, bundleName, appToHapPolicyType);
    map.set(key, {
      bundleName: bundleName,
      mappingType: appToHapPolicyType,
    });
  }

  public getPackageName(bundleName: string): string {
    let packageName: string = '';
    this.mMapping.forEach((value, key) => {
      if (bundleName === value.bundleName) {
        packageName = key;
      }
    });
    return packageName;
  }

  private minusDays(date: Date, days: number): number {
    let curTime = date.getTime();
    return curTime - (days * DAY_IN_MILLIS);
  }

  /**
   *  初始化出湖策略
   */
  public initAppToHapPolicyMap(): void {
    let strategyPath = GlobalContext.getContext().filesDir + LOCAL_PATH_PREFIX + DELIVERY_APP_STRATEGY_FILE_NAME;
    if (!FileUtils.isExist(strategyPath)) {
      this.initDefaultConfig();
      return;
    }
    let strategyConfigJson: DeliveryPolicyStrategy = FileUtils.readJsonFile(strategyPath);
    log.info(`initStrategy configJson ${JSON.stringify(strategyConfigJson)}`);
    if (!strategyConfigJson) {
      this.initDefaultConfig();
      return;
    }
    this.appToHapPolicyMap.clear();
    if (strategyConfigJson.block) {
      this.appToHapPolicyMap.set(APP_LEAVE_LAKE_BLOCK_TYPE, strategyConfigJson.block);
    }
    if (strategyConfigJson.gray) {
      this.appToHapPolicyMap.set(APP_LEAVE_GRAY_TYPE, strategyConfigJson.gray);
    }
    if (strategyConfigJson.trust) {
      this.appToHapPolicyMap.set(APP_LEAVE_TRUST_TYPE, strategyConfigJson.trust);
    }
    if (strategyConfigJson.special) {
      Object.keys(strategyConfigJson.special).forEach((specialKey) => {
        if (!strategyConfigJson.special) {
          return;
        }
        this.appToHapPolicyMap.set(specialKey, strategyConfigJson.special[specialKey]);
      })
    }
    this.appToHapPolicyMap.forEach((value, key) => {
      if (value.forceUpdate === true) {
        value.remindFrequency = '0';
        log.showInfo(`initAppToHapPolicyMap, ${key} forceUpdate is true, remindFrequency set 0}`);
      }
    });
  }

  private initDefaultConfig(): void {
    this.appToHapPolicyMap.set(APP_LEAVE_LAKE_BLOCK_TYPE, { remindUpdate: true });
    this.appToHapPolicyMap.set(APP_LEAVE_GRAY_TYPE, { remindUpdate: false });
    this.appToHapPolicyMap.set(APP_LEAVE_TRUST_TYPE, { remindUpdate: false });
  }


  /**
   *  策略更新时重置缓存的应用弹框记录详情
   */
  public resetDialogDetail(): void {
    this.mRecordMap.clear();
    let allKeys: string[] = Object.keys(this.mappingPreferences?.getAllSync());
    if (CheckEmptyUtils.isEmptyArr(allKeys)) {
      log.warn('resetDialogDetail allKeys is empty');
      return;
    }
    allKeys.forEach(bundle => {
      if (bundle !== MAPPING_KEY && bundle !== LAST_UPDATE_TIME_KEY) {
        let appShowDialogDetailString: string = this.mappingPreferences?.getSync(bundle, '') as string;
        let appShowDialogDetail: AppShowDialogDetail;
        try {
          appShowDialogDetail = JSON.parse(appShowDialogDetailString) as AppShowDialogDetail;
          appShowDialogDetail.increasingFlag = 0;
        } catch (e) {
          appShowDialogDetail = { lastShowDialogTime: 0, showDialogCount: 1, increasingFlag: 1 };
          log.showError('JSON.parse appShowDialogDetail error:' + e);
        }
        this.mRecordMap.set(bundle, appShowDialogDetail);
        this.mappingPreferences?.putSync(bundle, JSON.stringify(appShowDialogDetail));
      }
    });
    this.mappingPreferences?.flush();
    log.info('resetDialogDetail reset increasingFlag success');
  }
}

class AppToHapPolicyStrategy {
  public remindUpdate?: boolean;
  public forceUpdate?: boolean;
  public installedDialogType?: InstalledDialogType;
  public remindFrequency?: string;
  public remindMaxCount?: number;
}

class DeliveryPolicyStrategy {
  public block?: AppToHapPolicyStrategy;
  public gray?: AppToHapPolicyStrategy;
  public trust?: AppToHapPolicyStrategy;
  public special?: Record<string, AppToHapPolicyStrategy>;
}

export class AppToHapDetail {
  public bundleName: string = '';
  public mappingType?: string;
}

export class AppShowDialogDetail {
  public lastShowDialogTime: number = 0;
  public showDialogCount?: number;
  public increasingFlag?: number;
}

export enum InstalledDialogType {
  OPEN = 0,
  UNINSTALL = 1,
  FORCE_UNINSTALL = 2,
}