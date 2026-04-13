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
  SCBNavigationFromRecentCallback
} from '../../../../../../../main/ets/controllers/SceneNavigationController/interface/SCBNavigationCallback';
import {
  SCBBaseNavigationFromRecentState,
  SCBNavigationFromRecentIdleState
} from '../../../../../../../main/ets/controllers/SceneNavigationController/state/SCBNavigationFromRecentState';
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

let callback: SCBNavigationFromRecentCallback = {
  onExitRecent: () => {
  }
}

let scbBaseNavigationFromRecentState = new SCBBaseNavigationFromRecentState(2774);
let scbNavigationFromRecentIdleState = new SCBNavigationFromRecentIdleState(2774);
let scbBaseNavigationState = new SCBBaseNavigationState(2774);

export default function SCBNavigationFromRecentStateTest() {
  describe('SCBNavigationFromRecentStateTest', () => {
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

    it('SCBNavigationFromRecentIdleState_consumeUpdateEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromRecentState.callback = undefined;
      expect(scbNavigationFromRecentIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeUpdateEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    // false || false
    it('SCBNavigationFromRecentIdleState_consumeEndEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 100;
      scbBaseNavigationState.curSpeed = 1;
      scbBaseNavigationFromRecentState.callback = undefined;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    // false || true
    it('SCBNavigationFromRecentIdleState_consumeEndEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = 1;
      scbBaseNavigationFromRecentState.callback = undefined;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    // true || true
    it('SCBNavigationFromRecentIdleState_consumeEndEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationState.curSpeed = -1;
      event.offsetY = 1000;
      scbBaseNavigationFromRecentState.callback = undefined;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    // false || false
    it('SCBNavigationFromRecentIdleState_consumeEndEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 100;
      scbBaseNavigationState.curSpeed = 1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    // false || true
    it('SCBNavigationFromRecentIdleState_consumeEndEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = 1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    // true || true
    it('SCBNavigationFromRecentIdleState_consumeEndEvent_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_1', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_2', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_3', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_4', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_5', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_6', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_7', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_8', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_9', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_10', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_11', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromRecentIdleState_consumeEndEvent_co_12', 0, (): void => {
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
      event.offsetY = 1000;
      scbBaseNavigationState.curSpeed = -1;
      scbBaseNavigationFromRecentState.callback = callback;
      expect(scbNavigationFromRecentIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

  })
}