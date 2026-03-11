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
import {
  SCBSceneSessionManager,
  SystemSessionInfo
} from '../../../../../../../main/ets/TsIndex';
import { TouchEvent } from 'touchEvent';
import { SendClickEventController, SendTouchModel, SendTouchUtils } from '../../../../../../../../Index';

const TAG = 'SendClickEventControllerTest';

let sendClickEventController = new SendClickEventController(TAG, 1, 1);

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

export default function SendClickEventControllerTest() {
  describe('SendClickEventControllerTest', () => {
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

    it('SendClickEventControllerTest_sendClickEvent', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let systemSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(systemSessionInfo);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      expect(sendClickEventController.sendClickEvent(null, null) == undefined).assertTrue();
      expect(sendClickEventController.sendClickEvent(touchEvent, touchEvent) == undefined).assertTrue();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(systemSceneSession);
      expect(sendClickEventController.sendClickEvent(null, null) == undefined).assertTrue();
      expect(sendClickEventController.sendClickEvent(null, touchEvent) == undefined).assertTrue();
      expect(sendClickEventController.sendClickEvent(touchEvent, null) == undefined).assertTrue();
      expect(sendClickEventController.sendClickEvent(touchEvent, touchEvent) == undefined).assertTrue();
      let touchEvent2 = touchEvent;
      touchEvent2.changedTouches[0].id = 1;
      expect(sendClickEventController.sendClickEvent(touchEvent2, touchEvent) == undefined).assertTrue();
      expect(sendClickEventController.sendClickEvent(touchEvent2, null) == undefined).assertTrue();
    })

    it('SendClickEventControllerTest_recordTouchEventLog_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(SendTouchUtils.recordTouchEventLog(TAG, 'send', null) === undefined).assertTrue();
    })

    it('SendClickEventControllerTest_recordTouchEventLog_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(SendTouchUtils.recordTouchEventLog(TAG, 'send', touchEvent) === undefined).assertTrue();
    })

    it('SendClickEventControllerTest_sendTouchEvent_001', 0, (): void => {
      expect(sendClickEventController.sendTouchEvent(null) === undefined).assertTrue();
    })

    it('SendClickEventControllerTest_clickCallback_1', 0, (): void => {
      expect((sendClickEventController as object)['clickCallback'](new SendTouchModel('test', 0), undefined) ===
        undefined).assertTrue();
    })

    it('SendClickEventControllerTest_clickCallback_2', 0, (): void => {
      touchEvent.type = TouchType.Down;
      expect((sendClickEventController as object)['clickCallback'](new SendTouchModel('test', 0), touchEvent) ===
        undefined).assertTrue();
    })

    it('SendClickEventControllerTest_clickCallback_3', 0, (): void => {
      touchEvent.type = TouchType.Cancel;
      expect((sendClickEventController as object)['clickCallback'](new SendTouchModel('test', 0), touchEvent) ===
        undefined).assertTrue();
    })

    it('SendClickEventControllerTest_clickCallback_4', 0, (): void => {
      touchEvent.type = TouchType.Up;
      expect((sendClickEventController as object)['clickCallback'](new SendTouchModel('test', 0), touchEvent) ===
        undefined).assertTrue();
    })
  })
}


