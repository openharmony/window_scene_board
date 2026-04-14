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

import { ThemeActivationEvent } from '@ohos/frameworkwrapper';
import { describe, beforeAll, it, expect, Level } from '@ohos/hypium';
import { DualInstanceHandler } from '../../../../main/ets/themeassistant/handler/DualInstanceHandler';
import { commonEventManager } from '@kit.BasicServicesKit';
import { ThemeActivationTarget } from '@ohos/themeservicekit/Index';

const HIGH_LEVEL_INDEX: number = 2;
const LOW_LEVEL_INDEX: number = 1;

let handler: DualInstanceHandler = DualInstanceHandler.getInstance();

export function DualInstanceHandlerTest() {
  describe('DualInstanceHandlerTest', (): void => {
    beforeAll((): void => {
      // Always assume primary instance is used
      AppStorage.setOrCreate<boolean>('dualEngineSwitchPrimary', true);
      AppStorage.setOrCreate<boolean>('dualEngineSwitchSecondary', false);
      AppStorage.setOrCreate<number>('dualEnginePrimaryZIndex', HIGH_LEVEL_INDEX);
      AppStorage.setOrCreate<number>('dualEngineSecondaryZIndex', LOW_LEVEL_INDEX);
    });

    it('DIH_On_Engine_Ready', Level.LEVEL0, onEngineReadyTest);
    it('DIH_On_Activate_Theme', Level.LEVEL0, onActivateThemeTest);
  });
}

function onEngineReadyTest(): void {
  let engineReadyAllowance: number = 1000;

  handler.onEngineReady();
  setTimeout(() => {
    expect(AppStorage.get<boolean>('dualEngineSwitchPrimary')).assertTrue();
    expect(AppStorage.get<boolean>('dualEngineSwitchSecondary')).assertFalse();
  }, engineReadyAllowance);
}

function onActivateThemeTest(): void {
  let sudoEvent: ThemeActivationEvent = {
    target: ThemeActivationTarget.ALL,
    themeType: 0,
    themeOwnership: 0,
    activeThemePath: ''
  }
  handler.onActivateTheme(sudoEvent);
  expect(AppStorage.get<boolean>('dualEngineSwitchSecondary')).assertTrue();
  expect(AppStorage.get<boolean>('dualEnginePrimaryZIndex')).assertEqual(HIGH_LEVEL_INDEX);
  commonEventManager.publish('ThemeFinishLoading', () => {});

  let commonEventPublishLag: number = 500;
  setTimeout(() => {
    expect(AppStorage.get<boolean>('dualEngineSwitchSecondary')).assertTrue();
    expect(AppStorage.get<boolean>('dualEngineSwitchPrimary')).assertFalse();
    expect(AppStorage.get<boolean>('dualEngineSecondaryZIndex')).assertEqual(HIGH_LEVEL_INDEX);
  }, commonEventPublishLag);
}

