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
  ArgumentMatchers,
  MockKit,
  when,
} from '@ohos/hypium';
import screenSessionManager from '@ohos.screenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import {
  SCBSceneContainerSession
} from '../../../../../../../../src/main/ets/scene/session/SCBSceneContainerSession';
import {
  SCBSceneContainerSessionArray
} from '../../../../../../../../src/main/ets/scene/session/SCBSceneContainerSession';
import { SCBSceneInfo } from '../../../../../../../../src/main/ets/scene/session/SCBSceneInfo';
import { SCBSceneSession } from '../../../../../../../../src/main/ets/scene/session/SCBSceneSession';
import {
  SCBScreenSession,
} from '../../../../../../../../src/main/ets/screen/session/SCBScreenSession';
import { RotationConstants, SCBConstants } from '@ohos/commonconstants';
import {
  SCBSceneOrientation
} from '../../../../../../../../src/main/ets/scene/session/SCBSceneOrientation';
import {
  SCBScreenSessionManager,
  SCBScreenSessionArray
} from '../../../../../../../../src/main/ets/screen/session/SCBScreenSessionManager';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SCBSceneSessionManager,
  ScenePanelState
} from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import type { UIContext } from '@ohos.arkui.UIContext';
import { ReflectionUtils } from './ReflectionUtils';

const TAG = 'SCBWindowRotateForFolder';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
// 0 means vertical, 1 means horizontal.
const defaultScreenVertical = 0;

function mockPadEnv(containerSession: SCBSceneContainerSession, scbScreenSession: SCBScreenSession): void {
  SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
  containerSession.screenProperty.setDefaultRotation(RotationConstants.ROTATION_270);
  containerSession.screenProperty.rotation = RotationConstants.ROTATION_270;
  scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_270;
}

function modRotation(scbScreenSession: SCBScreenSession, containerSession: SCBSceneContainerSession,
  rotation: number): void {
  scbScreenSession.scbScreenProperty.rotation = rotation;
  containerSession.screenProperty.rotation = rotation;
}

function assertRotation(screenRotationChangeCallBack: Function | undefined, scbScreenSession: SCBScreenSession,
  rotatoin: Array<RotationConstants>): void {
  if (screenRotationChangeCallBack) {
    screenRotationChangeCallBack(RotationConstants.ROTATION_90);
    screenRotationChangeCallBack(RotationConstants.ROTATION_180);
    screenRotationChangeCallBack(RotationConstants.ROTATION_270);
    screenRotationChangeCallBack(RotationConstants.ROTATION_0);
    expect(scbScreenSession.scbScreenProperty.rotation).assertLargerOrEqual(0);
  }
}

export function SCBWindowRotateTestForFolder(): void {
  describe('SCBWindowRotateTestForFolder', () => {
    interface ScreenSessionTestObj {
      screenRotationChangeCallBack: Function | undefined;
      scbScreenSession: SCBScreenSession;
      containerSession: SCBSceneContainerSession;
      scbScreenSessionManager: SCBScreenSessionManager;
    }

    let createInstance = (): ScreenSessionTestObj => {
      let callbackMap = new Map<string, Function>();
      let screenRotationChangeCallBack: Function | undefined = (): void => {
      };
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: 100,
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
        }
      };
      let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
      if (callbackMap.get('sensorRotationChange') !== undefined) {
        screenRotationChangeCallBack = callbackMap.get('sensorRotationChange');
      }
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, scbScreenSession.scbScreenProperty);
      containerSession.init();
      containerSession.setActivationAtToggleHomeScenario();
      let scbScreenSessionManager = SCBScreenSessionManager.getInstance();
      return {
        screenRotationChangeCallBack,
        scbScreenSession,
        containerSession,
        scbScreenSessionManager
      };
    };

    let screenSessionTestObj: ScreenSessionTestObj;
    beforeEach(() => {
      screenSessionTestObj = createInstance();
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(scbSceneSessionManager, 'isScreenLock', false);
      scbSceneSessionManager.init();
      scbSceneSessionManager.initSystemSceneList(100);
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.isScreenLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      scbSceneSessionManager.setPanelLists(100);
      let callback = (): ScenePanelState => ScenePanelState.FULLSCENE;
      scbSceneSessionManager.registerGetScenePanelStateCallback(100, 100, callback);
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession: SCBSceneContainerSession = screenSessionTestObj.containerSession;
      let specialContainerSessionListCallback = (): SCBSceneContainerSessionArray => {
        let scbSceneContainerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
        scbSceneContainerSessionArray.push(containerSession);
        log.showInfo(`registerGetScenePanelStateCallback containerSession.isActive:${containerSession.isActive},
          containerSession.sessionData.requestOrientation:${containerSession.sessionData.requestOrientation},
          scbSceneContainerSessionArray.length: ${scbSceneContainerSessionArray.length}`);
        return scbSceneContainerSessionArray;
      };
      scbSceneSessionManager.registerGetContainerSessionListCallback(specialContainerSessionListCallback, 100);
      scbSceneSessionManager.registerGetSpecialContainerSessionListCallback(specialContainerSessionListCallback);
      expect(screenSessionTestObj).not().assertNull();
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
      let list: SCBScreenSessionArray = new SCBScreenSessionArray();
      list.push(scbScreenSession);
      SCBScreenSessionManager.getInstance().setScreenSessionList(list);
      scbScreenSession.scbScreenProperty.defaultScreenOrientation = defaultScreenVertical;
      scbScreenSession.scbScreenProperty.setDefaultRotation(RotationConstants.ROTATION_0);
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      containerSession.screenProperty.rotation = RotationConstants.ROTATION_0;
      containerSession.isSplit = false;
      containerSession.sessionData.sdkVersion = 12;
    });
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('UNSPECIFIED_TEST_FOR_FOLDER', 0, () => {
      // GIVEN: 初始化窗口和屏幕，打桩应用设置自身为UNSPECIFIED
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      // WHEN: 设置初始旋转角度为0
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.UNSPECIFIED;
      containerSession.screenProperty.rotation = RotationConstants.ROTATION_0;
      log.showInfo(`UNSPECIFIED_TEST containerSession.sessionData.requestOrientation=${containerSession.sessionData.requestOrientation}}`);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到180度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      // THEN: 1) senor为90度时, 应用旋转到0度; 2) senor为180度时, 应用旋转到0度;
      //       3) senor为270度时, 应用旋转到0度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      mocker.clear(scbScreenSessionManager);
    });

    it('VERTICAL_TEST_FOR_FOLDER', 0, () => {
      // GIVEN: 初始化窗口和屏幕, 打桩应用设置自身为竖屏
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      // WHEN: 设置初始旋转策略为VERTICAL
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.VERTICAL;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      // THEN: 1) senor为90度时, 应用旋转到0度; 2) senor为180度时, 应用旋转到0度;
      //       3) senor为270度时, 应用旋转到0度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到180度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      mocker.clear(scbScreenSessionManager);
    });

    it('HORIZONTAL_TEST_FOR_FOLDER', 0, () => {
      // GIVEN: 初始化窗口和屏幕, 打桩应用设置自身为横屏
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.HORIZONTAL;
      // WHEN: 设置初始旋转角度为270
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_270);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      // THEN: 1) senor为90度时, 应用旋转到270度; 2) senor为180度时, 应用旋转到270度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到270度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到180度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到270度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      mocker.clear(scbScreenSessionManager);
    });

    it('REVERSE_VERTICAL_TEST_FOR_FOLDER', 0, () => {
      // GIVEN: 初始化窗口和屏幕, 打桩应用设置自身为REVERSE_VERTICAL
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.REVERSE_VERTICAL;
      // WHEN: 设置初始旋转角度为180
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_180);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_180);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      // THEN: 1) senor为90度时, 应用旋转到180度; 2) senor为180度时, 应用旋转到180度;
      //       3) senor为270度时, 应用旋转到180度; 4) senor为0度时, 应用旋转到180度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_180, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_180));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到180度;
      //       3) senor为270度时, 应用旋转到180度; 4) senor为0度时, 应用旋转到180度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_180));
      mocker.clear(scbScreenSessionManager);
    });

    it('REVERSE_HORIZONTAL_TEST_FOR_FOLDER', 0, () => {
      // GIVEN: 初始化窗口和屏幕, 打桩应用设置自身为REVERSE_HORIZONTAL
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.REVERSE_HORIZONTAL;
      // WHEN: 设置初始旋转角度为90
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_90;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到90度;
      //       3) senor为270度时, 应用旋转到90度; 4) senor为0度时, 应用旋转到90度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_90, RotationConstants.ROTATION_90));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到90度;
      //       3) senor为270度时, 应用旋转到90度; 4) senor为0度时, 应用旋转到90度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_90, RotationConstants.ROTATION_90));
      mocker.clear(scbScreenSessionManager);
    });

    it('SENSOR_TEST_FOR_FOLDER', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到180度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
    });

    it('AUTO_ROTATION_RESTRICTED_TEST_FOR_FOLDER', 0, () => {
      // GIVEN: 初始化窗口和屏幕, 打桩应用设置自身为AUTO_ROTATION_RESTRICTED
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      let containerSession = screenSessionTestObj.containerSession;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_RESTRICTED;
      // WHEN: 屏幕旋转角度设置为0
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      let mocker: MockKit = new MockKit();
      let func1: Function =
      mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到180度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      // THEN: 1) senor为90度时, 应用旋转到0度; 2) senor为180度时, 应用旋转到0度;
      //       3) senor为270度时, 应用旋转到0度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到180度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      mocker.clear(scbScreenSessionManager);
    });

    it('SENSOR_VERTICAL_TEST_FOR_FOLDER', 0, () => {
      // GIVEN: 初始化窗口和屏幕, 打桩应用设置自身为SENSOR_VERTICAL
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR_VERTICAL;
      // WHEN: 设置初始旋转角度为0
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      // THEN: 1) senor为90度时, 应用旋转到0度; 2) senor为180度时, 应用旋转到180度;
      //       3) senor为270度时, 应用旋转到180度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到180度;
      //       3) senor为270度时, 应用旋转到180度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      mocker.clear(scbScreenSessionManager);
    });

    it('SENSOR_HORIZONTAL_TEST_FOR_FOLDER', 0, () => {
      // GIVEN: 初始化窗口和屏幕, 打桩应用设置自身为SENSOR_HORIZONTAL
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR_HORIZONTAL;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      // WHEN: 设置初始旋转角度为0
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到90度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到270度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到90度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到270度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      mocker.clear(scbScreenSessionManager);
    });

    it('AUTO_ROTATION_PORTRAIT_RESTRICTED_TEST_FOR_FOLDER', 0, () => {
      // GIVEN: 初始化窗口和屏幕, 打桩应用设置自身为AUTO_ROTATION_PORTRAIT_RESTRICTED
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED;
      // WHEN: 设置初始旋转角度为0
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      // THEN: 1) senor为90度时, 应用旋转到0度; 2) senor为180度时, 应用旋转到0度;
      //       3) senor为270度时, 应用旋转到0度; 4) senor为0度时, 应用旋转到0度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
    });

    it('AUTO_ROTATION_LANDSCAPE_RESTRICTED_TEST_FOR_FOLDER', 0, () => {
      // GIVEN: 初始化窗口和屏幕, 打桩应用设置自身为AUTO_ROTATION_LANDSCAPE_RESTRICTED
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED;
      // WHEN: 设置初始旋转角度为270
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_270);
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到90度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到270度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_270);
      // THEN: 1) senor为90度时, 应用旋转到270度; 2) senor为180度时, 应用旋转到270度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到270度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      // THEN: 1) senor为90度时, 应用旋转到90度; 2) senor为180度时, 应用旋转到90度;
      //       3) senor为270度时, 应用旋转到270度; 4) senor为0度时, 应用旋转到270度;
      assertRotation(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      mocker.clear(scbScreenSessionManager);
    });
  });
}