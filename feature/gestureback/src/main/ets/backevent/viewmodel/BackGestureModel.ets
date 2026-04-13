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

import { BackGestureModelCallBack } from './BackGestureModelCallBack';
import { BackEventViewModelCallBack } from './BackEventViewModelCallBack';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { EvtBus, HiSysBackEventData, RotateChangeEvent } from '@ohos/frameworkwrapper';
import { scbEventExclusiveManager, EventType } from '@ohos/windowscene';
import { MetaBallUtils } from '../../metaball/common/MetaBallUtils';
import { GestureBackConstants } from '../../common/GestureBackConstants';
import { gestureBackSettings } from '../../common/GestureBackSettings';

const TAG = 'BackGestureModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class BackGestureModel {

  private isIgnoreBackGesture: boolean = false;
  private viewModelCallBack: BackEventViewModelCallBack | null = null;
  private callBack: BackGestureModelCallBack | null = null;

  constructor(callBack: BackGestureModelCallBack, viewModelCallBack: BackEventViewModelCallBack | null) {
    this.callBack = callBack;
    this.viewModelCallBack = viewModelCallBack;
  }

  public backGestureStart(event: GestureEvent, isLeftArea: boolean, startY: number) {
    log.showInfo(`backGestureStart, startY:${startY}`);
    if (scbEventExclusiveManager.isExclusive(EventType.GESTURE_BACK)) {
      if (event.fingerList.length === 1) {
        scbEventExclusiveManager.restoreAllEventExclusive(EventType.GESTURE_BACK);
      }
      this.isIgnoreBackGesture = true;
      return;
    }
    this.viewModelCallBack?.onBackGestureStart(event, isLeftArea, startY);
  }

  public backGestureUpdate(event: GestureEvent, isLeftArea: boolean) {
    if (this.isIgnoreBackGesture) {
      return;
    }
    // if recognized as back gesture, update meta ball animation
    let animProcess = MetaBallUtils.calculateAnimProcess(isLeftArea ? event.offsetX : -event.offsetX);
    this.viewModelCallBack?.onBackGestureUpdate(isLeftArea, event, animProcess);
  }

  public backGestureEnd(event: GestureEvent, startX: number, startTime: number, isLeftArea: boolean) {
    log.showInfo('backGestureEnd');
    if (this.isIgnoreBackGesture) {
      this.isIgnoreBackGesture = false;
      this.callBack?.onIgnoreBackGesture();
      return;
    }
    this.viewModelCallBack?.onBackGestureEnd();

    const backDirection = isLeftArea ? HiSysBackEventData.LEFT : HiSysBackEventData.RIGHT
    if (this.checkAccidentalTouch(event, isLeftArea, startX, startTime)) {
      this.callBack?.onBackGestureCancelForUser(backDirection);
      return;
    }

    // 当执行back手势时会打断当前旋转过程
    let rotateEvent: RotateChangeEvent = RotateChangeEvent.create(RotateChangeEvent.ROTATE_STATUS_CANCEL);
    EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);

    log.showInfo(`on pan gesture to send back. isLeftArea=${isLeftArea}`);
    this.callBack?.onSendGestureBackTo(event);
  }

  // 抬手防back手势误触
  protected checkAccidentalTouch(event: GestureEvent, isLeftArea: boolean, startX: number, startTime: number): boolean {
    const duration = (event.timestamp - startTime) / GestureBackConstants.NS_TO_MS;
    // 1. 如果抬手坐标在热区内，则back失败；
    if (this.isInBackResponseRegion(event, isLeftArea, startX)) {
      log.showInfo('Up antiAccidentalTouch, in ResponseRegion');
      return true;
    }
    // 2. 如果手势时间小于120ms，滑动距离小于64px，则back失败
    if (duration < GestureBackConstants.BACK_TIME_THRESHOLD &&
      Math.abs(event.offsetX) < px2vp(GestureBackConstants.CANCEL_BACK_DISTANCE_THRESHOLD_120)) {
      log.showInfo(`Up antiAccidentalTouch, less than 64px in ${gestureBackSettings.getBackTimeThreshold()}ms.`);
      return true;
    }
    // 3. 如果手势时间大于150ms，滑动距离小于32vp，则back失败
    if (duration > GestureBackConstants.CANCEL_BACK_TIME_THRESHOLD &&
      Math.abs(event.offsetX) < GestureBackConstants.CANCEL_BACK_DISTANCE_THRESHOLD) {
      log.showInfo(`Up antiAccidentalTouch, is less than 32vp over 150ms.`);
      return true;
    }
    return false;
  }

  /**
   * 是否在back手势热区内
   *
   * @param event
   */
  public isInBackResponseRegion(event: GestureEvent, isLeftArea: boolean, startX: number): boolean {
    log.showInfo(`startX：${vp2px(startX)}, event.offsetX：${vp2px(event.offsetX)}, isInBackResponseRegion：${vp2px(gestureBackSettings.getBackResponseRegionWidth())}`);
    let isInBackResponseRegion = false;
    if (isLeftArea) {
      isInBackResponseRegion = startX + event.offsetX <= gestureBackSettings.getBackResponseRegionWidth();
    } else {
      isInBackResponseRegion = startX + event.offsetX > 0;
    }
    return isInBackResponseRegion;
  }

  public backGestureCancel() {
    log.showInfo('backGestureCancel');
    if (this.isIgnoreBackGesture) {
      this.isIgnoreBackGesture = false;
      this.callBack?.onIgnoreBackGesture();
      return;
    }
    this.callBack?.onBackGestureCancel();
  }

}