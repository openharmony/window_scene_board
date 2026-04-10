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

import { LogDomain, LogHelper, CheckEmptyUtils, SingletonHelper } from '@ohos/basicutils';
import {
  SCBSceneSessionManager,
  GestureType,
  scbGestureManager,
  SCBSystemSceneSession,
  SCBSessionRect,
  SCBScreenSessionManager,
  SCBScreenProperty,
  SCBSpecificSession
} from '@ohos/windowscene';
import { FormCenterViewManager, StyleConstants} from '@ohos/launchercommon';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SendClickEventController } from '@ohos/windowscene/Index';

const TAG = 'SCBGestureBackViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);
const FOLD_KEYBOARD_DOCK_MARGIN = 18;

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
  public gestureDockTime: number = 0;
  private persistentId: number = 0;
  private zIndex: number = 0;
  private screenProperty: SCBScreenProperty | null = null;
  private sendClickEventController:SendClickEventController | null = null;
  private statusBarHeight: number = 0;
  private dockHeight: number = 0;
  private backWindowResponseWidth: number = vp2px(StyleConstants.GESTURE_NAVIGATION_SIDE_WINDOW_WIDTH);

  public static getInstance(): SCBGestureBackViewModel {
    return SingletonHelper.getInstance(SCBGestureBackViewModel, TAG);
  }

  public init(persistentId: number, zIndex: number, screenProperty: SCBScreenProperty) {
    this.persistentId = persistentId;
    this.zIndex = zIndex;
    this.sendClickEventController = new SendClickEventController(TAG, this.persistentId, this.zIndex);
    this.screenProperty = screenProperty;
  }

  public sendClickEvent(downEvent: TouchEvent, upEvent: TouchEvent) {
    this.sendClickEventController?.sendClickEvent(downEvent, upEvent);
  }

  /**
   * 手势使能变化时修改响应区域
   * @param isEnabled 是否使能
   */
  public changeRegionIfEnableChange(isEnabled: boolean, screenX: number, screenY: number) {
    log.showInfo(`changeResponseIfEnableChange isEnabled = ${isEnabled}`);
    this.backWindowResponseWidth = isEnabled ? vp2px(StyleConstants.GESTURE_NAVIGATION_SIDE_WINDOW_WIDTH) : 0;
    this.setBackResponseRegion(screenX, screenY);
  }

  /**
   * 执行手势退出操作
   * @param gestureType 手势类型
   * @param event 触发事件
   */
  public processBackEvent(gestureType: GestureType, event?: GestureEvent): void {
    log.showInfo('processBackEvent begin');
    ContextMenu.close();
    FormCenterViewManager.getInstance().closeFormCenterView();
    let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession(this.screenProperty?.screenId);
    if (!focusedSession) {
      log.showError(`${TAG} processBackEvent falied with null session.`);
      return;
    }
    if (focusedSession instanceof SCBSpecificSession &&
      focusedSession.session.type === sceneSessionManager.SessionType.TYPE_PIP) {
      scbGestureManager.onGestureEvent(gestureType, 'SCBPictureInPictureScenePanel', null, event);
    }
    const sceneType: string = 'SCBScenePanel' + SCBSceneSessionManager.getInstance().mainScreenId;
    scbGestureManager.onGestureEvent(gestureType, sceneType, null, event);
  }

  public setSystemBarHeight(statusBarHeight: number, dockHeight: number): void {
    this.statusBarHeight = statusBarHeight;
    this.dockHeight = dockHeight;
  }

  private setFoldResponseRegionWithoutKeyboard(sysSceneSession: SCBSystemSceneSession, screenX: number,
    screenY: number, foldCreaseRegion: SCBSessionRect): void {
    const responseRegionBHeight = foldCreaseRegion.top.getPx() - this.statusBarHeight;
    const responseRegionYC = foldCreaseRegion.top.getPx() + foldCreaseRegion.height.getPx();
    const responseRegionCHeight = screenY - responseRegionYC - this.dockHeight;
    log.showInfo(`setFoldResponseRegionWithoutKeyboard  responseRegionCHeight: ${responseRegionCHeight}`);
    sysSceneSession.setResponseRegion([{
      // B面左
      x: 0,
      y: this.statusBarHeight,
      width: this.backWindowResponseWidth,
      height: responseRegionBHeight
    },
      // B面右
      {
        x: screenX - this.backWindowResponseWidth,
        y: this.statusBarHeight,
        width: this.backWindowResponseWidth,
        height: responseRegionBHeight
      },
      // C面左
      {
        x: 0,
        y: responseRegionYC,
        width: this.backWindowResponseWidth,
        height: responseRegionCHeight
      },
      //C面右
      {
        x: screenX - this.backWindowResponseWidth,
        y: responseRegionYC,
        width: this.backWindowResponseWidth,
        height: responseRegionCHeight
      }]);
  }

  private setFoldResponseRegionWithKeyboard(sysSceneSession: SCBSystemSceneSession, screenX: number,
    foldCreaseRegion: SCBSessionRect): void {
    const responseRegionBHeight =
      foldCreaseRegion.top.getPx() - this.statusBarHeight - this.dockHeight - vp2px(FOLD_KEYBOARD_DOCK_MARGIN);
    log.showInfo(`setFoldResponseRegionWithKeyboard dockHeight: ${this.dockHeight} this.statusBarHeight: ${this.statusBarHeight}`);
    sysSceneSession.setResponseRegion([{
      // B面左
      x: 0,
      y: this.statusBarHeight,
      width: this.backWindowResponseWidth,
      height: responseRegionBHeight
    },
      // B面右
      {
        x: screenX - this.backWindowResponseWidth,
        y: this.statusBarHeight,
        width: this.backWindowResponseWidth,
        height: responseRegionBHeight
      }]);
  }

  private setExpandResponseRegion(sysSceneSession: SCBSystemSceneSession, screenX: number, screenY: number): void {
    const responseRegionHeight: number = screenY - this.statusBarHeight - this.dockHeight;
    log.showInfo(`setExpandResponseRegion  statusBarHeight:${this.statusBarHeight}  dockHeight:${this.dockHeight}`);
    sysSceneSession.setResponseRegion([{
      // B面左
      x: 0,
      y: this.statusBarHeight,
      width: this.backWindowResponseWidth,
      height: responseRegionHeight
    },
      // B面右
      {
        x: screenX - this.backWindowResponseWidth,
        y: this.statusBarHeight,
        width: this.backWindowResponseWidth,
        height: responseRegionHeight
      }]);
  }


  /**
   * 设置侧滑控件的控制区域
   * @param screenX 屏幕X
   * @param screenY 屏幕Y
   */
  public setBackResponseRegion(screenX: number, screenY: number) {
    let sysSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (CheckEmptyUtils.isEmpty(sysSceneSession)) {
      log.showInfo('sysSceneSession is null.');
      return;
    }
    this.setExpandResponseRegion(sysSceneSession, screenX, screenY);
  }
}

const singletonBackViewModel: SCBGestureBackViewModel = SCBGestureBackViewModel.getInstance();
export default singletonBackViewModel;