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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import {SCBGestureNavBarViewModel} from '../../../../../../../../../pcbase/src/main/ets/SceneBoard/gesturenavigation/viewmodel/SCBGestureNavBarViewModel';
import {NavbarPanGesture} from '../../../../../../../../../pcbase/src/main/ets/SceneBoard/gesturenavigation/viewmodel/SCBGestureNavBarViewModel';
import {
  scbEventExclusiveManager,
  SCBRotateChangeReason,
  SCBSceneSessionManager,
  GestureNavigationState,
  SCBSystemSceneSession
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ReflectionUtils } from '../../../../../../../../../pc/src/ohosTest/ets/test/ets/common/utils/ReflectionUtils';
import { NavBarEventType, CEManager } from '@ohos/frameworkwrapper';

export default function SCBGestureNavBarViewModelTest() {
  describe('SCBGestureNavBarViewModelTest', () => {
    let mocker: MockKit;
    let scbGestureNavBarViewModel: SCBGestureNavBarViewModel;
    let navbarPanGesture: NavbarPanGesture;
    let gestureEvent:GestureEvent= {
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
      velocity: 0,
      target: {
        area:{
          width: 5,
          height: 10,
          position: {
            x: 20, y: 20
          },
          globalPosition: {
            x: 50, y: 50
          },
        }
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    enum PanGestureType {
      DEFAULT = 0,
      GAME_OPERATE = 1
    }
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

    it('defaultPerationTest', 0, () => {
      navbarPanGesture.defaultPeration(null);
      navbarPanGesture.defaultPeration(gestureEvent);
      expect(navbarPanGesture instanceof NavbarPanGesture).assertTrue();
    })

    it('handleOnActionStartOneTest', 0, () => {
      let mockIsExclusive: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockIsExclusive)([ArgumentMatchers.any]).afterReturn(true);
      let fingerList: FingerInfo[] = [{
        id: 2,
        globalX: 20,
        globalY: 20,
        localX: 50,
        localY: 50,
        displayX: 60.34,
        displayY: 60.34,
      }];
      gestureEvent.fingerList = fingerList
      navbarPanGesture.handleOnActionStart(gestureEvent);
      expect(navbarPanGesture instanceof NavbarPanGesture).assertTrue();
    })

    it('handleOnActionStartTwoTest', 0, () => {
      let mockIsExclusive: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockIsExclusive)([ArgumentMatchers.any]).afterReturn(false);
      ReflectionUtils.setProperty(navbarPanGesture, 'panGestureType_', PanGestureType.DEFAULT);
      navbarPanGesture.handleOnActionStart(gestureEvent);
      expect(navbarPanGesture instanceof NavbarPanGesture).assertTrue();
    })

    it('handleOnActionUpdateTest', 0, () => {
      navbarPanGesture.isIgnoreNavBarGesture = true;
      navbarPanGesture.handleOnActionUpdate(gestureEvent);
      navbarPanGesture.isIgnoreNavBarGesture = false;
      ReflectionUtils.setProperty(navbarPanGesture, 'panGestureType_', PanGestureType.DEFAULT);
      navbarPanGesture.handleOnActionUpdate(gestureEvent);
      expect(navbarPanGesture instanceof NavbarPanGesture).assertTrue();
    })

    it('handleOnActionEndTest', 0, () => {
      navbarPanGesture.isIgnoreNavBarGesture = true;
      navbarPanGesture.handleOnActionEnd(gestureEvent);
      navbarPanGesture.isIgnoreNavBarGesture = false;
      navbarPanGesture.isGestureNavBarCancel = true;
      navbarPanGesture.handleOnActionEnd(gestureEvent);
      navbarPanGesture.isIgnoreNavBarGesture = false;
      navbarPanGesture.isGestureNavBarCancel = false;
      ReflectionUtils.setProperty(navbarPanGesture, 'panGestureType_', PanGestureType.DEFAULT);
      navbarPanGesture.handleOnActionEnd(gestureEvent);
      expect(navbarPanGesture instanceof NavbarPanGesture).assertTrue();
    })

    it('handleOnActionCancelTest', 0, () => {
      navbarPanGesture.isIgnoreNavBarGesture = true;
      navbarPanGesture.handleOnActionCancel();
      navbarPanGesture.isIgnoreNavBarGesture = false;
      ReflectionUtils.setProperty(navbarPanGesture, 'panGestureType_', PanGestureType.DEFAULT);
      navbarPanGesture.handleOnActionCancel();
      expect(navbarPanGesture instanceof NavbarPanGesture).assertTrue();
    })

    it('rotateAnimaChangeCallBackTest',0 , (): void => {
      (scbGestureNavBarViewModel as object)['rotateAnimaChangeCallBack'](SCBRotateChangeReason.ROTATE_BEGIN)
      (scbGestureNavBarViewModel as object)['rotateAnimaChangeCallBack'](SCBRotateChangeReason.ROTATE_END)
      (scbGestureNavBarViewModel as object)['rotateAnimaChangeCallBack'](SCBRotateChangeReason.UNSPECIFIED)
      expect(scbGestureNavBarViewModel instanceof SCBGestureNavBarViewModel).assertTrue();
    })

    it('publishScenePanelEventMsgTest',0 , (): void => {
      let parameters: Record<string, Object> = {
        "data": NavBarEventType.EXECUTE_HOME
      };
      (scbGestureNavBarViewModel as object)['publishScenePanelEventMsg'](CEManager.CUSTOM_NAVBAR_EVENT, NavBarEventType.NAVBAR_UP,parameters)
      expect(scbGestureNavBarViewModel instanceof SCBGestureNavBarViewModel).assertTrue();
    })

    it('processNavigationEventTest',0 , (): void => {
      scbGestureNavBarViewModel.processNavigationEvent(GestureNavigationState.START, gestureEvent);
      scbGestureNavBarViewModel.processNavigationEvent(GestureNavigationState.UPDATE, gestureEvent);
      scbGestureNavBarViewModel.processNavigationEvent(GestureNavigationState.END, gestureEvent);
      scbGestureNavBarViewModel.processNavigationEvent(GestureNavigationState.CANCEL, gestureEvent);
      expect(scbGestureNavBarViewModel instanceof SCBGestureNavBarViewModel).assertTrue();
    })

  })
}