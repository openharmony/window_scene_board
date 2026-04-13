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

import { TsLog } from '@ohos/themeservicebase/Index';
import { UpgradeApi } from '../api/UpgradeApi';
import { VersionInfo } from '../model/VersionInfo';

const TAG: string = 'UpgradeDefaultApi';

export class UpgradeDefaultApi implements UpgradeApi {
  init(doUpgrade: (from: number, to: number) => Promise<void>): Promise<void> {
    TsLog.warning(TAG, `Method[init] not implemented.`);
    return Promise.resolve();
  }

  initOS(doUpgrade: (from?: VersionInfo, to?: VersionInfo) => Promise<void>): Promise<void> {
    TsLog.warning(TAG, 'Method[initOS] not implemented.');
    return Promise.resolve();
  }
}