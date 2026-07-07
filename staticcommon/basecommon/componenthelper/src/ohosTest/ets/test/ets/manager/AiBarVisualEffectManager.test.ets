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
import { AiBarVisualEffectManager } from '../../../../../main/ets/manager/AiBarVisualEffectManager'
import { thermal } from '@kit.BasicServicesKit'

export default function AiBarVisualEffectManagerTest() {
  describe('AiBarVisualEffectManagerTest', () => {
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
      const result: ESObject = AiBarVisualEffectManager.getInstance();
      expect(result).assertEqual(AiBarVisualEffectManager.mInstance);
    });

    it('test_init_1', 0, async () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      expect(aibarvisualeffectmanager.init() === undefined).assertTrue();
    });

    it('test_isFullDevice_1', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'full' };
      const result: ESObject = (aibarvisualeffectmanager as object)['isFullDevice']();
      expect(result).assertEqual(true);
    });

    it('test_isFullDevice_2', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'lite' };
      const result: ESObject = (aibarvisualeffectmanager as object)['isFullDevice']();
      expect(result).assertEqual(false);
    });

    it('test_isFullDevice_3', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'xxxxx' };
      const result: ESObject = (aibarvisualeffectmanager as object)['isFullDevice']();
      expect(result).assertEqual(false);
    });

    it('test_isFullEffect_1', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['isFullVisualEffect'] = false;
      const result: ESObject = aibarvisualeffectmanager.isFullEffect();
      expect(result).assertEqual(false);
    });

    it('test_isFullEffect_2', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['isFullVisualEffect'] = true;
      const result: ESObject = aibarvisualeffectmanager.isFullEffect();
      expect(result).assertEqual(true);
    });

    it('test_upgradeVass_1', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'full' };
      aibarvisualeffectmanager.upgradeVass();
      expect((aibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(true);
    });

    it('test_upgradeVass_2', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'lite' };
      aibarvisualeffectmanager.upgradeVass();
      expect((aibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(false);
    });

    it('test_updateFullEffect_1', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'full' };
      (aibarvisualeffectmanager as object)['isVassSupportNewEffect'] = true;
      aibarvisualeffectmanager.updateFullEffect(10);
      expect((aibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(false);
    });

    it('test_updateFullEffect_2', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'full' };
      (aibarvisualeffectmanager as object)['isVassSupportNewEffect'] = true;
      aibarvisualeffectmanager.updateFullEffect(0);
      expect((aibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(true);
    });

    it('test_updateFullEffect_3', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'lite' };
      (aibarvisualeffectmanager as object)['isVassSupportNewEffect'] = true;
      aibarvisualeffectmanager.updateFullEffect(10);
      expect((aibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(false);
    });

    it('test_updateFullEffect_4', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'lite' };
      (aibarvisualeffectmanager as object)['isVassSupportNewEffect'] = true;
      aibarvisualeffectmanager.updateFullEffect(0);
      expect((aibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(false);
    });

    it('test_updateFullEffect_5', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['profileParam'] = { animationLevel: 'full' };
      (aibarvisualeffectmanager as object)['isVassSupportNewEffect'] = false;
      aibarvisualeffectmanager.updateFullEffect(0);
      expect((aibarvisualeffectmanager as object)['isFullVisualEffect']).assertEqual(false);
    });

    it('test_getEffectLevel_1', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['isFullVisualEffect'] = false;
      const result: ESObject = aibarvisualeffectmanager.getEffectLevel();
      expect(result).assertEqual('lite');
    });

    it('test_getEffectLevel_2', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['isFullVisualEffect'] = true;
      const result: ESObject = aibarvisualeffectmanager.getEffectLevel();
      expect(result).assertEqual('full');
    });

    it('test_isGameScene_1', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      const result: ESObject = (aibarvisualeffectmanager as object)['isGameScene'](1);
      expect(result).assertTrue();
    });

    it('test_isGameScene_2', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      const result: ESObject = (aibarvisualeffectmanager as object)['isGameScene'](0);
      expect(result).assertFalse();
    });

    it('test_isRSSScene_1', 0, async () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      let result: ESObject = (aibarvisualeffectmanager as object)['isRSSScene']();
      expect(result).assertEqual(false);
    });

    it('test_isOverThermalScene_1', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['overThermalLevel'] = thermal.ThermalLevel.HOT;
      let result: ESObject = (aibarvisualeffectmanager as object)['isOverThermalScene'](thermal.ThermalLevel.HOT);
      expect(result).assertEqual(true);
    });

    it('test_isOverThermalScene_2', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      (aibarvisualeffectmanager as object)['overThermalLevel'] = thermal.ThermalLevel.HOT;
      let result: ESObject = (aibarvisualeffectmanager as object)['isOverThermalScene'](thermal.ThermalLevel.WARM);
      expect(result).assertEqual(false);
    });

    it('test_limitAppVsyncStart_1', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      expect(aibarvisualeffectmanager.limitAppVsyncStart(thermal.ThermalLevel.HOT) === undefined).assertTrue();
    });

    it('test_limitAppVsyncStart_2', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      expect(aibarvisualeffectmanager.limitAppVsyncStart(thermal.ThermalLevel.NORMAL) === undefined).assertTrue();
    });

    it('test_limitAppVsyncEnd_1', 0, async () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      expect(aibarvisualeffectmanager.limitAppVsyncEnd() === undefined).assertTrue();
    });

    it('test_checkVassMetaData_1', 0, () => {
      let aibarvisualeffectmanager: AiBarVisualEffectManager = AiBarVisualEffectManager.getInstance();
      const result: ESObject = (aibarvisualeffectmanager as object)['checkVassMetaData']();
      expect(result).assertEqual(true);
    });
  })
}