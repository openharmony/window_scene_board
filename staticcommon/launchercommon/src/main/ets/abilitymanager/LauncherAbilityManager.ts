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

import bundleMgr from '@ohos.bundle';
import bundleMonitor from '@ohos.bundle.bundleMonitor';
import launcherBundleManager from '@ohos.bundle.launcherBundleManager';
import { LauncherAbilityInfo } from 'bundleManager/LauncherAbilityInfo';
import { AppItemInfo } from '../bean/AppItemInfo';
import { DockItemInfo } from '../bean/DockItemInfo';
import { ShortcutInfo } from '../bean/ReceiveEventInfo';
import { AppStatus, CommonConstants } from '../constants/CommonConstants';
import { EventConstants } from '../constants/EventConstants';
import bundleManager from '@ohos.bundle.bundleManager';
import type { BusinessError, Callback } from '@ohos.base';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, IconResourceManager, ResourceManager } from '@ohos/frameworkwrapper';
import { AppTypeUtils } from '@ohos/componenthelper';
import { installer } from '@kit.AbilityKit';
import { GetHideAppsFromConfig } from '../layoutconfig/GetHideAppsFromConfig';

const TAG = 'LauncherAbilityManager';
/**
 * 时间格式,小时,13位
 */
const PAG_END = 13;
const ERROR_CODE = 0;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
export const APP_LOCKED_ERROR_CODE = 17700062;
export type ListenerFuncType = (event: string, bundleName: string, userId: number, appIndex?: number) => void;
export type shortCutFuncType = (bundleName: string, shortcutInfo: ShortcutInfo[]) => void;

/**
 * Wrapper class for innerBundleManager and formManager interfaces.
 */
class LauncherAbilityManager {
  private static readonly BUNDLE_STATUS_CHANGE_KEY = 'BundleStatusChange';
  private static mInstance: LauncherAbilityManager;
  private readonly mAppMap = new Map<string, AppItemInfo>();
  private mUserId: number = 100; // 多用户需求待做，当前默认100用户
  private mIsPad: boolean = false;
  private mHasVoiceCapability: boolean = true;

  private readonly mPackageAddCallback: (info) => void = (info) => {
      log.showWarn(`mBundleStatusCallback add bundleName: ${info.bundleName}` + `appIndex: ${info.appIndex}`);
      if (GetHideAppsFromConfig.getInstance().isHideApp(info.bundleName)) {
        log.showDebug(`mBundleStatusCallback add bundleName is hide app: ${info.bundleName}`);
        return;
      }
      // 目前sceneboard暂不支持做用户校验。
      // this.mUserId == userId &&
      this.notifyLauncherAbilityChange(EventConstants.EVENT_PACKAGE_ADDED, info.bundleName, info.userId,
        info.appIndex ?? 0);
    };
  private readonly mPackageRemoveCallback: (info) => void = (info) => {
      const isSameUser: boolean = info.userId === this.mUserId;
      log.showWarn(`mBundleStatusCallback remove bundleName: ${info.bundleName}` + `appIndex: ${info.appIndex}, isSameUser ${isSameUser}`);
      if (info.userId === this.getUserId()) {
         this.mAppMap.delete(this.getCacheKey(info.bundleName, info.appIndex ?? 0))
      }
      // 目前sceneboard暂不支持做用户校验。
      // this.mUserId == userId &&
      this.notifyLauncherAbilityChange(EventConstants.EVENT_PACKAGE_REMOVED, info.bundleName, info.userId,
        info.appIndex ?? 0);
    };
  private readonly mPackageUpdateCallback: (info) => void = (info) => {
      log.showWarn(`mBundleStatusCallback update bundleName: ${info.bundleName}` + `appIndex: ${info.appIndex}`);
      if (GetHideAppsFromConfig.getInstance().isHideApp(info.bundleName)) {
        log.showDebug(`mBundleStatusCallback update bundleName is hide app: ${info.bundleName}`);
        return;
      }
      // this.mUserId == userId &&
      this.notifyLauncherAbilityChange(EventConstants.EVENT_PACKAGE_CHANGED, info.bundleName, info.userId,
        info.appIndex ?? 0);
    };

  private readonly mLauncherAbilityChangeListeners: ListenerFuncType[] = [];

  private constructor() {
    this.mIsPad = DeviceHelper.isPad();
    this.mHasVoiceCapability = DeviceHelper.isSupportVoiceCapability();
  }

  /**
   * Get desktop application information management object
   *
   * @return Desktop application information management object instance
   */
  static getInstance(): LauncherAbilityManager {
    if (!LauncherAbilityManager.mInstance) {
      LauncherAbilityManager.mInstance = new LauncherAbilityManager();
    }
    return LauncherAbilityManager.mInstance;
  }

  setCurrentUserId(userId: number): void {
    this.mUserId = userId;
  }

  getUserId(): number {
    return this.mUserId;
  }

  /**
   * Monitor system application status.
   *
   * @params listener: listening object
   */
  registerLauncherAbilityChangeListener(listener: ListenerFuncType): void {
    log.showWarn('register BMS callback');
    if (listener != null) {
      try {
        bundleMonitor.on('add', this.mPackageAddCallback);
        bundleMonitor.on('update', this.mPackageUpdateCallback);
        bundleMonitor.on('remove', this.mPackageRemoveCallback);
      } catch (err) {
        log.error('registerCallback fail:', err);
      }
      const index = this.mLauncherAbilityChangeListeners.indexOf(listener);
      if (index === CommonConstants.INVALID_VALUE) {
        this.mLauncherAbilityChangeListeners.push(listener);
      }
    } else {
      log.showWarn('listener is null');
    }
  }

  /**
   * Cancel monitoring system application status.
   *
   * @params listener: listening object
   */
  unregisterLauncherAbilityChangeListener(listener: ListenerFuncType): void {
    if (listener) {
      const index = this.mLauncherAbilityChangeListeners.indexOf(listener);
      if (index !== CommonConstants.INVALID_VALUE) {
        this.mLauncherAbilityChangeListeners.splice(index, 1);
      }
      log.showWarn(`unregister BMS callback,Listeners length: ${this.mLauncherAbilityChangeListeners.length}`);
      if (this.mLauncherAbilityChangeListeners.length === 0) {
        try {
          bundleMonitor.off('add', this.mPackageAddCallback);
          bundleMonitor.off('update', this.mPackageUpdateCallback);
          bundleMonitor.off('remove', this.mPackageRemoveCallback);
        } catch (err) {
          log.error('unregisterCallback fail:', err);
        }
      }
    } else {
      log.showWarn('listener is null');
    }
  }

  private notifyLauncherAbilityChange(event: string, bundleName: string, userId: number, appIndex: number): void {
    if (userId !== this.getUserId()) {
      log.showWarn('user is not current');
      return;
    }
    for (let index = 0; index < this.mLauncherAbilityChangeListeners.length; index++) {
      if (appIndex > 0) {
        this.mLauncherAbilityChangeListeners[index](event, bundleName, userId, appIndex);
      } else {
        this.mLauncherAbilityChangeListeners[index](event, bundleName, userId);
      }
    }
  }

  /**
   * get all app List info from BMS
   */
  async getLauncherAbilityList(userId?: number): Promise<AppItemInfo[]> {
    let abilityList: LauncherAbilityInfo[] | undefined;
    await launcherBundleManager.getAllLauncherAbilityInfo(userId ? userId : this.mUserId)
      .then((res) => {
        abilityList = res;
      })
      .catch((err: Error) => {
        log.showError('getLauncherAbilityList error:', err);
      });
    const appItemInfoList = new Array<AppItemInfo>();
    if (!abilityList) {
      log.showDebug('getLauncherAbilityList Empty');
      return appItemInfoList;
    }
    for (let i = 0; i < abilityList.length; i++) {
      try {
        let appItem = this.convertToAppItemInfo(abilityList[i]);
        if (this.isIgnoreApp(appItem)) {
          continue;
        }
        appItemInfoList.push(appItem);
      } catch (error) {
        log.showError(`get app item info failed, error code: ${error.code}, message: ${error.message}.`);
      }
    }
    return appItemInfoList;
  }

  /**
   * 从BMS根据bundleName获取所有应用
   * @param bundleName
   * @returns 当前bundleName所有应用
   */
  public getLauncherAbilityInfoByBundleName(bundleName: string): AppItemInfo[] {
    let abilityInfos: LauncherAbilityInfo[] = [];
    try {
      abilityInfos = launcherBundleManager.getLauncherAbilityInfoSync(bundleName, this.mUserId);
    } catch (err) {
      log.showError(`getShortcutInfoByBundleNameSync error, code:${err?.code} message:${err?.message}`);
    }
    const appList: AppItemInfo[] = [];
    abilityInfos.forEach((item: LauncherAbilityInfo) => {
      let appItem = this.convertToAppItemInfo(item);
      appList.push(appItem);
    });

    return appList;
  }

  /**
   * get AbilityInfos by bundleName from BMS
   *
   * @params bundleName Application package name
   * @return List of entry capabilities information of the target application
   */
  async getLauncherAbilityInfo(bundleName: string, isPackAdd?: boolean): Promise<AppItemInfo[]> {
    let abilityInfos: LauncherAbilityInfo[] | undefined;
    try {
      abilityInfos = launcherBundleManager.getLauncherAbilityInfoSync(bundleName, this.mUserId);
    } catch (err) {
      log.error('getLauncherAbilityInfo error:', err);
    };
    const appItemInfoList = new Array<AppItemInfo>();
    if (CheckEmptyUtils.isEmpty(abilityInfos)) {
      log.showError('getLauncherAbilityInfo Empty, %{public}s', bundleName);
      return appItemInfoList;
    }
    for (let i = 0; i < abilityInfos.length; i++) {
      let appItem = this.convertToAppItemInfo(abilityInfos[i], isPackAdd);
      // 安装场景需要获取最新应用名称，保证应用名刷新
      if (CheckEmptyUtils.isEmpty(appItem.appName)) {
        appItem.appName = await IconResourceManager.getInstance().updateAppNameSync(appItem.appLabelId ?? 0,
          appItem.bundleName, appItem.moduleName, '', appItem.appIndex);
        log.showInfo(`getLauncherAbility updateAppNameSync:${appItem.appName}`);
      }
      if (this.isIgnoreApp(appItem)) {
        continue;
      }
      appItemInfoList.push(appItem);
    }
    return appItemInfoList;
  }

  /**
   * 过滤应用
   *
   * @param appItem 应用信息
   * @returns true标识过滤该应用
   */
  public isIgnoreApp(appItem: AppItemInfo | DockItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(appItem)) {
      return true;
    }
    return this.isIgnoreContact(appItem.abilityName);
  }

  /**
   * 根据设备场景过滤联系人或通话
   *
   * @param appItem 应用信息
   * @returns true标识过滤该应用
   */
  private isIgnoreContact(abilityName: string): boolean {
    return (this.mIsPad && !this.mHasVoiceCapability && abilityName === CommonConstants.CONTACT_HAS_VOICE_CAPABILITY) ||
      (this.mIsPad && this.mHasVoiceCapability && abilityName === CommonConstants.CONTACT_PAD_NO_VOICE_CAPABILITY) ||
      (!this.mIsPad && abilityName === CommonConstants.CONTACT_PAD_NO_VOICE_CAPABILITY);
  }

  isAbilityInstalledAsync(bundleName: string, callBack: Callback<boolean>): void {
    try {
      launcherBundleManager.getLauncherAbilityInfo(bundleName, this.mUserId, (err, data) => {
        callBack?.(data?.length > 0);
      });
    } catch (err) {
      log.error(`isAbilityInstalledAsync getLauncherAbilityInfo error:`, err);
    }
  }

  /**
   * get AppItemInfo from BMS with bundleName
   * @params bundleName
   * @return AppItemInfo
   */
  async getAppInfoByBundleName(bundleName: string, abilityName?: string, appIndex?: number): Promise<AppItemInfo | undefined> {
    let appItemInfo: AppItemInfo | undefined = undefined;
    if (!appIndex) {
      appIndex = 0;
    }
    // get from cache
    if (this.mAppMap != null && this.mAppMap.has(this.getCacheKey(bundleName, appIndex))) {
      appItemInfo = this.mAppMap.get(this.getCacheKey(bundleName, appIndex));
    }
    if (appItemInfo !== undefined) {
      if (CheckEmptyUtils.isEmpty(appItemInfo.appName)) {
        appItemInfo.appName = await IconResourceManager.getInstance().getAppName(appItemInfo.appLabelId,
          appItemInfo.bundleName, appItemInfo.moduleName, '', appIndex);
        log.showInfo('getAppInfoByBundleName ' + appItemInfo.appName);
      }
      return appItemInfo;
    }
    // get from system
    let abilityInfos: LauncherAbilityInfo[] | undefined;
    try {
      abilityInfos = launcherBundleManager.getLauncherAbilityInfoSync(bundleName, this.mUserId);
    } catch (err) {
      log.error('getAppInfoByBundleName launcherBundleMgr getLauncherAbilityInfos error:', err);
    };

    if (!abilityInfos || abilityInfos.length === 0) {
      log.showDebug(`${bundleName} has no launcher ability`);
      return undefined;
    }
    let data: AppItemInfo | undefined = undefined;
    for (let i = 0; i < abilityInfos.length; i++) {
      data = this.convertToAppItemInfo(abilityInfos[i]);
      if (!CheckEmptyUtils.isEmpty(data) && !this.isIgnoreApp(data) && data.appIndex === appIndex) {
        break;
      }
      data = undefined;
    }
    if (data) {
      if (CheckEmptyUtils.isEmpty(data.appName)) {
        data.appName = await IconResourceManager.getInstance().updateAppNameSync(data.appLabelId ?? 0, data.bundleName,
          data.moduleName, '', data.appIndex);
        log.showInfo(`getAppInfoByBundleName updateAppNameSync:${data.appName}`);
      }
      log.showError('getAppInfoByBundleName from BMS, appName:%{public}s;bundleName:%{public}s', data.appName, data.bundleName);
    }
    return data;
  }

  async getAppLabelId(bundleName: string): Promise<number | undefined> {
    log.showDebug(`${bundleName} get app info`);
    let applicationInfo: bundleManager.ApplicationInfo | undefined;
    let appFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
    try {
      await bundleManager.getApplicationInfo(bundleName, appFlags, this.mUserId)
        .then((res) => {
          if (res !== undefined) {
            applicationInfo = res;
          }
        })
        .catch((err: Error) => {
          log.error('getApplicationInfo launcherBundleMgr getLauncherAbilityInfos error:', err);
        });
    } catch (error) {
      log.error('getAppLabelId bundleManager.getApplicationInfo try error:', error);
    }


    if (!applicationInfo) {
      log.showError(`${bundleName} has no launcher ability`);
      return undefined;
    }
    return applicationInfo.labelId;
  }

  async getAppIconId(bundleName: string): Promise<number | undefined> {
    log.showDebug(`${bundleName} get app iconId`);
    let applicationInfo: bundleManager.ApplicationInfo | undefined;
    let appFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
    try {
      await bundleManager.getApplicationInfo(bundleName, appFlags, this.mUserId)
        .then((res) => {
          if (res !== undefined) {
            applicationInfo = res;
          }
        })
        .catch((err: Error) => {
          log.error('getAppIconId bundleManager.getApplicationInfo reject error:', err);
        });
    } catch (error) {
      log.error('getAppIconId bundleManager.getApplicationInfo error:', error);
    }

    if (!applicationInfo) {
      log.showError(`${bundleName} has no application info`);
      return undefined;
    }
    return applicationInfo.iconId;
  }

  private getCacheKey(bundleName: string, appIndex: number): string {
    return `${bundleName}${appIndex ?? 0}`;
  }

  private convertToAppItemInfo(info: LauncherAbilityInfo, isPackAdd?: boolean): AppItemInfo{
    const appItemInfo = new AppItemInfo();
    if (CheckEmptyUtils.isEmpty(info)) {
      log.showError(`convertToAppItemInfo info: ${JSON.stringify(info)} `);
      return appItemInfo;
    }
    this.fillAppItemInfo(appItemInfo, info, isPackAdd);
    return appItemInfo;
  }

  private fillAppItemInfo(appItemInfo: AppItemInfo, info: LauncherAbilityInfo, isPackAdd?: boolean): void {
    appItemInfo.appName = info.labelId === 0 ? info.applicationInfo?.label : '';
    appItemInfo.isSystemApp = info.applicationInfo?.systemApp;
    appItemInfo.isUninstallAble = info.applicationInfo?.removable;
    appItemInfo.appIconId = info.iconId;
    appItemInfo.applicationIconId = info.applicationInfo?.iconId;
    appItemInfo.appLabelId = info.labelId;
    appItemInfo.applicationLabelId = info.applicationInfo?.labelId;
    appItemInfo.codePath = info.applicationInfo?.codePath;
    appItemInfo.bundleName = info.elementName.bundleName;
    appItemInfo.kindId = AppTypeUtils.getInstance().queryAppTypeByPackage(info.elementName.bundleName);
    appItemInfo.abilityName = info.elementName.abilityName;
    appItemInfo.moduleName = info.elementName.moduleName;
    appItemInfo.appIndex = info.applicationInfo?.appIndex;
    appItemInfo.shortcutId = '';
    appItemInfo.installSource = info.applicationInfo?.installSource;
    if (isPackAdd && info.installTime === 0) {
      appItemInfo.installTime = String(new Date(parseInt(Date.now().toString().padEnd(PAG_END, '0'))));
      log.showInfo('installTime:%{public}s', appItemInfo.installTime);
    } else {
      appItemInfo.installTime = String(new Date(parseInt(info.installTime.toString().padEnd(PAG_END, '0'))));
    }
    appItemInfo.areaType = CommonConstants.TYPE_AREA_APP_CENTER;
    appItemInfo.bundleType = bundleManager.BundleType.APP;
    appItemInfo.appStatus = AppStatus.INSTALLED;
    appItemInfo.keyName = AppItemInfo.getKeyName(appItemInfo);
    if (!this.isIgnoreApp(appItemInfo)) {
      this.mAppMap.set(this.getCacheKey(appItemInfo.bundleName, appItemInfo.appIndex ?? 0), appItemInfo);
    }
    if (info?.applicationInfo?.multiAppMode?.multiAppModeType === bundleManager.MultiAppModeType.MULTI_INSTANCE) {
      appItemInfo.enableNewAppInstance = true;
    }
  }

  /**
   * uninstall application, notice the userId need to be the login user
   *
   * @params bundleName application bundleName
   * @params callback to get result
   * @params appIndex application appIndex
   */
  async uninstallLauncherAbility(bundleName: string, callback: Function, appIndex?: number,
    forceUninstall?: boolean): Promise<void> {
    log.showInfo(`uninstallLauncherAbility bundleName: ${bundleName}`);
    if (appIndex && appIndex > 0) {
      let result: ResponseCode = {
        code: CommonConstants.INVALID_VALUE,
        errorCode: ERROR_CODE
      };
      try {
        let bundlerInstaller = await installer.getBundleInstaller();
        let param: installer.DestroyAppCloneParam = {
          userId: this.mUserId,
          parameters: [
            {
              key: 'ohos.bms.param.verifyUninstallRule',
              value: forceUninstall ? 'false' : 'true'
            }
          ]
        };
        bundlerInstaller.destroyAppClone(bundleName, appIndex, param).then(() => {
          result.code = CommonConstants.UNINSTALL_SUCCESS;
          callback(bundleName, result, appIndex);
        }).catch((error: BusinessError) => {
          result.errorCode = error.code;
          log.error(`destroyAppClone failed: ${error.message}, error.code: ${error.code}`);
          callback(bundleName, result, appIndex);
        });
      } catch (error) {
        log.error('getBundleInstaller failed. Cause: ' + error.message);
        callback(bundleName, result, appIndex);
      }
    } else {
      this.uninstallFromBms(bundleName, callback, appIndex, forceUninstall);
    }
  }

  async uninstallFromBms(bundleName: string, callback: Function, appIndex?: number,
    forceUninstall?: boolean): Promise<void> {
    let result: ResponseCode = {
      code: CommonConstants.INVALID_VALUE,
      errorCode: ERROR_CODE
    };
    let installParam: installer.InstallParam = {
      userId: this.mUserId,
      installFlag: 0,
      isKeepData: false,
      parameters: [
        {
          key: 'ohos.bms.param.verifyUninstallRule',
          value: forceUninstall ? 'false' : 'true'
        }
      ]
    };
    try {
      let bundlerInstaller = await installer.getBundleInstaller();
      bundlerInstaller.uninstall(bundleName, installParam, (error: BusinessError) => {
        if (error) {
          log.error(`uninstall failed: ${error.message}, error.code: ${error.code}`);
          result.errorCode = error.code;
          callback(bundleName, result, appIndex);
        } else {
          log.showInfo(`uninstall start callback`);
          result.code = CommonConstants.UNINSTALL_SUCCESS;
          callback(bundleName, result, appIndex);
        }
      });
    } catch (error) {
      let message = (error as BusinessError).message;
      log.error(`getBundleInstaller failed. cause: ${message}`);
      callback(bundleName, result, appIndex);
    }
  }

  async getShortcutInfo(paramBundleName: string, callback: shortCutFuncType): Promise<void> {
    log.showInfo(`launcherBundleManager getShortcutInfo bundleName: ${paramBundleName}`);
    try {
      await launcherBundleManager.getShortcutInfo(paramBundleName)
        .then(shortcutInfo => callback(paramBundleName, shortcutInfo));
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      log.showError(`getShortcutInfo error, code: ${code}, message: ${message}`);
    }
  }

  /**
   * 从包管理同步获取快捷方式信息
   *
   * @param bundleName 查询的包名
   * @param callback 回调函数
   */
  public getShortcutInfoSync(bundleName: string,
    callback: (bundleName: string, shortcutInfoList: ShortcutInfo[]) => void): void {
    log.showInfo(`launcherBundleManager getShortcutInfoSync bundleName: ${bundleName}`);
    let shortcutInfo: ShortcutInfo[] = [];
    try {
      shortcutInfo = launcherBundleManager.getShortcutInfoSync(bundleName);
    } catch (err) {
      log.showError(`getShortcutInfoSync error, code: ${err?.code}  message: ${err?.message}`);
    }

    if (callback) {
      callback(bundleName, shortcutInfo);
    }
  }

  /**
   * 从包管理同步获取快捷方式信息
   *
   * @param bundleName 查询的包名
   * @returns 快捷方式信息列表
   */
  public getShortcutInfoByBundleNameSync(bundleName: string): ShortcutInfo[] {
    log.showInfo(`launcherBundleManager getShortcutInfoByBundleNameSync bundleName: ${bundleName}`);
    let shortcutInfo: ShortcutInfo[] = [];
    try {
      shortcutInfo = launcherBundleManager.getShortcutInfoSync(bundleName);
    } catch (err) {
      log.showError(`getShortcutInfoByBundleNameSync error, code: ${err?.code}  message: ${err?.message}`);
    }
    return shortcutInfo;
  }

  cleanAppMapCache(): void {
    this.mAppMap.clear();
  }
}

export const launcherAbilityManager = LauncherAbilityManager.getInstance();

export interface BaseInfo {
  bundleName: string,
  userId: number,
  appIndex?: number
}

export class ResponseCode {
  public code: number = -1;
  public errorCode: number = -1
}