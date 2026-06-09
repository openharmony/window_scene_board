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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { SCBSplitManager } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBSplitManager';
import {
  enableShowInputMethodForSplit,
  ifHasShowInputMethodForSplit,
  ifCallingWindowIdMatched,
  SCBInputMethodHelper
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBInputMethodHelper';
import {
  KeyboardChangeCallback,
  SCBDividerParam,
  SCBKeyboardManager,
  SCBKeyboardPanelSession,
  SCBKeyboardSession,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  SplitStyle} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';

let splitManagerTmp = SCBSplitManager.getInstance();
let screenPropertyTmp: SCBScreenProperty = new SCBScreenProperty();
let sceneInfoTmp: SCBSceneInfo;
let keyboardSessionTmp: SCBKeyboardSession;
let keyboardPanelSessionTmp: SCBKeyboardPanelSession;
let keyboardSceneInfoTmp: SCBSceneInfo;
let containerSessionTmp: SCBSceneContainerSession;
let inputMethodHelperTmp: SCBInputMethodHelper;
let secSceneInfoTmp: SCBSceneInfo;
let primSessionTmp: SCBSceneSession;
let secondarySessionTmp: SCBSceneSession;
let assertFlag = true;

let initTestInfo = () => {
  sceneInfoTmp = new SCBSceneInfo('testPriBundle_bundle', 'testPriModule_module', 'testPriAbility_ability');
  secSceneInfoTmp = new SCBSceneInfo('testSecBundle_bundle', 'testSecModule_module', 'testSecAbility_ability');
  primSessionTmp = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoTmp), sceneInfoTmp);
  secondarySessionTmp = new SCBSceneSession(sceneSessionManager.requestSceneSession(secSceneInfoTmp), secSceneInfoTmp);
  containerSessionTmp = new SCBSceneContainerSession(primSessionTmp, screenPropertyTmp);
  containerSessionTmp.dividerParam = new SCBDividerParam();
  containerSessionTmp.addSceneSession(secondarySessionTmp);
  containerSessionTmp.initAll();
  inputMethodHelperTmp = new SCBInputMethodHelper();
  keyboardSceneInfoTmp = new SCBSceneInfo('testKeyboardBundle_bundle', 'testKeyboardModule_module', 'testKeyboardAbility_ability');
  let keyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();
  let keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();
  keyboardSessionTmp = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfoTmp),
    () => {}, keyboardChangeCallbackMap, keyboardChangeListenerList);
  keyboardPanelSessionTmp = SCBKeyboardManager.getInstance().getPanelSession();
}

export function SCBInputMethodHelperTest() {

  describe('SCBInputMethodHelperTest_describe', () => {
    beforeAll(() => {
      initTestInfo();
      inputMethodHelperTmp.init(containerSessionTmp);
    })

    afterAll((): void => {})

    beforeEach((): void => {
    })

    afterEach((): void => {})

    it('inputShowCallbackTest_it', Level.LEVEL0, (): void => {
      keyboardSessionTmp.sessionData.sessionState = sceneSessionManager.SessionState.STATE_ACTIVE;
      containerSessionTmp.isSplit = true;
      containerSessionTmp.removeSceneSession(secondarySessionTmp);
      expect(assertFlag).assertTrue();
      SCBKeyboardManager.getInstance().getKeyboardSession()?.setCallingSessionId(primSessionTmp.sceneInfo.persistentId);
      inputMethodHelperTmp.inputShowCallback(keyboardSessionTmp);
      expect(assertFlag).assertTrue();

      containerSessionTmp.addSceneSession(secondarySessionTmp);
      keyboardSessionTmp.sessionData.sessionState = sceneSessionManager.SessionState.STATE_FOREGROUND;
      keyboardSessionTmp.sessionGravity = sceneSessionManager.KeyboardGravity.GRAVITY_DEFAULT;
      containerSessionTmp.dividerParam.setSplitStyle(SplitStyle.UP_AND_DOWN_POS);
      expect(assertFlag).assertTrue();
      containerSessionTmp.dividerParam.setIsVertical(true);
      inputMethodHelperTmp.inputShowCallback(keyboardSessionTmp);
      expect(containerSessionTmp.splitParam.hasAvoidInputMethod).assertFalse();

      containerSessionTmp.dividerParam.setSplitStyle(SplitStyle.LEFT_AND_RIGHT_POS);
      inputMethodHelperTmp.inputShowCallback(keyboardSessionTmp);
      expect(containerSessionTmp.splitParam.hasAvoidInputMethod).assertFalse();
    });

    it('ifCallingWindowIdMatchedTest_it', Level.LEVEL0, (): void => {
      expect(ifCallingWindowIdMatched(containerSessionTmp)).assertFalse();
      let keyboardSession: SCBKeyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
      if (keyboardSession) {
        keyboardSession.setCallingSessionId(primSessionTmp.session.persistentId);
        expect(ifCallingWindowIdMatched(containerSessionTmp)).assertTrue();
        keyboardSession.setCallingSessionId(secondarySessionTmp.session.persistentId);
        expect(ifCallingWindowIdMatched(containerSessionTmp)).assertTrue();
      }
    });

    it('enableShowInputMethodForSplitTest_it', Level.LEVEL0, (): void => {
      containerSessionTmp.isKeyboardEnableShow = false;
      expect(enableShowInputMethodForSplit(containerSessionTmp, containerSessionTmp.splitParam)).assertFalse();
    });

    it('ifHasShowInputMethodForSplitTest_it', Level.LEVEL0, (): void => {
      containerSessionTmp.isKeyboardEnableShow = false;
      expect(ifHasShowInputMethodForSplit(containerSessionTmp)).assertFalse();
    });

    it('keyboardChangeCallbackTest_it', Level.LEVEL0, (): void => {
      let sessionRect: sceneSessionManager.SessionRect = {
        posX_: 1,
        posY_: 1,
        width_: 120,
        height_: 120
      };
      inputMethodHelperTmp.keyboardChangeCallback.onRectChangeChange(
        sessionRect, sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
      inputMethodHelperTmp.keyboardChangeCallback.onRectChangeChange(
        sessionRect, sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
      inputMethodHelperTmp.keyboardChangeCallback.onSessionTouchableChange(true);
      expect(assertFlag).assertTrue();
      inputMethodHelperTmp.keyboardChangeCallback.onKeyboardGravityChange(
        sceneSessionManager.KeyboardGravity.GRAVITY_FLOAT);
      inputMethodHelperTmp.keyboardChangeCallback.onCustomAnimationPlaying(true);
      inputMethodHelperTmp.keyboardChangeCallback.onForceHide(true);
      expect(assertFlag).assertTrue();
      inputMethodHelperTmp.keyboardChangeCallback.getZIndex();
      inputMethodHelperTmp.keyboardChangeCallback.onVirtualScreenStateChange(screenPropertyTmp.screenId,
        sceneInfoTmp.persistentId, sceneSessionManager.SessionState.STATE_DISCONNECT);
      inputMethodHelperTmp.keyboardChangeCallback.onCallingSessionChange(primSessionTmp.sceneInfo.persistentId);
      expect(assertFlag).assertTrue();
    });

  });
}