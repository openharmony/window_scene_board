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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import {
  EventConstants,
  HiSysBackEventData,
  HiSysEventUtil,
  obtainLocalEvent,
  sEventManager,
} from '@ohos/frameworkwrapper';
import {
  FocusChangeReason,
  GestureType,
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBSceneSessionManager
} from '@ohos/windowscene';
import { CommonConstants, GestureDockModeConfig, vibratorMgr } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { systemDateTime } from '@kit.BasicServicesKit';
import singletonBackViewModel from '../viewmodel/SCBGestureBackViewModel';
import { GestureDockPullOutData } from './GestureDockPullOutData';
import { GestureDockConstants, GestureDockMode } from '../../../gestureDock/common/GestureDockConstants';
import { GestureBackMetaBallModel } from '@ohos/gestureback/src/main/ets/metaball/viewmodel/GestureBackMetaBallModel';
import { GestureDockViewModel } from '../../../gestureDock/dock/viewmodel/GestureDockViewModel';
import { GestureDockAdapter } from '../../../gestureDock/common/adapter/GestureDockAdapter';
import { GestureDockState } from '../../../gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr';
import { SCBGestureDockParam } from '../../../gestureDock/dock/viewmodel/viewdata/GestureDockParam';

const TAG = 'PullOutDockViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class GestureDockPullOutModel {
  public pullOutData: GestureDockPullOutData = new GestureDockPullOutData();
  private metaBallModel: GestureBackMetaBallModel = GestureBackMetaBallModel.getInstance();
  public isGestureDockShow: boolean = false;
  private gestureDockCallback: Function | undefined;

  public static getInstance(): GestureDockPullOutModel {
    return SingletonHelper.getInstance(GestureDockPullOutModel, TAG);
  }

  /**
   * Dock是否可以呼入呼出
   */
  public isDockOutEnable(): boolean {
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    if (dockViewData && dockViewData.getGestureDockShowMode() > GestureDockMode.APPEAR) {
      return false;
    }
    return this.isGestureDockEnable() && !this.pullOutData.isLock;
  }

  /**
   * Dock是否可用
   */
  private isGestureDockEnable(): boolean {
    if (this.isGestureDockShow && !GestureDockAdapter.isGestureDockForbid()) {
      return true;
    }
    let isGestureDockShow: boolean = false;
    try {
      isGestureDockShow = GestureDockModeConfig.getInstance().getIsSupportGestureDock();
    } catch (error) {
      log.showError('get gesture dock system param error');
    }
    this.isGestureDockShow = isGestureDockShow && !GestureDockAdapter.isGestureDockForbid();
    return this.isGestureDockShow;
  }

  /**
   * 设置Dock窗口的 persistentId
   */
  public setPersistentId(persistentId: number): void {
    log.showInfo(`setPersistentId persistentId:${persistentId}`);
    this.pullOutData.persistentId = persistentId;
  }

  /**
   * 注册Dock呼入呼出的动效
   * @param callback
   */
  public registerDockAnimation(callback: (animationType: number) => void) {
    log.showInfo('registerDockAnimation');
    this.gestureDockCallback = callback;
  }

  /**
   * 反注册Dock呼入呼出的动效
   * @param callback
   */
  public unRegisterDockAnimation() {
    log.showInfo('unRegisterDockAnimation');
    this.gestureDockCallback = undefined;
  }

  /**
   * 执行Dock呼入呼出动效
   *
   * @param gestureDirection
   * @param dockAnimFinish
   */
  public notifyDockAnimation(gestureDirection: number, dockAnimFinish?: Function) {
    log.showInfo(`notifyDockAnimation,gestureDirectionis${gestureDirection}},gestureDockCallbackis${this.gestureDockCallback}`);
    this.gestureDockCallback?.(gestureDirection, dockAnimFinish);
  }

  /**
   * 设置是左边呼出还是右边呼出
   *
   * @param isLeft
   */
  public setIsLeft(isLeft: boolean) {
    this.pullOutData.isLeft = isLeft;
  }

  /**
   * 重置呼出Dock的参数
   */
  public resetPullOutDockParam(): void {
    this.pullOutData.reset();
  }

  // back融球挤出动效结束
  public onExtrudeBallsFinish = () => {
    log.showInfo(`onExtrudeBallsFinish.`);
    if (this.isDockOutEnable() && this.pullOutData.actionUpTime === 0) {
      SCBGestureDockParam.getInstance().isGestureDockShow = true;
      this.pullOutData.isMoveBackAnimStart = false;
      this.changeToDockImg();
    }
  }

  // back融球回收动效开始
  public onMoveBackBallsBegin = () => {
    log.showInfo(`onMoveBackBallsBegin.`);
    if (this.isDockOutEnable()) {
      this.metaBallModel.finishChangeDockImgAnim();
      this.metaBallModel.resetDockImgProcess();
      this.pullOutData.isMoveBackAnimStart = true;
      this.pullOutData.isBackImageChange = false;
      this.pullOutData.isPullOutDock = false;
    }
  }

  // back融球回收动效结束
  public onMoveBackBallsFinish = () => {
    log.showInfo(`onMoveBackBallsFinish actionUpTime: ${this.pullOutData.actionUpTime}`);
  }

  /**
   * 箭头变OpenHarmony环
   */
  private changeToDockImg(): void {
    log.showInfo(`changeToDockImg.`);
    this.pullOutData.startChangeDockImgTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    this.pullOutData.isChangeDockImgAnimRunning = true;
    this.metaBallModel.changeDockImgAnim(true, this.changeToDockImgAnimFinish);
    this.leftRightDockOutExclusive();
  }

  /**
   * 箭头变OpenHarmony环动效完成后
   */
  private changeToDockImgAnimFinish = (isLeft: boolean) => {
    log.showInfo(`changeToDockImgAnimFinish.actionUpTime: ${this.pullOutData.actionUpTime} \
    startChangeDockImgTime:${this.pullOutData.startChangeDockImgTime}`);
    this.pullOutData.isChangeDockImgAnimRunning = false;
    GestureDockViewModel.getInstance().getViewEvent()?.onChangeToDockImgAnimFinish();
    if (this.pullOutData.actionUpTime === 0) {
      // 未松手，动效做完了，OpenHarmony环也呼出了，松手呼出Dock
      // back回收动效执行了，不执行呼出Dock
      if (!this.isDockOutEnable()) {
        log.showInfo(`changeToDockImgAnimFinish.gesture dock is not enable.`);
        return;
      }
      if (this.pullOutData.isMoveBackAnimStart) {
        this.metaBallModel.resetDockImgProcess();
        return;
      }
      this.metaBallModel.setDockImgProcess();
      this.pullOutData.isBackImageChange = true;
      let dockViewData = GestureDockViewModel.getInstance().getViewData();
      if (dockViewData && dockViewData.getGestureDockDirection() === GestureDockState.GESTURE_DOCK_IN) {
        vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_UPGLIDE,
          CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
      }
      this.pullOutData.isPullOutDock = true;
    } else if (this.pullOutData.actionUpTime - this.pullOutData.startChangeDockImgTime >
      GestureDockConstants.GESTURE_DOCK_STAY_DURATION) {
      // 松手了，动效做完了，OpenHarmony环也呼出了，呼出Dock栏
      if (!this.isDockOutEnable()) {
        log.showInfo(`changeToDockImgAnimFinish.gesture dock is not enable.`);
        return;
      }
      if (this.pullOutData.isMoveBackAnimStart) {
        log.showInfo(`changeToDockImgAnimFinish, MetaBalls has moved back.`);
        this.metaBallModel.resetDockImgProcess();
        this.pullInGestureDock();
        return;
      }
      this.pullOutData.isBackImageChange = true;
      let dockViewData = GestureDockViewModel.getInstance().getViewData();
      if (dockViewData && dockViewData.getGestureDockDirection() === GestureDockState.GESTURE_DOCK_IN) {
        vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_UPGLIDE,
          CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
      }
      this.pullOutGestureDock();
      this.pullOutData.isPullOutDock = true;
    } else {
      // 松手了，动效做完了，OpenHarmony环未呼出了，发送back手势
      this.pullOutData.isBackImageChange = false;
      let dockViewData = GestureDockViewModel.getInstance().getViewData();
      if (dockViewData && dockViewData.getGestureDockDirection() === GestureDockState.GESTURE_DOCK_IN) {
        SCBGestureDockParam.getInstance().isGestureDockShow = false;
      }
      this.pullOutData.isPullOutDock = false;
    }
  }

  /**
   * 左右Dock栏互斥
   */
  public leftRightDockOutExclusive(): void {
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    let isLeftOutRightIn =
      dockViewData && dockViewData.getGestureDockDirection() === GestureDockState.GESTURE_DOCK_LEFT_OUT &&
        !this.pullOutData.isLeft;
    let isRightOutLeftIn = dockViewData && dockViewData.getGestureDockDirection() ===
    GestureDockState.GESTURE_DOCK_RIGHT_OUT && this.pullOutData.isLeft;
    if (isLeftOutRightIn || isRightOutLeftIn) {
      log.showInfo(`continuous change`);
      this.notifyDockAnimation(isLeftOutRightIn ?
      GestureDockState.GESTURE_DOCK_RIGHT_IN_LEFT_OUT : GestureDockState.GESTURE_DOCK_LEFT_IN_RIGHT_OUT);
    }
  }

  /**
   * 手势结束时，是否需要发送back事件
   * @returns
   */
  public isSendBackEventOnGestureEnd(): boolean {
    // 呼出Dock，不下发Back事件
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    log.showInfo(`isSendBackEventOnGestureEnd:${dockViewData?.getGestureDockDirection()}`);
    if (this.pullOutData.isPullOutDock) {
      this.pullOutGestureDock();
      return false;
    } else if (dockViewData && dockViewData.getGestureDockDirection() === GestureDockState.GESTURE_DOCK_IN) {
      SCBGestureDockParam.getInstance().isGestureDockShow = false;
    }
    return true;
  }

  /**
   * Dock呼出的情况下，呼入Dock
   */
  public pullInGestureDock(): void {
    log.showInfo(`pullInGestureDock`);
    if (!SCBGestureDockParam.getInstance().isGestureDockShow) {
      log.showInfo(`gesture dock is not show. return`);
      return;
    }
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    if (dockViewData && dockViewData.getGestureDockDirection() > GestureDockState.GESTURE_DOCK_IN) {
      this.notifyDockAnimation(GestureDockState.GESTURE_DOCK_IN, () => {
        SCBGestureDockParam.getInstance().isGestureDockShow = false;
      });
    } else {
      SCBGestureDockParam.getInstance().isGestureDockShow = false;
    }
  }

  /**
   * Dock呼入的情况下，呼出Dock
   */
  public pullOutGestureDock(): void {
    log.showInfo(`pullOutGestureDock`);
    let dockViewData = GestureDockViewModel.getInstance().getViewData();
    if (dockViewData && dockViewData.getGestureDockDirection() > GestureDockState.GESTURE_DOCK_IN) {
      log.showInfo(`GestureDock is out. return`);
      return;
    }
    this.requestDockFocus();
    this.notifyDockAnimation(this.pullOutData.isLeft ? GestureDockState.GESTURE_DOCK_LEFT_OUT :
    GestureDockState.GESTURE_DOCK_RIGHT_OUT);
  }

  private requestDockUnfocus(): void {
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.pullOutData.persistentId)?.setFocusable(false);
    SCBSceneSessionManager.getInstance().requestUnfocus(this.pullOutData.persistentId);
  }

  private requestDockFocus(): void {
    SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(
      this.pullOutData.persistentId)?.setFocusable(true);
    SCBSceneSessionManager.getInstance().requestFocus(this.pullOutData.persistentId, true,
      FocusChangeReason.FOREGROUND);
  }
}