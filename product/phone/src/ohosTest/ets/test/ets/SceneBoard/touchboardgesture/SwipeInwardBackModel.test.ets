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
  it,
  describe,
  expect,
} from '@ohos/hypium';
import { SwipeInwardBackModel } from '@ohos/phonebase/src/main/ets/SceneBoard/touchboardgesture/SwipeInwardBackModel';
import { PadBackEventViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/back/viewmodel/PadBackEventViewModel';
import {
  GestureFailReason
} from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/back/viewmodel/SCBGestureBackViewModel';
import {
  BackEventViewModelCallBack
} from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackEventViewModelCallBack';

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

const leftResponseViewModel: PadBackEventViewModel = new PadBackEventViewModel(0, 4102, true,
  backResponseViewModelCallBack);
const rightResponseViewModel: PadBackEventViewModel = new PadBackEventViewModel(0,4102, false,
  backResponseViewModelCallBack);
const swipeInwardBackModel: SwipeInwardBackModel = new SwipeInwardBackModel(leftResponseViewModel,
  rightResponseViewModel, 2880, 1920);

export default function SwipeInwardBackModelTest() {
  describe('SwipeInwardBackModelTest', () => {

    it('SwipeInwardBackModelTest_registerSwipeInwardCallback', 0, (): void => {
      expect(swipeInwardBackModel.registerSwipeInwardCallback() === undefined).assertTrue();
    })

    it('SwipeInwardBackModelTest_unRegisterSwipeInwardCallback', 0, (): void => {
      expect(swipeInwardBackModel.unRegisterSwipeInwardCallback() === undefined).assertTrue();
    })
  })
}