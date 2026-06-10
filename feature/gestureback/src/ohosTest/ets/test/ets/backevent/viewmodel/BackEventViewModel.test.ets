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

import { SendTouchEventController, SendTouchModel } from '@ohos/windowscene/Index';
import { BackEventViewModelCallBack, GestureFailReason } from
  '../../../../../../main/ets/backevent/viewmodel/BackEventViewModelCallBack';
import { ActionType, BackEventViewModel } from '../../../../../../main/ets/backevent/viewmodel/BackEventViewModel';

export default function BackResponseViewModelTest() {
  describe('BackResponseViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.·
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

    const backResponseViewModelCallBack: BackEventViewModelCallBack = {
      onRecognizeFail: (reason: GestureFailReason) => {
      },

      onBackGestureEnd: () => {
      },

      onBackGestureCancel: () => {
      },

      onSendClickEventTo: () => {
      },

      onSendGestureBackTo: () => {
      },
      onBackGestureStart: (): void => {
        throw new Error('Function not implemented.');
      },
      onBackGestureUpdate: (): void => {
        throw new Error('Function not implemented.');
      },
      onBackGestureCancelForUser: (): void => {
        throw new Error('Function not implemented.');
      }
    }
    const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true,
      backResponseViewModelCallBack);

    it('BackResponseViewModelTest_onClickEvent1', 0, () => {
      expect(backViewModel.onClickEvent() === undefined).assertTrue();
    })

    it('BackResponseViewModelTest_onClickEvent2', 0, () => {
      let mocker = new MockKit();
      let send: SendTouchEventController = new SendTouchEventController('onClickEvent', 1000, 10);
      when(mocker.mockFunc(send, send.getCurSendTouchModel))().afterReturn(null);
      expect(backViewModel.onClickEvent() === undefined).assertTrue();
      mocker.clear(send);
    })

    it('BackResponseViewModelTest_onClickEvent3', 0, () => {
      let mocker = new MockKit();
      let send: SendTouchEventController = new SendTouchEventController('onClickEvent', 1000, 10);
      let sendTouchModel: SendTouchModel = new SendTouchModel('onClickEvent', 2000);
      send.addSendTouchModel(sendTouchModel);
      when(mocker.mockFunc(send, send.getCurSendTouchModel))().afterReturn(sendTouchModel);
      expect(backViewModel.onClickEvent() === undefined).assertTrue();
      mocker.clear(send);
    })

    it('BackResponseViewModelTest_onClickEvent_4', 0, () => {
      let backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc((backViewModel as object)['sendTouchEventController'],
        (backViewModel as object)['sendTouchEventController'].getCurSendTouchModel);
      when(mockFunc)().afterReturn(new SendTouchModel('onClickEvent', 2000));
      expect(backViewModel.onClickEvent() === undefined).assertTrue();
      mocker.ignoreMock((backViewModel as object)['sendTouchEventController'],
        (backViewModel as object)['sendTouchEventController'].getCurSendTouchModel);
    })

    it('BackEventViewModelTest_onAccessibilityHoverTransparent1', 0, () => {
      let backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      let event: TouchEvent = {
        type: TouchType.Down,
        changedTouches: [{
          y: 2
        } as TouchObject]
      } as TouchEvent
      (backViewModel as object)['sendTouchEventController'] = null;
      expect(backViewModel.onAccessibilityHoverTransparent(event) === undefined).assertTrue();
    })

    it('BackEventViewModelTest_onAccessibilityHoverTransparent2', 0, () => {
      let backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      let send: SendTouchEventController = new SendTouchEventController('BackEventView', 1000, 10);
      let event: TouchEvent = {
        type: TouchType.Down,
        changedTouches: [{
          y: 2
        } as TouchObject]
      } as TouchEvent
      (backViewModel as object)['sendTouchEventController'] = send;
      expect(backViewModel.onAccessibilityHoverTransparent(event) === undefined).assertTrue();
    })

    it('BackEventViewModelTest_onTouchEvent1', 0, () => {
      expect(backViewModel.onTouchEvent(1, touchEvent) === undefined).assertTrue();
    })

    it('BackEventViewModelTest_onTouchEvent2', 0, () => {
      let send: SendTouchEventController = new SendTouchEventController('onClickEvent', 1000, 10);
      let event: TouchEvent = {
        type: TouchType.Down,
        changedTouches: [{
          y: 2
        } as TouchObject]
      } as TouchEvent
      expect(backViewModel.onTouchEvent(1, touchEvent) === undefined).assertTrue();
    })

    it('BackEventViewModelTest_onTouchEvent_003', 0, () => {
      touchEvent.type = TouchType.Up;
      expect(backViewModel.onTouchEvent(1, touchEvent) === undefined).assertTrue();
    })

    it('BackEventViewModelTest_onTouchEvent_004', 0, () => {
      touchEvent.type = TouchType.Move;
      expect(backViewModel.onTouchEvent(1, touchEvent) === undefined).assertTrue();
    })

    it('BackEventViewModelTest_onTouchEvent_005', 0, () => {
      touchEvent.type = TouchType.Cancel;
      expect(backViewModel.onTouchEvent(1, touchEvent) === undefined).assertTrue();
    })

    it('BackResponseViewModelTest_onLongPressGestureAction1', 0, () => {
      expect(backViewModel.onLongPressGestureAction(ActionType.START) === undefined).assertTrue();
    })

    it('BackResponseViewModelTest_onLongPressGestureAction2', 0, () => {
      let mocker = new MockKit();
      let send: SendTouchEventController = new SendTouchEventController('onClickEvent', 1000, 10);
      when(mocker.mockFunc(send, send.getCurSendTouchModel))().afterReturn(null);
      expect(backViewModel.onLongPressGestureAction(ActionType.START) === undefined).assertTrue();
      mocker.clear(send);
    })

    it('BackResponseViewModelTest_onLongPressGestureAction3', 0, () => {
      let mocker = new MockKit();
      let send: SendTouchEventController = new SendTouchEventController('onClickEvent', 1000, 10);
      let sendTouchModel: SendTouchModel = new SendTouchModel('onClickEvent', 2000);
      when(mocker.mockFunc(send, send.getCurSendTouchModel))().afterReturn(sendTouchModel);
      expect(backViewModel.onLongPressGestureAction(ActionType.START) === undefined).assertTrue();
      mocker.clear(send);
    })

    it('BackResponseViewModelTest_onLongPressGestureAction4', 0, () => {
      let mocker = new MockKit();
      let send: SendTouchEventController = new SendTouchEventController('onClickEvent', 1000, 10);
      let sendTouchModel: SendTouchModel = new SendTouchModel('onClickEvent', 2000);
      when(mocker.mockFunc(send, send.getCurSendTouchModel))().afterReturn(sendTouchModel);
      expect(backViewModel.onLongPressGestureAction(ActionType.START) === undefined).assertTrue();
      mocker.clear(send);
    })

    it('BackResponseViewModelTest_onLongPressGestureAction5', 0, () => {
      let mocker = new MockKit();
      let send: SendTouchEventController = new SendTouchEventController('onClickEvent', 1000, 10);
      let sendTouchModel: SendTouchModel = new SendTouchModel('onClickEvent', 2000);
      when(mocker.mockFunc(send, send.getCurSendTouchModel))().afterReturn(sendTouchModel);
      expect(backViewModel.onLongPressGestureAction(ActionType.END) === undefined).assertTrue();
      mocker.clear(send);
    })

    it('BackResponseViewModelTest_onLongPressGestureAction6', 0, () => {
      let mocker = new MockKit();
      let send: SendTouchEventController = new SendTouchEventController('onClickEvent', 1000, 10);
      let sendTouchModel: SendTouchModel = new SendTouchModel('onClickEvent', 2000);
      when(mocker.mockFunc(send, send.getCurSendTouchModel))().afterReturn(sendTouchModel);
      expect(backViewModel.onLongPressGestureAction(ActionType.CANCEL) === undefined).assertTrue();
      mocker.clear(send);
    })

    it('BackResponseViewModelTest_onLongPressGestureAction7', 0, () => {
      let mocker = new MockKit();
      let send: SendTouchEventController = new SendTouchEventController('onClickEvent', 1000, 10);
      let sendTouchModel: SendTouchModel = new SendTouchModel('onClickEvent', 2000);
      when(mocker.mockFunc(send, send.getCurSendTouchModel))().afterReturn(sendTouchModel);
      expect(backViewModel.onLongPressGestureAction(ActionType.UPDATE) === undefined).assertTrue();
      mocker.clear(send);
    })

    it('SCBGestureBackViewModelTest_GestureFailInjectDown1', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      expect(backViewModel.GestureFailInjectDown(GestureFailReason.CANCEL_FROM_USER) === undefined).assertTrue();
    })

    it('SCBGestureBackViewModelTest_GestureFailInjectDown2', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      expect(backViewModel.GestureFailInjectDown(GestureFailReason.CANCEL_FROM_SYSTEM) === undefined).assertTrue();
    })

    it('SCBGestureBackViewModelTest_GestureFailInjectDown3', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      expect(backViewModel.GestureFailInjectDown(GestureFailReason.TIMEOUT) === undefined).assertTrue();
    })

    it('SCBGestureBackViewModelTest_onPanGestureActionUpdate_001', 0, async () => {
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
    });

    // this.recognizeState === RecognizeState.FAIL
    it('SCBGestureBackViewModelTest_onPanGestureActionUpdate_002', 0, async () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      event.timestamp = 200000000;
      backViewModel.onPanGestureActionUpdate(event);
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionUpdate_003', 0, async () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      event.timestamp = 200000000;
      (backViewModel as object)['isPanGestureFinished'] = true;
      (backViewModel as object)['recognizeState'] = 2;
      backViewModel.onPanGestureActionUpdate(event);
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionUpdate_004', 0, async () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      event.timestamp = 200000000;
      (backViewModel as object)['isPanGestureFinished'] = true;
      (backViewModel as object)['recognizeState'] = 1;
      backViewModel.onPanGestureActionUpdate(event);
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionUpdate_005', 0, async () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      (backViewModel as object)['isPanGestureFinished'] = false;
      (backViewModel as object)['recognizeState'] = 1;
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionUpdate_006', 0, async () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      (backViewModel as object)['isPanGestureFinished'] = false;
      (backViewModel as object)['recognizeState'] = 1;
      (backViewModel as object)['hasCheckAccidentalTouch'] = false;
      let mocker = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc((backViewModel as object), (backViewModel as object)['checkAccidentalTouch']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
      mocker.ignoreMock((backViewModel as object), (backViewModel as object)['checkAccidentalTouch']);
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionEnd_001', 0, async () => {
      expect(backViewModel.onPanGestureActionEnd(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionEnd_002', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, false, backResponseViewModelCallBack);
      backViewModel.onPanGestureActionEnd(event);
      expect(backViewModel.onPanGestureActionEnd(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionEnd_003', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, false, backResponseViewModelCallBack);
      expect(backViewModel.onPanGestureActionEnd(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionEnd_004', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      event.timestamp = 200000000;
      backViewModel.onPanGestureActionUpdate(event);
      expect(backViewModel.onPanGestureActionEnd(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionEnd_005', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      event.timestamp = 200000000;
      (backViewModel as object)['isPanGestureFinished'] = true;
      expect(backViewModel.onPanGestureActionEnd(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionEnd_006', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      (backViewModel as object)['isPanGestureFinished'] = false;
      (backViewModel as object)['recognizeState'] = 1;
      expect(backViewModel.onPanGestureActionEnd(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionEnd_007', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      (backViewModel as object)['isPanGestureFinished'] = false;
      (backViewModel as object)['recognizeState'] = 10;
      expect(backViewModel.onPanGestureActionEnd(event) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionCancel_001', 0, async () => {
      expect(backViewModel.onPanGestureActionCancel() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionCancel_002', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      backViewModel.onPanGestureActionEnd(event);
      expect(backViewModel.onPanGestureActionCancel() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionCancel_003', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, false, backResponseViewModelCallBack);
      expect(backViewModel.onPanGestureActionCancel() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionCancel_004', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      event.timestamp = 200000000;
      backViewModel.onPanGestureActionUpdate(event);
      expect(backViewModel.onPanGestureActionCancel() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionCancel_005', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, false, backResponseViewModelCallBack);
      (backViewModel as object)['recognizeState'] = 2;
      expect(backViewModel.onPanGestureActionCancel() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionCancel_006', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, false, backResponseViewModelCallBack);
      (backViewModel as object)['recognizeState'] = 1;
      expect(backViewModel.onPanGestureActionCancel() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_onPanGestureActionCancel_007', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, false, backResponseViewModelCallBack);
      (backViewModel as object)['recognizeState'] = 10;
      expect(backViewModel.onPanGestureActionCancel() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_isValidAngle_001', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, true, backResponseViewModelCallBack);
      event.timestamp = 0;
      event.offsetX = 0;
      event.offsetY = -1;
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
    });

    it('BackEventViewModelTest_getBackGestureStartY_001', 0, () => {
      touchEvent.type = TouchType.Down;
      touchEvent.changedTouches[0].y = 300;
      expect(backViewModel.onTouchEvent(1, touchEvent) === undefined).assertTrue();
    })

    it('BackEventViewModelTest_getBackGestureStartY_002', 0, () => {
      touchEvent.type = TouchType.Down;
      touchEvent.changedTouches[0].y = 300;
      expect(backViewModel.onTouchEvent(10000, touchEvent) === undefined).assertTrue();
    })

    it('BackEventViewModelTest_backGestureRecognize_2', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, false, backResponseViewModelCallBack);
      event.timestamp = 10;
      (backViewModel as object)['startTime'] = 1;
      event.offsetX = px2vp(20);
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc((backViewModel as object), (backViewModel as object)['isValidAngle']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect((backViewModel as object)['backGestureRecognize'](event) === undefined).assertTrue();
      mocker.ignoreMock((backViewModel as object), (backViewModel as object)['isValidAngle']);
    })

    it('BackEventViewModelTest_checkAccidentalTouch_2', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, false, backResponseViewModelCallBack);
      event.timestamp = 150000000;
      (backViewModel as object)['startTime'] = 1;
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc((backViewModel as object)['backGestureModel'],
        (backViewModel as object)['backGestureModel'].isInBackResponseRegion);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect((backViewModel as object)['checkAccidentalTouch'](event) !== undefined).assertTrue();
      mocker.ignoreMock((backViewModel as object)['backGestureModel'],
        (backViewModel as object)['backGestureModel'].isInBackResponseRegion);
    })

    it('BackEventViewModelTest_isValidAngle_1', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, false, backResponseViewModelCallBack);
      expect((backViewModel as object)['isValidAngle'](0, 0, 0) !== undefined).assertTrue();
    })

    it('BackEventViewModelTest_isValidAngle_2', 0, () => {
      const backViewModel: BackEventViewModel = new BackEventViewModel(100, 1001, false, backResponseViewModelCallBack);
      expect((backViewModel as object)['isValidAngle'](1, 0, 0) !== undefined).assertTrue();
    })

    it('BackEventViewModelTest_onMouseTouch', 0, () => {
      expect(backViewModel.onMouseTouch() === undefined).assertTrue();
    })
  })
}
