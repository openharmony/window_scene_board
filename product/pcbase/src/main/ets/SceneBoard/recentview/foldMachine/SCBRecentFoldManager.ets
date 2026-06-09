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
import { SCBSessionRect } from '@ohos/windowscene';
import { AnimationType, SCBRecentFoldMachineVM } from './SCBRecentFoldMachineVM';
import { SCBRecentFoldHalfVM } from './SCBRecentFoldHalfVM';
import { SCBRecentFoldPhysicalVM } from './SCBRecentFoldPhysicalVM';
import { SCBRecentFoldVirtualVM } from './SCBRecentFoldVirtualVM';
import { SCBRecentStyle, SCBRecentStyleManager } from './SCBRecentStyle';
import { SCBRecentUnfoldHorVM } from './SCBRecentUnfoldHorVM';
import { SCBRecentUnfoldVerVM } from './SCBRecentUnfoldVerVM';

const TAG = 'Recent-SCBRecentFoldManager';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentFoldManager {

  private static instance: SCBRecentFoldManager;
  private screenIds: Set<number> = new Set<number>();

  constructor() {}

  public static getInstance(): SCBRecentFoldManager {
    if (!SCBRecentFoldManager.instance) {
      SCBRecentFoldManager.instance = new SCBRecentFoldManager();
    }
    return SCBRecentFoldManager.instance;
  }

  public destroy(): void {}
}