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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  TestType,
  Size,
  Level,
  MockKit,
  when} from '@ohos/hypium'
import {
  RecentRotationUtil} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentRotationUtil'
import { RotationConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  RecentsStyleConstants,
  SCBContainerRotationReason,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  SCBScreenSession,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import screenSessionManager from '@ohos.screenSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import type { UIContext } from '@ohos.arkui.UIContext';
import {
  RotateFuncType,
  WrapRotationEntryParam } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';

export default function RecentRotationUtilTest() {
  describe('RecentRotationUtilTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll((): void => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach((): void => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach((): void => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll((): void => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    // 卡片和屏幕是否在一个旋转角度
    it('isSameRotation_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let screenRotation = 0;
      let sessionRotation = 180;
      expect(RecentRotationUtil.isSameRotation(screenRotation, sessionRotation)).assertTrue();
    })

    it('isSameRotation_test_180', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let screenRotation = 180;
      let sessionRotation = 0;
      expect(RecentRotationUtil.isSameRotation(screenRotation, sessionRotation)).assertTrue();
    })

    it('isSameRotation_test_360', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let screenRotation = 360;
      let sessionRotation = 0;
      expect(RecentRotationUtil.isSameRotation(screenRotation, sessionRotation)).assertTrue();
    })

    it('isSameRotation_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let screenRotation = 0;
      let sessionRotation = 0;
      expect(RecentRotationUtil.isSameRotation(screenRotation, sessionRotation)).assertTrue();
    })

    it('isSameRotation_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let screenRotation = 0;
      let sessionRotation = 360;
      expect(RecentRotationUtil.isSameRotation(screenRotation, sessionRotation)).assertTrue();
    })

    it('isSameRotation_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let screenRotation = 1;
      let sessionRotation = 0;
      expect(RecentRotationUtil.isSameRotation(screenRotation, sessionRotation)).assertTrue();
    })

    let screenProperty = new SCBScreenProperty();
    let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

    // 获取缩放比例
    it('getRecentScaleByRotation_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentRotationUtil.getRecentScaleByRotation(true)).assertEqual(RecentsStyleConstants.VERTICAL_RECENT_SCALE);
    })

    it('getRealRotationFromScreenSession_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      when(getScreenSession)().afterReturn(null);
      let screenProperty = new SCBScreenProperty();
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRealRotationFromScreenSession_test_02_copy15', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getScreenSession);
      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        displayGroupId: 0,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        },
        destroyContent: (): void => {}
      };
      let scbScreenSession = new SCBScreenSession(screenSession);
      when(getScreenSession)().afterReturn(scbScreenSession);
      screenProperty.rotation = 1;
      expect(RecentRotationUtil.getScreenRotation(screenProperty)).assertEqual(1);
    })

    it('getRotateStatus_rotate_0', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let rotate: number = RotationConstants.ROTATION_0;
      let status: number = 0;
      expect(RecentRotationUtil.getRotateStatus(rotate)).assertEqual(status);
    })

    it('getRotateStatus_rotate_270', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let rotate: number = RotationConstants.ROTATION_270;
      let status: number = 1;
      expect(RecentRotationUtil.getRotateStatus(rotate)).assertEqual(status);
    })

    it('getRotateStatus_rotate_90', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let status: number = 2;
      let rotate: number = RotationConstants.ROTATION_90;
      expect(RecentRotationUtil.getRotateStatus(rotate)).assertEqual(status);
    })

    it('getRotateStatus_rotate_180', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let status: number = 3;
      let rotate: number = RotationConstants.ROTATION_180;
      expect(RecentRotationUtil.getRotateStatus(rotate)).assertEqual(status);
    })

    it('getRotateStatus_rotate_default', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let status: number = 0;
      let rotate: number = RotationConstants.ROTATION_360;
      expect(RecentRotationUtil.getRotateStatus(rotate)).assertEqual(status);
    })

    it('createRotationParam_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let param = new WrapRotationEntryParam();
      param.rotateFuncType = RotateFuncType.START_SCENE;
      param.reason = SCBContainerRotationReason.START_SCENE;
      let containerRotation = RecentRotationUtil.createRotationParam(RotateFuncType.START_SCENE, SCBContainerRotationReason.START_SCENE);
      expect(containerRotation.reason)
        .assertEqual(param.reason);
    })

    it('createRotationParam_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let param = new WrapRotationEntryParam();
      param.rotateFuncType = RotateFuncType.START_SCENE;
      param.reason = SCBContainerRotationReason.START_SCENE;
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let container: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      param.containerSession = container;
      let containerRotation = RecentRotationUtil.createRotationParam(RotateFuncType.START_SCENE, SCBContainerRotationReason.START_SCENE,
        container);
      expect(containerRotation.reason).assertEqual(param.reason);
    })

    it('createRotationParam_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let param = new WrapRotationEntryParam();
      param.rotateFuncType = RotateFuncType.START_SCENE;
      param.reason = SCBContainerRotationReason.START_SCENE;
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let container: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      param.containerSession = container;
      let containerRotation = RecentRotationUtil.createRotationParam(RotateFuncType.START_SCENE, SCBContainerRotationReason.START_SCENE,
        container);
      expect(containerRotation.reason).assertEqual(param.reason);
    })

    it('createRotationParam_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let param = new WrapRotationEntryParam();
      param.rotateFuncType = RotateFuncType.START_SCENE;
      param.reason = SCBContainerRotationReason.START_SCENE;
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let container: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      param.containerSession = container;
      param.needAnimation = true;
      let containerRotation = RecentRotationUtil.createRotationParam(RotateFuncType.START_SCENE, SCBContainerRotationReason.START_SCENE,
        container, true);
      expect(containerRotation.needAnimation).assertEqual(param.needAnimation);
    })

    it('createRotationParam_test_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let param = new WrapRotationEntryParam();
      param.rotateFuncType = RotateFuncType.START_SCENE;
      param.reason = SCBContainerRotationReason.START_SCENE;
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let container: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      param.containerSession = container;
      param.needAnimation = true;
      param.isFromRecent = true;
      let containerRotation = RecentRotationUtil.createRotationParam(RotateFuncType.START_SCENE, SCBContainerRotationReason.START_SCENE,
        container, true, true);
      expect(containerRotation.isFromRecent).assertEqual(param.isFromRecent);
    })
  })
}