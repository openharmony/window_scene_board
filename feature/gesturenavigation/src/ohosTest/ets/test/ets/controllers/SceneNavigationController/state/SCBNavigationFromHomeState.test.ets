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
  SCBNavigationFromHomeCallback
} from '../../../../../../../main/ets/controllers/SceneNavigationController/interface/SCBNavigationCallback';
import {
  NavigationFromHomeRecentState,
  SCBBaseNavigationFromHomeState,
  SCBNavigationFromHomeIdleState
} from '../../../../../../../main/ets/controllers/SceneNavigationController/state/SCBNavigationFromHomeState';
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

let callback: SCBNavigationFromHomeCallback = {
  onEnterFirstHomePage: () => {
  },
  onEnterHome: () => {
  },
  onEnterRecent: (follow: boolean, offsetX: number, offsetY: number) => {
  },
  onUpdateRecent: (offsetX: number, offsetY: number) => {
  },
  onExitRecent: () => {
  },
  onUpdateScaleDesktop: (offsetY: number) => {
  },
  onEnterSwitch: (follow: boolean, offsetX: number, offsetY: number) => {
  },
  onUpdateSwitch: (offsetX: number, offsetY: number) => {
  },
  onExitSwitch: () => {
  }
}

let scbNavigationFromHomeIdleState = new SCBNavigationFromHomeIdleState(2774);
let scbBaseNavigationFromHomeState = new SCBBaseNavigationFromHomeState(2774);
let navigationFromHomeRecentState = new NavigationFromHomeRecentState(2774);
let scbBaseNavigationState = new SCBBaseNavigationState(2774);

export default function SCBNavigationFromHomeStateTest() {
  describe('SCBNavigationFromHomeStateTest', () => {
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

    it('SCBBaseNavigationFromHomeState_setCallback_1', 0, (): void => {
      expect(scbBaseNavigationFromHomeState.setCallback(callback) === undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeUpdateEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      expect(scbNavigationFromHomeIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeUpdateEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbBaseNavigationFromHomeState.callback = undefined;
      expect(scbNavigationFromHomeIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeUpdateEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbBaseNavigationFromHomeState.callback = callback;
      expect(scbNavigationFromHomeIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeUpdateEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -400;
      scbNavigationFromHomeIdleState.curSpeed = 1;
      scbBaseNavigationFromHomeState.callback = undefined;
      expect(scbNavigationFromHomeIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeUpdateEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -400;
      scbNavigationFromHomeIdleState.curSpeed = 1;
      scbBaseNavigationFromHomeState.callback = callback;
      expect(scbNavigationFromHomeIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeUpdateEvent_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -400;
      scbNavigationFromHomeIdleState.preEvent = undefined;
      scbNavigationFromHomeIdleState.curSpeed = 1;
      scbBaseNavigationFromHomeState.callback = callback;
      expect(scbNavigationFromHomeIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeUpdateEvent_7', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -400;
      scbNavigationFromHomeIdleState.preEvent = undefined;
      scbNavigationFromHomeIdleState.curSpeed = 1;
      scbBaseNavigationFromHomeState.callback = undefined;
      expect(scbNavigationFromHomeIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeUpdateEvent_8', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -400;
      scbNavigationFromHomeIdleState.curSpeed = -1;
      expect(scbNavigationFromHomeIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeEndEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      expect(scbNavigationFromHomeIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeEndEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      let isFromRecentState = false;
      scbBaseNavigationFromHomeState.callback = undefined;
      expect(scbNavigationFromHomeIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeEndEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      let isFromRecentState = false;
      scbBaseNavigationFromHomeState.callback = callback;
      expect(scbNavigationFromHomeIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeEndEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      let isFromRecentState = true;
      scbBaseNavigationFromHomeState.callback = undefined;
      expect(scbNavigationFromHomeIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_consumeEndEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      let isFromRecentState = true;
      scbBaseNavigationFromHomeState.callback = callback;
      expect(scbNavigationFromHomeIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_isHomeFirstPageShowOfDistanceLimit_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -138;
      expect((scbNavigationFromHomeIdleState as object)['isHomeFirstPageShowOfDistanceLimit'](event.offsetY)).assertFalse();
    })

    it('SCBNavigationFromHomeIdleState_isHomeFirstPageShowOfDistanceLimit_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -139;
      expect((scbNavigationFromHomeIdleState as object)['isHomeFirstPageShowOfDistanceLimit'](event.offsetY)).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_isHomeFirstPageShowOfSpeedLimit_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let speed = -2;
      expect((scbNavigationFromHomeIdleState as object)['isHomeFirstPageShowOfSpeedLimit'](speed)).assertTrue();
    })

    it('SCBNavigationFromHomeIdleState_isHomeFirstPageShowOfSpeedLimit_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let speed = -0.1;
      expect((scbNavigationFromHomeIdleState as object)['isHomeFirstPageShowOfSpeedLimit'](speed)).assertFalse();
    })

    it('NavigationFromHomeRecentState_consumeUpdateEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      expect(navigationFromHomeRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('NavigationFromHomeRecentState_consumeUpdateEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1000;
      scbBaseNavigationFromHomeState.callback = undefined;
      expect(navigationFromHomeRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('NavigationFromHomeRecentState_consumeUpdateEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1000;
      scbBaseNavigationFromHomeState.callback = callback;
      expect(navigationFromHomeRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('NavigationFromHomeRecentState_consumeUpdateEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -100;
      scbBaseNavigationFromHomeState.callback = undefined;
      expect(navigationFromHomeRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('NavigationFromHomeRecentState_consumeUpdateEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -100;
      scbBaseNavigationFromHomeState.callback = callback;
      expect(navigationFromHomeRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('NavigationFromHomeRecentState_consumeEndEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      scbBaseNavigationState.preOffY = 10;
      scbBaseNavigationFromHomeState.callback = undefined;
      expect(navigationFromHomeRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('NavigationFromHomeRecentState_consumeEndEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      scbBaseNavigationState.preOffY = 10;
      scbBaseNavigationFromHomeState.callback = callback;
      expect(navigationFromHomeRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('NavigationFromHomeRecentState_consumeEndEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      scbBaseNavigationState.preOffY = 1000;
      scbBaseNavigationState.curSpeed = 1;
      scbBaseNavigationFromHomeState.callback = undefined;
      expect(navigationFromHomeRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('NavigationFromHomeRecentState_consumeEndEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      scbBaseNavigationState.preOffY = 1000;
      scbBaseNavigationState.curSpeed = 1;
      scbBaseNavigationFromHomeState.callback = callback;
      expect(navigationFromHomeRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('NavigationFromHomeRecentState_consumeEndEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      scbBaseNavigationState.preOffY = 1000;
      scbBaseNavigationState.curSpeed = 0.1;
      scbBaseNavigationFromHomeState.callback = undefined;
      expect(navigationFromHomeRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('NavigationFromHomeRecentState_consumeEndEvent_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      scbBaseNavigationState.preOffY = 1000;
      scbBaseNavigationState.curSpeed = 0.1;
      scbBaseNavigationFromHomeState.callback = callback;
      expect(navigationFromHomeRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

  })
}