/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import {
  AnimateToScheduleUtils,
  LogHelper,
  LogDomain,
  SingletonHelper,
  AppStorageUtil,
  DataProperty,
} from '@ohos/basicutils';
import {
  DisplayMgr,
  SCBScreenSession,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBPropertyChangeReason,
  SCBRotateChangeReason,
  SCBSceneSessionManager,
  SCBWindowRotateController,
  SCBKeyboardManager,
  MidSceneConfig
} from '@ohos/windowscene';
import { viewMgrPolicy, ViewType, ApsUtils, RotateChangeEvent, EvtBus, DeviceHelper, } from '@ohos/frameworkwrapper';
// import apsManager from '@ohos.graphic.apsManager';
import { StyleConstants } from '@ohos/launchercommon';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import transactionManager from '@ohos.transactionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import curves from '@ohos.curves';
import { WinLog, WinLogDomain } from '@ohos/windowscene/src/main/ets/utils/WinLog';

const TAG = 'SCBWindowRotate';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class SCBWindowRotate {
  private rotationAnimCnt: number = 0;
  private rotateFinishTimerId: number = -1;
  private prepareBeforeAnimationCallback: Function | undefined = undefined;

  constructor() {
    SCBWindowRotateController.getInstance().registerWindowRotateChangeCallback((screenProperty: SCBScreenProperty,
      reason: SCBPropertyChangeReason, needNotify: boolean = true) => {
      this.onWindowRotateChange(screenProperty, reason, needNotify);
    });
  }

  /**
   * Obtains a single instance of SCBWindowRotate.
   *
   * @returns { SCBWindowRotate } Returns a singleton instance of SCBWindowRotate
   */
  public static getInstance(): SCBWindowRotate {
    return SingletonHelper.getInstance(SCBWindowRotate, TAG);
  }

  /**
   * register window rotate prepare before animation callback
   *
   * @param {func} Function
   */
  public registerPrepareBeforeAnimationCallback(func: Function): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'registerPrepareBeforeAnimationCallback');
    this.prepareBeforeAnimationCallback = func;
  }

  /**
   * unregister window rotate change callback
   */
  public unRegisterPrepareBeforeAnimationCallback(): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'unRegisterPrepareBeforeAnimationCallback');
    this.prepareBeforeAnimationCallback = undefined;
  }

  private handlePrepareBeforeAnimation(targetRotation: number): void {
    if (this.prepareBeforeAnimationCallback) {
      this.prepareBeforeAnimationCallback(targetRotation);
    } else {
      WinLog.showError(WinLogDomain.WMS_ROTATION, 'prepareBeforeAnimationCallback is null');
    }
  }

  private onWindowRotateChange(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason, needNotify: boolean): void {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (screenSession === null || screenSession === undefined) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'onWindowRotateChange screenSession is null.');
      return;
    }
    WinLog.showError(WinLogDomain.WMS_ROTATION, `onWindowRotateChange current: ${screenSession.scbScreenProperty.getLogString()},` +
      ` screenProperty: ${screenProperty.getLogString()}, reason: ${reason}`);
    switch (reason) {
      case SCBPropertyChangeReason.FOLD_SCREEN_ROTATION:
        this.rotateWithAnimation(screenProperty, reason, screenSession);
        break;
      case SCBPropertyChangeReason.FOLD_LANDSCAPE_START:
        this.rotateWithNoAnimation(screenProperty, reason, needNotify, screenSession);
        break;
      case SCBPropertyChangeReason.PAGE_ROTATION:
        this.rotateWithAnimation(screenProperty, reason, screenSession);
        break;
      default:
        WinLog.showError(WinLogDomain.WMS_ROTATION, `unknown reason type: ${reason}`);
        break;
    }
    DisplayMgr.onScreenPropertyChange(screenSession);
  }

  /**
   * notifyScreenRotateToCallbacks
   */
  public notifyScreenRotateToCallbacks(screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) {
    SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty, reason);
  }

  /**
   * updateScreenRotationProperty
   */
  public updateScreenRotationProperty(screenProperty: SCBScreenProperty,
    notifyType: SCBRotateChangeReason = SCBRotateChangeReason.UNSPECIFIED) {
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty, notifyType);
  }

  /**
   * notifyScenePanelPropertyChange
   */
  public notifyScenePanelPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    SCBScreenSessionManager.getInstance().notifyScenePanelPropertyChange(screenProperty, reason);
  }

  /**
   * updateScreenPropertyToCallbacks
   */
  public updateScreenPropertyToCallbacks(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    SCBScreenSessionManager.getInstance().updateScreenPropertyToCallbacks(screenProperty, reason);
  }

  /**
   * updateScbScreenPropertyByRotation
   */
  public updateScbScreenPropertyByRotation(screenSession: SCBScreenSession, rotation: number): void {
    screenSession.updateScbScreenPropertyByRotation(rotation);
  }

  /**
   * updateRotateAnimationConfig
   */
  public updateRotateAnimationConfig(rotateDuration: number): void {
    SCBSceneSessionManager.getInstance().updateRotateAnimationConfig(rotateDuration);
  }

  /**
   * prepareSystemSceneRotationBeforeAnimation
   */
  public prepareSystemSceneRotationBeforeAnimation(rotation: number): void {
    SCBSceneSessionManager.getInstance().prepareSystemSceneRotationBeforeAnimation(rotation);
  }

  /**
   * notifyKeyBoardBeforeRotation
   */
  public notifyKeyBoardBeforeRotation(): void {
    SCBKeyboardManager.getInstance().getKeyboardSession()?.setKeyboardRotationFlag(true);
  }

  /**
   * notifyKeyBoardAfterRotation
   */
  public notifyKeyBoardAfterRotation(): void {
    SCBKeyboardManager.getInstance().getKeyboardSession()?.setKeyboardRotationFlag(false);
  }

  /**
   * notifySystemSceneToUpdateSizeChangeReason
   */
  public notifySystemSceneToUpdateSizeChangeReason(screenProperty: SCBScreenProperty,
    reason: sceneSessionManager.SessionSizeChangeReason): void {
    SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateSizeChangeReason(screenProperty, reason);
  }

  /**
   * updateInvisibleSystemSceneFoldChange
   */
  public updateInvisibleSystemSceneFoldChange(inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]>,
    screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    SCBScreenSessionManager.getInstance().updateInvisibleSystemSceneFoldChange(inVisibleSystemSceneCallbacks,
      screenProperty, reason);
  }

  private rotateWithNoAnimation(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason, needNotify: boolean, screenSession: SCBScreenSession): void {
    this.notifyScreenRotateToCallbacks(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    this.updateScbScreenPropertyByRotation(screenSession, screenProperty.rotation);
    if (needNotify) {
      this.updateScreenRotationProperty(screenProperty);
    }
    let rotationWindow = SCBWindowRotateController.getInstance()
      .notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN, true);
    this.notifyScenePanelPropertyChange(screenProperty, reason);
    SCBWindowRotateController.getInstance().updateRotationWindow(rotationWindow);
    this.updateScreenPropertyToCallbacks(screenProperty, reason);
    this.notifyScreenRotateToCallbacks(screenProperty, SCBRotateChangeReason.ROTATE_END);
    SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_END);
  }

  private rotateWithAnimation(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason,
    screenSession: SCBScreenSession): void {
    this.updateScbScreenPropertyByRotation(screenSession, screenProperty.rotation);
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    this.rotationAnimCnt++;
    if (SCBSceneSessionManager.getInstance().hasFullSceneSession(screenProperty.screenId)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' hasFullSceneSession need hide background');
      viewMgrPolicy.hideView(ViewType.DESKTOP);
      viewMgrPolicy.hideView(ViewType.WALLPAPER);
    } else if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' screen lock need hide desktop');
      viewMgrPolicy.hideView(ViewType.DESKTOP);
    }
    this.rotateSetApsScene(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    performanceMonitor.begin('EXPAND_SCREEN_ROTATION_ANI', performanceMonitor.ActionType.LAST_UP);
    let rotateEvent: RotateChangeEvent = RotateChangeEvent.create(RotateChangeEvent.ROTATE_STATUS_START);
    EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
    this.updateScreenRotationProperty(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    this.notifyScreenRotateToCallbacks(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    let rotateDuration: number = reason === SCBPropertyChangeReason.PAGE_ROTATION ? 0 : 600;
    this.handleWindowRotateAnimate(screenProperty, reason, rotateEvent, rotateDuration);
  }

  private rotateSetApsScene(screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) : void {
    let containerSession = SCBSceneSessionManager.getInstance()
        .getContainerSessionList(screenProperty.screenId)?.getTopActiveSession();
    let styleConstants = reason === SCBRotateChangeReason.ROTATE_BEGIN ? StyleConstants.DEFAULT_1 :
        StyleConstants.DEFAULT_0;
    if (DeviceHelper.is2In1DevicePadType() && containerSession && containerSession.primarySession &&
        containerSession.secondarySession) {
      // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION_SPLIT, styleConstants);
    } else {
      // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, styleConstants);
    }
  }

  private handleWindowRotateAnimate(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason,
    rotateEvent: RotateChangeEvent, rotateDuration: number) : void {
    this.updateRotateAnimationConfig(rotateDuration);
    this.handlePrepareBeforeAnimation(screenProperty.rotation);
    this.prepareSystemSceneRotationBeforeAnimation(screenProperty.rotation);
    let rotationWindow =
      SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    type SceneCallback = [Function, boolean, number | null];
    let inVisibleSystemSceneCallbacks: SceneCallback[] = [];
    WinLog.showError(WinLogDomain.WMS_ROTATION, `startRotationAnimate,${this.rotationAnimCnt}`);
    transactionManager.openSyncTransaction(screenProperty.screenId);
    this.notifyKeyBoardBeforeRotation();
    AppStorageUtil.setOrCreate('isScreenProperty', true, new DataProperty(true, false));
    this.notifySystemSceneToUpdateSizeChangeReason(screenProperty,
      sceneSessionManager.SessionSizeChangeReason.ROTATION);
    this.setRotateFinishTimer(screenProperty, rotateEvent);
    animateTo({
      duration : rotateDuration,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        this.rotationAnimationFinished(screenProperty, rotateEvent);
        this.rotateSetApsScene(screenProperty, SCBRotateChangeReason.ROTATE_END);
      }
    }, () => {
      SCBScreenSessionManager.getInstance().updateSystemSceneFoldChangeBeforeScenePanel(screenProperty, reason);
      this.notifyScenePanelPropertyChange(screenProperty, reason);
      inVisibleSystemSceneCallbacks = SCBScreenSessionManager.getInstance().updateSystemSceneFoldChange(screenProperty,
        reason);
      SCBWindowRotateController.getInstance().updateRotationWindow(rotationWindow);
    });
    this.updateInvisibleSystemSceneFoldChange(inVisibleSystemSceneCallbacks, screenProperty, reason);
    transactionManager.closeSyncTransaction(screenProperty.screenId);
  }

  private setRotateFinishTimer(screenProperty: SCBScreenProperty, rotateEvent: RotateChangeEvent): void {
    if (this.rotateFinishTimerId !== -1) {
      clearTimeout(this.rotateFinishTimerId);
    }
    this.rotateFinishTimerId = setTimeout(() => {
      this.rotationAnimationFinished(screenProperty, rotateEvent, true);
      this.rotateFinishTimerId = -1;
    }, 3000);
  }

  private rotationAnimationFinished(screenProperty: SCBScreenProperty, rotateEvent: RotateChangeEvent,
    isTimeoutCheck: boolean = false): void {
    WinLog.showError(WinLogDomain.WMS_ROTATION, `endRotationAnimate, ${this.rotationAnimCnt} isTimeoutCheck:${isTimeoutCheck}`);
    if (isTimeoutCheck) {
      if (this.rotationAnimCnt > 0) {
        this.rotationAnimCnt = 1;
      } else {
        return;
      }
    }
    this.rotationAnimCnt--;
    if (this.rotationAnimCnt < 0) {
      this.rotationAnimCnt = 0;
      return;
    }
    this.notifyKeyBoardAfterRotation();
    AppStorageUtil.setOrCreate('isScreenProperty', false, new DataProperty(true, false));
    SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_END);
    if (this.rotationAnimCnt === 0) {
      this.notifyScreenRotateToCallbacks(screenProperty, SCBRotateChangeReason.ROTATE_END);
      this.updateScreenRotationProperty(screenProperty, SCBRotateChangeReason.ROTATE_END);
      AnimateToScheduleUtils.raiseAnimateToCPUPriority(1);
      this.notifySystemSceneToUpdateSizeChangeReason(screenProperty,
        sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      rotateEvent.rotateStatus = RotateChangeEvent.ROTATE_STATUS_END;
      // for pad midScene
      let topSession = SCBSceneSessionManager.getInstance()
        .getContainerSessionList(screenProperty.screenId)?.getTopActiveSession();
      if (MidSceneConfig.isSupportPadDifference() && !!topSession && topSession?.isMidScene) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' midscene not show wallPaper');
      } else if (topSession?.isSplitView()) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' splitView not show wallPaper');
      } else {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' not midcsene show wallPaper');
        viewMgrPolicy.showView(ViewType.WALLPAPER);
      }
      if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' ROTATE_END screen lock need show desktop');
        viewMgrPolicy.showView(ViewType.DESKTOP);
      }
      SCBSceneSessionManager.getInstance().refreshAvailableArea(screenProperty.screenId);
      EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
      performanceMonitor.end('EXPAND_SCREEN_ROTATION_ANI');
    }
  }

  public getRotateAnimationCnt(): number {
      return this.rotationAnimCnt;
  }

}