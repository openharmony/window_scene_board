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

import { scbEventExclusiveManager } from '@ohos/windowscene';

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
import { BackEventViewModelCallBack } from '../../../../../../main/ets/backevent/viewmodel/BackEventViewModelCallBack';
import { BackGestureModel } from '../../../../../../main/ets/backevent/viewmodel/BackGestureModel';
import { BackGestureModelCallBack } from '../../../../../../main/ets/backevent/viewmodel/BackGestureModelCallBack';

let eventArea: Area = {
  width: 0,
  height: 0,
  position: { x: 0, y: 0 },
  globalPosition: { x: 0, y: 0 }
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

let callBack: BackGestureModelCallBack = {
  onBackGestureCancelForUser: () => {
  },
  onBackGestureCancel: () => {
  },
  onIgnoreBackGesture: () => {
  },
  onSendGestureBackTo: () => {
  }
}

let viewModelCallBack: BackEventViewModelCallBack | null = {
  onRecognizeFail: () => {
  },
  onBackGestureStart: () => {
  },
  onBackGestureUpdate: () => {
  },
  onBackGestureEnd: () => {
  },
  onBackGestureCancel: () => {
  },
  onBackGestureCancelForUser: (): void => {
  },
  onSendClickEventTo: () => {
  },
  onSendGestureBackTo: () => {
  }
}

let backGestureModel: BackGestureModel = new BackGestureModel(callBack, viewModelCallBack);

function ignoreBackGesture() {
  let mocker: MockKit = new MockKit();
  let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
  when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
  event.fingerList = [{
    id: 0,
    globalX: 0,
    globalY: 0,
    localX: 0,
    localY: 0,
    displayX: 0,
    displayY: 0
  }];
  backGestureModel.backGestureStart(event, true, 0);
  mocker.clearAll();
}

export default function BackGestureModelTest() {
  describe('BackGestureModelTest', () => {
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

    it('BackGestureModelTest_backGestureStart_001', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      event.fingerList = [{
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      }];
      expect(backGestureModel.backGestureStart(event, true, 0) === undefined).assertTrue();
      mocker.clearAll();
    })

    it('BackGestureModelTest_backGestureStart_002', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      event.fingerList = [{
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      }, {
        id: 1,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      }];
      expect(backGestureModel.backGestureStart(event, true, 0) === undefined).assertTrue();
      mocker.clearAll();
    })

    it('BackGestureModelTest_backGestureStart_003', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      viewModelCallBack = null;
      let backGestureModel: BackGestureModel = new BackGestureModel(callBack, viewModelCallBack);
      expect(backGestureModel.backGestureStart(event, true, 0) === undefined).assertTrue();
      mocker.clearAll();
    })

    it('BackGestureModelTest_backGestureStart_004', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(backGestureModel.backGestureStart(event, true, 0) === undefined).assertTrue();
      mocker.clearAll();
    })

    it('BackGestureModelTest_backGestureUpdate_001', 0, () => {
      ignoreBackGesture(); // isIgnoreBackGesture = true
      expect(backGestureModel.backGestureUpdate(event, true) === undefined).assertTrue();
      backGestureModel.backGestureCancel(); // isIgnoreBackGesture = false
    })

    it('BackGestureModelTest_backGestureUpdate_002', 0, () => {
      expect(backGestureModel.backGestureUpdate(event, true) === undefined).assertTrue();
    })

    it('BackGestureModelTest_backGestureUpdate_003', 0, () => {
      viewModelCallBack = null;
      let backGestureModel: BackGestureModel = new BackGestureModel(callBack, viewModelCallBack);
      expect(backGestureModel.backGestureUpdate(event, true) === undefined).assertTrue();
    })

    it('BackGestureModelTest_backGestureUpdate_004', 0, () => {
      viewModelCallBack = null;
      let backGestureModel: BackGestureModel = new BackGestureModel(callBack, viewModelCallBack);
      expect(backGestureModel.backGestureUpdate(event, false) === undefined).assertTrue();
    })

    it('BackGestureModelTest_backGestureUpdate_005', 0, () => {
      expect(backGestureModel.backGestureUpdate(event, false) === undefined).assertTrue();
    })

    it('BackGestureModelTest_backGestureEnd_001', 0, () => {
      ignoreBackGesture(); // isIgnoreBackGesture = true
      expect(backGestureModel.backGestureEnd(event, 1, 1, true) === undefined).assertTrue();
    })

    it('BackGestureModelTest_backGestureEnd_002', 0, () => {
      expect(backGestureModel.backGestureEnd(event, 1, 1, true) === undefined).assertTrue();
    })

    it('BackGestureModelTest_backGestureEnd_003', 0, () => {
      expect(backGestureModel.backGestureEnd(event, 1, 1, false) === undefined).assertTrue();
    })

    it('BackGestureModelTest_backGestureEnd_004', 0, () => {
      event.offsetX = 50;
      expect(backGestureModel.backGestureEnd(event, 1, 1, false) === undefined).assertTrue();
    })

    it('BackGestureModelTest_backGestureEnd_005', 0, () => {
      event.offsetX = 0;
      event.timestamp = 200000000;
      expect(backGestureModel.backGestureEnd(event, 1, 1, false) === undefined).assertTrue();
    })

    it('BackGestureModelTest_backGestureCancel_001', 0, () => {
      ignoreBackGesture(); // isIgnoreBackGesture = true
      expect(backGestureModel.backGestureCancel() === undefined).assertTrue();
    })

    it('BackGestureModelTest_backGestureCancel_002', 0, () => {
      expect(backGestureModel.backGestureCancel() === undefined).assertTrue();
    })

  })
}
