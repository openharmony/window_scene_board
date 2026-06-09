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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { SendTouchEventController, SendState } from '@ohos/windowscene/Index';

const TAG = 'SCBOuterGestureNavBarViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/*
 * Manager for Outer Gesture Navigation : Single Display Pocket Product
 */
export class SCBOuterGestureNavBarViewModel {
  private readonly HALF_CIRCLED: number = 180;
  private readonly MAX_LIMIT_ANGLE: number = 15;

  public outerSetSendStateNone(sendTouchEventController?: SendTouchEventController): void {
  }

  public outerSetSendStateSend(sendTouchEventController?: SendTouchEventController): void {
  }
}

export const scbOuterGestureNavBarViewModel = SingletonHelper.getInstance(SCBOuterGestureNavBarViewModel, TAG);