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
import { HashMap } from '@kit.ArkTS';
import { rpc } from '@kit.IPCKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AppIconCheckAndFixManager, LostBundleInfo } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconCheckAndFixManager';
import { IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG = 'CheckAppIconLost';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 图标丢失查询对外接口
 * 用于检测图标丢失场景: 图标Image异常、opacity异常以及图标布局缓存缺失
 */
export class CheckAppIconLost implements IExecutor {
  async execute(extra?: object): Promise<string> {
    const checkLostParm = extra as CheckLostParm;
    if (CheckEmptyUtils.isEmpty(checkLostParm)) {
      log.showWarn('invalid checkLostParm');
      return JSON.stringify(new AppIconCheckResult(CheckResultCode.FAILED_INVALID_PARAMETERS, ''));
    }
    try {
      const callerUid: number = rpc.IPCSkeleton.getCallingUid();
      const callerName = await bundleManager.getBundleNameByUid(callerUid);
      const applicationInfo = bundleManager.getApplicationInfoSync(callerName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT);
      if (applicationInfo && applicationInfo.systemApp) {
        let lostInfos: HashMap<number, LostBundleInfo[]> =
          await AppIconCheckAndFixManager.getInstance().checkIcon(checkLostParm.bundleName);
        return JSON.stringify(new AppIconCheckResult(CheckResultCode.SUCCESS, this.stringifyCheckResult(lostInfos)));
      } else {
        log.showWarn('check appIconLost must be called by system app');
        return JSON.stringify(new AppIconCheckResult(CheckResultCode.FAILED_OTHER, ''));
      }
    } catch (err) {
      log.showError(`getBundleInfoSync error, code: ${err?.code}, message: ${err?.message}`);
      return JSON.stringify(new AppIconCheckResult(CheckResultCode.FAILED_OTHER, ''));
    }
  }

  private stringifyCheckResult(lostInfos: HashMap<number, LostBundleInfo[]>): string {
    let checkResult: Record<number, LostBundleInfo[]> = {};
    lostInfos.forEach((value: LostBundleInfo[], key: number) => {
      if (key !== undefined && !CheckEmptyUtils.isEmptyArr(value)) {
        checkResult[key] = value;
      }
    })
    return JSON.stringify(checkResult);
  }
}

/**
 * 检测图标丢失参数
 */
class CheckLostParm {
  public bundleName: string = ''
}

/**
 * 检测结果code
 */
enum CheckResultCode {
  // 0：检测完成
  SUCCESS = 0,
  // 1：检测失败：入参不合法
  FAILED_INVALID_PARAMETERS = 1,
  // -1：检测失败：其它原因
  FAILED_OTHER = -1,
}

/**
 * 检测返回的结果
 */
class AppIconCheckResult {
  public code: CheckResultCode;
  public reason: string;

  constructor(code: CheckResultCode, reason: string) {
    this.code = code;
    this.reason = reason;
  }
}