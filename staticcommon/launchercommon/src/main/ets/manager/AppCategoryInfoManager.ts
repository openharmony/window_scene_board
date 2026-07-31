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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
// import { appInfoManager } from '@kit.StoreKit';
import { CommonConstants, RdbStoreManager } from '../TsIndex';
import { taskpool } from '@kit.ArkTS';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiDfxEventUtil';
import { AppCatErrorCode } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { EventManager, EvtBus, OobeActivatedEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { AppCategoryUtils } from '../utils/AppCategoryUtils';
import { UserUnlockedEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import osAccount from '@ohos.account.osAccount';
import { BusinessError } from '@ohos.base';
import DefaultDesktopLayoutInfo from '../configs/DefaultDesktopLayoutInfo';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import ConfigParseUtil from '../utils/ConfigParseUtil';
import { FileUtils } from '@ohos/basicutils';

const TAG = 'AppCategoryInfoManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 应用分类信息管理类
 */
export class AppCategoryInfoManager {
  private static instance: AppCategoryInfoManager;
  // 时间戳，应用安装时间作为检查点，如果时间戳超过7天，异步全量刷新缓存、数据表
  private updateAppCatTimeStamp: number = -1;
  // 应用市场没有配置21个预置应用的分类信息，需要单独配置，key:bundleName,value:secondaryCategoryId(应用的二级分类id)
  private presetAppCatIdMap: Map<string, number> = new Map<string, number>();
  private appCatIdMap: Map<string, number> = new Map<string, number>();
  // key:secondaryCategoryId(应用的二级分类id),value:分类名称
  private appCatNameMap: Map<number, string> = new Map<number, string>();
  private eventMgr: EventManager = EvtBus.createEventManager();
  // 应用的分类是否可获取
  private appCatEnable: boolean = false;
  // 系统账号认证解锁标志
  private isOsAccountUnlocked: boolean = false;

  // oobe流程结束时，全量获取本地应用的分类信息
  private onOobeChangeEvent = (event: OobeActivatedEvent): void => {
    log.showInfo(`onOobeActiveEvent: ${event?.isActivated}`);
    if (event != null && event.isActivated === false) {
      let bundleNames = AppCategoryUtils.getAllAppBundleNames();
      this.initAllAppCatInfo(bundleNames);
    }
  };

  // 开机后系统账号第一次认证解锁时，全量获取本地应用的分类信息
  private onUserUnlockedEvent = (event: UserUnlockedEvent): void => {
    try {
      osAccount.getAccountManager()?.isOsAccountUnlocked().then((isVerified: boolean) => {
        log.showInfo(`isOsAccountUnlocked success, isVerified = ${isVerified}`);
        this.isOsAccountUnlocked = isVerified;
        if (isVerified) {
          let bundleNames = AppCategoryUtils.getAllAppBundleNames();
          this.initAllAppCatInfo(bundleNames);
        }
      }).catch((err: BusinessError) => {
        log.showError(`update category err code: ${err?.code} message: ${err?.message}`);
      });
    } catch (e) {
      let err = e as BusinessError;
      log.showError(`isOsAccountUnlocked err code: ${err?.code} message: ${err?.message}`);
    }
  };

  public static getInstance(): AppCategoryInfoManager {
    if (AppCategoryInfoManager.instance == null) {
      AppCategoryInfoManager.instance = new AppCategoryInfoManager();
    }
    return AppCategoryInfoManager.instance;
  }

  constructor() {
  }

  /**
   *  初始化
   */
  public init(): void {
    log.showInfo('init appCat');
    this.initAppCatNameMap();
    this.registerOobeActivatedEventListener();
    this.registerUserUnlockedEventListener();
    this.appCatEnable = true;
  }

  /**
   * 释放
   */
  public release(): void {
    log.showInfo('release');
    this.unRegisterEventListener();
    this.appCatEnable = false;
  }

  /**
   * 应用的分类是否可以获取
   *
   * @returns 是否可获取
   */
  public getAppCatEnable(): boolean {
    return this.appCatEnable;
  }

  /**
   * 注册oobe阶段变化事件的监听
   */
  private registerOobeActivatedEventListener(): void {
    this.eventMgr.on(OobeActivatedEvent, this.onOobeChangeEvent);
  }

  /**
   * 反注册oobe阶段变化事件的监听
   */
  private unRegisterEventListener(): void {
    this.eventMgr.offAll();
  }

  /**
   * 注册账号认证解锁事件的监听
   */
  private registerUserUnlockedEventListener(): void {
    this.eventMgr.on(UserUnlockedEvent, this.onUserUnlockedEvent);
  }

  /**
   * 通过应用二级分类id获取对应的国际化名称
   *
   * @param appCatId 应用二级分类id
   * @returns 应用的国际化名称
   */
  public getAppCatName(appCatId: number): string | undefined {
    let appCatName: string = this.appCatNameMap.get(appCatId) ?? '';
    if (CheckEmptyUtils.checkStrIsEmpty(appCatName)) {
      HiDfxEventUtil.reportAppCategoryInfoMiss('', appCatId, AppCatErrorCode.CATEGORY_NAME_ERROR);
      log.showError(`getAppCatName failed! secondaryCategoryId: ${appCatId}`);
      return undefined;
    }
    return appCatName;
  }

  /**
   * 分类是否存在
   *
   * @param appCatId 应用二级分类id
   */
  public catIdExist(appCatId: number): boolean {
    return this.appCatNameMap.has(appCatId);
  }

  /**
   * 更新应用的分类信息
   *
   * @param downloadAppBundleNames 下载中应用的bundleName集合
   */
  public updateAppCatInfo(downloadAppBundleNames: string[]): void {
    let bundleNames: string[] = [];
    const currentTime: number = new Date().getTime();
    // 第一次构造AppCategoryInfoManager、或者距离上次全量刷新超过7天，需要异步全量刷新数据
    if (this.updateAppCatTimeStamp === -1 ||
      (currentTime - this.updateAppCatTimeStamp) > 7 * CommonConstants.ONE_DAY_MILL) {
      bundleNames = AppCategoryUtils.getAllAppBundleNames();
      this.initAllAppCatInfo(bundleNames);
    } else {
      bundleNames = downloadAppBundleNames;
      this.addAppCatInfo(bundleNames);
    }
    log.showInfo(`updateAppCatInfo bundleNames.length:${bundleNames.length}`);
  }

  /**
   * 初始化本地全量应用的分类信息
   *
   * @param bundleNames 应用bundleName集合
   * @returns
   */
  public async initAllAppCatInfo(bundleNames: string[]): Promise<void> {
    log.info('initAllAppCatInfo start');
    if (!bundleNames || bundleNames.length === 0) {
      log.showWarn('initAllAppCatInfo, bundleName is empty');
      return;
    }

    // let appCatInfos: appInfoManager.AppCategoryInfo[] = await this.getAppCatInfoFromAG(bundleNames);
    this.appCatIdMap.clear();
    // 1、从应用市场接口获取数据为空，读数据库全量数据，同步到缓存
    // if (!appCatInfos || appCatInfos.length === 0) {
    //   log.showWarn('initAllAppCatInfo, appCatInfos is null');
    //   this.syncAppCatDataToCache();
    //   return;
    // }
    //应用市场接口数据不为空，判断预制应用表是否为空
    if (!this.isPresetMapNotEmpt()) {
      await this.reloadCCM();
    }
    log.info(`presetAppCatIdMap.size ${this.presetAppCatIdMap.size}`)

    // // 2、从应用市场接口获取数据不为空，写缓存
    // appCatInfos.forEach((appCatInfo) => {
    //   if (appCatInfo != null) {
    //     this.appCatIdMap.set(appCatInfo.bundleName, appCatInfo.secondaryCategoryId);
    //   }
    // });
    // // 3、从应用市场接口获取数据不为空，先删库，再写库
    // try {
    //   RdbStoreManager.getInstance().deleteAppCatInfoTable().then(() => {
    //     RdbStoreManager.getInstance().batchInsertOrUpdateAppCatInfo(appCatInfos);
    //   });
    // } catch (err) {
    //   log.showError(`initAllAppCatInfo failed, code: ${err?.code}, message: ${err?.message}`);
    // }
    this.updateAppCatTimeStamp = new Date().getTime();
  }

  /**
   * 增量添加应用的分类信息
   *
   * @param bundleNames 应用的bundleName集合
   * @returns
   */
  private async addAppCatInfo(bundleNames: string[]): Promise<void> {
    if (!bundleNames || bundleNames.length === 0) {
      log.showWarn('addAppCatInfo, bundleName is empty');
      return;
    }
    // let appCatInfos: appInfoManager.AppCategoryInfo[] = await this.getAppCatInfoFromAG(bundleNames);
    // // 1、从应用市场接口获取数据为空，直接返回
    // if (!appCatInfos || appCatInfos.length === 0) {
    //   log.showWarn('addAppCatInfo, appCatInfos is null');
    //   return;
    // }
    // // 2、从应用市场接口获取数据不为空，写缓存
    // appCatInfos.forEach((appCatInfo) => {
    //   if (appCatInfo != null) {
    //     this.appCatIdMap.set(appCatInfo.bundleName, appCatInfo.secondaryCategoryId);
    //   }
    // });
    // 3、从应用市场接口获取数据不为空，写库
    // try {
    //   RdbStoreManager.getInstance().batchInsertOrUpdateAppCatInfo(appCatInfos);
    // } catch (err) {
    //   log.showError(`addAppCatInfo failed, code: ${err?.code}, message: ${err?.message}`);
    // }
  }

  /**
   * 从本地缓存读取应用的二级分类id
   *
   * @param bundleName 应用的bundleName
   * @returns 应用的二级分类id
   */
  public readCatIdFromCache(bundleName: string): number | undefined {
    if (!this.appCatIdMap || this.appCatIdMap.size === 0) {
      log.showWarn('readCatIdFromCache appCatIdMap is null, return');
      // 如果本地缓存为空，全量刷新数据
      let bundleNames = AppCategoryUtils.getAllAppBundleNames();
      this.initAllAppCatInfo(bundleNames);
      return undefined;
    }
    return this.appCatIdMap.get(bundleName);
  }

  /**
   * 判断预制应用分类缓存表是否为空
   * @returns 不为空返回true
   */
  public isPresetMapNotEmpt(): Boolean {
    return this.presetAppCatIdMap.size > 0;
  }

  /**
   * 从应用市场接口获取分类信息
   *
   * @param bundleNames 应用的bundleName集合
   * @returns 应用分类信息集合
   */
  // private async getAppCatInfoFromAG(bundleNames: string[]): Promise<appInfoManager.AppCategoryInfo[]> {
  //   if (!bundleNames || bundleNames.length === 0) {
  //     log.showWarn('getAppCatInfoFromAG, bundleName is empty');
  //     return [];
  //   }
  //   log.showInfo(`getAppCatInfoFromAG bundleNames.length: ${bundleNames.length}`);
  //   let appCatInfos: appInfoManager.AppCategoryInfo[] = [];
  //   try {
  //     // 避免重复获取系统账号的认证解锁状态，减少耗时操作(开机后到首次解锁前为false，之后都为true)
  //     if (this.isOsAccountUnlocked === false) {
  //       this.isOsAccountUnlocked = await osAccount.getAccountManager()?.isOsAccountUnlocked();
  //     }
  //     log.showInfo(`isOsAccountUnlocked = ${this.isOsAccountUnlocked}`);
  //     // 系统账号已认证解锁，才可以获取分类信息
  //     if (this.isOsAccountUnlocked === true) {
  //       const categoryResult = (await taskpool.execute(new taskpool.Task(getAppCatInfoTask,
  //         bundleNames))) as appInfoManager.AppCategoryInfo[];
  //       appCatInfos = await this.getValidAppCatInfo(categoryResult);
  //     }
  //   } catch (err) {
  //     log.showError(`getAppCatInfoFromAG failed, code: ${err?.code}, message: ${err?.message}`);
  //   }
  //   return appCatInfos;
  // }

  // 获取有效的分类信息，即把有分类id的信息筛选出来
  // private async getValidAppCatInfo(categoryResult: appInfoManager.AppCategoryInfo[]): Promise<appInfoManager.AppCategoryInfo[]> {
  //   let appCatInfos: appInfoManager.AppCategoryInfo[] = [];
  //   if (this.presetAppCatIdMap.size === 0) {
  //     await this.reloadCCM();
  //   }
  //   if (!categoryResult || categoryResult.length === 0) {
  //     log.showWarn('getValidAppCatInfo categoryResult is null, return');
  //     return appCatInfos;
  //   }
  //   categoryResult.forEach((result) => {
  //     if (result != null && result.appQueryCode === appInfoManager.QueryCode.SUCCESS) {
  //       if (result.primaryCategoryId === CommonConstants.GAME_APP_PRIMARY_CATEGORY_ID) {
  //         appCatInfos.push(this.getGameAppCategory(result));
  //       } else {
  //         appCatInfos.push(result);
  //       }
  //     } else {
  //       let presetAppCat = this.getPresetAppCategory(result);
  //       if (presetAppCat == null) {
  //         HiDfxEventUtil.reportAppCategoryInfoMiss(result?.bundleName, result?.secondaryCategoryId,
  //           result?.appQueryCode);
  //         log.showError(`getValidAppCatInfo failed! bundleName: ${result?.bundleName},
  //           secondaryCategoryId: ${result?.secondaryCategoryId}, appQueryCode: ${result?.appQueryCode}`);
  //       } else {
  //         appCatInfos.push(presetAppCat);
  //       }
  //     }
  //   });
  //   log.showInfo(`getValidAppCatInfo appCatInfos.length: ${appCatInfos.length}`);
  //   return appCatInfos;
  // }

  // 获取游戏应用的分类信息（游戏应用的分类取一级分类id，其他应用的分类取二级分类id）
  // private getGameAppCategory(appCategory: appInfoManager.AppCategoryInfo): appInfoManager.AppCategoryInfo {
  //   let gameAppCategory = {
  //     bundleName: appCategory.bundleName,
  //     primaryCategoryId: appCategory.primaryCategoryId,
  //     secondaryCategoryId: appCategory.primaryCategoryId,
  //     appQueryCode: appCategory.appQueryCode
  //   } as appInfoManager.AppCategoryInfo;
  //   return gameAppCategory;
  // }

  // 获取预置应用的分类信息
  // private getPresetAppCategory(appCategory: appInfoManager.AppCategoryInfo): appInfoManager.AppCategoryInfo | undefined {
  //   if (appCategory == null) {
  //     log.showInfo('getPresetAppCategory, appCategory is null');
  //     return undefined;
  //   }
  //   let categoryId = this.presetAppCatIdMap.get(appCategory.bundleName);
  //   if (categoryId && categoryId > 0) {
  //     let appCategoryInfo = {
  //       bundleName: appCategory.bundleName,
  //       primaryCategoryId: appCategory.primaryCategoryId,
  //       secondaryCategoryId: categoryId,
  //       appQueryCode: appCategory.appQueryCode
  //     } as appInfoManager.AppCategoryInfo;
  //     return appCategoryInfo;
  //   }
  //   return undefined;
  // }

  // 从数据表同步分类信息到本地缓存
  // private async syncAppCatDataToCache(): Promise<boolean> {
  //   try {
  //     let appCatInfos: appInfoManager.AppCategoryInfo[] = await RdbStoreManager.getInstance().getAllAppCatInfo();
  //     if (!appCatInfos || appCatInfos.length === 0) {
  //       log.showWarn('syncAppCatDataToCache, appCatInfos is null');
  //       return false;
  //     }
  //     appCatInfos.forEach((appCatInfo) => {
  //       if (appCatInfo != null) {
  //         this.appCatIdMap.set(appCatInfo?.bundleName, appCatInfo?.secondaryCategoryId);
  //       }
  //     });
  //     log.showInfo(`appCatInfos.length: ${appCatInfos.length}, appCatIdMap.size: ${this.appCatIdMap.size}`);
  //     return true;
  //   } catch (err) {
  //     log.showError(`syncAppCatDataToCache failed, code: ${err?.code}, message: ${err?.message}`);
  //   }
  //   return false;
  // }

  private initAppCatNameMap(): void {
    this.appCatNameMap.set(10000000, 'app_category_tools');
    this.appCatNameMap.set(10000001, 'app_category_business');
    this.appCatNameMap.set(10000002, 'app_category_efficiency');
    this.appCatNameMap.set(10000003, 'app_category_finance');
    this.appCatNameMap.set(10000004, 'app_category_education');
    this.appCatNameMap.set(10000005, 'app_category_kids');
    this.appCatNameMap.set(10000006, 'app_category_news');
    this.appCatNameMap.set(10000007, 'app_category_infotainment');
    this.appCatNameMap.set(10000008, 'app_category_reading');
    this.appCatNameMap.set(10000009, 'app_category_sports');
    this.appCatNameMap.set(10000010, 'app_category_cars');
    this.appCatNameMap.set(10000011, 'app_category_medical');
    this.appCatNameMap.set(10000012, 'app_category_health');
    this.appCatNameMap.set(10000013, 'app_category_movies');
    this.appCatNameMap.set(10000014, 'app_category_music');
    this.appCatNameMap.set(10000015, 'app_category_entertainment');
    this.appCatNameMap.set(10000016, 'app_category_social');
    this.appCatNameMap.set(10000017, 'app_category_photography');
    this.appCatNameMap.set(10000018, 'app_category_art');
    this.appCatNameMap.set(10000019, 'app_category_themes');
    this.appCatNameMap.set(10000020, 'app_category_lifestyle');
    this.appCatNameMap.set(10000021, 'app_category_house');
    this.appCatNameMap.set(10000022, 'app_category_shopping');
    this.appCatNameMap.set(10000023, 'app_category_food');
    this.appCatNameMap.set(10000024, 'app_category_travel');
    this.appCatNameMap.set(10000025, 'app_category_travel_navigation');
    this.appCatNameMap.set(10000026, 'app_category_test');
    this.appCatNameMap.set(2, 'app_category_game');
    this.appCatNameMap.set(20000008, 'app_category_test_verification');
  }

  /**
   * 先设置兜底的默认分类信息，然后读取CCM预制布局的分类信息来覆盖默认分类，避免预制应用获取不到分类
   */
  private initCatWithoutCcm(): void {
    this.presetAppCatIdMap.set('com.ohos.calculator', 10000000);
    this.presetAppCatIdMap.set('com.ohos.betaclub', 10000000);
    this.presetAppCatIdMap.set('com.ohos.soundrecorder', 10000000);
    this.presetAppCatIdMap.set('com.ohos.samplemanagement', 10000000);
    this.presetAppCatIdMap.set('com.ohos.dataclone', 10000000);
    this.presetAppCatIdMap.set('com.ohos.calendar', 10000000);
    this.presetAppCatIdMap.set('com.ohos.clock', 10000000);

    this.presetAppCatIdMap.set('com.ohos.settings', 10000000);
    this.presetAppCatIdMap.set('com.ohos.notepad', 10000000);
    this.presetAppCatIdMap.set('com.ohos.files', 10000000);
    this.presetAppCatIdMap.set('com.ohos.remotecontroller', 10000000);
    this.presetAppCatIdMap.set('com.ohos.parentcontrol', 10000000);
    this.presetAppCatIdMap.set('com.ohos.fut', 10000000);
    this.presetAppCatIdMap.set('com.ohos.mms', 10000016);
    this.presetAppCatIdMap.set('com.ohos.contacts', 10000016);
    this.presetAppCatIdMap.set('com.ohos.meetime', 10000016);
    this.presetAppCatIdMap.set('com.ohos.email', 10000016);
    this.presetAppCatIdMap.set('com.openharmony.it.welink', 10000016);
    this.presetAppCatIdMap.set('com.ohos.photos', 10000017);
    this.presetAppCatIdMap.set('com.ohos.camera', 10000017);
    this.presetAppCatIdMap.set('com.ohos.hiskytone', 10000024);
  }

  private async reloadCCM(): Promise<void> {
    let cfgFiles: string[] = [];
    let configPath: string = 'etc/hw_launcher_default_workspace.json';
    this.presetAppCatIdMap.clear();
    log.info(`reloadCCM start`);
    try {
      cfgFiles = await ConfigParseUtil.getAllConfig(configPath);
    } catch (error) {
      log.error('configPolicy.getCfgFiles error', error);
    }

    let configList: Array<DefaultDesktopLayoutInfo> = [];
    cfgFiles.forEach((filePath) => {
      const layout = FileUtils.readJsonFile(filePath.toString()) as DefaultDesktopLayoutInfo;
      configList.push(layout);
    });
    this.initPresetAppCatIdMap(configList);
  }

  private handleFolderItems(folderItems: GridLayoutItemInfo[]): void {
    folderItems.forEach((folderItem) => {
      if (folderItem.appCatagory) {
        this.presetAppCatIdMap.set(folderItem.bundleName, folderItem.appCatagory);
      }
    });
  }

  private async insertPresetMap(listItem: DefaultDesktopLayoutInfo): Promise<void> {
    log.info(`insertPresetMap start`);
    if (listItem) {
      listItem.layoutInfo.forEach((item: GridLayoutItemInfo) => {
        if (item.appCatagory) {
          this.presetAppCatIdMap.set(item.bundleName, item.appCatagory);
        }
        if (item.layoutInfo && item.typeId === CommonConstants.TYPE_FOLDER) {
          this.handleFolderItems(item.layoutInfo[0]);
        }
      });
    }
  }

  public async initPresetAppCatIdMap(configList: Array<DefaultDesktopLayoutInfo>): Promise<void> {
    this.initCatWithoutCcm();
    if (configList) {
      configList.forEach((listItem) => {
        if (listItem?.isAppCatagory) {
          this.insertPresetMap(listItem);
        }
      });
      log.info(`The number of configured AppCatagory ccm is configList length: ${configList.length}`);
    }
  }
  /**
   * 判断是否需要重新获取分类，用于重启时如果没网导致分类丢失
   */
  public isNeedRefreshAppCatIdMap(): boolean {
    //21是预置应用的个数，不需要从AG获取，如果只有这些应用分类，说明此时从AG获取失败了，需要重新获取。
    log.info(TAG, `appCatIdMap size is: ${this.appCatIdMap.size}`);
    return this.appCatIdMap.size <= 21;
  }

}

// async function getAppCatInfoTask(bundleNames: string[]): Promise<appInfoManager.AppCategoryInfo[]> {
//   'use concurrent';
//   return await appInfoManager.getAppCategory(bundleNames);
// }