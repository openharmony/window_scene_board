/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import formHost from '@ohos.app.form.formHost';
import { AccountMgr, GlobalContext, SystemParamUtils } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CardItemInfo } from '../TsIndex';
const TAG = 'CardLockManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SYS_PARM_APP_LOCK_ENABLE_KEY = 'const.appsecurityprivacy.applock.feature_enabled';
const APP_LOCK_SUPPORT = '1';
const APP_LOCK_NOT_SUPPORT = '0';
const LOCK_SCREEN_OR_EXIST_APP = 1;
const GET_APP_LOCK_CONDITION_ERROR_CODE = -1;

export default class CardLockManager {
  private static mCardLockManager: CardLockManager;
  private currentUserId: number = -1;
  private isSupportDevice: boolean = false;
  private cache: Map<string, Set<string>> = new Map(); //记录已经解除蒙版的cardId
  private cacheProtected: Map<string, Set<string>> = new Map(); //记录主应用是否暂时解除保护
  private dealingAppLockState: boolean = false; // 是否正在处理主应用加锁移除锁事件

  private constructor() {
  }

  /**
   * 初始化CardLockManager
   */
  public async init(): Promise<void> {
    try {
      this.currentUserId = await AccountMgr.getCurrentAccountId();
      this.loadLockedApp();
    } catch (err) {
      log.showError('getCurrentAccountId catch error');
      // userId查询失败直接返回
      return;
    }
    this.isSupportDevice =
      SystemParamUtils.getSystemParam(SYS_PARM_APP_LOCK_ENABLE_KEY, APP_LOCK_NOT_SUPPORT) === APP_LOCK_SUPPORT;
    if (!this.isSupportDevice) {
      log.showInfo('init, current devices is not support');
      return;
    }
  }

  private async loadLockedApp(): Promise<void> {
    this.cache = new Map<string, Set<string>>();
    // const protectedAppList = await appLock.getProtectedAppInfos(this.currentUserId);
    // for (let appInfo of protectedAppList) {
    //   if (!appInfo.appIndex) {
    //     // 分身应用不支持应用锁
    //     this.cache.set(this.getCacheKey(appInfo.bundleName, this.currentUserId), new Set());
    //   }
    // }
  }

  /**
   * 获取单例对象
   * @returns CardLockManager
   */
  public static getInstance(): CardLockManager {
    if (!CardLockManager.mCardLockManager) {
      CardLockManager.mCardLockManager = new CardLockManager();
    }
    return CardLockManager.mCardLockManager;
  }

  // private appProtectedStateChange = async (appProtectedStates: Array<appLock.AppProtectedState>): Promise<void> => {
  //   if (this.dealingAppLockState) {
  //     log.showInfo('get appProtectedStateChange , but is dealingAppLockState, return');
  //     this.dealingAppLockState = false;
  //     return;
  //   }
  //   for (let state of appProtectedStates) {
  //     if (state.appInfo.appIndex) {
  //       // 分身应用不响应
  //       continue;
  //     }
  //     //获取是否 退后台即锁定
  //     const result: number = await appLock.getAppLockCondition?.(this.currentUserId)?.catch((err: Error) => {
  //       log.showError('getAppLockCondition failed, message: %{public}s', err?.message);
  //       return GET_APP_LOCK_CONDITION_ERROR_CODE;
  //     });
  //     const key = this.getCacheKey(state.appInfo.bundleName, this.currentUserId);
  //     log.showInfo('getAppLockCondition result is %{public}d; bundleName = %{public}s; state.isProtected = %{public}s; size = %{public}s;',
  //       result, state.appInfo.bundleName, String(state.isProtected), String(this.cacheProtected.get(key)?.size));
  //     // 退后台即锁定, 不做任何处理
  //     if (result === LOCK_SCREEN_OR_EXIST_APP) {
  //       let tmpCache = this.cacheProtected.get(key);
  //       if (tmpCache) { // 需要清空cacheProtected
  //         this.cache.set(key, tmpCache);
  //         this.cacheProtected.delete(key);
  //       }
  //       return;
  //     }
  //     if (!state.isProtected) {
  //       if (this.cache.get(key)) {
  //         this.cacheProtected.set(key, this.cache.get(key));
  //         this.cache.delete(key);
  //       }
  //     } else if (state.isProtected) {
  //       let tmpCache = this.cacheProtected.get(key);
  //       if (tmpCache) {
  //         this.cache.set(key, tmpCache);
  //         this.cacheProtected.delete(key);
  //       }
  //     }
  //   }
  // };

  // private switchStateChangeCallback = (appSwitchStates: Array<appLock.SwitchState>): void => {
  //   if (!Array.isArray(appSwitchStates)) {
  //     log.showWarn('appSwitchStates callback return undefined data');
  //     return;
  //   }
  //   appSwitchStates.forEach(appSwitchState => {
  //     if (appSwitchState === undefined || appSwitchState === null) {
  //       log.showWarn('appSwitchState is undefined');
  //       return;
  //     }
  //     if (appSwitchState.appInfo.appIndex) {
  //       // 分身应用不支持应用锁
  //       log.showWarn('not main app');
  //       return;
  //     }
  //     let bundleName: string = appSwitchState.appInfo.bundleName;
  //     let userId: number = appSwitchState.userId;
  //     let cacheKey: string = this.getCacheKey(bundleName, userId);
  //     this.dealingAppLockState = true;
  //     if (appSwitchState.isOn) {
  //       this.cache.set(cacheKey, new Set());
  //     } else {
  //       this.cacheProtected.delete(cacheKey);
  //       this.cache.delete(cacheKey);
  //     }
  //   });
  // };

  /**
   * 登记已经解除蒙版的cardId
   * @param bundleName 包名
   * @param cardId 卡片ID
   * @returns void
   */
  public addReleasedForm(bundleName: string, cardId: string): void {
    let cacheKey: string = this.getCacheKey(bundleName, this.currentUserId);
    let cardIs: Set<string> | undefined = this.cache.get(cacheKey);
    if (!cardIs) {
      return;
    }
    cardIs.add(cardId);
  }

  private getCacheKey(bundleName: string, userId: number): string {
    return `${bundleName}_${userId}`;
  }

  /**
   * 注册监听应用上锁信息
   */
  public registerAppLock(): void {
    log.showInfo('register CardLockManager start');
    try {
      // // 主应用加锁/刪除锁
      // appLock.on('switchStateChange', this.switchStateChangeCallback);
      // // 主应用进入输入密码暂时解除保护/锁屏恢复保护
      // appLock.on('appProtectedStateChange', this.appProtectedStateChange);
    } catch (err) {
      log.showError('switchStateChange register CardLockManager failed, code: %{public}d, message: %{public}s',
        err?.code, err?.message);
    }
  }

  /**
   * 解注册监听
   */
  public unregisterAppLock(): void {
    log.showInfo('unregister CardLockManager start');
    try {
      // appLock.off('switchStateChange', this.switchStateChangeCallback);
      // appLock.off('appProtectedStateChange', this.appProtectedStateChange);
    } catch (err) {
      log.showError('switchStateChange unregister CardLockManager failed, code: %{public}d, message: %{public}s',
        err?.code, err?.message);
    }
  }

  /**
   * 卡片移除-删除缓存
   * @param cardId
   */
  public deleteCacheByCardId(cardId: string): void {
    log.showInfo('delete cache cardId = ' + cardId);
    if (!cardId) {
      return;
    }
    for (let key in this.cache) {
      this.cache[key].delete(cardId);
      this.cacheProtected[key].delete(cardId);
    }
  }

  /**
   * 获取卡片是否解除蒙版(释放)
   * @param bundleName 包名
   * @param cardId 卡片ID
   * @returns boolean
   */
  public getLockedCardIsReleased(bundleName: string, cardId: string): boolean {
    let cacheKey: string = this.getCacheKey(bundleName, this.currentUserId);
    let set = this.cache.get(cacheKey);
    return (set && set.has(cardId)) ?? false;
  }

  /**
   * 获取主应用是否有应用锁
   * @param bundleName 包名
   * @returns boolean
   */
  public mainAppHasLock(bundleName: string): boolean {
    return this.cache.has(this.getCacheKey(bundleName, this.currentUserId));
  }

  /**
   * 修改卡片锁状态
   * @param formInfo: CardItemInfo
   * @returns boolean
   */
  public async updateCardLockStatus(formInfo: CardItemInfo): Promise<void> {
    let cacheKey: string = this.getCacheKey(formInfo.bundleName, this.currentUserId);
    let cardIs: Set<string> | undefined = this.cache.get(cacheKey);
    if (!cardIs) {
      log.showInfo(`cache of ${cacheKey} is undefined`);
      return;
    }
    let isReleased = this.getLockedCardIsReleased(formInfo.bundleName, formInfo.cardId);
    formHost.updateFormLockedState?.(formInfo.cardId, isReleased)
      .then(() => {
        log.showInfo('update card status success ');
        if (isReleased) {
          cardIs?.delete(formInfo.cardId);
          log.showInfo(`delete cache formInfo.cardId = ${formInfo.cardId}`);
        } else {
          cardIs?.add(formInfo.cardId);
          log.showInfo(`add cache formInfo.cardId = ${formInfo.cardId}`);
        }
      }).catch((e: Error) => {
        log.showInfo('update card status fail e = ' + JSON.stringify(e));
      });
  }
}