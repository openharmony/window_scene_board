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
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene';
import {
  RecentEventViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/viewmodel/RecentEventViewModel';

import { RecentRotationUtil } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentRotationUtil';
import sceneSessionManager from '@ohos.sceneSessionManager';
import screenSessionManager from '@ohos.screenSessionManager';
import { commonEventManager, systemParameter } from '@kit.BasicServicesKit';
import {
  SCBOuterScenePanelManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/SCBOuterScenePanelManager';

let screenPropertyNull: SCBScreenProperty;
let scContainerSessionNull: SCBSceneContainerSession;

export default function RecentEventViewModelTest() {
  describe('RecentEventViewModelTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testMoudle', 'testAbility');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
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
      offsetX: 0,
      offsetY: 30,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };
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
    let scContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
    let recentEventViewModel:RecentEventViewModel = new RecentEventViewModel(screenProperty);


    it('RecentEventViewModel_test_getPanGestureEvent_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scContainerSession.currentRotation = 180;
      let mocker: MockKit = new MockKit();
      let screenRotation: Function = mocker.mockFunc(RecentRotationUtil, RecentRotationUtil.getScreenRotation);
      when(screenRotation)(ArgumentMatchers.any).afterReturn(32220);
      RecentEventViewModel.getPanGestureEvent(event, screenProperty, scContainerSession);
      expect(RecentEventViewModel.getPanGestureEvent(event, screenProperty, scContainerSession).offsetX).assertEqual(0);
      mocker.ignoreMock(RecentRotationUtil, RecentRotationUtil.getScreenRotation);
    })

    it('RecentEventViewModel_test_getPanGestureEvent_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scContainerSession.currentRotation = 180;
      let mocker: MockKit = new MockKit();
      let screenRotation: Function = mocker.mockFunc(RecentRotationUtil, RecentRotationUtil.getScreenRotation);
      when(screenRotation)(ArgumentMatchers.any).afterReturn(97020);
      RecentEventViewModel.getPanGestureEvent(event, screenProperty, scContainerSession);
      expect(RecentEventViewModel.getPanGestureEvent(event, screenProperty, scContainerSession).offsetX).assertEqual(0);
      mocker.ignoreMock(RecentRotationUtil, RecentRotationUtil.getScreenRotation);
    })

    it('RecentEventViewModel_test_getPanGestureEvent_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentEventViewModel.getPanGestureEvent(event, screenPropertyNull, scContainerSession).offsetX)
        .assertEqual(0);
      expect(RecentEventViewModel.getPanGestureEvent(event, screenProperty, scContainerSessionNull).offsetX)
        .assertEqual(0);
      expect(RecentEventViewModel.getPanGestureEvent(event, screenPropertyNull, scContainerSessionNull).offsetX)
        .assertEqual(0);
    })

    it('RecentEventViewModel_test_resetHoverScale_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEventViewModel.isInHover = true;
      (recentEventViewModel as object)['resetHoverScale'](scContainerSession);
      expect(recentEventViewModel.isInHover).assertEqual(false);
    })

    it('RecentEventViewModel_test_touchDownCallback_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentEventViewModel as object)['touchDownCallback'](touchEvent, 0);
      expect(recentEventViewModel.isInHover).assertEqual(false);
    })

    it('RecentEventViewModel_test_touchDownCallback_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      touchEvent.touches.push({
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
      });
      touchEvent.touches.push({
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
      });
      (recentEventViewModel as object)['touchDownCallback'](touchEvent, 0);
      expect(recentEventViewModel.isInHover).assertEqual(false);
    })

    it('RecentEventViewModel_test_getPanGestureDirection_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(RecentRotationUtil,
        RecentRotationUtil.isSameRotation);
      when(mockFunc)().afterReturn(true);
      RecentEventViewModel.getPanGestureDirection(screenProperty, 0);
      expect(RecentEventViewModel).not().assertUndefined();
      mocker.ignoreMock(SCBOuterScenePanelManager,
        RecentRotationUtil.isSameRotation);
    })

    it('RecentEventViewModel_test_getPanGestureDirection_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(RecentRotationUtil,
        RecentRotationUtil.isSameRotation);
      when(mockFunc)().afterReturn(false);
      RecentEventViewModel.getPanGestureDirection(screenProperty, 0);
      expect(RecentEventViewModel).not().assertUndefined();
      mocker.ignoreMock(SCBOuterScenePanelManager,
        RecentRotationUtil.isSameRotation);
    })

    it('RecentEventViewModel_test_getClickAnnounceText_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentEventViewModel.getClickAnnounceText('test', true)).not().assertUndefined();
    })

    it('RecentEventViewModel_test_init_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEventViewModel.init(scContainerSession);
      expect(RecentEventViewModel).not().assertUndefined();;
    })

    it('RecentEventViewModel_test_handleHoverEvent_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEventViewModel.isNeedHoverAnimation = false;
      recentEventViewModel.handleHoverEvent(false, scContainerSession);
      expect(RecentEventViewModel).not().assertUndefined();;
    })

    it('RecentEventViewModel_test_handleHoverEvent_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEventViewModel.isNeedHoverAnimation = true;
      recentEventViewModel.handleHoverEvent(true, scContainerSession);
      expect(RecentEventViewModel).not().assertUndefined();;
    })

    it('RecentEventViewModel_test_handleTouchEvent_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEventViewModel.handleTouchEvent(touchEvent, scContainerSession);
      expect(RecentEventViewModel).not().assertUndefined();;
    })

    it('RecentEventViewModel_test_handleTouchEvent_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      touchEvent.source = SourceType.Mouse;
      recentEventViewModel.handleTouchEvent(touchEvent, scContainerSession);
      expect(RecentEventViewModel).not().assertUndefined();;
    })

    it('RecentEventViewModel_test_handleTouchEvent_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      touchEvent.type = TouchType.Cancel;
      touchEvent.source = SourceType.Unknown;
      recentEventViewModel.handleTouchEvent(touchEvent, scContainerSession);
      expect(RecentEventViewModel).not().assertUndefined();;
    })

  })
}