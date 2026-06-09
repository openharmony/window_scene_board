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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  BaseShortcutInfo,
  CheckResult,
  ResultCode,
  ShortcutViewModel
} from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/ShortcutViewModel';

const TAG = 'CheckShortcut';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 快捷图标校验操作
 */
export class CheckShortcut implements IExecutor {
  async execute(extra?: object): Promise<string> {
    let shortcutInfo = extra as BaseShortcutInfo;
    let result: CheckResult = new CheckResult();
    if (CheckEmptyUtils.isEmpty(shortcutInfo)) {
      log.showWarn('invalid shortcutInfo');
      result.code = ResultCode.FAILED_INVALID_PARAMETERS;
      return JSON.stringify(result);
    }
    result = ShortcutViewModel.getInstance().checkShortcut(shortcutInfo);
    return JSON.stringify(result);
  }
}