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
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSpecificSession,
  SCBSceneInfo,
  SCBScreenProperty,
  SCBSessionRect
} from '../../../../../../../..';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { ReflectionUtils } from './ReflectionUtils';
import { SCBSessionEventId } from '../../../../../../../main/ets/scene/session/SCBSceneSession.ts';
import { FocusChangeReason } from '../../../../../../../main/ets/common/FocusChangeReason';
import { SCBSceneSession, SCBWindowShadowConfig } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import { SCBSceneSessionManager } from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';

let specificSession: SCBSpecificSession;
let sceneInfo: SCBSceneInfo;
let stateChangeCallback = (parentId: number, persistentId: number, state: sceneSessionManager.SessionState): void => {
  if (typeof parentId !== 'number') {
    return;
  }
};
let nullCallback: Function;

export function SCBSpecificSessionTest() {
  describe('SCBSpecificSessionTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      specificSession = new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo), stateChangeCallback);
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    getZIndexTest();
    registerSessionTouchableChangeCallbackTest();
    setWindowOffsetTest();
    setWindowScaleTest();
    setFocusedTest();
    setTouchableTest();
    setZOrderTest();
    onCreateSpecificSessionTest();
    registerCreateSubSessionCallbackTest();
    setSpecialWindowEffectConfigTest();
    isSubWindowTest();
    isVoiceInteractionWindowTest();
    isDialogWindowTest();
    isTopmostSubWindowTest();
    needSetSpecialWindowShadowConfigTest();
    needSetSpecialWindowCornerConfigTest();
    resetSpecialWindowShadowConfigTest();
    resetSpecialWindowCornerConfigTest();
    setSpecialWindowCornerConfigTest();
    setSpecialWindowShadowConfigTest();
    onSessionControlStatusChangeTest();
    onSessionRectChangeTest();
    getFocusedTest();
    getFocusableTest();
    setFocusableTest();
    getVisibilityTest();
    setVisibilityTest();
    addRefCountTest();
    decRefCountTest();
    unRegisterAllTest();
    updateSizeChangeReasonTest();
    updateSubRectForSplitTest();
    updateSubRectForFloatTest();
    calSubRectInMultiWindowTest();
    isSessionForegroundTest();
    isFloatWindowTest();
    onSessionSetWindowCornerRadiusTest();
    onSessionForceHideChangeTest();
    onSessionStateChangeTest();
    onRaiseToTopTest();
    onRaiseToTopForPointDownTest();
    onRaiseAboveTargetTest();
    onSessionFocusableChangeTest();
    onSessionTouchableChangeTest();
    onClickModalWindowOutsideTest();
    onCustomAnimationPlayingTest();
    onSessionEventTest();
    getBundleNameTest();
    onSessionModalTypeChangeTest();
    onSessionDisplayIdChangeTest();
    updateDisplayIdTest();
    updateSessionStateChangeFuncTest();
    updateRectTest();
    updateSubRectAlgorithmTest();
    getNameTest();
    setParentSessionRegisterTest();
    subWindowAppModalTypeTest();
    registerSessionStateChangeCallbackTest();
    unregisterSessionStateChangeCallbackTest();
    subWindowRectTest();
    subWindowGetOutlineTest();
    registerSessionRectChangeRelativeParentCallbackTest();
    unregisterSessionRectChangeRelativeParentCallbackTest();
  })
}

function getZIndexTest() {
  it('getZIndex', 0, () => {
    // The default value if callback not set.
    expect(specificSession.getZIndex()).assertEqual(0);
    specificSession.sessionData.getZIndexCallback = () => {return 1};
    expect(specificSession.getZIndex()).assertEqual(1);
  })
}

function registerSessionTouchableChangeCallbackTest() {
  it('registerSessionTouchableChangeCallback', 0, () => {
    specificSession.registerSessionTouchableChangeCallback(stateChangeCallback);
    expect(specificSession.sessionData.sessionTouchableChangeCallback).assertEqual(stateChangeCallback);
  })
}

function setWindowOffsetTest() {
  it('setWindowOffset', 0, () => {
    specificSession.setWindowOffset(100, 200);
    expect(ReflectionUtils.getProperty(specificSession, 'windowOffsetX')).assertEqual(100);
    expect(ReflectionUtils.getProperty(specificSession, 'windowOffsetY')).assertEqual(200);
    specificSession.setWindowOffset(100, 200);
  })
}

function setWindowScaleTest() {
  it('setWindowScale', 0, () => {
    specificSession.setWindowScale(100, 200);
    expect(ReflectionUtils.getProperty(specificSession, 'windowScaleX')).assertEqual(100);
    expect(ReflectionUtils.getProperty(specificSession, 'windowScaleY')).assertEqual(200);
    specificSession.setWindowScale(100, 200);
  })
}

function setFocusedTest() {
  it('setFocused', 0, () => {
    specificSession.setFocused(true);
    expect(specificSession.isFocused).assertTrue();
    // COVERAGE if (this.isFocused === isFocused)
    specificSession.setFocused(true);
    expect(specificSession.isFocused).assertTrue();
    // COVERAGE if (isFocused && !this.isFocusable)
    specificSession.setFocused(false);
    expect(specificSession.isFocused).assertFalse();
    specificSession.setFocusable(false);
    specificSession.setFocused(true);
    expect(specificSession.isFocused).assertFalse();
  })
}

function setTouchableTest() {
  it('setTouchable', 0, () => {
    specificSession.setTouchable(true);
    expect(specificSession.isTouchable).assertTrue();
    specificSession.setTouchable(false);
    expect(specificSession.isTouchable).assertFalse();
  })

}

function setZOrderTest() {
  it('setZOrder', 0, () => {
    let ZOrder = 100;
    specificSession.setZOrder(ZOrder);
    expect(specificSession.sessionInfo.zOrder).assertEqual(ZOrder);
    // COVERAGE if (this.sessionInfo.zOrder !== zOrder)
    specificSession.setZOrder(ZOrder);
    expect(specificSession.sessionInfo.zOrder).assertEqual(ZOrder);
    ReflectionUtils.setProperty(specificSession, 'session', null);
    specificSession.setZOrder(ZOrder + 1);
    expect(specificSession.sessionInfo.zOrder).assertEqual(ZOrder);
  })
}

function onCreateSpecificSessionTest() {
  it('onCreateSpecificSession', 0, () => {
    ReflectionUtils.useFunc(specificSession, 'onCreateSpecificSession', specificSession);
    specificSession.sessionData.createSubSessionCallback = stateChangeCallback;
    ReflectionUtils.useFunc(specificSession, 'onCreateSpecificSession', specificSession);
    expect(true).assertTrue();
  })
}

function registerCreateSubSessionCallbackTest() {
  it('registerCreateSubSessionCallback', 0, () => {
    specificSession.registerCreateSubSessionCallback(stateChangeCallback);
    expect(specificSession.sessionData.createSubSessionCallback).assertEqual(stateChangeCallback);
  })
}

function setSpecialWindowEffectConfigTest() {
  it('setSpecialWindowEffectConfig', 0, ()=>{
    let specialBoarderRadiusOrigin = specificSession.specialBoarderRadius;
    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_APP)
    specificSession.setSpecialWindowEffectConfig();
    expect(specificSession.specialBoarderRadius).assertEqual(specialBoarderRadiusOrigin);

    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_SUB_APP);
    ReflectionUtils.useFunc(specificSession, 'onNeedDefaultAnimationFlagChange', true);
    specificSession.setSpecialWindowEffectConfig();
    specificSession.syncSpecificCornerRadius = -1; // -1 is invalid sync specific corner radius
    let specialBoarderRadius: Number = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    if (specialBoarderRadius !== undefined) {
      expect(specificSession.specialBoarderRadius).assertEqual(specialBoarderRadius);
    } else {
      expect(specificSession.specialBoarderRadius).assertEqual(0);
    }
  })
}

function isSubWindowTest() {
  it('isSubWindow', 0, ()=>{
    let ret = specificSession.session.type ===  sceneSessionManager.SessionType.TYPE_SUB_APP;
    expect(specificSession.isSubWindow()).assertEqual(ret);
  })
}

function isVoiceInteractionWindowTest() {
  it('isVoiceInteractionWindow', 0, ()=>{
    let ret = specificSession.session.type ===  sceneSessionManager.SessionType.TYPE_VOICE_INTERACTION;
    expect(specificSession.isVoiceInteractionWindow()).assertEqual(ret);
  })
}

function isDialogWindowTest() {
  it('isDialogWindow', 0, ()=>{
    let ret = specificSession.session.type ===  sceneSessionManager.SessionType.TYPE_DIALOG;
    expect(specificSession.isDialogWindow()).assertEqual(ret);
  })
}

function isTopmostSubWindowTest() {
  it('isTopmostSubWindow', 0, ()=>{
    let ret = specificSession.session.isTopmost && specificSession.isSubWindow();
    expect(specificSession.isTopmostSubWindow()).assertEqual(ret);
  })
}

function needSetSpecialWindowShadowConfigTest() {
  it('needSetSpecialWindowShadowConfig01', 0, () => {
    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_SUB_APP);
    ReflectionUtils.useFunc(specificSession, 'onNeedDefaultAnimationFlagChange', false);
    let ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowShadowConfig') as boolean;
    expect(ret).assertFalse();

    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_DIALOG);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowShadowConfig') as boolean;
    expect(ret).assertFalse();

    ReflectionUtils.useFunc(specificSession, 'onNeedDefaultAnimationFlagChange', true);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowShadowConfig') as boolean;
    expect(ret).assertTrue();
  })
  it('needSetSpecialWindowShadowConfig02', 0, () => {
    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_APP);
    let ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowShadowConfig') as boolean;
    expect(ret).assertFalse();

    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_FLOAT);
    ReflectionUtils.setProperty(specificSession.session, 'isAppType', true);
    ReflectionUtils.useFunc(specificSession, 'onNeedDefaultAnimationFlagChange', true);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowShadowConfig') as boolean;
    expect(ret).assertTrue();

    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_FLOAT_CAMERA);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowShadowConfig') as boolean;
    expect(ret).assertTrue();

    ReflectionUtils.useFunc(specificSession, 'onNeedDefaultAnimationFlagChange', false);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowShadowConfig') as boolean;
    expect(ret).assertFalse();

    ReflectionUtils.setProperty(specificSession.session, 'isAppType', false);
    specificSession.syncShadowConfig = new SCBWindowShadowConfig();
    specificSession.syncShadowConfig.radius = -1;
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowShadowConfig') as boolean;
    expect(ret).assertFalse();

    specificSession.syncShadowConfig.radius = 0;
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowShadowConfig') as boolean;
    expect(ret).assertFalse();
  })
}

function needSetSpecialWindowCornerConfigTest() {
  it('needSetSpecialWindowCornerConfig01', 0, () => {
    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_SUB_APP);
    ReflectionUtils.useFunc(specificSession, 'onNeedDefaultAnimationFlagChange', false);
    let ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowCornerConfig') as boolean;
    expect(ret).assertFalse();

    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_DIALOG);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowCornerConfig') as boolean;
    expect(ret).assertFalse();

    ReflectionUtils.useFunc(specificSession, 'onNeedDefaultAnimationFlagChange', true);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowCornerConfig') as boolean;
    expect(ret).assertTrue();
  })
  it('needSetSpecialWindowCornerConfig02', 0, () => {
    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_APP);
    let ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowCornerConfig') as boolean;
    expect(ret).assertFalse();

    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_FLOAT);
    ReflectionUtils.setProperty(specificSession.session, 'isAppType', true);
    ReflectionUtils.useFunc(specificSession, 'onNeedDefaultAnimationFlagChange', true);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowCornerConfig') as boolean;
    expect(ret).assertTrue();

    ReflectionUtils.setProperty(specificSession.session, 'type', sceneSessionManager.SessionType.TYPE_FLOAT_CAMERA);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowCornerConfig') as boolean;
    expect(ret).assertTrue();

    ReflectionUtils.useFunc(specificSession, 'onNeedDefaultAnimationFlagChange', false);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowCornerConfig') as boolean;
    expect(ret).assertFalse();

    ReflectionUtils.setProperty(specificSession.session, 'isAppType', false);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowCornerConfig') as boolean;
    expect(ret).assertFalse();

    specificSession.syncSpecificCornerRadius = 1; // 1 is valid sync specific corner radius
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowCornerConfig') as boolean;
    expect(ret).assertFalse();

    ReflectionUtils.setProperty(specificSession.session, 'isAppType', true);
    ret = ReflectionUtils.useFunc(specificSession, 'needSetSpecialWindowCornerConfig') as boolean;
    expect(ret).assertFalse();
  })
}

function resetSpecialWindowShadowConfigTest() {
  it('resetSpecialWindowShadowConfig', 0, () => {
    ReflectionUtils.useFunc(specificSession, 'resetSpecialWindowShadowConfig');
    specificSession.shadowConfig.radius = 1;
    ReflectionUtils.useFunc(specificSession, 'resetSpecialWindowShadowConfig');
    expect(specificSession.shadowConfig.radius).assertEqual(0);
  })
}

function resetSpecialWindowCornerConfigTest() {
  it('resetSpecialWindowCornerConfig', 0, () => {
    ReflectionUtils.useFunc(specificSession, 'resetSpecialWindowCornerConfig');
    specificSession.specialBoarderRadius = 1;
    ReflectionUtils.useFunc(specificSession, 'resetSpecialWindowCornerConfig');
    expect(specificSession.specialBoarderRadius).assertEqual(0);
  })
}

function setSpecialWindowCornerConfigTest() {
  it('setSpecialWindowCornerConfig', 0, () => {
    specificSession.syncSpecificCornerRadius = 1; // 1 is valid sync specific corner radius
    ReflectionUtils.useFunc(specificSession, 'setSpecialWindowCornerConfig');
    expect(specificSession.specialBoarderRadius).assertEqual(specificSession.syncSpecificCornerRadius);

    specificSession.syncSpecificCornerRadius = -1; // -1 is invalid sync specific corner radius
    specificSession.specialBoarderRadius = 0;
    ReflectionUtils.useFunc(specificSession, 'setSpecialWindowCornerConfig');
    let specialBoarderRadius: Number = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    if (specialBoarderRadius !== undefined) {
      expect(specificSession.specialBoarderRadius).assertEqual(specialBoarderRadius);
    } else {
      expect(specificSession.specialBoarderRadius).assertEqual(0);
    }
  })
}

function setSpecialWindowShadowConfigTest() {
  it('setSpecialWindowShadowConfig', 0, () => {
    ReflectionUtils.useFunc(specificSession, 'setSpecialWindowShadowConfig');
    expect(true).assertTrue();
  })
}

function onSessionControlStatusChangeTest() {
  it('onSessionControlStatusChange', 0, () => {
    specificSession.unregisterSessionControlStatusChangeCallback();
    ReflectionUtils.useFunc(specificSession, 'onSessionControlStatusChange');
    specificSession.registerSessionControlStatusChangeCallback(stateChangeCallback);
    ReflectionUtils.useFunc(specificSession, 'onSessionControlStatusChange');
    expect(true).assertTrue();
  })
}

function onSessionRectChangeTest() {
  it('onSessionRectChange', 0, () => {
    let sessionRectChangeCallback = (rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason):void => {
      console.log("sessionRectChangeCallback, rect: " + JSON.stringify(rect) + ", reason: " + reason);
    }
    specificSession.registerSessionRectChangeCallback(sessionRectChangeCallback);

    let rect :sceneSessionManager.SessionRect = {posX_ : 100, posY_ : 200, width_ : 300, height_ : 400};
    let reason :sceneSessionManager.SessionSizeChangeReason = sceneSessionManager.SessionSizeChangeReason.MOVE;

    //COVERAGE if (this.sessionRectChangeCallback)
    specificSession.onSessionRectChange(rect, reason);
    expect(specificSession.currRect.left.getPx()).assertEqual(0);
    expect(specificSession.currRect.top.getPx()).assertEqual(0);
    expect(specificSession.currRect.width.getPx()).assertEqual(0);
    expect(specificSession.currRect.height.getPx()).assertEqual(0);

    specificSession.unregisterSessionRectChangeCallback();
    specificSession.onSessionRectChange(rect, reason);
    expect(specificSession.currRect.left.getPx()).assertEqual(rect.posX_);
    expect(specificSession.currRect.top.getPx()).assertEqual(rect.posY_);

    reason = sceneSessionManager.SessionSizeChangeReason.RESIZE;
    specificSession.subWindowAnchorInfo.isFollowParent = false;
    specificSession.onSessionRectChange(rect, reason);
    expect(specificSession.currRect.width.getPx()).assertEqual(rect.width_);
    expect(specificSession.currRect.height.getPx()).assertEqual(rect.height_);

    reason = sceneSessionManager.SessionSizeChangeReason.RESIZE;
    specificSession.subWindowAnchorInfo.isFollowParent = true;
    specificSession.onSessionRectChange(rect, reason);
    expect(specificSession.currRect.width.getPx()).assertEqual(rect.width_);
    expect(specificSession.currRect.height.getPx()).assertEqual(rect.height_);

    rect = {posX_ : 0, posY_ : 0, width_ : 600, height_ : 800};
    reason = sceneSessionManager.SessionSizeChangeReason.MAXIMIZE;
    specificSession.subWindowAnchorInfo.isFollowParent = false;
    specificSession.onSessionRectChange(rect, reason);
    expect(specificSession.currRect.left.getPx()).assertEqual(rect.posX_);
    expect(specificSession.currRect.top.getPx()).assertEqual(rect.posY_);
    expect(specificSession.currRect.width.getPx()).assertEqual(rect.width_);
    expect(specificSession.currRect.height.getPx()).assertEqual(rect.height_);
  })
}

function getFocusedTest() {
  it('getFocused', 0, () => {
    expect(specificSession.getFocused()).assertEqual(specificSession.isFocused);
  })

}

function getFocusableTest() {
  it('getFocusable', 0, () => {
    expect(specificSession.getFocusable()).assertEqual(specificSession.isFocusable);
  })
}

function setFocusableTest() {
  it('setFocusable', 0, () => {
    specificSession.setFocusable(true);
    expect(specificSession.getFocusable()).assertTrue();
    specificSession.setFocusable(false);
    expect(specificSession.getFocusable()).assertFalse();
  })
}

function getVisibilityTest() {
  it('getVisibility', 0, () => {
    expect(specificSession.getVisibility()).assertEqual(specificSession.visibility);
  })
}

function setVisibilityTest() {
  it('setVisibility', 0, () => {
    specificSession.setVisibility(true);
    expect(specificSession.getVisibility()).assertTrue();
    specificSession.setVisibility(false);
    expect(specificSession.getVisibility()).assertFalse();
  })
}

function addRefCountTest() {
  it('addRefCount', 0, () => {
    specificSession.addRefCount();
    expect(specificSession.getRefCount()).assertEqual(1);
  })
}

function decRefCountTest() {
  it('decRefCount', 0, () => {
    specificSession.decRefCount();
    expect(specificSession.getRefCount()).assertEqual(-1);
  })
}

function unRegisterAllTest() {
  it('unRegisterAll', 0, () => {
    specificSession.sessionData.sessionControlStatusChangeCallback = stateChangeCallback;
    specificSession.sessionData.sessionTouchableChangeCallback = stateChangeCallback;
    specificSession.sessionData.customAnimationPlayingCallback = stateChangeCallback;
    specificSession.sessionData.sessionForceHideCallback = stateChangeCallback;
    specificSession.sessionData.sessionPrepareCloseCallback = stateChangeCallback;

    // COVERAGE if (this.refCount !== 0)
    specificSession.addRefCount();
    specificSession.unRegisterAll();
    expect(specificSession.sessionData.sessionControlStatusChangeCallback).not().assertNull();
    expect(specificSession.sessionData.sessionTouchableChangeCallback).not().assertNull();
    expect(specificSession.sessionData.customAnimationPlayingCallback).not().assertNull();
    expect(specificSession.sessionData.sessionForceHideCallback).not().assertNull();
    expect(specificSession.sessionData.sessionPrepareCloseCallback).not().assertNull();

    specificSession.decRefCount();
    specificSession.unRegisterAll();
    expect(specificSession.sessionData.sessionControlStatusChangeCallback).assertNull();
    expect(specificSession.sessionData.sessionTouchableChangeCallback).assertNull();
    expect(specificSession.sessionData.customAnimationPlayingCallback).assertNull();
    expect(specificSession.sessionData.sessionForceHideCallback).assertNull();
    expect(specificSession.sessionData.sessionPrepareCloseCallback).assertNull();
  })
}

function updateSizeChangeReasonTest() {
  it('updateSizeChangeReason', 0, () => {
    let reason :sceneSessionManager.SessionSizeChangeReason = sceneSessionManager.SessionSizeChangeReason.MAXIMIZE;
    specificSession.updateSizeChangeReason(reason);
    expect(specificSession.session).not().assertNull();
  })
}

function updateSubRectForSplitTest() {
  it('updateSubRectForSplit', 0, () => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.width = 300;
    screenProperty.height = 400;
    let mainRect: SCBSessionRect = new SCBSessionRect();
    specificSession.updateSubRectForSplit(screenProperty, mainRect);
    expect(specificSession.requestedRect.width.getPx()).assertEqual(screenProperty.width);
    specificSession.updateSubRectForSplit(screenProperty, mainRect);
    expect(specificSession.requestedRect.height.getPx()).assertEqual(screenProperty.height);
  })
}

function updateSubRectForFloatTest() {
  it('updateSubRectForFloat', 0, () => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.width = 300;
    screenProperty.height = 400;
    let mainRect: SCBSessionRect = new SCBSessionRect();
    specificSession.updateSubRectForFloat(screenProperty, mainRect);
    expect(specificSession.requestedRect.width.getPx()).assertEqual(screenProperty.width);
    specificSession.updateSubRectForFloat(screenProperty, mainRect);
    expect(specificSession.requestedRect.height.getPx()).assertEqual(screenProperty.height);
  })
}

function calSubRectInMultiWindowTest() {
  it('calSubRectInMultiWindow', 0, () => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let ret = specificSession.calSubRectInMultiWindow(screenProperty);
    // COVERAGE  if (!(this.isDialogWindow() || this.isSubWindow()))
    if (!(specificSession.isDialogWindow() || specificSession.isSubWindow())) {
      expect(ret).assertNull();
    }
    if (specificSession.getParentSession() === null) {
      expect(ret).assertNull();
    }
  })
}

function isSessionForegroundTest() {
  it('isSessionForeground1', 0, () => {
    specificSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_FOREGROUND;
    expect(specificSession.isSessionForeground()).assertTrue();
  })
  it('isSessionForeground2', 0, () => {
    specificSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_ACTIVE;
    expect(specificSession.isSessionForeground()).assertTrue();
  })
  it('isSessionForeground3', 0, () => {
    specificSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_BACKGROUND;
    expect(specificSession.isSessionForeground()).assertFalse();
  })
}

function isFloatWindowTest() {
  it('test_whenUseIsSubWindowMethod_thenSuccess', 0, ()=>{
    let ret = specificSession.session.type ===  sceneSessionManager.SessionType.TYPE_FLOAT;
    expect(specificSession.isFloatWindow()).assertEqual(ret);
  })
}

function onSessionSetWindowCornerRadiusTest() {
  it('test_whenSetWindowCornerRadiusCallbackNotEqualUndefined_thenOnSessionSetWindowCornerRadiusSuccess', 0, ()=>{
    let func: Function = (cornerRadius: number) => {};
    specificSession.setWindowCornerRadiusCallback = func;
    ReflectionUtils.useFunc(specificSession, 'onSessionSetWindowCornerRadius', 11);
    expect(specificSession.setWindowCornerRadiusCallback != undefined).assertEqual(true);
  })
}

function onSessionForceHideChangeTest() {
  it('test_whenSessionForceHideCallbackNotEqualUndefined_thenOnSessionForceHideChangeSuccess', 0, ()=>{
    let func: Function = (hide: boolean) => {};
    specificSession.registerSessionForceHideCallback(func);
    ReflectionUtils.useFunc(specificSession, 'onSessionForceHideChange', true);
    expect(specificSession.sessionData.sessionForceHideCallback != undefined).assertEqual(true);
  })
}

function onSessionStateChangeTest() {
  it('test_whenUseOnSessionStateChange_thenSuccess', 0, ()=>{
    ReflectionUtils.useFunc(
      specificSession, 'onSessionStateChange', sceneSessionManager.SessionState.STATE_DISCONNECT);
    expect(specificSession.sessionData.sessionState).assertEqual(sceneSessionManager.SessionState.STATE_DISCONNECT);
  })
}

function onRaiseToTopTest() {
  it('test_whenRaiseToTopCallbackNotEqualUndefined_thenOnRaiseToTopSuccess', 0, ()=>{
    let func: Function = (parentId: number, persistentId: number, flag: boolean, reason?: FocusChangeReason) => {};
    specificSession.sessionData.raiseToTopCallback = func;
    ReflectionUtils.useFunc(specificSession, 'onRaiseToTop');
    expect(specificSession.sessionData.raiseToTopCallback != undefined).assertEqual(true);
  })
}

function onRaiseToTopForPointDownTest() {
  it('test_whenRaiseToTopCallback_thenOnRaiseToTopForPointDownSuccess', 0, ()=>{
    let func: Function = (parentId: number, persistentId: number, flag: boolean, reason?: FocusChangeReason) => {};
    specificSession.sessionData.raiseToTopCallback = func;
    ReflectionUtils.useFunc(specificSession, 'onRaiseToTopForPointDown');
    expect(specificSession.sessionData.raiseToTopCallback != undefined).assertEqual(true);
  })
}

function onRaiseAboveTargetTest() {
  it('test_whenRaiseAboveTargetCallbackNotEqualUndefined_thenOnRaiseAboveTarget', 0, ()=>{
    let func: Function = (parentId: number, persistentId: number, subWindowId: number) => {};
    specificSession.sessionData.raiseAboveTargetCallback = func;
    ReflectionUtils.useFunc(specificSession, 'onRaiseAboveTarget', 1);
    expect(specificSession.sessionData.raiseAboveTargetCallback != undefined).assertEqual(true);
  })
}

function onSessionFocusableChangeTest() {
  it('test_whenOnSessionFocusableChange_thenSuccess', 0, ()=>{
    ReflectionUtils.useFunc(specificSession, 'onSessionFocusableChange', true);
    expect(specificSession.isFocusable).assertEqual(true);
  })
}

function onSessionTouchableChangeTest() {
  it('test_whenOnSessionTouchableChange_thenSuccess', 0, ()=>{
    ReflectionUtils.useFunc(specificSession, 'onSessionTouchableChange', true);
    expect(specificSession.isTouchable).assertEqual(true);
  })
}

function onClickModalWindowOutsideTest() {
  it('test_whenClickModalWindowOutsideCallbackNotEqualUndefined_thenOnClickModalWindowOutside', 0, ()=>{
    let func: Function = () => {};
    specificSession.registerClickModalWindowOutsideCallback(func);
    ReflectionUtils.useFunc(specificSession, 'onClickModalWindowOutside');
    expect(specificSession.sessionData.clickModalWindowOutsideCallback != undefined).assertEqual(true);
  })
}

function onCustomAnimationPlayingTest() {
  it('test_whenCustomAnimationPlayingCallbackNotEqualUndefined_thenOnCustomAnimationPlaying', 0, ()=>{
    let func: Function = (isPlaying: boolean) => {};
    specificSession.registerSessionCustomAnimationPlayingCallback(func);
    ReflectionUtils.useFunc(specificSession, 'onCustomAnimationPlaying', true);
    expect(specificSession.sessionData.customAnimationPlayingCallback != undefined).assertEqual(true);
  })
}

function onSessionEventTest() {
  it('test_whenOnSessionEvent_thenSuccess', 0, ()=>{
    ReflectionUtils.useFunc(specificSession, 'onSessionEvent', SCBSessionEventId.EVENT_START_MOVE);
    expect(specificSession.isSessionMoving).assertEqual(true);
  })
}

function getBundleNameTest() {
  it('test_whenIsInvalid_thenReturnEmptyString', 0, ()=>{
    let ret: string = ReflectionUtils.useFunc(specificSession, 'getBundleName');
    expect(ret).assertEqual('');
  })
}

function onSessionModalTypeChangeTest() {
  it('test_whenOnSessionModalTypeChange_thenSuccess', 0, ()=>{
    ReflectionUtils.useFunc(
      specificSession, 'onSessionModalTypeChange', sceneSessionManager.SubWindowModalType.TYPE_NORMAL);
    expect(specificSession.session.subWindowAppModalType).assertEqual(sceneSessionManager.SubWindowModalType.TYPE_NORMAL);
  })
}

function onSessionDisplayIdChangeTest() {
  it('test_whenOnSessionDisplayIdChange_thenSuccess', 0, ()=>{
    ReflectionUtils.useFunc(specificSession, 'onSessionDisplayIdChange', 1);
    expect(specificSession.screenId).assertEqual(1);
  })
}

function updateDisplayIdTest() {
  it('test_whenUpdateDisplayId_thenSuccess', 0, ()=>{
    specificSession.updateDisplayId(1);
    expect(specificSession.screenId).assertEqual(1);
  })
}

function updateSessionStateChangeFuncTest() {
  it('test_whenUpdateSessionStateChangeFunc_thenSuccess', 0, ()=>{
    let func: Function = () => {};
    specificSession.updateSessionStateChangeFunc(func);
    expect(specificSession.sessionData.stateChangeCallback).assertEqual(func);
  })
}

function updateRectTest() {
  it('test_whenUpdateRect_thenSuccess', 0, ()=>{
    let mocker: MockKit = new MockKit();;
    let mockUpdateSizeChangeReason: Function = mocker.mockFunc(specificSession, specificSession.updateSizeChangeReason);
    when(mockUpdateSizeChangeReason)(ArgumentMatchers.any).afterReturnNothing();

    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    specificSession.updateRect(
      rect.left, rect.top, rect.width, rect.height, sceneSessionManager.SessionSizeChangeReason.RESIZE)
    mocker.verify('updateSizeChangeReason', [sceneSessionManager.SessionSizeChangeReason.RESIZE]).atLeast(1);
    mocker.ignoreMock(specificSession, specificSession.updateSizeChangeReason);
  })
}

function updateSubRectAlgorithmTest() {
  it('test_whenUpdateSubRectAlgorithm_thenSuccess', 0, () => {
    specificSession.setRequestedRect(new SCBSessionRect(20, 20, 20, 20));
    let res: SCBSessionRect = specificSession.updateSubRectAlgorithm(new SCBSessionRect(10, 10, 10, 10));
    expect(res.width.getPx()).assertEqual(10);
    expect(res.height.getPx()).assertEqual(10);
    expect(res.left.getPx()).assertEqual(0);
    expect(res.top.getPx()).assertEqual(0);
  })
}

function getNameTest() {
  it('test_whenGetName_thenSuccess', 0, ()=>{
    let name: string = specificSession.getName();
    expect(name).assertEqual(`persistentId: ${specificSession.session.persistentId}`);
  })
}

function setParentSessionRegisterTest() {
  it('test_setParentSession_registerCallback', 0, ()=>{
    specificSession.registerSetParentSessionCallback(()=>{});
    expect(specificSession.sessionData.setParentSessionCallback).not().assertNull();

    specificSession.registerRaiseToTopCallback(()=>{});
    expect(specificSession.sessionData.raiseToTopCallback).not().assertNull();

    specificSession.registerRaiseAboveTargetCallback(()=>{});
    expect(specificSession.sessionData.raiseAboveTargetCallback).not().assertNull();

    specificSession.registerStateChangeCallback(()=>{});
    expect(specificSession.sessionData.stateChangeCallback).not().assertNull();

    specificSession.registerSubSessionRaiseToTopCallback(()=>{});
    expect(specificSession.sessionData.subSessionRaiseToTopCallback).not().assertNull();

    specificSession.registerSubSessionRaiseAboveTargetCallback(()=>{});
    expect(specificSession.sessionData.subSessionRaiseAboveTargetCallback).not().assertNull();

    specificSession.registerSubSessionStateChangeCallback(()=>{});
    expect(specificSession.registerSubSessionStateChangeCallback).not().assertNull();
  })

  it('test_setParentSession_get_registerCallback', 0, ()=>{
    let callback = () => {};
    specificSession.registerSubSessionRaiseToTopCallback(callback);
    expect(specificSession.getSubSessionRaiseToTopCallback()).assertEqual(callback);

    specificSession.registerSubSessionRaiseAboveTargetCallback(callback);
    expect(specificSession.getSubSessionRaiseAboveTargetCallback()).assertEqual(callback);

    specificSession.registerSubSessionStateChangeCallback(callback);
    expect(specificSession.getSubSessionStateChangeCallback()).assertEqual(callback);
  })
}

function subWindowAppModalTypeTest() {
  it('test_subWindowAppModalType', 0, ()=>{
    specificSession.session.subWindowAppModalType = sceneSessionManager.SubWindowModalType.TYPE_NORMAL;
    expect(specificSession.isModal()).assertEqual(false);
    expect(specificSession.isModalApplication()).assertEqual(false);

    specificSession.session.subWindowAppModalType = sceneSessionManager.SubWindowModalType.TYPE_TEXT_MENU;
    expect(specificSession.isModal()).assertEqual(false);
    expect(specificSession.isModalApplication()).assertEqual(false);

    specificSession.session.subWindowAppModalType = sceneSessionManager.SubWindowModalType.TYPE_TOAST;
    expect(specificSession.isModal()).assertEqual(false);
    expect(specificSession.isModalApplication()).assertEqual(false);

    specificSession.session.subWindowAppModalType = sceneSessionManager.SubWindowModalType.TYPE_DIALOG;
    expect(specificSession.isModal()).assertEqual(true);
    expect(specificSession.isModalApplication()).assertEqual(false);

    specificSession.session.subWindowAppModalType = sceneSessionManager.SubWindowModalType.TYPE_WINDOW_MODALITY;
    expect(specificSession.isModal()).assertEqual(true);
    expect(specificSession.isModalApplication()).assertEqual(false);

    specificSession.session.subWindowAppModalType = sceneSessionManager.SubWindowModalType.TYPE_APPLICATION_MODALITY;
    expect(specificSession.isModal()).assertEqual(true);
    expect(specificSession.isModalApplication()).assertEqual(true);
  })
}

function registerSessionStateChangeCallbackTest() {
  it('test_registerSessionStateChangeCallback_01', 0, () => {
    let testA = 10;
    let testCallback =
      (parentId: number, persistentId: number, state: sceneSessionManager.SessionState, zIndex: number) => {
        testA = 20;
      };
    specificSession.registerSessionStateChangeCallback(testCallback);
    expect(testA).assertEqual(10);
    specificSession.sessionData.needUpdateSubSessionState = true;
    specificSession.registerSessionStateChangeCallback(testCallback);
    expect(testA).assertEqual(20);
  });
  it('test_registerSessionStateChangeCallback_02', 0, () => {
    specificSession.registerSessionStateChangeCallback(nullCallback);
    let callback: Function = Reflect.get(specificSession.sessionData, 'stateChangeCallback');
    expect(callback !== nullCallback).assertTrue();
  });
}

function unregisterSessionStateChangeCallbackTest() {
  it('test_unregisterSessionStateChangeCallback_01', 0, () => {
    let testCallback = () => {};
    Reflect.set(specificSession.sessionData, 'stateChangeCallback', testCallback);
    specificSession.unregisterSessionStateChangeCallback(testCallback);
    let callback: Function = Reflect.get(specificSession.sessionData, 'stateChangeCallback');
    expect(callback).assertNull();
  });
  it('test_unregisterSessionStateChangeCallback_02', 0, () => {
    let testCallback1 = () => {};
    let testCallback2 = () => {};
    Reflect.set(specificSession.sessionData, 'stateChangeCallback', testCallback1);
    specificSession.unregisterSessionStateChangeCallback(testCallback2);
    let callback: Function = Reflect.get(specificSession.sessionData, 'stateChangeCallback');
    expect(callback === testCallback1).assertTrue();
  });
}

function subWindowRectTest() {
  it('test_setWindowLastSafeRect', 0, () => {
    specificSession.setWindowLastSafeRect(0, 0, 500, 500);
  });
  it('test_saveLastRect', 0, () => {
    specificSession.saveLastRect();
  });
}

function subWindowGetOutlineTest() {
  it('test_getoutline', 0, () => {
    let outline: OutlineOptions = {
      width: 0,
      color: '#00000000'
    }
    specificSession.session.subWindowOutlineEnabled = false;
    outline = specificSession.getOutline();
    expect(outline.width).assertEqual(0);
    expect(outline.color).assertEqual('#00000000');

    specificSession.session.subWindowOutlineEnabled = true;
    const mainSession: SCBSceneSession | null =
      SCBSceneSessionManager.getInstance().findMainSessionById(specificSession.session.persistentId);
    if (mainSession) {
      outline = specificSession.getOutline();
      expect(outline.width).assertEqual(px2vp(mainSession.strokeConfig.outlineWidth));
      expect(outline.color).assertEqual(mainSession.strokeConfig.outlineColor);
    } else {
      expect(outline.width).assertEqual(0);
      expect(outline.color).assertEqual('#00000000');
    }
  });
}

function registerSessionRectChangeRelativeParentCallbackTest() {
  it('test_registerSessionRectChangeRelativeParentCallback', 0, () => {
    let testCallback = () => {
    };
    let beforeLength: number = specificSession.sessionRectChangeRelativeParentCallbackMap.size;
    specificSession.registerSessionRectChangeRelativeParentCallback(testCallback, 0);
    expect(beforeLength).assertEqual(specificSession.sessionRectChangeRelativeParentCallbackMap.size - 1);
  });
}

function unregisterSessionRectChangeRelativeParentCallbackTest() {
  it('test_unregisterSessionRectChangeRelativeParentCallback', 0, () => {
    let testCallback = () => {
    };
    specificSession.registerSessionRectChangeRelativeParentCallback(testCallback, 0);
    specificSession.unregisterSessionRectChangeRelativeParentCallback(0);
    let callback: Function | undefined = specificSession.sessionRectChangeRelativeParentCallbackMap.get(0);
    expect(callback === undefined).assertTrue();
  });
}