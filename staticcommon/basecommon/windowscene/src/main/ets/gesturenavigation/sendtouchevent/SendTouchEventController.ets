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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSessionManager } from '../../scene/session/SCBSceneSessionManager';
import { List, Queue } from '@kit.ArkTS';
import systemDateTime from '@ohos.systemDateTime';
import { SendTouchUtils } from './SendTouchUtils';
import { SendTouchModel } from './SendTouchModel';

const TAG = 'SendTouchEventController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export enum SendState {
  NONE,
  // 发送事件(back手势识别失败，点击事件, 长按事件)
  SEND_EVENT,
  // 不发送事件(手势互斥、back手势识别成功)
  NOT_SEND_EVENT
}

// 单根手指Model队列收集的最大数量
const SINGLE_TOUCH_MODEL_QUEUE_MAXCOUNT = 150;

/**
 * SendTouchEventController
 */
export class SendTouchEventController {
  private tag: string = '';
  private persistentId: number = 0;
  private zIndex: number = 0;
  private sendState: SendState = SendState.NONE;
  private sendTouchModelList: List<SendTouchModel> = new List();
  private failedCntMap: Map<SendTouchModel, number> = new Map();
  private failedUpTimeMap: Map<SendTouchModel, number> = new Map();
  private curSendTouchModel: SendTouchModel | null = null;
  private downEvent: TouchEvent | null = null;
  private upEvent: TouchEvent | null = null;

  constructor(tag: string, persistentId: number, zIndex: number) {
    this.tag = tag;
    this.persistentId = persistentId;
    this.zIndex = zIndex;
  }

  /**
   * 获取发送的状态
   *
   * @returns 发送的状态
   */
  public getSendState(): SendState {
    return this.sendState;
  }

  /**
   * 设置发送的状态
   *
   * @param sendState 发送的状态
   */
  public setSendState(sendState: SendState): void {
    this.sendState = sendState;
    log.showInfo(`[${this.tag}] setSendState:${this.sendState}.`);
    if (sendState === SendState.NOT_SEND_EVENT) {
      // 设置为不发送事件，清除当前收集的手指事件
      log.showInfo(`[${this.tag}] not send event, clear all sendTouchModels.`);
      this.clearSendTouchModelList();
    }
  }

  /**
   * 将sendTouchModel加入List中
   *
   * @param sendTouchModel 单个手指注入事件模型
   */
  public addSendTouchModel(sendTouchModel: SendTouchModel): void {
    log.showInfo(`[${this.tag}] addSendTouchModel:fingerId:${sendTouchModel.getTouchFingerId()}`);
    this.sendTouchModelList.add(sendTouchModel);
  }

  /**
   * 根据手指Id，获取List中sendTouchModel
   *
   * @param touchFingerId 手指Id
   * @returns sendTouchModel 单个手指注入事件模型
   */
  public getSendTouchModelByFingerId(touchFingerId: number): SendTouchModel | null {
    let sendTouchModel: SendTouchModel | null = null;
    this.sendTouchModelList.forEach((value) => {
      if (value.getTouchFingerId() === touchFingerId) {
        sendTouchModel = value;
      }
    });
    return sendTouchModel;
  }

  /**
   * 获取List中sendTouchModel
   *
   * @param sendTouchModel 单个手指注入事件模型
   * @returns sendTouchModel List中注入事件模型
   */
  public getSendTouchModelByModel(sendTouchModel: SendTouchModel | null): SendTouchModel | null {
    if (!sendTouchModel) {
      return null;
    }
    return this.getSendTouchModelByFingerId(sendTouchModel.getTouchFingerId());
  }

  /**
   * 获取当前手指的SendTouchModel
   *
   * @returns sendTouchModel 单个手指注入事件模型
   */
  public getCurSendTouchModel(): SendTouchModel | null {
    log.showInfo(`[${this.tag}] curSendTouchModel:{fingerId:${this.curSendTouchModel?.getTouchFingerId()}}`);
    return this.curSendTouchModel;
  }

  /**
   * 删除指定SendTouchModel
   *
   * @param sendTouchModel 单个手指注入事件模型
   */
  public removeSendTouchModel(sendTouchModel: SendTouchModel | null): void {
    if (sendTouchModel && this.getSendTouchModelByModel(sendTouchModel)) {
      this.sendTouchModelList.remove(sendTouchModel);
      this.failedCntMap.delete(sendTouchModel);
      this.failedUpTimeMap.delete(sendTouchModel);
      log.showInfo(`[${this.tag}] The sendTouchModel fingerId:${sendTouchModel?.getTouchFingerId()} has been removed.`);
      log.showInfo(`[${this.tag}] sendTouchModelList:${this.sendTouchModelList.length} `);
      return;
    }
    log.showInfo(`[${this.tag}] The sendTouchModel fingerId:${sendTouchModel?.getTouchFingerId()} remove fail.`);
  }

  /**
   * 清除所有SendTouchModel
   */
  public clearSendTouchModelList(): void {
    log.showInfo(`[${this.tag}] clearSendTouchModelList: ${this.sendTouchModelList.length}.`);
    let deleteTouchModelList = new List<SendTouchModel>();
    this.sendTouchModelList.forEach((sendTouchModel: SendTouchModel) => {
      if (!sendTouchModel.isSendingTouchEvent()) {
        deleteTouchModelList.add(sendTouchModel);
      }
    })
    deleteTouchModelList.forEach((sendTouchModel: SendTouchModel) => {
      this.removeSendTouchModel(sendTouchModel);
    })
    if (this.sendTouchModelList.length === 0) {
      this.curSendTouchModel = null;
    }
  }

  /**
   * 获取现在的透传事件的数量
   * @returns 透传事件的数量
   */
  public getSendNum(): number {
    let num: number = 0;
    this.sendTouchModelList.forEach((sendTouchModel: SendTouchModel) => {
      if (sendTouchModel.isSendingTouchEvent()) {
        num = num + 1;
      }
    });
    return num;
  }

  /**
   * 处理异常手指注入事件，针对ArkUI事件未闭环
   */
  public handleExceptionTouchModels(): void {
    let upTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    let exceptionTouchModelList = new List<SendTouchModel>();

    this.sendTouchModelList.forEach((model: SendTouchModel) => {
      let failedCnt = this.failedCntMap.get(model);
      let failedUpTime = this.failedUpTimeMap.get(model);
      if (failedCnt === undefined || failedUpTime === undefined) {
        this.failedCntMap.set(model, model.getMoveCnt());
        this.failedUpTimeMap.set(model, upTime);
        return;
      }
      // 当前多模最大降帧10Hz 取500ms经验值进行保障
      if (upTime - failedUpTime > 500) {
        if (failedCnt === model.getMoveCnt()) {
          exceptionTouchModelList.add(model);
        } else {
          this.failedCntMap.set(model, model.getMoveCnt());
          this.failedUpTimeMap.set(model, upTime);
        }
      }
    })

    exceptionTouchModelList.forEach((sendTouchModel: SendTouchModel) => {
      log.showInfo(`handle exception sendTouchModel, fingerId:${sendTouchModel.getTouchFingerId()}`);
      this.removeSendTouchModel(sendTouchModel);
    })
  }

  /**
   * 收集TouchEvent
   * @param event 触屏事件
   * @param noSendEvent 手指按下时的事件透传拦截标记
   */
  public receiveTouchEvent(event?: TouchEvent, noSendEvent?: boolean): void {
    // 设置为不注入事件，不再收集touch事件
    if (this.sendState === SendState.NOT_SEND_EVENT) {
      return;
    }
    switch (event?.type) {
      case TouchType.Down:
        if (noSendEvent) {
          log.showInfo(`noSendEvent is ${noSendEvent}`);
          return;
        }
        this.checkSendTouchModelList();
        // 在down事件的时候，指定对应的sendTouchModel
        let sendTouchModel = new SendTouchModel(this.tag, event.changedTouches[0].id);
        this.addSendTouchModel(sendTouchModel);
        this.curSendTouchModel = sendTouchModel;
        this.curSendTouchModel.addTouchEventToQueue(event);
        break;
      case TouchType.Move:
      case TouchType.Up:
      case TouchType.Cancel:
        // 检查当前的SendTouchModel
        this.checkCurSendTouchModel(event);
        this.curSendTouchModel?.addTouchEventToQueue(event);
        break;
      default:
        break;
    }
    // 设置为注入事件，发送收集touch事件
    if (this.sendState === SendState.SEND_EVENT && this.curSendTouchModel) {
      this.sendTouchModelEvent(this.curSendTouchModel);
    }
  }

  /**
   * 发送TouchEvent
   *
   * @param touchEvent
   */
  public sendTouchEvent(touchEvent: TouchEvent | null): void {
    if (this.hasSentEvent(touchEvent)) {
      return;
    }
    let zOrder = this.zIndex;
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      zOrder = systemSceneSession.getZOrder();
    }
    if (!touchEvent) {
      log.showInfo(`[${this.tag}] send touch event fail, event is empty.`)
      return;
    }
    this.saveEvent(touchEvent);
    SendTouchUtils.recordTouchEventLog(this.tag, 'send', touchEvent);
    SCBSceneSessionManager.getInstance().sendTouchEvent(touchEvent, zOrder);
  }

  /**
   * 发送所有收集手指事件
   */
  public sendALLTouchModeEvent(): void {
    if (this.sendTouchModelList.length === 0) {
      return;
    }
    this.sendTouchModelList.forEach((value) => {
      this.sendTouchModelEvent(value);
    });
  }

  /**
   * 发送指定sendTouchModel中的事件
   *
   * @param sendTouchModel 单个手指注入事件模型
   */
  public sendTouchModelEvent(sendTouchModel: SendTouchModel): void {
    // 判断定时器是否在注入过程中，如果注入过程中，则不在注入
    if (sendTouchModel?.isSendingTouchEvent()) {
      return;
    }
    // 判断定时器是否在注入过程中，如果注入过程中，则不在注入
    if (sendTouchModel?.isSendingPanGestureEvent()) {
      return;
    }
    //back手势识别失败，开启定时器下发touch事件
    sendTouchModel?.startSendPanGestureEvent((sendTouchModel: SendTouchModel, touchEvent: TouchEvent) => {
      this.sendTouchEvent(touchEvent);
      if (touchEvent?.type === TouchType.Up || touchEvent?.type === TouchType.Cancel) {
        //下发完成时，关闭定时器
        sendTouchModel?.stopSendPanGestureEvent();
        //从列表中删除
        this.removeSendTouchModel(sendTouchModel);
      }
    });
  }

  /**
   * 检查当前手指SendTouchModel
   *
   * @param event 触屏事件
   */
  private checkCurSendTouchModel(event: TouchEvent): void {
    let fingerId = event?.changedTouches[0]?.id;
    if (this.curSendTouchModel?.getTouchFingerId() !== fingerId) {
      this.curSendTouchModel = this.getSendTouchModelByFingerId(fingerId);
    }
    this.checkTouchEventQueue();
  }

  /**
   * 检查当前手指SendTouchModel的Queue有没有超量存储
   */
  private checkTouchEventQueue(): void {
    // 单个手指：超过150个，一直没有Send，不收集事件，并且清除掉这个根手指
    let touchEventQueue = this.curSendTouchModel?.getTouchEventQueue();
    let isSendingTouchEvent = this.curSendTouchModel?.isSendingTouchEvent();
    if (touchEventQueue && touchEventQueue?.length > SINGLE_TOUCH_MODEL_QUEUE_MAXCOUNT && !isSendingTouchEvent) {
      log.showInfo(`[${this.tag}] touchEventQueue is over 150, no sending.`);
      this.removeSendTouchModel(this.curSendTouchModel);
      this.curSendTouchModel = null;
    }
  }

  /**
   * 检查当前List是否存在异常SendTouchModel
   */
  private checkSendTouchModelList(): void {
    if (this.sendTouchModelList.length === 0) {
      return;
    }
    log.showInfo(`checkSendTouchModelList length: ${this.sendTouchModelList.length}`);
    let isAllUpAndWaitSending: boolean = true;
    this.sendTouchModelList.forEach((value: SendTouchModel) => {
      if (value.isSendingTouchEvent() || !value.getUpEvent()) {
        isAllUpAndWaitSending = false;
      }
    })
    if (isAllUpAndWaitSending) {
      log.showInfo(`checkSendTouchModelList is all up and not sending`);
      this.clearSendTouchModelList();
    }
  }

  private hasSentEvent(touchEvent: TouchEvent | null): boolean {
    return this.downEvent === touchEvent || this.upEvent === touchEvent;
  }

  private saveEvent(touchEvent: TouchEvent) {
    if (touchEvent.type === TouchType.Down) {
      this.downEvent = touchEvent;
    } else if (touchEvent.type === TouchType.Up) {
      this.upEvent = touchEvent;
    }
  }
}