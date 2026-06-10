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
import {
  FSM, FSMEvent, SCBScenePanelManager,
  SCBScreenProperty
} from '@ohos/windowscene';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Size,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { HomeIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/HomeIdle';
import {
  QuickSwitchFollowingFromHome
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/QuickSwitchFollowingFromHome';
import { ScenePanelEvents } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelEvents';
import {
  gestureHelperInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';
import screenSessionManager from '@ohos.screenSessionManager';
import { AppIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/AppIdle';
import { QuickSwitchIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchIdle';
import { GestureHelper } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';

export default function QuickSwitchFollowingFromHomeTest() {
  let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  let screenProp: screenSessionManager.ScreenProperty = {
    rotation: 1,
    bounds: {
      left: 1,
      top: 1,
      width: 1,
      height: 1,
      radius: 1,
    },
    fakeBounds: {
      left: 0,
      top: 0,
      width: 0,
      height: 0,
      radius: 0
    },
    isFakeInUse: false,
    rsId: 0,
  };
  scbScreenProperty.update(screenProp);
  let scbScenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
  let homeIdle: HomeIdle = new HomeIdle(scbScenePanelManager);
  let quickSwitchFollowingFromHome: QuickSwitchFollowingFromHome = new QuickSwitchFollowingFromHome(scbScenePanelManager);
  let appIdle: AppIdle = new AppIdle(scbScenePanelManager);
  let quickSwitchIdle: QuickSwitchIdle = new QuickSwitchIdle(scbScenePanelManager);

  let eventArea: Area = {
    width: 0,
    height: 0,
    position: {
      x: 0, y: 0
    },
    globalPosition: {
      x: 0, y: 0
    }
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
    offsetX: 10,
    offsetY: 5,
    angle: 0,
    speed: 0,
    scale: 0,
    pinchCenterX: 0,
    pinchCenterY: 0,
    velocityX: 0,
    velocityY: 0,
    velocity: 0
  };


  quickSwitchFollowingFromHome.callback = {
    onEnterHome: () => {
    },

    onUpdateScaleDesktop: (offsetY: number) => {
    },

    onExitRecent: () => {
    },

    onEnterRecent: (follow: boolean, offsetX: number, offsetY: number) => {
    },

    onUpdateRecent: (offsetX: number, offsetY: number) => {
    },

    onEnterFirstHomePage: () => {
    },
    onEnterSwitch: (follow: boolean, offsetX: number, offsetY: number) => {
    },

    onUpdateSwitch: (offsetX: number, offsetY: number) => {
    },

    onExitSwitch: () => {
    }
  }


  describe('QuickSwitchFollowingFromHomeTest', () => {
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

    it('QuickSwitchFollowingFromHome_onEnter', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      quickSwitchFollowingFromHome.onEnter(quickSwitchFollowingFromHome, fsmEvent);
      expect(fsmEvent).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_init_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromHome).addState(quickSwitchIdle).addState(homeIdle);
      fsm.currentState = quickSwitchFollowingFromHome;
      quickSwitchFollowingFromHome.attachToFsm(fsm);
      quickSwitchFollowingFromHome.init();
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_START);
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      //toHomeFollowing GestureHelper.isUpForward(event)为true
      event.offsetY = -10;
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(fsm).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_init_02', Level.LEVEL0, (): void => {
      event.offsetY = -0.000001;
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(quickSwitchFollowingFromHome).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_init_03', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromHome).addState(quickSwitchIdle).addState(homeIdle);
      fsm.currentState = quickSwitchFollowingFromHome;
      quickSwitchFollowingFromHome.attachToFsm(fsm);
      quickSwitchFollowingFromHome.callback = null;
      quickSwitchFollowingFromHome.init();
      expect(fsm).not().assertNull();
      event.offsetY = -0.000001;
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      event.offsetY = 10;
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_init_04', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromHome).addState(quickSwitchIdle).addState(homeIdle);
      fsm.currentState = quickSwitchFollowingFromHome;
      quickSwitchFollowingFromHome.attachToFsm(fsm);
      quickSwitchFollowingFromHome.callback = {
        onEnterHome: () => {
        },

        onUpdateScaleDesktop: (offsetY: number) => {
        },

        onExitRecent: () => {
        },

        onEnterRecent: (follow: boolean, offsetX: number, offsetY: number) => {
        },

        onUpdateRecent: (offsetX: number, offsetY: number) => {
        },

        onEnterFirstHomePage: () => {
        },
        onEnterSwitch: (follow: boolean, offsetX: number, offsetY: number) => {
        },

        onUpdateSwitch: (offsetX: number, offsetY: number) => {
        },

        onExitSwitch: () => {
        }
      };
      quickSwitchFollowingFromHome.init();
      expect(fsm).not().assertNull();
      event.offsetY = -0.000001;
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      event.offsetY = 10;
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_init_05', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromHome).addState(quickSwitchIdle).addState(homeIdle);
      fsm.currentState = quickSwitchFollowingFromHome;
      quickSwitchFollowingFromHome.attachToFsm(fsm);
      quickSwitchFollowingFromHome.callback = null;
      quickSwitchFollowingFromHome.init();
      expect(fsm).not().assertNull();
      event.offsetY = 10;
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_init_06', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromHome).addState(quickSwitchIdle).addState(homeIdle);
      fsm.currentState = quickSwitchFollowingFromHome;
      quickSwitchFollowingFromHome.attachToFsm(fsm);
      quickSwitchFollowingFromHome.callback = {
        onEnterHome: () => {
        },

        onUpdateScaleDesktop: (offsetY: number) => {
        },

        onExitRecent: () => {
        },

        onEnterRecent: (follow: boolean, offsetX: number, offsetY: number) => {
        },

        onUpdateRecent: (offsetX: number, offsetY: number) => {
        },

        onEnterFirstHomePage: () => {
        },
        onEnterSwitch: (follow: boolean, offsetX: number, offsetY: number) => {
        },

        onUpdateSwitch: (offsetX: number, offsetY: number) => {
        },

        onExitSwitch: () => {
        }
      };
      quickSwitchFollowingFromHome.init();
      expect(fsm).not().assertNull();
      event.offsetY = 10;
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_init_07', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromHome).addState(quickSwitchIdle).addState(homeIdle);
      fsm.currentState = quickSwitchFollowingFromHome;
      quickSwitchFollowingFromHome.attachToFsm(fsm);
      quickSwitchFollowingFromHome.init();
      quickSwitchFollowingFromHome.callback = null;
      expect(fsm).not().assertNull();
      event.offsetY = -10;
      gestureHelperInstance.startEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 10,
        offsetY: 10,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      gestureHelperInstance.curSpeed = 0.25;
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_init_08', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromHome).addState(quickSwitchIdle).addState(homeIdle);
      fsm.currentState = quickSwitchFollowingFromHome;
      quickSwitchFollowingFromHome.attachToFsm(fsm);
      quickSwitchFollowingFromHome.init();
      quickSwitchFollowingFromHome.callback = {
        onEnterHome: () => {
        },

        onUpdateScaleDesktop: (offsetY: number) => {
        },

        onExitRecent: () => {
        },

        onEnterRecent: (follow: boolean, offsetX: number, offsetY: number) => {
        },

        onUpdateRecent: (offsetX: number, offsetY: number) => {
        },

        onEnterFirstHomePage: () => {
        },
        onEnterSwitch: (follow: boolean, offsetX: number, offsetY: number) => {
        },

        onUpdateSwitch: (offsetX: number, offsetY: number) => {
        },

        onExitSwitch: () => {
        }
      };
      expect(fsm).not().assertNull();
      event.offsetY = -10;
      gestureHelperInstance.startEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 10,
        offsetY: 10,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      gestureHelperInstance.curSpeed = 0.25;
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_init_9', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromHome).addState(quickSwitchIdle).addState(homeIdle);
      fsm.currentState = quickSwitchFollowingFromHome;
      quickSwitchFollowingFromHome.attachToFsm(fsm);
      quickSwitchFollowingFromHome.init();
      quickSwitchFollowingFromHome.callback = {
        onEnterHome: () => {
        },

        onUpdateScaleDesktop: (offsetY: number) => {
        },

        onExitRecent: () => {
        },

        onEnterRecent: (follow: boolean, offsetX: number, offsetY: number) => {
        },

        onUpdateRecent: (offsetX: number, offsetY: number) => {
        },

        onEnterFirstHomePage: () => {
        },
        onEnterSwitch: (follow: boolean, offsetX: number, offsetY: number) => {
        },

        onUpdateSwitch: (offsetX: number, offsetY: number) => {
        },

        onExitSwitch: () => {
        }
      };
      expect(fsm).not().assertNull();
      event.offsetY = -10;
      gestureHelperInstance.startEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 10,
        offsetY: 10,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      gestureHelperInstance.curSpeed = 0.25;
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isRightForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      expect(fsm).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_init_10', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromHome).addState(quickSwitchIdle).addState(homeIdle);
      fsm.currentState = quickSwitchFollowingFromHome;
      quickSwitchFollowingFromHome.attachToFsm(fsm);
      quickSwitchFollowingFromHome.init();
      quickSwitchFollowingFromHome.callback = {
        onEnterHome: () => {
        },

        onUpdateScaleDesktop: (offsetY: number) => {
        },

        onExitRecent: () => {
        },

        onEnterRecent: (follow: boolean, offsetX: number, offsetY: number) => {
        },

        onUpdateRecent: (offsetX: number, offsetY: number) => {
        },

        onEnterFirstHomePage: () => {
        },
        onEnterSwitch: (follow: boolean, offsetX: number, offsetY: number) => {
        },

        onUpdateSwitch: (offsetX: number, offsetY: number) => {
        },

        onExitSwitch: () => {
        }
      };
      expect(fsm).not().assertNull();
      event.offsetY = -10;
      gestureHelperInstance.startEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 10,
        offsetY: 10,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      gestureHelperInstance.curSpeed = 0.25;
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isRightForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(false);
      quickSwitchFollowingFromHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      expect(fsm).not().assertNull();
    })

    it('QuickSwitchFollowingFromHome_onLeave', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      quickSwitchFollowingFromHome.onLeave(quickSwitchFollowingFromHome, fsmEvent);
      expect(fsmEvent).not().assertNull();
    })
  })
}