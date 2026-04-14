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
import {
  EventConstants,
  HiSysBackEventData,
  HiSysEventUtil,
  obtainLocalEvent,
  sEventManager
} from '@ohos/frameworkwrapper';
import { ResUtils, SCBScenePanelManager, SCBSceneSessionManager } from '@ohos/windowscene';
import { SendTouchEventController, SendState } from '@ohos/windowscene/Index';
import { GestureFailReason, BackEventViewModelCallBack } from './BackEventViewModelCallBack';
import { BackGestureModel } from './BackGestureModel';
import { BackGestureModelCallBack } from './BackGestureModelCallBack';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureBackConstants } from '../../common/GestureBackConstants';
import { gestureBackSettings } from '../../common/GestureBackSettings';

const TAG = 'BackEventViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export enum ActionType {
  START,
  UPDATE,
  END,
  CANCEL
}

export enum RecognizeState {
  NONE,
  SUCCESS,
  FAIL
}

export class BackEventViewModel {
  private persistentId: number = 0;
  private zIndex: number = 0;
  protected startTime: number = 0;
  private startX: number = 0;
  protected startY: number = 0;
  protected isLeftArea: boolean = false;
  // 是否在滑动过程中，防误触识别了
  private hasCheckAccidentalTouch: boolean = false;
  protected recognizeState: RecognizeState = RecognizeState.NONE;
  private isPanGestureFinished: boolean = false;
  protected sendTouchEventController: SendTouchEventController | null = null;
  protected backGestureModel: BackGestureModel | null = null;
  private viewModelCallBack: BackEventViewModelCallBack | null = null;

  constructor(persistentId: number, zIndex: number, isLeftArea: boolean,
              viewModelCallBack: BackEventViewModelCallBack | null) {
    this.persistentId = persistentId;
    this.zIndex = zIndex;
    this.isLeftArea = isLeftArea;
    this.sendTouchEventController = new SendTouchEventController(TAG, this.persistentId, this.zIndex);
    this.viewModelCallBack = viewModelCallBack;
    if (this.backGestureCallBack !== null) {
      this.backGestureModel = new BackGestureModel(this.backGestureCallBack, viewModelCallBack);
    }
  }

  protected backGestureCallBack: BackGestureModelCallBack = {

    // back手势被互斥
    onIgnoreBackGesture: (): void => {
      this.recognizeState = RecognizeState.NONE;
      this.sendTouchEventController?.setSendState(SendState.NONE);
    },

    // back手势反悔Cancel
    onBackGestureCancelForUser: (backDirection: string): void => {
      this.viewModelCallBack?.onBackGestureCancelForUser();
      this.setGestureFailed(GestureFailReason.CANCEL_FROM_USER);
      this.reportBackParam(HiSysBackEventData.CANCEL, backDirection);
      this.recognizeState = RecognizeState.NONE;
      this.sendTouchEventController?.setSendState(SendState.NONE);
    },

    // back手势系統Cancel
    onBackGestureCancel: (): void => {
      this.viewModelCallBack?.onBackGestureCancel();
      this.setGestureFailed(GestureFailReason.CANCEL_FROM_SYSTEM);
      this.recognizeState = RecognizeState.NONE;
      this.sendTouchEventController?.setSendState(SendState.NONE);
    },

    // 发送back事件
    onSendGestureBackTo: (event: GestureEvent): void => {
      this.viewModelCallBack?.onSendGestureBackTo(this.isLeftArea, event);
      this.recognizeState = RecognizeState.NONE;
      this.sendTouchEventController?.setSendState(SendState.NONE);
      sEventManager.publish(obtainLocalEvent(EventConstants.BACK_GESTURE, true));
    }
  };

  /**
   * back打点参数
   */
  public reportBackParam(result: string, side?: string) {
    let containerSession = SCBScenePanelManager.getInstance().getSceneContainerSessionList().getTopActiveSession();
    HiSysEventUtil.reportBackEvent(result, side, containerSession?.isMidScene,
      containerSession?.getBundleName() ?? 'desktop');
  }

  /**
   * 无障碍事件透传
   *
   * @param event 无障碍事件
   */
  public onAccessibilityHoverTransparent(event: TouchEvent) {
    log.showInfo(`onAccessibilityHoverTransparent event:fingerId=${event?.changedTouches[0]?.id},type:${event?.type}`);
    this.sendTouchEventController?.sendTouchEvent(event);
  }

  /**
   * touch事件相关操作
   * @param sendTouchEventController 事件发送控制器
   * @param startY 事件发生点在纵向的位置
   * @param event 事件对象
   * @returns 事件发生点在纵向的位置
   */
  public onTouchEvent(screenHeight: number, event?: TouchEvent) {
    //接受touch事件
    this.sendTouchEventController?.receiveTouchEvent(event);
    if (event?.type === TouchType.Down) {
      this.startY = this.getBackGestureStartY(event.changedTouches[0].y, screenHeight);
      this.startX = event.changedTouches[0].x;
    }
  }

  /**
   * Click事件相关操作
   * @param sendTouchEventController 事件发送控制器
   * @param persistentId 组件ID
   */
  public onClickEvent(): void {
    let curSendTouchModel = this.sendTouchEventController?.getCurSendTouchModel();
    if (curSendTouchModel) {
      this.viewModelCallBack?.onSendClickEventTo(curSendTouchModel?.getDownEvent(), curSendTouchModel?.getUpEvent())
      this.sendTouchEventController?.clearSendTouchModelList();
    }
  }

  /**
   * 长按相关操作
   *
   * @param actionType 操作类型
   * @param sendTouchEventController 事件发送控制器
   */
  public onLongPressGestureAction(actionType: ActionType): void {
    switch (actionType) {
      case ActionType.START:
        this.sendTouchEventController?.sendALLTouchModeEvent();
        this.sendTouchEventController?.setSendState(SendState.SEND_EVENT);
        break;
      case ActionType.END:
      case ActionType.CANCEL:
        this.sendTouchEventController?.setSendState(SendState.NONE);
        break;
    }
  }

  /**
   * 鼠标事件透传
   */
  public onMouseTouch(): void {
    this.sendTouchEventController?.sendALLTouchModeEvent();
    this.sendTouchEventController?.setSendState(SendState.SEND_EVENT);
  }

  /**
   * 滑动事件-Start
   * @param event
   */
  public onPanGestureActionStart(event: GestureEvent) {
    let sysSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    sysSceneSession.setSkipDraw(false);
    this.startTime = event.timestamp;
    this.isPanGestureFinished = false;
    this.hasCheckAccidentalTouch = false;
    this.recognizeState = RecognizeState.NONE;
    this.sendTouchEventController?.setSendState(SendState.NONE);
  }

  /**
   * 滑动事件-Update
   * @param event
   */
  public onPanGestureActionUpdate(event: GestureEvent) {
    if (this.isPanGestureFinished) {
      log.showInfo('back gesture has been finished.');
      return;
    }
    if (this.recognizeState === RecognizeState.FAIL) {
      log.showError(`recognize back gesture fail.offsetX=${event.offsetX},isLeftArea=true`);
      this.sendTouchEventController?.handleExceptionTouchModels();
      return;
    }
    if (this.recognizeState === RecognizeState.SUCCESS) {
      // back手势识别成为后，做back手势跟手防误触
      // 已检测过大于120msBack手势跟手防误触, 后续不再识别
      if (!this.hasCheckAccidentalTouch && this.checkAccidentalTouch(event)) {
        log.showInfo(`Update antiAccidentalTouch, in ResponseRegion over ${gestureBackSettings.getBackTimeThreshold()}ms, back cancel.`);
        this.onPanGestureActionCancel();
        return;
      }
      this.backGestureModel?.backGestureUpdate(event, this.isLeftArea);
      return;
    }
    this.backGestureRecognize(event);
  }

  /**
   * 滑动事件-End
   * @param event
   */
  public onPanGestureActionEnd(event: GestureEvent) {
    if (this.isPanGestureFinished) {
      log.showInfo('back gesture has been finish.');
      return;
    }
    this.isPanGestureFinished = true;

    const backDirection = this.isLeftArea ? HiSysBackEventData.LEFT : HiSysBackEventData.RIGHT
    switch (this.recognizeState) {
      case RecognizeState.NONE:
        log.showInfo('backGestureEnd ignore, not recognized');
        this.sendTouchEventController?.sendALLTouchModeEvent();
        this.reportBackParam(HiSysBackEventData.CANCEL, backDirection);
        break;
      case RecognizeState.FAIL:
        log.showInfo('backGestureEnd ignore, not recognized');
        this.recognizeState = RecognizeState.NONE;
        this.sendTouchEventController?.setSendState(SendState.NONE);
        this.reportBackParam(HiSysBackEventData.CANCEL, backDirection);
        break;
      case RecognizeState.SUCCESS:
        this.backGestureModel?.backGestureEnd(event, this.startX, this.startTime, this.isLeftArea);
        break;
      default:
        break;
    }

  }

  /**
   * 滑动事件-Cancel
   * @param event
   */
  public onPanGestureActionCancel() {
    log.showInfo('onActionCancel.');
    if (this.isPanGestureFinished) {
      log.showInfo('back gesture has been finish.');
      return;
    }
    this.isPanGestureFinished = true;
    switch (this.recognizeState) {
      case RecognizeState.NONE:
        this.sendTouchEventController?.sendALLTouchModeEvent();
        break;
      case RecognizeState.FAIL:
        this.recognizeState = RecognizeState.NONE;
        this.sendTouchEventController?.setSendState(SendState.NONE);
        break;
      case RecognizeState.SUCCESS:
        this.backGestureModel?.backGestureCancel();
        break;
      default:
        break;
    }
    let containerSession = SCBScenePanelManager.getInstance().getSceneContainerSessionList().getTopActiveSession();
    HiSysEventUtil.reportBackEvent(HiSysBackEventData.CANCEL, undefined, undefined,
      containerSession?.getBundleName() ?? 'desktop');
  }

  /**
   * back手势识别
   * @param event
   */
  protected backGestureRecognize(event: GestureEvent): void {
    if ((event.timestamp - this.startTime) / GestureBackConstants.NS_TO_MS >
      gestureBackSettings.getBackTimeThreshold()) {
      // if haven't recognized, check:
      // 1. not exceed 120ms from onActionStart
      this.setGestureFailed(GestureFailReason.TIMEOUT);
      return;
    }
    // 2. x distance from onActionStart > 15px
    if (Math.abs(event.offsetX) <= px2vp(gestureBackSettings.getBackDistanceThreshold())) {
      return;
    }
    // 3. angle in 150° hot zone
    if (this.isValidAngle(event.offsetX, event.offsetY, GestureBackConstants.BACK_ANGLE_THRESHOLD)) {
      log.showInfo('back gesture recognize success');
      this.recognizeState = RecognizeState.SUCCESS;
      this.sendTouchEventController?.setSendState(SendState.NOT_SEND_EVENT);
      this.backGestureModel?.backGestureStart(event, this.isLeftArea, this.startY);
    } else {
      this.setGestureFailed(GestureFailReason.INVALID_ANGLE);
    }
  }

  /*
   * 检测是否是back手势跟手误触
   *
   * return true：属于误触, false：非误触
   */
  private checkAccidentalTouch(event: GestureEvent): boolean {
    if ((event.timestamp - this.startTime) / GestureBackConstants.NS_TO_MS >
      gestureBackSettings.getBackTimeThreshold()) {
      // 大于120ms, 开始检测是否是back手势跟手误触
      this.hasCheckAccidentalTouch = true;
      // 大于120ms, 手指在back热区, 则识别失败, back手势跟手误触
      if (this.backGestureModel?.isInBackResponseRegion(event, this.isLeftArea, this.startX)) {
        return true;
      }
    }
    return false;
  }


  /**
   * 判断手指滑动角度是否符合要求
   * @param offsetX 手指横向移动距离
   * @param offsetY 手指纵向移动距离
   * @param backAngleThresold 手指滑动角度界限
   * @returns 手指滑动角度是否符合要求
   */
  protected isValidAngle(offsetX: number, offsetY: number, backAngleThresold: number): boolean {
    if (offsetX === 0) {
      return false;
    }
    const angle = Math.atan(offsetY / offsetX) / Math.PI * 180;
    return Math.abs(angle) < backAngleThresold;
  }

  /**
   * back手势识别失败
   *
   * @param reason 失败原因
   */
  protected setGestureFailed(reason: GestureFailReason): void {
    log.showError(`back gesture recognize failed, reason=${reason}`);
    this.recognizeState = RecognizeState.FAIL;
    this.viewModelCallBack?.onRecognizeFail(reason);
    this.GestureFailInjectDown(reason);
  }

  /**
   * 获取back手势起始的Y坐标
   */
  private getBackGestureStartY(startY: number, screenHeight: number): number {
    let backGestureStartY = startY;
    let topY = px2vp(StyleConstants.GESTURE_NAVIGATION_BACK_CANVAS_WIDTH);
    let bottomY = px2vp(screenHeight) - (StyleConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT +
    ResUtils.getNumber($r('app.float.status_bar_phone_height')) + px2vp(StyleConstants.GESTURE_NAVIGATION_BACK_CANVAS_WIDTH));

    log.showInfo(`topY: ${px2vp(StyleConstants.GESTURE_NAVIGATION_BACK_CANVAS_WIDTH)}`);

    if (backGestureStartY < topY) {
      backGestureStartY = topY;
    }
    if (backGestureStartY > bottomY) {
      backGestureStartY = bottomY;
    }

    return backGestureStartY;
  }

  public setSendStateNotSend() {
    this.sendTouchEventController?.setSendState(SendState.NOT_SEND_EVENT);
  }

  public getGestureRecognizeState(): RecognizeState {
    return this.recognizeState;
  }

  /**
   * back手势识别失败, 事件向下层窗口注入
   * @param reason 失败原因
   * @param sendTouchEventController 事件发送控制器
   */
  public GestureFailInjectDown(reason: GestureFailReason) {
    if (reason !== (GestureFailReason.CANCEL_FROM_USER || GestureFailReason.CANCEL_FROM_SYSTEM)) {
      this.sendTouchEventController?.setSendState(SendState.SEND_EVENT);
      this.sendTouchEventController?.sendALLTouchModeEvent();
    }
  }
}