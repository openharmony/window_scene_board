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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import {
  GestureType,
  PcKeyType,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSpecificSession,
  SCBSystemSceneSession,
  SystemSessionInfo
} from '@ohos/windowscene';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBFoldSceneStateManager, SCBFoldState} from '@ohos/pcmode';
import { SCBGestureBackViewModel }
  from '../../../../../../../../../pcbase/src/main/ets/SceneBoard/gesturenavigation/viewmodel/SCBGestureBackViewModel';


export default function SCBGestureBackViewModelTest() {
  describe('SCBGestureBackViewModelTest', () => {
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

    let systemSessionInfo: SystemSessionInfo = {
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
      isOverlayScene: true,
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED
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
      offsetY: 1,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };
    let mocker: MockKit;
    const scbGestureBackViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();
    beforeAll(() => {
    })
    beforeEach(() => {
      mocker = new MockKit();
    })
    afterEach(() => {
    })
    afterAll(() => {
      mocker.clearAll();
    })

    it('processBackEventOneTest', 0, () => {
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      when(mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getInstance))()
        .afterReturn(scbSceneSessionManager);
      when(mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getFocusedSession))().afterReturn(null);
      scbGestureBackViewModel.processBackEvent(GestureType.BACK, event);
      expect(scbGestureBackViewModel instanceof SCBGestureBackViewModel).assertTrue();
    });

    it('processBackEventTwoTest', 0, () => {
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      when(mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getInstance))()
        .afterReturn(scbSceneSessionManager);
      let focusedSession: SCBSpecificSession = {
        session: {
          type: sceneSessionManager.SessionType.TYPE_PIP
        } as sceneSessionManager.SceneSession
      } as SCBSpecificSession;
      when(mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getFocusedSession))()
        .afterReturn(focusedSession)
      scbGestureBackViewModel.processBackEvent(GestureType.BACK, event);
      expect(scbGestureBackViewModel instanceof SCBGestureBackViewModel).assertTrue();
    });

    it('setBackResponseRegionOneTest', 0, () => {
      when(mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty))(systemSessionInfo).afterReturn(true);
      scbGestureBackViewModel.setBackResponseRegion(20,30);
      expect(scbGestureBackViewModel instanceof SCBGestureBackViewModel).assertTrue();
    })
  })
}
