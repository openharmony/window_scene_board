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

import { CacheManager } from '../manager/CacheManager';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PackageCommonEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import {
  AppItemInfo,
  CommonConstants,
  GridLayoutItemInfo,
  launcherAbilityManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import Account from '@ohos.account.osAccount';
import osAccount from '@ohos.account.osAccount';
import { CommonEventData } from 'commonEvent/commonEventData';

const TAG = 'appInstall_AccountChangeListener';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MAIN_USERID = 100;

interface CustomEventData extends CommonEventData {
  uid: number,
  bundleName: string,
  userId: number,
  isModuleUpdate: boolean,
  bundleType: number,
  atomicServiceModuleUpgrade: number,
  isEnableDynamicIcon: boolean,
  appIndex: number,
  event: string
}
/**
 * 用户切换监听
 */
export class AccountChangeListener {
  private static mInstance: AccountChangeListener;
  private mUserId: number = MAIN_USERID; // 当前默认100用户
  private accountSwitchedEvent = (switchData: osAccount.OsAccountSwitchEventData) => {
    this.dealAccountSwitched(switchData);
  };

  private constructor() {
  }

  static getInstance(): AccountChangeListener {
    if (!AccountChangeListener.mInstance) {
      AccountChangeListener.mInstance = new AccountChangeListener();
    }
    return AccountChangeListener.mInstance;
  }

  public getUserId(): number {
    return this.mUserId;
  }

  /**
   * 初始化该类
   */
  public init(): void {
    try {
      Account.getAccountManager().getOsAccountLocalId().then((userId: number) => {
        this.mUserId = userId;
        log.showWarn('init userId:%{public}d', userId);
      });
    } catch (error) {
      log.showError(`osAccount error -> getAccountManagerOn switched. code ${error?.code}`);
    }
  }

  private dealAccountSwitched(switchData: osAccount.OsAccountSwitchEventData): void {
    if (!switchData) {
      log.showWarn('receive user switched return, switchData is undefined');
      return;
    }
    log.showWarn('receive user switched. current user:%{public}d, <%{public}d -> %{public}d>',
      this.mUserId, switchData.fromAccountId, switchData.toAccountId);
    if (this.mUserId === switchData.fromAccountId) {
      return;
    }
    this.onAccountSwitched();
  }

  private async onAccountSwitched(): Promise<boolean> {
    let installedApps: AppItemInfo[] =
      await launcherAbilityManager.getLauncherAbilityList(this.mUserId);
    if (!installedApps || installedApps.length === 0) {
      return false;
    }
    let installedAppMaps: Map<string, AppItemInfo> = new Map<string, AppItemInfo>();
    installedApps.forEach((item: AppItemInfo) => {
      if (item.keyName) {
        installedAppMaps.set(item.keyName, item);
      }
    });
    let appList: GridLayoutItemInfo[] = CacheManager.getInstance().getAllGridLayoutItemList();
    appList.forEach((item: GridLayoutItemInfo) => {
      if (item.typeId === CommonConstants.TYPE_APP) {
        this.checkAppLabelIdIconId(item, installedAppMaps);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
        item.layoutInfo?.flat().forEach(item => this.checkAppLabelIdIconId(item, installedAppMaps));
      }
    });
    return true;
  }

  private checkAppLabelIdIconId(item: GridLayoutItemInfo, installedAppMaps: Map<string, AppItemInfo>): void {
    if (item.typeId !== CommonConstants.TYPE_APP || item.appIndex !== CommonConstants.MAIN_APP_INDEX) {
      return;
    }
    let bmsApp = installedAppMaps.get(this.getKeyName(item));
    if (bmsApp && (bmsApp.appLabelId !== item.appLabelId || bmsApp.appIconId !== item.appIconId)) {
      log.showWarn('app[%{public}s] has updated', item.bundleName);
      let customEventData : CustomEventData= {
        uid: 0,
        bundleName: item.bundleName,
        userId: this.mUserId,
        isModuleUpdate: false,
        bundleType: 0,
        atomicServiceModuleUpgrade: 0,
        isEnableDynamicIcon: false,
        appIndex: 0,
        event: PackageCommonEvent.EVENT_PACKAGE_CHANGED
      };
      let commonEvent: PackageCommonEvent = new PackageCommonEvent(customEventData);
      CacheManager.getInstance().appAddedOrUpdated(commonEvent, item.bundleName);
    }
  }

  private getKeyName(item: GridLayoutItemInfo): string {
    if (CheckEmptyUtils.isEmpty(item)) {
      return '';
    }
    return `${item.bundleName}${item.abilityName}${item.moduleName}${item.appIndex ?? 0}${item.shortcutId ?? ''}`;
  }
}