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

import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SystemUIInitiator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * SystemUI组件启动器
 */
export class SystemUIInitiator {
  static init(): void {
    log.showWarn(`SystemUIInitiator init baseState`);
    // 状态管理初始化
    baseStateMgr.init();
  }
}