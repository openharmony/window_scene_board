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

import { GlobalContext } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import type abilityCommon from '@ohos.app.ability.common';
import {
  ThreeButtonAccessibilityManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/settings/preference/ThreeButtonAccessibilityManager'

export default function ThreeButtonAccessibilityManagerTest() {
  describe('ThreeButtonAccessibilityManagerTest', () => {
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

    let threeButtonAccessibilityManager: ThreeButtonAccessibilityManager = new ThreeButtonAccessibilityManager();

    it('ThreeButtonAccessibilityManager_closeFloatBallAndSaveBeforeOpen', 0, async (done: Function) => {
      let context = globalThis.getContext() as abilityCommon.ServiceExtensionContext
      GlobalContext.setContext(context);
      threeButtonAccessibilityManager.closeFloatBallAndSaveBeforeOpen(context);
      expect(threeButtonAccessibilityManager).not().assertUndefined();
      done();
    });

    it('ThreeButtonAccessibilityManager_onChangeAccessibilityModeStateChange_1', 0, async (done: Function) => {
      let context = globalThis.getContext() as abilityCommon.ServiceExtensionContext
      GlobalContext.setContext(context);
      threeButtonAccessibilityManager.onChangeAccessibilityModeStateChange(false);
      expect(threeButtonAccessibilityManager).not().assertUndefined();
      done();
    });
    it('ThreeButtonAccessibilityManager_onChangeAccessibilityModeStateChange_2', 0, async (done: Function) => {
      let context = globalThis.getContext() as abilityCommon.ServiceExtensionContext
      GlobalContext.setContext(context);
      threeButtonAccessibilityManager.onChangeAccessibilityModeStateChange(true);
      expect(threeButtonAccessibilityManager).not().assertUndefined();
      done();
    });

    it('ThreeButtonAccessibilityManager_getFloatBeforeOpenState_1', 0, async (done: Function) => {
      let context = globalThis.getContext() as abilityCommon.ServiceExtensionContext
      GlobalContext.setContext(context);
      (threeButtonAccessibilityManager as object)['getFloatBeforeOpenState']('1', '0');
      expect(threeButtonAccessibilityManager).not().assertUndefined();
      done();
    });

    it('ThreeButtonAccessibilityManager_getFloatBeforeOpenState_2', 0, async (done: Function) => {
      let context = globalThis.getContext() as abilityCommon.ServiceExtensionContext
      GlobalContext.setContext(context);
      (threeButtonAccessibilityManager as object)['getFloatBeforeOpenState']('0', '1');
      expect(threeButtonAccessibilityManager).not().assertUndefined();
      done();
    });
    it('ThreeButtonAccessibilityManager_getFloatBeforeOpenState_3', 0, async (done: Function) => {
      let context = globalThis.getContext() as abilityCommon.ServiceExtensionContext
      GlobalContext.setContext(context);
      (threeButtonAccessibilityManager as object)['getFloatBeforeOpenState']('0', '0');
      expect(threeButtonAccessibilityManager).not().assertUndefined();
      done();
    });
    it('ThreeButtonAccessibilityManager_getFloatBeforeOpenState_3', 0, async (done: Function) => {
      let context = globalThis.getContext() as abilityCommon.ServiceExtensionContext
      GlobalContext.setContext(context);
      (threeButtonAccessibilityManager as object)['getFloatBeforeOpenState']('1', '1');
      expect(threeButtonAccessibilityManager).not().assertUndefined();
      done();
    });

    it('ThreeButtonAccessibilityManager_handleAccessibilityModeOpen', 0, async (done: Function) => {
      let context = globalThis.getContext() as abilityCommon.ServiceExtensionContext
      GlobalContext.setContext(context);
      (threeButtonAccessibilityManager as object)['handleAccessibilityModeOpen']();
      expect(threeButtonAccessibilityManager).not().assertUndefined();
      done();
    });

    it('ThreeButtonAccessibilityManager_getFloatNavAccessibilityModeState', 0, async (done: Function) => {
      let context = globalThis.getContext() as abilityCommon.ServiceExtensionContext
      GlobalContext.setContext(context);
      (threeButtonAccessibilityManager as object)['getFloatNavAccessibilityModeState']();
      expect(threeButtonAccessibilityManager).not().assertUndefined();
      done();
    });

    it('ThreeButtonAccessibilityManager_saveFloatNavAccessibilityModeState', 0, async (done: Function) => {
      let context = globalThis.getContext() as abilityCommon.ServiceExtensionContext
      GlobalContext.setContext(context);
      (threeButtonAccessibilityManager as object)['saveFloatNavAccessibilityModeState']('1');
      expect(threeButtonAccessibilityManager).not().assertUndefined();
      done();
    });
  })
}