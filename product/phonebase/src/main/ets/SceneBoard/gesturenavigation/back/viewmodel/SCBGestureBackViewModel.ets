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

import { LogDomain, LogHelper, CheckEmptyUtils, SingletonHelper } from '@ohos/basicutils';
import {
  ResUtils,
  SCBSceneSessionManager,
  GestureType,
  PcKeyType,
  scbGestureManager,
  SCBSpecificSession,
  SCBSceneSession,
  SCBKeyboardManager,
  SCBScenePanelManager,
  SCBSceneContainerState,
  SCBScreenProperty,
  scbEventExclusiveManager,
  EventType,
  SCBScreenSessionManager,
  SCBRotateChangeReason
} from '@ohos/windowscene';
import {
  viewMgrPolicy,
  ViewType,
  DeviceHelper,
  HiSysEventUtil,
  HiSysBackEventData,
  EventConstants,
  obtainLocalEvent,
  sEventManager
} from '@ohos/frameworkwrapper';
import { GestureDockModeConfig, StyleConstants } from '@ohos/launchercommon';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SendClickEventController } from '@ohos/windowscene/Index';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { gestureBackSettings } from '@ohos/gestureback/src/main/ets/common/GestureBackSettings';
import { GestureBackMetaBallModel } from '@ohos/gestureback/src/main/ets/metaball/viewmodel/GestureBackMetaBallModel';

const TAG = 'SCBGestureBackViewModel';
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

export enum GestureFailReason {
  INVALID_ANGLE = 'invalid_angle',
  TIMEOUT = 'timeout',
  CANCEL_FROM_USER = 'cancel_from_user',
  CANCEL_FROM_SYSTEM = 'cancel_from_system'
}

export class SCBGestureBackViewModel {

  private persistentId: number = 0;
  private zIndex: number = 0;
  private screenProperty: SCBScreenProperty | null = null;
  private sendClickEventController:SendClickEventController | null = null;
  public gestureNavSidWidth: number = gestureBackSettings.getBackResponseRegionWidth();
  public navSideDistToBottom: number = StyleConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT;
  public gestureDockTime: number = 0;

  public static getInstance(): SCBGestureBackViewModel {
    return SingletonHelper.getInstance(SCBGestureBackViewModel, TAG);
  }

  public init(persistentId: number, zIndex: number, screenProperty: SCBScreenProperty) {
    this.persistentId = persistentId;
    this.zIndex = zIndex;
    this.sendClickEventController = new SendClickEventController(TAG, this.persistentId, this.zIndex);
    this.screenProperty = screenProperty;
  }

  /**
   * 注册监听窗口旋转动效
   */
  public registerRotateAnimaChangeCallBack(): void {
    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.rotateAnimaChangeCallBack);
  }

  /**
   * 反注册监听窗口旋转动效
   */
  public unRegisterRotateAnimaChangeCallBack(): void {
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.rotateAnimaChangeCallBack);
  }

  private rotateAnimaChangeCallBack = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) => {
    switch (reason) {
      case SCBRotateChangeReason.ROTATE_BEGIN:
        log.showInfo(`ROTATE_BEGIN`);
        // 监听到旋转动效时，打断抬手动效
        GestureBackMetaBallModel.getInstance().finishUpAnim();
        break;
      case SCBRotateChangeReason.ROTATE_END:
        log.showInfo(`ROTATE_END`);
        break;
      default:
        break;
    }
  }

  /**
   * 新形态小折叠产品折叠状态时，设置左右手势组件宽度、到底部的距离
   */
  public refreshGestureHotZonePocketFold(): void {
    this.gestureNavSidWidth = StyleConstants.OUTER_GESTURE_NAVIGATION_SIDE_WINDOW_WIDTH;
    this.navSideDistToBottom = StyleConstants.OUTER_GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT;
    log.showInfo(`${TAG} refreshGestureHotZoneSingle gestureNavSidWidth = ${this.gestureNavSidWidth} ` +
      `navSideDistToBottom = ${this.navSideDistToBottom}`);
  }

  /**
   * 默认情况下，设置左右手势组件宽度、到底部的距离
   */
  public refreshGestureHotZoneToDefault(): void {
    this.gestureNavSidWidth = gestureBackSettings.getBackResponseRegionWidth();
    this.navSideDistToBottom = StyleConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT;
    log.showInfo(`${TAG} refreshGestureHotZoneToDefault gestureNavSidWidth = ${this.gestureNavSidWidth} ` +
      `navSideDistToBottom = ${this.navSideDistToBottom}`);
  }

  /**
   * 记录PC的退出操作
   * @param type PcKeyType
   * @param isGestureEnabled 是否允许手势操作
   */
  public registerPcKeyCallback(type: PcKeyType, isGestureEnabled: boolean): void {
    log.showInfo(`${TAG} registerPcKeyCallback ${type}`);
    if (!isGestureEnabled) {
      log.showInfo(`${TAG} Gesture is disabled.`);
      return;
    }
    if (scbEventExclusiveManager.isExclusive(EventType.GESTURE_BACK)) {
      scbEventExclusiveManager.restoreAllEventExclusive(EventType.GESTURE_BACK);
      log.showInfo(`${TAG} GESTURE_BACK is exclusive.`);
      return;
    }
    if (viewMgrPolicy.isViewShowing(ViewType.KEYGUARD)) {
      log.showInfo(`${TAG} KEYGUARD isViewShowing.`);
      return;
    }
    switch (type) {
      case PcKeyType.BACK:
        this.processBackEvent(GestureType.PC_BACK);
        break;
      case PcKeyType.BACK_FLOAT:
        this.processBackEvent(GestureType.PC_BACK_FLOAT);
        break;
    }
  }

  /**
   * 执行手势退出操作
   * @param gestureType 手势类型
   * @param event 触发事件
   */
  public processBackEvent(gestureType: GestureType, event?: GestureEvent): void {
    // 如果手电筒提示页面页面显示的话则此页面接收退出信息其他页面不接收
    if (viewMgrPolicy.isViewShowing(ViewType.FLASHLIGHT_TIPS)) {
      scbGestureManager.onGestureEvent(GestureType.BACK, 'FlashlightTips');
      return;
    }
    if (viewMgrPolicy.isViewShowing(ViewType.KEYGUARD)) {
      scbGestureManager.onGestureEvent(gestureType, 'SCBSpecialScenePanel', null, event);
      return;
    }

    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession(this.screenProperty?.screenId);
    if (!focusedSession) {
      log.showError(`${TAG} processBackEvent falied with null session.`);
      return;
    }
    if (focusedSession instanceof SCBSpecificSession &&
      focusedSession.session.type === sceneSessionManager.SessionType.TYPE_PIP) {
      scbGestureManager.onGestureEvent(gestureType, 'SCBPictureInPictureScenePanel', null, event);
    }
    scbGestureManager.onGestureEvent(gestureType, 'SCBScenePanel', null, event);
  }


  /**
   * 设置侧滑控件的控制区域
   * @param sysSceneSession
   * @param inBackGesture 滑动状态
   * @param screenX 屏幕X
   * @param screenY 屏幕Y
   */
  public setBackResponseRegion(isFullScreenResponse: boolean, screenX: number, screenY: number) {
    let sysSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (CheckEmptyUtils.isEmpty(sysSceneSession)) {
      log.showInfo('sysSceneSession is null.');
      return;
    }
    if (isFullScreenResponse) {
      sysSceneSession.setResponseRegion([{ x: 0, y: 0, width: screenX, height: screenY }]);
    } else {
      const windowWidth: number = ArkUIAdapter.vp2px(this.gestureNavSidWidth);
      const windowHeight: number = screenY - ArkUIAdapter.vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')) +
      this.navSideDistToBottom);
      const windowPositionY: number = ArkUIAdapter.vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')));

      sysSceneSession.setResponseRegion([{
        x: 0,
        y: windowPositionY,
        width: windowWidth,
        height: windowHeight
      },
        {
          x: screenX - windowWidth,
          y: windowPositionY,
          width: windowWidth,
          height: windowHeight
        }]);
    }
  }

  /**
   * 注入点击事件
   *
   * @param downEvent 按下事件
   * @param upEvent 抬手事件
   */
  public sendClickEvent(downEvent: TouchEvent, upEvent: TouchEvent) {
    this.sendClickEventController?.sendClickEvent(downEvent, upEvent);
  }
}

const singletonBackViewModel: SCBGestureBackViewModel = SCBGestureBackViewModel.getInstance();
export default singletonBackViewModel;

