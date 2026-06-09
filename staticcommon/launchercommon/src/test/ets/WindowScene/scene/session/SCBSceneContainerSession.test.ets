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
import {
  RectInfo,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';

const DEFAULT: number = 0;

export function SCBSceneContainerSessionTest() {

  let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();

  describe('SCBSceneContainerSessionTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('isOneStepSplitTest', DEFAULT, () => {
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);

      let secSceneInfo: SCBSceneInfo = new SCBSceneInfo('testSecBundle', 'testSecModule', 'testSecAbility');
      let secSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(secSceneInfo), secSceneInfo);

      let screenProperty: SCBScreenProperty = new SCBScreenProperty();

      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
      containerSession.isSplit = true;
      expect(containerSession.isOneStepSplit()).assertTrue();

      containerSession.addSceneSession(secSceneSession);
      expect(containerSession.isOneStepSplit()).assertFalse();

      containerSession.isSplit = false;
      expect(containerSession.isOneStepSplit()).assertFalse();
    })
    it('isSplitViewTest', DEFAULT, () => {
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
      containerSession.isSplit = false;
      expect(containerSession.isSplitView()).assertFalse();

      containerSession.isSplit = true;
      expect(containerSession.isSplitView()).assertFalse();
      let secSceneInfo: SCBSceneInfo = new SCBSceneInfo('testSecBundle', 'testSecModule', 'testSecAbility');
      let secSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(secSceneInfo), secSceneInfo);
      containerSession.addSceneSession(secSceneSession);
      expect(containerSession.isSplitView()).assertTrue();
    })
    it('processOrientationRelatedToSplit', DEFAULT, () => {
      let sensorRotation: number = 270;
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
      containerSession.isSplit = false;
      expect(containerSession.processOrientationRelatedToSplit(sensorRotation)).assertEqual(undefined);
    })
    it("init", DEFAULT, () => {
      containerSession.init();
      expect(containerSession.isDisappearing).assertEqual(false);
    })
    it('onTransitionActiveToRect', DEFAULT, () => {
      let iconRectinfo: RectInfo = new RectInfo();
      containerSession.companionIconInfo.iconId='';
      containerSession.onTransitionActiveToRect(iconRectinfo);
    })
  })
}