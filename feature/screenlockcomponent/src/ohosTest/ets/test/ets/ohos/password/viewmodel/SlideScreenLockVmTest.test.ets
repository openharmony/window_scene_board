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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  KeyguardStatusService,
  PowerUtils,
  ScreenLockToDesktopConsts,
  slClockOneShotToDesktopService,
  ScreenLockUnlockService,
  GlobalStatusCache,
  SlUnlockReportHelper,
  ScreenLockStateManager,
  ClockAodAndDesktopConsts
} from '@ohos/screenlockcommon';
import Constants from '../../../../../../../main/ets/common/Constants';
import display from '@ohos.display';
import SlideScreenLockVm from '../../../../../../../main/ets/password/viewmodel/SlideScreenLockVm'
import { slStateHelper } from '../../../../../../../main/ets/common/helper/SlStateHelper';
import { BlurFreezeScene, ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';

export default function SlideScreenLockVmTest() {
  let slideScreenLockVm: SlideScreenLockVm = new SlideScreenLockVm(1);
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

  let fingerInfo: FingerInfo = {
    id: 0,
    globalX: 0,
    globalY: 0,
    localX: -1,
    localY: 0,
    displayX: 0,
    displayY: 0
  };

  let gestureEvent: GestureEvent = {
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
    timestamp: 0,
    source: SourceType.Unknown,
    pressure: 0,
    tiltX: 0,
    tiltY: 0,
    sourceTool: SourceTool.Unknown,
    target: {
      area: {
        width: 0, height: 0, position: { x: 0, y: 0 }, globalPosition: { x: 0, y: 0 }
      }
    }
  };

  describe('SlideScreenLockVmTest', () => {
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

    it('test_SlideScreenLockVmTest_viewModelInit', 0, () => {
      let resetAnimation: Function = () => {};
      let slideAnimation: Function = () => {};
      let slideToPwdInput: Function = () => {};
      slideScreenLockVm.viewModelInit(resetAnimation, slideAnimation, slideToPwdInput);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_serviceInit', 0, () => {
      slideScreenLockVm.serviceInit();
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_viewModelDestroy', 0, () => {
      slideScreenLockVm.viewModelDestroy();
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_handleTouchEvent', 0, () => {
      touchEvent.type = TouchType.Down;
      slideScreenLockVm.handleTouchEvent(touchEvent, 0);
      expect(slideScreenLockVm).not().assertUndefined();
      (slideScreenLockVm as object)['hasTouchDown'] = false;
      touchEvent.type = TouchType.Move;
      slideScreenLockVm.handleTouchEvent(touchEvent, 1);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.type = TouchType.Up;
      slideScreenLockVm.handleTouchEvent(touchEvent, 2);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.type = TouchType.Cancel;
      slideScreenLockVm.handleTouchEvent(touchEvent, 3);
      expect(slideScreenLockVm).not().assertUndefined();
      slideScreenLockVm.handleTouchEvent(touchEvent, 4);
      expect(slideScreenLockVm).not().assertUndefined();
      slideScreenLockVm.handleTouchEvent(touchEvent, 5);
      expect(slideScreenLockVm).not().assertUndefined();
      slideScreenLockVm.handleTouchEvent(touchEvent, 6);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_resetTouchStatus', 0, () => {
      slideScreenLockVm.resetTouchStatus();
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_showInfo', 0, () => {
      touchEvent.type = TouchType.Up;
      (slideScreenLockVm as object)['showInfo']('abc', touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_showInfo1', 0, () => {
      touchEvent.type = TouchType.Move;
      (slideScreenLockVm as object)['showInfo']('abc', touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_handleEventMove', 0, () => {
      let mocker: MockKit = new MockKit();
      (slideScreenLockVm as object)['firstTouchId'] = 1;
      touchEvent.touches = [{
        type: TouchType.Move,
        id:  0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0,
      }];
      let mockFuc: Function = mocker.mockFunc(slideScreenLockVm, (slideScreenLockVm as object)['isUnlockWithoutPwd']);
      (slideScreenLockVm as object)['handleEventMove'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.touches[0].id = 1;
      when(mockFuc)().afterReturn(true);
      (slideScreenLockVm as object)['handleEventMove'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.touches[0].id = 1;
      when(mockFuc)().afterReturn(false);
      (slideScreenLockVm as object)['handleEventMove'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined()
      touchEvent.touches[0].id = 1;
      when(mockFuc)().afterReturn(false);
      (slideScreenLockVm as object)['handleEventMove'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined()
      touchEvent.touches[0].id = 1;
      touchEvent.touches[0].screenX = 200;
      touchEvent.touches[0].screenY = 200;
      when(mockFuc)().afterReturn(true);
      (slideScreenLockVm as object)['handleEventMove'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined()
      touchEvent.touches[0].id = 1;
      touchEvent.touches[0].screenX = 200;
      touchEvent.touches[0].screenY = 200;
      when(mockFuc)().afterReturn(false);
      (slideScreenLockVm as object)['handleEventMove'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined()
      touchEvent.touches[0].id = 1;
      touchEvent.touches[0].screenX = 300;
      touchEvent.touches[0].screenY = 20;
      when(mockFuc)().afterReturn(true);
      (slideScreenLockVm as object)['handleEventMove'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined()
      touchEvent.touches[0].id = 1;
      touchEvent.touches[0].screenX = 300;
      touchEvent.touches[0].screenY = 300;
      when(mockFuc)().afterReturn(false);
      (slideScreenLockVm as object)['handleEventMove'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined()
      mocker.ignoreMock(slideScreenLockVm, (slideScreenLockVm as object)['isUnlockWithoutPwd']);
    })

    it('test_SlideScreenLockVmTest_handSlideAnimation', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(slideScreenLockVm, (slideScreenLockVm as object)['isUnlockWithoutPwd']);
      (slideScreenLockVm as object)['slideDistance'] = 5;
      (slideScreenLockVm as object)['handSlideAnimation'](1, 1, 1, 1, 1, 1);
      expect(slideScreenLockVm).not().assertUndefined();
      (slideScreenLockVm as object)['slideDistance'] = 20;
      (slideScreenLockVm as object)['isOneShotAvaiOnMove'] = true;
      when(mockFuc)().afterReturn(true);
      (slideScreenLockVm as object)['handSlideAnimation'](1, 1, 1, 1, 1, 1);
      expect(slideScreenLockVm).not().assertUndefined();
      (slideScreenLockVm as object)['slideDistance'] = 20;
      (slideScreenLockVm as object)['isOneShotAvaiOnMove'] = false;
      when(mockFuc)().afterReturn(false);
      (slideScreenLockVm as object)['handSlideAnimation'](1, 1, 1, 1, 1, 1);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_handleEventDown', 0, () => {
      (slideScreenLockVm as object)['handleEventDown'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_handleEventUp', 0, () => {
      let mocker: MockKit = new MockKit();
      (slideScreenLockVm as object)['firstTouchId'] = 1;
      touchEvent.touches = [{
        type: TouchType.Move,
        id:  0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0,
      }];
      let mockFuc: Function = mocker.mockFunc(slideScreenLockVm, (slideScreenLockVm as object)['isUnlockWithoutPwd']);
      (slideScreenLockVm as object)['handleEventUp'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.touches[0].id = 1;
      slideScreenLockVm.resetTouchStatus();
      (slideScreenLockVm as object)['handleEventUp'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.touches[0].id = 1;
      (slideScreenLockVm as object)['hasTouchDown'] = true;
      touchEvent.touches[0].screenX = 200;
      touchEvent.touches[0].screenY = 200;
      when(mockFuc)().afterReturn(true);
      (slideScreenLockVm as object)['handleEventUp'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.touches[0].id = 1;
      (slideScreenLockVm as object)['hasTouchDown'] = true;
      touchEvent.touches[0].screenX = 200;
      touchEvent.touches[0].screenY = 200;
      when(mockFuc)().afterReturn(false);
      (slideScreenLockVm as object)['handleEventUp'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.touches[0].id = 1;
      (slideScreenLockVm as object)['hasTouchDown'] = true;
      touchEvent.touches[0].screenX = 10;
      touchEvent.touches[0].screenY = 10;
      (slideScreenLockVm as object)['handleEventUp'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      mocker.ignoreMock(slideScreenLockVm, (slideScreenLockVm as object)['isUnlockWithoutPwd']);
    })

    it('test_SlideScreenLockVmTest_unlockEvent', 0, () => {
      slideScreenLockVm.unlockEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_unlockEvent1', 0, () => {
      touchEvent.touches = [{
        type: TouchType.Move,
        id:  0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0,
      }, {
        type: TouchType.Up,
        id:  0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0,
      }];
      slideScreenLockVm.unlockEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_unlockEvent2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(GlobalStatusCache.getInstance(), GlobalStatusCache.getInstance().getStatus);
      touchEvent.touches = [{
        type: TouchType.Move,
        id:  0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0,
      }];
      when(mockFuc)().afterReturn(true);
      slideScreenLockVm.unlockEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      mocker.ignoreMock(GlobalStatusCache.getInstance(), GlobalStatusCache.getInstance().getStatus);
    })

    it('test_SlideScreenLockVmTest_unlockEvent3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(GlobalStatusCache.getInstance(), GlobalStatusCache.getInstance().getStatus);
      touchEvent.touches = [{
        type: TouchType.Move,
        id:  0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0,
      }];
      when(mockFuc)().afterReturn(false);
      touchEvent.type = TouchType.Move;
      slideScreenLockVm.unlockEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.type = TouchType.Down;
      slideScreenLockVm.unlockEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.type = TouchType.Cancel;
      slideScreenLockVm.unlockEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      touchEvent.type = TouchType.Up;
      slideScreenLockVm.unlockEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_unlockAodEvent', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(GlobalStatusCache.getInstance(), GlobalStatusCache.getInstance().getStatus);
      let mockFuc1: Function = mocker.mockFunc(slideScreenLockVm, (slideScreenLockVm as object)['isUnlockWithoutPwd']);
      let mockFuc2: Function =
        mocker.mockFunc(slClockOneShotToDesktopService, slClockOneShotToDesktopService.isClockOneShotAnimAvailable);
      touchEvent.touches = [{
        type: TouchType.Move,
        id:  0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0,
      }];
      when(mockFuc)().afterReturn(true);
      slideScreenLockVm.unlockAodEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      (slideScreenLockVm as object)['hasTouchDown'] = false;
      slideScreenLockVm.unlockAodEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      (slideScreenLockVm as object)['hasTouchDown'] = true;
      touchEvent.type = TouchType.Up;
      touchEvent.touches[0].screenX = 100;
      touchEvent.touches[0].screenY = 200;
      slideScreenLockVm.unlockAodEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      (slideScreenLockVm as object)['hasTouchDown'] = true;
      touchEvent.type = TouchType.Up;
      touchEvent.touches[0].screenX = 100;
      touchEvent.touches[0].screenY = 200;
      when(mockFuc1)().afterReturn(true);
      when(mockFuc2)().afterReturn(true);
      slideScreenLockVm.unlockAodEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      (slideScreenLockVm as object)['hasTouchDown'] = true;
      touchEvent.type = TouchType.Up;
      touchEvent.touches[0].screenX = 100;
      touchEvent.touches[0].screenY = 200;
      when(mockFuc1)().afterReturn(true);
      when(mockFuc2)().afterReturn(false);
      slideScreenLockVm.unlockAodEvent(touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      mocker.ignoreMock(GlobalStatusCache.getInstance(), GlobalStatusCache.getInstance().getStatus);
      mocker.ignoreMock(slideScreenLockVm, (slideScreenLockVm as object)['isUnlockWithoutPwd']);
      mocker.ignoreMock(slClockOneShotToDesktopService, slClockOneShotToDesktopService.isClockOneShotAnimAvailable);
    })

    it('test_SlideScreenLockVmTest_calculateKeyboardPosition', 0, () => {
      (slideScreenLockVm as object)['calculateKeyboardPosition'](1, 1000);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_calculateKeyboardPosition1', 0, () => {
      AppStorage.setOrCreate<number>('folderStatus', 1);
      (slideScreenLockVm as object)['calculateKeyboardPosition'](300, 10);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_calculateKeyboardPosition2', 0, () => {
      AppStorage.setOrCreate<number>('folderStatus', 0);
      (slideScreenLockVm as object)['calculateKeyboardPosition'](300, 10);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_calculateKeyboardPosition3', 0, () => {
      AppStorage.setOrCreate<number>('folderStatus', 1);
      (slideScreenLockVm as object)['calculateKeyboardPosition'](1, 1000);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_calculateKeyboardPosition4', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      let mockFuc1: Function = mocker.mockFunc(KeyguardStatusService, KeyguardStatusService.isSpecialMode);
      when(mockFuc)().afterReturn(false);
      (slideScreenLockVm as object)['calculateKeyboardPosition'](300, 10);
      expect(slideScreenLockVm).not().assertUndefined();
      when(mockFuc1)().afterReturn(true);
      (slideScreenLockVm as object)['calculateKeyboardPosition'](300, 10);
      expect(slideScreenLockVm).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(KeyguardStatusService, KeyguardStatusService.isSpecialMode);
    })

    it('test_SlideScreenLockVmTest_pinchGestureEvent', 0, () => {
      slideScreenLockVm.pinchGestureEvent(gestureEvent, 0, () => {})
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_pinchGestureEvent1', 0, () => {
      gestureEvent.fingerList = [fingerInfo, fingerInfo];
      slideScreenLockVm.pinchGestureEvent(gestureEvent, 0, () => {})
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_pinchGestureEvent2', 0, () => {
      gestureEvent.fingerList = [fingerInfo, fingerInfo];
      gestureEvent.fingerList[0].globalX = 3;
      gestureEvent.fingerList[0].globalY = 3;
      gestureEvent.fingerList[1].globalX = 1;
      gestureEvent.fingerList[1].globalY = 1;
      slideScreenLockVm.pinchGestureEvent(gestureEvent, 1, () => {})
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_pinchGestureEvent3', 0, () => {
      gestureEvent.fingerList = [fingerInfo, fingerInfo];
      gestureEvent.fingerList[0].globalX = 3;
      gestureEvent.fingerList[0].globalY = 3;
      gestureEvent.fingerList[1].globalX = 1;
      gestureEvent.fingerList[1].globalY = 1;
      (slideScreenLockVm as object)['pinchGesStartFingerDistance'] = 100;
      slideScreenLockVm.pinchGestureEvent(gestureEvent, 1, () => {})
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_pinchGestureEvent4', 0, () => {
      gestureEvent.fingerList = [fingerInfo, fingerInfo];
      slideScreenLockVm.pinchGestureEvent(gestureEvent, 2, () => {})
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_pinchGestureEvent5', 0, () => {
      gestureEvent.fingerList = [fingerInfo, fingerInfo];
      slideScreenLockVm.pinchGestureEvent(gestureEvent, 3, () => {})
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_pinchFingerDistance', 0, () => {
      (slideScreenLockVm as object)['pinchFingerDistance'](undefined, undefined);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_setSlidState', 0, () => {
      slideScreenLockVm.setSlidState(false);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_setSlidState1', 0, () => {
      slideScreenLockVm.setSlidState(true);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_getSlBindState', 0, () => {
      let slBindState: ISlState | undefined = slStateHelper.getSlBindState();
      (slideScreenLockVm as object)['slBindState'] = slBindState;
      (slideScreenLockVm as object)['getSlBindState']();
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_getSlBindState1', 0, () => {
      let slBindState: ISlState | undefined = undefined;
      (slideScreenLockVm as object)['slBindState'] = slBindState;
      (slideScreenLockVm as object)['getSlBindState']();
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_setSlideDistance', 0, () => {
      (slideScreenLockVm as object)['setSlideDistance'](100);
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_isUnlockWithoutPwd', 0, () => {
      (slideScreenLockVm as object)['isUnlockWithoutPwd']();
      expect(slideScreenLockVm).not().assertUndefined();
    })

    it('test_SlideScreenLockVmTest_checkSlideTouchState', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(slideScreenLockVm, (slideScreenLockVm as object)['isSupportSlide']);
      when(mockFuc)().afterReturn(false);
      (slideScreenLockVm as object)['checkSlideTouchState'](touchEvent);
      expect(slideScreenLockVm).not().assertUndefined();
      mocker.ignoreMock(slideScreenLockVm, (slideScreenLockVm as object)['isSupportSlide']);
    })

    it('test_SlideScreenLockVmTest_resetOneShotAnimation', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(slideScreenLockVm, (slideScreenLockVm as object)['isUnlockWithoutPwd']);
      when(mockFuc)().afterReturn(true);
      (slideScreenLockVm as object)['isOneShotAvaiOnMove'] = true;
      (slideScreenLockVm as object)['resetOneShotAnimation']();
      expect(slideScreenLockVm).not().assertUndefined();
      mocker.ignoreMock(slideScreenLockVm, (slideScreenLockVm as object)['isUnlockWithoutPwd']);
    })

    it('test_SlideScreenLockVmTest_getKeyboardPosByGrid', 0, () => {
      let position:number = Constants.NO_TOUCH_OR_SCREEN_MIDDLE;
      position = (slideScreenLockVm as object)['getKeyboardPosByGrid'](1, 2, 3, 4);
      expect(position).assertEqual(Constants.SCREEN_LEFT);
      position = (slideScreenLockVm as object)['getKeyboardPosByGrid'](5, 6, 3, 4);
      expect(position).assertEqual(Constants.SCREEN_RIGHT);
      position = (slideScreenLockVm as object)['getKeyboardPosByGrid'](3.1, 3.9, 3, 4);
      expect(position).assertEqual(Constants.NO_TOUCH_OR_SCREEN_MIDDLE);
    })

    it('test_SlideScreenLockVmTest_getGridPosByKeyboardWidth', 0, () => {
      let gridPos:number = (slideScreenLockVm as object)['getGridPosByKeyboardWidth'](0.5);
      expect(gridPos).assertEqual(0.375);
    })
  })
}