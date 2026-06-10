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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BackGestureModel } from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackGestureModel';
import { SwipeInwardConstants } from '../../../touchboardgesture/SwipeInwardEvent';
import { GestureBackConstants } from '@ohos/gestureback/src/main/ets/common/GestureBackConstants';

const TAG = 'PadBackGestureModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class PadBackGestureModel extends BackGestureModel {

  // 抬手防back手势误触
  protected checkAccidentalTouch(event: GestureEvent, isLeftArea: boolean, startX: number, startTime: number): boolean {
    const duration = (event.timestamp - startTime) / GestureBackConstants.NS_TO_MS;
    // 1. 120ms内未滑出热区或者小于64px (32vp), pad touchpad is 32px
    const cancelBackDistanceThreshold120: number = event.sourceTool === SourceTool.TOUCHPAD ?
    SwipeInwardConstants.CANCEL_BACK_DISTANCE_THRESHOLD_120 :
    GestureBackConstants.CANCEL_BACK_DISTANCE_THRESHOLD_120;
    if (duration < GestureBackConstants.BACK_TIME_THRESHOLD &&
      (this.isInBackResponseRegion(event, isLeftArea, startX) ||
        Math.abs(event.offsetX) < px2vp(cancelBackDistanceThreshold120))) {
      log.showInfo(`BackGesture Up antiAccidentalTouch, is in back ResponseRegion or is less than 64px in 120ms. offsetX: ${event.offsetX}`);
      return true;
    }
    // 2. slide offsetX < 32vp (pad touchpad is 16px) and over 150ms from onActionStart to cancel back
    const cancelBackDistanceThreshold: number = event.sourceTool === SourceTool.TOUCHPAD ?
    SwipeInwardConstants.CANCEL_BACK_DISTANCE_THRESHOLD : GestureBackConstants.CANCEL_BACK_DISTANCE_THRESHOLD;
    if (duration > GestureBackConstants.CANCEL_BACK_TIME_THRESHOLD &&
      Math.abs(event.offsetX) < cancelBackDistanceThreshold) {
      log.showInfo(`BackGesture Up antiAccidentalTouch, is less than 32vp out 150ms, offsetX: ${event.offsetX}`);
      return true;
    }
    return false;
  }
}