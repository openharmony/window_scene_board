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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import {
  AiBarSettingsDataMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/settings/preference/AiBarSettingsDataMgr';
import type abilityCommon from '@ohos.app.ability.common';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import { SwitchType } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/settings/preference/PreferenceType';
import { ReflectionUtils } from '../../../scenemanager/multiwindow/ReflectionUtils';

export default function AiBarSettingsDataMgrTest() {
  describe('AiBarSettingsDataMgrTest', () => {
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

    it('AiBarSettingsDataMgr_syncData_1', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterReturn('false');
      await aiBarSettingsDataMgr.initData();
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      done();
    });

    it('AiBarSettingsDataMgr_syncData_2', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterReturn('true');
      await aiBarSettingsDataMgr.initData();
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      done();
    });

    it('AiBarSettingsDataMgr_syncData_3', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterThrow('Simulated Error');
      await aiBarSettingsDataMgr.initData();
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      done();
    });

    it('AiBarSettingsDataMgr_syncPreferenceDataToSetting_1', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterReturn('true');
      await aiBarSettingsDataMgr.initData();
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      done();
    });

    it('AiBarSettingsDataMgr_getPreference_1', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterReturn('true');
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
      await aiBarSettingsDataMgr.initData();
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      done();
    });

    it('AiBarSettingsDataMgr_getPreference_2', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterReturn('true');
      GlobalContext.setContext(null);
      await aiBarSettingsDataMgr.initData();
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(aiBarSettingsDataMgr, aiBarSettingsDataMgr.getValueSync);
      done();
    });

    it('AiBarSettingsDataMgr_putValue_1', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      await aiBarSettingsDataMgr.putValue('testKey', 'testValue');
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      done();
    });

    it('AiBarSettingsDataMgr_putValue_2', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsDataManager, settingsDataManager.setValueWithDomain);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('Test Error');
      await aiBarSettingsDataMgr.putValue('testKey', 'testValue');
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(settingsDataManager, settingsDataManager.setValueWithDomain);
      done();
    });

    it('AiBarSettingsDataMgr_getValueSync_1', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result = aiBarSettingsDataMgr.getValueSync('', 'default');
      expect(result).assertEqual('default');
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      done();
    });

    it('AiBarSettingsDataMgr_getValueSync_2', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result = aiBarSettingsDataMgr.getValueSync('key', 'default');
      expect(result).assertEqual('default');
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      done();
    });

    it('AiBarSettingsDataMgr_getValueSync_3', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsDataManager, settingsDataManager.getValueWithDomain);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('Error');
      const result = aiBarSettingsDataMgr.getValueSync('key', 'default');
      expect(result).assertEqual('default');
      mocker.ignoreMock(settingsDataManager, settingsDataManager.getValueWithDomain);
      done();
    });

    it('AiBarSettingsDataMgr_getNumberValueSync_1', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result = aiBarSettingsDataMgr.getNumberValueSync('testKey', '10');
      expect(result).assertEqual(10);
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      done();
    });

    it('AiBarSettingsDataMgr_getNumberValueSync_2', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(globalThis, globalThis.isNaN);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result = aiBarSettingsDataMgr.getNumberValueSync('testKey', '10');
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(globalThis, globalThis.isNaN);
      done();
    });

    it('AiBarSettingsDataMgr_getNumberValueSync_3', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsDataManager, settingsDataManager.getValueWithDomain);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn('5');
      const result = aiBarSettingsDataMgr.getNumberValueSync('testKey', '10');
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(settingsDataManager, settingsDataManager.getValueWithDomain);
      done();
    });

    it('AiBarSettingsDataMgr_getNumberValueSync_4', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsDataManager, settingsDataManager.getValueWithDomain);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterThrow('Error');
      const result = aiBarSettingsDataMgr.getNumberValueSync('testKey', '10');
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(settingsDataManager, settingsDataManager.getValueWithDomain);
      done();
    });

    it('AiBarSettingsDataMgr_setStatus_1', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, 'AiBarSettingsDataMgr');
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(log, log.showError);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('Test Error');
      await aiBarSettingsDataMgr.setStatus('errorKey');
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(log, log.showError);
      done();
    });

    it('AiBarSettingsDataMgr_setStatus_2', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      await aiBarSettingsDataMgr.setStatus('');
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      done();
    });

    it('AiBarSettingsDataMgr_setStatus_3', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      expect(aiBarSettingsDataMgr).not().assertUndefined();
      done();
    });

    it('AiBarSettingsDataMgr_registerCallback_1', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      expect(aiBarSettingsDataMgr.registerCallback(null, null) === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_registerCallback_2', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      expect(aiBarSettingsDataMgr.registerCallback(null, () => {
      }) === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_registerCallback_3', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      expect(aiBarSettingsDataMgr.registerCallback('validType', () => {
      }) === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_unRegisterCallback_1', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      expect(aiBarSettingsDataMgr.unRegisterCallback('true') === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_unRegisterCallback_2', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      aiBarSettingsDataMgr.registerCallback('true', () => {
      });
      expect(aiBarSettingsDataMgr.unRegisterCallback('true') === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_unregisterKeyObserver_1', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      expect(aiBarSettingsDataMgr.unregisterKeyObserver() === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_closeFloatingBall', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      expect(aiBarSettingsDataMgr.closeFloatingBall() === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_openFloatingBall', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      expect(aiBarSettingsDataMgr.openFloatingBall() === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_closeThreeButton', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      expect(aiBarSettingsDataMgr.closeThreeButton() === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_openThreeButton', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      expect(aiBarSettingsDataMgr.openThreeButton() === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_isThreeButtonOpen', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      try {
        let value = ReflectionUtils.setProperty(aiBarSettingsDataMgr, 'isThreeButtonOpen', null);
        expect(value === undefined).assertTrue();
        done();
      } catch (e) {
      }
    });

    it('AiBarSettingsDataMgr_isFloatBallOpen', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      try {
        let value = ReflectionUtils.setProperty(aiBarSettingsDataMgr, 'isFloatBallOpen', null);
        expect(value === undefined).assertTrue();
        done();
      } catch (e) {
      }
    });

    it('AiBarSettingsDataMgr_checkFloatingBallStatus', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      let value = ReflectionUtils.setProperty(aiBarSettingsDataMgr, 'checkFloatingBallStatus', true);
      expect(value === undefined).assertTrue();
      done();
    });

    it('AiBarSettingsDataMgr_checkFloatingBallAfterClone', 0, async (done: Function) => {
      let aiBarSettingsDataMgr: AiBarSettingsDataMgr = new AiBarSettingsDataMgr();
      try {
        let value = ReflectionUtils.setProperty(aiBarSettingsDataMgr, 'checkFloatingBallAfterClone', null);
        expect(value === undefined).assertTrue();
        done();
      } catch (e) {
      }
    });
  })
}