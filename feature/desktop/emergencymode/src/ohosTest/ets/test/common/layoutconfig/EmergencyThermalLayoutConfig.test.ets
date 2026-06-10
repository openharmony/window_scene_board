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
import { CheckEmptyUtils } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { AppItemInfo } from '@ohos/launchercommon'
import { EmergencyThermalAppVo } from '../../../../../main/ets/common/bean/EmergencyThermalAppVo'
import { EmergencyThermalDefaultAppDto } from '../../../../../main/ets/common/bean/EmergencyThermalDefaultAppDto'
import { EmergencyThermalLayoutConfig } from '../../../../../main/ets/common/layoutconfig/EmergencyThermalLayoutConfig'

export default function EmergencyThermalLayoutConfigTest() {
  describe('EmergencyThermalLayoutConfigTest', () => {
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
    it('test_getInstance', 0, () => {
      let sInstance: EmergencyThermalLayoutConfig = EmergencyThermalLayoutConfig.getInstance();
      expect(sInstance instanceof EmergencyThermalLayoutConfig).assertTrue();
    })

    it('test_initLayoutInfo', 0, async (done: Function) => {
      let sInstance: EmergencyThermalLayoutConfig = EmergencyThermalLayoutConfig.getInstance();
      let EmergencyInfoList: EmergencyThermalAppVo[] = [
        { appItem: { bundleName: 'bundle1', abilityName: 'ability1', appName: 'app1', appIconId: 1 } },
        { appItem: { bundleName: 'bundle2', abilityName: 'ability2', appName: 'app2', appIconId: 2 } },
      ];

      await sInstance.initLayoutInfo(1, EmergencyInfoList);
      expect(sInstance instanceof EmergencyThermalLayoutConfig).assertTrue();
      done();
    })

    it('test_checkAndInitLayout', 0, async (done: Function) => {
      let sInstance: EmergencyThermalLayoutConfig = EmergencyThermalLayoutConfig.getInstance();
      let EmergencyThermalDefaultAppDto: EmergencyThermalDefaultAppDto[] = [
        { bundleName: 'bundle2', abilityName: 'ability2', type: 1 },
        { bundleName: 'bundle2', abilityName: 'ability2', type: 2 }
      ];
      let EmergencyInfoList: EmergencyThermalAppVo[] = [
        { appItem: { bundleName: 'bundle1', abilityName: 'ability1', appName: 'app1', appIconId: 1 } },
        { appItem: { bundleName: 'bundle2', abilityName: 'ability2', appName: 'app2', appIconId: 2 } },
        { appItem: { bundleName: 'bundle1', abilityName: 'ability1', appName: 'app1', appIconId: 1 } },
        { appItem: { bundleName: 'bundle2', abilityName: 'ability2', appName: 'app2', appIconId: 2 } },
        { appItem: { bundleName: 'bundle1', abilityName: 'ability1', appName: 'app1', appIconId: 1 } },
        { appItem: { bundleName: 'bundle2', abilityName: 'ability2', appName: 'app2', appIconId: 2 } },
        { appItem: { bundleName: 'bundle2', abilityName: 'ability2', appName: 'app2', appIconId: 2 } },
        { appItem: { bundleName: 'bundle2', abilityName: 'ability2', appName: 'app2', appIconId: 2 } },
        { appItem: { bundleName: 'bundle2', abilityName: 'ability2', appName: 'app2', appIconId: 2 } },
      ];
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      await (sInstance as object)['checkAndInitLayout'](EmergencyThermalDefaultAppDto, 1, EmergencyInfoList);
      expect(sInstance instanceof EmergencyThermalLayoutConfig).assertTrue();
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it('test_filterAndInitLayoutItem', 0, () => {
      try {
        let sInstance: EmergencyThermalLayoutConfig = EmergencyThermalLayoutConfig.getInstance();
        (sInstance as object)['filterAndInitLayoutItem']([], {
          bundleName: 'bundle2', abilityName: 'ability2'
        }, []);
        let appItemInfo: AppItemInfo[] = [
          {
            bundleName: 'bundle1',
            abilityName: 'ability1',
            appName: 'app1',
            appIconId: 1
          },
          {
            bundleName: 'bundle2',
            abilityName: 'ability2',
            appName: 'app2',
            appIconId: 2
          },
        ];
        let EmergencyThermalDefaultAppDto: EmergencyThermalDefaultAppDto = {
          bundleName: 'bundle2', abilityName: 'ability2'
        };

        let rstList: EmergencyThermalAppVo[] = [
          {
            appItem: {
              bundleName: 'bundle1',
              abilityName: 'ability1',
              appName: 'app1',
              appIconId: 1
            }
          },
          {
            appItem: {
              bundleName: 'bundle2',
              abilityName: 'ability2',
              appName: 'app2',
              appIconId: 2
            }
          },
        ];
        (sInstance as object)['filterAndInitLayoutItem'](appItemInfo, EmergencyThermalDefaultAppDto, rstList);
        expect(sInstance instanceof EmergencyThermalLayoutConfig).assertTrue();
      }catch(err){

      }
    })

  })
}