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
import { AppIconCheckAndFixManager } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconCheckAndFixManager';
import { IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG = 'FixAppIconLost';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 图标丢失修复对外接口
 * 用于修复图标丢失场景: 图标Image异常、opacity异常以及图标布局缓存缺失
 */
export class FixAppIconLost implements IExecutor {
  async execute(extra?: object): Promise<string> {
    const fixLostParam = extra as FixLostParam;
    if (CheckEmptyUtils.isEmpty(fixLostParam)) {
      log.showWarn('invalid fixLostParm');
      return JSON.stringify(FixResultCode.FAILED_INVALID_PARAMETERS);
    }
    try {
      const callerUid = rpc.IPCSkeleton.getCallingUid();
      const callerName = await bundleManager.getBundleNameByUid(callerUid);
      const applicationInfo = bundleManager.getApplicationInfoSync(callerName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT);
      if (applicationInfo && applicationInfo.systemApp) {
        let result: boolean =
          await AppIconCheckAndFixManager.getInstance().fixIcon(fixLostParam.reason, fixLostParam.bundleName);
        return JSON.stringify(result ? FixResultCode.SUCCESS : FixResultCode.FAILED_INVALID_PARAMETERS);
      } else {
        log.showWarn('fix appIconLost must be called by system app');
        return JSON.stringify(FixResultCode.FAILED_OTHER);
      }
    } catch (err) {
      log.showError(`getBundleInfoSync error, code: ${err?.code}, message: ${err?.message}`);
      return JSON.stringify(FixResultCode.FAILED_INVALID_PARAMETERS);
    }
  }
}

/**
 * 修复图标丢失参数
 */
class FixLostParam {
  public reason: number = 0;
  public bundleName: string = '';
}

/**
 * 检测结果code
 */
enum FixResultCode {
  // 0：修复完成
  SUCCESS = 0,
  // 1：修复失败：入参不合法
  FAILED_INVALID_PARAMETERS = 1,
  // -1：修复失败：其它原因
  FAILED_OTHER = -1,
}