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

import { LogDomain, LogHelper } from '../common/BasicCommon';
import bundleManager from '@ohos.bundle.bundleManager';
import { NtfBundleInfo } from '../common/bundleInfoUtil';
import { osAccount } from '@kit.BasicServicesKit';
import { notificationSettingManager } from '../manager/NotificationSettingManager';
import { KeyValPair } from './SystemUISettingSession';
import { ContextManager } from '../manager/ContextManager';
import { bundleResourceManager } from '@kit.AbilityKit';

const IS_INCLUDE_ABILITY_INFO = 33;
const ohos_APPLICATION = '1';
const LINUX_APPLICATION = '2';

const TAG = 'NotificationManagement-BundleResourceModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DELIVER_TONG_BUNDLE_NAME: string = 'com.deliver.appstore.lite';

export default class BundleResourceModel {
  async getBundleInfoAsync(param: Object): Promise<KeyValPair> {
    return new Promise((res, _rej) => {
      let launchParam = param as LaunchParam;
      this.getBundleInfo(launchParam?.bundleName, res, launchParam?.appIndex, launchParam?.uid);
    });
  }

  async getBundleInfo(bundleName: string | undefined, callback: (value: KeyValPair | PromiseLike<KeyValPair>) => void,
    appIndex?: number, uid?: number): Promise<void> {
    log.showInfo('GetBundleInfo for {%{public}s-%{public}d}', bundleName, appIndex);
    if (appIndex !== undefined && appIndex > 0) {
      bundleManager.getAppCloneBundleInfo(bundleName, appIndex, IS_INCLUDE_ABILITY_INFO).then((data) => {
        this.convertBundleInfo(data, appIndex).then(bundleInfo => callback(this.convert2BundleInfo(bundleInfo)));
      }).catch(async (error: Error) => {
        log.error(TAG, `getBundleInfo failed, appIndex: ${appIndex}, error: ${error?.code}, ${error?.message}.`);
        await this.getBundleInfoWhenException(bundleName, callback, appIndex, uid);
      });
    } else {
      bundleManager.getBundleInfo(bundleName, IS_INCLUDE_ABILITY_INFO).then((data) => {
        this.convertBundleInfo(data, 0).then(bundleInfo => callback(this.convert2BundleInfo(bundleInfo)));
      }).catch(async (error: Error) => {
        log.error(TAG, `getBundleInfo failed, appIndex: ${appIndex}, error: ${error?.code}, ${error?.message}.`);
        await this.getBundleInfoWhenException(bundleName, callback, undefined, uid);
      });
    }
  }

  private convert2BundleInfo(bundleInfo: NtfBundleInfo): KeyValPair | PromiseLike<KeyValPair> {
    let result: KeyValPair = {};
    result.appTitle = bundleInfo.appTitle;
    result.appVersion = bundleInfo.appVersion;
    result.appBundleName = bundleInfo.appBundleName;
    result.appUid = bundleInfo.appUid;
    result.systemApp = bundleInfo.systemApp;
    result.appIcon = bundleInfo.appIcon;
    result.appIndex = bundleInfo.appIndex;
    result.appSwitch = bundleInfo.appSwitch ?? false;
    result.appSlot = bundleInfo.appSlot ?? 0;
    result.appTitle = bundleInfo.appTitle;
    result.isdeliverApp = bundleInfo.isdeliverApp ?? false;
    return result;
  }

  private async getBundleInfoWhenException(bundleName: string | undefined,
    callback: (value: KeyValPair | PromiseLike<KeyValPair>) => void, appIndex?: number, uid?: number): Promise<void> {
    const res = bundleResourceManager.getBundleResourceInfo(bundleName);
    const app = await notificationSettingManager.getAppItem(uid ?? 0);
    let callbk: KeyValPair = {};
    if (appIndex) {
      callbk.appTitle = res?.label;
      callbk.appBundleName = res?.bundleName;
      callbk.appUid = uid ?? 0;
      callbk.appIcon = app?.icon ?? '';
      callbk.appIndex = appIndex;
      callback(callbk);
    } else {
      let callbk: KeyValPair = {};
      callbk.appTitle = res?.label;
      callbk.appBundleName = res?.bundleName;
      callbk.appUid = uid ?? 0;
      callbk.appIcon = app?.icon ?? '';
      callback(callbk);
    }
  }

  private async convertBundleInfo(data: bundleManager.BundleInfo, appIndex: number): Promise<NtfBundleInfo> {
    let appInfo = data.appInfo;
    let allAppInfo = await notificationSettingManager.getAppItem(appInfo.uid, appInfo.name);
    let appTitle = allAppInfo?.label;
    let appIcon = allAppInfo?.icon;
    const isDeliver = ['1', '2'].includes(appInfo.codePath);
    const isdeliverApp = appInfo.installSource === DELIVER_TONG_BUNDLE_NAME;
    if (!allAppInfo) {
      log.showInfo(`getAppItem fail, appInfo.uid=${appInfo.uid}, bundleName=${data.name}`);
      let labelAndIcon = await notificationSettingManager.getAppResource(ContextManager.getContext(), data.name,
        data.appInfo.bundleType, isDeliver);
      appTitle = labelAndIcon.label;
      appIcon = labelAndIcon.icon;
    }
    const bundleInfo: NtfBundleInfo = {
      appTitle: appTitle ?? '',
      appVersion: data.versionName,
      appBundleName: data.name,
      appUid: appInfo.uid,
      systemApp: appInfo.systemApp,
      appIcon: appIcon ?? '',
      appIndex,
      isdeliverApp: isdeliverApp,
    };
    return bundleInfo;
  }

  /**
   * 是否为应用
   * @param bundleName 应用的bundleName
   *
   * @returns 是否为应用
   */
  async isDeliverApplication(bundleName: string): Promise<boolean> {
    let userId = await osAccount.getAccountManager().getOsAccountLocalId();
    let bundleInfo = await bundleManager.getBundleInfo(bundleName, IS_INCLUDE_ABILITY_INFO, userId);
    let appInfo = bundleInfo.appInfo;
    log.showInfo('isDeliverApplication appInfo: ' + appInfo.codePath);
    return appInfo.codePath === ohos_APPLICATION || appInfo.codePath === LINUX_APPLICATION;
  }

  /**
   * 是否安装某应用，签名验证
   * @param bundleName 应用名
   * @param appId 应用签名
   */
  async isSpecificAppInstalled(bundleName: string, appId: string): Promise<boolean> {
    try {
      let bundleInfo =
        await bundleManager.getBundleInfo(bundleName, bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO);
      return appId === bundleInfo.signatureInfo.appId;
    } catch (e) {
      log.showError('getBundleInfo failed: ' + e);
    }

    return false;
  }
}

class LaunchParam {
  public appIndex: number = 0;
  public bundleName?: string;
  public uid?: number;
}

class Error {
  public code?: number;
  public message?: string;
}