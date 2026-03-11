/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import {
  SCBRootSceneSession,
  SCBSceneInfo,
  SCBSceneMode,
} from '../../../../../../../..';
import { SCBScreenSessionManager } from '../../../../../../../main/ets/screen/session/SCBScreenSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ReflectionUtils } from './ReflectionUtils';
import type Want from '@ohos.app.ability.Want';

interface SceneInfoTest {
  bundleName: string; moduleName: string; abilityName: string; appIndex: number; windowMode: number;
  persistentId:number; screenId: number; callState: number; isCalledRightlyByCallerId: boolean;
  callerPersistentId:1; callerBundleName: ""; callerAbilityName: ""; windowWidth: 0;
  windowHeight: 0; windowLeft: 0; windowTop:0; withAnimation: true; focusedOnShow: true;
  isAtomicService: true; isStartupInstallFree:true; needClearInNotShowRecent: true; isFromIcon:true;
}

interface ScreenSessionTest{
  screenId: number; name: string;
}

interface SCBScreenSessionTest{
  session: ScreenSessionTest;
}

function createSceneInfoTest(bundleName: string, moduleName: string, abilityName: string,
  persistentId: number): SceneInfoTest {
  let sceneInfoTest: SceneInfoTest = {
    bundleName,
    moduleName,
    abilityName,
    appIndex: 0,
    windowMode: 0,
    persistentId,
    screenId: 0,
    callState: 0,
    isCalledRightlyByCallerId: false,
    callerPersistentId: 1,
    callerBundleName: '',
    callerAbilityName: '',
    windowWidth: 0,
    windowHeight: 0,
    windowLeft: 0,
    windowTop: 0,
    withAnimation: true,
    focusedOnShow: true,
    isAtomicService: true,
    isStartupInstallFree: true,
    needClearInNotShowRecent: true,
    isFromIcon: true
  };
  return sceneInfoTest
}

export function SCBRootSceneSessionTest() {
  describe('SCBRootSceneSessionTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('isEmergencyCallToCallUiTest', 0, () => {
      let scbRootSceneSession: SCBRootSceneSession = new SCBRootSceneSession();
      expect(ReflectionUtils.useFunc(scbRootSceneSession, 'isEmergencyCallToCallUI', null, null)).assertFalse();

      let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('com.ohos.callui', 'testModule', 'com.ohos.callui.MainAbility');
      let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('com.ohos.callui', 'testModule', 'testAbility');
      expect(ReflectionUtils.useFunc(scbRootSceneSession, 'isEmergencyCallToCallUI', toSceneInfo, fromSceneInfo)).assertFalse();
      fromSceneInfo.abilityName = 'com.ohos.emergencyCall.EmergencyCallAbility';
      expect(ReflectionUtils.useFunc(scbRootSceneSession, 'isEmergencyCallToCallUI', toSceneInfo, fromSceneInfo)).assertTrue();
    });

    it('onBatchPendingSceneSessionsActivationTest_01', 0, () => {
      let scbRootSceneSession: SCBRootSceneSession = new SCBRootSceneSession();
      let sceneInfoTestArray: SceneInfoTest[] = [];
      ReflectionUtils.useFunc(scbRootSceneSession, 'onBatchPendingSceneSessionsActivation', sceneInfoTestArray);
      expect(sceneInfoTestArray).assertNull();
    });

    it('onBatchPendingSceneSessionsActivationTest_02', 0, () => {
      let scbRootSceneSession: SCBRootSceneSession = new SCBRootSceneSession();
      let sceneInfoTestArray: SceneInfoTest[] = [];
      let sceneInfoTest1: SceneInfoTest = createSceneInfoTest("testBundle1", "testModule1", "testAbility1", 11);
      sceneInfoTestArray.push(sceneInfoTest1);
      ReflectionUtils.useFunc(scbRootSceneSession, 'onBatchPendingSceneSessionsActivation', sceneInfoTestArray);
      expect(sceneInfoTestArray).not().assertNull();
    });

    it('onBatchPendingSceneSessionsActivationTest_03', 0, () => {
      let scbRootSceneSession: SCBRootSceneSession = new SCBRootSceneSession();
      let sceneInfoTestArray: SceneInfoTest[] = [];
      let sceneInfoTest1: SceneInfoTest = createSceneInfoTest("testBundle1", "testModule1", "testAbility1", 11);
      let sceneInfoTest2: SceneInfoTest = createSceneInfoTest("testBundle2", "testModule2", "testAbility2", 22);
      sceneInfoTestArray.push(sceneInfoTest1);
      sceneInfoTestArray.push(sceneInfoTest2);
      ReflectionUtils.useFunc(scbRootSceneSession, 'onBatchPendingSceneSessionsActivation', sceneInfoTestArray);
      expect(sceneInfoTestArray).not().assertNull();
    });

    it('onBatchPendingSceneSessionsActivationTest_04', 0, () => {
      let scbRootSceneSession: SCBRootSceneSession = new SCBRootSceneSession();
      let sceneInfoTestArray: SceneInfoTest[] = [];
      let sceneInfoTest1: SceneInfoTest = createSceneInfoTest("testBundle1", "testModule1", "testAbility1", 11);
      let sceneInfoTest2: SceneInfoTest = createSceneInfoTest("testBundle2", "testModule2", "testAbility2", 22);
      let sceneInfoTest3: SceneInfoTest = createSceneInfoTest("testBundle3", "testModule3", "testAbility3", 33);
      sceneInfoTestArray.push(sceneInfoTest1);
      sceneInfoTestArray.push(sceneInfoTest2);
      sceneInfoTestArray.push(sceneInfoTest3);
      ReflectionUtils.useFunc(scbRootSceneSession, 'onBatchPendingSceneSessionsActivation', sceneInfoTestArray);
      expect(sceneInfoTestArray).not().assertNull();
    });

    it('onBatchPendingSceneSessionsActivationTest_05', 0, () => {
      let scbRootSceneSession: SCBRootSceneSession = new SCBRootSceneSession();
      let sceneInfoTestArray: SceneInfoTest[] = [];
      let sceneInfoTest1: SceneInfoTest = createSceneInfoTest("testBundle1", "testModule1", "testAbility1", 11);
      let sceneInfoTest2: SceneInfoTest = createSceneInfoTest("testBundle2", "testModule2", "testAbility2", 22);
      let sceneInfoTest3: SceneInfoTest = createSceneInfoTest("testBundle3", "testModule3", "testAbility3", 33);
      let sceneInfoTest4: SceneInfoTest = createSceneInfoTest("testBundle4", "testModule4", "testAbility4", 44);
      sceneInfoTestArray.push(sceneInfoTest1);
      sceneInfoTestArray.push(sceneInfoTest2);
      sceneInfoTestArray.push(sceneInfoTest3);
      sceneInfoTestArray.push(sceneInfoTest4);
      ReflectionUtils.useFunc(scbRootSceneSession, 'onBatchPendingSceneSessionsActivation', sceneInfoTestArray);
      expect(sceneInfoTestArray).not().assertNull();
    });

    it('onBatchPendingSceneSessionsActivationTest_06', 0, () => {
      let scbRootSceneSession: SCBRootSceneSession = new SCBRootSceneSession();
      let sceneInfoTestArray: SceneInfoTest[] = [];
      let sceneInfoTest1: SceneInfoTest = createSceneInfoTest("testBundle1", "testModule1", "testAbility1", 11);
      sceneInfoTestArray.push(sceneInfoTest1);
      sceneInfoTestArray.push(sceneInfoTest1);
      ReflectionUtils.useFunc(scbRootSceneSession, 'onBatchPendingSceneSessionsActivation', sceneInfoTestArray);
      expect(sceneInfoTestArray).not().assertNull();
    });

    it('onPendingSceneSessionActivation', 0, () => {
      let scbRootSceneSession: SCBRootSceneSession = new SCBRootSceneSession();
      let sceneInfoTest: SceneInfoTest= {
        bundleName: "testBundle",
        moduleName: "testModule",
        abilityName: "testAbility",
        appIndex: 0,
        windowMode: 0,
        persistentId: 123,
        screenId: 0,
        callState: 0,
        isCalledRightlyByCallerId: false,
        callerPersistentId: 1,
        callerBundleName: '',
        callerAbilityName: '',
        windowWidth: 0,
        windowHeight: 0,
        windowLeft: 0,
        windowTop: 0,
        withAnimation: true,
        focusedOnShow: true,
        isAtomicService: true,
        isStartupInstallFree: true,
        needClearInNotShowRecent: true,
        isFromIcon: true
      };

      // FLOATING
      sceneInfoTest.windowMode = 102;
      ReflectionUtils.useFunc(scbRootSceneSession, 'onPendingSceneSessionActivation', sceneInfoTest);

      // WINDOW_MODE_FULLSCREEN
      sceneInfoTest.windowMode = 1;
      ReflectionUtils.useFunc(scbRootSceneSession, 'onPendingSceneSessionActivation', sceneInfoTest);

      // WINDOW_MODE_SPLIT_PRIMARY
      sceneInfoTest.windowMode = 100;
      ReflectionUtils.useFunc(scbRootSceneSession, 'onPendingSceneSessionActivation', sceneInfoTest);

      // WINDOW_MODE_SPLIT_SECONDARY
      sceneInfoTest.windowMode = 101;
      ReflectionUtils.useFunc(scbRootSceneSession, 'onPendingSceneSessionActivation', sceneInfoTest);

      // mock
      let mocker: MockKit = new MockKit();
      let mockFunc1 = mocker.mockFunc(SCBScreenSessionManager.getInstance(), SCBScreenSessionManager.getInstance().getScreenSession);
      // screenName = 'HiCar'
      let screenSessionTest1: ScreenSessionTest = {
        screenId: 1,
        name: 'HiCar'
      };
      let scbScreenSessionTest1: SCBScreenSessionTest = {
        session: screenSessionTest1
      };

      when(mockFunc1)(1).afterReturn(scbScreenSessionTest1);
      sceneInfoTest.screenId = 1;
      ReflectionUtils.useFunc(scbRootSceneSession, 'onPendingSceneSessionActivation', sceneInfoTest);

      // screenName = 'SubScreen' and DeviceHelper.isSmallFoldProduct() = true
      let screenSessionTest2: ScreenSessionTest = {
        screenId: 2,
        name: 'SubScreen'
      };
      let scbScreenSessionTest2: SCBScreenSessionTest = {
        session: screenSessionTest2
      };
      when(mockFunc1)(2).afterReturn(scbScreenSessionTest2);
      let mockDeviceHelperFunc = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(mockDeviceHelperFunc)(ArgumentMatchers.any).afterReturn(true);
      sceneInfoTest.screenId = 2;
      ReflectionUtils.useFunc(scbRootSceneSession, 'onPendingSceneSessionActivation', sceneInfoTest);

      // Other and callState != 0
      let screenSessionTest3: ScreenSessionTest = {
        screenId: 3,
        name: 'Other'
      };
      let scbScreenSessionTest3: SCBScreenSessionTest = {
        session: screenSessionTest3
      };
      when(mockFunc1)(3).afterReturn(scbScreenSessionTest3);
      sceneInfoTest.screenId = 3;
      sceneInfoTest.callState = 1;
      ReflectionUtils.useFunc(scbRootSceneSession, 'onPendingSceneSessionActivation', sceneInfoTest);

      // callState == 0
      sceneInfoTest.callState = 0;
      ReflectionUtils.useFunc(scbRootSceneSession, 'onPendingSceneSessionActivation', sceneInfoTest);
      mocker.clear(SCBScreenSessionManager.getInstance());
      mocker.clear(DeviceHelper);
    });

    it('bindAttribute', 0, () => {
      let scbRootSceneSession: SCBRootSceneSession = new SCBRootSceneSession();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneInfoTest: SceneInfoTest= {
        bundleName: "testBundle",
        moduleName: "testModule",
        abilityName: "testAbility",
        appIndex: 0,
        windowMode: 0,
        persistentId: 123,
        screenId: 0,
        callState: 0,
        isCalledRightlyByCallerId: true,
        callerPersistentId: 1,
        callerBundleName: '',
        callerAbilityName: '',
        windowWidth: 0,
        windowHeight: 0,
        windowLeft: 0,
        windowTop: 0,
        withAnimation: true,
        focusedOnShow: true,
        isAtomicService: true,
        isStartupInstallFree: true,
        needClearInNotShowRecent: true,
        isFromIcon: true
      };
      ReflectionUtils.useFunc(scbRootSceneSession, 'bindAttribute', sceneInfoTest, scbSceneInfo);
    });

  });
}