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
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  SCBWindowRotateController,
} from '../../../../../../../main/ets/scene/manager/SCBWindowRotateController';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { RotationConstants, SCBConstants } from '@ohos/commonconstants';
import { SCBSceneInfo } from '../../../../../../../main/ets/scene/session/SCBSceneInfo';
import { SCBSceneSession } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import {
  SCBScreenProperty,
  SCBScreenSession
} from '../../../../../../../main/ets/screen/session/SCBScreenSession';
import {
  SCBScreenSessionManager, SCBRotateChangeReason
} from '../../../../../../../main/ets/screen/session/SCBScreenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneContainerSession
} from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';
import screenSessionManager from '@ohos.screenSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ReflectionUtils } from '../../utils/ReflectionUtils';
import { SCBSessionRect } from '../../../../../../../main/ets/scene/session/SCBSessionRect';
import { SCBDividerParam } from '../../../../../../../main/ets/scene/session/SCBDividerParam';

async function getControllerInstance(): Promise<SCBWindowRotateController> {
  const controller = SCBWindowRotateController.getInstance();
  return controller;
}

const TAG = 'SCBWindowRotateController';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export function SCBWindowRotateControllerTest() {
  describe('SCBWindowRotateControllerTest', () => {
    getInstanceTest();
    isFullScreenRotatePolicyTest();
    isDesktopRotatableTest();
    windowRotateEntryTest();
    sceneLandscapeStartTest();
    landscapeStartSyncTest();
    isLandscapeStartInterruptTest();
    isLandscapeStartNotSyncTest();
    notifyRotationChangeTest();
    updateRotationWindowTest();
  });
}

let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

let callbackMap = new Map<string, Function>();
let testPtr : UIContext;
let screenSession: screenSessionManager.ScreenSession = {
  screenId: -1,
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

function getInstanceTest() {
  it('getInstance', 0, async () => {
    const controller = SCBWindowRotateController.getInstance();
    expect(controller === undefined).assertFalse();
  });
}

function isFullScreenRotatePolicyTest() {

  it('isFullScreenRotatePolicy_0', 0, async () => {
    const controller = await getControllerInstance();
    let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
    if (screenSession === null || screenSession === undefined) {
      expect( controller.isFullScreenRotatePolicy() === false).assertFalse();
    }
    else {
      expect( controller.isFullScreenRotatePolicy(screenSession) === true).assertTrue();
    }
  });

  it('isFullScreenRotatePolicy_1', 0, async () => {
    const controller = await getControllerInstance();
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
    let scbScreenSession = new SCBScreenSession(screenSession);
    const isFullScreenRotatePolicy = controller.isFullScreenRotatePolicy(scbScreenSession);
    expect(isFullScreenRotatePolicy === true).assertTrue();
  });

}

function isDesktopRotatableTest() {
  it('isDesktopRotatable_1', 0, async () => {
    const controller = await getControllerInstance();

    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
    if (screenSession === null || screenSession === undefined) {
      expect(controller.isDesktopRotatable() === false).assertTrue();
    }
    else {
      expect(controller.isDesktopRotatable() === true).assertTrue();
    }
  });

  it('isDesktopRotatable_2', 1, async () => {
    const controller = await getControllerInstance();

    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
    if (screenSession === null || screenSession === undefined) {
      expect(controller.isDesktopRotatable() === false).assertTrue();
    }
    else {
      expect(controller.isDesktopRotatable())
        .assertEqual((screenSession.isRotateScreenPolicy() || controller.isFullScreenRotatePolicy()));
    }
  });

}

function windowRotateEntryTest() {

  it('windowRotateEntry_1', 0, async () => {
    const controller = await getControllerInstance();
    let mocker: MockKit = new MockKit();
    let getMainScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getMainScreenSession);

    let scbScreenSession = new SCBScreenSession(screenSession);
    scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;

    const sceneInfo =
      new SCBSceneInfo('testCompatibilityBundle4', 'testCompatibilityModule4', 'testCompatibilityAbility4');
    let sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    sceneSession.sessionData.currentRotation = RotationConstants.ROTATION_0;
    sceneSession.sceneInfo.screenId = -1;

    when(getMainScreenSession)().afterReturn(null);
    controller.windowRotateEntry(RotationConstants.ROTATION_90, 'window rotate', true, true, true, false);
    expect(scbScreenSession.scbScreenProperty.rotation === RotationConstants.ROTATION_0).assertTrue();
    mocker.ignoreMock(sessionManager, sessionManager.getMainScreenSession);
  });

  it('windowRotateEntry_2', 0, async () => {
    const controller = await getControllerInstance();
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
    const mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    controller.windowRotateEntry(90, 'window rotate', true, true, true, false);
    expect(mainScreenSession.scbScreenProperty.rotation === 90).assertTrue();

  });

  it('windowRotateEntry_3', 0, async () => {
    const controller = await getControllerInstance();
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
    const mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    controller.windowRotateEntry(RotationConstants.ROTATION_90, 'window rotate', true, true, true, false);
    expect(mainScreenSession.scbScreenProperty.rotation === RotationConstants.ROTATION_90).assertTrue();
  });

  it('windowRotateEntry_4', 0, async () => {
    const controller = await getControllerInstance();
    const mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    controller.windowRotateEntry(RotationConstants.ROTATION_90, 'window rotate', true, false, true, false);
    expect(mainScreenSession.scbScreenProperty.rotation === RotationConstants.ROTATION_90).assertTrue();
  });

  it('windowRotateEntry_5', 0, async () => {
    const controller = await getControllerInstance();
    const mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    controller.windowRotateEntry(RotationConstants.ROTATION_0, 'window rotate', true, false, true, false);
    expect(mainScreenSession.scbScreenProperty.rotation === RotationConstants.ROTATION_0).assertTrue();
  });

  it('windowRotateEntry_6', 0, async () => {
    const controller = await getControllerInstance();
    const mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    controller.windowRotateEntry(RotationConstants.ROTATION_180, 'window rotate', true, true, true, false);
    expect(mainScreenSession.scbScreenProperty.rotation === RotationConstants.ROTATION_180).assertTrue();
  });

  it('windowRotateEntry_7', 0, async () => {
    const controller = await getControllerInstance();
    const mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    controller.windowRotateEntry(RotationConstants.ROTATION_270, 'window rotate', true, true, true, false);
    expect(mainScreenSession.scbScreenProperty.rotation === RotationConstants.ROTATION_270).assertTrue();
  });
}

function sceneLandscapeStartTest() {
  it('sceneLandscapeStartTest', 0, async () => {
    const controller = await getControllerInstance();

    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
    let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
    let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
    let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession,
      testSCBScreenProperty);
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;

    const mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.copy(mainScreenSession.scbScreenProperty);
    containerSession.screenProperty.screenId = mainScreenSession.session.screenId;

      let targetRotation: number = RotationConstants.ROTATION_270;
    controller.sceneLandscapeStart(mainScreenSession, containerSession, targetRotation, screenProperty);

    expect(containerSession.screenProperty.rotation === targetRotation).assertTrue();

  });
}

function landscapeStartSyncTest() {
  it('landscapeStartSync_1', 0, async () => {
    const controller = await getControllerInstance();
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
    let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
    let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
    let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    testSCBScreenProperty.rotation = RotationConstants.ROTATION_0;
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession,
      testSCBScreenProperty);
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.rotation = RotationConstants.ROTATION_90;
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;

    screenProperty.screenId = -100;
    controller.landscapeStartSync(containerSession, screenProperty);
    expect(containerSession.screenProperty.rotation === screenProperty.rotation).assertFalse();
  });

  it('landscapeStartSync_2', 0, async () => {
    const controller = await getControllerInstance();
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
    let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
    let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
    let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    testSCBScreenProperty.rotation = RotationConstants.ROTATION_0;
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession,
      testSCBScreenProperty);
    const mainScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    let screenProperty: SCBScreenProperty = mainScreenSession.scbScreenProperty.getCopy();
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;

    containerSession.screenProperty.screenId = mainScreenSession.session.screenId;
    let targetRotation: number = RotationConstants.ROTATION_270;
    controller.sceneLandscapeStart(mainScreenSession, containerSession, targetRotation, screenProperty);
    setTimeout(()=>{
      controller.landscapeStartSync(containerSession, screenProperty);
    },600);
    expect(containerSession.screenProperty.rotation === targetRotation).assertTrue();
  });
}

function isLandscapeStartInterruptTest() {
  it('isLandscapeStartInterrupt_1', 0, async () => {
    const controller = await getControllerInstance();
    let mocker: MockKit = new MockKit();
    let getMainScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getMainScreenSession);
    when(getMainScreenSession)().afterReturn(null);
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
    controller.setLandScapeStartNotSync(true);
    expect(controller.isLandscapeStartInterrupt() === false).assertTrue();
    controller.setLandScapeStartNotSync(false);
    expect(controller.isLandscapeStartInterrupt() === false).assertTrue();
    mocker.ignoreMock(sessionManager, sessionManager.getMainScreenSession)
  });

  it('isLandscapeStartInterrupt_2', 0, async () => {
    const controller = await getControllerInstance();
    let mocker: MockKit = new MockKit();
    let getMainScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getMainScreenSession);
    let scbScreenSession = new SCBScreenSession(screenSession);
    scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
    when(getMainScreenSession)().afterReturn(scbScreenSession);
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
    controller.setLandScapeStartNotSync(true);
    expect(controller.isLandscapeStartInterrupt() === true).assertTrue();
    controller.setLandScapeStartNotSync(false);
    expect(controller.isLandscapeStartInterrupt() === false).assertTrue();
    mocker.ignoreMock(sessionManager, sessionManager.getMainScreenSession)
  });
}

function isLandscapeStartNotSyncTest() {
  it('isLandscapeStartNotSync_1', 0, async () => {
    const controller = await getControllerInstance();
    let mocker: MockKit = new MockKit();
    let getMainScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getMainScreenSession);
    when(getMainScreenSession)().afterReturn(null);
    expect(controller.isLandscapeStartNotSync() === false).assertTrue();
    mocker.ignoreMock(sessionManager, sessionManager.getMainScreenSession)
  });

  it('isLandscapeStartNotSync_2', 0, async () => {
    const controller = await getControllerInstance();
    let mocker: MockKit = new MockKit();
    let getMainScreenSession: Function = mocker.mockFunc(sessionManager, sessionManager.getMainScreenSession);
    let scbScreenSession = new SCBScreenSession(screenSession);
    scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
    when(getMainScreenSession)().afterReturn(scbScreenSession);
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;

    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
    let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
    let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
    let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession,
      testSCBScreenProperty);
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.copy(scbScreenSession.scbScreenProperty);
    let targetRotation: number = RotationConstants.ROTATION_270;
    controller.sceneLandscapeStart(scbScreenSession, containerSession, targetRotation, screenProperty);

    expect(controller.isLandscapeStartNotSync() === true).assertTrue();
    controller.setLandScapeStartNotSync(false);
    expect(controller.isLandscapeStartNotSync() === false).assertTrue();
    mocker.ignoreMock(sessionManager, sessionManager.getMainScreenSession)
  });
}

function notifyRotationChangeTest() {
  it('notifyRotationChange', 0, async () => {
    const controller = await getControllerInstance();
    let testScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let testReason: SCBRotateChangeReason = SCBRotateChangeReason.ROTATE_BEGIN;
    let res = controller.notifyRotationChange(testScreenProperty, testReason);
    if (res === null || typeof res !== 'object' || !Array.isArray(res)) {
      return;
    }
    expect(res.length >= 0).assertTrue();
  });
}

function updateRotationWindowTest() {
  it('updateRotationWindow', 0, async () => {
    const controller = await getControllerInstance();
    let testRotationWindow: Array<sceneSessionManager.RotationChangeResult> | void = undefined;
    controller.updateRotationWindow(testRotationWindow);

    let testRotationChangeResult: sceneSessionManager.RotationChangeResult = {
      persistentId: 0,
      rectType: sceneSessionManager.RectType.RELATIVE_TO_SCREEN,
      windowRect: {
        posX_: 0,
        posY_: 0,
        width_: 200,
        height_: 200,
      }
    }
    testRotationWindow = [];
    testRotationWindow.push(testRotationChangeResult);
    controller.updateRotationWindow(testRotationWindow);
    expect(testRotationWindow.length).assertEqual(1);
  });
}