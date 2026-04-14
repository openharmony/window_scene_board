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

import { bundleManager } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import DockLayoutCacheManager from '@ohos/launchercommon/src/main/ets/cache/layout/DockLayoutCacheManager';
import { ShortcutLimitInfo, ResultCode } from
  '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/ShortcutViewModel';
import { IExecutor, LaunchLayoutCacheManager } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG = 'SetPinShortcutLimitInfo';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 设置应用快捷方式加桌数量上限
 */
export class SetPinShortcutLimitInfo implements IExecutor {
  async execute(extra?: object): Promise<string> {
    const shortcutLimitArr = extra as Array<ShortcutLimitInfo>;
    if (CheckEmptyUtils.isEmpty(shortcutLimitArr)) {
      log.showWarn('invalid shortcutInfo');
      return JSON.stringify(ResultCode.FAILED_INVALID_PARAMETERS);
    }
    try {
      const callerUid = rpc.IPCSkeleton.getCallingUid();
      const callerName = await bundleManager.getBundleNameByUid(callerUid);
      const applicationInfo = bundleManager.getApplicationInfoSync(callerName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT);
      if (applicationInfo && applicationInfo.systemApp) {
        // 尝试设置桌面缓存
        let code: number = await LaunchLayoutCacheManager.getInstance()
          .updateShortcutLimitInfoByShortcutList(shortcutLimitArr);
        if (code !== ResultCode.SUCCESS) {
          // 尝试设置dock缓存
          code = await DockLayoutCacheManager.getInstance().updateShortcutLimitInfoByShortcutList(shortcutLimitArr);
        }
        return JSON.stringify(code);
      } else {
        log.showWarn('setShortcutLimit must be called by system app');
        return JSON.stringify(ResultCode.FAILED_OTHER);
      }
    } catch (err) {
      log.showError(`getBundleInfoSync error, code: ${err?.code}, message: ${err?.message}`);
      return JSON.stringify(ResultCode.FAILED_INVALID_PARAMETERS);
    }
  }
}