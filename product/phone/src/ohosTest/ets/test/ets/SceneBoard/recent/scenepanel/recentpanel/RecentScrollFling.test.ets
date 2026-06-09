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
  FSMEvent,
  SCBScenePanelManager,
  SCBScreenProperty,
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBSceneInfo,
  FSM
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
import screenSessionManager from '@ohos.screenSessionManager';
import { RecentScrollFling } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentScrollFling';
import { RecentScrollFollowing } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentScrollFollowing';
import { RecentScrollHelper } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentScrollHelper';
import { HomeIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/HomeIdle';
import { RecentIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentIdle';
import { AppIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/AppIdle';
import { GestureHelper } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';
import { TouchEvent } from 'touchEvent';
import { ScenePanelEvents } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelEvents';
import sceneSessionManager from '@ohos.sceneSessionManager';

export default function RecentScrollFlingTest() {
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
  let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
  let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
  let scbScenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
  let recentScrollFling: RecentScrollFling = new RecentScrollFling(scbScenePanelManager);
  let recentIdle: RecentIdle = new RecentIdle(scbScenePanelManager);
  let homeIdle: HomeIdle = new HomeIdle(scbScenePanelManager);
  let appIdle: AppIdle = new AppIdle(scbScenePanelManager);
  let recentScrollFollowing: RecentScrollFollowing = new RecentScrollFollowing(scbScenePanelManager);
  let recentScrollHelper: RecentScrollHelper = new RecentScrollHelper('RecentScrollFling');
  let fsm = new FSM('testFSM');
  fsm.addState(recentIdle).addState(recentScrollFling);
  fsm.currentState = recentIdle;
  let historicalPoint: HistoricalPoint = {
    touchObject: {
      type: TouchType.Down,
      id: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0
    },
    size: 0,
    force: 0,
    timestamp: 0
  }
  let touchEvent: TouchEvent = {
    target: {
      area: {
        width: 0,
        height: 0,
        position: {
          x: 0, y: 0
        },
        globalPosition: {
          x: 0, y: 0
        }
      }
    },
    timestamp: 0,
    source: 0,
    pressure: 0,
    tiltX: 0,
    tiltY: 0,
    sourceTool: 0,
    type: TouchType.Down,
    touches: [],
    changedTouches: [{
      id: 0,
      type: 0,
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0
    }],
    stopPropagation: () => {
    },
    getHistoricalPoints: () => {
      return [historicalPoint, historicalPoint];
    },
    preventDefault: () => {
    }
  };
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
  (recentScrollFling as object)['callback']  = {
    name: 'RecentScrollFlingCallback',
    doScroll: (deltaOffset: number, currentOffset: number) => {},
    doTouchDown: (touchEvent: TouchEvent) => {},
    doTouchUp: (touchEvent: TouchEvent) => {},
    toHomeIdle: () => {},
    toAppIdle: (sceneContainerSession: SCBSceneContainerSession) => {},
    clearAllMission: () => {}
  };

  describe('RecentScrollFlingTest', () => {
    beforeAll(() => {})
    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    it('RecentScrollFlingTest_onEnter', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_SCROLL_START);
      recentScrollFling.onEnter(recentIdle, fsmEvent);
      expect(fsmEvent).not().assertNull();
    })

    it('RecentScrollFlingTest_init_01', Level.LEVEL0, (): void => {
      recentScrollFling.transfer(ScenePanelEvents.EVENT_SCROLL_START, event);
      expect(recentScrollFling).not().assertNull();
    })

    it('RecentScrollFlingTest_init_02', Level.LEVEL0, (): void => {
      fsm.addState(recentScrollFollowing).addState(recentScrollFling);
      fsm.currentState = recentScrollFling;
      recentScrollFling.transfer(ScenePanelEvents.EVENT_ON_SCROLL, event);
      expect(recentScrollFling).not().assertNull();
    })

    it('RecentScrollFlingTest_init_03', Level.LEVEL0, (): void => {
      recentScrollFling.transfer(ScenePanelEvents.EVENT_SCROLL_STOP, event);
      expect(recentScrollFling).not().assertNull();
    })

    it('RecentScrollFlingTest_init_04', Level.LEVEL0, (): void => {
      recentScrollFling.transfer(ScenePanelEvents.EVENT_TOUCH_DOWN, event);
      expect(recentScrollFling).not().assertNull();
    })

    it('RecentScrollFlingTest_init_05', Level.LEVEL0, (): void => {
      recentScrollFling.transfer(ScenePanelEvents.EVENT_TOUCH_UP, event);
      expect(recentScrollFling).not().assertNull();
    })
  })
}