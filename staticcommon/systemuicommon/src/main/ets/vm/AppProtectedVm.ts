/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
// import appLock from '@hms.security.appLock';
import osAccount from '@ohos.account.osAccount';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '../maintenance/CommonExceptionCode';
import { StatisticsMaintenance } from '../maintenance/StatisticsMaintenance';

const log = LogHelper.getLogHelper(LogDomain.NC, 'AppProtectedVm');

/**
 * 应用加锁后的保护状态监控类
 */
@Observed
export class AppProtectedVm {
  private userId: number = 100;
  /**
   * 获取实例
   */
  public static get = SingletonHelper.createFactory(() => new AppProtectedVm());
  /**
   * 保护状态应用缓存列表
   */
  public protectedAppSet: Set<string> = new Set();
  /**
   * 查询应用是否处于保护状态
   * @param bundleIdxKey 包名_索引
   * @returns
   */
  public isProtected(bundleIdxKey: string): boolean {
    if (!bundleIdxKey) {
      return false;
    }
    return AppProtectedVm.get().protectedAppSet.has(bundleIdxKey);
  }
  /**
   * 初始化
   * @returns
   */
  public async init(): Promise<void> {
    try {
      log.showInfo('start init protected app list');
      this.initUserId();
      // appLock.on('appProtectedStateChange', this.onAppProtectedStateCB);
      await this.initProtectedStateMap();
      log.showInfo('protected app list init end');
    } catch (e) {
      LogWithHa.error(log, `AppProtectedVm --> init protected app list err ${e}`,
        CommonExceptionCode.INIT_APP_PROTECTED_FAIL, e);
    }
  }

  private async initProtectedStateMap(): Promise<void> {
    // const protectedAppList = await appLock.getProtectedAppInfos(this.userId);
    // let appProtectedSet = AppProtectedVm.get().protectedAppSet;
    // for (let appInfo of protectedAppList) {
    //   appProtectedSet.add(`${appInfo.bundleName}_${appInfo.appIndex}`);
    //   log.showInfo('init %{public}s_%{public}d protected status to true', appInfo.bundleName, appInfo.appIndex);
    // }
    // AppProtectedVm.get().protectedAppSet = new Set(appProtectedSet);
  }

  private initUserId(): void {
    const uid = GlobalContext.getContext().applicationInfo.uid;
    this.userId = osAccount.getAccountManager().getOsAccountLocalIdForUidSync(uid);
    log.showInfo(`userId:${this.userId}`);
  }

  // onAppProtectedStateCB = (appProtectedStates: Array<appLock.AppProtectedState>): void => {
  //   log.showWarn(`get appProtectedStateChange: ${appProtectedStates.length}`);
  //   let appProtectedSet = AppProtectedVm.get().protectedAppSet;
  //   for (let state of appProtectedStates) {
  //     const key = `${state.appInfo.bundleName}_${state.appInfo.appIndex}`;
  //     if (appProtectedSet.has(key) && !state.isProtected) {
  //       appProtectedSet.delete(key);
  //       log.showInfo('update %{public}s_%{public}d protected status to false', state.appInfo.bundleName, state.appInfo.appIndex);
  //     } else if (state.isProtected) {
  //       appProtectedSet.add(key);
  //       log.showInfo('update %{public}s_%{public}d protected status to true', state.appInfo.bundleName, state.appInfo.appIndex);
  //     }
  //   }
  //   AppProtectedVm.get().protectedAppSet = new Set(appProtectedSet);
  //   StatisticsMaintenance.get().protectedAppSet = new Set(appProtectedSet);
  // };
}