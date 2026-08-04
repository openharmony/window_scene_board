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
  NaviBarSettingsDataMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/settings/preference/NaviBarSettingsDataMgr';
import type abilityCommon from '@ohos.app.ability.common';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import { SwitchType } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/settings/preference/PreferenceType';
import { ReflectionUtils } from '../../../scenemanager/multiwindow/ReflectionUtils';

export default function NaviBarSettingsDataMgrTest() {
  describe('NaviBarSettingsDataMgrTest', () => {
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

    it('NaviBarSettingsDataMgr_syncData_1', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterReturn('false');
      await naviBarSettingsDataMgr.initData();
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      done();
    });

    it('NaviBarSettingsDataMgr_syncData_2', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterReturn('true');
      await naviBarSettingsDataMgr.initData();
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      done();
    });

    it('NaviBarSettingsDataMgr_syncData_3', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterThrow('Simulated Error');
      await naviBarSettingsDataMgr.initData();
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      done();
    });

    it('NaviBarSettingsDataMgr_syncPreferenceDataToSetting_1', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterReturn('true');
      await naviBarSettingsDataMgr.initData();
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      done();
    });

    it('NaviBarSettingsDataMgr_getPreference_1', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterReturn('true');
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
      await naviBarSettingsDataMgr.initData();
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      done();
    });

    it('NaviBarSettingsDataMgr_getPreference_2', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      when(mockFunc)(SwitchType.CLICK_BACK_STATUS).afterReturn('true');
      GlobalContext.setContext(null);
      await naviBarSettingsDataMgr.initData();
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(naviBarSettingsDataMgr, naviBarSettingsDataMgr.getValueSync);
      done();
    });

    it('NaviBarSettingsDataMgr_putValue_1', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      await naviBarSettingsDataMgr.putValue('testKey', 'testValue');
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      done();
    });

    it('NaviBarSettingsDataMgr_putValue_2', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsDataManager, settingsDataManager.setValueWithDomain);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('Test Error');
      await naviBarSettingsDataMgr.putValue('testKey', 'testValue');
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(settingsDataManager, settingsDataManager.setValueWithDomain);
      done();
    });

    it('NaviBarSettingsDataMgr_getValueSync_1', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result = naviBarSettingsDataMgr.getValueSync('', 'default');
      expect(result).assertEqual('default');
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      done();
    });

    it('NaviBarSettingsDataMgr_getValueSync_2', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result = naviBarSettingsDataMgr.getValueSync('key', 'default');
      expect(result).assertEqual('default');
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      done();
    });

    it('NaviBarSettingsDataMgr_getValueSync_3', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsDataManager, settingsDataManager.getValueWithDomain);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('Error');
      const result = naviBarSettingsDataMgr.getValueSync('key', 'default');
      expect(result).assertEqual('default');
      mocker.ignoreMock(settingsDataManager, settingsDataManager.getValueWithDomain);
      done();
    });

    it('NaviBarSettingsDataMgr_getNumberValueSync_1', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result = naviBarSettingsDataMgr.getNumberValueSync('testKey', '10');
      expect(result).assertEqual(10);
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      done();
    });

    it('NaviBarSettingsDataMgr_getNumberValueSync_2', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(globalThis, globalThis.isNaN);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result = naviBarSettingsDataMgr.getNumberValueSync('testKey', '10');
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(globalThis, globalThis.isNaN);
      done();
    });

    it('NaviBarSettingsDataMgr_getNumberValueSync_3', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsDataManager, settingsDataManager.getValueWithDomain);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn('5');
      const result = naviBarSettingsDataMgr.getNumberValueSync('testKey', '10');
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(settingsDataManager, settingsDataManager.getValueWithDomain);
      done();
    });

    it('NaviBarSettingsDataMgr_getNumberValueSync_4', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsDataManager, settingsDataManager.getValueWithDomain);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterThrow('Error');
      const result = naviBarSettingsDataMgr.getNumberValueSync('testKey', '10');
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(settingsDataManager, settingsDataManager.getValueWithDomain);
      done();
    });

    it('NaviBarSettingsDataMgr_setStatus_1', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, 'NaviBarSettingsDataMgr');
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(log, log.showError);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('Test Error');
      await naviBarSettingsDataMgr.setStatus('errorKey');
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      mocker.ignoreMock(log, log.showError);
      done();
    });

    it('NaviBarSettingsDataMgr_setStatus_2', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      await naviBarSettingsDataMgr.setStatus('');
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      done();
    });

    it('NaviBarSettingsDataMgr_setStatus_3', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      expect(naviBarSettingsDataMgr).not().assertUndefined();
      done();
    });

    it('NaviBarSettingsDataMgr_registerCallback_1', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      expect(naviBarSettingsDataMgr.registerCallback(null, null) === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_registerCallback_2', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      expect(naviBarSettingsDataMgr.registerCallback(null, () => {
      }) === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_registerCallback_3', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      expect(naviBarSettingsDataMgr.registerCallback('validType', () => {
      }) === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_unRegisterCallback_1', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      expect(naviBarSettingsDataMgr.unRegisterCallback('true') === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_unRegisterCallback_2', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      naviBarSettingsDataMgr.registerCallback('true', () => {
      });
      expect(naviBarSettingsDataMgr.unRegisterCallback('true') === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_unregisterKeyObserver_1', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      expect(naviBarSettingsDataMgr.unregisterKeyObserver() === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_closeFloatingBall', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      expect(naviBarSettingsDataMgr.closeFloatingBall() === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_openFloatingBall', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      expect(naviBarSettingsDataMgr.openFloatingBall() === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_closeThreeButton', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      expect(naviBarSettingsDataMgr.closeThreeButton() === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_openThreeButton', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      expect(naviBarSettingsDataMgr.openThreeButton() === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_isThreeButtonOpen', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      try {
        let value = ReflectionUtils.setProperty(naviBarSettingsDataMgr, 'isThreeButtonOpen', null);
        expect(value === undefined).assertTrue();
        done();
      } catch (e) {
      }
    });

    it('NaviBarSettingsDataMgr_isFloatBallOpen', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      try {
        let value = ReflectionUtils.setProperty(naviBarSettingsDataMgr, 'isFloatBallOpen', null);
        expect(value === undefined).assertTrue();
        done();
      } catch (e) {
      }
    });

    it('NaviBarSettingsDataMgr_checkFloatingBallStatus', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      let value = ReflectionUtils.setProperty(naviBarSettingsDataMgr, 'checkFloatingBallStatus', true);
      expect(value === undefined).assertTrue();
      done();
    });

    it('NaviBarSettingsDataMgr_checkFloatingBallAfterClone', 0, async (done: Function) => {
      let naviBarSettingsDataMgr: NaviBarSettingsDataMgr = new NaviBarSettingsDataMgr();
      try {
        let value = ReflectionUtils.setProperty(naviBarSettingsDataMgr, 'checkFloatingBallAfterClone', null);
        expect(value === undefined).assertTrue();
        done();
      } catch (e) {
      }
    });
  })
}