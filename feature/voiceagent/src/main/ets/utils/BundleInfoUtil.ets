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

import bundleManager from '@ohos.bundle.bundleManager';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';

const TAG: string = 'BundleInfoUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class BundleInfoUtil {
  static isBundleEnabled(bundleName: string): boolean {
    try {
      const isEnabled: boolean = bundleManager.isApplicationEnabledSync(bundleName);
      log.showInfo(`isApplicationEnabled: ${isEnabled}`);
      if (isEnabled === undefined) {
        return false;
      }
      return isEnabled;
    } catch (err) {
      log.showError(`isBundleEnabled err: ${(err as BusinessError).code} ${(err as BusinessError).message}`);
      return false;
    }
  }

  /**
   * 获取应用信息
   * @param bundleName 应用包名
   * @returns
   */
  static getBundleInfo(bundleName: string): bundleManager.BundleInfo | undefined {
    try {
      let bundleInfo = bundleManager.getBundleInfoSync(bundleName,
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA |
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE);
      return bundleInfo;
    } catch (err) {
      log.showError(`getBundleInfo err: ${(err as BusinessError).code} ${(err as BusinessError).message}`);
      return undefined;
    }
  }
}