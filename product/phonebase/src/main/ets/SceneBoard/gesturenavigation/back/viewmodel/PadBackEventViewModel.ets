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

import { SendState } from '@ohos/windowscene/Index';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GestureBackConstants } from '@ohos/gestureback/src/main/ets/common/GestureBackConstants';
import { SwipeInwardConstants } from '../../../touchboardgesture/SwipeInwardEvent';
import { PadBackGestureModel } from '../model/PadBackGestureModel';
import { BackEventViewModel } from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackEventViewModel';
import { BackEventViewModelCallBack } from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackEventViewModelCallBack';
import { GestureFailReason, RecognizeState } from './SCBGestureBackViewModel';

const TAG = 'PadBackEventViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class PadBackEventViewModel extends BackEventViewModel {

  constructor(persistentId: number, zIndex: number, isLeftArea: boolean,
    viewModelCallBack: BackEventViewModelCallBack | null) {
    super(persistentId, zIndex, isLeftArea, viewModelCallBack)
    this.backGestureModel = new PadBackGestureModel(this.backGestureCallBack, viewModelCallBack)
  }

  /**
   * back手势识别
   * @param event
   */
  protected backGestureRecognize(event: GestureEvent): void {
    if ((event.timestamp - this.startTime) / GestureBackConstants.NS_TO_MS > GestureBackConstants.BACK_TIME_THRESHOLD) {
      // if haven't recognized, check:
      // 1. not exceed 120ms from onActionStart
      this.setGestureFailed(GestureFailReason.TIMEOUT);
      return;
    }
    // 2. x distance from onActionStart > 15px (touchpad is 0 px)
    const distance = event.sourceTool === SourceTool.TOUCHPAD ?
    SwipeInwardConstants.BACK_DISTANCE_THRESHOLD : GestureBackConstants.BACK_DISTANCE_THRESHOLD;
    if (Math.abs(event.offsetX) <= px2vp(distance)) {
      return;
    }
    // 3. angle in 150° hot zone  (touchpad is 95 px)
    const backAngleThreshold = event.sourceTool === SourceTool.TOUCHPAD ?
    SwipeInwardConstants.BACK_ANGLE_THRESHOLD : GestureBackConstants.BACK_ANGLE_THRESHOLD;
    if (this.isValidAngle(event.offsetX, event.offsetY, backAngleThreshold)) {
      log.showInfo('back gesture recognize success');
      this.recognizeState = RecognizeState.SUCCESS;
      this.sendTouchEventController?.setSendState(SendState.NOT_SEND_EVENT);
      this.backGestureModel?.backGestureStart(event, this.isLeftArea, this.startY);
    } else {
      this.setGestureFailed(GestureFailReason.INVALID_ANGLE);
    }
  }

}