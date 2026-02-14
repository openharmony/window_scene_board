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
  SCBScreenProperty
} from '../../../../../../../../src/main/ets/screen/session/SCBScreenSession';
import { RotationConstants, SCBConstants } from '@ohos/commonconstants';
import {
  SCBSceneOrientation
} from '../../../../../../../../src/main/ets/scene/session/SCBSceneOrientation';
import {
  SCBPropertyChangeReason,
  SCBRotateChangeReason,
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

const TAG = 'SCBWindowRotateTest';
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

function assertRotatoin(screenRotationChangeCallBack: Function | undefined, scbScreenSession: SCBScreenSession,
  rotatoin: Array<RotationConstants>): void {
  if (screenRotationChangeCallBack) {
    screenRotationChangeCallBack(RotationConstants.ROTATION_90);
    screenRotationChangeCallBack(RotationConstants.ROTATION_180);
    screenRotationChangeCallBack(RotationConstants.ROTATION_270);
    screenRotationChangeCallBack(RotationConstants.ROTATION_0);
    expect(scbScreenSession.scbScreenProperty.rotation).assertLargerOrEqual(0);
  }
}

export function SCBWindowRotateTest2(): void {
  describe('SCBWindowRotateTest2', () => {
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
          containerSession.sessionData.requestOrientation:${containerSession.sessionData.requestOrientation}, scbSceneContainerSessionArray.length: ${scbSceneContainerSessionArray.length}`);
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

    it('UNSPECIFIED_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.UNSPECIFIED;
      containerSession.screenProperty.rotation = RotationConstants.ROTATION_0;
      log.showInfo(`UNSPECIFIED_TEST containerSession.sessionData.requestOrientation=${containerSession.sessionData.requestOrientation}}`);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      if (screenRotationChangeCallBack !== undefined) {
        assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
          new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
            RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      }
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      mockPadEnv(containerSession, scbScreenSession);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      mocker.clear(scbScreenSessionManager);
    });

    it('VERTICAL_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.VERTICAL;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      mockPadEnv(containerSession, scbScreenSession);
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      mocker.clear(scbScreenSessionManager);
    });

    it('HORIZONTAL_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_270);
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.HORIZONTAL;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      mockPadEnv(containerSession, scbScreenSession);
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_270;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      mocker.clear(scbScreenSessionManager);
    });

    it('REVERSE_VERTICAL_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.REVERSE_VERTICAL;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_180);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_180, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_180));
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_180);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_180, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_180));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_180));
      mockPadEnv(containerSession, scbScreenSession);
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_180;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_180, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_180));
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_180;
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_180, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_180));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_180));
      mocker.clear(scbScreenSessionManager);
    });

    it('REVERSE_HORIZONTAL_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.REVERSE_HORIZONTAL;
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_90;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_90, RotationConstants.ROTATION_90));
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_90, RotationConstants.ROTATION_90));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_90, RotationConstants.ROTATION_90));
      mockPadEnv(containerSession, scbScreenSession);
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_90;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_90, RotationConstants.ROTATION_90));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_90, RotationConstants.ROTATION_90));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_90, RotationConstants.ROTATION_90));
      mocker.clear(scbScreenSessionManager);
    });

    it('SENSOR_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
    });

    it('AUTO_ROTATION_RESTRICTED_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      let containerSession = screenSessionTestObj.containerSession;
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_RESTRICTED;
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      mockPadEnv(containerSession, scbScreenSession);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      mocker.clear(scbScreenSessionManager);
    });

    it('SENSOR_VERTICAL_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR_VERTICAL;
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_0));
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_0));
      mockPadEnv(containerSession, scbScreenSession);
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_180, RotationConstants.ROTATION_0));
      mocker.clear(scbScreenSessionManager);
    });

    it('SENSOR_HORIZONTAL_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR_HORIZONTAL;
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      mockPadEnv(containerSession, scbScreenSession);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_270);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_270);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      mocker.clear(scbScreenSessionManager);
    });

    it('AUTO_ROTATION_PORTRAIT_RESTRICTED_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
    });

    it('AUTO_ROTATION_LANDSCAPE_RESTRICTED_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_270);
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      containerSession.screenProperty.rotation = RotationConstants.ROTATION_270;
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_270;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      mockPadEnv(containerSession, scbScreenSession);
      containerSession.screenProperty.rotation = RotationConstants.ROTATION_270;
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_270;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_270);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_180);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      mocker.clear(scbScreenSessionManager);
    });

    it('LOCKED_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.LOCKED;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      mockPadEnv(containerSession, scbScreenSession);
      containerSession.screenProperty.rotation = RotationConstants.ROTATION_0;
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_90, RotationConstants.ROTATION_90));
      mocker.clear(scbScreenSessionManager);
    });

    it('USER_ROTATION_PORTRAIT_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_PORTRAIT;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
    });

    it('AUTO_ROTATION_UNSPECIFIED_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_180);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
    });

    it('USER_ROTATION_LANDSCAPE_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_LANDSCAPE;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_90,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
    });

    it('USER_ROTATION_PORTRAIT_INVERTED_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_PORTRAIT_INVERTED;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
    });

    it('USER_ROTATION_LANDSCAPE_INVERTED_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
    });

    it('FOLLOW_DESKTOP_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.FOLLOW_DESKTOP;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_90);
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
      when(func1)(ArgumentMatchers.any).afterReturn(false);

      mockPadEnv(containerSession, scbScreenSession);
      containerSession.screenProperty.rotation = RotationConstants.ROTATION_270;
      scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_270;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
    });

    it('HIGH_FREQUENCT_ROTATION_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      for (let i: number = 0; i < 10; i++) {
        if (i % 2 === 0) {
          containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR;
          containerSession.screenProperty.rotation = RotationConstants.ROTATION_0;
          scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
          let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
          assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
            new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
              RotationConstants.ROTATION_270, RotationConstants.ROTATION_0));
        } else {
          containerSession.sessionData.requestOrientation = SCBSceneOrientation.HORIZONTAL;
          containerSession.screenProperty.rotation = RotationConstants.ROTATION_270;
          scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_270;
          let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
          assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
            new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
              RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
        }
      }
    });

    it('SAME_STATEGY_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.HORIZONTAL;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_270);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.HORIZONTAL;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.HORIZONTAL;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_270, RotationConstants.ROTATION_270,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
    });

    it('IS_NOT_ACTIVE_TEST', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let containerSession = screenSessionTestObj.containerSession;
      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR;
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      let screenRotationChangeCallBack: Function | undefined = screenSessionTestObj.screenRotationChangeCallBack;
      containerSession.sessionData.requestOrientation = SCBSceneOrientation.HORIZONTAL;
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      containerSession.requestBackground();
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_0, RotationConstants.ROTATION_0,
          RotationConstants.ROTATION_0, RotationConstants.ROTATION_0));
      modRotation(scbScreenSession, containerSession, RotationConstants.ROTATION_0);
      containerSession.setActivationAtToggleHomeScenario();
      assertRotatoin(screenRotationChangeCallBack, scbScreenSession,
        new Array<RotationConstants>(RotationConstants.ROTATION_90, RotationConstants.ROTATION_180,
          RotationConstants.ROTATION_270, RotationConstants.ROTATION_270));
    });
  });
}