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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe, expect, it, MockKit
} from "@ohos/hypium";
import { AppItemInfo } from "@ohos/launchercommon";
import {
  GestureDockActionAbilityStrategy
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewdata/GestureDockActionAbilityStrategy';

export default function GestureDockActionAbilityStrategyTest() {
  describe('GestureDockDataControllerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('GestureDockActionAbilityStrategy_expandDataByStrategy_test_01', 0, () => {
      let gestureDockActionAbilityStrategy: GestureDockActionAbilityStrategy = new GestureDockActionAbilityStrategy();
      let appItemInfos: AppItemInfo[] = [{
        appIconId: 1,
        abilityName: 'test_abilityName',
        appName: 'test_appName',
        bundleName: 'test_bundleName'
      }];
      gestureDockActionAbilityStrategy.expandDataByStrategy(appItemInfos);
      expect(appItemInfos.length).assertEqual(1);
      expect(appItemInfos[0].bundleName).assertEqual('test_bundleName');
    });
  });
}