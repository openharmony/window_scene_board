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

import { describe, beforeAll, it, expect, Level } from '@ohos/hypium';
import { EngineContainerManager } from '../../../../main/ets/themeassistant/component/EngineContainerManager';

const HIGH_LEVEL_INDEX: number = 2;
const LOW_LEVEL_INDEX: number = 1;

let containerMgr: EngineContainerManager = EngineContainerManager.getInstance();

export function EngineContainerManagerTest() {
  describe('EngineContainerManagerTest', (): void => {
    beforeAll((): void => {
      // Always assume primary instance is used
      AppStorage.setOrCreate<boolean>('dualEngineSwitchPrimary', true);
      AppStorage.setOrCreate<boolean>('dualEngineSwitchSecondary', false);
      AppStorage.setOrCreate<number>('dualEnginePrimaryZIndex', HIGH_LEVEL_INDEX);
      AppStorage.setOrCreate<number>('dualEngineSecondaryZIndex', LOW_LEVEL_INDEX);
      AppStorage.setOrCreate<boolean>('themeEngineRestartTrigger', true);
    });

    it('ECM_Start_New_Instance', Level.LEVEL0, startNewInstanceTest);
    it('ECM_Kill_Idle_Instance', Level.LEVEL0, killIdleInstanceTest);
    it('ECM_Restart_Instance', Level.LEVEL0, restartCurrentTest);
  });
}

function startNewInstanceTest(): void {
  containerMgr.startNewInstance();
  expect(AppStorage.get<boolean>('dualEngineSwitchSecondary')).assertTrue();
  expect(AppStorage.get<boolean>('dualEnginePrimaryZIndex')).assertEqual(HIGH_LEVEL_INDEX);
}

function killIdleInstanceTest(): void {
  containerMgr.startNewInstance();
  containerMgr.killIdleInstance();
  expect(AppStorage.get<boolean>('dualEngineSwitchSecondary')).assertTrue();
  expect(AppStorage.get<boolean>('dualEngineSwitchPrimary')).assertFalse();
  expect(AppStorage.get<boolean>('dualEngineSecondaryZIndex')).assertEqual(HIGH_LEVEL_INDEX);
}

function restartCurrentTest(): void {
  let trigger: boolean | undefined = AppStorage.get<boolean>('themeEngineRestartTrigger');
  expect(trigger).not().assertNull();
  containerMgr.restartCurrentInstance();
  expect(AppStorage.get<boolean>('themeEngineRestartTrigger')).assertEqual(!trigger);
}

