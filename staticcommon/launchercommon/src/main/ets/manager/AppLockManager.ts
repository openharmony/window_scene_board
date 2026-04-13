/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
// import appLock from '@hms.security.appLock';
import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { AccountMgr, SystemParamUtils } from '@ohos/frameworkwrapper';

const TAG = 'AppLockManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const MAIN_USER_ID = 100;
const UNDEFINED_USER_ID = -1;
const SYS_PARM_APP_LOCK_ENABLE_KEY = 'const.appsecurityprivacy.applock.feature_enabled';
const APP_LOCK_SUPPORT = '1';
const APP_LOCK_NOT_SUPPORT = '0';
const MAX_RETRY_TIMES: number = 5;
const RETRY_INTERVAL_MS: number = 1000;

/**
 * 用于处理应用锁的单例类
 */
export class AppLockManager {
  private static mAppLockManager: AppLockManager;

  // 应用锁状态监听集
  private appLockListeners: Set<AppLockChangeListener> = new Set();

  private cache: Map<string, boolean> = new Map();

  private uninstallLockedApp: string = '';

  /**
   * 白名单应用(不展示上锁解锁), bundleName缓存
   */
  private exemptedCache: Set<string> = new Set();

  private currentUserId: number = UNDEFINED_USER_ID;

  private isSupportDevice: boolean = false;

  // private switchStateChangeCallback = (appSwitchStates: Array<appLock.SwitchState>): void => {
  //   if (!Array.isArray(appSwitchStates)) {
  //     log.showWarn(TAG, 'appSwitchStates callback return undefined data');
  //     return;
  //   }
  //   appSwitchStates.forEach(appSwitchState => {
  //     if (appSwitchState === undefined || appSwitchState === null) {
  //       log.showWarn(TAG, 'appSwitchState is undefined');
  //       return;
  //     }
  //     let cacheKey: string =
  //       this.getCacheKey(appSwitchState.appInfo.bundleName, appSwitchState.appInfo.appIndex, appSwitchState.userId);
  //     log.showInfo(TAG, 'appSwitchStates callback....cacheKey:  %{public}s, isOn: %{public}s', cacheKey,
  //       appSwitchState.isOn);
  //     if (appSwitchState.isOn) {
  //       this.cache.set(cacheKey, true);
  //     } else {
  //       this.cache.delete(cacheKey);
  //     }
  //     // 状态回调
  //     this.appLockListeners.forEach((li) => li?.onSingleAppLockStatusChange(cacheKey, appSwitchState.isOn));
  //   });
  //   AppStorage.setOrCreate('onAppLockCache', this.cache);
  // };

  private constructor() {
  }

  /**
   * 初始化AppLockManager
   */
  public async init(): Promise<void> {
    try {
      this.currentUserId = await AccountMgr.getCurrentAccountId();
    } catch (err) {
      log.showError(TAG, 'getCurrentAccountId catch error');
      // userId查询失败直接返回
      return;
    }
    log.showInfo('getCurrentAccountId userId:  %{public}s', this.currentUserId.toString());
    // 0 -- 不支持, 1 -- 支持
    this.isSupportDevice =
      SystemParamUtils.getSystemParam(SYS_PARM_APP_LOCK_ENABLE_KEY, APP_LOCK_NOT_SUPPORT) === APP_LOCK_SUPPORT;
    if (!this.isSupportDevice) {
      log.showInfo(TAG, 'init, current devices is not support');
      return;
    }
    this.updateAllAppLockStatus();
    this.updateExemptedBundleInfos(MAX_RETRY_TIMES);
  }

  /**
   * 获取单例对象
   * @returns AppLockManager
   */
  public static getInstance(): AppLockManager {
    if (!AppLockManager.mAppLockManager) {
      AppLockManager.mAppLockManager = new AppLockManager();
    }
    return AppLockManager.mAppLockManager;
  }

  /**
   * 获取应用的缓存key值
   * @param bundleName 包名
   * @param appIndex appIndex
   * @param userId 当前userId
   * @returns string 缓存key值
   */
  private getCacheKey(bundleName: string, appIndex: number, userId: number): string {
    return `${bundleName}_${appIndex}_${userId}`;
  }

  /**
   * 获取应用缓存key值
   *
   * @param bundleName 应用包名
   * @param appIndex 应用分身ID
   * @returns key值
   */
  public getAppKey(bundleName: string, appIndex: number): string {
    return this.getCacheKey(bundleName, appIndex, this.currentUserId);
  }

  /**
   * 根据应用信息获取应用是否加锁
   * @param bundleName 包名
   * @param appIndex
   * @returns AppLockStatusEnum 加锁状态与展示信息
   */
  public getAppLockStatus(bundleName: string, appIndex: number): AppLockStatusEnum {
    if (!this.isSupportDevice) {
      log.showInfo(TAG, 'current devices is not support');
      return AppLockStatusEnum.NOT_DISPLAY;
    }
    if (this.currentUserId !== MAIN_USER_ID) {
      log.showInfo(TAG, 'currentUserId is not main user, not display');
      return AppLockStatusEnum.NOT_DISPLAY;
    }
    if (this.exemptedCache.has(bundleName)) {
      log.showInfo(TAG, 'exempted app: %{public}s, not display', bundleName);
      return AppLockStatusEnum.NOT_DISPLAY;
    }
    let cacheKey: string = this.getCacheKey(bundleName, appIndex, this.currentUserId);
    let isLocked: boolean | undefined = this.cache.get(cacheKey);
    return isLocked ? AppLockStatusEnum.LOCK : AppLockStatusEnum.UNLOCK;
  }

  /**
   * 刷新缓存中存储的应用上锁信息
   */
  private async updateAllAppLockStatus(): Promise<void> {
    this.cache.clear();

    // let lockedAppInfos: appLock.AppInfo[] = [];
    // try {
    //   lockedAppInfos = await appLock.getSwitchEnabledAppInfos(this.currentUserId);
    // } catch (err) {
    //   log.showError(TAG, 'getSwitchEnabledAppInfos failed, code: %{public}d, message: %{public}s', err?.code, err?.message);
    //   return;
    // }
    // lockedAppInfos.forEach((lockedAppInfo: appLock.AppInfo) => {
    //   if (lockedAppInfo === undefined || lockedAppInfo === null) {
    //     log.showWarn(TAG, 'lockedAppInfo is undefined');
    //     return;
    //   }
    //   let cacheKey: string =
    //     this.getCacheKey(lockedAppInfo.bundleName, lockedAppInfo.appIndex, this.currentUserId);
    //   log.showInfo('lockedAppInfos cacheKey: %{public}s', cacheKey);
    //   this.cache.set(cacheKey, true);
    // });
    AppStorage.setOrCreate('onAppLockCache', this.cache);
    // 状态回调
    this.appLockListeners.forEach((li) => li?.onAllAppLockStatusChange(this.cache));
    // log.showInfo(TAG, 'updateAllAppLockStatus success, lockedApp num: %{public}s', lockedAppInfos.length.toString());
  }

  /**
   * 刷新缓存中存储的白名单应用
   */
  private async updateExemptedBundleInfos(retryTimes: number): Promise<void> {
    log.showWarn(TAG, `updateExemptedBundleInfos, retryTime: ${retryTimes}`);
    if (retryTimes <= 0) {
      log.showError(TAG, `retry times run out`);
      return;
    }
    this.exemptedCache.clear();
    // let exemptedBundleInfos: appLock.BundleInfo[] = [];
    // try {
    //   // 白名单应用查询
    //   exemptedBundleInfos = await appLock.getExemptedBundleInfos(this.currentUserId);
    //   if (exemptedBundleInfos === undefined || exemptedBundleInfos === null) {
    //     log.showWarn(TAG, 'getExemptedBundleInfos return undefined data');
    //     return;
    //   }
    // } catch (err) {
    //   log.showError(TAG, 'getExemptedBundleInfos failed, code: %{public}d, message: %{public}s', err?.code, err?.message);
    //   setTimeout(() => {
    //     this.updateExemptedBundleInfos(--retryTimes);
    //   }, RETRY_INTERVAL_MS);
    //   return;
    // }
    // log.showWarn(TAG, `exempted list length: ${exemptedBundleInfos}`);
    // for (let i = 0; i < exemptedBundleInfos.length; i++) {
    //   let exemptedInfo: appLock.BundleInfo = exemptedBundleInfos[i];
    //   if (exemptedInfo === undefined || CommonUtils.isEmpty(exemptedInfo.bundleName)) {
    //     log.showWarn(TAG, 'exemptedInfo or exemptedInfo.bundleName is invalid');
    //     continue;
    //   }
    //   log.showWarn(TAG, 'exempted bundle: %{public}s', exemptedInfo.bundleName);
    //   this.exemptedCache.add(exemptedInfo.bundleName);
    // }
    // 状态回调
    this.appLockListeners.forEach((li) => li?.onExemptedBundleChange(this.exemptedCache));
  }

  /**
   * 注册监听应用上锁信息
   */
  public registerAppLock(): void {
    log.showInfo(TAG, 'registerAppLock start');
    try {
      // appLock.on('switchStateChange', this.switchStateChangeCallback);
    } catch (err) {
      log.showError(TAG, 'switchStateChange registerAppLock failed, code: %{public}d, message: %{public}s', err?.code,
        err?.message);
    }
  }

  /**
   * 解注册监听
   */
  public unregisterAppLock(): void {
    log.showInfo(TAG, 'unregisterAppLock start');
    try {
      // appLock.off('switchStateChange', this.switchStateChangeCallback);
    } catch (err) {
      log.showError(TAG, 'switchStateChange unregisterAppLock failed, code: %{public}d, message: %{public}s', err?.code,
        err?.message);
    }
  }

  /**
   * 注册应用锁状态监听
   *
   * @param li 监听器
   */
  public registerStatusListener(li: AppLockChangeListener): void {
    if (li) {
      this.appLockListeners.add(li);
      // 初始化回调
      li.onExemptedBundleChange(this.exemptedCache);
      li.onAllAppLockStatusChange(this.cache);
    }
  }

  /**
   * 注销应用锁状态监听
   *
   * @param li 监听器
   */
  public unregisterStatusListener(li: AppLockChangeListener): void {
    if (li) {
      this.appLockListeners.delete(li);
    }
  }

  /**
   * 记录加锁应用bundleName
   */
  public setUninstallLockedAppBundleName(bundleName: string): void {
    this.uninstallLockedApp = bundleName;
  }

  /**
   * 获取加锁应用bundleName
   */
  public getUninstallLockedAppBundleName(): string {
    return this.uninstallLockedApp;
  }
}

export enum AppLockStatusEnum {
  NOT_DISPLAY = 'NOT_DISPLAY',
  LOCK = 'LOCK',
  UNLOCK = 'UNLOCK',
}

// 应用锁状态监听
export interface AppLockChangeListener {
  /**
   * 应用锁白名单应用包名集切换回调
   *
   * @param exemptedSet 白名单集(应用包名)
   */
  onExemptedBundleChange(exemptedSet: Set<string>): void;

  /**
   * 开启应用锁的所有应用切换回调
   *
   * @param appLockMap 开启应用锁集(应用key - 应用锁开关)
   */
  onAllAppLockStatusChange(appLockMap: Map<string, boolean>): void;

  /**
   * 单个应用的应用锁状态切换回调
   *
   * @param appKey 应用key
   * @param isAppLockOn true应用锁开启
   */
  onSingleAppLockStatusChange(appKey: string, isAppLockOn: boolean): void;
}