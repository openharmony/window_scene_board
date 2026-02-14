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

import { ScenePanelEvents } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelEvents';
import {
  gestureHelperInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';
import { RecentLayoutManager } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentLayoutManager';
import screenSessionManager from '@ohos.screenSessionManager';
import { RecentIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentIdle';
import {
  RecentDeleteFollowing
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentDeleteFollowing';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { FSM, FSMEvent, SCBScreenProperty } from '@ohos/windowscene';
import {
  RecentViewParam,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession
} from '@ohos/windowscene';
import { recentLayoutConfigInstance } from '@ohos/recents';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  GestureHelper
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';
import { RecentDelete } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentDelete';

export default function RecentDeleteFollowingEnterTest() {
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
  let recentDeleteFollowing: RecentDeleteFollowing = new RecentDeleteFollowing(scbScenePanelManager);
  let recentIdle: RecentIdle = new RecentIdle(scbScenePanelManager);

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


  recentDeleteFollowing.callback = {
    name: 'RecentDeleteFollowingCallback',
    update: (containerId: number, event: GestureEvent) => {
    },
    restore: (containerId: number, event: GestureEvent) => {
    },
    cancel: (containerId: number, event: GestureEvent) => {
    },
    delete: (containerId: number, event: GestureEvent) => {
    }
  };


  describe('RecentDeleteFollowingEnterTest', () => {
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

    let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
    let recentLayoutConfig = recentLayoutConfigInstance;
    totalContainerSessionList.add(scbSceneContainer);
    totalContainerSessionList.add(scbSceneContainer);

    it('RecentDeleteFollowing_onEnter_test_01', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      recentDeleteFollowing.onEnter(recentDeleteFollowing, fsmEvent, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentDeleteFollowing).addState(recentIdle);
      fsm.currentState = recentDeleteFollowing;
      recentDeleteFollowing.attachToFsm(fsm);
      recentDeleteFollowing.init();
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      //toHomeFollowing GestureHelper.isUpForward(event)为true
      event.offsetY = -10;
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_02', Level.LEVEL0, (): void => {
      event.offsetY = -0.000001;
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_03', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentDeleteFollowing).addState(recentIdle);
      fsm.currentState = recentDeleteFollowing;
      recentDeleteFollowing.attachToFsm(fsm);
      recentDeleteFollowing.callback = null;
      recentDeleteFollowing.init();
      expect(recentDeleteFollowing).not().assertNull();
      event.offsetY = -0.000001;
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      event.offsetY = 10;
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_04', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentDeleteFollowing).addState(recentIdle);
      fsm.currentState = recentDeleteFollowing;
      recentDeleteFollowing.attachToFsm(fsm);
      recentDeleteFollowing.callback = {
        name: 'RecentDeleteFollowingCallback',
        update: (containerId: number, event: GestureEvent) => {
        },
        restore: (containerId: number, event: GestureEvent) => {
        },
        cancel: (containerId: number, event: GestureEvent) => {
        },
        delete: (containerId: number, event: GestureEvent) => {
        }
      };
      recentDeleteFollowing.init();
      expect(recentDeleteFollowing).not().assertNull();
      event.offsetY = -0.000001;
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      event.offsetY = 10;
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_05', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentDeleteFollowing).addState(recentIdle);
      fsm.currentState = recentDeleteFollowing;
      recentDeleteFollowing.attachToFsm(fsm);
      recentDeleteFollowing.callback = null;
      recentDeleteFollowing.init();
      expect(recentDeleteFollowing).not().assertNull();
      event.offsetY = 10;
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_06', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentDeleteFollowing).addState(recentIdle);
      fsm.currentState = recentDeleteFollowing;
      recentDeleteFollowing.attachToFsm(fsm);
      recentDeleteFollowing.callback = {
        name: 'RecentDeleteFollowingCallback',
        update: (containerId: number, event: GestureEvent) => {
        },
        restore: (containerId: number, event: GestureEvent) => {
        },
        cancel: (containerId: number, event: GestureEvent) => {
        },
        delete: (containerId: number, event: GestureEvent) => {
        }
      };
      recentDeleteFollowing.init();
      expect(recentDeleteFollowing).not().assertNull();
      event.offsetY = 10;
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_07', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentDeleteFollowing).addState(recentIdle);
      fsm.currentState = recentDeleteFollowing;
      recentDeleteFollowing.attachToFsm(fsm);
      recentDeleteFollowing.init();
      recentDeleteFollowing.callback = null;
      expect(recentDeleteFollowing).not().assertNull();
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
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_08', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentDeleteFollowing).addState(recentIdle);
      fsm.currentState = recentDeleteFollowing;
      recentDeleteFollowing.attachToFsm(fsm);
      recentDeleteFollowing.init();
      recentDeleteFollowing.callback = {
        name: 'RecentDeleteFollowingCallback',
        update: (containerId: number, event: GestureEvent) => {
        },
        restore: (containerId: number, event: GestureEvent) => {
        },
        cancel: (containerId: number, event: GestureEvent) => {
        },
        delete: (containerId: number, event: GestureEvent) => {
        }
      };
      expect(recentDeleteFollowing).not().assertNull();
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
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_09', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentDeleteFollowing).addState(recentIdle);
      fsm.currentState = recentDeleteFollowing;
      recentDeleteFollowing.attachToFsm(fsm);
      recentDeleteFollowing.init();
      recentDeleteFollowing.callback = {
        name: 'RecentDeleteFollowingCallback',
        update: (containerId: number, event: GestureEvent) => {
        },
        restore: (containerId: number, event: GestureEvent) => {
        },
        cancel: (containerId: number, event: GestureEvent) => {
        },
        delete: (containerId: number, event: GestureEvent) => {
        }
      };
      expect(recentDeleteFollowing).not().assertNull();
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
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_10', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentDeleteFollowing).addState(recentIdle);
      fsm.currentState = recentDeleteFollowing;
      recentDeleteFollowing.attachToFsm(fsm);
      recentDeleteFollowing.init();
      recentDeleteFollowing.callback = {
        name: 'RecentDeleteFollowingCallback',
        update: (containerId: number, event: GestureEvent) => {
        },
        restore: (containerId: number, event: GestureEvent) => {
        },
        cancel: (containerId: number, event: GestureEvent) => {
        },
        delete: (containerId: number, event: GestureEvent) => {
        }
      };
      expect(recentDeleteFollowing).not().assertNull();
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
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentDeleteFollowing).not().assertNull();
    })

    it('RecentDeleteFollowing_init_test_11', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentDeleteFollowing).addState(recentIdle);
      fsm.currentState = recentDeleteFollowing;
      recentDeleteFollowing.attachToFsm(fsm);
      recentDeleteFollowing.init();
      recentDeleteFollowing.callback = {
        name: 'RecentDeleteFollowingCallback',
        update: (containerId: number, event: GestureEvent) => {
        },
        restore: (containerId: number, event: GestureEvent) => {
        },
        cancel: (containerId: number, event: GestureEvent) => {
        },
        delete: (containerId: number, event: GestureEvent) => {
        }
      };
      expect(recentDeleteFollowing).not().assertNull();
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
      recentDeleteFollowing.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentDeleteFollowing).not().assertNull();
    })
  })
}
