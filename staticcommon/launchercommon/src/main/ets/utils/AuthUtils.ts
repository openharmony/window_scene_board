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
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
const TAG = 'AuthUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 卡片适配应用锁认证模块
 */
export default class AuthUtils {
  public static auth(): Promise<boolean> {
    return new Promise<boolean>(async (resolve) => {
      try {
        // await appLock.startAppLockAuth();
        log.showInfo('authUtils auth succeed');
        resolve(true);
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        log.showError(`auth catch error. Code is ${err?.code}, message is ${err?.message}`);
        resolve(false);
      }
    });
  }
}