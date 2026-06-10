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
import { ScreenLockApi } from '@ohos/screenlockcommon';
import { IExecutor } from '../IExecutor';
import { PowerUtils, ScreenOnOffService } from '@ohos/screenlockcommon';
import { BundleVerifyUtils } from '../../BundleVerifyUtils';

const TAG = 'invokeUnlock';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const REQUIRE_PERMISSION: string = 'ohos.permission.ACCESS_SCREEN_LOCK_INNER';

/**
 * 调用unlock方法
 *
 * @since 2024-05-10
 */
export class InvokeUnlock implements IExecutor {
  /**
   * 启动unlock
   * @param extra
   */
  async execute(extra?: object): Promise<void> {
    if (AppStorage.get('isBeginSleepStart') || !ScreenOnOffService.getInstance().isScreenOn) {
      PowerUtils.wakeupDeviceInFakeAod(PowerUtils.WAKEUP_DETAIL_OUTER_HOME_AOD_UNLOCK);
    }
    ScreenLockApi.requestUnlock({
      success: (): void => {
        log.showInfo('invoke Unlock done');
      }
    });
  }

  /**
   * Unlock接口权限认证
   */
  async verifyIdentity(bundleName: string): Promise<boolean> {
    if (!BundleVerifyUtils.hasPermission(bundleName, REQUIRE_PERMISSION)) {
      log.error(`verifyIdentity failed, reason: permission denied, bundleName:${bundleName}`);
      return false;
    }
    return true;
  }
}