/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
  KeyboardChangeCallback,
  SCBKeyboardSession,
  SCBKeyboardManager,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSpecificSession,
  SCBSystemSceneSession,
  SystemSessionInfo,
} from '../../../../../../../..';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ReflectionUtils } from './ReflectionUtils';

let keyboardSession: SCBKeyboardSession;
let scbSceneSession: SCBSceneSession;
let specificSceneSession: SCBSpecificSession;
let systemSceneSession: SCBSystemSceneSession;

export default function SCBKeyboardManagerTest() {
  describe('SCBKeyboardManagerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      // create keyboardSession
      let keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();
      let keyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      keyboardSession = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfo), () => {
      }, keyboardChangeCallbackMap, keyboardChangeListenerList);

      // create scbSceneSession
      scbSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      // create specificSceneSession
      let stateChangeCallback = (parentId: number, persistentId: number,
        state: sceneSessionManager.SessionState): void => {
        if (typeof parentId !== 'number') {
          return;
        }
      };
      specificSceneSession = new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo),
        stateChangeCallback);

      // create systemSceneSession
      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
        sceneName: 'SCBKeyboardManagerTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        isOverlayScene: true,
      };
      systemSceneSession = new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo),
        systemSessionInfo, undefined);
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    onKeyboardStateChangeForPCTest();
  })
}

function onKeyboardStateChangeForPCTest() {
  it('onKeyboardStateChangeForPC', 0, () => {
    keyboardSession.setCallingSession(scbSceneSession);
    ReflectionUtils.useFunc(SCBKeyboardManager.getInstance(), 'onKeyboardStateChangeForPC', 0, keyboardSession.session.persistentId,
      sceneSessionManager.SessionState.STATE_FOREGROUND, false);
    expect(keyboardSession.screenId).assertEqual(scbSceneSession.sceneInfo.screenId);

    keyboardSession.setCallingSession(specificSceneSession);
    ReflectionUtils.useFunc(SCBKeyboardManager.getInstance(), 'onKeyboardStateChangeForPC', 0, keyboardSession.session.persistentId,
      sceneSessionManager.SessionState.STATE_FOREGROUND, false);
    expect(keyboardSession.screenId).assertEqual(specificSceneSession.screenId);

    keyboardSession.setCallingSession(systemSceneSession);
    ReflectionUtils.useFunc(SCBKeyboardManager.getInstance(), 'onKeyboardStateChangeForPC', 0, keyboardSession.session.persistentId,
      sceneSessionManager.SessionState.STATE_FOREGROUND, false);
    expect(keyboardSession.screenId).assertEqual(systemSceneSession.session.screenId);
  });
}
