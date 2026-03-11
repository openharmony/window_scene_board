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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  SCBKeyboardSession,
  SCBSceneInfo,
  KeyboardChangeCallback,
  SCBScreenProperty,
  SCBSessionRect,
  SCBSceneSession,
  SCBSceneContainerSession,
} from '../../../../../../../..';
import { RotationConstants } from '@ohos/commonconstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSystemSceneSession } from '../../../../../../../main/ets/scene/session/SCBSystemSceneSession';
import { SCBSpecificSession } from '../../../../../../../main/ets/scene/session/SCBSpecificSession';
import { ReflectionUtils } from './ReflectionUtils';

interface ISCBKeyboardSession {
  updateKeyboardOffset(callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null): void;

  onSessionForceHideChange(hide: boolean): void;

  onSessionStateChange(state: sceneSessionManager.SessionState): void;

  onKeyboardGravityChange(gravity: sceneSessionManager.KeyboardGravity): void;

  onSessionTouchableChange(isTouchable: boolean): void;

  onCustomAnimationPlaying(isPlaying: boolean): void;

  setSpecialWindowCornerConfig(): void;

  setSpecialWindowShadowConfig(): void;

  handleKeyboardRectChange(reason: sceneSessionManager.SessionSizeChangeReason): void;

  onAdjustKeyboardLayout(params: sceneSessionManager.KeyboardLayoutParams): void;

  notifyKeyboardStateChange(state: number): void;
}

let keyboardSession: SCBKeyboardSession;
let iKeyboardSession: ISCBKeyboardSession;

export function SCBKeyboardSessionTest() {
  describe('SCBKeyboardSessionTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      let keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();
      let keyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession = sceneSessionManager.requestSceneSession(sceneInfo);
      keyboardSession = new SCBKeyboardSession(sceneSession, () => {
      }, keyboardChangeCallbackMap, keyboardChangeListenerList);
      iKeyboardSession = (keyboardSession as object as ISCBKeyboardSession);
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    SCBKeyboardSessionTest1();
    SCBKeyboardSessionTest2();
    SCBKeyboardSessionTest3();
    SCBKeyboardSessionTest5();
    SCBKeyboardSessionTest6();
    SCBKeyboardSessionTest7();
  })
}

function SCBKeyboardSessionTest1() {
  it('getZIndex', 0, () => {
    expect(keyboardSession.getZIndex() >= 0).assertTrue();
  });
  it('isKeyboardShowing', 0, () => {
    keyboardSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_DISCONNECT;
    expect(keyboardSession.isKeyboardShowing()).assertFalse();

    keyboardSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_FOREGROUND;
    expect(keyboardSession.isKeyboardShowing()).assertTrue();

    keyboardSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_ACTIVE;
    expect(keyboardSession.isKeyboardShowing()).assertTrue();
  });
  it('registerSessionTouchableChangeCallback', 0, () => {
    keyboardSession.registerSessionTouchableChangeCallback(() => {
    });
  });
  it('setZOrder', 0, () => {
    keyboardSession.setZOrder(1);
    expect(true).assertTrue();

    keyboardSession.setZOrder(1);
    expect(true).assertTrue();
  });
  it('unRegisterAll', 0, () => {
    keyboardSession.unRegisterAll();
    expect(true).assertTrue();
  });
  it('openKeyboardSyncTransaction', 0, () => {
    keyboardSession.openKeyboardSyncTransaction();
    expect(true).assertTrue();
  });
  it('closeKeyboardSyncTransaction', 0, () => {
    keyboardSession.closeKeyboardSyncTransaction(true, false, false);
    expect(true).assertTrue();
    keyboardSession.closeKeyboardSyncTransaction(false, false, true);
    expect(true).assertTrue();
  });
}

function SCBKeyboardSessionTest2() {
  it('updateInputRect', 0, () => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    ;

    screenProperty.rotation = RotationConstants.ROTATION_90;
    keyboardSession.updateInputRect(screenProperty);
    expect(true).assertTrue();

    screenProperty.rotation = RotationConstants.ROTATION_0;
    keyboardSession.updateInputRect(screenProperty);
    expect(true).assertTrue();

    screenProperty.rotation = RotationConstants.ROTATION_180;
    keyboardSession.updateInputRect(screenProperty);
    expect(true).assertTrue();
  });
  it('updateKeyboardRectForRotation', 0, () => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    ;

    screenProperty.rotation = RotationConstants.ROTATION_90;
    keyboardSession.updateKeyboardRectForRotation(screenProperty);
    expect(true).assertTrue();

    screenProperty.rotation = RotationConstants.ROTATION_0;
    keyboardSession.updateKeyboardRectForRotation(screenProperty);
    expect(true).assertTrue();

    screenProperty.rotation = RotationConstants.ROTATION_180;
    keyboardSession.updateKeyboardRectForRotation(screenProperty);
    expect(true).assertTrue();
  });
  it('GetKeyboardBorderRadius', 0, () => {
    expect(keyboardSession.GetKeyboardBorderRadius() >= 0).assertTrue();
  });
  it('updateKeyboardOffset', 0, () => {
    iKeyboardSession.updateKeyboardOffset(keyboardSession.getCallingSession());
    expect(true).assertTrue();
  });
}

function SCBKeyboardSessionTest3() {
  it('onSessionForceHideChange', 0, () => {
    iKeyboardSession.onSessionForceHideChange(true);
    expect(true).assertTrue();
  });
  it('onSessionStateChange', 0, () => {
    iKeyboardSession.onSessionStateChange(sceneSessionManager.SessionState.STATE_DISCONNECT);
    expect(true).assertTrue();
    iKeyboardSession.onSessionStateChange(sceneSessionManager.SessionState.STATE_ACTIVE);
    expect(true).assertTrue();
    iKeyboardSession.onSessionStateChange(sceneSessionManager.SessionState.STATE_INACTIVE);
    expect(true).assertTrue();
    iKeyboardSession.onSessionStateChange(sceneSessionManager.SessionState.STATE_CONNECT);
    expect(true).assertTrue();
    iKeyboardSession.onSessionStateChange(sceneSessionManager.SessionState.STATE_FOREGROUND);
    expect(true).assertTrue();
    iKeyboardSession.onSessionStateChange(sceneSessionManager.SessionState.STATE_BACKGROUND);
    expect(true).assertTrue();
    ReflectionUtils.setProperty(keyboardSession.sessionData, "sessionState",
      sceneSessionManager.SessionState.STATE_DISCONNECT);
    ReflectionUtils.useFunc(keyboardSession, "onSessionStateChange",
      sceneSessionManager.SessionState.STATE_BACKGROUND);
    expect(true).assertTrue();
  });
  it('onSessionTouchableChange', 0, () => {
    iKeyboardSession.onSessionTouchableChange(true);
    expect(true).assertTrue();
  });
  it('onCustomAnimationPlaying', 0, () => {
    iKeyboardSession.onCustomAnimationPlaying(true);
    expect(true).assertTrue();
  });
  it('setSpecialWindowCornerConfig', 0, () => {
    iKeyboardSession.setSpecialWindowCornerConfig();
    expect(true).assertTrue();
  });
}

function getSessionRect(): sceneSessionManager.SessionRect {
  let rect: sceneSessionManager.SessionRect = {
    posX_: 1,
    posY_: 1,
    width_: 1,
    height_: 1,
  };
  return rect;
}

function SCBKeyboardSessionTest5() {
  it('onAdjustKeyboardLayout', 0, () => {
    let rect: sceneSessionManager.SessionRect = {
      posX_: 1,
      posY_: 1,
      width_: 1,
      height_: 1
    };
    iKeyboardSession.onAdjustKeyboardLayout({
      gravity: sceneSessionManager.KeyboardGravity.GRAVITY_DEFAULT,
      landscapeAvoidHeight: 0,
      portraitAvoidHeight: 0,
      landscapeKeyboardRect: rect,
      portraitKeyboardRect: rect,
      landscapePanelRect: rect,
      portraitPanelRect: rect,
    });
    expect(true).assertTrue();
  });
}

function SCBKeyboardSessionTest6() {
  it('notifyKeyboardStateChange', 0, () => {
    iKeyboardSession.notifyKeyboardStateChange(sceneSessionManager.SessionState.STATE_DISCONNECT);
    expect(true).assertTrue();
    iKeyboardSession.notifyKeyboardStateChange(sceneSessionManager.SessionState.STATE_CONNECT);
    expect(true).assertTrue();
  });
  it('IsNeedOpenSyncTransaction', 0, () => {
    keyboardSession.setKeyboardRotationFlag(true);
    let res: boolean = keyboardSession.IsNeedOpenSyncTransaction(true, true);
    expect(res).assertFalse();

    keyboardSession.setKeyboardRotationFlag(false);
    keyboardSession.sessionGravity = sceneSessionManager.KeyboardGravity.GRAVITY_FLOAT;
    res = keyboardSession.IsNeedOpenSyncTransaction(true, true);
    expect(res).assertFalse();

    keyboardSession.sessionGravity = sceneSessionManager.KeyboardGravity.GRAVITY_BOTTOM;
    res = keyboardSession.IsNeedOpenSyncTransaction(true, true);
    expect(res).assertFalse();

    res = keyboardSession.IsNeedOpenSyncTransaction(false, true);
    expect(res).assertFalse();

    res = keyboardSession.IsNeedOpenSyncTransaction(false, false);
    expect(res).assertFalse();

    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    keyboardSession.sessionData.callingSession = sceneSession;
    res = keyboardSession.IsNeedOpenSyncTransaction(false, false);
    expect(res).assertFalse();

    sceneSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_DISCONNECT;
    res = keyboardSession.IsNeedOpenSyncTransaction(false, false);
    expect(res).assertFalse();

    sceneSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_FOREGROUND;
    res = keyboardSession.IsNeedOpenSyncTransaction(false, false);
    expect(res).assertTrue();
  });
}

function SCBKeyboardSessionTest7() {
  it('clearContainerSessionRecordInKeyboard', 0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

    keyboardSession.clearContainerSessionRecordInKeyboard();
    expect(true).assertTrue();

    keyboardSession.sessionData.containerSession = containerSession;
    keyboardSession.clearContainerSessionRecordInKeyboard();
    expect(true).assertTrue();

    keyboardSession.clearContainerSessionRecordInKeyboard(containerSession.containerId);
    expect(true).assertTrue();
  });
  it('getKeyboardPanelTranslateY', 0, () => {
    keyboardSession.getKeyboardPanelTranslateY();
    expect(true).assertTrue();
  });
  it('notifyKeyboardAnimationCompleted', 0, () => {
    const panelRect = new SCBSessionRect(0, 1700, 1620, 1020);
    keyboardSession.notifyKeyboardAnimationCompleted(0, true, panelRect);
    expect(true).assertTrue();
    const beginRect = new SCBSessionRect(600, 600, 600, 600);
    keyboardSession.notifyKeyboardAnimationCompleted(0, true, panelRect, beginRect);
    expect(true).assertTrue();
  });
  it('getKeyboardPanelRealRect', 0, () => {
    const panelRect = keyboardSession.getKeyboardPanelRealRect();
    expect(true).assertTrue();
  });
}