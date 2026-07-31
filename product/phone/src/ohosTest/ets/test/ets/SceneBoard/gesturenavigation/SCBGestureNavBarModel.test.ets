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
import { SendTouchEventController } from '@ohos/windowscene/Index';

import {
  GestureNavigationState,
  SCBRotateChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  ScenePanelState
} from '@ohos/windowscene';
import { viewMgrPolicy } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
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
import { DesktopModeManager, SystemBarChangeType } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { SCBNaviBarConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/SCBNaviBarConstants';

import {
  NavbarPanGesture,
  PanGestureType,
  SCBGestureNavBarViewModel,
} from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/SCBGestureNavBarViewModel';
import { SystemSceneConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/SystemSceneConstants';
import { NAVIBarViewData } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarViewData';
import { NAVIBarViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarViewModel';
export default function SCBGestureNavBarModelSTest() {
  describe('SCBGestureNavBarModelSTest', () => {
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

    let navBarViewModel: SCBGestureNavBarViewModel = new SCBGestureNavBarViewModel();
    let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
    let naviBarViewModel: NAVIBarViewModel = NAVIBarViewModel.getInstance(new SCBScreenProperty());

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

    let gestureEvent: GestureEvent = {
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
    }

    it('SCBGestureNavBarViewModel_registerRotateAnimaChangeCallBack_1', 0, (): void => {
      navBarViewModel.registerRotateAnimaChangeCallBack();
      expect(navBarViewModel).not().assertUndefined();
    })

    it('SCBGestureNavBarViewModel_checkEnableAntiTouchStatus_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(navBarViewModel,
        navBarViewModel.checkGameStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      naviBarViewData.isShowingNaviBar = false;
      navBarViewModel.checkEnableAntiTouchStatus();
      expect(navBarViewModel).not().assertUndefined();
      mocker.clear(navBarViewModel);
    })

    it('SCBGestureNavBarViewModel_checkEnableAntiTouchStatus_2', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(navBarViewModel,
        navBarViewModel.checkGameStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      naviBarViewData.isShowingNaviBar = true;
      navBarViewModel.checkEnableAntiTouchStatus();
      expect(navBarViewModel).not().assertUndefined();
      mocker.clear(navBarViewModel);
    })

    it('SCBGestureNavBarViewModel_getWindowHeight_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(navBarViewModel.getWindowHeight(SystemSceneConstants.DEFAULT_HEIGHT) !== undefined).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('SCBGestureNavBarViewModel_getWindowHeight_2', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(navBarViewModel.getWindowHeight(SystemSceneConstants.DEFAULT_HEIGHT) !== undefined).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('SCBGestureNavBarViewModel_processNavigationEvent_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(navBarViewModel.processNavigationEvent(GestureNavigationState.START, gestureEvent) === undefined)
        .assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureNavBarViewModel_processNavigationEvent_2', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(navBarViewModel.processNavigationEvent(GestureNavigationState.START, gestureEvent) === undefined)
        .assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureNavBarViewModel_processNavigationEvent_3', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(navBarViewModel.processNavigationEvent(GestureNavigationState.START, gestureEvent) === undefined)
        .assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureNavBarViewModel_processNavigationEvent_4', 0, (): void => {
      navBarViewModel.processNavigationEvent(GestureNavigationState.UPDATE, gestureEvent);
      expect(navBarViewModel).not().assertUndefined();
    })

    it('SCBGestureNavBarViewModel_processNavigationEvent_5', 0, (): void => {
      (navBarViewModel as object)['isSendToSCBScenePanel'] = true;
      navBarViewModel.processNavigationEvent(GestureNavigationState.UPDATE, gestureEvent);
      expect(navBarViewModel).not().assertUndefined();
    })

    it('SCBGestureNavBarViewModel_processNavigationEvent_6', 0, (): void => {
      navBarViewModel.processNavigationEvent(GestureNavigationState.END, gestureEvent);
      expect(navBarViewModel).not().assertUndefined();
    })

    it('SCBGestureNavBarViewModel_processNavigationEvent_7', 0, (): void => {
      (navBarViewModel as object)['isSendToSCBScenePanel'] = true;
      navBarViewModel.processNavigationEvent(GestureNavigationState.END, gestureEvent);
      expect(navBarViewModel).not().assertUndefined();
    })

    it('SCBGestureNavBarViewModel_processNavigationEvent_8', 0, (): void => {
      navBarViewModel.processNavigationEvent(GestureNavigationState.CANCEL, gestureEvent);
      expect(navBarViewModel).not().assertUndefined();
    })

    it('SCBGestureNavBarViewModel_processNavigationEvent_9', 0, (): void => {
      (navBarViewModel as object)['isSendToSCBScenePanel'] = true;
      navBarViewModel.processNavigationEvent(GestureNavigationState.CANCEL, gestureEvent);
      expect(navBarViewModel).not().assertUndefined();
    })

    it('SCBGestureNavBarViewModel_processBackEvent_2', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(navBarViewModel.processBackEvent(gestureEvent) === undefined).assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureNavBarViewModel_processBackEvent_3', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(navBarViewModel.processBackEvent(gestureEvent) === undefined).assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureNavBarViewModel_recordLongPressLog_1', 0, (): void => {
      expect(navBarViewModel.recordLongPressLog('tag') === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_recordLongPressLog_2', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(navBarViewModel.recordLongPressLog('tag', gestureEvent) === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
    })

    it('SCBGestureNavBarViewModel_recordLongPressLog_3', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(navBarViewModel.recordLongPressLog('tag', gestureEvent) === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
    })

    it('SCBGestureNavBarViewModel_navBarOnTouch_1', 0, (): void => {
      expect(navBarViewModel.navBarOnTouch(touchEvent, true) === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_navBarOnTouch_2', 0, (): void => {
      touchEvent.type = TouchType.Down;
      expect(navBarViewModel.navBarOnTouch(touchEvent, false) === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_navBarOnTouch_3', 0, (): void => {
      touchEvent.type = TouchType.Up;
      expect(navBarViewModel.navBarOnTouch(touchEvent, true) === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_navBarOnTouch_4', 0, (): void => {
      touchEvent.type = TouchType.Move;
      expect(navBarViewModel.navBarOnTouch(touchEvent, true) === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_navBarOnTouch_5', 0, (): void => {
      touchEvent.type = TouchType.Up;
      expect(navBarViewModel.navBarOnTouch(touchEvent, false) === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_navBarOnTouch_6', 0, (): void => {
      touchEvent.type = TouchType.Cancel;
      expect(navBarViewModel.navBarOnTouch(touchEvent, false) === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_navBarOnTouch_7', 0, (): void => {
      touchEvent.type = TouchType.Down;
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(navBarViewModel, navBarViewModel.upOrCancelTouch);
      when(mockFunc)().afterReturn(false);
      expect(navBarViewModel.navBarOnTouch(touchEvent, false) === undefined).assertTrue();
      mocker.ignoreMock(navBarViewModel, navBarViewModel.upOrCancelTouch);
    })

    it('SCBGestureNavBarViewModel_upOrCancelTouch_1', 0, (): void => {
      expect(navBarViewModel.upOrCancelTouch(TouchType.Up) !== undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_upOrCancelTouch_2', 0, (): void => {
      expect(navBarViewModel.upOrCancelTouch(TouchType.Cancel) !== undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_upOrCancelTouch_3', 0, (): void => {
      expect(navBarViewModel.upOrCancelTouch(TouchType.Down) !== undefined).assertTrue();
    })

    it('NavbarPanGesture_checkAndSetPerationType_001', 0, () => {
      let sendTouchEventController: SendTouchEventController | null = null
      let navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
      let navbarPanGesture = new NavbarPanGesture(navBarViewModel, sendTouchEventController);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      navbarPanGesture.initParam(true); // naviBarIsShowInStart_ = true
      expect(navbarPanGesture.panGestureType).assertEqual(PanGestureType.DEFAULT);
      navbarPanGesture.checkAndSetPerationType(screenProperty);
    })

    it('NavbarPanGesture_checkAndSetPerationType_002', 0, () => {
      let sendTouchEventController: SendTouchEventController | null = null
      let navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
      let navbarPanGesture = new NavbarPanGesture(navBarViewModel, sendTouchEventController);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      navbarPanGesture.initParam(false); // naviBarIsShowInStart_ = false
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(navBarViewModel, navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(navbarPanGesture.checkAndSetPerationType(screenProperty) === undefined).assertTrue();
      mocker.ignoreMock(navBarViewModel, navBarViewModel.checkEnableAntiTouchStatus);
    })

    it('NavbarPanGesture_checkAndSetPerationType_003', 0, () => {
      let sendTouchEventController: SendTouchEventController | null = null
      let navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
      let navbarPanGesture = new NavbarPanGesture(navBarViewModel, sendTouchEventController);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      navbarPanGesture.initParam(false); // naviBarIsShowInStart_ = false
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarViewModel, naviBarViewModel.isConfigureMisTouchAppActive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(navbarPanGesture.checkAndSetPerationType(screenProperty) === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.isConfigureMisTouchAppActive);
    })

    it('NavbarPanGesture_accidentalTouchPeration_001', 0, () => {
      let sendTouchEventController: SendTouchEventController | null = null
      let navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
      let navbarPanGesture = new NavbarPanGesture(navBarViewModel, sendTouchEventController);
      expect(navbarPanGesture.accidentalTouchPeration(touchEvent) === undefined).assertTrue();
    })

    it('NavbarPanGesture_defaultPeration_001', 0, () => {
      let sendTouchEventController: SendTouchEventController | null = null
      let navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
      let navbarPanGesture = new NavbarPanGesture(navBarViewModel, sendTouchEventController);
      let gestureEvent = null;
      expect(navbarPanGesture.defaultPeration(gestureEvent) === undefined).assertTrue();
    })

    it('NavbarPanGesture_defaultPeration_002', 0, () => {
      let sendTouchEventController: SendTouchEventController | null = null;
      let navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
      let navbarPanGesture = new NavbarPanGesture(navBarViewModel, sendTouchEventController);
      expect(navbarPanGesture.defaultPeration(gestureEvent) === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_sendNavigationEvent_001', 0, () => {
      let viewModel: SCBGestureNavBarViewModel = new SCBGestureNavBarViewModel();
      expect(viewModel.processNavigationEvent(1, gestureEvent) === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_rotateAnimaChangeCallBack_1', 0, () => {
      let viewModel: SCBGestureNavBarViewModel = new SCBGestureNavBarViewModel();
      let screenProperty = new SCBScreenProperty();
      let reason = SCBRotateChangeReason.ROTATE_BEGIN;
      expect((viewModel as object)['rotateAnimaChangeCallBack'](screenProperty, reason) === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_rotateAnimaChangeCallBack_2', 0, () => {
      let viewModel: SCBGestureNavBarViewModel = new SCBGestureNavBarViewModel();
      let screenProperty = new SCBScreenProperty();
      let reason = SCBRotateChangeReason.ROTATE_BEGIN;
      expect((viewModel as object)['rotateAnimaChangeCallBack'](screenProperty, reason) === undefined).assertTrue();
    })

    it('SCBGestureNavBarViewModel_rotateAnimaChangeCallBack_3', 0, () => {
      let viewModel: SCBGestureNavBarViewModel = new SCBGestureNavBarViewModel();
      let screenProperty = new SCBScreenProperty();
      let reason = SCBRotateChangeReason.UNSPECIFIED;
      expect((viewModel as object)['rotateAnimaChangeCallBack'](screenProperty, reason) === undefined).assertTrue();
    })
  })
}