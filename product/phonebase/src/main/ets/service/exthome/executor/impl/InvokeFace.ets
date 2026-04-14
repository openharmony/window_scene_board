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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ScreenLockApi } from '@ohos/screenlockcommon';
import { IExecutor } from '../IExecutor';
import { BundleVerifyUtils } from '../../BundleVerifyUtils';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { ScreenLockVerifyService } from '@ohos/screenlockcommon/src/main/ets/services/ScreenLockVerifyService';

const TAG = 'InvokeFace';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const REQUIRE_PERMISSION: string = 'ohos.permission.ACCESS_SCREEN_LOCK_INNER';

/**
 * 调用人脸识别并返回结果
 *
 * @since 2024-03-28
 */
export class InvokeFace implements IExecutor {
  /**
   * 启动人脸识别
   * @param extra
   */
  async execute(extra?: object): Promise<void> {
    log.info('invoke Face execute');
    ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, true);
  }

  /**
   * 人脸识别接口权限认证
   */
  async verifyIdentity(bundleName: string): Promise<boolean> {
    if (!BundleVerifyUtils.hasPermission(bundleName, REQUIRE_PERMISSION)) {
      log.error(`verifyIdentity failed, reason: permission denied, bundleName:${bundleName}`);
      return false;
    }
    return true;
  }
}