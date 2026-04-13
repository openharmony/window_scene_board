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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { DesktopModeChangeFunc,
  PriorityCallBack } from '../../../../../../../main/ets/desktopmode/statemanager/DesktopModeManager';
import { BaseModeState } from '../../../../../../../main/ets/desktopmode/statemanager/modelstate/BaseModeState';
import type DesktopModeState from '../../../../../../../main/ets/desktopmode/statemanager/modelstate/DesktopModeState';
import {
  TherEmcOverlayModeState
} from '../../../../../../../main/ets/desktopmode/statemanager/modelstate/TherEmcOverlayModeState';
import { DesktopModeEnum, DesktopModeManager } from '../../../../../../../main/ets/TsIndex';

const TAG = 'DesktopModeManagerTest';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default function DesktopModeManagerTest() {
  describe('DesktopModeManagerTest', () => {
    const instance: DesktopModeManager = DesktopModeManager.getInstance();
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('should return an instance of DesktopModeManager', 0, () => {
      const instance_1: DesktopModeManager = DesktopModeManager.getInstance();
      const instance_2: DesktopModeManager = DesktopModeManager.getInstance();
      expect(instance_1).assertEqual(instance);
      expect(instance_2).assertEqual(instance);
    });

    it('should register a callback successfully', 0, () => {
      instance['desktopModeChangeCallbacks'].clear();
      let registerTag: string = 'tag';
      let desktopModeChangeFunc = (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {};
      instance.registerModeChangeCallback(registerTag, desktopModeChangeFunc);
      let length: number = instance['desktopModeChangeCallbacks'].size;
      expect(registerTag).assertEqual('tag');
    });

    it('should not register a callback if the tag is empty', 0, () => {
      instance['desktopModeChangeCallbacks'].clear();
      let desktopModeChangeFunc = (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {};
      instance.registerModeChangeCallback('', desktopModeChangeFunc);
      let length: number = instance['desktopModeChangeCallbacks'].size;
      expect(instance).not().assertUndefined();
    });

    it('should not register a callback if the callback is empty', 0, () => {
      instance['desktopModeChangeCallbacks'].clear();
      instance.registerModeChangeCallback('tag', null);
      let length: number = instance['desktopModeChangeCallbacks'].size;
      expect(instance).not().assertUndefined();
    });

    it('should not register a callback if the tag is already registered', 0, () => {
      instance['desktopModeChangeCallbacks'].clear();
      let registerTag: string = 'tag';
      let desktopModeChangeFunc = (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {};
      instance.registerModeChangeCallback(registerTag, desktopModeChangeFunc);
      instance.registerModeChangeCallback(registerTag, desktopModeChangeFunc);
      let length: number = instance['desktopModeChangeCallbacks'].size;
      expect(registerTag).assertEqual('tag');
    });

    it('should delete the callback and log success message', 0, () => {
      instance['desktopModeChangeCallbacks'].clear();
      let registerTag: string = 'tag';
      let desktopModeChangeFunc = (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {};
      let priorityCallBack: PriorityCallBack = new PriorityCallBack(desktopModeChangeFunc, 1);
      instance['desktopModeChangeCallbacks'].set(registerTag, priorityCallBack);
      instance.unRegisterModeChangeCallback(registerTag);
      expect(instance['desktopModeChangeCallbacks'].has(registerTag)).assertFalse();
    });

    it('should not log success message when registerTag does not exist', 0, () => {
      instance['desktopModeChangeCallbacks'].clear();
      let registerTag: string = 'tag';
      let notRegisterTag: string = 'not_tag';
      let desktopModeChangeFunc = (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {};
      let priorityCallBack: PriorityCallBack = new PriorityCallBack(desktopModeChangeFunc, 1);
      instance['desktopModeChangeCallbacks'].set(registerTag, priorityCallBack);
      instance.unRegisterModeChangeCallback(notRegisterTag);
      expect(instance['desktopModeChangeCallbacks'].has(registerTag)).assertTrue();
    });

    it('should change mode state from prev to target', 0, () => {
      let preStateMode: DesktopModeState = BaseModeState.getInstance();
      let targetState: DesktopModeState = TherEmcOverlayModeState.getInstance();;
      instance.changeModeStateTo(targetState);
      expect(instance['desktopModeState'].getStateMode()).assertEqual(targetState.getStateMode());
    });

    it('test_registerUnRegisterModeChangeCallback_001', 0, () => {
      let registerTag = 'testRegisterTag0001987';
      instance.unRegisterModeChangeCallback(registerTag);
      let hasRegisterTag = instance['desktopModeChangeCallbacks'].has(registerTag);
      expect(hasRegisterTag).assertFalse();
      let callBack = (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {
      };
      instance.registerModeChangeCallback(registerTag, callBack);
      let hasRegisterTag1 = instance['desktopModeChangeCallbacks'].has(registerTag);
      expect(hasRegisterTag1).assertTrue();
      instance.registerModeChangeCallback(registerTag, callBack);
      let hasRegisterTag2 = instance['desktopModeChangeCallbacks'].has(registerTag);
      expect(hasRegisterTag2).assertTrue();
      instance.unRegisterModeChangeCallback(registerTag);
      instance.registerModeChangeCallback('', callBack);
      let hasRegisterTag3 = instance['desktopModeChangeCallbacks'].has(registerTag);
      expect(instance).not().assertUndefined();
      instance.registerModeChangeCallback(registerTag, null);
      let hasRegisterTag4 = instance['desktopModeChangeCallbacks'].has(registerTag);
      expect(instance).not().assertUndefined();
      instance.registerModeChangeCallback(registerTag, callBack);
      let hasRegisterTag5 = instance['desktopModeChangeCallbacks'].has(registerTag);
      expect(instance).not().assertUndefined();
    });

    it('test_changeModeStateTo_001', 0, () => {
      AppStorage.setOrCreate('deviceModeState', Number(DesktopModeEnum.THER_EMC_OVERLAY_MODE));
      expect(AppStorage.get('deviceModeState')).assertEqual(DesktopModeEnum.THER_EMC_OVERLAY_MODE);
      let preStateMode: DesktopModeState =  instance['desktopModeState'];
      expect(preStateMode).not().assertNull();
      expect(AppStorage.get('deviceModeState')).assertEqual(DesktopModeEnum.THER_EMC_OVERLAY_MODE);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(preStateMode, preStateMode.getStateMode);
      when(mockFunc)().afterReturn(DesktopModeEnum.THERMAL_SAFE_MODE);
      let targetState: DesktopModeState = TherEmcOverlayModeState.getInstance();
      let mockFunc1: Function = mocker.mockFunc(targetState, targetState.getStateMode);
      when(mockFunc1)().afterReturn(DesktopModeEnum.THER_EMC_OVERLAY_MODE);
      instance.changeModeStateTo(targetState);
      expect(AppStorage.get('deviceModeState')).not().assertUndefined();
      mocker.clear(preStateMode);
      mocker.clear(targetState);
      mocker.clearAll();
    });

    it('test_changeModeStateTo_002', 0, () => {
      AppStorage.setOrCreate('deviceModeState', Number(DesktopModeEnum.THERMAL_SAFE_MODE));
      expect(AppStorage.get('deviceModeState')).assertEqual(Number(DesktopModeEnum.THERMAL_SAFE_MODE));
      let preStateMode: DesktopModeState = instance['desktopModeState'];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(preStateMode, preStateMode.getStateMode);
      let targetState: DesktopModeState = BaseModeState.getInstance();
      let mockFunc1: Function = mocker.mockFunc(targetState, targetState.getStateMode);
      when(mockFunc)().afterReturn(DesktopModeEnum.THER_EMC_OVERLAY_MODE);
      when(mockFunc1)().afterReturn(DesktopModeEnum.THERMAL_SAFE_MODE);
      instance.changeModeStateTo(targetState);
      expect(AppStorage.get('deviceModeState')).assertEqual(Number(DesktopModeEnum.THERMAL_SAFE_MODE));
      mocker.clear(preStateMode);
      mocker.clear(targetState);
      mocker.clearAll();
    });

    it('test_changeModeStateTo_003', 0, () => {
      AppStorage.setOrCreate('deviceModeState', Number(DesktopModeEnum.THERMAL_SAFE_MODE));
      let preStateMode: DesktopModeState =  instance['desktopModeState'];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(preStateMode, preStateMode.getStateMode);
      let targetState: DesktopModeState = TherEmcOverlayModeState.getInstance();
      let mockFunc1: Function = mocker.mockFunc(targetState, targetState.getStateMode);
      when(mockFunc)().afterReturn(DesktopModeEnum.THER_EMC_OVERLAY_MODE);
      when(mockFunc1)().afterReturn(DesktopModeEnum.THER_EMC_OVERLAY_MODE);
      instance.changeModeStateTo(targetState);
      expect(AppStorage.get('deviceModeState')).assertEqual(Number(DesktopModeEnum.THERMAL_SAFE_MODE));
      mocker.clear(preStateMode);
      mocker.clear(targetState);
      mocker.clearAll();
    });

    it('test_getDesktopMode', 0, () => {
      let preStateMode: DesktopModeState = instance['desktopModeState'];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(preStateMode, preStateMode.getStateMode);
      when(mockFunc)().afterReturn(DesktopModeEnum.THER_EMC_OVERLAY_MODE);
      let mode = instance.getDesktopMode();
      expect(mode).assertEqual(DesktopModeEnum.THERMAL_SAFE_MODE);
      mocker.clear(preStateMode);
      mocker.clearAll();
    });
  })
}