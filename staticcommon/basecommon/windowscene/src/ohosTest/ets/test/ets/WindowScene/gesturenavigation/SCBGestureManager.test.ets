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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  Size,
  TestType,
  when
} from '@ohos/hypium';
import {
  GestureType,
  GestureEnableCaller,
  scbGestureManager
} from '../../../../../../main/ets/gesturenavigation/SCBGestureManager';

export default function SCBGestureManagerTest() {
  describe('SCBGestureManagerTest', () => {
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

    it('SCBGestureManagerTest_unregisterPcKeyCallback', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      const TAG = 'SCBGestureManagerTest';
      scbGestureManager['pcKeyEventCallBack'].set(TAG, (): void => {
      });
      expect(scbGestureManager.unregisterPcKeyCallback(TAG) === undefined).assertTrue();
      scbGestureManager.unregisterPcKeyCallback('TAG');
    })

    it('SCBGestureManagerTest_unRegisterGestureEnabledCallback', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      expect(scbGestureManager.unRegisterGestureEnabledCallback(gestureType) === undefined).assertTrue();
      scbGestureManager.unRegisterGestureEnabledCallback(gestureType);
    })

    it('SCBGestureManagerTest_registerGestureEnabledCallback_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let type: GestureType = GestureType.BACK;
      expect(scbGestureManager.registerGestureEnabledCallback(type, null) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerGestureEnabledCallback_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let type: GestureType = GestureType.BACK;
      expect(scbGestureManager.registerGestureEnabledCallback(type, (): void => {
      }) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerGestureEnabledCallback_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let type: GestureType = GestureType.NAVIGATION;
      expect(scbGestureManager.registerGestureEnabledCallback(type, null) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerGestureEnabledCallback_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let type: GestureType = GestureType.NAVIGATION;
      expect(scbGestureManager.registerGestureEnabledCallback(type, (): void => {
      }) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerGestureEnabledCallback_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let type: GestureType = GestureType.PC_BACK;
      expect(scbGestureManager.registerGestureEnabledCallback(type, (): void => {
      }) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_setGestureNavigationEnable_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['isEnableCallBackMap'].set(GestureType.BACK, (): Function | null => null);
      scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.SCREEN_LOCK, true, true);
      scbGestureManager['isEnableCallBackMap'].set(GestureType.BACK, () => {
      });
      let key: GestureType = GestureType.BACK;
      expect(scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.SCREEN_LOCK, true, true) === undefined).assertTrue();
      key = GestureType.NAVIGATION;
      scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.SCREEN_LOCK, true, true);
      key = GestureType.PC_BACK;
      scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.SCREEN_LOCK, true, true);
    })

    it('SCBGestureManagerTest_setGestureNavigationEnablePriority', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['isEnableCallBackMap'].set(GestureType.BACK, (): Function | null => null);
      scbGestureManager.setGestureNavigationEnablePriority(GestureEnableCaller.SCREEN_LOCK, true, true);
      scbGestureManager['isEnableCallBackMap'].set(GestureType.NAVIGATION, () => {
      });
      let key: GestureType = GestureType.NAVIGATION;
      expect(scbGestureManager.setGestureNavigationEnablePriority(GestureEnableCaller.SCREEN_LOCK, true, true) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerGestureEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['gestureEventCallBack'].delete(gestureType);
      expect(scbGestureManager.registerGestureEvent(gestureType, sceneType, (): void => {
      }) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerGestureEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['gestureEventCallBack'].set(gestureType, new Map());
      expect(scbGestureManager.registerGestureEvent(gestureType, sceneType, (): void => {
      }) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerGestureEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['gestureEventCallBack'].set(gestureType, new Map());
      scbGestureManager['gestureEventCallBack'].get(gestureType)?.set(sceneType, ()=>{});
      expect(scbGestureManager.registerGestureEvent(gestureType, sceneType, (): void => {
      }) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_unRegisterGestureEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['gestureEventCallBack'].delete(gestureType);
      expect(scbGestureManager.unRegisterGestureEvent(gestureType, sceneType) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_unRegisterGestureEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['gestureEventCallBack'].set(gestureType, new Map());
      expect(scbGestureManager.unRegisterGestureEvent(gestureType, sceneType) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_unRegisterGestureEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['gestureEventCallBack'].set(gestureType, new Map());
      scbGestureManager['gestureEventCallBack'].get(gestureType)?.set(sceneType, ()=>{});
      expect(scbGestureManager.unRegisterGestureEvent(gestureType, sceneType) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerTouchEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      let callBack: Function = () => {
      };
      scbGestureManager['touchEventCallBack'].delete(gestureType);
      expect(scbGestureManager.registerTouchEvent(gestureType, sceneType, callBack) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerTouchEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      let callBack: Function = () => {
      };
      scbGestureManager['touchEventCallBack'].set(gestureType, new Map());
      expect(scbGestureManager.registerTouchEvent(gestureType, sceneType, callBack) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerTouchEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      let callBack: Function = () => {
      };
      scbGestureManager['touchEventCallBack'].set(gestureType, new Map());
      scbGestureManager['touchEventCallBack'].get(gestureType)?.set(sceneType, () => {
      });
      expect(scbGestureManager.registerTouchEvent(gestureType, sceneType, callBack) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_unRegisterTouchEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['touchEventCallBack'].delete(gestureType);
      expect(scbGestureManager.unRegisterTouchEvent(gestureType, sceneType) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_unRegisterTouchEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['touchEventCallBack'].set(gestureType, new Map());
      expect(scbGestureManager.unRegisterTouchEvent(gestureType, sceneType) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_unRegisterTouchEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['touchEventCallBack'].set(gestureType, new Map());
      scbGestureManager['touchEventCallBack'].get(gestureType)?.set(sceneType, ()=>{});
      expect(scbGestureManager.unRegisterTouchEvent(gestureType, sceneType) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_onTouchEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['touchEventCallBack'].set(gestureType, new Map());
      expect(scbGestureManager.onTouchEvent(gestureType, sceneType) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_onTouchEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      scbGestureManager['touchEventCallBack'].delete(gestureType);
      expect(scbGestureManager.onTouchEvent(gestureType, sceneType) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_setGestureNavigationEnable', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['isEnableCallBackMap'].set(GestureType.BACK, (): Function | null => null);
      scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.SCREEN_LOCK, true, true);
      scbGestureManager['isEnableCallBackMap'].set(GestureType.BACK, () => {
      });
      expect(scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.SCREEN_LOCK, true, true) === undefined).
      assertTrue();
    })

    it('SCBGestureManagerTest_registerPCKey_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['isEnableCallBackMap'].set(GestureType.BACK, (): Function | null => null);
      expect(scbGestureManager.initGestureNavigationManager() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerPCKey_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['isEnableCallBackMap'].set(GestureType.BACK, () => {
      });
      expect(scbGestureManager.initGestureNavigationManager() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_onGestureNavigationEnabledChange_001', 0, (): void => {
      let caller = GestureEnableCaller.SAMPLE_MANAGEMENT;
      expect(scbGestureManager['onGestureNavigationEnabledChange'](true, caller, 0) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_onGestureNavigationEnabledChange_002', 0, (): void => {
      let caller = GestureEnableCaller.PROJECT_MENU;
      expect(scbGestureManager['onGestureNavigationEnabledChange'](true, caller, 2) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_onGestureNavigationEnabledChange_003', 0, (): void => {
      let caller = GestureEnableCaller.MMI_TEST;
      expect(scbGestureManager['onGestureNavigationEnabledChange'](true, caller, 2) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_onGestureNavigationEnabledChange_004', 0, (): void => {
      let caller = GestureEnableCaller.OOBE;
      expect(scbGestureManager['onGestureNavigationEnabledChange'](true, caller, 2) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_onGestureNavigationEnabledChange_005', 0, (): void => {
      let caller = GestureEnableCaller.OOBE;
      expect(scbGestureManager['onGestureNavigationEnabledChange'](true, caller, 6) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_processGestureEnable_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['isEnableCallBackMap'].set(GestureType.BACK, (): Function | null => null);
      expect(scbGestureManager.setGestureNavigationEnablePriority(
        GestureEnableCaller.SAMPLE_MANAGEMENT, true, true) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_processGestureEnable_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['isEnableCallBackMap'].set(GestureType.BACK, (): void => {
      });
      scbGestureManager['isEnableCallBackMap'].set(GestureType.NAVIGATION, (): void => {
      });
      expect(scbGestureManager.setGestureNavigationEnablePriority(
        GestureEnableCaller.SAMPLE_MANAGEMENT, true, true) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_processGestureEnable_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['isEnableCallBackMap'].set(GestureType.NAVIGATION, (): void => {
      });
      expect(scbGestureManager.setGestureNavigationEnablePriority(
        GestureEnableCaller.SAMPLE_MANAGEMENT, true, true) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_checkGestureEnable_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let callerEnableMap: Map<GestureEnableCaller, boolean> = new Map();
      callerEnableMap.set(GestureEnableCaller.WATCH_SCENE_PANEL, false);
      expect(scbGestureManager['checkGestureEnable'](GestureType.BACK, callerEnableMap) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_onGestureEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureType: GestureType = GestureType.BACK;
      let sceneType: string = 'SCBGestureManagerTest';
      expect(scbGestureManager.onGestureEvent(gestureType, sceneType) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerWinDEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['canRespondWinD'] = true;
      expect(scbGestureManager.registerPublicKey() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerWinDEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['canRespondWinD'] = false;
      expect(scbGestureManager.registerPublicKey() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerWinTabEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['canRespondWinTab'] = true;
      expect(scbGestureManager.registerPublicKey() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerWinTabEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['canRespondWinTab'] = false;
      expect(scbGestureManager.registerPublicKey() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerWinDpapUPEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['canRespondWinDpapUP'] = true;
      expect(scbGestureManager.registerPublicKey() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerWinDpapUPEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['canRespondWinDpapUP'] = false;
      expect(scbGestureManager.registerPublicKey() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerFn0Event_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['canRespondFn0'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(scbGestureManager.registerPublicKey() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerFn0Event_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbGestureManager['canRespondFn0'] = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(scbGestureManager.registerPublicKey() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_debugSetGestureNavigationEnable_1', 0, (): void => {
      let args = [GestureEnableCaller.SAMPLE_MANAGEMENT, 'false', 'false'];
      expect(scbGestureManager['debugSetGestureNavigationEnable'](args) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_debugSetGestureNavigationEnable_3', 0, (): void => {
      let args = [GestureEnableCaller.SAMPLE_MANAGEMENT, 'undefined', 'false', 'false'];
      expect(scbGestureManager['debugSetGestureNavigationEnable'](args) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_debugSetGestureNavigationEnable_4', 0, (): void => {
      let args = [GestureEnableCaller.SAMPLE_MANAGEMENT, 'false', 'undefined', 'false'];
      expect(scbGestureManager['debugSetGestureNavigationEnable'](args) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_debugSetGestureNavigationEnable_5', 0, (): void => {
      let args = [GestureEnableCaller.SAMPLE_MANAGEMENT, 'false', 'false', 'undefined'];
      expect(scbGestureManager['debugSetGestureNavigationEnable'](args) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_debugSetGestureNavigationEnable_6', 0, (): void => {
      let args = [GestureEnableCaller.SAMPLE_MANAGEMENT, 'false', 'false', 'true'];
      expect(scbGestureManager['debugSetGestureNavigationEnable'](args) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_debugSetGestureNavigationEnable_7', 0, (): void => {
      let args = [GestureEnableCaller.SAMPLE_MANAGEMENT, 'false', 'false', 'false'];
      expect(scbGestureManager['debugSetGestureNavigationEnable'](args) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_debugSetGestureNavigationEnable_8', 0, (): void => {
      let args = [GestureEnableCaller.OOBE, 'false', 'false', 'false'];
      expect(scbGestureManager['debugSetGestureNavigationEnable'](args) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_debugSetGestureNavigationEnable_9', 0, (): void => {
      let args = [GestureEnableCaller.OOBE, 'false', 'false', 'false', 'false', 'false', 'false'];
      expect(scbGestureManager['debugSetGestureNavigationEnable'](args) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_debugSetGestureNavigationEnable_10', 0, (): void => {
      let args = [GestureEnableCaller.OOBE, 'false', 'false', 'true'];
      expect(scbGestureManager['debugSetGestureNavigationEnable'](args) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_debugSetGestureNavigationEnable_10', 0, (): void => {
      let args = [GestureEnableCaller.MMI_TEST, 'false', 'false', 'true', '0'];
      expect(scbGestureManager['debugSetGestureNavigationEnable'](args) !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_isSystemAppCaller_1', 0, (): void => {
      expect(scbGestureManager['isSystemAppCaller'](GestureEnableCaller.SAMPLE_MANAGEMENT)).assertTrue();
    })

    it('SCBGestureManagerTest_isSystemAppCaller_2', 0, (): void => {
      expect(scbGestureManager['isSystemAppCaller'](GestureEnableCaller.MMI_TEST)).assertTrue();
    })

    it('SCBGestureManagerTest_isSystemAppCaller_3', 0, (): void => {
      expect(scbGestureManager['isSystemAppCaller'](GestureEnableCaller.PROJECT_MENU)).assertTrue();
    })

    it('SCBGestureManagerTest_isSystemAppCaller_4', 0, (): void => {
      expect(scbGestureManager['isSystemAppCaller'](GestureEnableCaller.SYSTEM_DIALOG)).assertFalse();
    })

    it('SCBGestureManagerTest_getBooleanByString_1', 0, (): void => {
      expect(scbGestureManager['getBooleanByString']('true')).assertTrue();
    })

    it('SCBGestureManagerTest_getBooleanByString_2', 0, (): void => {
      expect(scbGestureManager['getBooleanByString']('false')).assertFalse();
    })

    it('SCBGestureManagerTest_getBooleanByString_3', 0, (): void => {
      expect(scbGestureManager['getBooleanByString']('undefined') === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_resetThirdAppEnable_1', 0, (): void => {
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbGestureManager, scbGestureManager['isThirdAppCaller']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      scbGestureManager['gestureBackEnableMap'].set('test', false);
      expect(scbGestureManager['resetThirdAppEnable']() === undefined).assertTrue();
      mocker.ignoreMock(scbGestureManager, scbGestureManager['isThirdAppCaller']);
    })

    it('SCBGestureManagerTest_isThirdAppCaller_1', 0, (): void => {
      expect(scbGestureManager['isThirdAppCaller']('test') !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_isThirdAppCaller_2', 0, (): void => {
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbGestureManager, scbGestureManager['isSystemAppCaller']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(scbGestureManager['isThirdAppCaller']('test') !== undefined).assertTrue();
      mocker.ignoreMock(scbGestureManager, scbGestureManager['isSystemAppCaller']);
    })

    it('SCBGestureManagerTest_isThirdAppCaller_3', 0, (): void => {
      let mocker = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(scbGestureManager, scbGestureManager['isSystemAppCaller']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(scbGestureManager, scbGestureManager['getSceneBoardCallerByString']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      expect(scbGestureManager['isThirdAppCaller']('test') !== undefined).assertTrue();
      mocker.ignoreMock(scbGestureManager, scbGestureManager['isSystemAppCaller']);
      mocker.ignoreMock(scbGestureManager, scbGestureManager['getSceneBoardCallerByString']);
    })

    it('SCBGestureManagerTest_getSceneBoardCallerByString_1', 0, (): void => {
      expect(scbGestureManager['getSceneBoardCallerByString'](GestureEnableCaller.WATCH_SCENE_PANEL) !== undefined)
        .assertTrue();
    })

    it('SCBGestureManagerTest_getSceneBoardCallerByString_2', 0, (): void => {
      expect(scbGestureManager['getSceneBoardCallerByString'](GestureEnableCaller.OOBE) !== undefined)
        .assertTrue();
    })

    it('SCBGestureManagerTest_getSceneBoardCallerByString_3', 0, (): void => {
      expect(scbGestureManager['getSceneBoardCallerByString'](GestureEnableCaller.SYSTEM_DIALOG) !== undefined)
        .assertTrue();
    })

    it('SCBGestureManagerTest_getSceneBoardCallerByString_4', 0, (): void => {
      expect(scbGestureManager['getSceneBoardCallerByString'](GestureEnableCaller.SCREEN_LOCK) !== undefined)
        .assertTrue();
    })

    it('SCBGestureManagerTest_getSceneBoardCallerByString_5', 0, (): void => {
      expect(scbGestureManager['getSceneBoardCallerByString']('test') === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_gestureEventCallback_1', 0, (): void => {
      scbGestureManager['gestureCallBackMap'].set(1, new Map());
      expect(scbGestureManager.gestureEventCallback(0) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_gestureEventCallback_2', 0, (): void => {
      scbGestureManager['gestureCallBackMap'].set(1, new Map());
      expect(scbGestureManager.gestureEventCallback(1) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_onGestureEventCallback_1', 0, (): void => {
      scbGestureManager['gestureCallBackMap'].set(1, new Map());
      scbGestureManager.onGestureEventCallback(5, 1, () => {
      })
      expect(scbGestureManager.onGestureEventCallback(5, 1, () => {
      }) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_onGestureEventCallback_2', 0, (): void => {
      scbGestureManager['gestureCallBackMap'].set(5, new Map());
      expect(scbGestureManager.onGestureEventCallback(5, 5, () => {
      }) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_aiBarChange_1', 0, (): void => {
      scbGestureManager['aiBarChangeAnimCallBack'] = () => undefined;
      expect(scbGestureManager.aiBarChange(1) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_aiBarChange_2', 0, (): void => {
      scbGestureManager['aiBarChangeAnimCallBack'] = () => {
      }
      expect(scbGestureManager.aiBarChange(1) === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_getNumberByString_1', 0, (): void => {
      expect(scbGestureManager['getNumberByString']('0') !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_getNumberByString_2', 0, (): void => {
      expect(scbGestureManager['getNumberByString']('2') !== undefined).assertTrue();
    })

    it('SCBGestureManagerTest_getNumberByString_3', 0, (): void => {
      expect(scbGestureManager['getNumberByString']('3') === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_registerKioskModeChangeCallback_1', 0, (): void => {
      expect(scbGestureManager.registerKioskModeChangeCallback() === undefined).assertTrue();
    })

    it('SCBGestureManagerTest_unRegisterKioskModeChangeCallback_1', 0, (): void => {
      expect(scbGestureManager.unRegisterKioskModeChangeCallback() === undefined).assertTrue();
    })
  })
}