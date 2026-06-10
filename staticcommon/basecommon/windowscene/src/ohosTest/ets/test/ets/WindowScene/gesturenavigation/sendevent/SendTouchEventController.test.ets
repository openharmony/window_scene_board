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

import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  Size,
  TestType,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { SCBSceneSessionManager, SystemSessionInfo } from '../../../../../../../main/ets/TsIndex';
import {
  SendState,
  SendTouchEventController
} from '../../../../../../../main/ets/gesturenavigation/sendtouchevent/SendTouchEventController';
import { SendTouchModel } from '../../../../../../../main/ets/gesturenavigation/sendtouchevent/SendTouchModel';
import { TouchEvent } from 'touchEvent';

const TAG = 'SendTouchEventControllerTest';

let sendTouchModel = new SendTouchModel(TAG, 1);
let sendTouchEventController = new SendTouchEventController(TAG, 1, 1);

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

function cb(sendTouchModel: SendTouchModel, touchEvent: TouchEvent): void {
}

function clickCallback(sendClickModel: SendTouchModel, touchEvent: TouchEvent, zIndex: number): void {
}

let systemSessionInfo: SystemSessionInfo = {
  systemType: sceneSessionManager.SessionType.TYPE_PANEL,
  sceneName: 'test',
  sceneZIndex: 0,
  hitTestMode: HitTestMode.Default,
  isRotatable: true,
}

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

export default function SendTouchEventControllerTest() {
  describe('SendTouchEventControllerTest', () => {
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

    // event is empty
    it('SendTouchModel_addTouchEventToQueue_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(sendTouchModel.addTouchEventToQueue() === undefined).assertTrue();
    })

    it('SendTouchModel_addTouchEventToQueue_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchModel.clearTouchEventQueue();
      expect(sendTouchModel.addTouchEventToQueue(touchEvent) === undefined).assertTrue();
    })

    // event type is TouchType.Down
    it('SendTouchModel_addTouchEventToQueue_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      touchEvent.type = TouchType.Down;
      expect(sendTouchModel.addTouchEventToQueue(touchEvent) === undefined).assertTrue();
    })

    //  event type is TouchType.Up or TouchType.Cancel
    it('SendTouchModel_addTouchEventToQueue_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      touchEvent.type = TouchType.Move;
      expect(sendTouchModel.addTouchEventToQueue(touchEvent) === undefined).assertTrue();
    })

    it('SendTouchModel_addTouchEventToQueue_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      touchEvent.type = TouchType.Up;
      expect(sendTouchModel.addTouchEventToQueue(touchEvent) === undefined).assertTrue();
    })

    //  event type is TouchType.Cancel
    it('SendTouchModel_addTouchEventToQueue_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      touchEvent.type = TouchType.Cancel;
      expect(sendTouchModel.addTouchEventToQueue(touchEvent) === undefined).assertTrue();
    })

    it('SendTouchModel_getTouchEventQueue_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(sendTouchModel.getTouchEventQueue() !== null).assertTrue();
    })

    it('SendTouchModel_startSendClickEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchModel.clearTouchEventQueue();
      expect(sendTouchModel.startSendClickEvent() === undefined).assertTrue();
    })

    it('SendTouchModel_startSendClickEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchModel.addTouchEventToQueue(touchEvent);
      expect(sendTouchModel.startSendClickEvent() === undefined).assertTrue();
    })

    it('SendTouchModel_startSendClickEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchModel.addTouchEventToQueue(touchEvent);
      sendTouchModel.setClickCallback(clickCallback);
      expect(sendTouchModel.startSendClickEvent() === undefined).assertTrue();
    })

    it('SendTouchModel_startSendPanGestureEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(sendTouchModel.startSendPanGestureEvent(cb) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchModel_startSendPanGestureEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sendTouchModel.clearTouchEventQueue();
      expect(sendTouchModel.startSendPanGestureEvent(cb) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchModel_startSendPanGestureEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sendTouchModel.addTouchEventToQueue(touchEvent);
      expect(sendTouchModel.startSendPanGestureEvent(cb) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchModel_startSendPanGestureEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchModel.addTouchEventToQueue(touchEvent);
      setInterval(() => sendTouchModel.startSendPanGestureEvent(cb), 5);
      expect(sendTouchModel.startSendPanGestureEvent(cb) === undefined).assertTrue();
    })

    // setRecognizeState to SUCCESS
    it('SendTouchEventController_setRecognizeState_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let res = SendState.NOT_SEND_EVENT;
      expect(sendTouchEventController.setSendState(res) === undefined).assertTrue();
    })

    // setRecognizeState to FAIL
    it('SendTouchEventController_setRecognizeState_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let res = SendState.SEND_EVENT;
      expect(sendTouchEventController.setSendState(res) === undefined).assertTrue();
    })

    // there is no SendTouchModel
    it('SendTouchEventController_getSendTouchModelByFingerId_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
        sendTouchEventController.addSendTouchModel(sendTouchModel);
        expect(sendTouchEventController.getSendTouchModelByFingerId(0) !== undefined).assertTrue();
      })

    // Should return the SendTouchModel
    it('SendTouchEventController_getSendTouchModelByFingerId_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
        sendTouchEventController.addSendTouchModel(sendTouchModel);
        expect(sendTouchEventController.getSendTouchModelByFingerId(-1) !== undefined).assertTrue();
      })

    it('SendTouchEventController_getSendTouchModelByFingerId_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
        expect(sendTouchEventController.getSendTouchModelByFingerId(0) !== undefined).assertTrue();
      })

    it('SendTouchEventController_getSendTouchModelByFingerId_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
        expect(sendTouchEventController.getSendTouchModelByFingerId(-1) !== undefined).assertTrue();
      })

    it('SendTouchEventController_checkCurSendTouchModel_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      touchEvent.type = TouchType.Cancel;
      touchEvent.changedTouches[0].id = 0;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    it('SendTouchEventController_checkCurSendTouchModel_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      touchEvent.type = TouchType.Cancel;
      touchEvent.changedTouches[0].id = -1;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    // sendTouchModel is null
    it('SendTouchEventController_getSendTouchModelByModel_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
        expect(sendTouchEventController.getSendTouchModelByModel(null) !== undefined).assertTrue();
      })

    // sendTouchModel is not null
    it('SendTouchEventController_getSendTouchModelByModel_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
        expect(sendTouchEventController.getSendTouchModelByModel(sendTouchModel) !== undefined).assertTrue();
      })

    it('SendTouchEventController_getCurSendTouchModel_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.clearSendTouchModelList();
      expect(sendTouchEventController.getCurSendTouchModel() !== undefined).assertTrue();
    })

    it('SendTouchEventController_getCurSendTouchModel_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.receiveTouchEvent(touchEvent);
      expect(sendTouchEventController.getCurSendTouchModel() !== undefined).assertTrue();
    })

    // sendTouchModel is null
    it('SendTouchEventController_removeSendTouchModel_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(sendTouchEventController.removeSendTouchModel(null) === undefined).assertTrue();
    })

    // sendTouchModel is not null
    it('SendTouchEventController_removeSendTouchModel_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.addSendTouchModel(sendTouchModel)
      expect(sendTouchEventController.removeSendTouchModel(sendTouchModel) === undefined).assertTrue();
    })

    it('SendTouchEventController_clearSendTouchModelList_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingTouchEvent);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        expect(sendTouchEventController.clearSendTouchModelList() === undefined).assertTrue();
        mocker.clear(sendTouchModel);
      })

    it('SendTouchEventController_handleExceptionTouchModels_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
        sendTouchEventController.addSendTouchModel(sendTouchModel);
        expect(sendTouchEventController.handleExceptionTouchModels() === undefined).assertTrue();
      })

    it('SendTouchEventController_handleExceptionTouchModels_2', 0, (): void => {
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      sendTouchEventController.handleExceptionTouchModels();
      expect(sendTouchEventController.handleExceptionTouchModels() === undefined).assertTrue();
    })

    it('SendTouchEventController_handleExceptionTouchModels_3', 0, (): void => {
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      sendTouchEventController.handleExceptionTouchModels();
      setTimeout(() => {
        sendTouchEventController.handleExceptionTouchModels()
      }, 600);
      expect(sendTouchEventController.handleExceptionTouchModels() === undefined).assertTrue();
    })

    // recognizeState is SUCCESS
    it('SendTouchEventController_receiveTouchEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.NOT_SEND_EVENT);
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    // event type is TouchType.Down
    it('SendTouchEventController_receiveTouchEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.SEND_EVENT);
      touchEvent.type = TouchType.Down;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    // event type is TouchType.Move
    it('SendTouchEventController_receiveTouchEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.SEND_EVENT);
      touchEvent.type = TouchType.Move;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    // event type is TouchType.Up
    it('SendTouchEventController_receiveTouchEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.SEND_EVENT);
      touchEvent.type = TouchType.Up;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    // event type is TouchType.Cancel
    it('SendTouchEventController_receiveTouchEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.SEND_EVENT);
      touchEvent.type = TouchType.Cancel;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    it('SendTouchEventController_receiveTouchEvent_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.SEND_EVENT);
      touchEvent.type = TouchType.Cancel;
      sendTouchEventController.clearSendTouchModelList();
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    // event type is TouchType.Down
    it('SendTouchEventController_receiveTouchEvent_7', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.NONE);
      touchEvent.type = TouchType.Down;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    // event type is TouchType.Move
    it('SendTouchEventController_receiveTouchEvent_8', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.NONE);
      touchEvent.type = TouchType.Move;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    // event type is TouchType.Up
    it('SendTouchEventController_receiveTouchEvent_9', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.NONE);
      touchEvent.type = TouchType.Up;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    // event type is TouchType.Cancel
    it('SendTouchEventController_receiveTouchEvent_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.NONE);
      touchEvent.type = TouchType.Cancel;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    // recognizeState is FAIL and curSendTouchModel is not null
    it('SendTouchEventController_receiveTouchEvent_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.SEND_EVENT);
      touchEvent.type = 6;
      expect(sendTouchEventController.receiveTouchEvent(touchEvent) === undefined).assertTrue();
    })

    it('SendTouchEventController_receiveTouchEvent_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.setSendState(SendState.SEND_EVENT);
      expect(sendTouchEventController.receiveTouchEvent() === undefined).assertTrue();
    })

    it('SendTouchEventController_sendALLPanGestureEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.removeSendTouchModel(sendTouchModel);
      expect(sendTouchEventController.sendALLTouchModeEvent() === undefined).assertTrue();
    })

    it('SendTouchEventController_sendALLPanGestureEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      expect(sendTouchEventController.sendALLTouchModeEvent() === undefined).assertTrue();
    })

    it('SendTouchEventController_sendPanGestureEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(sendTouchEventController.sendTouchModelEvent(sendTouchModel) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchEventController_sendPanGestureEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingTouchEvent);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      touchEvent.type = TouchType.Up;
      expect(sendTouchEventController.sendTouchModelEvent(sendTouchModel) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchEventController_sendPanGestureEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingTouchEvent);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      touchEvent.type = TouchType.Cancel;
      expect(sendTouchEventController.sendTouchModelEvent(sendTouchModel) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchEventController_sendPanGestureEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingTouchEvent);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      touchEvent.type = TouchType.Down;
      expect(sendTouchEventController.sendTouchModelEvent(sendTouchModel) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchEventController_sendPanGestureEvent_5', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingTouchEvent);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      touchEvent.type = TouchType.Cancel;
      expect(sendTouchEventController.sendTouchModelEvent(sendTouchModel) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchEventController_sendPanGestureEvent_6', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingTouchEvent);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      touchEvent.type = TouchType.Up;
      expect(sendTouchEventController.sendTouchModelEvent(sendTouchModel) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchEventController_sendPanGestureEvent_7', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingTouchEvent);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      touchEvent.type = TouchType.Cancel;
      expect(sendTouchEventController.sendTouchModelEvent(sendTouchModel) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchEventController_sendPanGestureEvent_8', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingTouchEvent);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      touchEvent.type = TouchType.Down;
      expect(sendTouchEventController.sendTouchModelEvent(sendTouchModel) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchEventController_sendPanGestureEvent_9', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingTouchEvent);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sendTouchEventController.addSendTouchModel(sendTouchModel);
      touchEvent.type = TouchType.Cancel;
      expect(sendTouchEventController.sendTouchModelEvent(sendTouchModel) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchEventController_sendPanGestureEvent_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sendTouchEventController.clearSendTouchModelList();
      expect(sendTouchEventController.sendTouchModelEvent(null) === undefined).assertTrue();
    })

    it('SendTouchEventController_sendPanGestureEvent_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingTouchEvent);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(sendTouchModel, sendTouchModel.isSendingPanGestureEvent);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      expect(sendTouchEventController.sendTouchModelEvent(sendTouchModel) === undefined).assertTrue();
      mocker.clear(sendTouchModel);
    })

    it('SendTouchEventController_sendTouchEvent_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(sendTouchEventController.sendTouchEvent(null) === undefined).assertTrue();
    })

    it('SendTouchEventController_sendTouchEvent_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let systemSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(systemSessionInfo);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      expect(sendTouchEventController.sendTouchEvent(touchEvent) === undefined).assertTrue();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(systemSceneSession);
      expect(sendTouchEventController.sendTouchEvent(touchEvent) === undefined).assertTrue();
    })

    it('SendTouchEventController_sendTouchEvent_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      expect(sendTouchEventController.sendTouchEvent(null) === undefined).assertTrue();
    })

    it('SendTouchEventController_sendTouchEvent_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      touchEvent.type = TouchType.Down;
      expect(sendTouchEventController.sendTouchEvent(touchEvent) === undefined).assertTrue();
    })

    it('SendTouchEventController_saveEvent_1', 0, (): void => {
      let sendTouchEventController = new SendTouchEventController(TAG, 1, 1);
      touchEvent.type = TouchType.Up;
      expect((sendTouchEventController as object)['saveEvent'](touchEvent) === undefined).assertTrue();
    })
  })
}


