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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BackEventViewModel } from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackEventViewModel';
import { SwipeInwardConstants, SwipeInwardController } from './SwipeInwardEvent';
import { SwipeInwardCallback, TouchBoardSwipeInwardGestureManager } from './SwipeInwardGestureManager';

const TAG = 'SwipeInwardBackModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class SwipeInwardBackModel {
  // 内滑手势
  private swipeInwardController: SwipeInwardController = new SwipeInwardController();
  private touchPadResponseViewModel: BackEventViewModel | null = null;
  private leftResponseViewModel: BackEventViewModel | null = null;
  private rightResponseViewModel: BackEventViewModel | null = null;
  private screenX: number = 0;
  private screenY: number = 0;

  constructor(leftResponseViewModel: BackEventViewModel | null, rightResponseViewModel: BackEventViewModel | null,
    screenX: number, screenY: number) {
    this.leftResponseViewModel = leftResponseViewModel;
    this.rightResponseViewModel = rightResponseViewModel;
    this.screenX = screenX;
    this.screenY = screenY;
  }

  public registerSwipeInwardCallback(): void {
    TouchBoardSwipeInwardGestureManager.getInstance().registerSwipeInwardCallback(this.swipeInwardCallback);
  }
  public unRegisterSwipeInwardCallback(): void {
    TouchBoardSwipeInwardGestureManager.getInstance().unRegisterSwipeInwardCallback(this.swipeInwardCallback);
  }


  private swipeInwardCallback: SwipeInwardCallback = {
    name: 'swipeInward',
    onSwipeInwardBegin: (x: number, y: number, time: number) => {
      this.swipeInwardController.reset();
      this.swipeInwardController.beginHandle(x, y, time);
      this.touchPadResponseViewModel = x < SwipeInwardConstants.SWIPE_INWARD_TOUCHPAD_WIDTH *
      SwipeInwardConstants.SWIPE_INWARD_HALF ? this.leftResponseViewModel : this.rightResponseViewModel;
      if (!this.touchPadResponseViewModel) {
        return;
      }
      const event: GestureEvent = this.swipeInwardController.createGestureEvent(x, y, this.screenX, this.screenY);
      log.showInfo(`onSwipeInwardBegin, offsetX: ${event.offsetX}, globalX: ${event.fingerList[0].globalX}`);
      this.touchPadResponseViewModel?.onPanGestureActionStart(event);
    },
    onSwipeInwardUpdate: (x: number, y: number, time: number) => {
      if (!this.swipeInwardController.getHandleState()) {
        return;
      }
      if (!this.touchPadResponseViewModel) {
        return;
      }
      this.swipeInwardController.updatePointerData(x, y, time);
      this.swipeInwardController.calculateAndJudge();
      const event: GestureEvent = this.swipeInwardController.createGestureEvent(x, y, this.screenX, this.screenY);
      this.touchPadResponseViewModel?.onPanGestureActionUpdate(event);
    },
    onSwipeInwardEnd: (x: number, y: number, time: number) => {
      if (!this.touchPadResponseViewModel) {
        return;
      }
      if (this.swipeInwardController.judgeIfDoBack()) {
        // 返回操作接口
        log.showInfo('onSwipeInwardEnd:do go back action');
        this.swipeInwardController.updatePointerData(x, y, time);
        const event: GestureEvent = this.swipeInwardController.createGestureEvent(x, y, this.screenX, this.screenY);
        this.touchPadResponseViewModel?.onPanGestureActionEnd(event);
      } else {
        log.showInfo('onSwipeInwardEnd:judgeIfDoBack failed, cancel');
        this.touchPadResponseViewModel?.onPanGestureActionCancel();
      }
      this.swipeInwardController.endHandle();
      this.swipeInwardController.reset();
    },
  }

}