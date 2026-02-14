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

import { TouchEvent } from 'touchEvent';
import { SCBSceneSessionManager } from '../../scene/session/SCBSceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { List } from '@kit.ArkTS';
import { SendTouchUtils } from './SendTouchUtils';
import { SendTouchModel } from './SendTouchModel';

const TAG = 'SendClickEventController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * SendTouchEventController
 */
export class SendClickEventController {

  private tag: string = '';
  private persistentId: number = 0;
  private zIndex: number = 0;
  private delayTime: number = 20;
  private isSending: boolean = false;
  private sendClickModelList: List<SendTouchModel> = new List();

  constructor(tag: string, persistentId: number, zIndex: number) {
    this.tag = tag;
    this.persistentId = persistentId;
    this.zIndex = zIndex;
  }

  public getSendClickModelByFingerId(touchFingerId: number): SendTouchModel | null {
    let sendTouchModel: SendTouchModel | null = null;
    this.sendClickModelList.forEach((value) => {
      if (value.getTouchFingerId() === touchFingerId) {
        sendTouchModel = value;
      }
    });
    return sendTouchModel;
  }

  /**
   * 发送ClickEvent的回调
   */
  private clickCallback = (sendClickModel: SendTouchModel, touchEvent: TouchEvent | undefined) => {
    if (!touchEvent) {
      return;
    }
    switch (touchEvent.type) {
      case TouchType.Down: {
        this.sendTouchEvent(touchEvent);
        let sendClickQueue = sendClickModel.getTouchEventQueue();
        if (sendClickQueue && sendClickQueue.length > 0) {
          sendClickModel.startSendClickEvent();
        }
        break;
      }
      case TouchType.Cancel:
      case TouchType.Up: {
        setTimeout(() => {
          this.sendTouchEvent(touchEvent);
          let sendClickQueue = sendClickModel.getTouchEventQueue();
          if (sendClickQueue && sendClickQueue.length > 0) {
            sendClickModel.startSendClickEvent();
          } else {
            this.sendClickModelList.remove(sendClickModel);
          }
        }, this.delayTime);
        break;
      }
    }
  }

  /*
   * 透传点击事件给下层应用窗口
   *
   * @param downEvent 按压事件
   * @param upEvent 抬起事件
   * @param delayTime 抬手事件的延时时间
   */
  public sendClickEvent(downEvent: TouchEvent | null | undefined,
    upEvent: TouchEvent | null | undefined, delayTime: number = 20): void {
    this.delayTime = delayTime;
    // 为解决多模的注入事件和底座分发的事件fingerId的冲突，临时使用注入事件的fingerid=10000来规避冲突，后续多模给出正式解决方案。
    if (downEvent && upEvent && downEvent.changedTouches[0].id === upEvent.changedTouches[0].id) {
      let sendClickModel: SendTouchModel | null = this.getSendClickModelByFingerId(downEvent.changedTouches[0].id);
      if (!sendClickModel) {
        sendClickModel = new SendTouchModel(this.tag, downEvent.changedTouches[0].id);
        sendClickModel.setClickCallback(this.clickCallback);
        this.sendClickModelList.add(sendClickModel);
        sendClickModel.addTouchEventToQueue(downEvent);
        sendClickModel.addTouchEventToQueue(upEvent);
        sendClickModel.startSendClickEvent();
      } else {
        sendClickModel.addTouchEventToQueue(downEvent);
        sendClickModel.addTouchEventToQueue(upEvent);
      }
    }
  }

  /**
   * 发送TouchEvent
   *
   * @param touchEvent
   */
  public sendTouchEvent(touchEvent: TouchEvent | null): void {
    if (!touchEvent) {
      log.showInfo(`[${this.tag}] send touch event fail, event is empty.`)
      return;
    }
    let zOrder: number = this.zIndex;
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      zOrder = systemSceneSession.getZOrder();
    }
    SendTouchUtils.recordTouchEventLog(this.tag, 'send', touchEvent);
    SCBSceneSessionManager.getInstance().sendTouchEvent(touchEvent, zOrder);
  }
}