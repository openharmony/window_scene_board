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

// import appLock from '@ohos.security.appLock';
import osAccount from '@ohos.account.osAccount';
import { Singleton } from '../utils/Singleton';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { StatisticsMaintenance } from '../maintenance/StatisticsMaintenance';

const log = LogHelper.getLogHelper(LogDomain.NC, 'AppProtectedStatusVm');

/**
 * 应用加锁后的保护状态监控类, 使用ObservedV2实现
 */
@ObservedV2
export class AppProtectedStatusVm {
  @Singleton.decorate() public static get instance() { return new AppProtectedStatusVm(); }
  /**
   * 保护状态应用缓存列表
   */
  @Trace public protectedAppSet: Set<string> = new Set();

  private userId: number = 100;
  /**
   * 查询应用是否处于保护状态
   * @param bundleIdxKey 包名_索引
   * @returns
   */
  public isProtected(bundleName: string, appIndex: number): boolean {
    const bundleIdxKey = `${bundleName}_${appIndex}`;
    return this.protectedAppSet.has(bundleIdxKey);
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
      log.error('AppProtectedVm --> init protected app list err', e);
    }
  }

  private async initProtectedStateMap(): Promise<void> {
    // const protectedAppList:ESObject = await appLock.getProtectedAppInfos(this.userId);
    // for (let appInfo of protectedAppList) {
    //   const key = `${appInfo.bundleName}_${appInfo.appIndex}`;
    //   log.showWarn('init update protected status for %{public}s to true', key);
    //   this.protectedAppSet.add(key);
    // }
    // log.showInfo(`initProtectedStateMap size:${this.protectedAppSet.size}`);
  }

  private initUserId(): void {
    const uid = GlobalContext.getContext().applicationInfo.uid;
    this.userId = osAccount.getAccountManager().getOsAccountLocalIdForUidSync(uid);
    log.showInfo(`userId:${this.userId}`);
  }

  // public onAppProtectedStateCB = (appProtectedStates: Array<appLock.AppProtectedState>): void => {
  //   log.showWarn(`get appProtectedStateChange: ${appProtectedStates.length}`);
  //   for (let state of appProtectedStates) {
  //     const key = `${state.appInfo.bundleName}_${state.appInfo.appIndex}`;
  //     if (!state.isProtected) {
  //       log.showWarn('update protected status for %{public}s to false', key);
  //       this.protectedAppSet.delete(key);
  //     } else {
  //       log.showWarn('update protected status for %{public}s to true', key);
  //       this.protectedAppSet.add(key);
  //     }
  //   }
  //   StatisticsMaintenance.get().protectedAppSet = new Set(this.protectedAppSet);
  //   log.showInfo(`cur protected size:${this.protectedAppSet.size}`);
  // };
}