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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, TestType, Size, Level } from '@ohos/hypium';
import {
  GestureHelper,
  gestureHelperInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';


let eventArea: Area = {
  width: 0,
  height: 0,
  position: { x: 0, y: 0 },
  globalPosition: { x: 0, y: 0 }
};

let eventTarget: EventTarget = {
  area: eventArea
};

let event: GestureEvent = {
  target: eventTarget,
  timestamp: 0,
  source: 0,
  pressure: 0,
  tiltX: 0,
  tiltY: 0,
  sourceTool: 0,
  repeat: false,
  fingerList: [],
  offsetX: 0,
  offsetY: 0,
  angle: 0,
  speed: 0,
  scale: 0,
  pinchCenterX: 0,
  pinchCenterY: 0,
  velocityX: 0,
  velocityY: 0,
  velocity: 0
};

export default function GestureHelperTest() {
  describe('GestureHelperTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll((): void => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach((): void => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach((): void => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll((): void => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })


    it('GestureHelperTest_isNearlyUpForward', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -100;
      GestureHelper.isNearlyUpForward(event);
      expect(true).assertTrue();
    })

    it('GestureHelperTest_isNearlyDownForward', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 100;
      GestureHelper.isNearlyDownForward(event);
      expect(true).assertTrue();
    })


    it('GestureHelperTest_isNearlyRightForward', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetX = 100;
      GestureHelper.isNearlyRightForward(event);
      expect(true).assertTrue();
    })


    it('GestureHelperTest_isNearlyLeftForward', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetX = -100;
      GestureHelper.isNearlyLeftForward(event);
      expect(true).assertTrue();
    })


    it('GestureHelperTest_invoke', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let gestureHelper =  new GestureHelper();
      gestureHelper.reset();
      expect(true).assertTrue();
      try {
        gestureHelper.invoke(event);
      } catch (e) {
        expect(false).assertFail();
      }

      try {
        gestureHelper.invoke(event);
      } catch (e) {
        expect(false).assertFail();
      }


      try {
        event  = {
          target: eventTarget,
          timestamp: Date.now(),
          source: 0,
          pressure: 0,
          tiltX: 0,
          tiltY: 0,
          sourceTool: 0,
          repeat: false,
          fingerList: [],
          offsetX: 0,
          offsetY: 0,
          angle: 0,
          speed: 0,
          scale: 0,
          pinchCenterX: 0,
          pinchCenterY: 0,
          velocityX: 0,
          velocityY: 0,
          velocity: 0
        };
        gestureHelper.invoke(event);
      } catch (e) {
        expect(false).assertFail();
      }

      try {
        gestureHelper.speedScalar = 1;
        gestureHelper.invoke(event);
      } catch (e) {
        expect(false).assertFail();
      }
    })

  })
}