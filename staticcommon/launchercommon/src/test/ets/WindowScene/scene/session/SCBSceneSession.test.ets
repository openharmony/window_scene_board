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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSceneInfo, SCBSceneMode, SCBSceneSession } from '@ohos/windowscene';

const DEFAULT: number = 0;

export function SCBSceneSessionTest() {

  describe('SCBSceneSessionTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterEach((): void => {
    })
    afterAll((): void => {
    })

    it('isSupportSplitModeTest', DEFAULT, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(sceneSession.isSupportSplitMode()).assertTrue();
    })

    it('isSupportFloatingModeTest', DEFAULT, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(sceneSession.isSupportFloatingMode()).assertTrue();
    })

    it('updateWindowModeTest', DEFAULT, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
      expect(sceneSession.sceneInfo.windowMode).assertEqual(SCBSceneMode.PRIMARY);
    })

    it('updateFloatingScaleTest', DEFAULT, () => {
      const setScale: number = 0.6;
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.updateFloatingScale(setScale);
      expect(sceneSession.floatingParam.floatingSceneScale).assertEqual(setScale);
    })

    it('requestBackgroundOfFloating', DEFAULT, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.session.requestBackgroundOfFloating();
      expect(scbSceneSession.isActive).assertEqual(false);
    })

    it('initFloatingSceneOnTransferSessionTest', DEFAULT, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 100;
      scbSceneSession.initFloatingSceneOnTransferSession(screenProperty);
      expect(scbSceneSession.floatingParam.floatingSceneScale).assertEqual(1);
      expect(scbSceneSession.floatingSceneScale).assertEqual(1);
      expect(scbSceneSession.floatBorderRadius).assertEqual(0);
      expect(scbSceneSession.translateX).assertEqual(0);
      expect(scbSceneSession.translateY).assertEqual(0);
      expect(scbSceneSession.positionX.getPx()).assertEqual(0);
      expect(scbSceneSession.positionY.getPx()).assertEqual(0);
      expect(scbSceneSession.width.getPx()).assertEqual(100);
      expect(scbSceneSession.height.getPx()).assertEqual(100);
      expect(scbSceneSession.floatBorderWidth).assertEqual(0);
      expect(scbSceneSession.floatingParam.borderWidth).assertEqual(0);
      expect(scbSceneSession.opacity).assertEqual(1);
      expect(scbSceneSession.scaleX).assertEqual(1);
      expect(scbSceneSession.scaleY).assertEqual(1);
      expect(scbSceneSession.sceneInfo.windowMode).assertEqual(SCBSceneMode.FULLSCREEN);
    })

    it('setShowRecent', DEFAULT, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.session.setShowRecent();
      scbSceneSession.session.setShowRecent(false);
      scbSceneSession.session.setShowRecent(true);
    })

    it('processBackEvent', DEFAULT, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.requestSessionActivation();
      sceneSessionManager.processBackEvent();
    })

    it('setScale', DEFAULT, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.session.setScale(1.0, 1.0, 0.0, 0.0);
    })

    it('requestHideKeyboard', DEFAULT, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.session.requestHideKeyboard();
    })
  })
}