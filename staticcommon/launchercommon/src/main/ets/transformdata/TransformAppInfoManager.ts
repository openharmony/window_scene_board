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
import { CheckEmptyUtils, FileUtils, LogDomain, Logger } from '@ohos/basicutils';
import fs from '@ohos.file.fs';
import { LocalHapMigrateInfo } from './LocalHapMigrateInfo';
import { PackageInfo, AbroadPackageInfo } from './PackageInfo';
import { ConfigParseUtil } from '../TsIndex';
import { convertxml } from '@kit.ArkTS';

const TAG = 'TransformAppInfoManager';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
const INSTALL_LIST_CONFIG_PATH = 'etc/app/install_list_capability.json';
const DISALLOWED_HAP_LIST_IN_PRIVATE_SPACE_CONFIG_PATH = 'etc/private_space/disallowed_hap_list.xml';
const THIRD_APP_MIGRATE_POLICY = 'third_dev_module_migrate_policy.json';
const ENTERPRISE_APP_MIGRATE_POLICY = 'enterprise_module_migrate_policy.json';
const AG_APP_MIGRATE_POLICY = 'ag_module_migrate_policy.json';
const AUTO_MIGRATE_PRIVACY_CODE = 'auto_migrate_privacy_code.json';
const ABROAD_AUTO_MIGRATE_PRIVACY_CODE = 'abroad_auto_migrate_privacy_code.json';
const APP_LIST = 'app_list.json';
const ABROAD_APP_LIST = 'abroad_app_list.json';
const APP_RESERVE_POLICY = 'app_reserve_policy.json';
const BACK_RESTORE_PATH = 'restore/';
const APP_RESERVE_POLICY_RESERVE = 'reserve';
const MAIN_USER_ID = 100;
const SUB_USER_ID_GAP = 91;
const CLONEDPROFILE_USER_ID_MIN = 128;
const CLONEDPROFILE_USER_ID_MAX = 148;
const UNKNOWN = 'unknown';

export enum AppReservePolicyType {
  UNDEFINED = 0,
  DELETE = 1,
  RESERVE = 2,
}

export enum AppReserveType {
  // 普通三方应用
  THIRD = 0,
  // 企业应用
  ENTERPRISE = 1,
  // 尝鲜应用
  TASTE_FRESH = 2,
  // 克隆应用应用
  DELIVER_TONG = 3,
  // 兜底应用
  OTHER_DELIVER = 4,
  // 应用应用
  EASYA_BROAD = 5,
  // 快捷方式
  SHORTCUT = 6
}

export enum AutoMigrateType {
  NOMIGRATE = 0,
  MIGRATE = 1
}

export enum RgmSupport32Type {
  NOTSUPPORT = 0,
  SUPPORT = 1
}

export class TransformAppInfoManager {
  private static sInstance: TransformAppInfoManager;
  public static sHideIconAppList: Set<string> = new Set();
  public static disallowedHapListInPrivateSpace: Set<string> = new Set();

  private mAppMigrateInfos: Array<LocalHapMigrateInfo> = [];
  private mAppMigrateInfoMap: Map<string, LocalHapMigrateInfo> = new Map();
  private mAppReservePolicy = AppReservePolicyType.UNDEFINED;
  private mPackageInfos: Map<number, Array<PackageInfo>> = new Map();
  private readonly mAbroadPackageInfos: Array<AbroadPackageInfo> = [];
  private mSunsetAppList: Set<string> = new Set();
  private isAutoMigrateApp: number = AutoMigrateType.NOMIGRATE;
  private isAbroadAutoMigrateApp: number = AutoMigrateType.NOMIGRATE;
  private isRgmSupport32: number = RgmSupport32Type.NOTSUPPORT;
  private privacyPolicyCode: string = '';
  private userAgreementCode: string = '';
  private abroadPrivacyPolicyCode: string = '';
  private abroadUserAgreementCode: string = '';
  private isNeedLoadEnterpirsePolicy: boolean = true;

  // /data/storage/el1/base/haps/phone_sceneboard/files
  private filesDir: string = '';
  // /data/storage/el1/base/.backup/
  private backupDir: string = '';

  public static getInstance(): TransformAppInfoManager {
    if (!TransformAppInfoManager.sInstance) {
      TransformAppInfoManager.sInstance = new TransformAppInfoManager();
    }
    return TransformAppInfoManager.sInstance;
  }

  public init(filesDir: string, backupDir?: string): void {
    if (this.checkPathValid(filesDir)) {
      this.filesDir = filesDir;
      this.filesDir += this.filesDir.endsWith('/') ? '' : '/';
    }
    if (this.checkPathValid(backupDir)) {
      this.backupDir = backupDir ?? '';
      this.backupDir += this.backupDir.endsWith('/') ? '' : '/';
    }
    log.showInfo(TAG, `init filesDir is: ${this.filesDir}`);
    log.showInfo(TAG, `init backupDir is: ${this.backupDir}`);
  }

  private checkPathValid(dir?: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(dir)) {
      return false;
    }
    return FileUtils.isExist(dir);
  }

  public saveFilesToLocal(): void {
    if (CheckEmptyUtils.checkStrIsEmpty(this.backupDir) || CheckEmptyUtils.checkStrIsEmpty(this.filesDir)) {
      log.showWarn(TAG, 'saveFilesToLocal fileDir or backupDir is empty');
      return;
    }
    this.saveFileToLocal(THIRD_APP_MIGRATE_POLICY);
    this.saveFileToLocal(APP_LIST);
    this.saveFileToLocal(ABROAD_APP_LIST);
    this.saveFileToLocal(APP_RESERVE_POLICY);
    this.saveFileToLocal(ENTERPRISE_APP_MIGRATE_POLICY);
    this.saveFileToLocal(AG_APP_MIGRATE_POLICY);
    this.saveFileToLocal(AUTO_MIGRATE_PRIVACY_CODE);
    this.saveFileToLocal(ABROAD_AUTO_MIGRATE_PRIVACY_CODE);
  }

  private saveFileToLocal(fileName: string): void {
    log.showInfo(TAG, `saveFileToLocal : ${fileName}`);
    if (FileUtils.isExist(this.backupDir + BACK_RESTORE_PATH + fileName)) {
      FileUtils.copyFile(this.backupDir + BACK_RESTORE_PATH + fileName, this.filesDir + fileName);
      log.showInfo(TAG, `saveFileToLocal dest path : ${this.filesDir + fileName}`);
    } else {
      log.showWarn(TAG, `saveFileToLocal file not exist: ${fileName}`);
    }
  }

  public getAppReservePolicy(reload: boolean): AppReservePolicyType {
    if (this.mAppReservePolicy === AppReservePolicyType.UNDEFINED || reload) {
      this.loadAppReservePolicy();
    }
    return this.mAppReservePolicy;
  }

  public getSunsetAppList(reload: boolean): Set<string> {
    if (this.mAppReservePolicy === AppReservePolicyType.UNDEFINED || reload) {
      this.loadAppReservePolicy();
    }
    return this.mSunsetAppList;
  }

  public getAutoMigrateAppType(reload: boolean): number {
    if (this.mAppReservePolicy === AppReservePolicyType.UNDEFINED || reload) {
      this.loadAppReservePolicy();
    }
    if (!this.privacyPolicyCode || !this.userAgreementCode || reload) {
      this.loadOucAutoMigratePolicy();
    }
    // 自动开关打开的情况下,依赖双上面的协议声明。同意才可自动
    if (this.privacyPolicyCode === UNKNOWN || this.userAgreementCode === UNKNOWN) {
      return AutoMigrateType.NOMIGRATE;
    }
    return this.isAutoMigrateApp;
  }

  public getAbroadAutoMigrateAppType(reload?: boolean): number {
    if (this.mAppReservePolicy === AppReservePolicyType.UNDEFINED || reload) {
      this.loadAppReservePolicy();
    }
    if (!this.abroadPrivacyPolicyCode || !this.abroadUserAgreementCode || reload) {
      this.loadOUCAbroadAutoMigratePolicy();
    }
    // 自动开关打开的情况下,依赖双上面的协议声明。同意才可自动
    if (this.abroadPrivacyPolicyCode === UNKNOWN || this.abroadUserAgreementCode === UNKNOWN) {
      return AutoMigrateType.NOMIGRATE;
    }
    return this.isAbroadAutoMigrateApp;
  }

  public getRgmSupportType(reload: boolean): RgmSupport32Type {
    if (this.mAppReservePolicy === AppReservePolicyType.UNDEFINED || reload) {
      this.loadAppReservePolicy();
    }
    return this.isRgmSupport32;
  }

  private loadOucAutoMigratePolicy(): void {
    let config: string = this.getFileString(AUTO_MIGRATE_PRIVACY_CODE);
    if (CheckEmptyUtils.checkStrIsEmpty(config)) {
      log.showWarn(TAG, 'loadOucAutoMigratePolicy config string empty');
      this.privacyPolicyCode = UNKNOWN;
      this.userAgreementCode = UNKNOWN;
      return;
    }
    let jsonObject: IJsonInfo;
    try {
      jsonObject = JSON.parse(config);
    } catch (error) {
      this.privacyPolicyCode = UNKNOWN;
      this.userAgreementCode = UNKNOWN;
      log.showError(TAG, 'loadOucAutoMigratePolicy parse json error %{public}s', error?.message);
      return;
    }
    this.privacyPolicyCode = jsonObject.privacyPolicyCode ?? UNKNOWN;
    this.userAgreementCode = jsonObject.userAgreementCode ?? UNKNOWN;
    log.showInfo(TAG, 'loadOucAutoMigratePolicy privacyPolicyCode = %{public}s , userAgreementCode = %{public}s',
      this.privacyPolicyCode, this.userAgreementCode);
  }

  private loadOUCAbroadAutoMigratePolicy(): void {
    let config: string = this.getFileString(ABROAD_AUTO_MIGRATE_PRIVACY_CODE);
    if (CheckEmptyUtils.checkStrIsEmpty(config)) {
      log.showWarn(TAG, 'loadOUCAbroadAutoMigratePolicy config string empty');
      this.abroadPrivacyPolicyCode = UNKNOWN;
      this.abroadUserAgreementCode = UNKNOWN;
      return;
    }
    let jsonObject: IJsonInfo;
    try {
      jsonObject = JSON.parse(config);
    } catch (error) {
      this.abroadPrivacyPolicyCode = UNKNOWN;
      this.abroadUserAgreementCode = UNKNOWN;
      log.showError(TAG, 'loadOUCAbroadAutoMigratePolicy parse json error %{public}s', error?.message);
      return;
    }
    this.abroadPrivacyPolicyCode = jsonObject.privacyPolicyCode ?? UNKNOWN;
    this.abroadUserAgreementCode = jsonObject.userAgreementCode ?? UNKNOWN;
    log.showInfo(TAG, 'loadOUCAbroadAutoMigratePolicy privacyPolicyCode = %{public}s , userAgreementCode = %{public}s',
      this.abroadPrivacyPolicyCode, this.abroadUserAgreementCode);
  }

  private loadAppReservePolicy(): void {
    let config: string = this.getFileString(APP_RESERVE_POLICY);
    if (CheckEmptyUtils.checkStrIsEmpty(config)) {
      log.showWarn(TAG, 'loadAppReservePolicy config string empty');
      this.mAppReservePolicy = AppReservePolicyType.DELETE;
      return;
    }
    let jsonObject: IJSonAppReservePolicy;
    try {
      jsonObject = JSON.parse(config);
    } catch (error) {
      this.mAppReservePolicy = AppReservePolicyType.DELETE;
      log.showError(TAG, 'parse json error %{public}s ', error?.message);
      return;
    }
    if (jsonObject?.appReservePolicy === APP_RESERVE_POLICY_RESERVE) {
      this.mAppReservePolicy = AppReservePolicyType.RESERVE;
    } else {
      this.mAppReservePolicy = AppReservePolicyType.DELETE;
    }
    if (!CheckEmptyUtils.isEmpty(jsonObject?.sunsetAppList)) {
      log.showInfo(TAG, `sunsetAppList  is: ${jsonObject?.sunsetAppList}`);
      let sunsetArr: string[] = jsonObject?.sunsetAppList.split(',');
      sunsetArr.forEach(item => this.mSunsetAppList.add(item));
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(jsonObject?.isAutoMigrateApp)) {
      this.isAutoMigrateApp = Number(jsonObject?.isAutoMigrateApp);
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(jsonObject?.isAbroadAutoMigrateApp)) {
      this.isAbroadAutoMigrateApp = Number(jsonObject?.isAbroadAutoMigrateApp);
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(jsonObject?.isRgmSupport32)) {
      this.isRgmSupport32 = Number(jsonObject?.isRgmSupport32);
    }
    log.showInfo(TAG, `AppReservePolicy is:${this.mAppReservePolicy}, isAutoMigrateApp is: ${jsonObject?.isAutoMigrateApp}, ` +
      `isAbroadAutoMigrateApp is: ${jsonObject?.isAbroadAutoMigrateApp}, isRgmSupport32 is: ${jsonObject?.isRgmSupport32}`);
  }

  public getHapMigrateInfos(): Array<LocalHapMigrateInfo> {
    if (CheckEmptyUtils.isEmptyArr(this.mAppMigrateInfos)) {
      this.loadMigratePolicies();
    }
    return this.mAppMigrateInfos;
  }

  public getHapMigrateInfosMap(): Map<string, LocalHapMigrateInfo> {
    if (this.mAppMigrateInfoMap.size === 0) {
      this.loadMigratePolicies();
    }
    return this.mAppMigrateInfoMap;
  }

  /**
   *  根据bundleName判断是不是企业应用 true 是企业 false 不存在企业
   * @param bundleName
   * @returns
   */
  public isEnterpriseApp(bundleName: string): boolean {
    if (this.mAppMigrateInfoMap.size === 0) {
      this.loadMigratePolicies();
    }
    return this.getMigrateByBundleAndType(bundleName, AppReserveType.ENTERPRISE) !== undefined;
  }

  /**
   *  根据bundleName判断是不是尝鲜应用业
   * @param bundleName
   * @returns
   */
  public isTasteFreshApp(bundleName: string): boolean {
    if (this.mAppMigrateInfoMap.size === 0) {
      this.loadMigratePolicies();
    }
    return this.getMigrateByBundleAndType(bundleName, AppReserveType.TASTE_FRESH) !== undefined;
  }

  /**
   *  根据bundleName判断是不是克隆应用应用
   * @param bundleName
   * @returns
   */
  public isdeliverApp(bundleName: string): boolean {
    if (this.mAppMigrateInfoMap.size === 0) {
      this.loadMigratePolicies();
    }
    return this.getMigrateByBundleAndType(bundleName, AppReserveType.DELIVER_TONG) !== undefined;
  }

  /**
   *  根据bundleName判断是不是应用应用
   * @param bundleName
   * @returns
   */
  public isEasyAboardApp(bundleName: string): boolean {
    if (this.mAppMigrateInfoMap.size === 0) {
      this.loadMigratePolicies();
    }
    return this.getMigrateByBundleAndType(bundleName, AppReserveType.EASYA_BROAD) !== undefined;
  }

  /**
   *  根据bundleName判断是不是兜底入克隆应用应用
   * @param bundleName
   * @returns
   */
  public isOtherdeliverApp(bundleName: string): boolean {
    if (this.mAppMigrateInfoMap.size === 0) {
      this.loadMigratePolicies();
    }
    return this.getMigrateByBundleAndType(bundleName, AppReserveType.OTHER_DELIVER) !== undefined;
  }

  /**
   *  根据bundleName判断和类型判拿到本地映射文件
   * @param bundleName  应用包名
   * @param type 类型 2 应用市场尝鲜应用  1 企业应用 0 三方应用
   * @returns
   */
  public getMigrateByBundleAndType(bundleName: string, type: number): LocalHapMigrateInfo | undefined {
    if (this.mAppMigrateInfoMap.size === 0) {
      this.loadMigratePolicies();
    }
    return this.mAppMigrateInfoMap.get(bundleName + type);
  }

  public releaseHapMigrateInfos(): void {
    this.mAppMigrateInfos = [];
    this.mAppMigrateInfoMap.clear();
  }

  private loadMigratePolicies(): void {
    this.mAppMigrateInfos = [];
    this.mAppMigrateInfoMap.clear();
    this.loadMigratePolicy(THIRD_APP_MIGRATE_POLICY);
    this.loadMigratePolicy(AG_APP_MIGRATE_POLICY);
    if (this.isNeedLoadEnterpirsePolicy) {
      this.loadMigratePolicy(ENTERPRISE_APP_MIGRATE_POLICY);
    }
    for (let i = 0; i < this.mAppMigrateInfos.length; i++) {
      this.mAppMigrateInfoMap.set(this.mAppMigrateInfos[i].source + this.mAppMigrateInfos[i].type,
        this.mAppMigrateInfos[i]);
    }
  }

  private getFileString(fileName: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(this.filesDir)) {
      log.showWarn(TAG, 'getFileString fileDir is empty');
      return '';
    }
    let filePath: string = this.filesDir + fileName;
    if (!FileUtils.isExist(filePath)) {
      log.showWarn(TAG, `getFileString filePath not exist: ${fileName}`);
      return '';
    }
    let config: string = '';
    try {
      config = fs.readTextSync(filePath);
    } catch (error) {
      log.error(TAG, 'getFileString error', error);
    }
    return config;
  }

  private loadMigratePolicy(fileName: string): void {
    let config: string = this.getFileString(fileName);
    if (CheckEmptyUtils.checkStrIsEmpty(config)) {
      log.showWarn(TAG, `loadMigratePolicy config string empty: ${fileName}`);
      return;
    }
    let jsonArray: IJSonEnterpriseMigratePolicy[] = [];
    try {
      jsonArray = JSON.parse(config);
    } catch (error) {
      log.showError(TAG, 'parse json error,%{public}s error %{public}s ', fileName, error?.message);
      return;
    }
    if (!Array.isArray(jsonArray)) {
      log.showWarn(TAG, `loadMigratePolicy config string is not array: ${fileName}`);
      return;
    }
    for (const jsonEle of jsonArray) {
      let localHapMigrateInfo: LocalHapMigrateInfo = new LocalHapMigrateInfo(jsonEle);
      if (fileName === THIRD_APP_MIGRATE_POLICY && localHapMigrateInfo.isValid()) {
        localHapMigrateInfo.type = AppReserveType.THIRD;
        // 如果同时存在一对一和多对一的映射关系，优先读取多对一
        if (!CheckEmptyUtils.checkStrIsEmpty(localHapMigrateInfo.source) &&
        CheckEmptyUtils.isEmptyArr(localHapMigrateInfo.sourceModules)) {
          this.mAppMigrateInfos.push(localHapMigrateInfo);
          log.showInfo(TAG, `localHapMigrateInfo is ${JSON.stringify(localHapMigrateInfo)}`);
          continue;
        }
        for (let index = 0; index < localHapMigrateInfo.sources.length; index++) {
          jsonEle.sourceModule = localHapMigrateInfo.sources[index];
          let subLocalHapMigrateInfo: LocalHapMigrateInfo = new LocalHapMigrateInfo(jsonEle);
          subLocalHapMigrateInfo.type = AppReserveType.THIRD;
          this.mAppMigrateInfos.push(subLocalHapMigrateInfo);
          log.showInfo(TAG, `subLocalHapMigrateInfo is ${JSON.stringify(subLocalHapMigrateInfo)}`);
        }
      } else if (fileName === ENTERPRISE_APP_MIGRATE_POLICY && localHapMigrateInfo.isValid()) {
        localHapMigrateInfo.type = AppReserveType.ENTERPRISE;
        this.mAppMigrateInfos.push(localHapMigrateInfo);
      } else if (fileName === AG_APP_MIGRATE_POLICY && !CheckEmptyUtils.checkStrIsEmpty(localHapMigrateInfo.sourceModule)) {
        this.mAppMigrateInfos.push(localHapMigrateInfo);
        // 如果ag_module_migrate_policy.json配置文件中存在企业应用，则不需要再加载enterprise_module_migrate_policy.json
        if (this.isNeedLoadEnterpirsePolicy && localHapMigrateInfo.type === AppReserveType.ENTERPRISE) {
          this.isNeedLoadEnterpirsePolicy = false;
        }
      }
      log.showInfo(TAG, `localHapMigrateInfo is ${JSON.stringify(localHapMigrateInfo)}`);
    }
  }

  public getPackageInfosForUserId(userId: number): Array<PackageInfo> {
    if (CheckEmptyUtils.isEmpty(this.mPackageInfos)) {
      this.mPackageInfos = new Map();
    }
    if (this.mPackageInfos.size === 0) {
      this.loadPackageInfos(APP_LIST);
    }
    return this.mPackageInfos.get(userId) ?? [];
  }

  public getPackageInfoByUserIdAndBundleName(userId: number, packageName: string): PackageInfo | undefined {
    if (CheckEmptyUtils.isEmpty(this.mPackageInfos)) {
      this.mPackageInfos = new Map();
    }
    if (this.mPackageInfos.size === 0) {
      this.loadPackageInfos(APP_LIST);
    }
    let packageInfoArray: PackageInfo[] = this.mPackageInfos.get(userId) ?? [];
    return packageInfoArray.find(item => item.packageName === packageName);
  }

  public getTwinAppPackageInfoByBundleName(packageName: string): PackageInfo | undefined {
    if (CheckEmptyUtils.isEmpty(this.mPackageInfos)) {
      this.mPackageInfos = new Map();
    }
    if (this.mPackageInfos.size === 0) {
      this.loadPackageInfos(APP_LIST);
    }
    for (let userId of this.mPackageInfos.keys()) {
      if (this.isClonedProfile(userId)) {
        let packageInfoArray: PackageInfo[] = this.mPackageInfos.get(userId) ?? [];
        return packageInfoArray.find(item => item.packageName === packageName);
      }
    }
    return undefined;
  }

  public releasePackageInfos(): void {
    this.mPackageInfos.clear();
  }

  private loadPackageInfos(fileName: string): void {
    let config: string = this.getFileString(fileName);
    if (CheckEmptyUtils.checkStrIsEmpty(config)) {
      log.showWarn(TAG, `loadApkInfos config string empty: ${fileName}`);
      return;
    }
    let jsonArray: IJSonApps[] = [];
    try {
      jsonArray = JSON.parse(config);
    } catch (error) {
      log.showError(TAG, 'parse json error,%{public}s error %{public}s ', fileName, error?.message);
      return;
    }
    if (!Array.isArray(jsonArray)) {
      log.showWarn(TAG, `loadApkInfos config string is not array: ${fileName}`);
      return;
    }
    for (const jsonEle of jsonArray) {
      let user: number = Number(jsonEle?.userId);
      if (Number.isNaN(user)) {
        continue;
      }
      let jsonAppList = jsonEle?.appList;
      if (!Array.isArray(jsonAppList)) {
        continue;
      }
      let packageList: Array<PackageInfo> = [];
      for (const pkgEle of jsonAppList) {
        let packageInfo = new PackageInfo(pkgEle);
        if (packageInfo.isValid()) {
          packageList.push(packageInfo);
        }
      }
      this.mPackageInfos.set(this.getAccountIdFromUserId(user), packageList);
    }
  }

  /**
   *  加载应用虚拟机内应用清单
   */
  public loadAbroadPackageInfos(): void {
    let config: string = this.getFileString(ABROAD_APP_LIST);
    if (CheckEmptyUtils.checkStrIsEmpty(config)) {
      log.showWarn(TAG, `loadApkInfos config string empty: ${ABROAD_APP_LIST}`);
      return;
    }
    let jsonObject: IJSonAbroadApps;
    try {
      jsonObject = JSON.parse(config);
    } catch (error) {
      log.showError(TAG, 'parse json error,%{public}s error %{public}s ', ABROAD_APP_LIST, error?.message);
      return;
    }
    let jsonAppList: AbroadPackageInfo[] = jsonObject?.abroadAppList;
    if (!Array.isArray(jsonAppList)) {
      log.showError(TAG, 'parse json error, no abroadAppList in json');
      return;
    }
    for (const jsonEle of jsonAppList) {
      let packageInfo = new AbroadPackageInfo(jsonEle);
      if (packageInfo.isValid()) {
        this.mAbroadPackageInfos.push(packageInfo);
      }
    }
  }

  public getAbroadPackageInfo(): Array<AbroadPackageInfo> {
    if (this.mAbroadPackageInfos.length === 0) {
      this.loadAbroadPackageInfos();
    }
    return this.mAbroadPackageInfos;
  }

  private isClonedProfile(userId: number): boolean {
    return (userId >= CLONEDPROFILE_USER_ID_MIN) && (userId < CLONEDPROFILE_USER_ID_MAX);
  }

  private getAccountIdFromUserId(userId: number): number {
    if (userId === 0) {
      return MAIN_USER_ID;
    }
    if (this.isClonedProfile(userId)) {
      return userId;
    }
    return SUB_USER_ID_GAP + userId;
  }

  /**
   * 加载设备桌面隐藏图标应用列表
   * @returns
   */
  public async loadHideIconAppList(): Promise<void> {
    log.showInfo(TAG, 'start loadHideIconAppList from CCM');
    try {
      const cfgFilePaths = await ConfigParseUtil.getAllConfig(INSTALL_LIST_CONFIG_PATH);
      log.showInfo(TAG, 'Succeeded in obtaining the CCM file, cfgFilePaths.length %{public}d', cfgFilePaths.length);
      for (const filePath of cfgFilePaths) {
        this.dealWithCfgConfig(filePath);
      }
    } catch (error) {
      log.error(TAG, 'loadHideIconAppList from CCM error', error?.message);
    }
    log.showWarn(TAG, `loadHideIconAppList size: ${TransformAppInfoManager.sHideIconAppList.size}`);
  }

  /**
   * 加载设备隐私空间桌面不显示图标应用列表
   * @returns
   */
  public async loadDisallowedHapListInPrivateSpace(): Promise<void> {
    log.showInfo(TAG, 'start loadDisallowedHapListInPrivateSpace from CCM');
    try {
      const cfgFilePath = await ConfigParseUtil.getConfig(DISALLOWED_HAP_LIST_IN_PRIVATE_SPACE_CONFIG_PATH);
      const config: string = fs.readTextSync(cfgFilePath);
      if (CheckEmptyUtils.checkStrIsEmpty(config)) {
        log.showWarn(TAG, 'config content is empty');
        return;
      }
      let convertOptions: convertxml.ConvertOptions = {
        trim: false,
        declarationKey: '_declaration',
        instructionKey: '_instruction',
        attributesKey: '_attributes',
        textKey: '_text',
        cdataKey: '_cdata',
        doctypeKey: '_doctype',
        commentKey: '_comment',
        parentKey: '_parent',
        typeKey: '_type',
        nameKey: '_name',
        elementsKey: '_elements'
      };
      let convertXmlObj: convertxml.ConvertXML = new convertxml.ConvertXML();
      let resObj: CovertObject  = convertXmlObj.convertToJSObject(config, convertOptions) as CovertObject;
      let rootElements: CovertElementObject[] = this.findElementsByTag(resObj._elements, 'root');
      if (CheckEmptyUtils.isEmptyArr(rootElements)) {
        log.showWarn(TAG, 'Can not find root elements');
        return;
      }
      let disallowedInstallHapElements: CovertElementObject[] = this.findElementsByTag(rootElements, 'disallowed_install_hap');
      if (CheckEmptyUtils.isEmptyArr(disallowedInstallHapElements)) {
        log.showWarn(TAG, 'Can not find disallowedInstallHap elements');
        return;
      }
      for (let item of disallowedInstallHapElements) {
        if (item._name !== 'bundle_name') {
          continue;
        }
        item?._elements.forEach(nameItem => {
          TransformAppInfoManager.disallowedHapListInPrivateSpace.add(nameItem._text);
        });
      }
    } catch (error) {
      log.error(TAG, 'loadDisallowedHapListInPrivateSpace from CCM error', error?.message);
    } finally {
      log.showWarn(TAG, `loadDisallowedHapListInPrivateSpace size: ${TransformAppInfoManager.disallowedHapListInPrivateSpace.size}`);
    }
  }

  private findElementsByTag(elements: CovertElementObject[], findTag: String): CovertElementObject[] {
    if (!elements) {
      return [];
    }
    for (let i = 0; i < elements.length; i++) {
      if (elements[i]._name === findTag) {
        return elements[i]._elements;
      }
    }
    log.showInfo(TAG, 'Can not find it return null');
    return [];
  }

  private dealWithCfgConfig(filePath: string): void {
    try {
      let config: string = fs.readTextSync(filePath);
      if (CheckEmptyUtils.checkStrIsEmpty(config)) {
        log.showWarn(TAG, 'configuration content is empty');
        return;
      }
      let jsonConfig: IJSonInstalls;
      try {
        jsonConfig = JSON.parse(config);
      } catch (error) {
        log.showError(TAG, 'parse json error: %{public}s ', error?.message);
        return;
      }
      let jsonInstallList = jsonConfig?.install_list;
      if (!Array.isArray(jsonInstallList)) {
        log.showWarn(TAG, 'configuration content is not json array');
        return;
      }
      for (const jsonEle of jsonInstallList) {
        if (TransformAppInfoManager.sHideIconAppList.has(jsonEle.bundleName)) {
          jsonEle?.allowAppDesktopIconHide === true ?
          TransformAppInfoManager.sHideIconAppList.add(jsonEle.bundleName) :
          TransformAppInfoManager.sHideIconAppList.delete(jsonEle.bundleName);
        } else if (jsonEle?.allowAppDesktopIconHide === true) {
          TransformAppInfoManager.sHideIconAppList.add(jsonEle.bundleName);
        }
      }
    } catch (error) {
      log.showError(TAG, 'parse json  error %{public}s ', error?.message);
    }
  }
}

export interface IJsonInfo {
  privacyPolicyCode: string;
  userAgreementCode: string
}

export interface IJSonAppReservePolicy {
  appReservePolicy: string;
  isAutoMigrateApp: string;
  isAbroadAutoMigrateApp: string;
  isRgmSupport32: string;
  sunsetAppList: string;
}

export interface IJSonEnterpriseMigratePolicy {
  sourceModule: string;
  sourceModuleSignatures: string[];
  targetModule: string;
  targetModuleUrl: string;
}

export interface IJSonApps {
  userId: number;
  appList: PackageInfo[];
}

export interface IJSonAbroadApps {
  abroadAppList: AbroadPackageInfo[]
}

export interface IJSonInstalls {
  install_list: IJSonInstallApp[];
}

export interface IJSonInstallApp {
  bundleName: string;
  app_signature: string[];
  allowAppUsePrivilegeExtension: boolean;
  allowAppDesktopIconHide: boolean;
  allowAbilityExcludeFromMissions?: boolean;
  runningResourcesApply?: boolean;
  resourcesApply?: number[];
  allowCommonEvent: string[]
}

interface AttributesObject {
  version: string,
  encoding: string
}

interface CovertElementObject {
  _type: string,
  _name: string,
  _text: string,
  _elements: CovertElementObject[],
}

interface CovertObject {
  _declaration: AttributesObject,
  _elements: CovertElementObject[]
}