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
import {
  ViewArea as ScreenRect,
  CEManager,
  NavBarEventType,
  SCBDesktopCacheManager
} from '@ohos/frameworkwrapper';
import {
  EventType,
  GestureNavigationState,
  GestureType,
  scbGestureManager,
  SCBSceneSessionManager,
  SCBScreenProperty,
  scbEventExclusiveManager,
  SCBScreenSessionManager,
  SCBRotateChangeReason,
} from '@ohos/windowscene';
import { CommonConstants } from '@ohos/launchercommon';
import { SendTouchEventController } from '@ohos/windowscene/Index';
import { commonEventManager } from '@kit.BasicServicesKit';

const TAG = 'SCBGestureNavBarViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export enum PanGestureType {
  DEFAULT = 0,
  GAME_OPERATE = 1
}

export class NavbarPanGesture {
  public isFirstUpSlide: boolean = false;
  private gestureNavigationState_: GestureNavigationState = GestureNavigationState.START;
  private panGestureType_: PanGestureType = PanGestureType.DEFAULT;
  private sendTouchEventController_: SendTouchEventController | null = null;
  private navBarViewModel_: SCBGestureNavBarViewModel;
  public isIgnoreNavBarGesture: boolean = false;
  public isGestureNavBarCancel: boolean = false;
  public lastUpdateEvent: GestureEvent | null = null;

  constructor(navBarViewModel: SCBGestureNavBarViewModel,
    sendTouchEventController?: SendTouchEventController | null) {
    this.initParam();
    this.navBarViewModel_ = navBarViewModel;
    this.sendTouchEventController_ = sendTouchEventController ?? null;
  }

  public get panGestureType(): PanGestureType {
    return this.panGestureType_;
  }

  public set gestureNavigationState(gestureNavigationState: GestureNavigationState) {
    this.gestureNavigationState_ = gestureNavigationState;
  }

  /**
   * PanGesture.start时初始化参数
   * @param aiBarIsShowInStart PanGesture.start时的导航条状态
   */
  public initParam(): void {
    this.isFirstUpSlide = false;
    this.isIgnoreNavBarGesture = false;
    this.isGestureNavBarCancel = false;
    this.gestureNavigationState_ = GestureNavigationState.START;
    this.panGestureType_ = PanGestureType.DEFAULT;
  }

  /**
   * PanGesture.start时检查并记录操作类型，配置支持防误触功能的应用复用游戏操作逻辑
   * @param screenProperty PanGesture.start时的屏幕参数
   */
  public checkAndSetPerationType(): void {
    this.panGestureType_ = PanGestureType.DEFAULT;
  }

  /**
   * 默认操作（上滑多任务/快切）
   * @param gestureEvent 滑动事件
   */
  public defaultPeration(gestureEvent: GestureEvent | null): void {
    if (!gestureEvent) {
      log.showInfo(`pan gesture ${this.gestureNavigationState_} event is null.`);
      return;
    }
    this.navBarViewModel_.processNavigationEvent(this.gestureNavigationState_, gestureEvent);
  }

  /**
   * 防误触操作
   * @param touchEvent 滑动事件
   */
  public accidentalTouchPeration(touchEvent: TouchEvent | null): void {
    this.sendTouchEventController_?.sendTouchEvent(touchEvent);
  }

  public handleOnActionStart(event: GestureEvent): void {
    if (scbEventExclusiveManager.isExclusive(EventType.GESTURE_NAVBAR)) {
      if (event?.fingerList.length === 1) {
        scbEventExclusiveManager.restoreAllEventExclusive(EventType.GESTURE_NAVBAR);
      }
      log.showWarn('gesture is exclusive, cancel start action');
      this.isIgnoreNavBarGesture = true;
      return;
    }
    this.isGestureNavBarCancel = false;
    scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_NAVBAR, true);
    AppStorage.setAndLink('isInNavBarGesture', true);
    this.initParam();
    this.checkAndSetPerationType();
    switch (this.panGestureType) {
      case PanGestureType.DEFAULT:
        this.defaultPeration(event);
        break;
    }
  }

  public handleOnActionUpdate(event: GestureEvent): void {
    this.gestureNavigationState = GestureNavigationState.UPDATE;
    if (this.isIgnoreNavBarGesture) {
      return;
    }
    switch (this.panGestureType) {
      case PanGestureType.DEFAULT:
        this.defaultPeration(event);
        this.lastUpdateEvent = event;
        break;
    }
  }

  public handleOnActionEnd(event: GestureEvent): void {
    this.gestureNavigationState = GestureNavigationState.END;
    if (this.isIgnoreNavBarGesture) {
      this.isIgnoreNavBarGesture = false;
      return;
    }
    if (this.isGestureNavBarCancel) {
      log.showInfo(`pan gesture has been cancel.`);
      return;
    }
    AppStorage.setAndLink('isInNavBarGesture', false);
    scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_NAVBAR, false);
    switch (this.panGestureType) {
      case PanGestureType.DEFAULT:
        this.defaultPeration(event);
        break;
    }
  }

  public handleOnActionCancel(): void {
    this.gestureNavigationState = GestureNavigationState.END;
    if (this.isIgnoreNavBarGesture) {
      this.isIgnoreNavBarGesture = false;
      return;
    }
    scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_NAVBAR, false);
    AppStorage.setAndLink('isInNavBarGesture', false);
    switch (this.panGestureType) {
      case PanGestureType.DEFAULT:
        this.defaultPeration(this.lastUpdateEvent);
        this.lastUpdateEvent = null;
        break;
    }
  }
}

/**
 * SCBGestureNavBar  拆分函数
 *
 * @since 2024-04-16
 */
export class SCBGestureNavBarViewModel {
  private static mInstance: SCBGestureNavBarViewModel;
  public screenRotation: number = CommonConstants.INVALID_VALUE;

  static getInstance(): SCBGestureNavBarViewModel {
    if (SCBGestureNavBarViewModel.mInstance == null) {
      SCBGestureNavBarViewModel.mInstance = new SCBGestureNavBarViewModel();
    }
    return SCBGestureNavBarViewModel.mInstance;
  }

  public registerRotateAnimaChangeCallBack() {
    scbEventExclusiveManager.registerEventExclusive(EventType.ANIMATION_SCREENROTATE, () => {
      scbEventExclusiveManager.setEventExclusive(EventType.ANIMATION_SCREENROTATE, false);
    });
    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.rotateAnimaChangeCallBack);
  }

  private rotateAnimaChangeCallBack = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) => {
    switch (reason) {
      case SCBRotateChangeReason.ROTATE_BEGIN:
        log.showInfo('ROTATE_BEGIN');
        scbEventExclusiveManager.setEventExclusive(EventType.ANIMATION_SCREENROTATE, true);
        SCBDesktopCacheManager.getInstance().resetFreezeStateAndReady('ROTATE_BEGIN');
        break;
      case SCBRotateChangeReason.ROTATE_END:
        log.showInfo('ROTATE_END');
        scbEventExclusiveManager.setEventExclusive(EventType.ANIMATION_SCREENROTATE, false);
        SCBDesktopCacheManager.getInstance().setWallPaperFreezeReady(true, 'ROTATE_END');
        break;
      default:
        break;
    }
  }

  public unRegisterRotateAnimaChangeCallBack() {
    scbEventExclusiveManager.unRegisterEventExclusive(EventType.ANIMATION_SCREENROTATE);
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.rotateAnimaChangeCallBack);
  }

  /**
   * 设置响应热区
   * @param viewHeight 窗口高度
   * @param hotAreaHeight 热区高度
   * @param widthVp 热区宽度
   * @param persistentId 组件ID
   */
  public setResponseRegion(viewHeight: number, hotAreaHeight: number,
    screenProperty: SCBScreenProperty, persistentId: number) {
    let sysSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(persistentId);
    if (sysSceneSession) {
      log.showInfo(`setResponseRegion, viewHeight:${viewHeight}  hotAreaHeight:${hotAreaHeight} \
      viewHeight-vp2px:${vp2px(viewHeight)} hotAreaHeight-vp2px:${vp2px(hotAreaHeight)}`);
      sysSceneSession.setResponseRegion([{
        x: 0,
        y: vp2px(viewHeight - hotAreaHeight),
        width: screenProperty.width,
        height: vp2px(hotAreaHeight)
      }]);
    }
  }

  /**
   * 开启导航
   * @param navState 手势导航类型
   * @param event
   */
  public processNavigationEvent(navState: GestureNavigationState, event: GestureEvent): void {
    log.showInfo(`processNavigationEvent: ${navState}`)
    switch (navState) {
      case GestureNavigationState.START:
        this.sendNavigationEvent(navState, event);
        break;
      case GestureNavigationState.UPDATE:
        this.sendNavigationEvent(navState, event);
        break;
      case GestureNavigationState.END:
      case GestureNavigationState.CANCEL:
        this.publishScenePanelEventMsg(CEManager.CUSTOM_NAVBAR_EVENT, NavBarEventType.NAVBAR_UP);
        this.sendNavigationEvent(navState, event);
        break;
    }
  }

  private sendNavigationEvent(navState: GestureNavigationState, event: GestureEvent): void {
    let screenSessionList = SCBScreenSessionManager.getInstance().getScreenSessionList();
    for (let session of screenSessionList) {
      const sceneType: string = 'SCBScenePanel' + session.scbScreenProperty.screenId;
      scbGestureManager.onGestureEvent(GestureType.NAVIGATION, sceneType, navState, event);
    }
  }

  private publishScenePanelEventMsg(eventNAME: string, eventType: string, parameters?: Record<string, Object>): void {
    let options: commonEventManager.CommonEventPublishData = {
      data: eventType
    };
    if (parameters !== undefined) {
      options.parameters = parameters;
    }
    try {
      commonEventManager.publish(eventNAME, options, () => {
        log.showDebug(`publish ${eventNAME} ${eventType} success`);
      });
    } catch (error) {
      log.showError(`publish ${eventNAME} ${eventType} error ${error}`)
    }
  }

  /**
   * 是否上滑或取消
   * @param type
   * @returns
   */
  public upOrCancelTouch(type: TouchType): boolean {
    return type === TouchType.Up || type === TouchType.Cancel
  }

  /**
   * 保存底部上滑前屏幕的旋转角度
   *
   * @param screenRotation
   */
  public saveScreenRotationOnGestureStart(): void {
    let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    this.screenRotation = screenSession?.sensorScreenProperty?.rotation;
  }
}
