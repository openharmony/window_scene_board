/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { AnimateToScheduleUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  ApsUtils,
  DeviceHelper,
  EvtBus,
  HiDfxEventUtil,
  HiSysEventUtil,
  RotateChangeEvent,
  ViewManagerPolicy,
  ViewType,
} from '@ohos/frameworkwrapper';
import { SCBWindowRotateController } from '../scene/manager/SCBWindowRotateController';
import { SCBContainerRotationReason, SCBSceneContainerSession,
  SCBSceneContainerSessionArray } from '../scene/session/SCBSceneContainerSession';
import { SCBScreenProperty, SCBScreenSession } from '../screen/session/SCBScreenSession';
import {
  SCBPropertyChangeReason,
  SCBRotateChangeReason,
  SCBScreenSessionManager,
} from '../screen/session/SCBScreenSessionManager';
import { performanceMonitor } from '@kit.ArkUI';
import { SCBSceneSessionManager } from '../scene/session/SCBSceneSessionManager';
import transactionManager from '@ohos.transactionManager';
// import apsManager from '@ohos.graphic.apsManager';
import { RotationConstants } from '@ohos/commonconstants';
import { SCBDeviceScreenConfig } from '../config/SCBDeviceScreenConfig';
import { WinLog, WinLogDomain } from '../utils/WinLog';

const TAG = 'SCBRotationController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const DEFAULT_PANEL_NAME = '';
const DEFAULT_0 = 0;
const DEFAULT_1 = 1;
const EMPTY_CONTAINER_ARRAY: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

export interface RotationPropertyHolder {
  getScreenProperty: () => SCBScreenProperty;
  getContainerSessionList: () => SCBSceneContainerSessionArray;
  getFloatingSessionList: () => SCBSceneContainerSessionArray;
}

export class SCBRotationController {
  private currRotation: number = 0;
  private rotationAnimCnt: number = 0;
  private rotateFinishTimerId: number = -1;
  private rotationPropertyHolder: RotationPropertyHolder;

  // ----------------------------------------------------------------------------------------------------
  // SCBScenePanelViewModel callback
  // ----------------------------------------------------------------------------------------------------
  private handleSplitScreenFunc: (containerSession: SCBSceneContainerSession | null, screenProperty: SCBScreenProperty,
    needHideKeyboard: boolean) => void;
  private prepareRotationBeforeAnimationFunc: (rotation: number) => void;
  private setExpandStartContainerSessionFunc: (session: SCBSceneContainerSession | null) => void;
  private showDividerAfterRotationFunc: (containerSession: SCBSceneContainerSession | null, rotateDuration: number) => void;
  private updateNeedScrollClipRotateFinishFunc: () => void;
  private setFloatAnimateStatusFunc: (animateStatus: boolean) => void;
  private showWallpaperAfterRotateFunc: (isEnableBlur: boolean) => void;
  private updateFloatContainerWithScreenChangeFunc: (screenProperty: SCBScreenProperty,
    reason: SCBContainerRotationReason) => void;
  private notifyUpdateScenePanelWhenRotateFunc: (screenProperty: SCBScreenProperty) => void;
  private getPanelNameFunc: () => string;
  private updateFloatAfterRotationAnimateFunc: () => void;
  private updateBlackBackgroundStateFunc: (blackBackgroundState: boolean) => void;
  private setKeyboardRotationFlagFunc: (isRotating: boolean) => void;
  private clearRecentStartNotifyRotationFunc: () => void;
  private coverSensorRotationFunc: (screenSession: SCBScreenSession) => void;
  private handleFloatWhenExitSceneFunc: (reason?: SCBContainerRotationReason) => void;
  private interruptPipAnimWithFloatRotationFunc: () => void;
  private clearExitSceneNotifyRotationFunc: () => void;
  private getMattesLockStateFunc: () => boolean;
  private executeAnimateToFunc: (rotateDuration: number, isAssignCurve: boolean, event: () => void, onFinish: () => void) => void;

  // ----------------------------------------------------------------------------------------------------
  // SCBScenePanelViewModel function
  // ----------------------------------------------------------------------------------------------------

  /**
   * register handleSplitScreen function
   */
  public registerHandleSplitScreenFunc(handleSplitScreenFunc: (containerSession: SCBSceneContainerSession | null,
    screenProperty: SCBScreenProperty, needHideKeyboard: boolean) => void): void {
    this.handleSplitScreenFunc = handleSplitScreenFunc;
  }

  /**
   * unregister handleSplitScreen function
   */
  public unregisterHandleSplitScreenFunc(): void {
    this.handleSplitScreenFunc = null;
  }

  /**
   * handleSplitScreen
   */
  public handleSplitScreen(containerSession: SCBSceneContainerSession | null, screenProperty: SCBScreenProperty,
    needHideKeyboard: boolean = false): void {
    if (this.handleSplitScreenFunc) {
      this.handleSplitScreenFunc(containerSession, screenProperty, needHideKeyboard);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[handleSplitScreen] handleSplitScreenFunc called');
    }
  }

  /**
   * register prepareRotationBeforeAnimation function
   */
  public registerPrepareRotationBeforeAnimationFunc(prepareRotationBeforeAnimationFunc: (rotation: number) => void): void {
    this.prepareRotationBeforeAnimationFunc = prepareRotationBeforeAnimationFunc;
  }

  /**
   * unregister prepareRotationBeforeAnimation function
   */
  public unregisterPrepareRotationBeforeAnimationFunc(): void {
    this.prepareRotationBeforeAnimationFunc = null;
  }

  /**
   * prepareRotationBeforeAnimation
   */
  public prepareRotationBeforeAnimation(rotation: number): void {
    if (this.prepareRotationBeforeAnimationFunc) {
      this.prepareRotationBeforeAnimationFunc(rotation);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[prepareRotationBeforeAnimation] called');
    }
  }

  /**
   * register setExpandStartContainerSession function
   */
  public registerSetExpandStartContainerSessionFunc(setExpandStartContainerSessionFunc:
    (session: SCBSceneContainerSession | null) => void): void {
    this.setExpandStartContainerSessionFunc = setExpandStartContainerSessionFunc;
  }

  /**
   * unregister setExpandStartContainerSession function
   */
  public unregisterSetExpandStartContainerSessionFunc(): void {
    this.setExpandStartContainerSessionFunc = null;
  }

  private setExpandStartContainerSession(containerSession: SCBSceneContainerSession | null): void {
    if (this.setExpandStartContainerSessionFunc) {
      this.setExpandStartContainerSessionFunc(containerSession);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[setExpandStartContainerSession] called');
    }
  }

  /**
   * update current rotation
   */
  public updateCurrRotation(rotation: number): void {
    this.setCurrRotation(rotation);
  }

  /**
   * register showDividerAfterRotation function
   */
  public registerShowDividerAfterRotationFunc(showDividerAfterRotationFunc:
    (containerSession: SCBSceneContainerSession | null, rotateDuration: number) => void): void {
    this.showDividerAfterRotationFunc = showDividerAfterRotationFunc;
  }

  /**
   * unregister showDividerAfterRotation function
   */
  public unregisterShowDividerAfterRotationFunc(): void {
    this.showDividerAfterRotationFunc = null;
  }

  /**
   * showDividerAfterRotation
   */
  public showDividerAfterRotation(containerSession: SCBSceneContainerSession | null, rotateDuration: number): void {
    if (this.showDividerAfterRotationFunc) {
      this.showDividerAfterRotationFunc(containerSession, rotateDuration);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[showDividerAfterRotation] called');
    }
  }

  /**
   * register updateNeedScrollClipRotateFinish function
   */
  public registerUpdateNeedScrollClipRotateFinishFunc(updateNeedScrollClipRotateFinishFunc: () => void): void {
    this.updateNeedScrollClipRotateFinishFunc = updateNeedScrollClipRotateFinishFunc;
  }

  /**
   * unregister updateNeedScrollClipRotateFinish function
   */
  public unregisterUpdateNeedScrollClipRotateFinishFunc(): void {
    this.updateNeedScrollClipRotateFinishFunc = null;
  }

  /**
   * updateNeedScrollClipRotateFinish
   */
  public updateNeedScrollClipRotateFinish(): void {
    if (this.updateNeedScrollClipRotateFinishFunc) {
      this.updateNeedScrollClipRotateFinishFunc();
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateNeedScrollClipRotateFinish] called');
    }
  }

  /**
   * register setFloatAnimateStatus function
   */
  public registerSetFloatAnimateStatusFunc(setFloatAnimateStatusFunc: (animateStatus: boolean) => void): void {
    this.setFloatAnimateStatusFunc = setFloatAnimateStatusFunc;
  }

  /**
   * unregister setFloatAnimateStatus function
   */
  public unregisterSetFloatAnimateStatusFunc(): void {
    this.setFloatAnimateStatusFunc = null;
  }

  /**
   * setFloatAnimateStatus
   */
  public setFloatAnimateStatus(animateStatus: boolean): void {
    if (this.setFloatAnimateStatusFunc) {
      this.setFloatAnimateStatusFunc(animateStatus);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[setFloatAnimateStatus] called');
    }
  }

  /**
   * register showWallpaperAfterRotate function
   */
  public registerShowWallpaperAfterRotateFunc(showWallpaperAfterRotateFunc: (isEnableBlur: boolean) => void): void {
    this.showWallpaperAfterRotateFunc = showWallpaperAfterRotateFunc;
  }

  /**
   * unregister showWallpaperAfterRotate function
   */
  public unregisterShowWallpaperAfterRotateFunc(): void {
    this.showWallpaperAfterRotateFunc = null;
  }

  /**
   * showWallpaperAfterRotate
   */
  public showWallpaperAfterRotate(isEnableBlur: boolean = true): void {
    if (this.showWallpaperAfterRotateFunc) {
      this.showWallpaperAfterRotateFunc(isEnableBlur);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[showWallpaperAfterRotate] called');
    }
  }

  /**
   * register updateFloatContainerWithScreenChange function
   */
  public registerUpdateFloatContainerWithScreenChangeFunc(updateFloatContainerWithScreenChangeFunc:
    (screenProperty: SCBScreenProperty, reason: SCBContainerRotationReason) => void): void {
    this.updateFloatContainerWithScreenChangeFunc = updateFloatContainerWithScreenChangeFunc;
  }

  /**
   * unregister updateFloatContainerWithScreenChange function
   */
  public unregisterUpdateFloatContainerWithScreenChangeFunc(): void {
    this.updateFloatContainerWithScreenChangeFunc = null;
  }


  /**
   * updateFloatContainerWithScreenChange
   */
  public updateFloatContainerWithScreenChange(screenProperty: SCBScreenProperty,
    reason: SCBContainerRotationReason): void {
    if (this.updateFloatContainerWithScreenChangeFunc) {
      this.updateFloatContainerWithScreenChangeFunc(screenProperty, reason);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[updateFloatContainerWithScreenChange] called`);
    }
  }

  /**
   * register notifyUpdateScenePanelWhenRotate function
   */
  public registerNotifyUpdateScenePanelWhenRotateFunc(notifyUpdateScenePanelWhenRotateFunc:
    (screenProperty: SCBScreenProperty) => void): void {
    this.notifyUpdateScenePanelWhenRotateFunc = notifyUpdateScenePanelWhenRotateFunc;
  }

  /**
   * unregister notifyUpdateScenePanelWhenRotate function
   */
  public unregisterNotifyUpdateScenePanelWhenRotateFunc(): void {
    this.notifyUpdateScenePanelWhenRotateFunc = null;
  }

  /**
   * notifyUpdateScenePanelWhenRotate
   */
  public notifyUpdateScenePanelWhenRotate(screenProperty: SCBScreenProperty): void {
    if (this.notifyUpdateScenePanelWhenRotateFunc) {
      this.notifyUpdateScenePanelWhenRotateFunc(screenProperty);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyUpdateScenePanelWhenRotate] called');
    }
  }

  /**
   * register getPanelName function
   */
  public registerGetPanelNameFunc(getPanelNameFunc: () => string): void {
    this.getPanelNameFunc = getPanelNameFunc;
  }

  /**
   * unregister getPanelName function
   */
  public unregisterGetPanelNameFunc(): void {
    this.getPanelNameFunc = null;
  }

  /**
   * getPanelName
   */
  public getPanelName(): string {
    if (this.getPanelNameFunc) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[getPanelName] called`);
      return this.getPanelNameFunc();
    }
    return DEFAULT_PANEL_NAME;
  }

  /**
   * register updateFloatAfterRotationAnimate function
   */
  public registerUpdateFloatAfterRotationAnimateFunc(updateFloatAfterRotationAnimateFunc: () => void): void {
    this.updateFloatAfterRotationAnimateFunc = updateFloatAfterRotationAnimateFunc;
  }

  /**
   * unregister updateFloatAfterRotationAnimate function
   */
  public unregisterUpdateFloatAfterRotationAnimateFunc(): void {
    this.updateFloatAfterRotationAnimateFunc = null;
  }

  /**
   * updateFloatAfterRotationAnimate
   */
  public updateFloatAfterRotationAnimate(): void {
    if (this.updateFloatAfterRotationAnimateFunc) {
      this.updateFloatAfterRotationAnimateFunc();
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateFloatAfterRotationAnimate] called');
    }
  }

  /**
   * register updateBlackBackgroundState function
   */
  public registerUpdateBlackBackgroundStateFunc(updateBlackBackgroundStateFunc:
    (blackBackgroundState: boolean) => void): void {
    this.updateBlackBackgroundStateFunc = updateBlackBackgroundStateFunc;
  }

  /**
   * unregister updateBlackBackgroundState function
   */
  public unregisterUpdateBlackBackgroundStateFunc(): void {
    this.updateBlackBackgroundStateFunc = null;
  }

  /**
   * updateBlackBackgroundState
   */
  public updateBlackBackgroundState(blackBackgroundState: boolean): void {
    if (this.updateBlackBackgroundStateFunc) {
      this.updateBlackBackgroundStateFunc(blackBackgroundState);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateBlackBackgroundState] called');
    }
  }

  /**
   * register setKeyboardRotationFlag function
   */
  public registerSetKeyboardRotationFlagFunc(setKeyboardRotationFlagFunc: (isRotating: boolean) => void): void {
    this.setKeyboardRotationFlagFunc = setKeyboardRotationFlagFunc;
  }

  /**
   * unregister setKeyboardRotationFlag function
   */
  public unregisterSetKeyboardRotationFlagFunc(): void {
    this.setKeyboardRotationFlagFunc = null;
  }

  /**
   * setKeyboardRotationFlag
   */
  public setKeyboardRotationFlag(isRotating: boolean): void {
    if (this.setKeyboardRotationFlagFunc) {
      this.setKeyboardRotationFlagFunc(isRotating);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[setKeyboardRotationFlag] called');
    }
  }

  /**
   * register clearRecentStartNotifyRotation function
   */
  public registerClearRecentStartNotifyRotationFunc(clearRecentStartNotifyRotationFunc: () => void): void {
    this.clearRecentStartNotifyRotationFunc = clearRecentStartNotifyRotationFunc;
  }

  /**
   * unregister clearRecentStartNotifyRotation function
   */
  public unregisterClearRecentStartNotifyRotationFunc(): void {
    this.clearRecentStartNotifyRotationFunc = null;
  }

  private clearRecentStartNotifyRotation(): void {
    if (this.clearRecentStartNotifyRotationFunc) {
      this.clearRecentStartNotifyRotationFunc();
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[clearRecentStartNotifyRotation] called');
    }
  }

  /**
   * register coverSensorRotation function
   */
  public registerCoverSensorRotationFunc(coverSensorRotationFunc: (screenSession: SCBScreenSession) => void): void {
    this.coverSensorRotationFunc = coverSensorRotationFunc;
  }

  /**
   * unregister coverSensorRotation function
   */
  public unregisterCoverSensorRotationFunc(): void {
    this.coverSensorRotationFunc = null;
  }

  /**
   * coverSensorRotation
   */
  public coverSensorRotation(screenSession: SCBScreenSession): void {
    if (this.coverSensorRotationFunc) {
      this.coverSensorRotationFunc(screenSession);
      WinLog.showDebug(WinLogDomain.WMS_ROTATION, '[coverSensorRotation] called');
    }
  }

  /**
   * register handleFloatWhenExitScene function
   */
  public registerHandleFloatWhenExitSceneFunc(handleFloatWhenExitSceneFunc:
    (reason?: SCBContainerRotationReason) => void): void {
    this.handleFloatWhenExitSceneFunc = handleFloatWhenExitSceneFunc;
  }

  /**
   * unregister handleFloatWhenExitScene function
   */
  public unregisterHandleFloatWhenExitSceneFunc(): void {
    this.handleFloatWhenExitSceneFunc = null;
  }

  /**
   * handleFloatWhenExitScene
   */
  public handleFloatWhenExitScene(reason?: SCBContainerRotationReason): void {
    if (this.handleFloatWhenExitSceneFunc) {
      this.handleFloatWhenExitSceneFunc(reason);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[handleFloatWhenExitScene] called');
    }
  }

  /**
   * register interruptPipAnimWithFloatRotation function
   */
  public registerInterruptPipAnimWithFloatRotationFunc(interruptPipAnimWithFloatRotationFunc: () => void): void {
    this.interruptPipAnimWithFloatRotationFunc = interruptPipAnimWithFloatRotationFunc;
  }

  /**
   * unregister interruptPipAnimWithFloatRotation function
   */
  public unregisterInterruptPipAnimWithFloatRotationFunc(): void {
    this.interruptPipAnimWithFloatRotationFunc = null;
  }

  private interruptPipAnimWithFloatRotation(): void {
    if (this.interruptPipAnimWithFloatRotationFunc) {
      this.interruptPipAnimWithFloatRotationFunc();
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[interruptPipAnimWithFloatRotation] called');
    }
  }

  /**
   * register clearExitSceneNotifyRotation function
   */
  public registerClearExitSceneNotifyRotationFunc(clearExitSceneNotifyRotationFunc: () => void): void {
    this.clearExitSceneNotifyRotationFunc = clearExitSceneNotifyRotationFunc;
  }

  /**
   * unregister clearExitSceneNotifyRotation function
   */
  public unregisterClearExitSceneNotifyRotationFunc(): void {
    this.clearExitSceneNotifyRotationFunc = null;
  }

  /**
   * clearExitSceneNotifyRotation
   */
  public clearExitSceneNotifyRotation(): void {
    if (this.clearExitSceneNotifyRotationFunc) {
      this.clearExitSceneNotifyRotationFunc();
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[clearExitSceneNotifyRotation] called');
    }
  }

  /**
   * register getMattesLockState function
   */
  public registerGetMattesLockStateFunc(getMattesLockStateFunc: () => boolean): void {
    this.getMattesLockStateFunc = getMattesLockStateFunc;
  }

  /**
   * unregister getMattesLockState function
   */
  public unregisterGetMattesLockStateFunc(): void {
    this.getMattesLockStateFunc = null;
  }

  /**
   * getMattesLockState
   */
  public getMattesLockState(): boolean {
    if (this.getMattesLockStateFunc) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getMattesLockState] called');
      return this.getMattesLockStateFunc();
    }
    return false;
  }

  /**
   * register getMattesLockState function
   */
  public registerExecuteAnimateToFunc(executeAnimateToFunc:
    (rotateDuration: number, isAssignCurve: boolean, event: () => void, onFinish: () => void) => void): void {
    this.executeAnimateToFunc = executeAnimateToFunc;
  }

  /**
   * unregister getMattesLockState function
   */
  public unregisterExecuteAnimateToFunc(): void {
    this.executeAnimateToFunc = null;
  }

  private executeRotationAnimate(rotateDuration: number, isAssignCurve: boolean, event: () => void, onFinish: () => void): void {
    if (this.executeAnimateToFunc) {
      this.executeAnimateToFunc(rotateDuration, isAssignCurve, event, onFinish);
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[executeAnimateTo] called');
    }
  }

  /**
   * setRotationPropertyHolder
   */
  public setRotationPropertyHolder(rotationPropertyHolder: RotationPropertyHolder): void {
    this.rotationPropertyHolder = rotationPropertyHolder;
  }

  /**
   * clearRotationPropertyHolder
   */
  public clearRotationPropertyHolder(): void {
    this.rotationPropertyHolder = null;
  }

  private getScreenProperty(): SCBScreenProperty {
    if (this.rotationPropertyHolder) {
      WinLog.showDebug(WinLogDomain.WMS_ROTATION, '[getScreenProperty] called');
      return this.rotationPropertyHolder.getScreenProperty();
    }
    throw new Error('[ROTATION][rotationPropertyHolder] is null');
  }

  private getContainerSessionList(): SCBSceneContainerSessionArray {
    if (this.rotationPropertyHolder) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getContainerSessionList] called');
      return this.rotationPropertyHolder.getContainerSessionList();
    }
    return EMPTY_CONTAINER_ARRAY;
  }

  private getFloatingSessionList(): SCBSceneContainerSessionArray {
    if (this.rotationPropertyHolder) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getFloatingSessionList] called');
      return this.rotationPropertyHolder.getFloatingSessionList();
    }
    return EMPTY_CONTAINER_ARRAY;
  }

  private getCurrRotation(): number {
    return this.currRotation;
  }

  private getRotationAnimCnt(): number {
    return this.rotationAnimCnt;
  }

  private setRotationAnimCnt(rotationAnimCnt: number): void {
    this.rotationAnimCnt = rotationAnimCnt;
  }

  private addRotationAnimCnt(): void {
    this.rotationAnimCnt++;
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotationWithAnimation] rotationAnimCnt: ${this.rotationAnimCnt}');
  }

  private decRotationAnimCnt(): void {
    this.rotationAnimCnt--;
  }

  private getRotateFinishTimerId(): number {
    return this.rotateFinishTimerId;
  }

  private setRotateFinishTimerId(rotateFinishTimerId: number): void {
    this.rotateFinishTimerId = rotateFinishTimerId;
  }

  private setCurrRotation(currRotation: number): void {
    this.currRotation = currRotation;
  }

  /**
   * requestPIPScenePanelRotation
   */
  public requestPIPScenePanelRotation(screenProperty: SCBScreenProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[requestPIPScenePanelRotation] called');
    SCBSceneSessionManager.getInstance().requestPIPScenePanelRotation(screenProperty.screenId);
  }

  /**
   * startSceneWithRotationIfNeed
   */
  public startSceneWithRotationIfNeed(containerSession?: SCBSceneContainerSession | null, needAnimation: boolean = false,
    isFromRecent: boolean = false, fromUser: boolean = false, isPageRotation: boolean = false): void {
    if (!containerSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[startSceneWithRotationIfNeed] containerSession is null');
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[startSceneWithRotationIfNeed] containerSession ${containerSession.getName()}` +
      `needAnimation ${needAnimation} isFromRecent ${isFromRecent} fromUser ${fromUser} ` +
      `isPageRotation ${isPageRotation}`);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.getScreenProperty().screenId);
    if (!screenSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[startSceneWithRotationIfNeed] screenSession is null');
      return;
    }
    this.coverSensorRotation(screenSession);
    let targetRotation = this.getContainerSessionRotation(containerSession, screenSession, fromUser);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[startSceneWithRotationIfNeed] before rotate with targetRotation=%{public}i, ' +
      'sensorRotation=%{public}i, currentScreenRotation=%{public}i, currentContainerRotation=%{public}i, ' +
      'name=%{public}s', targetRotation, screenSession.sensorScreenProperty.rotation, this.getScreenProperty().rotation,
      containerSession.currentRotation, containerSession.primarySession?.sceneInfo.bundleName);
    if (SCBWindowRotateController.getInstance().isDesktopRotatable()) {
      HiSysEventUtil.reportRotationChange(containerSession.primarySession?.sceneInfo.bundleName,
        SCBScreenSessionManager.getInstance().getScreenRotation(this.getScreenProperty().screenId), targetRotation,
        fromUser ? HiSysEventUtil.ROTATION_TYPE_SET_REQUESTED_ORIENTATION : HiSysEventUtil.ROTATION_TYPE_APP_START);
      this.rotateScreenPolicy(screenSession, containerSession, isFromRecent, needAnimation, targetRotation, isPageRotation);
    } else {
      this.rotateWindowPolicy(containerSession, fromUser, targetRotation, isFromRecent, needAnimation, isPageRotation);
    }
  }

  /**
   * getContainerSessionRotation
   */
  public getContainerSessionRotation(containerSession: SCBSceneContainerSession, screenSession: SCBScreenSession,
    fromUser: boolean): number {
    let targetRotation = containerSession.getTargetRotation(screenSession.sensorScreenProperty.rotation, fromUser);
    if (containerSession.currentRotation === null || containerSession.currentRotation === undefined) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[getContainerSessionRotation] currentContainerRotation=%{public}i name=%{public}s',
        containerSession.currentRotation, containerSession.getName());
      containerSession.currentRotation = this.getScreenProperty().rotation ?? 0;
      if (screenSession.isRotateScreenPolicy()) {
        containerSession.currentRotation = screenSession.scbScreenProperty?.rotation;
      }
    }
    if (!fromUser && containerSession.isRelatedToUserRotationPolicy() &&
      targetRotation !== containerSession.currentRotation) {
      targetRotation = containerSession.currentRotation;
      let rotationPolicyMap = SCBDeviceScreenConfig.getInstance().getRotationPolicyMap();
      if (!rotationPolicyMap.get(targetRotation)) {
        targetRotation = RotationConstants.ROTATION_0;
      }
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getContainerSessionRotation] change targetRotation=%{public}i', targetRotation);
    }
    return targetRotation;
  }

  /**
   * rotate when use window rotation policy
   */
  public rotateWindowPolicy(containerSession: SCBSceneContainerSession, fromUser: boolean, targetRotation: number,
    isFromRecent: boolean, needAnimation: boolean, isPageRotation: boolean = false): void {
    WinLog.showDebug(WinLogDomain.WMS_ROTATION, '[rotateWindowPolicy] rotate with window policy');
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateWindowPolicy] no need to rotate in the lock screen interface');
      return;
    }
    if (this.isRotationSameAsTargetRotation(containerSession, targetRotation)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateWindowPolicy] no need to rotate with same targetRotation');
      return;
    }
    SCBWindowRotateController.getInstance().notifyBeforeWindowRotateChange();
    this.clearRecentStartNotifyRotation();
    HiSysEventUtil.reportRotationChange(containerSession.primarySession?.sceneInfo.bundleName,
      SCBScreenSessionManager.getInstance().getScreenRotation(this.getScreenProperty().screenId), targetRotation,
      fromUser ? HiSysEventUtil.ROTATION_TYPE_SET_REQUESTED_ORIENTATION : HiSysEventUtil.ROTATION_TYPE_APP_START);

    const screenProperty: SCBScreenProperty = this.getScreenProperty().getRotatedScreenProperty(targetRotation);
    if (isFromRecent && needAnimation && containerSession.currentRotation === targetRotation) {
      needAnimation = false;
    }
    if (needAnimation) {
      // only animation need rotate reason
      if (isFromRecent) {
        this.prepareAnimationBeforeStart(containerSession, this.getScreenProperty().rotation);
      }
      this.notifyRotationWithAnimation(screenProperty, SCBContainerRotationReason.PANEL_ROTATION);
    } else if (isPageRotation) {
      this.notifyPageRotation(screenProperty, true, SCBContainerRotationReason.PANEL_ROTATION, containerSession, isPageRotation);
    } else {
      // change this.screenProperty with screenProperty
      this.notifyRotation(screenProperty, true, SCBContainerRotationReason.START_SCENE, containerSession);
    }
    this.requestPIPScenePanelRotation(screenProperty);
  }

  private isRotationSameAsTargetRotation(containerSession: SCBSceneContainerSession, targetRotation: number): boolean {
    return this.getScreenProperty().rotation === targetRotation &&
      containerSession.currentRotation === targetRotation && this.getCurrRotation() === targetRotation;
  }

  private updateRotateAnimationConfig(rotateDuration: number): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateRotateAnimationConfig] called');
    SCBSceneSessionManager.getInstance().updateRotateAnimationConfig(rotateDuration);
  }

  private notifySystemSceneToUpdateSizeChangeReason(screenProperty: SCBScreenProperty,
    reason: sceneSessionManager.SessionSizeChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifySystemSceneToUpdateSizeChangeReason] called');
    SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateSizeChangeReason(screenProperty, reason);
  }

  private updateVisibleSystemRotation(screenProperty: SCBScreenProperty): [Function, boolean, number | null][] {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateVisibleSystemRotation] called');
    return SCBScreenSessionManager.getInstance().updateVisibleSystemRotation(screenProperty);
  }

  private updateVisibleSystemRotationBeforeScenePanel(screenProperty: SCBScreenProperty): void {
    log.showInfo(`[WINDOW_ROTATION] updateVisibleSystemRotation before ScenePanel`);
    SCBScreenSessionManager.getInstance().updateVisibleSystemRotationBeforeScenePanel(screenProperty);
  }

  private updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks: [Function, boolean, number | null][],
    screenProperty: SCBScreenProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, ` updateInVisibleSystemRotation`);
    SCBScreenSessionManager.getInstance().updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks, screenProperty);
  }

  private setRotateFinishTimer(rotationStartTime: number, screenProperty: SCBScreenProperty,
    rotateEvent: RotateChangeEvent, containerSession: SCBSceneContainerSession | null): void {
    if (this.getRotateFinishTimerId() !== -1) {
      clearTimeout(this.getRotateFinishTimerId());
    }
    this.setRotateFinishTimerId(setTimeout(() => {
      this.rotationAnimationFinished(rotationStartTime, screenProperty,
        rotateEvent, containerSession, true);
      this.setRotateFinishTimerId(-1);
    }, 3000));
  }

  /**
   * notifyRotationWithAnimation
   */
  public notifyRotationWithAnimation(screenProperty: SCBScreenProperty, reason: SCBContainerRotationReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotationWithAnimation] reason: %{public}i, screenProperty, ' +
      'left=%{public}i, top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i', reason,
      screenProperty.left, screenProperty.top, screenProperty.width, screenProperty.height, screenProperty.rotation);
    let containerSession = this.rotationAnimationBegin(screenProperty);
    let rotationWindow = SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    let rotateDuration = this.getRotateDuration(screenProperty.rotation);
    this.updateRotateAnimationConfig(rotateDuration);
    transactionManager.openSyncTransaction(screenProperty.screenId);
    let rotationStartTime = Date.now();
    let rotateEvent: RotateChangeEvent = RotateChangeEvent.create(RotateChangeEvent.ROTATE_STATUS_START);
    EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
    this.notifySystemSceneToUpdateSizeChangeReason(screenProperty, sceneSessionManager.SessionSizeChangeReason.ROTATION);
    let inVisibleSystemSceneCallbacks: [Function, boolean, number | null][] = [];
    this.setRotateFinishTimer(rotationStartTime, screenProperty,
      rotateEvent, containerSession);
    this.setFloatAnimateStatus(true);
    this.executeRotationAnimate(rotateDuration, true, () => {
        let currScreenProperty = new SCBScreenProperty();
        currScreenProperty.copy(this.getScreenProperty());
        this.updateScreenSessionWhenRotate(screenProperty, reason);
        this.updateVisibleSystemRotationBeforeScenePanel(screenProperty);
        this.updateScenePanelWhenRotate(screenProperty, currScreenProperty, reason, undefined);
        inVisibleSystemSceneCallbacks = this.updateVisibleSystemRotation(screenProperty);
        SCBWindowRotateController.getInstance().updateRotationWindow(rotationWindow);
      }, () => {
        this.rotationAnimationFinished(rotationStartTime, screenProperty,
          rotateEvent, containerSession);
        this.setFloatAnimateStatus(false);
      }
    );
    this.showDividerAfterRotation(containerSession, rotateDuration);
    this.updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks, screenProperty);
    this.handleSplitScreen(containerSession, screenProperty, true);
    transactionManager.closeSyncTransaction(screenProperty.screenId);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotationWithAnimation] Update Rotation screenProperty, left=%{public}i,' +
      ' top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i',
      this.getScreenProperty().left, this.getScreenProperty().top, this.getScreenProperty().width,
      this.getScreenProperty().height, this.getScreenProperty().rotation);
  }

  /**
   * updateScreenSessionWhenRotate
   */
  public updateScreenSessionWhenRotate(screenProperty: SCBScreenProperty, reason: SCBContainerRotationReason): void {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.getScreenProperty().screenId);
    if (!screenSession) {
      log.showError('updateScreenSessionWhenRotate screenSession is null');
      return;
    }
    // screen rotation no need to change bounds in screen session
    // rotation with start/exit scene need change bounds since screen session cannot know
    if (reason !== SCBContainerRotationReason.SCREEN_ROTATION) {
      screenSession.updateVirtualProperty(screenProperty, SCBPropertyChangeReason.ROTATION, false);
    }
  }

  /**
   * updateScenePanelWhenRotate
   */
  public updateScenePanelWhenRotate(screenProperty: SCBScreenProperty, currScreenProperty: SCBScreenProperty,
    reason: SCBContainerRotationReason, currentContainer?: SCBSceneContainerSession, isPageRotation: boolean = false): void {
    this.getScreenProperty().copy(screenProperty);
    this.setCurrRotation(this.getScreenProperty().rotation);
    this.notifyUpdateScenePanelWhenRotate(screenProperty);
    if (currentContainer && !currentContainer.isFloat) {
      // start scene with exact container rotation
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[updateScenePanelWhenRotate] Update currentContainer, ` + 
                   `containerId=${currentContainer?.containerId}, isActive=${currentContainer.isActive}` +
                   `name=${currentContainer?.primarySession?.sceneInfo.bundleName}`);
      currentContainer?.updateContainerSessionWithRotation(this.getScreenProperty(), reason, isPageRotation);
    } else {
      // rotation with whole screen
      for (let containerSession of this.getContainerSessionList()) {
        if (!containerSession.isActive) {
          // need to set inactive container not rotate
          continue;
        }
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[updateScenePanelWhenRotate] Update containerSession, ` + 
                     `containerId=${containerSession.containerId}, isActive=${containerSession.isActive}` + 
                     `name=${containerSession.primarySession?.sceneInfo.bundleName}`);
        containerSession.updateContainerSessionWithRotation(screenProperty, reason, isPageRotation);
      }
    }
    this.updateFloatContainerWithScreenChange(screenProperty, reason);
    this.updateSystemBarProperty();
  }

  private updateSystemBarProperty(): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateScenePanelWhenRotate] updateSystemBarProperty');
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
  }

  private rotationAnimationFinished(rotationStartTime: number, screenProperty: SCBScreenProperty,
    rotateEvent: RotateChangeEvent, containerSession: SCBSceneContainerSession | null,
    isTimeoutCheck: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[rotationAnimationFinished] rotationAnimCnt:${this.getRotationAnimCnt()}` +
                 `isTimeoutCheck:${isTimeoutCheck}`);
    this.updateNeedScrollClipRotateFinish();
    if (isTimeoutCheck) {
      if (this.getRotationAnimCnt() > 0) {
        this.setRotationAnimCnt(1);
      } else {
        return;
      }
    }
    this.decRotationAnimCnt();
    if (this.getRotationAnimCnt() < 0) {
      this.setRotationAnimCnt(0);
      return;
    }
    let rotationDuration = Date.now() - rotationStartTime;
    HiDfxEventUtil.reportScenePanelRotationEnd(rotationStartTime.toFixed(), this.getScreenProperty().screenId,
      this.getPanelName(), rotationDuration);
    SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_END);
    if (this.getRotationAnimCnt() === 0) {
      this.notifyScreenRotateToCallbacks(screenProperty,
        SCBRotateChangeReason.ROTATE_END);
      this.updateScreenRotationProperty(screenProperty,
        SCBRotateChangeReason.ROTATE_END);
      // not show desktop, since focus error
      AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(1);
      this.notifySystemSceneToUpdateSizeChangeReason(screenProperty,
        sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      this.updateBlackBackgroundState(false);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, DEFAULT_0);
      this.showWallpaperAfterRotate();
      rotateEvent.rotateStatus = RotateChangeEvent.ROTATE_STATUS_END;
      EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
      performanceMonitor.end('SCREEN_ROTATION_ANI');
    }
    this.setKeyboardRotationFlag(false);
    this.updateFloatAfterRotationAnimate();
  }

  private notifyScreenRotateToCallbacks(screenProperty: SCBScreenProperty, notifyType: SCBRotateChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[notifyScreenRotateToCallbacks] notifyType: ${notifyType}`);
    SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty, notifyType);
  }

  private prepareSystemSceneRotationBeforeAnimation(rotation: number): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[prepareSystemSceneRotationBeforeAnimation] rotation: ${rotation}`);
    SCBSceneSessionManager.getInstance().prepareSystemSceneRotationBeforeAnimation(rotation);
  }

  /**
   * rotationAnimationBegin
   */
  public rotationAnimationBegin(screenProperty: SCBScreenProperty): SCBSceneContainerSession | null {
    // notify other app rotation listener
    this.updateScreenRotationProperty(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    this.notifyScreenRotateToCallbacks(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(0);
    this.addRotationAnimCnt();

    // don't show wallpaper and desktop during rotation both normal and split scenario
    if (SCBSceneSessionManager.getInstance().hasFullSceneSession(screenProperty.screenId)) {
      ViewManagerPolicy.hideView(ViewType.DESKTOP);
    }
    let isScreenLocked = SCBSceneSessionManager.getInstance().isScreenLocked();
    if (isScreenLocked || SCBSceneSessionManager.getInstance().hasFullSceneSession(screenProperty.screenId)) {
      ViewManagerPolicy.hideView(ViewType.WALLPAPER);
    }
    let containerSession = this.getContainerSessionList().getTopActiveSession();
    if (containerSession && containerSession.primarySession && containerSession.secondarySession) {
      containerSession.dividerParam.dividerAlpha = 0;
    }

    // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, DEFAULT_1);
    performanceMonitor.begin('SCREEN_ROTATION_ANI', performanceMonitor.ActionType.LAST_UP,
      containerSession?.primarySession?.sceneInfo.bundleName);

    this.prepareRotationBeforeAnimation(screenProperty.rotation);
    this.prepareSystemSceneRotationBeforeAnimation(screenProperty.rotation);

    //  black background is added only when a full-screen Session exists.
    if (!!this.getContainerSessionList().getTopActiveSession()) {
      this.updateBlackBackgroundState(true);
    }
    this.setKeyboardRotationFlag(true);
    return containerSession ?? null;
  }

  /**
   * rotationAnimationBeginWhenNotifyRotation
   */
  public rotationAnimationBeginWhenNotifyRotation(screenProperty: SCBScreenProperty): SCBSceneContainerSession | null {
    AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(0);
    this.addRotationAnimCnt();
    let containerSession = this.getContainerSessionList().getTopActiveSession();
    // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, DEFAULT_1);
    performanceMonitor.begin('SCREEN_ROTATION_ANI', performanceMonitor.ActionType.LAST_UP,
      containerSession?.primarySession?.sceneInfo.bundleName);
    // 大角度的旋转
    this.prepareRotationBeforeAnimation(screenProperty.rotation);
    this.prepareSystemSceneRotationBeforeAnimation(screenProperty.rotation);
    this.setKeyboardRotationFlag(true);
    return containerSession ?? null;
  }

  /**
   * prepareAnimationBeforeStart
   */
  public prepareAnimationBeforeStart(containerSession: SCBSceneContainerSession, screenRotation: number): void {
    let lastAngle = (screenRotation - containerSession.currentRotation + RotationConstants.ROTATION_360) %
      RotationConstants.ROTATION_360;
    if (lastAngle === RotationConstants.ROTATION_270) {
      lastAngle = -RotationConstants.ROTATION_90;
    }
    let tmp = (screenRotation - lastAngle + RotationConstants.ROTATION_360) % RotationConstants.ROTATION_360;
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[prepareAnimationBeforeStart] change sceneContainerSession currentRotation ` +
                 `from ${containerSession.currentRotation} to ${tmp}, ` +
                 `screenRotation: ${screenRotation} start from recent, ` +
                 `name:${containerSession.getName()} lastAngle:${lastAngle}`);
    containerSession.currentRotation = tmp;
  }

  /**
   * rotate when use screen rotation policy
   */
  public rotateScreenPolicy(screenSession: SCBScreenSession, containerSession: SCBSceneContainerSession,
    isFromRecent: boolean, needAnimation: boolean, targetRotation: number, isPageRotation: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenPolicy] rotate with screen policy' +
                 `isPageRotation:${isPageRotation}`);
    const screenRotation = SCBScreenSessionManager.getInstance().getScreenRotation(this.getScreenProperty().screenId);
    this.setExpandStartContainerSession(containerSession);
    if (isFromRecent && needAnimation && containerSession.currentRotation === targetRotation) {
      needAnimation = false;
    }
    // 应用当前角度不等于目标角度，或者当前屏幕角度不等于目标角度时，需要强制旋转
    let isForce: boolean = (containerSession.currentRotation !== targetRotation || targetRotation !== screenRotation);
    if (isForce && isFromRecent) {
      this.clearRecentStartNotifyRotation();
    }
    if (needAnimation) {
      if (isFromRecent) {
        this.prepareAnimationBeforeStart(containerSession, screenRotation);
      } else {
        if (screenSession.isRotateScreenPolicy()) {
          containerSession.currentRotation = targetRotation;
        }
      }
    }

    if (!needAnimation && targetRotation !== screenSession.scbScreenProperty.rotation &&
      !SCBSceneSessionManager.getInstance().isScreenLocked() && !isFromRecent &&
      !SCBScreenSessionManager.getInstance().isSingleFoldablePhoneFoldStatus() && !isPageRotation) {
      SCBWindowRotateController.getInstance().notifyBeforeWindowRotateChange();
      let screenProperty = this.getScreenProperty();
      SCBWindowRotateController.getInstance().sceneLandscapeStart(screenSession, containerSession,
        targetRotation, screenProperty);
      let systemSceneNeedAnimation = SCBScreenSessionManager.getInstance().hasRotationCallbacks(screenProperty);
      if (systemSceneNeedAnimation) {
        this.notifySystemSceneRotationWithAnimation(screenProperty, containerSession);
      }
      // sync when 600ms timeout
      setTimeout(() => {
        SCBWindowRotateController.getInstance().landscapeStartSync(containerSession, this.getScreenProperty());
      }, 600);
    } else {
      SCBWindowRotateController.getInstance().windowRotateEntry(targetRotation, 'scenePanelStartScene',
        needAnimation, isForce, true, false, isPageRotation);
    }
    this.setExpandStartContainerSession(null);
  }

  private updateScreenRotationProperty(screenProperty: SCBScreenProperty, notifyType: SCBRotateChangeReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateScreenRotationProperty] called');
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty, notifyType);
  }

  private notifySetSystemSceneRotaion(screenProperty: SCBScreenProperty, systemWantAnimation: boolean): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifySetSystemSceneRotaion] called');
    SCBSceneSessionManager.getInstance().notifySetSystemSceneRotaion(screenProperty, systemWantAnimation);
  }

  private notifyUpdateSystemScenePropertyWithoutAnimation(screenProperty: SCBScreenProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyUpdateSystemScenePropertyWithoutAnimation] called');
    SCBScreenSessionManager.getInstance().notifyUpdateSystemScenePropertyWithoutAnimation(screenProperty);
  }

  /**
   * notifyRotation
   */
  public notifyRotation(screenProperty: SCBScreenProperty, needUpdateSystem: boolean,
    reason: SCBContainerRotationReason, currentContainer?: SCBSceneContainerSession): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotation] reason: %{public}i, screenProperty: ' +
      'left=%{public}i, top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i', reason,
      screenProperty.left, screenProperty.top, screenProperty.width, screenProperty.height, screenProperty.rotation);
    let currScreenProperty = new SCBScreenProperty();
    currScreenProperty.copy(this.getScreenProperty());
    // notify other app rotation listener
    this.updateScreenRotationProperty(screenProperty, SCBRotateChangeReason.UNSPECIFIED);
    let rotationWindow = SCBWindowRotateController.getInstance()
      .notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN, true);
    this.updateScreenSessionWhenRotate(screenProperty, reason);
    SCBWindowRotateController.getInstance().updateRotationWindow(rotationWindow);
    this.updateScenePanelWhenRotate(screenProperty, currScreenProperty, reason, currentContainer);
    let needAnimation = SCBScreenSessionManager.getInstance().hasRotationCallbacks(screenProperty);
    if (needUpdateSystem) {
      // start scene need inform after start animation
      this.notifySetSystemSceneRotaion(screenProperty, false);
      this.notifyUpdateSystemScenePropertyWithoutAnimation(screenProperty);
      if (needAnimation) {
        this.notifySystemSceneRotationWithAnimation(screenProperty, currentContainer);
      }
    }
    SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_END);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotation] Update screenProperty, left=%{public}i, top=%{public}i' +
      ', width=%{public}i, height=%{public}i, rotation=%{public}i', this.getScreenProperty().left,
      this.getScreenProperty().top, this.getScreenProperty().width,
      this.getScreenProperty().height, this.getScreenProperty().rotation);
  }

  private getRotateDuration(screenPropertyRotation: number): number {
    let rotationAngle = Math.abs(screenPropertyRotation - this.getScreenProperty().rotation);
    return rotationAngle > 90 ? 550 : 400;
  }

  private notifyUpdateSystemScenePropertyWithAnimation(screenProperty: SCBScreenProperty): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyUpdateSystemScenePropertyWithAnimation] called');
    SCBScreenSessionManager.getInstance().notifyUpdateSystemScenePropertyWithAnimation(screenProperty);
  }

  private notifySystemSceneRotationWithAnimation(screenProperty: SCBScreenProperty,
    currentContainer?: SCBSceneContainerSession): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[notifySystemSceneRotationWithAnimation] notify systemscene, ` + 
                 `bundleName: ${currentContainer?.primarySession?.session.bundleName} animation when notifyRotation`);
    let containerSession = this.rotationAnimationBeginWhenNotifyRotation(screenProperty);
    let rotateDuration = this.getRotateDuration(screenProperty.rotation);
    let rotationStartTime = Date.now();
    this.updateRotateAnimationConfig(rotateDuration);
    let rotateEvent: RotateChangeEvent = RotateChangeEvent.create(RotateChangeEvent.ROTATE_STATUS_START);
    this.notifySystemSceneToUpdateSizeChangeReason(screenProperty, sceneSessionManager.SessionSizeChangeReason.ROTATION);
    this.setRotateFinishTimer(rotationStartTime, screenProperty,
      rotateEvent, containerSession);
    this.executeRotationAnimate(rotateDuration, true, () => {
        this.notifySetSystemSceneRotaion(screenProperty, true);
        this.notifyUpdateSystemScenePropertyWithAnimation(screenProperty);
      }, () => {
        this.rotationAnimationFinishedWhenNotifyRotation(rotationStartTime, screenProperty, rotateEvent);
      }
    );
  }

  private rotationAnimationFinishedWhenNotifyRotation(rotationStartTime: number, screenProperty: SCBScreenProperty,
    rotateEvent: RotateChangeEvent, isTimeoutCheck: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[rotationAnimationFinishedWhenNotifyRotation] AnimCnt:${this.getRotationAnimCnt()}` +
                 `isTimeoutCheck:${isTimeoutCheck}`);
    if (isTimeoutCheck) {
      if (this.getRotationAnimCnt() > 0) {
        this.setRotationAnimCnt(1);
      } else {
        return;
      }
    }
    this.decRotationAnimCnt();
    if (this.getRotationAnimCnt() < 0) {
      this.setRotationAnimCnt(0);
      return;
    }
    let rotationDuration = Date.now() - rotationStartTime;
    HiDfxEventUtil.reportScenePanelRotationEnd(rotationStartTime.toFixed(), this.getScreenProperty().screenId,
      this.getPanelName(), rotationDuration);
    if (this.getRotationAnimCnt() === 0) {
      AnimateToScheduleUtils.raiseAnimateRotationToCPUPriority(1);
      SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateSizeChangeReason(screenProperty,
        sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, DEFAULT_0);
      rotateEvent.rotateStatus = RotateChangeEvent.ROTATE_STATUS_END;
      EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
      performanceMonitor.end('SCREEN_ROTATION_ANI');
    }
    this.setKeyboardRotationFlag(false);
  }

  /**
   * notifyPageRotation
   */
  public notifyPageRotation(screenProperty: SCBScreenProperty, needUpdateSystem: boolean,
    reason: SCBContainerRotationReason, currentContainer?: SCBSceneContainerSession, isPageRotation: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyPageRotation] reason: %{public}i, screenProperty: ' +
      'left=%{public}i, top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i', reason,
      screenProperty.left, screenProperty.top, screenProperty.width, screenProperty.height, screenProperty.rotation);
    let currScreenProperty = new SCBScreenProperty();
    currScreenProperty.copy(this.getScreenProperty());
    // notify other app rotation listener
    transactionManager.openSyncTransaction(screenProperty.screenId);
    let inVisibleSystemSceneCallbacks: [Function, boolean, number | null][] = [];
    this.executeRotationAnimate(0, false, () => {
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty,
        SCBRotateChangeReason.UNSPECIFIED);
      this.updateScreenSessionWhenRotate(screenProperty, reason);
      this.updateVisibleSystemRotationBeforeScenePanel(screenProperty);
      this.updateScenePanelWhenRotate(screenProperty, currScreenProperty, reason, currentContainer, isPageRotation);
      inVisibleSystemSceneCallbacks = this.updateVisibleSystemRotation(screenProperty);
    }, () => {});
    if (currentContainer?.isVertical(currentContainer.currentRotation) !== currentContainer?.isVertical(screenProperty.rotation)) {
      transactionManager.closeSyncTransaction(screenProperty.screenId);
    } else {
      transactionManager.closeSyncTransactionWithVsync(screenProperty.screenId);
      // 0->180, 90->270 need close with vsync since size not change
    }
    this.updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks, screenProperty);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyPageRotation] Update screenProperty, left=%{public}i, top=%{public}i' +
      ', width=%{public}i, height=%{public}i, rotation=%{public}i', this.getScreenProperty().left,
      this.getScreenProperty().top, this.getScreenProperty().width,
      this.getScreenProperty().height, this.getScreenProperty().rotation);
  }

  /**
   * exitSceneWithRotationRecover
   */
  public exitSceneWithRotationRecover(currentSession?: SCBSceneContainerSession,
    reason?: SCBContainerRotationReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[exitSceneWithRotationRecover] exit scene rotation reason:${reason}`);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.getScreenProperty().screenId);
    if (!screenSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] screenSession is null');
      return;
    }
    if (SCBWindowRotateController.getInstance().isDesktopRotatable()) {
      this.rotateScreenWhenExitScene(currentSession, reason);
      return;
    }
    let isVerticalExit = this.isVerticalExit();
    if (isVerticalExit && reason !== SCBContainerRotationReason.LANDSCAPE_ONE_STEP_SCENE) {
      WinLog.showDebug(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] no need to recover with vertical Exit!');
      return;
    }
    // interrupt autoStartPip Animation with float rotation
    this.interruptPipAnimWithFloatRotation();
    // split scene need to do with rotation
    if (this.getContainerSessionList().getTopActiveFullSession() && !this.checkIfSplitScene(reason)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] no need to recover if exist top active scene!');
      return;
    }
    let targetScreenProperty = this.getScreenProperty().getRotatedScreenProperty(0);
    if (targetScreenProperty.rotation === this.getScreenProperty().rotation &&
      reason !== SCBContainerRotationReason.LANDSCAPE_ONE_STEP_SCENE) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] name=%{public}s, ' +
        'no need notify rotation targetRotation=%{public}i, sensorRotation=%{public}i, ' +
        'currentScreenRotation=%{public}i, currentRotation=%{public}i',
        currentSession?.primarySession?.sceneInfo.bundleName, targetScreenProperty.rotation,
        screenSession.sensorScreenProperty.rotation, this.getScreenProperty().rotation,
        currentSession?.currentRotation);
      return;
    }
    // change this.screenProperty with screenProperty
    HiSysEventUtil.reportRotationChange(currentSession?.primarySession?.sceneInfo.bundleName,
      SCBScreenSessionManager.getInstance().getScreenRotation(this.getScreenProperty().screenId),
      targetScreenProperty.rotation, HiSysEventUtil.ROTATION_TYPE_APP_OUT);
    if (reason && this.checkIfSplitScene(reason)) {
      this.notifyRotation(targetScreenProperty, true, reason, currentSession);
    } else if (this.getFloatingSessionList().getTopActiveSession()) {
      this.handleFloatWhenExitScene(reason);
      this.notifyRotationWithAnimation(targetScreenProperty, SCBContainerRotationReason.EXIT_SCENE);
    } else {
      this.notifyRotation(targetScreenProperty, true, SCBContainerRotationReason.EXIT_SCENE,
        currentSession);
    }
    this.clearExitSceneNotifyRotation();
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[exitSceneWithRotationRecover] targetRotation = 0
      ,sensorRotation=${screenSession.sensorScreenProperty.rotation},currentRotation=${this.getScreenProperty().screenId}`);
    SCBSceneSessionManager.getInstance().requestPIPScenePanelRotation(this.getScreenProperty().screenId);
  }

  public isVerticalExit(): boolean {
    return this.getScreenProperty().rotation === RotationConstants.ROTATION_0 ||
      this.getScreenProperty().rotation === RotationConstants.ROTATION_360;
  }

  private checkIfSplitScene(reason?: SCBContainerRotationReason): boolean {
    return reason === SCBContainerRotationReason.SPLIT_SCENE ||
      reason === SCBContainerRotationReason.LANDSCAPE_ONE_STEP_SCENE;
  }

  /**
   * 屏幕旋转的应用退出旋转
   */
  private rotateScreenWhenExitScene(currentSession?: SCBSceneContainerSession,
    reason?: SCBContainerRotationReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenWhenExitScene] rotate screen when exit scene');
    if (this.getContainerSessionList().getTopActiveSession() &&
      (reason !== SCBContainerRotationReason.SPLIT_SCENE && reason !== SCBContainerRotationReason.MID_SCENE)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateScreenWhenExitScene] no need to recover if exist top active scene!');
      return;
    }
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.getScreenProperty().screenId);
    if (!screenSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[rotateScreenWhenExitScene] screenSession is null');
      return;
    }
    // 锁定旋转时转到锁定前的角度；未锁定旋转时，转到sensor所在角度
    let targetRotation = screenSession.getTargetScreenRotationWhenAppExit();
    let isForce = (targetRotation !== screenSession.scbScreenProperty.rotation);
    let needAnimation: boolean = true;
    // when screen rotate landscape start not sync not need animation but need force
    if (SCBWindowRotateController.getInstance().isLandscapeStartInterrupt() &&
      targetRotation === SCBWindowRotateController.getInstance().getLandscapeStartDesktopRotation()) {
      WinLog.showWarn(WinLogDomain.WMS_ROTATION, '[rotateScreenWhenExitScene] screen rotate landscape start not sync when exit scene.');
      needAnimation = false;
      isForce = true;
    }
    HiSysEventUtil.reportRotationChange(currentSession?.primarySession?.sceneInfo.bundleName,
      SCBScreenSessionManager.getInstance().getScreenRotation(this.getScreenProperty().screenId),
      targetRotation, HiSysEventUtil.ROTATION_TYPE_APP_OUT);

    SCBWindowRotateController.getInstance().windowRotateEntry(targetRotation, 'scenePanelExitScene',
      needAnimation, isForce);
    SCBWindowRotateController.getInstance().setLandScapeStartNotSync(false);
  }

}