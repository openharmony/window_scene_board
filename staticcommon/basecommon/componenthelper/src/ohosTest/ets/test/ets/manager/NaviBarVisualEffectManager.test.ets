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
  describe,
  expect,
  it
} from '@ohos/hypium'
import { NaviBarVisualEffectManager } from '../../../../../main/ets/manager/NaviBarVisualEffectManager'
import { thermal } from '@kit.BasicServicesKit'

export default function NaviBarVisualEffectManagerTest() {
  describe('NaviBarVisualEffectManagerTest', () => {
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

    it('test_getInstance_1', 0, () => {
      const result: ESObject = NaviBarVisualEffectManager.getInstance();
      expect(result).assertEqual(NaviBarVisualEffectManager.mInstance);
    });

    it('test_init_1', 0, async () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      expect(navibarvisualeffectmanager.init() === undefined).assertTrue();
    });

    it('test_isFullDevice_1', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'full' };
      const result: ESObject = (navibarvisualeffectmanager as object)['isFullDevice']();
      expect(result).assertEqual(true);
    });

    it('test_isFullDevice_2', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'lite' };
      const result: ESObject = (navibarvisualeffectmanager as object)['isFullDevice']();
      expect(result).assertEqual(false);
    });

    it('test_isFullDevice_3', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'xxxxx' };
      const result: ESObject = (navibarvisualeffectmanager as object)['isFullDevice']();
      expect(result).assertEqual(false);
    });

    it('test_isFullEffect_1', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['isFullVisualEffect'] = false;
      const result: ESObject = navibarvisualeffectmanager.isFullEffect();
      expect(result).assertEqual(false);
    });

    it('test_isFullEffect_2', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['isFullVisualEffect'] = true;
      const result: ESObject = navibarvisualeffectmanager.isFullEffect();
      expect(result).assertEqual(true);
    });

    it('test_updateFullEffect_1', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'full' };
      navibarvisualeffectmanager.updateFullEffect(10);
      expect((navibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(false);
    });

    it('test_updateFullEffect_2', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'full' };
      navibarvisualeffectmanager.updateFullEffect(0);
      expect((navibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(true);
    });

    it('test_updateFullEffect_3', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'lite' };
      navibarvisualeffectmanager.updateFullEffect(10);
      expect((navibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(false);
    });

    it('test_updateFullEffect_4', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'lite' };
      navibarvisualeffectmanager.updateFullEffect(0);
      expect((navibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(false);
    });

    it('test_updateFullEffect_5', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'full' };
      navibarvisualeffectmanager.updateFullEffect(0);
      expect((navibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(true);
    });

    it('test_getEffectLevel_1', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['isFullVisualEffect'] = false;
      const result: ESObject = navibarvisualeffectmanager.getEffectLevel();
      expect(result).assertEqual('lite');
    });

    it('test_getEffectLevel_2', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['isFullVisualEffect'] = true;
      const result: ESObject = navibarvisualeffectmanager.getEffectLevel();
      expect(result).assertEqual('full');
    });

    it('test_isGameScene_1', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      const result: ESObject = (navibarvisualeffectmanager as object)['isGameScene'](1);
      expect(result).assertTrue();
    });

    it('test_isGameScene_2', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      const result: ESObject = (navibarvisualeffectmanager as object)['isGameScene'](0);
      expect(result).assertFalse();
    });

    it('test_isRSSScene_1', 0, async () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      let result: ESObject = (navibarvisualeffectmanager as object)['isRSSScene']();
      expect(result).assertEqual(false);
    });

    it('test_isOverThermalScene_1', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['overThermalLevel'] = thermal.ThermalLevel.HOT;
      let result: ESObject = (navibarvisualeffectmanager as object)['isOverThermalScene'](thermal.ThermalLevel.HOT);
      expect(result).assertEqual(true);
    });

    it('test_isOverThermalScene_2', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      (navibarvisualeffectmanager as object)['overThermalLevel'] = thermal.ThermalLevel.HOT;
      let result: ESObject = (navibarvisualeffectmanager as object)['isOverThermalScene'](thermal.ThermalLevel.WARM);
      expect(result).assertEqual(false);
    });

    it('test_limitAppVsyncStart_1', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      expect(navibarvisualeffectmanager.limitAppVsyncStart(thermal.ThermalLevel.HOT) === undefined).assertTrue();
    });

    it('test_limitAppVsyncStart_2', 0, () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      expect(navibarvisualeffectmanager.limitAppVsyncStart(thermal.ThermalLevel.NORMAL) === undefined).assertTrue();
    });

    it('test_limitAppVsyncEnd_1', 0, async () => {
      let navibarvisualeffectmanager: NaviBarVisualEffectManager = NaviBarVisualEffectManager.getInstance();
      expect(navibarvisualeffectmanager.limitAppVsyncEnd() === undefined).assertTrue();
    });

  })
}