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

import { describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect } from '@ohos/hypium';
import { ThreeFingerSwipeEvent } from '@ohos/pcbase/src/main/ets/common/ThreeFingerSwipeEvent';

export default function ThreeFingerSwipeEventTest() {
  describe('ThreeFingerSwipeEventTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('trySetX', 0, () => {
      try {
        let threeFingerSwipeEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        threeFingerSwipeEvent.set(8, 8, 8);
        expect(threeFingerSwipeEvent.x).assertEqual(8);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('trySetStamp', 0, () => {
      try {
        let threeFingerSwipeEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        threeFingerSwipeEvent.set(8, 8, 8);
        expect(threeFingerSwipeEvent.timestamp).assertEqual(8);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('trySetY', 0, () => {
      try {
        let threeFingerSwipeEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        threeFingerSwipeEvent.set(8, 8, 8);
        expect(threeFingerSwipeEvent.y).assertEqual(8);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('clone3', 0, () => {
      try {
        let threeFingerSwipeEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        let cloneTarget3: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        cloneTarget3.timestamp = 9;
        threeFingerSwipeEvent.clone(cloneTarget3);
        expect(threeFingerSwipeEvent.timestamp).assertEqual(9);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('timestamp', 0, () => {
      try {
        let threeFingerSwipeEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        let timestamp: number = threeFingerSwipeEvent.timestamp;
        expect(timestamp).assertEqual(0);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('clone2', 0, () => {
      try {
        let threeFingerSwipeEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        let cloneTarget2: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        cloneTarget2.y = 9;
        threeFingerSwipeEvent.clone(cloneTarget2);
        expect(threeFingerSwipeEvent.y).assertEqual(9);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('clone1', 0, () => {
      try {
        let threeFingerSwipeEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        let cloneTarget: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        cloneTarget.x = 9;
        threeFingerSwipeEvent.clone(cloneTarget);
        expect(threeFingerSwipeEvent.x).assertEqual(9);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('reset', 0, () => {
      try {
        let threeFingerSwipeEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        threeFingerSwipeEvent.set(8, 8, 8);
        threeFingerSwipeEvent.reset();
        expect(threeFingerSwipeEvent.timestamp).assertEqual(0);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('defaultY', 0, () => {
      try {
        let threeFingerSwipeEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        let theY: number = threeFingerSwipeEvent.y;
        expect(theY).assertEqual(-1);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('defaultX', 0, () => {
      try {
        let threeFingerSwipeEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
        let theX: number = threeFingerSwipeEvent.x;
        expect(theX).assertEqual(-1);
      } catch (e) {
        expect(false).assertFail();
      }
    })
  })
}