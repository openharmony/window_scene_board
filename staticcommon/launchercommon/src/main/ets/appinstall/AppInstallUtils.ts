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

import { Prompt } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { NumberConstants } from '@ohos/commonconstants';
// import { appInfoManager, installInfoManager } from '@kit.StoreKit';
import type Context from '@ohos.app.ability.common';
import type ctx from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import {
  AppItemInfo,
  AppModel,
  AppReserveType,
  AppStatus,
  GridLayoutItemInfo,
  launcherAbilityManager,
  LaunchLayoutCacheManager,
  NotHarmonyUtil,
  LegacyInfo,
  DockItemInfo,
  GridLayoutUtil,
  CommonConstants,
  DeliverUtil,
  ResidentLayoutCacheMgr
} from '../TsIndex';
import taskPool from '@ohos.taskpool';
import {
  CommonUtils,
  FileUtils,
  LogDomain,
  LogHelper,
  CheckEmptyUtils
} from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { BusinessError } from '@kit.BasicServicesKit';
import { ResUtils } from '@ohos/windowscene';
import { AppFoundationServiceExtensionManager } from '../manager/AppFoundationServiceExtensionManager';
import { BusinessType } from '../constants/CommonConstants';
import fileIo from '@ohos.file.fs';

const TAG = 'appInstall_AppInstallUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const WAIT_FOR_STRING = '__WAIT_FOR_';
const CONNECT_SYMBOL: string = '__';
const WAIT_FOR_STRING_INDEX: number = 2;
const PRE_DOWNLOAD_MENU_LEAST_NUM = 1;
const DEFAULT_USER_ID: number = 100;
const APP_NOT_IN_LIST = 1 << 5;
const DAY_IN_MILLIS = 1000 * 60 * 60 * 24;
const THROTTLING_INTERVAL = 500; // 点击优先下载，节流时间间隔
const NO_NETWORK_TASK = 1; // ag无网待办任务


export class AppInstallUtils {
  private static mInstance: AppInstallUtils;

  private mLauncherLayoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();

  private lastClickBundleName: string = ''; // 记录上次点击的图标包名

  private lastClickTime: number = 0; // 记录最后一次有效点击时间戳

  private constructor() {
  }

  public static getInstance(): AppInstallUtils {
    if (!AppInstallUtils.mInstance) {
      AppInstallUtils.mInstance = new AppInstallUtils();
    }
    return AppInstallUtils.mInstance;
  }

  /**
   * 通过taskPool获取图标
   * @param bundleNames
   * @returns
   */
  public async getIconFromAppGalleryPool(bundleNames: string[]): Promise<string> {
    let icon: string = '';
    try {
      icon = await taskPool.execute(getIconFromAppGallery, bundleNames, GlobalContext.getContext()) as string;
    } catch (e) {
      log.showError('getIconFromAppGalleryPool error e= %{public}s', e?.message);
    }
    return icon;
  }

  /**
   * 获取图标
   * @param bundleNames
   * @returns
   */
  public async getIconFromAppGallery(bundleNames: string[]): Promise<string | undefined> {
    return getIconFromAppGallery(bundleNames, GlobalContext.getContext());
  }

  /**
   * 暂停下载任务
   * @param bundleName
   */
  public pauseTask(bundleName: string): void {
    log.showInfo('AbsTaskOperation, start pause');
    try {
      taskPool.execute(pauseDownload, bundleName).then((result) => {
        log.showWarn('AbsTaskOperation, end pause : result= %{public}d', result);
      });
    } catch (e) {
      log.showError('AbsTaskOperation, err pause : e= %{public}s', e?.message);
    }
  }

  /**
   * 恢复下载任务
   * @param bundleName
   */
  public resumeTask(bundleName: string): void {
    log.showInfo('AbsTaskOperation, start resume');
    try {
      taskPool.execute(resumeDownload, bundleName, false).then((result) => {
        log.showWarn('AbsTaskOperation, end resume : result= %{public}d', result);
      });
    } catch (e) {
      log.showError('AbsTaskOperation, err resume : e= %{public}s', e?.message);
    }
  }

  /**
   * 检查下载任务
   * @param item
   */
  public checkTask(item: AppItemInfo | GridLayoutItemInfo): void {
    log.showInfo('AbsTaskOperation, start check, appStatus:%{public}d', item.appStatus);
    /*let checkTaskInfo: installInfoManager.CheckTaskInfo = this.getCheckTaskInfo(item);
    try {
      taskPool.execute(checkDownload, checkTaskInfo).then((result) => {
        log.showWarn('AbsTaskOperation, end check : result= %{public}s', result);
      });
    } catch (e) {
      log.showError('AbsTaskOperation, err check : e= %{public}s', e?.message);
    }*/
  }

  /**
   * 取消下载应用，如果下载成功，移除图标
   * @param bundleName
   */
  public cancelTask(bundleName: string): void {
    log.showInfo('AbsTaskOperation, start cancel, %{public}s', bundleName);
    try {
      taskPool.execute(cancelDownload, bundleName).then((result) => {
        if (result === 1) {
          log.showError('clickAppToCancel failed! bundleName:%{public}s result= %{public}d', bundleName, result);
        } else {
          log.showInfo('cancelTask bundleName:%{public}s result= %{public}d', bundleName, result);
        }
        this.cancelDownloadTask(bundleName);
      }).catch((err: BusinessError) => {
        log.showError('cancelTask error! bundleName[%{public}s], %{public}d:%{public}s', err?.code, err?.message);
      });
    } catch (e) {
      log.showError('cancelTask error! bundleName[%{public}s], e= %{public}s', bundleName, e?.message);
    }
  }

  private getAppListWithBundleName(bundleName: string): GridLayoutItemInfo[] {
    const appList = this.mLauncherLayoutCacheManager.getAllSameBundleNameAppItem(bundleName);
    // 编辑多选场景, 会清理桌面缓存, 导致找不到应用, 这里至少包含主应用, 没有找到主动增加.
    if (appList.findIndex(item => item.appIndex === undefined || item.appIndex === 0) === -1) {
      const item = new GridLayoutItemInfo();
      item.bundleName = bundleName;
      item.appIndex = 0;
      appList.push(item);
    }
    return appList;
  }

  private cancelDownloadTask(bundleName: string): void {
    if (bundleName.startsWith(WAIT_FOR_STRING)) {
      bundleName = this.getNormalBundleName(bundleName);
    }
    const apps = launcherAbilityManager.getLauncherAbilityInfoByBundleName(bundleName);
    // 如果在BMS中找到了该应用说明是更新，不需要移除
    if (apps.length === 0) {
      const appList = this.getAppListWithBundleName(bundleName);
      appList.forEach(item => {
        log.showWarn('remove item bundleName:%{public}s appIndex:%{public}d status:%{public}d',
          item.bundleName, item.appIndex, item.appStatus);
        AppModel.getInstance().appItemRemove(item.bundleName, item.appIndex ?? 0);
      });
    } else {
      log.showWarn('cancelTask bundleName:%{public}s is find in BMS, the app is updating', bundleName);
    }
  }

  /**
   * 请求下载任务
   *
   * @param taskInfo
   * @returns 请求是否成功
   */
  public async requestTask(item: AppItemInfo | GridLayoutItemInfo): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showWarn('requestTask item is empty');
      return false;
    }
    log.showInfo('AbsTaskOperation, start request , %{public}s', item.bundleName);
    /*try {
      const requestTaskInfo = this.getRequestTaskInfo(item);
      const result: installInfoManager.RequestResultInfo =
        await taskPool.execute(requestDownload, requestTaskInfo) as installInfoManager.RequestResultInfo;
      if (result.resultCode === 0 && result.downloadInfos[0].status === 0) {
        PreInstallUtils.resetIntent(item);
      }
      log.showInfo('requestTask bundleName[%{public}s] resultCode= %{public}d', item.bundleName, result.resultCode);
      return result.resultCode === 0;
    } catch (e) {
      log.showError('requestTask error! bundleName[%{public}s], e= %{public}s', item.bundleName, e?.message);
    }*/
    return false;
  }

  /**
   * 请求AG创建无网络待办任务
   *
   * @param taskInfo
   * @returns 任务创建是否成功
   */
  public async requestNoNetworkTask(item: GridLayoutItemInfo): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showWarn('requestNoNetworkTask item is empty');
      return false;
    }
    log.showInfo('requestNoNetworkTask, start request , %{public}s', item.bundleName);
    /*try {
      const requestTaskInfo = this.getNoNetworkRequestTaskInfo(item);
      const result: installInfoManager.RequestResultInfo =
        await taskPool.execute(requestDownload, requestTaskInfo) as installInfoManager.RequestResultInfo;
      if (result.resultCode !== 0) {
        log.showWarn('requestTask bundleName[%{public}s] resultCode= %{public}d', item.bundleName, result.resultCode);
        return false;
      }
      return true;
    } catch (e) {
      log.showError('requestTask error! bundleName[%{public}s], e= %{public}s', item.bundleName, e?.message);
    }*/
    return false;
  }

  /**
   * 构建无网络待办任务对象，该类型需要传appName、iconFd
   *
   * @param item 构建请求对象的应用
   * @returns RequestTaskInfo
   */
  private getNoNetworkRequestTaskInfo(item: GridLayoutItemInfo): ESObject {
    const bundleName = item.bundleName;
    log.showInfo(`getRequestTaskInfo bundleName ${bundleName}, icon ${item.iconResource}`);
    let iconFd: number = -1;
    if (FileUtils.isExist(item.iconResource?.replace(CommonConstants.SANDBOX_FILE_PREFIX, ''))) {
      iconFd = FileUtils.openFile(item.iconResource).fd;
      log.showInfo(`getRequestTaskInfo iconFd: ${iconFd}`);
    }
    if (CheckEmptyUtils.isEmpty(item.appName)) {
      item.appName = bundleName;
    }
    /*const requestTaskInfo: installInfoManager.RequestTaskInfo = {
      downloadInfos: new Array({
        bundleName: bundleName,
        taskType: NO_NETWORK_TASK,
        appName: item.appName,
        iconFd: iconFd
      } as installInfoManager.DownloadInfo),
    };
    return requestTaskInfo;*/
    return {};
  }

  private getRequestTaskInfo(item: AppItemInfo | GridLayoutItemInfo): ESObject {
    /*const bundleName = item.bundleName;
    const requestTaskInfo: installInfoManager.RequestTaskInfo = {
      downloadInfos: new Array({ bundleName: bundleName } as installInfoManager.DownloadInfo),
    };
    log.showInfo(`requestTaskInfo bundleInfo: ${bundleName}`);
    return requestTaskInfo;*/
    return {};
  }

  private getCheckTaskInfo(item: AppItemInfo | GridLayoutItemInfo): ESObject {
    let bundleName = item.bundleName;
    if (item.appStatus === AppStatus.WAIT_FOR_HARMONY) {
      let extendInfo: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
      if (extendInfo && extendInfo.has('requestBundleName')) {
        bundleName = extendInfo.get('requestBundleName') as string;
      }
    }
    /*let checkTaskInfo: installInfoManager.CheckTaskInfo = {
      'ownerInfo': this.getOwnerInfo(item.callerName ?? ''),
      'bundleName': bundleName,
      'callerName': item.callerName ?? '',
    };
    log.showInfo(`checkTaskInfo bundleInfo: ${bundleName}`);
    return checkTaskInfo;*/
    return {};
  }

  /**
   * 未鸿蒙化包名转普通包名
   *
   * @param waitForBundleName 未鸿蒙化包名
   * @returns string 普通包名
   */
  public getNormalBundleName(waitForBundleName: string): string {
    let args: string[] = waitForBundleName.split(CONNECT_SYMBOL);
    return args.length > WAIT_FOR_STRING_INDEX ? args[WAIT_FOR_STRING_INDEX] : waitForBundleName;
  }

  /**
   * 获取OwnerInfo
   * @param callerName
   * @returns
   */
  public getOwnerInfo(callerName: string): ESObject {
    let ownerInfo: ESObject;
    switch (callerName) {
      case 'com.ohos.clouddrive':
        ownerInfo = {
          'bundleName': callerName,
          'moduleName': 'phone',
          'abilityName': 'BackupServiceAbility',
        };
        break;
      case 'com.ohos.dataclone':
        ownerInfo = {
          'bundleName': callerName,
          'moduleName': 'phone',
          'abilityName': 'SilentInstallServiceExtAbility',
        };
        break;
      case 'com.ohos.databackup':
      case 'com.ohos.hisuite':
        ownerInfo = {
          'bundleName': callerName,
          'moduleName': 'phone',
          'abilityName': 'InstallServiceExtensionAbility',
        };
        break;
      default:
        ownerInfo = {
          'bundleName': '',
          'moduleName': '',
          'abilityName': '',
        };
        log.showInfo(' AppItemInfo has not checked');
        break;
    }
    return ownerInfo;
  }

  /**
   * 是否添加'优先下载'的菜单
   * @param item GridLayoutItemInfo
   * @returns
   */
  public isAddPreDownloadMenu(item: GridLayoutItemInfo): boolean {
    if (!this.isPreDownloadMenuAppType(item) || !this.isPreDownloadMenuStatus(item)) {
      return false;
    }
    let num: number = 0;
    let desktopLayoutItemList: GridLayoutItemInfo[] =
      this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);
    for (let i = 0; i < desktopLayoutItemList.length; i++) {
      let info: GridLayoutItemInfo = desktopLayoutItemList[i];
      if (!CheckEmptyUtils.isEmpty(info)) {
        num = num + this.getPreDownloadMenuNum(info, 'desktop');
        if (num > PRE_DOWNLOAD_MENU_LEAST_NUM) {
          log.showInfo('addPreDownloadMenu add true, bundleName:%{public}s, appName:%{public}s, num:%{public}d',
            item.bundleName, item.appName, num);
          return true;
        }
      }
    }
    let dockLayoutItemList: DockItemInfo[] | undefined = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (dockLayoutItemList === undefined) {
      return num > PRE_DOWNLOAD_MENU_LEAST_NUM;
    }
    for (let i = 0; i < dockLayoutItemList?.length; i++) {
      if (CheckEmptyUtils.isEmpty(dockLayoutItemList[i])) {
        continue;
      }
      let info: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockLayoutItemList[i]);
      if (!CheckEmptyUtils.isEmpty(info)) {
        num = num + this.getPreDownloadMenuNum(info, 'dock');
        if (num > PRE_DOWNLOAD_MENU_LEAST_NUM) {
          break;
        }
      }
    }
    log.showInfo('addPreDownloadMenu add %{public}s, bundleName:%{public}s, appName:%{public}s, num:%{public}d',
      num > PRE_DOWNLOAD_MENU_LEAST_NUM, item.bundleName, item.appName, num);
    return num > PRE_DOWNLOAD_MENU_LEAST_NUM;
  }

  /**
   * 点击优先下载
   * @param item GridLayoutItemInfo
   */
  public clickAppToPreDownload(item: GridLayoutItemInfo): void {
    try {
      let appList: GridLayoutItemInfo[] =
        this.mLauncherLayoutCacheManager.getAllSameBundleNameAppItem(item.bundleName);
      let status: number | undefined = appList[0]?.appStatus ?? item.appStatus;
      if (!this.isPreDownloadMenuAppStatus(status)) {
        log.showWarn('addPreDownloadMenu bundleName:%{public}s click return, appStatus:%{public}d, defaultStatus:%{public}d',
          item.bundleName, status, item.appStatus);
        return;
      }
      let checkTaskOptions: CheckTaskOptions | undefined = undefined;
      checkTaskOptions = this.getCheckTaskOptions(item);
      log.showInfo('addPreDownloadMenu bundleName:%{public}s click, status:%{public}d, callerName:%{public}s,checkTaskOptions:%{public}s',
        item.bundleName, status, item.callerName, JSON.stringify(checkTaskOptions));
      taskPool.execute(adjustTaskPriority, item.bundleName, 0, checkTaskOptions).catch((error: Error) => {
        log.error('addPreDownloadMenu click pending error', error.message);
      });
    } catch (e) {
      log.error('addPreDownloadMenu click error', e.message);
    }
  }

  /**
   * 处理点击图标优先下载
   */
  public dealClickPreDownload(itemInfo: GridLayoutItemInfo): void {
    let currentTime: number = new Date().getTime();
    // 同一个应用时间间隔校验
    if (itemInfo.bundleName === this.lastClickBundleName && currentTime - this.lastClickTime < THROTTLING_INTERVAL) {
      log.showWarn('The click time interval less than throttling interval, return.');
      return;
    }
    // 更新最后点击的包名和有效点击时间
    this.lastClickBundleName = itemInfo.bundleName;
    this.lastClickTime = currentTime;
    log.showInfo(`PreDownload true, bundleName = ${itemInfo?.bundleName}`);
    this.clickAppToPreDownload(itemInfo);
  }

  private isPreDownloadMenuStatus(item: GridLayoutItemInfo): boolean {
    let appList: GridLayoutItemInfo[] =
      this.mLauncherLayoutCacheManager.getAllSameBundleNameAppItem(item.bundleName);
    let status: number | undefined = appList[0]?.appStatus ?? item.appStatus;
    let res: boolean = this.isPreDownloadMenuAppStatus(status);
    log.showInfo('addPreDownloadMenu status %{public}s, bundleName:%{public}s, appName:%{public}s, appStatus:%{public}d,%{public}d',
      res, item.bundleName, item.appName, item.appStatus, status);
    return res;
  }

  private getPreDownloadMenuNum(item: GridLayoutItemInfo, tag: string): number {
    let num: number = 0;
    if (item.typeId === CommonConstants.TYPE_APP && this.isPreDownloadMenuApp(item)) {
      log.showInfo('addPreDownloadMenu %{public}s num bundleName:%{public}s, appName:%{public}s, appStatus:%{public}d',
        tag, item.bundleName, item.appName, item.appStatus);
      num++;
    } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
      let appList: GridLayoutItemInfo[] | undefined = item.layoutInfo?.flat().filter(itemInFolder =>
      itemInFolder && itemInFolder.typeId === CommonConstants.TYPE_APP && this.isPreDownloadMenuApp(itemInFolder));
      if (appList === undefined) {
        return num;
      }
      if (appList.length > 0) {
        log.showInfo('addPreDownloadMenu %{public}s folder num bundleName:%{public}s, appName:%{public}s, appStatus:%{public}d',
          tag, appList[0].bundleName, appList[0].appName, appList[0].appStatus);
      }
      if (appList.length > 1) {
        log.showInfo('addPreDownloadMenu %{public}s folder num bundleName:%{public}s, appName:%{public}s, appStatus:%{public}d',
          tag, appList[1].bundleName, appList[1].appName, appList[1].appStatus);
      }
      num = appList.length;
    }
    return num;
  }

  private isPreDownloadMenuApp(item: GridLayoutItemInfo): boolean {
    if (!this.isPreDownloadMenuAppType(item)) {
      return false;
    }
    let appList: GridLayoutItemInfo[] =
      this.mLauncherLayoutCacheManager.getAllSameBundleNameAppItem(item.bundleName);
    let status: number | undefined = appList[0]?.appStatus ?? item.appStatus;
    return this.isPreDownloadMenuAppStatus(status) || status === AppStatus.DOWNLOADING;
  }

  private isPreDownloadMenuAppType(item: GridLayoutItemInfo): boolean {
    if (!item) {
      return false;
    }
    if (item.appIndex !== CommonConstants.MAIN_APP_INDEX) {
      // 分身:不要菜单，不计数
      return false;
    }
    if (CommonUtils.jsonStrToMap(item.intent).get('appType') === AppReserveType.ENTERPRISE) {
      // 企业应用:不弹优先下载；从AG开始下载后可以弹优先下载
      let appList: GridLayoutItemInfo[] =
        this.mLauncherLayoutCacheManager.getAllSameBundleNameAppItem(item.bundleName);
      let status: number | undefined = appList[0]?.appStatus ?? item.appStatus;
      return status !== AppStatus.PENDING;
    }
    if (CommonUtils.jsonStrToMap(item.intent).get('appType') === AppReserveType.TASTE_FRESH) {
      // 尝鲜应用占位状态:不弹优先下载；从AG开始下载后可以弹优先下载
      return false;
    }
    if (DeliverUtil.isContainerItem(item.intent ?? '')) {
      // 应用:不要菜单，不计数
      return false;
    }
    return true;
  }

  private isPreDownloadMenuAppStatus(appStatus: number | undefined): boolean {
    return appStatus === AppStatus.PENDING || appStatus === AppStatus.WAITING || appStatus === AppStatus.PAUSING;
  }

  private getCheckTaskOptions(item: GridLayoutItemInfo): CheckTaskOptions {
    let checkTaskOptions: CheckTaskOptions = {
      'ownerInfo': this.getOwnerInfo(item.callerName ?? ''),
      'callerName': item.callerName ?? '',
    };
    return checkTaskOptions;
  }

  /**
   * 点击分身应用时根据主应用的状态进行不同的操作
   * @param bundleName
   */
  public clickTwinApp(bundleName: string): void {
    let appList: GridLayoutItemInfo[] = this.mLauncherLayoutCacheManager.getAllSameBundleNameAppItem(bundleName);
    if (!appList.length) {
      log.showWarn(`clickTwinApp err, ${bundleName} not find cache`);
      return;
    }
    let mainAppItem: GridLayoutItemInfo = appList[0];
    let mainAppItemAppStatus: number | undefined = mainAppItem.appStatus;
    log.showInfo(`clickTwinApp, main app bundlaName is ${bundleName}, status is ${mainAppItemAppStatus}`);
    if (mainAppItemAppStatus === AppStatus.PENDING || mainAppItemAppStatus === AppStatus.WAIT_FOR_HARMONY) {
      this.checkTask(mainAppItem);
    } else if (mainAppItemAppStatus === AppStatus.WAITING || mainAppItemAppStatus === AppStatus.WIFI_WAITING ||
      mainAppItemAppStatus === AppStatus.INSTALL_WAITING || mainAppItemAppStatus === AppStatus.PAUSING) {
      Prompt.showToast({
        message: ResUtils.getInnerStringNumS($r('app.string.click_twin_app_not_installed'), `${mainAppItem.appName}`)
      });
    } else if (mainAppItemAppStatus === AppStatus.DOWNLOADING) {
      Prompt.showToast({
        message: ResUtils.getInnerStringNumS($r('app.string.click_twin_app_download_start'), `${mainAppItem.appName}`)
      });
    } else if (mainAppItemAppStatus === AppStatus.INSTALLING) {
      Prompt.showToast({
        message: ResUtils.getInnerStringNumS($r('app.string.click_twin_app_download_installing'),
          `${mainAppItem.appName}`)
      });
    } else if (mainAppItemAppStatus === AppStatus.INSTALLED) {
      Prompt.showToast({
        message: ResUtils.getInnerStringNumS($r('app.string.click_twin_app_wait_data_recover'),
          `${mainAppItem.appName}`)
      });
    }
  }

  /**
   * 查询并点亮未鸿蒙化可出应用
   *
   * @param gridLayoutItemInfoList 未安装应用信息info
   */
  public async queryAndLightDeliverApp(gridLayoutItemInfoList: GridLayoutItemInfo[]): Promise<void> {
    try {
      if (launcherAbilityManager.getUserId() !== DEFAULT_USER_ID) {
        log.showWarn('only default user support deliver');
        return;
      }
      let date: Date = new Date();
      let preference = await preferences.getPreferences(
        GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext, 'DESKTOP_LAYOUT_INFO');
      let queryAndLightAddDeliverAppTime: number = preference.getSync('queryAndLightAddDeliverApp', 0) as number;
      if (queryAndLightAddDeliverAppTime !== 0 &&
        queryAndLightAddDeliverAppTime > this.minusDays(date, NumberConstants.CONSTANT_NUMBER_ONE)) {
        log.showInfo('not need query, last query time %{public}d', queryAndLightAddDeliverAppTime);
        return;
      }
      let pkgNameArr: string[] = [];
      gridLayoutItemInfoList.forEach(appItemInfo => {
        if (appItemInfo.appStatus === AppStatus.WAIT_FOR_HARMONY &&
          CommonUtils.jsonStrToMap(appItemInfo.intent).get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) as number !== 1) {
          pkgNameArr.push(appItemInfo.bundleName);
        }
      });
      if (CheckEmptyUtils.isEmptyArr(pkgNameArr)) {
        log.showInfo('queryAndLightAddDeliverAp pkgNameArr is empty');
        return;
      }
      let appFoundation: AppFoundationServiceExtensionManager = AppFoundationServiceExtensionManager.getInstance();
      await appFoundation.queryAppMappingInfo(pkgNameArr);
      let deliverBundleNamesMap: Map<string, number> = appFoundation.getDeliverBundleNamesMap();
      if (!appFoundation.queryMappingResult() && CheckEmptyUtils.isEmpty(deliverBundleNamesMap)) {
        log.showError('queryAppMappingInfo failed, do not save time');
        return;
      }
      let deliverBundleNames: string[] = this.removeNotInAppList32App(deliverBundleNamesMap, gridLayoutItemInfoList);
      if (!CheckEmptyUtils.isEmptyArr(deliverBundleNames)) {
        log.showInfo('lightAddDeliverApp start');
        let relationMap: Map<string, boolean> = new Map();
        let publicTestRelationMap: Map<string, boolean> = new Map();
        deliverBundleNames.forEach(item => {
          log.showInfo('queryAndLightAddDeliverApp hasohosApp: %{public}s', item);
          relationMap.set(item, true);
        });
        NotHarmonyUtil.lightingNotHarmonyAppIcons(relationMap, publicTestRelationMap);
        NotHarmonyUtil.refreshNotHarmonyFolderPosition(relationMap, publicTestRelationMap);
        let lightArrString: string = preference.getSync('lightDeliverBundleNames', '') as string;
        if (lightArrString) {
          lightArrString += ',';
        }
        preference.putSync('lightDeliverBundleNames', lightArrString + deliverBundleNames.join(','));
        log.showInfo('lightAddDeliverApp end');
      }
      preference.putSync('queryAndLightAddDeliverApp', date.getTime());
      await preference.flush().then(() => {
        log.showInfo('save queryAndLightAddDeliverApp to sp success');
      }).catch((reject: Error) => {
        log.showInfo('save queryAndLightAddDeliverApp to sp fail: %{public}s', reject?.message);
      });
      log.showInfo('queryAndLightAddDeliverApp time %{public}s', date.toString());
    } catch (err) {
      log.showError(`queryAndLightAddDeliverApp, Failed to get preferences error: ${err.code} : ${err.message}`);
    }
  }

  private removeNotInAppList32App(deliverBundleNamesMap: Map<string, number>,
    gridLayoutItemInfoList: GridLayoutItemInfo[]): string[] {
    let deliverBundleNames: string[] = [];
    if (CheckEmptyUtils.isEmpty(deliverBundleNamesMap) || CheckEmptyUtils.isEmptyArr(gridLayoutItemInfoList)) {
      log.showWarn('removeNotInAppList32App params is empty');
      return deliverBundleNames;
    }
    deliverBundleNamesMap.forEach((type, item) => {
      if (type & APP_NOT_IN_LIST) {
        let gridLayoutInfo: GridLayoutItemInfo | undefined =
          gridLayoutItemInfoList.find(grid => grid.bundleName === item);
        if (gridLayoutInfo && NotHarmonyUtil.isSupport64(CommonUtils.jsonStrToMap(gridLayoutInfo.intent)
          .get('legacyInfo') as LegacyInfo)) {
          log.showInfo('queryAndLightAddDeliverApp hasohosApp is support deliver 64: %{public}s', item);
          deliverBundleNames.push(item);
        }
      } else {
        deliverBundleNames.push(item);
      }
    });
    return deliverBundleNames;
  }

  /**
   * 在date基础减去上days天数
   *
   * @param date 基础日期
   * @param days 减去天数
   * @return 减去后的毫秒值
   */
  private minusDays(date: Date, days: number): number {
    let curTime: number = date.getTime();
    return curTime - (days * DAY_IN_MILLIS);
  }

  public cancelRestoreLauncherData(bundleNames: string[]): void {
    log.showInfo('cancelRestoreLauncherData, start cancel length: %{public}d', bundleNames.length);
    try {
      taskPool.execute(cancelDownloadBatch, bundleNames);
    } catch (e) {
      log.showInfo('cancelRestoreLauncherData, err cancel : e= %{public}s', e?.message);
    }
  }
}

/**
 * 应用市场请求图标
 * @param bundleNames
 * @param context
 * @returns
 */
async function getIconFromAppGallery(bundleNames: string[], context: Context.BaseContext): Promise<string | undefined> {
  'use concurrent';
  const TAG = 'appinstall getIconFromAppGallery';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  const ICON_NAME_PRE = 'appgallery_';
  const OLD_ICON_FOLDER_NAME = '/oldIcons';
  const READ_DATA_SIZE = 4096;
  let filesDir: string = (context as ctx.ServiceExtensionContext)?.filesDir;

  //  调用getAppIcons接口
  log.showInfo('AbsTaskOperation, start getAppIcon. %{public}s', filesDir);
  let stream: fileIo.Stream | undefined = undefined;
  let fd: number = -1;
  try {
    /*let result = await appInfoManager.getAppIcons(bundleNames);
    if (result.resultCode !== 0 || result.appIcons[0].code !== 0) {
      log.showInfo('getAppIcons err resultCode: %{public}d, code: %{public}d', result.resultCode, result.appIcons[0].code);
      return undefined;
    }
    log.showInfo('getAppIcon result : bundleName=%{public}s, iconfd=%{public}d', result.appIcons[0].bundleName, result.appIcons[0].iconFd);
    const fileName: string = ICON_NAME_PRE + bundleNames[0];
    const fileNameWithoutPoint: string = fileName.split('.').join('');
    if (!FileUtils.isExist(filesDir + OLD_ICON_FOLDER_NAME)) {
      FileUtils.createFolder(filesDir + OLD_ICON_FOLDER_NAME);
    }
    let filesPath: string = filesDir + OLD_ICON_FOLDER_NAME + '/' + fileNameWithoutPoint + '.png';
    if (FileUtils.isExist(filesPath)) {
      FileUtils.deleteConfigFile(filesPath);
    }
    fd = result.appIcons[0].iconFd;
    stream = fs.createStreamSync(filesPath, 'a+');
    let arrayBuffer = new ArrayBuffer(READ_DATA_SIZE);
    let readLine: number = 0;
    class Option {
      offset: number = 0;
      length: number = 0;
      encoding: string = 'utf-8';
    }
    while ((readLine = fs.readSync(fd, arrayBuffer)) !== 0) {
      let option: Option = new Option();
      option.length = readLine;
      log.showInfo('getIconFromAppGallery readLine =%{public}d', readLine);
      stream.writeSync(arrayBuffer, option);
    }
    return filesPath;*/
    return '';
  } catch (err) {
    log.showInfo('getAppIcons err: %{public}s', err?.message);
  } finally {
    if (stream) {
      try {
        stream.closeSync();
      } catch (error) {
        log.showError(`stream file closeSync error, error : ${error?.code}`);
      }
    }
    if (fd && fd !== -1) {
      fs.closeSync(fd);
    }
  }
  return undefined;
}

async function pauseDownload(bundleName: string): Promise<ESObject> {
  'use concurrent';
  // return installInfoManager.pauseTask(bundleName);
  return {};
}

async function resumeDownload(bundleName: string, isForce: boolean): Promise<ESObject> {
  'use concurrent';
  // return installInfoManager.resumeTask(bundleName, isForce);
  return {};
}

async function checkDownload(taskInfo: ESObject): Promise<boolean> {
  'use concurrent';
  // return installInfoManager.checkTask(taskInfo);
  return false;
}

async function cancelDownload(bundleName: string): Promise<ESObject> {
  'use concurrent';
  // return installInfoManager.cancelTask(bundleName);
  return {};
}

export async function adjustTaskPriority(bundleName: string, priority: number,
  checkTaskOptions?: CheckTaskOptions): Promise<void> {
  'use concurrent';
  // return installInfoManager.adjustTaskPriority(bundleName, priority, checkTaskOptions);
}

export interface CheckTaskOptions {
  ownerInfo: ESObject;
  callerName: string;
}

async function cancelDownloadBatch(bundleNames: string[]): Promise<void> {
  'use concurrent';
  const TAG = 'AppGalleryDownloadManager';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  for (let i = 0; i < bundleNames.length; i++) {
    /*let result = installInfoManager.cancelTask(bundleNames[i]);
    log.showInfo('cancelDownloadBatch, end cancel: bundleName=%{public}s, result= %{public}d', bundleNames[i], result);*/
  }
}

async function requestDownload(taskInfo: ESObject):
  Promise<ESObject> {
  'use concurrent';
  // return await installInfoManager.requestTask(taskInfo);
  return {};
}