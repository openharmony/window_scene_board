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
import {
  BackEventViewModelCallBack
} from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackEventViewModelCallBack';
import { BackGestureModelCallBack } from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackGestureModelCallBack';

import { ArgumentMatchers, describe, expect, it, MockKit, when, } from '@ohos/hypium';
import {
  PadBackGestureModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/back/model/PadBackGestureModel';

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
  onSendClickEventTo: () => {
  },
  onSendGestureBackTo: () => {
  },
  onBackGestureCancelForUser: (): void => {
  }
}

let backGestureModel: PadBackGestureModel = new PadBackGestureModel(callBack, viewModelCallBack);

export default function PadBackGestureModelTest() {
  describe('PadBackGestureModelTest', () => {
    it('PadBackGestureModelTest_backGestureEnd_001', 0, () => {
      expect(backGestureModel.backGestureEnd(event, 1, 1, true) === undefined).assertTrue();
    })

    it('PadBackGestureModelTest_backGestureEnd_002', 0, () => {
      event.offsetX = 50;
      expect(backGestureModel.backGestureEnd(event, 1, 1, false) === undefined).assertTrue();
    })

    it('PadBackGestureModelTest_backGestureEnd_003', 0, () => {
      event.offsetX = 0;
      event.timestamp = 200000000;
      expect(backGestureModel.backGestureEnd(event, 1, 1, false) === undefined).assertTrue();
    })

    it('PadBackGestureModelTest_checkAccidentalTouch_004', 0, () => {
      event.sourceTool = SourceTool.TOUCHPAD;
      event.timestamp = 1000001;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(backGestureModel, backGestureModel.isInBackResponseRegion);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      event.offsetX = 1;
      expect(backGestureModel.backGestureEnd(event, 1, 1, false) === undefined).assertTrue();
      mocker.ignoreMock(backGestureModel, backGestureModel.isInBackResponseRegion);
    })

    it('PadBackGestureModelTest_checkAccidentalTouch_005', 0, () => {
      event.sourceTool = SourceTool.TOUCHPAD;
      event.timestamp = 200000000;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(backGestureModel, backGestureModel.isInBackResponseRegion);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      event.offsetX = 200;
      expect(backGestureModel.backGestureEnd(event, 1, 1, false) === undefined).assertTrue();
      mocker.ignoreMock(backGestureModel, backGestureModel.isInBackResponseRegion);
    })

  })
}
