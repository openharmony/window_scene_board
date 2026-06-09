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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, TestType, Size, Level, expect, MockKit } from '@ohos/hypium'
import { SCBSceneSessionManager, SystemSessionInfo } from '@ohos/windowscene';

export function SCBSystemSceneSessionTest() {
  describe('SCBSystemSceneSessionTest', () => {
    beforeAll(() => {});
    beforeEach(() => {});
    afterEach(() => {});
    afterAll(() => {});

    it('touchOutsideCallback', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let sessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_PANEL,
        sceneName: 'test',
        sceneZIndex: 0,
        hitTestMode: HitTestMode.Default
      };
      let systemSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(sessionInfo);
      // test point
      let touchX = -1;
      let touchY = -1;
      let firstPointX = 123;
      let firstPointY = 456;
      let secondPointX = 1234;
      let secondPointY = 5678;
      systemSceneSession.registerTouchOutsideCallback((x,y) => {
        touchX = x;
        touchY = y;
      });
      systemSceneSession.notifyTouchOutside(firstPointX, firstPointY);
      // register touchOutsideCallback then notify, touch point change
      expect(touchX).assertEqual(firstPointX);
      expect(touchY).assertEqual(firstPointY);
      systemSceneSession.unregisterTouchOutsideCallback();
      systemSceneSession.notifyTouchOutside(secondPointX, secondPointY);
      // unregister touchOutsideCallback then notify, touch point not change
      expect(touchX).assertEqual(firstPointX);
      expect(touchY).assertEqual(firstPointY);
    });

    it('rotateChangeCallback', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let sessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_PANEL,
        sceneName: 'test',
        sceneZIndex: 0,
        hitTestMode: HitTestMode.Default,
        isRotatable: true,
      };
      let systemSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(sessionInfo);
      // test point
      let angle = -1;
      let firstAngle = 123;
      let secondAngle = 1234;
      systemSceneSession.registerRotateChangeCallback((ang) => {
        angle = ang;
      });
      systemSceneSession.notifyRotateChange(firstAngle);
      // register rotateChangeCallback then notify, angle change
      expect(angle).assertEqual(firstAngle);
      systemSceneSession.unregisterRotateChangeCallback();
      systemSceneSession.notifyRotateChange(secondAngle);
      // unregister rotateChangeCallback then notify, angle not change
      expect(angle).assertEqual(secondAngle);
    });
  })
}