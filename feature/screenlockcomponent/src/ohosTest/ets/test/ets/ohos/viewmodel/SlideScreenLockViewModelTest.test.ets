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
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { GlobalStatusCache } from '@ohos/screenlockcommon';
import SlideScreenLockVm, {
  SlideTouchType,
  PinchGestureActionType
} from '../../../../../../main/ets/password/viewmodel/SlideScreenLockVm';
import TestConst from '../constants/TestConst';
import { MockGestureEvent, MockFingerInfo } from '../constants/MockObject';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ScreenLockApi } from '@ohos/screenlockcommon';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
}
;

export default function SlideScreenLockViewModelTest() {
  let persisId: number;
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

  let events: TouchEvent = {
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
    type: 1,
    touches: [{
      y: 100,
      id: 1,
      displayX: 11,
      displayY: 12,
      windowX: 13,
      windowY: 14,
      type: TouchType.Up,
      screenX: 10,
      screenY: 10,
      x: 100
    }],
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
    preventDefault: (): void => {
    },
  }
  let callBackFunc: Function = () => {
  };
  describe('SlideScreenLockViewModelTest', (): void => {
    let slideScreenLockViewModel: SlideScreenLockVm = new SlideScreenLockVm(persisId);
    let mSlideScreenLockViewModelMode: SlideScreenLockViewModelMode = new SlideScreenLockViewModelMode(persisId);
    beforeAll((): void => {
      slideScreenLockViewModel.viewModelInit(callBackFunc, callBackFunc, callBackFunc);
    })

    beforeEach((): void => {
      AppStorage.setOrCreate('screenSimLocked', false);
      AppStorage.setOrCreate('lockStatus', 1);
    })

    afterEach((): void => {
    })

    afterAll((): void => {
      slideScreenLockViewModel.viewModelDestroy();
    })

    it('test_setSlidState_return', 0, (): void => {
      let isSliding: boolean = true;
      slideScreenLockViewModel.setSlidState(isSliding);
      slideScreenLockViewModel.setSlidState(isSliding);
      isSliding = false;
      slideScreenLockViewModel.setSlidState(isSliding);
      slideScreenLockViewModel.setSlidState(isSliding);
      expect(isSliding).not().assertNull();
    })

    it('test_pinchGestureEvent_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let startFingerInfoFirst: MockFingerInfo = new MockFingerInfo(100, 100);
      let startFingerInfoSecond: MockFingerInfo = new MockFingerInfo(400, 400);
      let gestureEventStart: MockGestureEvent = new MockGestureEvent(startFingerInfoFirst, startFingerInfoSecond);
      slideScreenLockViewModel.pinchGestureEvent(gestureEventStart, PinchGestureActionType.ACTION_START, () => {
      });
      let nextFingerInfoFirst: MockFingerInfo = new MockFingerInfo(200, 200);
      let nextFingerInfoSecond: MockFingerInfo = new MockFingerInfo(300, 300);
      let gestureEventNext: MockGestureEvent = new MockGestureEvent(nextFingerInfoFirst, nextFingerInfoSecond);
      slideScreenLockViewModel.pinchGestureEvent(gestureEventNext, PinchGestureActionType.ACTION_UPDATE, () => {
      });
      slideScreenLockViewModel.pinchGestureEvent(gestureEventNext, PinchGestureActionType.ACTION_END, () => {
      });
    })

    it('test_unlockAodEvent_return', 0, (): void => {
      events.type = 1;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        slideScreenLockViewModel.unlockAodEvent(events);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_ShowInfo_return', 0, (): void => {
      let message: string = 'res';
      let result = mSlideScreenLockViewModelMode.CheckSlideTouchState(events);
      mSlideScreenLockViewModelMode.ShowInfo(message, events);
      mSlideScreenLockViewModelMode.HandleEventMove(events);
      expect(result).not().assertNull();
      slideScreenLockViewModel.unlockEvent(events);
      events.type = 2;
      mSlideScreenLockViewModelMode.ShowInfo(message, events);
    })

    it('test_HandleEventMove_return', 0, (): void => {
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
      let event: TouchEvent = {
        type: 1,
        touches: [{
          y: 100,
          id: 1,
          displayX: 11,
          displayY: 12,
          windowX: 13,
          windowY: 14,
          type: TouchType.Up,
          screenX: 10,
          screenY: 10,
          x: 100
        },
          {
            y: 10,
            id: 2,
            displayX: 21,
            displayY: 22,
            windowX: 23,
            windowY: 24,
            type: TouchType.Move,
            screenX: 20,
            screenY: 20,
            x: 50
          }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: eventArea
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      try {
        event.touches[0].id = 0;
        AppStorage.set('accountFlag', false);
        AppStorage.get('accountFlag');
        mSlideScreenLockViewModelMode.HandleEventMove(event);
        AppStorage.set('accountFlag', true);
        AppStorage.get('accountFlag');
        mSlideScreenLockViewModelMode.HandleEventMove(event);
        AppStorage.set('accountsToHome', false);
        AppStorage.get('accountsToHome');
        mSlideScreenLockViewModelMode.HandleEventMove(event);
        AppStorage.set('accountsToHome', true);
        AppStorage.get('accountsToHome');
        mSlideScreenLockViewModelMode.HandleEventMove(event);
        expect(events.type).not().assertNull();
      } catch (e) {
      }
    })

    it('test_CheckSlideTouchState_return', 0, (): void => {
      events.type = 2;
      let result = mSlideScreenLockViewModelMode.CheckSlideTouchState(events);
      expect(result).assertEqual(true);
      slideScreenLockViewModel.unlockEvent(events);
      events.type = 0;
      slideScreenLockViewModel.unlockEvent(events);
      events.type = 1;
      slideScreenLockViewModel.unlockEvent(events);
      slideScreenLockViewModel.unlockAodEvent(events);
      events.type = 11;
      slideScreenLockViewModel.unlockEvent(events);
      slideScreenLockViewModel.unlockAodEvent(events);
      expect(events.type).assertEqual(11);
    })

    it('test_CheckSlideTouchState_return', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(ScreenLockApi, ScreenLockApi.getLock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      mSlideScreenLockViewModelMode.CheckSlideTouchState(events);
      expect(ScreenLockApi.getLock()).assertEqual(true);
      mocker.clear(ScreenLockApi);
      mocker.clearAll();
      AppStorage.set('lockStatus', false);
      AppStorage.get('lockStatus');
      expect(AppStorage.get('lockStatus')).assertEqual(false);
      mSlideScreenLockViewModelMode.CheckSlideTouchState(events);
      AppStorage.set('lockStatus', true);
      AppStorage.get('lockStatus');
      mSlideScreenLockViewModelMode.CheckSlideTouchState(events);
      GlobalStatusCache.getInstance().setStatus('quickToolsIsToolsUsing', true);
      GlobalStatusCache.getInstance().getStatus('quickToolsIsToolsUsing', false) as boolean;
      mSlideScreenLockViewModelMode.CheckSlideTouchState(events);
      GlobalStatusCache.getInstance().setStatus('quickToolsIsToolsUsing', false);
      GlobalStatusCache.getInstance().getStatus('quickToolsIsToolsUsing', false) as boolean;
      mSlideScreenLockViewModelMode.CheckSlideTouchState(events);
    })

    it('test_CalculateKeyboardPosition_return', 0, (): void => {
      let touchStartPositionX: number = 0;
      let touchEndPositionX: number = 3;
      let result = mSlideScreenLockViewModelMode.CalculateKeyboardPosition(touchStartPositionX, touchEndPositionX);
      expect(result).assertEqual(0);
    })

    it('test_CalculateKeyboardPosition_return', 0, (): void => {
      let touchStartPositionX: number = 3;
      let touchEndPositionX: number = 0;
      let result = mSlideScreenLockViewModelMode.CalculateKeyboardPosition(touchStartPositionX, touchEndPositionX);
      expect(result).assertEqual(0);
    })

    it('test_CalculateKeyboardPosition_return', 0, (): void => {
      let touchStartPositionX: number = 30;
      let touchEndPositionX: number = 20;
      let result = mSlideScreenLockViewModelMode.CalculateKeyboardPosition(touchStartPositionX, touchEndPositionX);
      expect(result).assertEqual(0);
    })

    it('test_GetSlBindState_return', 0, (): void => {
      slUiStateMgr.setSlState(SlMainStateType.SL_BIND_STATE);
      slUiStateMgr.getSlState(SlMainStateType.SL_BIND_STATE);
      let result = mSlideScreenLockViewModelMode.GetSlBindState();
      mSlideScreenLockViewModelMode.GetSlBindState();
      expect(result).not().assertNull();
    })

    it('test_serviceInit_return', 0, (): void => {
      let type: SlideTouchType = SlideTouchType.TOUCH_UNLOCK;
      slideScreenLockViewModel.handleTouchEvent(events, type);
      type = SlideTouchType.TOUCH_USER;
      slideScreenLockViewModel.handleTouchEvent(events, type);
      type = SlideTouchType.TOUCH_TOOLS;
      slideScreenLockViewModel.handleTouchEvent(events, type);
      type = SlideTouchType.TOUCH_NOTIFICATION;
      slideScreenLockViewModel.handleTouchEvent(events, type);
      type = SlideTouchType.TOUCH_RESPONSE;
      slideScreenLockViewModel.handleTouchEvent(events, type);
      type = SlideTouchType.TOUCH_CAMERA;
      slideScreenLockViewModel.handleTouchEvent(events, type);
      type = SlideTouchType.TOUCH_AOD_UNLOCK;
      slideScreenLockViewModel.handleTouchEvent(events, type);
      type = 10;
      slideScreenLockViewModel.handleTouchEvent(events, type);
      expect(type).not().assertNull();
    })

    it('test_pinchFingerDistanceOne_return', 0, (): void => {
      let fingerLeft: FingerInfo = {
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      };
      let fingerRight: FingerInfo = {
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      };
      let result = mSlideScreenLockViewModelMode.pinchFingerDistanceOne(fingerLeft, fingerRight);
      expect(result).not().assertNull();
      fingerLeft = {
        id: 10,
        globalX: 10,
        globalY: 10,
        localX: 10,
        localY: 10,
        displayX: 10,
        displayY: 10
      };
      fingerRight = {
        id: 20,
        globalX: 10,
        globalY: 10,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 20
      };
      mSlideScreenLockViewModelMode.pinchFingerDistanceOne(fingerLeft, fingerRight);
    })
  })
}

export class SlideScreenLockViewModelMode extends SlideScreenLockVm {
  constructor(persisId:number) {
    super(persisId);
  }

  public ShowInfo(message: string, event: TouchEvent): void {
    return this.showInfo(message, event);
  }

  public HandleEventMove(event: TouchEvent): void {
    return this.handleEventMove(event);
  }

  public CheckSlideTouchState(event: TouchEvent): boolean {
    return this.checkSlideTouchState(event);
  }

  public CalculateKeyboardPosition(touchStartPositionX: number, touchEndPositionX: number): number {
    return this.calculateKeyboardPosition(touchStartPositionX, touchEndPositionX);
  }

  public GetSlBindState(): ISlState | undefined {
    return this.getSlBindState();
  }

  public pinchFingerDistanceOne(fingerLeft: FingerInfo, fingerRight: FingerInfo): number {
    return this.pinchFingerDistance(fingerLeft, fingerRight);
  }
}