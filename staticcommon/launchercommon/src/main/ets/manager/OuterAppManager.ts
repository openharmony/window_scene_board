/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
  ArrayUtils,
  CheckEmptyUtils,
  FileUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  AppItemInfo,
  AppModel,
  CommonConstants,
  DeliverUtil,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  RdbStoreManager
} from '../TsIndex';
import { BusinessError, screenLock, systemDateTime } from '@kit.BasicServicesKit';
// import { appInfoManager } from '@kit.StoreKit';
import rdb from '@ohos.data.relationalStore';
import { AppBundleInfo, AppCategoryInfo, AppInfo } from '../bean/OuterAppNameList';
import { OuterAppNameListInfo } from '../bean/OuterAppNameList';
import { bundleManager } from '@kit.AbilityKit';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { connection } from '@kit.NetworkKit';
import { taskpool } from '@kit.ArkTS';
import systemparameter from '@ohos.systemParameterEnhance';
import { SmallFoldStyleUtil } from '../utils/SmallFoldStyleUtil';
import { launcherStatusUtil } from '@ohos/windowscene';
import { settingsDataManager } from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsDataManager';

const TAG: string = 'OuterAppManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
// 编辑模式APP分类文件路径
const APP_CATEGORIZE_PATH: string = '/sys_prod/etc/app_categorize/app_categorize.json';
// 精选应用 分类文件中的标签
const TOP_QUALITY_LABEL: string = 'topQualityPkgList';
// 实验应用 分类文件中的标签
const EXPERIMENTAL_LABEL: string = 'experimentalPkgList';
// 未适配外屏应用 分类文件中的标签
const BLOCKLIST_LABEL: string = 'blocklistPkg';
const VERSION_NAME = 'const.logsystem.versiontype';
// 元服务应用名特殊前缀
const ATOMIC_SERVICE_PRE_NAME = 'com.atomicservice.';
// 正常查询两小时限制毫秒数
const TWO_HOUR: number = 7200000;
// 异常查询半小时限制毫秒数
const THIRTY_MINUTES: number = 1800000;
const BETA_MODE: boolean = (systemparameter.getSync(VERSION_NAME, 'default') === 'beta');
const TOP_TAG: number = 35398;
const EXPERIMENT_TAG: number = 35399;
const BLOCK_TAG: number = 35397;
const DIMENSION_ID: number = 761;
// 是否开启外屏应用调试 key值
const DEBUG_OUTER_APP: string = 'debug.outer.app';

/**
 * 外屏菜单高度-0
 */
const OUTER_SHORTCUT_HEIGHT_0: number = 157;

/**
 * 外屏菜单高度-1
 */
const OUTER_SHORTCUT_HEIGHT_1: number = 90;

/**
 * 外屏菜单高度-2
 */
const OUTER_SHORTCUT_HEIGHT_2: number = 70;

/**
 * 外屏菜单高度-3
 */
const OUTER_SHORTCUT_HEIGHT_3: number = 140;

const OUTER_SHORTCUT_HEIGHT_LIST: number[] =
  [OUTER_SHORTCUT_HEIGHT_0, OUTER_SHORTCUT_HEIGHT_1, OUTER_SHORTCUT_HEIGHT_2, OUTER_SHORTCUT_HEIGHT_3];

/**
 * 外屏应用管理器
 */
export class OuterAppManager {
  private blockAppNameList: string[] = [];
  private topAppNameList: string[] = [];
  private experimentAppNameList: string[] = [];
  private appCategorize?: OuterAppNameListInfo;
  private mRefreshTime: number = 0;
  private static instance: OuterAppManager;
  private readonly mAppModel: AppModel;
  private isInExecution: boolean = false;
  private hasUnlocked: boolean = false;
  private restrictedTime: number = TWO_HOUR;
  // 是否正在查询ag接口去更新下载完成的应用名称
  private updateDownloadBundleNameStatus: boolean = false;
  // 安装完成应用之后 单线程查询ag接口.
  private updateDownloadBundleNameList: string[] = [];
  // 安装完成应用之后 单线程查询ag接口.之后callback
  private updateDownloadBundleNameCallBack?: UpdateDownloadBundleNameFunc;
  // 是否是模拟机
  private isEmulatorMode: boolean = false;
  // 是否开启外屏应用调试
  private isDebugMode: boolean = settingsDataManager.getValue(null, DEBUG_OUTER_APP, 'false') === 'true';
  private romBlockAppNameList: string[] = [];

  private constructor() {
    this.mAppModel = AppModel.getInstance();
    this.parseFileToAppCategorize(APP_CATEGORIZE_PATH);
    this.isEmulatorMode = DeviceHelper.isEmulator();
    settingsDataManager.registerKeyObserver(DEBUG_OUTER_APP, () => {
      this.isDebugMode = settingsDataManager.getValue(null, DEBUG_OUTER_APP, 'false') === 'true';
    });
    log.showWarn('registerUnlockTransitionCallback');
  }

  public static getInstance(): OuterAppManager {
    if (!OuterAppManager.instance) {
      OuterAppManager.instance = new OuterAppManager();
    }
    return OuterAppManager.instance;
  }

  /**
   * 设置单线程查询ag接口之后callback
   *
   * @param callBack 单线程查询ag接口之后的callback
   */
  public setUpdateDownloadBundleNameCallBack(callBack: UpdateDownloadBundleNameFunc): void {
    this.updateDownloadBundleNameCallBack = callBack;
  }

  /**
   * 查询单线程查询ag接口之后callback
   *
   * @returns 单线程查询ag接口之后的callback
   */
  public getUpdateDownloadBundleNameCallBack(): UpdateDownloadBundleNameFunc | undefined {
    return this.updateDownloadBundleNameCallBack;
  }

  /**
   * 解析json转换为AppCategorize
   *
   * @param filePatch 文件路径
   */
  public parseFileToAppCategorize(filePatch: string): void {
    // 分类文件不存在直接返回
    if (!FileUtils.isExist(filePatch)) {
      log.showInfo('xmlFile file not exist');
      return;
    }
    this.appCategorize = FileUtils.readJsonFile(filePatch);
  }

  /**
   * 更新应用名单
   */
  public async updateNameList(): Promise<void> {
    return;
  }

  private async categoryByTag(dbNameListMap: Map<string, string[]>): Promise<void> {
    connection.getAllNets((error: BusinessError, data: connection.NetHandle[]) => {
      if (error || CheckEmptyUtils.isEmptyArr(data) || !this.hasUnlocked) {
        // 未联网或未解锁过手机
        log.showInfo('categoryByTag not nets or no has unlocked');
        this.getGuaranteedDataByNotNet(dbNameListMap);
        this.isInExecution = false;
      } else {
        // 联网,查AG接口
        log.showInfo('categoryByTag has nets');
        this.asyncProcessingTag(dbNameListMap);
      }
      // 数据库中无数据,初始化保存数据
      if (dbNameListMap.get(TOP_QUALITY_LABEL)?.length === 0) {
        this.saveNameList();
      }
    });
  }

  /**
   * 未联网状态下获取保底数据
   *
   * @param dbNameListMap 数据库数据
   */
  private getGuaranteedDataByNotNet(dbNameListMap: Map<string, string[]>): void {
    // 内存中有数据,不继续查询
    if (this.topAppNameList.length !== 0) {
      log.showWarn('getGuaranteedDataByNotNet This memory already has data');
      return;
    }
    // 从rom或数据库中获取名单列表
    this.getMinimumGuaranteeNameList(dbNameListMap);
  }

  private asyncProcessingTag(dbNameListMap: Map<string, string[]>): void {
    // 获取全量应用名单
    let bundleNames: string[] = this.mAppModel.getAppList().map(item => item.bundleName);
    log.showInfo(`asyncProcessingTag start, length: ${bundleNames.length}`);
    bundleNames = bundleNames.filter(bundleName => !DeliverUtil.isSupportAppTypeInOut(bundleName));
    log.showInfo(`asyncProcessingTag filter isSupportAppTypeInOut end length: ${bundleNames.length}`);
    // taskpool.execute(asyncGetAppTagInfos, bundleNames).then((mTagInfosResult: Object) => {
    //   // let tagInfosResult = mTagInfosResult as appInfoManager.AppTagInfo[];
    //   // let isSaveNameList = true;
    //   // let appNameMap: Map<string, string[]> = this.getRomAppNameMap();
    //   // this.startCategory(tagInfosResult, appNameMap);
    //   // 如果精选应用列表为空,异常场景获取保底数据
    //   if (this.topAppNameList.length === 0) {
    //     log.showInfo('topAppNameList is empty');
    //     this.getMinimumGuaranteeNameList(dbNameListMap);
    //     isSaveNameList = false;
    //   }
    //   // 异常场景不保存数据至数据库, 数据库无数据时，必存一份保底
    //   if (isSaveNameList || dbNameListMap.get(TOP_QUALITY_LABEL)?.length === 0) {
    //     // 记录正常获取应用名单的时间戳
    //     this.mRefreshTime = systemDateTime.getTime();
    //     this.restrictedTime = TWO_HOUR;
    //     this.saveNameList();
    //   }
    // }).catch((error: Error) => {
    //   log.showWarn(`getAppTagInfos error: ${error}`);
    //   this.restrictedTime = THIRTY_MINUTES;
    //   if (this.topAppNameList.length !== 0) {
    //     log.showInfo('topAppNameList not is empty,no minimum data is required');
    //     return;
    //   }
    //   this.getMinimumGuaranteeNameList(dbNameListMap);
    // }).finally(() => {
    //   log.showWarn(`asyncProcessingTag end`);
    //   this.isInExecution = false;
    // });
  }

  /**
   * 获取预置分类名单map
   *
   * @returns 预置分类名单map
   */
  private getRomAppNameMap(): Map<string, string[]> {
    let appNameMap: Map<string, string[]> = new Map();
    appNameMap.set(BLOCKLIST_LABEL, this.getBlockPkgNameList());
    appNameMap.set(TOP_QUALITY_LABEL, this.getTopPkgNameList());
    appNameMap.set(EXPERIMENTAL_LABEL, this.getExperimentalPkgNameList());
    return appNameMap;
  }

  /**
   * 根据下载的应用新增分类数据
   *
   * @param bundleName 新下载的应用包名
   */
  public async updateNameListByDownload(bundleName: string | null, fromDealFunc: boolean = false): Promise<void> {
    log.showInfo(`updateNameListByDownload start ${bundleName}`);
    if (!bundleName) {
      log.showError('updateNameListByDownload bundleName is empty or product error');
      if (fromDealFunc) {
        this.dealDownloadBundleNameList();
      } else if (this.updateDownloadBundleNameCallBack !== undefined) {
        this.updateDownloadBundleNameCallBack?.(bundleName ?? '');
      }
      return;
    }
    try {
      // 判断是否联网, 未联网直接return
      if (CheckEmptyUtils.isEmptyArr(connection.getAllNetsSync())) {
        log.showInfo('updateNameListByDownload not net');
        if (fromDealFunc) {
          this.dealDownloadBundleNameList();
        } else if (this.updateDownloadBundleNameCallBack !== undefined) {
          this.updateDownloadBundleNameCallBack?.(bundleName);
        }
        return;
      }
      // 判断当前是否正常查询ag接口
      if (this.updateDownloadBundleNameStatus) {
        this.updateDownloadBundleNameList.push(bundleName);
        log.showInfo(`updateNameListByDownload updateDownloadBundleNameStatus true, push ${bundleName} in list`);
        return;
      }
      this.updateDownloadBundleNameStatus = true;
      try {
        if (DeliverUtil.isSupportAppTypeInOut(bundleName)) {
          log.showWarn('asyncGetAppTagInfosByDownLoad isSupportAppTypeInOut is deliver app type');
          bundleName = null;
        }
      } catch (error) {
        log.showError(`isSupportAppTypeInOut error, code: ${error?.code}, message: ${error?.message}`);
      }
      // taskpool.execute(asyncGetAppTagInfosByDownLoad, bundleName ?? '').then((mtagInfosResult: Object) => {
      //   // let tagInfosResult: appInfoManager.AppTagInfo[] = mtagInfosResult as appInfoManager.AppTagInfo[];
      //   // let appNameMap: Map<string, string[]> = new Map();
      //   // appNameMap.set(BLOCKLIST_LABEL, this.blockAppNameList);
      //   // appNameMap.set(TOP_QUALITY_LABEL, this.topAppNameList);
      //   // appNameMap.set(EXPERIMENTAL_LABEL, this.experimentAppNameList);
      //   // this.startCategory(tagInfosResult, appNameMap);
      // }).catch((error: Error) => {
      //   log.showWarn(`asyncGetAppTagInfosByDownLoad error: ${error}`);
      // }).finally(() => {
      //   log.showWarn(`asyncGetAppTagInfosByDownLoad end`);
      //   if (this.updateDownloadBundleNameCallBack !== undefined && !CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      //     this.updateDownloadBundleNameCallBack?.(bundleName ?? '');
      //   }
      //   this.updateDownloadBundleNameStatus = false;
      //   this.dealDownloadBundleNameList();
      // });
    } catch (err) {
      log.showError(`updateNameListByDownload err: ${err.message}`);
    }
    return;
  }

  private async dealDownloadBundleNameList(): Promise<void> {
    log.showInfo('dealDownloadBundleNameList start');
    if (!CheckEmptyUtils.isEmptyArr(this.updateDownloadBundleNameList)) {
      let bundleName = this.updateDownloadBundleNameList.shift();
      log.showInfo(`dealDownloadBundleNameList bundleName: ${bundleName}`);
      this.updateNameListByDownload(bundleName ?? '', true);
    }
  }

  /**
   * 查询数据库，之后更新列表
   * @param bundleNames
   * @param callback
   */
  public async getNameListCallBack(callback?: Function): Promise<void> {
    if (this.topAppNameList.length === 0) {
      log.showInfo('getNameListCallBack topAppNameList is empty');
      let dbNameListMap: Map<string, string[]> = await this.getAllNameListByDB();
      if (!dbNameListMap.get(TOP_QUALITY_LABEL) || dbNameListMap.get(TOP_QUALITY_LABEL)?.length === 0) {
        log.showError('getNameListCallBack getAllNameListByDB is empty');
        callback?.(new Map([
          [BLOCKLIST_LABEL, this.getBlockPkgNameList()],
          [TOP_QUALITY_LABEL, this.getTopPkgNameList()],
          [EXPERIMENTAL_LABEL, this.getExperimentalPkgNameList()]
        ]));
      } else {
        callback?.(dbNameListMap);
      }
    } else {
      log.showInfo('getNameListCallBack topAppNameList is exist');
      let nameListMap: Map<string, string[]> = new Map([
        [BLOCKLIST_LABEL, this.blockAppNameList],
        [TOP_QUALITY_LABEL, this.topAppNameList],
        [EXPERIMENTAL_LABEL, this.experimentAppNameList]
      ]);
      callback?.(nameListMap);
    }
    this.updateNameList();
  }

  /**
   * 获取数据有误的情况下调用, 获取保底列表
   *
   * @returns 数据库中是否有数据
   */
  private getMinimumGuaranteeNameList(dbNameListMap: Map<string, string[]>): void {
    // 数据库中数据有误或暂未存入数据库中,从rom取数据
    let appNameMap: Map<string, string[]> = new Map();
    if (!dbNameListMap.get(TOP_QUALITY_LABEL) || dbNameListMap.get(TOP_QUALITY_LABEL)?.length === 0) {
      log.showWarn(`getMinimumGuaranteeNameList by init`);
      this.setAppNameMap(appNameMap);
    } else {
      log.showWarn(`getMinimumGuaranteeNameList by db`);
      this.setAppNameMap(appNameMap, dbNameListMap);
    }
    this.setNameListByMap(appNameMap);
  }

  /**
   * 设置名单map
   *
   * @param appNameMap 名单map对象
   * @param dbNameListMap 数据库名单列表, 如果为空设置rom名单
   */
  private setAppNameMap(appNameMap: Map<string, string[]>, dbNameListMap?: Map<string, string[]>): void {
    if (!dbNameListMap) {
      appNameMap.set(TOP_QUALITY_LABEL, this.getTopPkgNameList());
      appNameMap.set(EXPERIMENTAL_LABEL, this.getExperimentalPkgNameList());
      appNameMap.set(BLOCKLIST_LABEL, this.getBlockPkgNameList());
    } else {
      appNameMap.set(TOP_QUALITY_LABEL, dbNameListMap.get(TOP_QUALITY_LABEL) ?? []);
      appNameMap.set(EXPERIMENTAL_LABEL, dbNameListMap.get(EXPERIMENTAL_LABEL) ?? []);
      appNameMap.set(BLOCKLIST_LABEL, dbNameListMap.get(BLOCKLIST_LABEL) ?? []);
    }
  }

  private async saveNameList(): Promise<void> {
    try {
      let bucketList: Array<rdb.ValuesBucket> = new Array();
      this.pushNameListToBucketList(bucketList, this.topAppNameList, TOP_QUALITY_LABEL);
      this.pushNameListToBucketList(bucketList, this.experimentAppNameList, EXPERIMENTAL_LABEL);
      this.pushNameListToBucketList(bucketList, this.blockAppNameList, BLOCKLIST_LABEL);
      await RdbStoreManager.getInstance().insertOuterAppCategorizeData(bucketList);
      log.showInfo(`saveNameList successful`);
    } catch (err) {
      log.showError(`saveNameList error: ${err.message}`);
    }
  }

  private async getAllNameListByDB(): Promise<Map<string, string[]>> {
    try {
      return await RdbStoreManager.getInstance().queryOuterAllAppCategorize();
    } catch (err) {
      log.showError(`getNameListByDB error: ${err.message}`);
    }
    return new Map<string, string[]>();
  }

  private pushNameListToBucketList(bucketList: Array<rdb.ValuesBucket>, nameList: string[], key: string): void {
    nameList.forEach(item => {
      let bucket: rdb.ValuesBucket = {
        'bundle_name': item,
        'category': key
      };
      bucketList.push(bucket);
    });
  }

  // private startCategory(tagInfosResult: appInfoManager.AppTagInfo[], appNameMap: Map<string, string[]>): void {
  //   if (!tagInfosResult || tagInfosResult.length === 0) {
  //     log.showWarn('isSupportOuter app not has tag');
  //     return;
  //   }
  //   log.showInfo(`isSupportOuter tagInfosResult: ${JSON.stringify(tagInfosResult)}`);
  //   for (let item of tagInfosResult) {
  //     if (CheckEmptyUtils.isEmpty(item) || CheckEmptyUtils.isEmpty(item.appQueryCode) ||
  //       CheckEmptyUtils.isEmpty(item.tags) || CheckEmptyUtils.isEmpty(item.bundleName)) {
  //       log.showWarn('startCategory item is empty');
  //       continue;
  //     }
  //     if (item.appQueryCode !== appInfoManager.QueryCode.SUCCESS) {
  //       log.showWarn(`${item.bundleName} query tag error`);
  //       continue;
  //     }
  //     log.showInfo('isSupportOuter success');
  //     for (let i = 0; i < item.tags.length; i++) {
  //       if (CheckEmptyUtils.isEmpty(item.tags[i])) {
  //         log.showWarn('startCategory item.tag is empty');
  //         continue;
  //       }
  //       let tagId: number = item.tags[i].tagId;
  //       log.showInfo(`item ${item.bundleName} tagId: ${tagId}`);
  //       switch (tagId) {
  //         case TOP_TAG:
  //           this.updateNameListByTag(appNameMap, TOP_QUALITY_LABEL, item.bundleName);
  //           break;
  //         case EXPERIMENT_TAG:
  //           this.updateNameListByTag(appNameMap, EXPERIMENTAL_LABEL, item.bundleName);
  //           break;
  //         case BLOCK_TAG:
  //           this.updateBlockNameList(appNameMap, BLOCKLIST_LABEL, item.bundleName);
  //           break;
  //         default:
  //           break;
  //       }
  //     }
  //   }
  //   this.setNameListByMap(appNameMap);
  // }

  private updateBlockNameList(appNameMap: Map<string, string[]>, mapKey: string, bundleName: string): void {
    if (!this.isOpenVersion()) {
      this.updateNameListByTag(appNameMap, mapKey, bundleName);
    }
  }

  private setNameListByMap(appNameMap: Map<string, string[]>): void {
    this.blockAppNameList = appNameMap.get(BLOCKLIST_LABEL) ?? [];
    this.topAppNameList = appNameMap.get(TOP_QUALITY_LABEL) ?? [];
    this.experimentAppNameList = appNameMap.get(EXPERIMENTAL_LABEL) ?? [];
  }

  /**
   * 判断应用是否是未适配应用
   *
   * @param bundleName 应用包名
   */
  private judgeAppIsBlock(bundleName: string, blockNameList?: string[]): boolean {
    let applicationInfo: bundleManager.ApplicationInfo | undefined;
    let appItemInfo: AppItemInfo | undefined;
    try {
      // 存在于未适配列表 是未适配应用
      let blockAppNameList: string[] = blockNameList ?? this.getBlockPkgNameListByTag();
      if (blockAppNameList.includes(bundleName)) {
        return true;
      }

      appItemInfo = AppModel.getInstance().getAppInfoByBundleName(bundleName);
      let isSystemApp: Boolean;
      let bundleType: number;
      if (!appItemInfo || appItemInfo.isSystemApp === undefined ||
        appItemInfo.bundleType === undefined) {
        log.showInfo(`judgeAppIsBlock: appItemInfo undefined, load ${bundleName} attribute from bundleManager`);
        applicationInfo = bundleManager.getApplicationInfoSync(bundleName, bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
        isSystemApp = applicationInfo.systemApp;
        bundleType = applicationInfo.bundleType;
      } else {
        log.showInfo(`judgeAppIsBlock: load ${bundleName} attribute from AppModel`);
        isSystemApp = appItemInfo.isSystemApp;
        bundleType = appItemInfo.bundleType;
      }
      // 所有元服务不适配
      if (bundleType === bundleManager.BundleType.ATOMIC_SERVICE) {
        log.showInfo(`Outer atomic service ${bundleName} not suitable.`);
        return true;
      }

      // 三方应用, 不存在于白名单列表是未适配应用(非开放名单版本)
      if (!this.isOpenVersion(true) &&
        !isSystemApp &&
        !this.topAppNameList.includes(bundleName) &&
        !this.experimentAppNameList.includes(bundleName)) {
        return true;
      }
    } catch (err) {
      log.showError(`${bundleName} getApplicationInfo error: ${err.message}`);
      return true;
    }

    // 当前元服务首次打开需先安装，安装完成前获取applicationInfo可能会报错。临时使用bundleName进行应用类型判断
    if ((applicationInfo === undefined) && (appItemInfo === undefined) && bundleName.startsWith(ATOMIC_SERVICE_PRE_NAME)) {
      log.showInfo(`Outer atomic service ${bundleName} not suitable.`);
      return true;
    }
    return false;
  }

  /**
   * 开放名单版本判断(三方应用不受管控)
   *
   * @param judgingDebug 是否判断'外屏应用调试'开关
   * @returns 是否是开放名单版本
   */
  public isOpenVersion(judgingDebug?: boolean): boolean {
    let isOpen: boolean = BETA_MODE || this.isEmulatorMode;
    if (judgingDebug) {
      isOpen = isOpen || this.isDebugMode;
    }
    return isOpen;
  }

  /**
   * 判断应用是否是精选应用
   *
   * @param bundleName 应用包名
   */
  private judgeAppIsTop(bundleName: string): boolean {
    try {
      // 存在于精选应用列表 是精选应用
      if (this.topAppNameList.includes(bundleName)) {
        return true;
      }
      // 自研应用, 不存在于未适配应用列表和实验应用列表是精选应用
      let appItemInfo: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(bundleName);
      let isSystemApp: Boolean;
      if (!appItemInfo || appItemInfo.isSystemApp === undefined) {
        log.showInfo(`judgeAppIsTop: appItemInfo undefined, load ${bundleName} attribute from bundleManager`);
        let applicationInfo = bundleManager
          .getApplicationInfoSync(bundleName, bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
        isSystemApp = applicationInfo.systemApp;
      } else {
        log.showInfo(`judgeAppIsTop: load ${bundleName} attribute from AppModel`);
        isSystemApp = appItemInfo.isSystemApp;
      }
      if (isSystemApp && !this.getBlockPkgNameListByTag().includes(bundleName) &&
        !this.experimentAppNameList.includes(bundleName)) {
        return true;
      }
    } catch (err) {
      log.showError(`${bundleName} getApplicationInfo error: ${err.message}`);
    }
    return false;
  }

  private updateNameListByTag(appNameMap: Map<string, string[]>, mapKey: string, bundleName: string): void {
    appNameMap.forEach((value: string[], key: string) => {
      if (mapKey === key) {
        this.pushByNoExist(value, bundleName);
      } else {
        ArrayUtils.deleteArr(value, bundleName);
      }
    });
  }

  private pushByNoExist(appNameList: string[], bundleName: string): void {
    if (appNameList.indexOf(bundleName) === -1) {
      appNameList.push(bundleName);
    }
  }

  /**
   * 是否需要更新数据
   *
   * @param refreshTime 上次刷新的时间
   * @param thresholdTime 限制时间
   * @returns 是否需要刷新
   */
  private isNeedRefresh(refreshTime: number, thresholdTime: number): boolean {
    let current: number = systemDateTime.getTime();
    let isIntervalDaysExceedsThreshold: boolean = (current - refreshTime) >
    thresholdTime;
    return isIntervalDaysExceedsThreshold;
  }

  /**
   * 获得预置未适配外屏应用包名集合
   *
   * @returns 未适配外屏应用包名集合
   */
  public getBlockPkgNameList(): string[] {
    if (CheckEmptyUtils.isEmptyArr(this.romBlockAppNameList) &&
      this.appCategorize &&
      !CheckEmptyUtils.isEmpty(this.appCategorize.blocklistPkg)) {
      this.romBlockAppNameList = this.appCategorize.blocklistPkg.map(item => item.bundleName);
    }
    return [...this.romBlockAppNameList];
  }

  /**
   * 获得预置精选应用包名集合
   *
   * @returns 预置精选应用包名集合
   */
  public getTopPkgNameList(): string[] {
    if (!this.appCategorize || CheckEmptyUtils.isEmpty(this.appCategorize.topQualityPkgList)) {
      return [];
    }
    return this.appCategorize.topQualityPkgList.map(item => item.bundleName);
  }

  /**
   * 获得预置实验应用包名集合
   *
   * @returns 预置精选应用包名集合
   */
  public getExperimentalPkgNameList(): string[] {
    if (!this.appCategorize || CheckEmptyUtils.isEmpty(this.appCategorize.experimentalPkgList)) {
      return [];
    }
    return this.appCategorize.experimentalPkgList.map(item => item.bundleName);
  }

  /**
   * 获得特殊应用包名集合
   *
   * @returns 特殊应用包名集合
   */
  public getSpecialApplicationPkgList(): string[] {
    if (!this.appCategorize || CheckEmptyUtils.isEmpty(this.appCategorize.outerAppStartupAddIconBlocklist)) {
      return [];
    }
    return this.appCategorize.outerAppStartupAddIconBlocklist.map(item => item.bundleName);
  }

  /**
   * 获得内外屏接续应用集合
   *
   * @returns 内外屏接续应用集合
   */
  public getOuterScreenFollowPkgList(): string[] {
    if (!this.appCategorize || CheckEmptyUtils.isEmpty(this.appCategorize.outerScreenFollowPkgList)) {
      return [];
    }
    return this.appCategorize.outerScreenFollowPkgList.map(item => item.bundleName);
  }

  /**
   * 获得受信任卡片集合
   *
   * @returns 受信任卡片集合
   */
  public getTrustedCardPkg(): string[] {
    if (!this.appCategorize || CheckEmptyUtils.isEmpty(this.appCategorize.trustedCardPkg)) {
      return [];
    }
    return this.appCategorize.trustedCardPkg.map(item => item.bundleName);
  }

  /**
   * 获得根据应用Tag更新后的未适配外屏应用包名集合
   *
   * @returns 根据应用Tag更新后的未适配外屏应用包名集合
   */
  public getBlockPkgNameListByTag(): string[] {
    this.updateNameList();
    if (this.isDebugMode) {
      return this.getBlockPkgNameList();
    }
    return [...this.blockAppNameList];
  }

  /**
   * 判断应用或ability是否是未适配应用
   *
   * @param bundleName 包名
   * @param abilityName ability名
   * @param isAddToOutDeskTop 是否是判断能否添加至外屏桌面的场景
   * @returns 是否是未适配应用
   */
  public isBlockApp(bundleName: string, abilityName?: string, isAddToOutDeskTop: boolean = false): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn('isBlockApp bundleName is empty');
      return false;
    }
    // 判断ability是否是未适配应用
    if (abilityName && !CheckEmptyUtils.checkStrIsEmpty(abilityName)) {
      let abilityNameIsBlock: boolean = this.abilityNameIsBlock(bundleName, abilityName);
      if (abilityNameIsBlock) {
        log.showWarn(`isBlockApp ${bundleName} and ${abilityName} is unsupported`);
        return true;
      }
    }
    // 说明是已添加至外屏的应用不影响用户使用
    if (!isAddToOutDeskTop && this.appIsInOuter(bundleName)) {
      log.showWarn(`isBlockApp ${bundleName} was added to outer screen`);
      return false;
    }
    // 此类型应用判断为未适配
    if (DeliverUtil.isSupportAppTypeInOut(bundleName)) {
      log.showWarn(`isBlockApp ${bundleName} is deliver app type`);
      return true;
    }
    // 判断应用是否是未适配应用
    let ret: boolean = this.judgeAppIsBlock(bundleName);
    log.showInfo(`isBlockApp ${bundleName} ret = ${ret}`);
    return ret;
  }

  /**
   * 判断多个应用或ability是否是未适配应用
   *
   * @param bundleNames json解析后的包名字符串
   * @returns json解析后的列表
   */
  public isBlockApps(bundleNames: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleNames)) {
      log.showWarn('isBlockApp bundleName is empty');
      return '';
    }
    let appBundleInfos: AppBundleInfo[] = [];
    try {
      appBundleInfos = JSON.parse(bundleNames);
      // 如果Json解析为空，则直接返回空字符串
      let isOuterList: AppInfo[] = [];
      let outerList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getOuterList();
      let blockAppNameList: string[] = this.getBlockPkgNameListByTag();
      appBundleInfos.forEach(bundleInfo => {
        if (CheckEmptyUtils.isEmpty(bundleInfo) || CheckEmptyUtils.isEmpty(bundleInfo.bundleName)) {
          log.showWarn('isBlockApps info or bundleName is empty');
          return;
        }
        let appInfo = new AppInfo();
        appInfo.bundleName = bundleInfo.bundleName;
        // 已添加至外屏的应用不影响用户使用
        if (this.appIsInOuter(appInfo.bundleName, outerList)) {
          appInfo.appIsOuterSupport = true;
          this.checkAppInfoAbilityNames(bundleInfo, appInfo);
        } else if (DeliverUtil.isSupportAppTypeInOut(appInfo.bundleName)) {
          // 鸿蒙OS
          appInfo.appIsOuterSupport = false;
          this.checkAppInfoAbilityNames(bundleInfo, appInfo, false);
        } else {
          appInfo.appIsOuterSupport = !this.judgeAppIsBlock(appInfo.bundleName, blockAppNameList);
          this.checkAppInfoAbilityNames(bundleInfo, appInfo, appInfo.appIsOuterSupport);
        }
        isOuterList.push(appInfo);
      });
      return JSON.stringify(isOuterList);
    } catch (err) {
      log.showError(`isBlockApps error: ${err.message}`);
      return '';
    }
  }

  private appIsInOuter(bundleName: string, outerList?: GridLayoutItemInfo[]): boolean {
    if (CheckEmptyUtils.isEmpty(outerList)) {
      outerList = LaunchLayoutCacheManager.getInstance().getOuterList();
    }
    let outerApp: GridLayoutItemInfo | undefined =
      outerList?.find(item => !CheckEmptyUtils.isEmpty(item) && item.bundleName === bundleName);
    return !CheckEmptyUtils.isEmpty(outerApp);
  }

  /**
   * 根据包名获取应用分类
   *
   * @param bundleNames json解析后的包名字符串
   * @returns json解析后的分类列表
   */
  public getAppCategory(bundleNames: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleNames)) {
      log.showWarn('isBlockApp bundleName is empty');
      return '';
    }
    let appBundleInfos: AppBundleInfo[] = [];
    try {
      appBundleInfos = JSON.parse(bundleNames);
      // 如果Json解析为空，则直接返回空字符串
      let appCategoryList: AppCategoryInfo[] = [];
      appBundleInfos.forEach(bundleInfo => {
        if (CheckEmptyUtils.isEmpty(bundleInfo) || CheckEmptyUtils.isEmpty(bundleInfo.bundleName)) {
          log.showWarn('getAppCategory info or bundleName is empty');
          return;
        }
        let appCategory = new AppCategoryInfo();
        appCategory.bundleName = bundleInfo.bundleName;

        if (this.isTopApp(appCategory.bundleName)) {
          appCategory.category = TOP_TAG;
        } else if (!this.isBlockApp(appCategory.bundleName, undefined, true)) {
          appCategory.category = EXPERIMENT_TAG;
        }
        appCategoryList.push(appCategory);
      });
      return JSON.stringify(appCategoryList);
    } catch (err) {
      log.showError(`getAppCategory error: ${err.message}`);
      return '';
    }
  }

  /**
   * 根据包名获取是否过滤卡片
   *
   * @param bundleNames json解析后的包名字符串
   * @returns json解析后的列表
   */
  public isFilterCardByJson(bundleNames: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleNames)) {
      log.showWarn('isBlockApp bundleName is empty');
      return '';
    }
    let appBundleInfos: AppBundleInfo[] = [];
    try {
      appBundleInfos = JSON.parse(bundleNames);
      // 如果Json解析为空，则直接返回空字符串
      let isOuterList: AppInfo[] = [];
      appBundleInfos.forEach(bundleInfo => {
        if (CheckEmptyUtils.isEmpty(bundleInfo) || CheckEmptyUtils.isEmpty(bundleInfo.bundleName)) {
          log.showWarn('isFilterCardByJson info or bundleName is empty');
          return;
        }
        let appInfo = new AppInfo();
        appInfo.bundleName = bundleInfo.bundleName;
        appInfo.appIsOuterSupport = !this.isFilterCard(bundleInfo.bundleName);
        isOuterList.push(appInfo);
      });
      return JSON.stringify(isOuterList);
    } catch (err) {
      log.showError(`isFilterCardByJson error: ${err.message}`);
      return '';
    }
  }

  /**
   * 是否过滤卡片
   *
   * @param bundleName 卡片包名
   * @returns 是否过滤卡片
   */
  public isFilterCard(bundleName: string, isFormCenter: boolean = false, isOuterHomeDisable: boolean = false): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn('isFilterCard bundleName is empty');
      return true;
    }
    // 外屏卡片过滤
    if (!isFormCenter || launcherStatusUtil.getShowOutLauncherStatus()) {
      if (isOuterHomeDisable) {
        return true;
      }
      return this.isBlockApp(bundleName, undefined, true) && !this.isTrustedCard(bundleName);
    }
    return false;
  }

  private checkAppInfoAbilityNames(appBundleInfo: AppBundleInfo, appInfo: AppInfo, appIsOuterSupport?: boolean): void {
    appBundleInfo.abilityNames.forEach(abilityName => {
      if (!CheckEmptyUtils.checkStrIsEmpty(abilityName)) {
        appInfo.abilityInfos.push({abilityName: abilityName,
          appIsOuterSupport: appIsOuterSupport === false ? false : !this.abilityNameIsBlock(appBundleInfo.bundleName, abilityName)});
      }
    });
  }

  /**
   * 判断是否为受信任的卡片
   *
   * @param bundleName 包名
   * @returns 是否是受信任的卡片
   */
  public isTrustedCard(bundleName: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn('isTrustedCard bundleName is empty');
      return false;
    }
    return this.getTrustedCardPkg().includes(bundleName);
  }

  private abilityNameIsBlock(bundleName: string, abilityName: string): boolean {
    let blockAbilityNames: string[] | undefined = SmallFoldStyleUtil.getMultitaskingFilterMap().get(bundleName);
    if (!blockAbilityNames || CheckEmptyUtils.isEmptyArr(blockAbilityNames)) {
      log.showWarn('abilityNameIsBlock blockAbilityNames is empty');
      return false;
    }
    return blockAbilityNames.includes(abilityName);
  }

  /**
   * 获取应用是否是精选应用
   *
   * @param bundleName bundleName
   * @returns
   */
  public isTopApp(bundleName: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn('isTopApp bundleName is empty');
      return false;
    }
    return this.judgeAppIsTop(bundleName);
  }

  /**
   * 获取根据tag更新后的精选应用包名集合
   *
   * @returns 根据应用Tag更新后的精选应用应用包名集合
   */
  public getTopPkgNameListByTag(): string[] {
    let topAppNameList: string[] = [...this.topAppNameList];
    this.updateNameList();
    return topAppNameList;
  }

  /**
   * 获取根据tag更新后的实验应用包名集合
   *
   * @returns 根据应用Tag更新后的实验应用包名集合
   */
  public getExperimentalPkgNameListByTag(): string[] {
    let experimentAppNameList: string[] = [...this.experimentAppNameList];
    this.updateNameList();
    return experimentAppNameList;
  }

  /**
   * 获取白名单应用列表
   *
   * @returns 根据应用Tag更新后的白名单应用列表
   */
  public getWhitelistByTag(): string[] {
    return this.getTopPkgNameListByTag().concat(this.getExperimentalPkgNameListByTag());
  }

  /**
   * 获得外屏shortcut菜单显示包名
   *
   * @returns 外屏shortcut菜单显示包名集合
   */
  public getOuterShowShortcutMenusAppList(): string[] {
    if (!this.appCategorize ||
      CheckEmptyUtils.isEmpty(this.appCategorize.outerShowShortcutMenusAppList)) {
      log.showInfo('getOuterShowShortcutMenusAppList list is empty');
      return [];
    }
    return this.appCategorize.outerShowShortcutMenusAppList.map(item => item.bundleName);
  }
}

// async function asyncGetAppTagInfosByDownLoad(bundleName: string): Promise<appInfoManager.AppTagInfo[]> {
//   'use concurrent';
//   const TAG = 'OuterAppManager';
//   const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
//   const DIMENSION_ID: number = 761;
//   let tagInfosResult: appInfoManager.AppTagInfo[] = [];
//   if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
//     log.showWarn('asyncGetAppTagInfosByDownLoad bundleName emp');
//     return tagInfosResult;
//   }
//   tagInfosResult = await appInfoManager.getAppTagInfos(DIMENSION_ID, [bundleName]);
//   log.showInfo('tagInfosResult: ' + tagInfosResult.length);
//   return tagInfosResult;
// }

// async function asyncGetAppTagInfos(bundleNames: string[]): Promise<appInfoManager.AppTagInfo[]> {
//   'use concurrent';
//   const TAG = 'OuterAppManager';
//   const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
//   const DIMENSION_ID: number = 761;
//   let tagInfosResult: appInfoManager.AppTagInfo[] = [];
//   if (CheckEmptyUtils.isEmptyArr(bundleNames)) {
//     log.showWarn('asyncGetAppTagInfos bundleNames emp');
//     return tagInfosResult;
//   }
//   tagInfosResult = await appInfoManager.getAppTagInfos(DIMENSION_ID, bundleNames);
//   log.showInfo('tagInfosResult: ' + tagInfosResult.length);
//   return tagInfosResult;
// }

// export function getOuterConstraintSizeOptions(appItem?: GridLayoutItemInfo): ConstraintSizeOptions {
//   if (!appItem) {
//     return { maxHeight: OUTER_SHORTCUT_HEIGHT_LIST[0] };
//   }
//   let outerList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().selectSameAppOuter(appItem.bundleName);
//   return { maxHeight: OUTER_SHORTCUT_HEIGHT_LIST[outerList[0]?.row ?? 0] };
// }

export type UpdateDownloadBundleNameFunc = (bundleName: string) => void;