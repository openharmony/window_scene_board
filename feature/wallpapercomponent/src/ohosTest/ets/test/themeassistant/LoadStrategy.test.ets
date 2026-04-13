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
import { TsResilienceHandler } from '../../../../main/ets/themeassistant/handler/TsResilienceHandler';
import { commonEventManager } from '@kit.BasicServicesKit';
import { dtWallpaperStateMgr } from '../../../../main/ets/wallpaper/model/DesktopWallpaperModel';

const HIGH_LEVEL_INDEX: number = 2;
const LOW_LEVEL_INDEX: number = 1;

let dih: DualInstanceHandler = DualInstanceHandler.getInstance();
let trh: TsResilienceHandler = TsResilienceHandler.getInstance();

export function LoadStrategyTest() {
  describe('LoadStrategyTest', (): void => {
    beforeAll((): void => {
      // Always assume primary instance is used
      AppStorage.setOrCreate<boolean>('dualEngineSwitchPrimary', true);
      AppStorage.setOrCreate<boolean>('dualEngineSwitchSecondary', false);
      AppStorage.setOrCreate<number>('dualEnginePrimaryZIndex', HIGH_LEVEL_INDEX);
      AppStorage.setOrCreate<number>('dualEngineSecondaryZIndex', LOW_LEVEL_INDEX);
      AppStorage.setOrCreate<boolean>('themeEngineRestartTrigger', true);
    });

    it('GLS_execution_test', Level.LEVEL0, gracefulStratTest);
    it('SLS_execution_test', Level.LEVEL0, singularStratTest);
    it('ScbLS_execution_test', Level.LEVEL0, scbStratTest);
    it('LS_recover_test', Level.LEVEL0, stratRecoverTest);
  });
}

function gracefulStratTest(): void {
  let sudoEvent: ThemeActivationEvent = {
    target: 7,
    themeType: 0,
    themeOwnership: 0,
    activeThemePath: ''
  }

  dih.onActivateTheme(sudoEvent);
  expect(AppStorage.get<boolean>('dualEngineSwitchSecondary')).assertTrue();
  expect(AppStorage.get<boolean>('dualEnginePrimaryZIndex')).assertEqual(HIGH_LEVEL_INDEX);
  commonEventManager.publish('ThemeFinishLoading', () => {});
  setTimeout(() => {
    expect(AppStorage.get<boolean>('dualEngineSwitchSecondary')).assertTrue();
    expect(AppStorage.get<boolean>('dualEngineSwitchPrimary')).assertFalse();
    expect(AppStorage.get<boolean>('dualEngineSecondaryZIndex')).assertEqual(HIGH_LEVEL_INDEX);
  }, 500);
}

function singularStratTest(): void {
  let sudoEvent: ThemeActivationEvent = {
    target: 7,
    themeType: 0,
    themeOwnership: 0,
    activeThemePath: ''
  }

  dih.onActivateTheme(sudoEvent);
  dih.onUiExtError();
  expect(AppStorage.get<boolean>('dualEngineSwitchPrimary')).assertFalse();
}

function scbStratTest(): void {
  let sudoEvent: ThemeActivationEvent = {
    target: 7,
    themeType: 0,
    themeOwnership: 0,
    activeThemePath: ''
  }

  dih.onActivateTheme(sudoEvent);
  for (let i: number = 0; i < 6; i++) {
    trh.updateRetryCount();
  }
  dih.onUiExtError();
  expect(AppStorage.get<boolean>('desktopWallpaperSupportScreenToEnd')).assertFalse();
}

function stratRecoverTest(): void {
  // Trigger ScbLoadStrategy
  let sudoEvent: ThemeActivationEvent = {
    target: 7,
    themeType: 0,
    themeOwnership: 0,
    activeThemePath: ''
  }

  dih.onActivateTheme(sudoEvent);
  for (let i: number = 0; i < 6; i++) {
    trh.updateRetryCount();
  }
  dih.onUiExtError();
  expect(AppStorage.get<boolean>('desktopWallpaperSupportScreenToEnd')).assertFalse();

  dtWallpaperStateMgr.setDesktopWallpaperMode(true); // Simulate ThemeServiceHelper call
  // Recover from previous error
  dih.onActivateTheme(sudoEvent);
  expect(AppStorage.get<boolean>('desktopWallpaperSupportScreenToEnd')).assertTrue();
}

