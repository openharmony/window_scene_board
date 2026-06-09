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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, AccountMgr } from '@ohos/frameworkwrapper';
import resourceManager from '@ohos.resourceManager';
import bundleManager from '@ohos.bundle.bundleManager';
import { BusinessError } from '@ohos.base';

const TAG = 'BRManager';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class BundleManager {
  static readonly RESOURCE_MANAGER = 'SystemUi_Resource_Manager';

  static getResourceManager(): resourceManager.ResourceManager {
    if (!globalThis[BundleManager.RESOURCE_MANAGER]) {
      log.showInfo('init resourceManager');
      globalThis[BundleManager.RESOURCE_MANAGER] = GlobalContext.getContext().resourceManager;
    }
    return globalThis[BundleManager.RESOURCE_MANAGER];
  }

  static getString(resId: number, callback?: Function): undefined | Promise<string> {
    if (callback) {
      BundleManager.getResourceManager().getString(resId, (error, value) => {
        log.showDebug('getString, callback excute');
        callback(value);
      });
      return undefined;
    } else {
      return BundleManager.getResourceManager().getString(resId);
    }
  }

  static getMediaBase64(resId: number, callback?: Function): undefined | Promise<string> {
    if (callback) {
      BundleManager.getResourceManager().getMediaBase64(resId, (error, value) => {
        log.showDebug('getMediaBase64, callback excute');
        callback(value);
      });
      return undefined;
    } else {
      return BundleManager.getResourceManager().getMediaBase64(resId);
    }
  }

  static async getBundleInfo(tag: string, bundleName: string, getInfo?: bundleManager.BundleFlag,
                             requestId?: number): Promise<bundleManager.BundleInfo | undefined> {
    getInfo = getInfo ?? bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
    let userId = requestId ?? await AccountMgr.getCurrentAccountId();
    log.showDebug(`getBundleInfo from: ${tag}, userId: ${userId}`);
    try {
      const bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfo(bundleName, getInfo, userId);
      if (bundleInfo) {
        log.info(`getBundleInfo success ${bundleName}`);
        return bundleInfo;
      } else {
        log.error(`getBundleInfo failed ${bundleName}`);
      }
    } catch (err) {
      let code = (err as BusinessError).code;
      log.error(`getBundleInfo failed: ${code}`);
    }
    return undefined;
  }
}