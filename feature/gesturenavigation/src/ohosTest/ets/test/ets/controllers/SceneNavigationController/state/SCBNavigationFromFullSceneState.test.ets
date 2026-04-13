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
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  Size,
  TestType,
  when
} from '@ohos/hypium';
import {
  SCBBaseNavigationFromFullSceneState,
  SCBNavigationFromFullSceneFarAwayState,
  SCBNavigationFromFullSceneIdleState,
  SCBNavigationFromFullSceneRecentState,
  SCBNavigationFromFullSceneZoomState
} from '../../../../../../../main/ets/controllers/SceneNavigationController/state/SCBNavigationFromFullSceneState';
import { OneStepState } from '../../../../../../../main/ets/constants/CommonConstants';
import {
  SCBNavigationFromFullSceneCallback
} from '../../../../../../../main/ets/controllers/SceneNavigationController/interface/SCBNavigationCallback';
import {
  SCBBaseNavigationState
} from '../../../../../../../main/ets/controllers/SceneNavigationController/state/SCBNavigationState';
import { DockUtils } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { display } from '@kit.ArkUI';

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

let stopMoveEvent: GestureEvent = {
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

let callback: SCBNavigationFromFullSceneCallback = {
  onEnterSceneZoom: () => {
  },
  onExitSceneZoom: () => {
  },
  onUpdateSceneZoom: (offsetX: number, offsetY: number) => {
  },
  onEnterRecent: (follow: boolean, offsetX: number, offsetY: number) => {
  },
  onUpdateRecent: (offsetX: number, offsetY: number) => {
  },
  onEnterAppFarView: () => {
  },
  onUpdateAppFarView: (offsetX: number, offsetY: number, speed: number) => {
  },
  onEnterHome: () => {
  },
  onEnterAppFullScreen: () => {
  },
  onEnterSplit: () => {
  },
  onGestureEventUpdate: (positionX: number, positionY: number, speed: number) => {
  },
  onGestureEventEnd: (positionX: number, positionY: number) => {
  },
  onGestureEventCancel: (positionX: number, positionY: number) => {
  },
  onEnterQuickSwitchFollowingFromAppIdle: () => {
  },
  onEnterHomeIdleFromQuickSwitchFollowing: () => {
  },
  onEnterQuickSwitchIdleFromQuickSwitchFollowing: (offsetX: number, offsetY: number) => {
  },
  onEnterAppIdleFromQuickSwitchFollowing: () => {
  },
  onEnterRecentFollowingFromQuickSwitchFollowing: (offsetX: number, offsetY: number) => {
  },
  onUpdateQuickSwitchFollowing: (offsetX: number, offsetY: number) => {
  },
  onEnterQuickSwitchIdleFromRecentFollowing: (offsetX: number, offsetY: number) => {
  }
}

let scbBaseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(2774);
let scbNavigationFromFullSceneIdleState = new SCBNavigationFromFullSceneIdleState(2774);
let scbNavigationFromFullSceneZoomState = new SCBNavigationFromFullSceneZoomState(2774);
let scbBaseNavigationState = new SCBBaseNavigationState(2774);
let scbNavigationFromFullSceneRecentState = new SCBNavigationFromFullSceneRecentState(2774);
let scbNavigationFromFullSceneFarAwayState = new SCBNavigationFromFullSceneFarAwayState(2774);

export default function SCBNavigationFromFullSceneStateTest() {
  describe('SCBNavigationFromFullSceneStateTest', () => {
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

    it('SCBBaseNavigationFromFullSceneState_constructor_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(new SCBBaseNavigationFromFullSceneState(0) !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_constructor_2', 0, (): void => {
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(1080);
      display.getDefaultDisplaySync().height = 1080;
      expect(baseNavigationFromFullSceneState !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_constructor_3', 0, (): void => {
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(1);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(mockFunc)().afterReturn(true);
      AppStorage.set('appDockVisibility', Visibility.Hidden);
      expect(baseNavigationFromFullSceneState !== undefined).assertTrue();
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
    })

    it('SCBBaseNavigationFromFullSceneState_constructor_4', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(mockFunc)().afterReturn(true);
      AppStorage.set('appDockVisibility', Visibility.Hidden);
      expect(new SCBBaseNavigationFromFullSceneState(100).screenHeight).assertEqual(20);
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
    })

    it('SCBBaseNavigationFromFullSceneState_constructor_5', 0, (): void => {
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(1);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(mockFunc)().afterReturn(true);
      AppStorage.set('appDockVisibility', Visibility.Visible);
      expect(baseNavigationFromFullSceneState !== undefined).assertTrue();
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
    })

    it('SCBBaseNavigationFromFullSceneState_setCallback_1', 0, (): void => {
      expect(scbBaseNavigationFromFullSceneState.setCallback(callback) === undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_isOneStepState_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_SPLIT;
      expect(scbBaseNavigationFromFullSceneState.isOneStepState()).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_isOneStepState_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_FLOATING;
      expect(scbBaseNavigationFromFullSceneState.isOneStepState()).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_isOneStepState_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.DEFAULT;
      expect(scbBaseNavigationFromFullSceneState.isOneStepState()).assertFalse();
    })

    it('SCBBaseNavigationFromFullSceneState_consumeUpdateEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      expect(scbBaseNavigationFromFullSceneState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_consumeUpdateEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      event.fingerList = [{
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      }];
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbBaseNavigationFromFullSceneState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_consumeUpdateEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      event.fingerList = [{
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      }];
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbBaseNavigationFromFullSceneState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_consumeUpdateEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      event.fingerList = [{
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      }, {
        id: 1,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      }];
      expect(scbBaseNavigationFromFullSceneState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_consumeEndEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      expect(scbBaseNavigationFromFullSceneState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_consumeEndEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      event.fingerList = [{
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      }];
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbBaseNavigationFromFullSceneState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_consumeEndEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      event.fingerList = [{
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      }];
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbBaseNavigationFromFullSceneState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_consumeEndEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      event.fingerList = [];
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbBaseNavigationFromFullSceneState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_consumeEndEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      event.fingerList = [];
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbBaseNavigationFromFullSceneState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBBaseNavigationFromFullSceneState_consumeEndEvent_6', 0, (): void => {
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(1080);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(mockFunc)().afterReturn(true);
      expect(baseNavigationFromFullSceneState.consumeEndEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
    })

    it('SCBNavigationFromFullSceneIdleState_consumeUpdateEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbNavigationFromFullSceneIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneIdleState_consumeUpdateEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbNavigationFromFullSceneIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneIdleState_consumeUpdateEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      expect(scbNavigationFromFullSceneIdleState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneIdleState_consumeEndEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(scbNavigationFromFullSceneIdleState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeUpdateEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      expect(scbNavigationFromFullSceneZoomState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeUpdateEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbBaseNavigationState.curSpeed = 0.2;
      expect(scbNavigationFromFullSceneZoomState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeUpdateEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbBaseNavigationState.curSpeed = 0.1;
      expect(scbNavigationFromFullSceneZoomState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeUpdateEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbBaseNavigationState.curSpeed = -0.1;
      scbNavigationFromFullSceneZoomState.stopMoveEvent = null;
      scbNavigationFromFullSceneZoomState.consumeUpdateEvent(event);
      expect(scbNavigationFromFullSceneZoomState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeUpdateEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1109;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.SHOW_BG_AND_ICON;
      event.timestamp = 0.1;
      scbBaseNavigationState.curSpeed = -0.1;
      scbNavigationFromFullSceneZoomState.stopMoveEvent = event;
      expect(scbNavigationFromFullSceneZoomState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeUpdateEvent_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbNavigationFromFullSceneZoomState.stopMoveEvent = event;
      expect(scbNavigationFromFullSceneZoomState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeUpdateEvent_7', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = Number.MAX_VALUE;
      scbNavigationFromFullSceneZoomState.screenHeight = 1;
      expect(scbNavigationFromFullSceneZoomState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeUpdateEvent_8', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1109;
      scbBaseNavigationState.curSpeed = -0.1;
      scbNavigationFromFullSceneZoomState.screenHeight = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbNavigationFromFullSceneZoomState,
        (scbNavigationFromFullSceneZoomState as object)['isRecentsViewShowOfDistanceLimit']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(scbNavigationFromFullSceneZoomState,
        (scbNavigationFromFullSceneZoomState as object)['isRecentsViewShowOfSpeedLimit']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc3: Function = mocker.mockFunc(scbNavigationFromFullSceneZoomState,
        (scbNavigationFromFullSceneZoomState as object)['isOneStepState']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(scbNavigationFromFullSceneZoomState.consumeUpdateEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(scbNavigationFromFullSceneZoomState,
        (scbNavigationFromFullSceneZoomState as object)['isRecentsViewShowOfDistanceLimit']);
      mocker.ignoreMock(scbNavigationFromFullSceneZoomState,
        (scbNavigationFromFullSceneZoomState as object)['isRecentsViewShowOfSpeedLimit']);
      mocker.ignoreMock(scbNavigationFromFullSceneZoomState,
        (scbNavigationFromFullSceneZoomState as object)['isOneStepState']);
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.ENTER_SPLIT);
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      scbBaseNavigationState.curSpeed = -0.2;
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      scbBaseNavigationState.curSpeed = -0.2;
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      scbBaseNavigationState.curSpeed = 0.2;
      event.offsetY = 1000;
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      scbBaseNavigationState.curSpeed = 0.2;
      event.offsetY = 1000;
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_SPLIT;
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_7', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_FLOATING;
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_8', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.DEFAULT;
      scbBaseNavigationState.curSpeed = -0.7;
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_9', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.DEFAULT;
      scbBaseNavigationState.curSpeed = Number.MAX_VALUE;
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbNavigationFromFullSceneZoomState.stopMoveEvent = stopMoveEvent;
      event.timestamp = Number.MAX_VALUE;
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      event.offsetY = 1600;
      expect(scbNavigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_12', 0, (): void => {
      let navigationFromFullSceneZoomState = new SCBNavigationFromFullSceneZoomState(100);
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
      when(mockFunc)().afterReturn(true);
      expect(navigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
    })

    it('SCBNavigationFromFullSceneZoomState_consumeEndEvent_13', 0, (): void => {
      let navigationFromFullSceneZoomState = new SCBNavigationFromFullSceneZoomState(100);
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function =
        mocker.mockFunc(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
      when(mockFunc1)().afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(navigationFromFullSceneZoomState,
        (navigationFromFullSceneZoomState as object)['isShouldEnterHomeView']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      expect(navigationFromFullSceneZoomState.consumeEndEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
      mocker.ignoreMock(navigationFromFullSceneZoomState,
        (navigationFromFullSceneZoomState as object)['isShouldEnterHomeView']);
    })

    it('SCBNavigationFromFullSceneZoomState_isShouldEnterHomeView_1', 0, (): void => {
      let scbNavigationFromFullSceneZoomState = new SCBNavigationFromFullSceneZoomState(100);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbNavigationFromFullSceneZoomState,
        (scbNavigationFromFullSceneZoomState as object)['isHomeViewShowOfSpeedLimit']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((scbNavigationFromFullSceneZoomState as object)['isShouldEnterHomeView'](1) !== undefined).assertTrue();
      mocker.ignoreMock(scbNavigationFromFullSceneZoomState,
        (scbNavigationFromFullSceneZoomState as object)['isHomeViewShowOfSpeedLimit']);
    })

    it('SCBNavigationFromFullSceneZoomState_isRecentsViewShowOfSpeedLimit_1', 0, (): void => {
      let scbNavigationFromFullSceneZoomState = new SCBNavigationFromFullSceneZoomState(100);
      expect((scbNavigationFromFullSceneZoomState as object)['isRecentsViewShowOfSpeedLimit'](px2vp(100), px2vp(0.1),
        px2vp(-1)) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_isRecentsViewShowOfSpeedLimit_2', 0, (): void => {
      let scbNavigationFromFullSceneZoomState = new SCBNavigationFromFullSceneZoomState(100);
      stopMoveEvent.timestamp = 100 * 1000000;
      scbNavigationFromFullSceneZoomState.stopMoveEvent = stopMoveEvent;
      expect((scbNavigationFromFullSceneZoomState as object)['isRecentsViewShowOfSpeedLimit'](px2vp(181 * 1000000),
        px2vp(0.01), px2vp(0)) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneZoomState_isRecentsViewShowOfSpeedLimit_3', 0, (): void => {
      let scbNavigationFromFullSceneZoomState = new SCBNavigationFromFullSceneZoomState(100);
      expect((scbNavigationFromFullSceneZoomState as object)['isRecentsViewShowOfSpeedLimit'](px2vp(100), px2vp(0.01),
        px2vp(1)) !== undefined).assertTrue();
    })


    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbNavigationFromFullSceneRecentState.startEvent = undefined;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.DEFAULT;
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbNavigationFromFullSceneRecentState.startEvent = undefined;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.DEFAULT;
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbNavigationFromFullSceneRecentState.startEvent = undefined;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_SPLIT;
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbNavigationFromFullSceneRecentState.startEvent = undefined;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_SPLIT;
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = Number.MAX_VALUE;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_SPLIT;
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_7', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = Number.MAX_VALUE;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_FLOATING;
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_8', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = Number.MAX_VALUE;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.DEFAULT;
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_9', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbNavigationFromFullSceneRecentState.startEvent = event;
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1400;
      scbNavigationFromFullSceneRecentState.startEvent = event;
      scbNavigationFromFullSceneRecentState.startEvent.offsetY = -1;
      scbBaseNavigationFromFullSceneState.aspectRadio = 3;
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_11', 0, (): void => {
      let navigationFromFullSceneRecentState = new SCBNavigationFromFullSceneRecentState(100);
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      navigationFromFullSceneRecentState.startEvent = event;
      event.offsetX = -1;
      event.offsetY = -1;
      let mocker = new MockKit();
      let mockIsRecentsViewOutOfDistanceLimit = mocker.mockFunc(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit']);
      let mockIsOneStepState =
        mocker.mockFunc(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
      when(mockIsRecentsViewOutOfDistanceLimit)(event.offsetY).afterReturn(true);
      when(mockIsOneStepState)().afterReturn(true);
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit']);
      mocker.ignoreMock(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_12', 0, (): void => {
      let navigationFromFullSceneRecentState = new SCBNavigationFromFullSceneRecentState(100);
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      event.offsetX = -1;
      let mocker = new MockKit();
      let mockIsRecentsViewOutOfDistanceLimit = mocker.mockFunc(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit']);
      let mockIsOneStepState =
        mocker.mockFunc(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
      let mockIsAppZoomViewShowOfDistanceLimit = mocker.mockFunc(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isAppZoomViewShowOfDistanceLimit']);
      when(mockIsRecentsViewOutOfDistanceLimit)(ArgumentMatchers.any).afterReturn(false);
      when(mockIsOneStepState)().afterReturn(false);
      when(mockIsAppZoomViewShowOfDistanceLimit)(ArgumentMatchers.any).afterReturn(false);
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit']);
      mocker.ignoreMock(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
      mocker.ignoreMock(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isAppZoomViewShowOfDistanceLimit']);
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_13', 0, (): void => {
      let navigationFromFullSceneRecentState = new SCBNavigationFromFullSceneRecentState(100);
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      event.offsetX = -1;
      event.offsetY = -1;
      navigationFromFullSceneRecentState.callback = undefined;
      let mocker = new MockKit();
      let mockIsRecentsViewOutOfDistanceLimit = mocker.mockFunc(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit']);
      let mockIsOneStepState =
        mocker.mockFunc(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
      let mockIsAppZoomViewShowOfDistanceLimit = mocker.mockFunc(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isAppZoomViewShowOfDistanceLimit']);
      when(mockIsRecentsViewOutOfDistanceLimit)(event.offsetY).afterReturn(false);
      when(mockIsOneStepState)().afterReturn(false);
      when(mockIsAppZoomViewShowOfDistanceLimit)(event.offsetY).afterReturn(false);
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit']);
      mocker.ignoreMock(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
      mocker.ignoreMock(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isAppZoomViewShowOfDistanceLimit']);
    })

    it('SCBNavigationFromFullSceneRecentState_consumeUpdateEvent_14', 0, (): void => {
      let navigationFromFullSceneRecentState = new SCBNavigationFromFullSceneRecentState(100);
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      event.offsetX = -1;
      event.offsetY = -1;
      navigationFromFullSceneRecentState.callback = callback;
      let mocker = new MockKit();
      let mockIsRecentsViewOutOfDistanceLimit = mocker.mockFunc(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit']);
      let mockIsOneStepState =
        mocker.mockFunc(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
      let mockIsAppZoomViewShowOfDistanceLimit = mocker.mockFunc(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isAppZoomViewShowOfDistanceLimit']);
      when(mockIsRecentsViewOutOfDistanceLimit)(event.offsetY).afterReturn(false);
      when(mockIsOneStepState)().afterReturn(false);
      when(mockIsAppZoomViewShowOfDistanceLimit)(event.offsetY).afterReturn(false);
      expect(scbNavigationFromFullSceneRecentState.consumeUpdateEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit']);
      mocker.ignoreMock(baseNavigationFromFullSceneState, baseNavigationFromFullSceneState.isOneStepState);
      mocker.ignoreMock(navigationFromFullSceneRecentState,
        (navigationFromFullSceneRecentState as object)['isAppZoomViewShowOfDistanceLimit']);
    })

    it('SCBNavigationFromFullSceneRecentState_consumeEndEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.ENTER_SPLIT);
      expect(scbNavigationFromFullSceneRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeEndEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      scbBaseNavigationState.curSpeed = -0.7;
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbNavigationFromFullSceneRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeEndEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      scbBaseNavigationState.curSpeed = -0.7;
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbNavigationFromFullSceneRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeEndEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      scbBaseNavigationState.curSpeed = 1;
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbNavigationFromFullSceneRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeEndEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      scbBaseNavigationState.curSpeed = 1;
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbNavigationFromFullSceneRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeEndEvent_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      expect(scbNavigationFromFullSceneRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeEndEvent_7', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.ENTER_SPLIT);
      scbBaseNavigationState.curSpeed = -1;
      expect(scbNavigationFromFullSceneRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeEndEvent_8', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.ENTER_FLOATING);
      scbBaseNavigationState.curSpeed = -1;
      expect(scbNavigationFromFullSceneRecentState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_consumeEndEvent_9', 0, (): void => {
      let navigationFromFullSceneRecentState = new SCBNavigationFromFullSceneRecentState(100);
      let navigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      let mocker = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(navigationFromFullSceneState, (navigationFromFullSceneState as object)['isOneStepState']);
      when(mockFunc)().afterReturn(true);
      expect(navigationFromFullSceneRecentState.consumeEndEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(navigationFromFullSceneState, (navigationFromFullSceneState as object)['isOneStepState']);
    })

    it('SCBNavigationFromFullSceneRecentState_consumeEndEvent_10', 0, (): void => {
      let navigationFromFullSceneRecentState = new SCBNavigationFromFullSceneRecentState(100);
      let navigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      let baseNavigationState = new SCBBaseNavigationState(100);
      let mocker = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(navigationFromFullSceneState, (navigationFromFullSceneState as object)['isOneStepState']);
      when(mockFunc)().afterReturn(false);
      baseNavigationState.curSpeed = -1;
      expect(navigationFromFullSceneRecentState.consumeEndEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(navigationFromFullSceneState, (navigationFromFullSceneState as object)['isOneStepState']);
    })

    it('SCBNavigationFromFullSceneRecentState_isRecentsViewOutOfDistanceLimit_1', 0, (): void => {
      let navigationFromFullSceneRecentState = new SCBNavigationFromFullSceneRecentState(100);
      navigationFromFullSceneRecentState.startEvent = event;
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      baseNavigationFromFullSceneState.aspectRadio = 5;
      navigationFromFullSceneRecentState.startEvent.offsetY = 5;
      expect((navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit'](1) !== undefined)
        .assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_isRecentsViewOutOfDistanceLimit_1', 0, (): void => {
      let navigationFromFullSceneRecentState = new SCBNavigationFromFullSceneRecentState(100);
      navigationFromFullSceneRecentState.startEvent = event;
      navigationFromFullSceneRecentState.screenHeight = 2;
      navigationFromFullSceneRecentState.aspectRadio = 5;
      navigationFromFullSceneRecentState.startEvent.offsetY = 5;
      expect((navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit'](1) !== undefined)
        .assertTrue();
    })

    it('SCBNavigationFromFullSceneRecentState_isRecentsViewOutOfDistanceLimit_2', 0, (): void => {
      let navigationFromFullSceneRecentState = new SCBNavigationFromFullSceneRecentState(100);
      navigationFromFullSceneRecentState.startEvent = event;
      navigationFromFullSceneRecentState.screenHeight = 100;
      navigationFromFullSceneRecentState.aspectRadio = 5;
      navigationFromFullSceneRecentState.startEvent.offsetY = 5;
      expect((navigationFromFullSceneRecentState as object)['isRecentsViewOutOfDistanceLimit'](1) !== undefined)
        .assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = 1;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbNavigationFromFullSceneFarAwayState.topOffsetY = -2;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbNavigationFromFullSceneFarAwayState.topOffsetY = 0;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbNavigationFromFullSceneFarAwayState.topOffsetY = 0;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_SPLIT;
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbNavigationFromFullSceneFarAwayState.topOffsetY = 0;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_SPLIT;
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1000;
      scbNavigationFromFullSceneFarAwayState.topOffsetY = 0;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.DEFAULT;
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_7', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1000;
      scbNavigationFromFullSceneFarAwayState.topOffsetY = 0;
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.DEFAULT;
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_8', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = Number.MAX_VALUE;
      scbBaseNavigationFromFullSceneState.screenHeight = 1;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_9', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_FLOATING;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_SPLIT;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.ENTER_SPLIT);
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeUpdateEvent_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      event.offsetY = -1;
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.DEFAULT);
      scbNavigationFromFullSceneFarAwayState.topOffsetY = -500;
      expect(scbNavigationFromFullSceneFarAwayState.consumeUpdateEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeEndEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.DEFAULT;
      scbBaseNavigationFromFullSceneState.callback = undefined;
      expect(scbNavigationFromFullSceneFarAwayState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeEndEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.DEFAULT;
      scbBaseNavigationFromFullSceneState.callback = callback;
      expect(scbNavigationFromFullSceneFarAwayState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeEndEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.setCurOneStepState(OneStepState.ENTER_SPLIT);
      expect(scbNavigationFromFullSceneFarAwayState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeEndEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbBaseNavigationFromFullSceneState.curOneStepState = OneStepState.ENTER_FLOATING;
      expect(scbNavigationFromFullSceneFarAwayState.consumeEndEvent(event) !== undefined).assertTrue();
    })

    it('SCBNavigationFromFullSceneFarAwayState_consumeEndEvent_5', 0, (): void => {
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      let navigationFromFullSceneFarAwayState = new SCBNavigationFromFullSceneFarAwayState(100);
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(baseNavigationFromFullSceneState,
        (baseNavigationFromFullSceneState as object)['isOneStepState']);
      when(mockFunc)().afterReturn(true);
      expect(navigationFromFullSceneFarAwayState.consumeEndEvent(event) !== undefined).assertTrue();
      mocker.ignoreMock(baseNavigationFromFullSceneState,
        (baseNavigationFromFullSceneState as object)['isOneStepState']);
    })

    it('SCBNavigationFromFullSceneFarAwayState_isFarAwayNeedEnterRecentsView_1', 0, (): void => {
      let navigationFromFullSceneFarAwayState = new SCBNavigationFromFullSceneFarAwayState(100);
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(baseNavigationFromFullSceneState,
        (baseNavigationFromFullSceneState as object)['isOneStepState']);
      when(mockFunc)().afterReturn(true);
      expect((navigationFromFullSceneFarAwayState as object)['isFarAwayNeedEnterRecentsView'](event) !== undefined)
        .assertTrue();
      mocker.ignoreMock(baseNavigationFromFullSceneState,
        (baseNavigationFromFullSceneState as object)['isOneStepState']);
    })

    it('SCBNavigationFromFullSceneFarAwayState_isFarAwayNeedEnterRecentsView_2', 0, (): void => {
      let navigationFromFullSceneFarAwayState = new SCBNavigationFromFullSceneFarAwayState(100);
      let baseNavigationFromFullSceneState = new SCBBaseNavigationFromFullSceneState(100);
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(baseNavigationFromFullSceneState,
        (baseNavigationFromFullSceneState as object)['isOneStepState']);
      when(mockFunc)().afterReturn(true);
      expect((navigationFromFullSceneFarAwayState as object)['isFarAwayNeedEnterRecentsView'](event))
        .assertFalse();
      mocker.ignoreMock(baseNavigationFromFullSceneState,
        (baseNavigationFromFullSceneState as object)['isOneStepState']);
    })
  })
}