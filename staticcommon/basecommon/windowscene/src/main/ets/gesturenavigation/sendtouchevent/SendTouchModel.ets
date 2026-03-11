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

import { Queue } from '@kit.ArkTS';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { TouchEvent } from 'touchEvent';
import { SendTouchUtils } from './SendTouchUtils';

const TAG = 'SendTouchModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);
const INVALID_ID: number = -1;

export class SendTouchModel {
  private tag: string = '';
  private persistentId: number = 0;
  private zIndex: number = 0;
  private touchFingerId: number = INVALID_ID;
  private intervalId: number = INVALID_ID;
  private isSending: boolean = false;
  private downEvent: TouchEvent | null = null;
  private upEvent: TouchEvent | null = null;
  private moveCnt: number = 0;
  private touchEventQueue: Queue<TouchEvent> | null = null;
  private clickCallback: ((sendClickModel: SendTouchModel, touchEvent: TouchEvent,
                           zIndex: number) => void) | null = null;

  constructor(tag: string, touchFingerId: number) {
    this.tag = tag;
    this.touchFingerId = touchFingerId;
  }

  public isSendingTouchEvent(): boolean {
    return this.isSending;
  }

  public setSendingTouchEvent(isSending: boolean) {
    this.isSending = isSending;
  }

  public setClickCallback(clickCallback: (sendClickModel: SendTouchModel, touchEvent: TouchEvent, zIndex: number) =>
  void): void {
    this.clickCallback = clickCallback;
  }

  public getClickCallback(): ((sendClickModel: SendTouchModel, touchEvent: TouchEvent, zIndex: number) => void) | null {
    return this.clickCallback;
  }

  public setDownEvent(downEvent: TouchEvent): void {
    this.downEvent = downEvent;
  }

  public getDownEvent(): TouchEvent | null {
    return this.downEvent;
  }

  public setUpEvent(upEvent: TouchEvent): void {
    this.upEvent = upEvent;
  }

  public getUpEvent(): TouchEvent | null {
    return this.upEvent;
  }

  public getMoveCnt(): number {
    return this.moveCnt;
  }

  public setTouchFingerId(touchFingerId: number): void {
    this.touchFingerId = touchFingerId;
  }

  public getTouchFingerId(): number {
    return this.touchFingerId;
  }

  public setPersistentId(persistentId: number): void {
    this.persistentId = persistentId;
  }

  public getPersistentId(): number {
    return this.persistentId;
  }

  public setZIndex(zIndex: number): void {
    this.zIndex = zIndex;
  }

  public getZIndex(): number {
    return this.zIndex;
  }

  /**
   *将touchEvent放入队列
   *
   * @paramevent
   * @paramevent
   */
  public addTouchEventToQueue(event?: TouchEvent): void {
    if (!event) {
      log.showInfo(`[${this.tag}]addTouchEventToQueue fail：event is empty.`);
      return;
    }
    if (!this.touchEventQueue) {
      this.touchEventQueue = new Queue();
    }
    this.touchEventQueue.add(event);
    if (event.type === TouchType.Down) {
      this.setDownEvent(event);
    }
    if (event.type === TouchType.Move) {
      this.moveCnt++;
    }
    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.setUpEvent(event);
    }
    SendTouchUtils.recordTouchEventLog(this.tag, 'receive', event);
  }

  public clearTouchEventQueue(): void {
    this.touchEventQueue = null;
  }

  public getTouchEventQueue(): Queue<TouchEvent> | null {
    return this.touchEventQueue;
  }

  public isSendingPanGestureEvent(): boolean {
    return this.intervalId !== INVALID_ID;
  }

  public startSendClickEvent(): void {
    if (!this.touchEventQueue) {
      log.showInfo('touchEventQueue is null.');
      return;
    }
    log.showInfo('startSendClickEvent:' + this.touchEventQueue.length);
    this.isSending = true;
    let touchEvent: TouchEvent | undefined = this.touchEventQueue.pop();
    this.clickCallback?.(this, touchEvent, this.zIndex);
  }

  /**
   *开始发送滑动事件
   */
  public startSendPanGestureEvent(callback: (sendTouchModel: SendTouchModel, touchEvent: TouchEvent) => void): void {
    if (this.intervalId === INVALID_ID) {
      log.showInfo(`[${this.tag}]fingerId:${this.getTouchFingerId()}start sending touchevent.`);
      this.isSending = true;
      this.intervalId = setInterval(() => {
        let touchEvent = this.touchEventQueue?.pop();
        if (touchEvent) {
          callback(this, touchEvent);
        }
      }, 5);
    }
  }

  /**
   *停止发送滑动事件
   */
  public stopSendPanGestureEvent(): void {
    clearInterval(this.intervalId);
    this.touchEventQueue = null;
    this.intervalId = INVALID_ID;
    this.isSending = false;
    log.showInfo(`[${this.tag}]The sendTouchModel fingerId:${this.getTouchFingerId()}stop sending touchevent.`);
  }
}