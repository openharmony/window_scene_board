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

import { ArgumentMatchers, describe,
  expect,
  it, MockKit, when,
} from '@ohos/hypium';

import {
  GestureFailReason
} from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/back/viewmodel/SCBGestureBackViewModel';
import {
  PadBackEventViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/back/viewmodel/PadBackEventViewModel';
import {
  BackEventViewModelCallBack
} from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackEventViewModelCallBack';


export default function PadBackResponseViewModelTest() {
  describe('PadBackResponseViewModelTest', () => {

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
      },
      onBackGestureUpdate: (): void => {
      },
      onBackGestureCancelForUser: (): void => {
      }
    }
    const backViewModel: PadBackEventViewModel = new PadBackEventViewModel(100, 1001, true, backResponseViewModelCallBack);

    it('PadBackResponseViewModelTest_onPanGestureActionUpdate_001', 0, async () => {
      (backViewModel as object)['recognizeState'] = 0;
      event.timestamp = 200000000;
      backViewModel.onPanGestureActionUpdate(event);
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
    });

    it('PadBackResponseViewModelTest_onPanGestureActionUpdate_002', 0, async () => {
      (backViewModel as object)['recognizeState'] = 0;
      event.timestamp = 20;
      event.sourceTool = SourceTool.TOUCHPAD;
      event.offsetX = 0;
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
    });

    it('PadBackResponseViewModelTest_onPanGestureActionUpdate_003', 0, async () => {
      (backViewModel as object)['recognizeState'] = 0;
      event.timestamp = 20;
      event.sourceTool = SourceTool.Pen;
      event.offsetX = 50;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(backViewModel, (backViewModel as object)['isValidAngle']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
      mocker.ignoreMock(backViewModel, (backViewModel as object)['isValidAngle']);
    });

    it('PadBackResponseViewModelTest_onPanGestureActionUpdate_004', 0, async () => {
      (backViewModel as object)['recognizeState'] = 0;
      event.timestamp = 20;
      event.sourceTool = SourceTool.Pen;
      event.offsetX = 50;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(backViewModel, (backViewModel as object)['isValidAngle']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
      mocker.ignoreMock(backViewModel, (backViewModel as object)['isValidAngle']);
    });

    it('PadBackResponseViewModelTest_onPanGestureActionUpdate_005', 0, async () => {
      (backViewModel as object)['recognizeState'] = 0;
      event.timestamp = 20;
      event.sourceTool = SourceTool.TOUCHPAD;
      event.offsetX = 50;
      expect(backViewModel.onPanGestureActionUpdate(event) === undefined).assertTrue();
    });
  })
}
