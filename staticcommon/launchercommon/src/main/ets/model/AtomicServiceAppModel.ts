/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import atomicServiceAbilityManager from '../manager/AtomicServiceAbilityManager';
import SystemApplication from '../configs/SystemApplication';
import { CommonConstants } from '../constants/CommonConstants';
import type { AppItemInfo } from '../bean/AppItemInfo';
import { FormModel } from './FormModel';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { IconResourceManager } from '@ohos/frameworkwrapper';
import { StateChangeType } from './AppModel';

const TAG = 'AtomicServiceAppModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Desktop application information data model.
 */
export class AtomicServiceAppModel {
  private mAtomicServiceBundleInfoList: AppItemInfo[] = [];
  private readonly mSystemApplicationName: string[] = [];
  private readonly mAppStateChangeListener: StateChangeType[] = [];
  private readonly mFormModel: FormModel;
  private static mInstance: AtomicServiceAppModel;

  private constructor() {
    log.showInfo('constructor start');
    this.mSystemApplicationName = SystemApplication.systemApplicationName.split(',');
    this.mFormModel = FormModel.getInstance();
  }

  /**
   * Get the application data model object.
   *
   * @return {object} application data model singleton
   */
  static getInstance(): AtomicServiceAppModel {
    if (AtomicServiceAppModel.mInstance == null) {
      AtomicServiceAppModel.mInstance = new AtomicServiceAppModel();
      globalThis.AtomicServiceAppModel = AtomicServiceAppModel.mInstance;
    }
    return AtomicServiceAppModel.mInstance;
  }

  /**
   * get AppInfo
   *
   * @param bundleName : bundlerName
   * @returns appInfo
   */
  public getAtomicInfoByBundleName(bundleName: string) : AppItemInfo | undefined {
    return this.mAtomicServiceBundleInfoList.find(item => bundleName === item.bundleName);
  }

  public getDesktopAtomicBundle(): Set<string> {
    let atomicBundleList: Set<string> = new Set<string>(this.mAtomicServiceBundleInfoList.map(item => item.bundleName));
    log.showInfo(`atomicBundleList length: ${atomicBundleList.size}`);
    return atomicBundleList;
  }

  /**
   * Get the list of apps displayed on the desktop.
   * (public function, reduce the frequency of method call)
   *
   * @return {array} bundleInfoList
   */
  async getAtomicServiceAppList(): Promise<AppItemInfo[]> {
    log.showInfo('getAtomicServiceAppList start');
    if (!CheckEmptyUtils.isEmptyArr(this.mAtomicServiceBundleInfoList)) {
      log.showInfo(`getAtomicServiceAppList bundleInfoList length: ${this.mAtomicServiceBundleInfoList.length}`);
      return this.mAtomicServiceBundleInfoList;
    }
    const bundleInfoList: AppItemInfo[] = await this.getAtomicServiceAppListAsync();
    log.showInfo(`getAtomicServiceAppList bundleInfoList length: ${this.mAtomicServiceBundleInfoList.length}`);
    return bundleInfoList;
  }

  /**
   * Get the list of apps displayed on the desktop (private function).
   *
   * @return {array} bundleInfoList, excluding system applications
   */
  async getAtomicServiceAppListAsync(): Promise<AppItemInfo[]> {
    let allAbilityList: AppItemInfo[] = await atomicServiceAbilityManager.getAtomicServiceAbilityList();
    if (CheckEmptyUtils.isEmptyArr(allAbilityList)) {
      return this.mAtomicServiceBundleInfoList;
    }
    this.mAtomicServiceBundleInfoList =
      allAbilityList.filter((ability) => {
        return this.mSystemApplicationName.indexOf(ability.bundleName) === CommonConstants.INVALID_VALUE;
      });

    for (let index: number = 0; index < this.mAtomicServiceBundleInfoList.length; index++) {
      let isLast: boolean = index === this.mAtomicServiceBundleInfoList.length - 1;
      this.mFormModel.updateAppItemFormInfo(this.mAtomicServiceBundleInfoList[index].bundleName, undefined, isLast);
    }
    log.showWarn('allAbilityList length: %{public}d, valid length: %{public}d',
      allAbilityList.length, this.mAtomicServiceBundleInfoList.length);
    return this.mAtomicServiceBundleInfoList;
  }

  /**
   * Register application list change event listener.
   *
   * @param listener
   */
  registerStateChangeListener(listener: StateChangeType): void {
    if (this.mAppStateChangeListener.indexOf(listener) === CommonConstants.INVALID_VALUE) {
      this.mAppStateChangeListener.push(listener);
    }
  }

  /**
   * Unregister application list change event listener.
   *
   * @param listener
   */
  unregisterAppStateChangeListener(listener: StateChangeType): void {
    let index: number = this.mAppStateChangeListener.indexOf(listener);
    if (index !== CommonConstants.INVALID_VALUE) {
      this.mAppStateChangeListener.splice(index, 1);
    }
  }

  /**
   * 获取userId.
   */
  getUserId(): number {
    return atomicServiceAbilityManager.getUserId();
  }

  /**
   * 获取并替换原子服务App
   *
   * @param bundleName 包名
   */
  async getAndReplaceAtomicAbility(bundleName: string, appIndex?: number): Promise<AppItemInfo | undefined> {
    const abilityInfos: AppItemInfo[] = await atomicServiceAbilityManager.getAtomicServiceAbilityInfoAsync(bundleName);
    if (CheckEmptyUtils.isEmptyArr(abilityInfos)) {
      log.showInfo('cannot get abilityInfo by bundleName:' + bundleName);
      return undefined;
    }
    log.showInfo(`atomic abilityInfos: ${JSON.stringify(abilityInfos)}`);
    this.replaceAtomicServiceItem(bundleName, abilityInfos);
    return abilityInfos[0];
  }

  private getAtomicServiceItemIndex(bundleName: string): number {
    for (const listItem of this.mAtomicServiceBundleInfoList) {
      if (listItem.bundleName === bundleName) {
        return this.mAtomicServiceBundleInfoList.indexOf(listItem);
      }
    }
    return CommonConstants.INVALID_VALUE;
  }

  private appendAtomicServiceItem(abilityInfos: AppItemInfo[]): void {
    for (let index = 0; index < abilityInfos.length; index++) {
      this.mAtomicServiceBundleInfoList.push(abilityInfos[index]);
    }
  }

  /**
   * 移除原子服务App
   *
   * @param bundleName 包名
   */
  removeAtomicServiceItem(bundleName: string, appIndex?: number): void {
    log.showDebug(`removeAtomicServiceItem bundleName: ${bundleName}`);
    let originItemIndex: number = this.getAtomicServiceItemIndex(bundleName);
    while (originItemIndex !== CommonConstants.INVALID_VALUE) {
      this.removeItemCache(this.mAtomicServiceBundleInfoList[originItemIndex]);
      this.mAtomicServiceBundleInfoList.splice(originItemIndex, 1);
      originItemIndex = this.getAtomicServiceItemIndex(bundleName);
    }
  }

  private removeItemCache(appItemInfo: AppItemInfo): void {
    log.showInfo(`removeItemCache bundleName: ${(appItemInfo.bundleName)}`);
    let cacheKey: string = appItemInfo.applicationLabelId + appItemInfo.bundleName + appItemInfo.moduleName;
    globalThis.ResourceManager.deleteAppResourceCache(cacheKey, 'name');
    IconResourceManager.getInstance().deleteIconResource(appItemInfo.bundleName);
  }

  private replaceAtomicServiceItem(bundleName: string, abilityInfos: AppItemInfo[]): void {
    log.showDebug(`replaceAtomicServiceItem bundleName: ${bundleName}`);
    this.removeAtomicServiceItem(bundleName);
    this.appendAtomicServiceItem(abilityInfos);
  }
}
