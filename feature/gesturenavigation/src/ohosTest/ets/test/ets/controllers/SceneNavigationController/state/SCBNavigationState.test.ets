/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  Size,
  TestType
} from '@ohos/hypium';
import {
  SCBBaseNavigationState
} from '../../../../../../../main/ets/controllers/SceneNavigationController/state/SCBNavigationState';

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

let scbBaseNavigationState = new SCBBaseNavigationState(2774);

export default function SCBNavigationStateTest() {
  describe('SCBNavigationStateTest', () => {
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

    it('SCBNavigationStateTest_setPreEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationState.preEvent = event;
      expect(scbBaseNavigationState.setPreEvent(event) === undefined).assertTrue();
    })

    it('SCBNavigationStateTest_consumeUpdateEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationState.preEvent = event;
      expect(scbBaseNavigationState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_consumeUpdateEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(scbBaseNavigationState.consumeUpdateEvent(event) === scbBaseNavigationState).assertTrue();
    })

    it('SCBNavigationStateTest_consumeEndEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationState.preEvent = event;
      expect(scbBaseNavigationState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_consumeEndEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(scbBaseNavigationState.consumeEndEvent(event) === scbBaseNavigationState).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationState.preEvent = undefined;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event)).assertEqual(0);
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationState.preEvent = event;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_1', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_2', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_3', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_4', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_5', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_6', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_7', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_8', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_9', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_10', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_11', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_12', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_13', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_14', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_15', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_16', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_17', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_18', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_19', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_20', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_21', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_22', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_23', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_24', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_25', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_26', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_27', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_28', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_29', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_30', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_31', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_32', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_33', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_34', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })

    it('SCBNavigationStateTest_calcSpeedAndAcc_co_35', 0, (): void => {
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

      scbBaseNavigationState.preEvent = event;
      scbBaseNavigationState.preEvent.offsetY = -5;
      expect(scbBaseNavigationState.calcSpeedAndAcc(event) !== undefined).assertTrue();
    })
  })
}