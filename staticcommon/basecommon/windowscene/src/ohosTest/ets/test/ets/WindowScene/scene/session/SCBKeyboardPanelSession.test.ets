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
  SCBKeyboardPanelSession,
  SCBSceneInfo,
  SystemSessionInfo,
  SmartMenuItem,
  SCBKeyboardManager,
  SmartMenu,
} from '../../../../../../../..';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { image } from '@kit.ImageKit';

interface ISCBKeyboardPanelSession {
  setVisibility(visibility: boolean): void;
}

let keyboardPanelSession: SCBKeyboardPanelSession;
let iKeyboardPanelSession: ISCBKeyboardPanelSession;

export function SCBKeyboardPanelSessionTest() {
  describe('SCBKeyboardPanelSessionTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
        sceneName: 'SCBGestureBackViewModelTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        // sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
        isOverlayScene: true,
      };
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      keyboardPanelSession =
        new SCBKeyboardPanelSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo);
      iKeyboardPanelSession = (keyboardPanelSession as object as ISCBKeyboardPanelSession);
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    setVisibilityTest();
  })
}

function setVisibilityTest() {
  it('setVisilibity', 0, () => {
    keyboardPanelSession.setVisibility(true);
    expect(keyboardPanelSession.visibility).assertTrue();

    keyboardPanelSession.setVisibility(false);
    expect(keyboardPanelSession.visibility).assertFalse();
  })
}