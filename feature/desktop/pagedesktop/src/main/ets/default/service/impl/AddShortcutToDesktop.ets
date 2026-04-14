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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AGShortcutInfo, ResultCode } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/ShortcutViewModel';
import { IExecutor, ShortcutInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DesktopShortcutViewModel } from '../../common/viewmodel/DesktopShortcutViewModel';

const TAG = 'AddShortcutToDesktop';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 快捷图标加桌操作
 */
export class AddShortcutToDesktop implements IExecutor {
  async execute(extra?: object): Promise<string> {
    let agShortcutInfo = extra as AGShortcutInfo;
    if (CheckEmptyUtils.isEmpty(agShortcutInfo)) {
      log.showWarn('invalid shortcutInfo');
      return JSON.stringify(ResultCode.FAILED_INVALID_PARAMETERS);
    }
    let shortcutInfo = agShortcutInfo as Object as ShortcutInfo;
    shortcutInfo.icon = agShortcutInfo.foregroundIcon;
    let code: ResultCode = await DesktopShortcutViewModel.getInstance().addShortcutToDesktop(shortcutInfo);
    return JSON.stringify(code);
  }
}