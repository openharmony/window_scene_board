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

import { SingletonHelper } from '@ohos/basicutils';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBConstants, RotationConstants } from '@ohos/commonconstants';
import { SCBScreenSession, SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { SCBSceneContainerSession } from '../session/SCBSceneContainerSession';
import { SCBSceneOrientation } from '../session/SCBSceneOrientation';
import { SCBScreenSessionManager, SCBPropertyChangeReason,
  SCBRotateChangeReason } from '../../screen/session/SCBScreenSessionManager';
import { ROTATION_TO_ORIENTATION, SCBSceneSessionManager, ScenePanelState } from '../session/SCBSceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { SCBSceneSession } from '../session/SCBSceneSession';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSystemSceneSession } from '../session/SCBSystemSceneSession';
import { SCBSpecificSession } from '../session/SCBSpecificSession';

const TAG = 'SCBWindowRotateController';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class SCBWindowRotateController {
  private windowRotateChangeCallback: Function;
  private beforeWindowRotateChangeCallback: Function;

  // landscap start state when screen rotate policy
  private landscapeStartFlag: boolean = false;
  private landScapeStartNotSync: boolean = false;
  private landscapeStartRotation: number = 0;
  private landscapeStartDesktopRotation: number = 0;
  private landscapeStartBundleName: string = '';
  private landscapeStartSceneOrientation: SCBSceneOrientation = SCBSceneOrientation.UNSPECIFIED;
  private landscapeStartScenePanelCallback: Function;
  private startSceneWithRotationIfNeedCallback: Function;

  /**
   * Obtains a single instance of SCBWindowRotateController.
   *
   * @returns { SCBWindowRotateController } Returns a singleton instance of SCBWindowRotateController
   */
  public static getInstance(): SCBWindowRotateController {
    return SingletonHelper.getInstance(SCBWindowRotateController, TAG);
  }

  /**
   * if full screen rotate policy
   *
   * @param { scbScreenSession } scbScreenSession
   * @returns boolean
   */
  public isFullScreenRotatePolicy(scbScreenSession?: SCBScreenSession): boolean {
    let screenSession = scbScreenSession;
    if (screenSession === undefined) {
      screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      if (screenSession === null || screenSession === undefined) {
        log.showInfo('[isFullScreenRotatePolicy] screenSession is null.');
        return false;
      }
    }
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    return !screenSession.isRotateScreenPolicy() && (uiType === SCBConstants.UITYPE_PAD ||
      screenSession.isFoldablePhoneExpandStatus());
  }

  /**
   * if desktop rotatable
   *
   * @returns boolean
   */
  public isDesktopRotatable(): boolean {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      log.showInfo('[isDesktopRotatable] screenSession is null.');
      return false;
    }
    return screenSession.isRotateScreenPolicy() || this.isFullScreenRotatePolicy();
  }

  /**
   * register window rotate change callback
   *
   * @param {func} Function
   */
  public registerWindowRotateChangeCallback(func: Function): void {
    log.showInfo('[registerWindowRotateChangeCallback] register.');
    this.windowRotateChangeCallback = func;
  }

  /**
   * unregister window rotate change callback
   */
  public unRegisterWindowRotateChangeCallback(): void {
    log.showInfo('[unRegisterWindowRotateChangeCallback] unregiser');
    this.windowRotateChangeCallback = undefined;
  }

  private notifyWindowRotateChange(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason,
    needNotify: boolean = true): void {
    if (this.windowRotateChangeCallback) {
      this.windowRotateChangeCallback(screenProperty, reason, needNotify);
    } else {
      log.showInfo('[notifyWindowRotateChange] callback is null');
    }
  }

  public registerBeforeWindowRotateChangeCallback(func: Function): void {
    this.beforeWindowRotateChangeCallback = func;
  }

  public notifyBeforeWindowRotateChange(): void {
    if (this.beforeWindowRotateChangeCallback) {
      this.beforeWindowRotateChangeCallback();
    } else {
      log.showInfo('[notifyBeforeWindowRotateChange] callback is null');
    }
  }

  /**
   * register callback which start scene as the same time rotate if need
   *
   * @param {func} Function
   */
  public registerStartSceneWithRotationIfNeedCallback(func: Function): void {
    log.showInfo('[registerStartSceneWithRotationIfNeedCallback] register.');
    this.startSceneWithRotationIfNeedCallback = func;
  }

  /**
   * unregister callback which start scene as the same time rotate if need
   */
  public unRegisterStartSceneWithRotationIfNeedCallback(): void {
    log.showInfo('[unRegisterStartSceneWithRotationIfNeedCallback] unregister.');
    this.startSceneWithRotationIfNeedCallback = undefined;
  }

  private notifyStartSceneWithRotationIfNeed(containerSession?: SCBSceneContainerSession | null,
    needAnimation: boolean = false, isFromRecent: boolean = false, fromUser: boolean = false): void {
    if (this.startSceneWithRotationIfNeedCallback) {
      this.startSceneWithRotationIfNeedCallback(containerSession, needAnimation, isFromRecent, fromUser);
    } else {
      log.showInfo('[notifyStartSceneWithRotationIfNeed] callback is null.');
    }
  }

  /**
   * window rotate when ccm config is window rotate
   *
   * @param { targetRotation } targetRotation
   * @param { rotateReasonDescription } rotateReasonDescription
   * @param { needAnimation } needAnimation
   * @param { isForce } isForce
   * @param { needNotify } needNotify
   * @param { ignoreSuspendRotate } ignoreSuspendRotate
   */
  public windowRotateEntry(targetRotation: number, rotateReasonDescription: string,
    needAnimation: boolean = true, isForce: boolean = false,
    needNotify: boolean = true, ignoreSuspendRotate: boolean = false, isPageRotation: boolean = false): void {
    log.showInfo(`windowRotateEntry targetRotation: ${targetRotation}, rotateReasonDescription:${rotateReasonDescription} ` +
      `isPageRotation:${isPageRotation}`);
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      log.showInfo('[windowRotateEntry] screenSession is null.');
      return;
    }
    if (screenSession.isRotateScreenPolicy()) {
      screenSession.rotationChangeByScreen(targetRotation, rotateReasonDescription, needAnimation, isForce, needNotify,
        isPageRotation);
      return;
    }
    if (!ignoreSuspendRotate && screenSession.isSuspendRotate(rotateReasonDescription)) {
      log.showInfo('[windowRotateEntry] rotate is disabled return.');
      return;
    }
    if (isForce) {
      log.showInfo('[windowRotateEntry] force rotate');
      this.rotateScreenToRotation(targetRotation, needAnimation, needNotify, rotateReasonDescription, screenSession, isPageRotation);
      return;
    }
    let curScreenRotation = screenSession.scbScreenProperty.rotation;
    if (targetRotation === curScreenRotation) {
      log.showInfo('[windowRotateEntry] no need rotate with same rotation: ' + targetRotation);
      return;
    }
    let needRotate = SCBSceneSessionManager.getInstance().isScreenNeedRotate(targetRotation, curScreenRotation, screenSession.scbScreenProperty.screenId);
    if (!needRotate) {
      log.showInfo('[windowRotateEntry] screen no need rotate return');
      return;
    }
    this.rotateScreenToRotation(targetRotation, needAnimation, needNotify, rotateReasonDescription, screenSession,
      isPageRotation);
    return;
  }

  private rotateScreenToRotation(rotation: number, needAnimation: boolean = true, needNotify: boolean = true,
    rotateReasonDescription: string, screenSession: SCBScreenSession, isPageRotation: boolean = false): void {
    log.showInfo(`[rotateScreenToRotation] rotate screen to: ${rotation}, rotateReasonDescription: ${rotateReasonDescription} isPageRotation: ${isPageRotation}`);
    this.notifyBeforeWindowRotateChange();
    AppStorage.setOrCreate('screenRotation', rotation);
    if (rotateReasonDescription === 'sensor rotation change') {
      let bundleName = SCBSceneSessionManager.getInstance().getContainerSessionList(screenSession.scbScreenProperty.screenId)
        .getTopActiveSession()?.primarySession?.sceneInfo.bundleName;
      HiSysEventUtil.reportRotationChange(bundleName, screenSession.scbScreenProperty.rotation, rotation, HiSysEventUtil.ROTATION_TYPE_SENSOR);
    }
    let propertyAfter = screenSession.scbScreenProperty.getRotatedScreenProperty(rotation);
    const reason = isPageRotation ? SCBPropertyChangeReason.PAGE_ROTATION : (needAnimation ? SCBPropertyChangeReason.FOLD_SCREEN_ROTATION :
      SCBPropertyChangeReason.FOLD_LANDSCAPE_START);
    this.notifyWindowRotateChange(propertyAfter, reason, needNotify);
  }

  /**
   * get landscape start flag
   *
   * @returns boolean
   */
  public getLandscapeStartFlag(): boolean {
    return this.landscapeStartFlag;
  }

  /**
   * register landscape start scenePanel callback
   *
   * @param {func} Function
   */
  public registerLandscapeStartScenePanelCallback(func: Function): void {
    log.showInfo('[registerLandscapeStartScenePanelCallback] register.');
    this.landscapeStartScenePanelCallback = func;
  }

  /**
   * unRegister landscape start scenePanel callback
   */
  public unRegisterLandscapeStartScenePanelCallback(): void {
    log.showInfo('[unRegisterLandscapeStartScenePanelCallback] unregister.');
    this.landscapeStartScenePanelCallback = undefined;
  }

  private updateScenePanelWhenLandscapeStart(propertyAfter: SCBScreenProperty): void {
    if (this.landscapeStartScenePanelCallback) {
      this.landscapeStartScenePanelCallback(propertyAfter);
    } else {
      log.showInfo('[updateScenePanelWhenLandscapeStart] callback is null.');
    }
  }

  /**
   * get landscape start desktop rotation
   *
   * @returns number
   */
  public getLandscapeStartDesktopRotation(): number {
    return this.landscapeStartDesktopRotation;
  }

  /**
   * get landscape start rotation
   *
   * @returns number
   */
  public getLandscapeStartRotation(): number {
    return this.landscapeStartRotation;
  }

  /**
   * set landscape start not sync
   *
   * @param {flag} boolean
   */
  public setLandScapeStartNotSync(flag: boolean): void {
    this.landScapeStartNotSync = flag;
  }

  /**
   * scene landscape start
   *
   * @param { screenSession } screenSession
   * @param { containerSession } containerSession
   * @param { targetRotation } targetRotation
   * @param { screenProperty } screenProperty
   */
  public sceneLandscapeStart(screenSession: SCBScreenSession, containerSession: SCBSceneContainerSession,
    targetRotation: number, screenProperty: SCBScreenProperty): void {
    let topActiveSession = SCBSceneSessionManager.getInstance().
      getContainerSessionList(screenSession.scbScreenProperty.screenId).getTopActiveSession();
    if (!topActiveSession) {
      this.landscapeStartDesktopRotation = screenSession.scbScreenProperty.rotation;
    }
    let windowRotation = targetRotation;
    log.showInfo(`[sceneLandscapeStart] landScapeStartNotSync: ${this.landScapeStartNotSync}, ` +
                 `landscapeStartFlag: ${this.landscapeStartFlag}`);
    if (!this.isFullScreenRotatePolicy()) {
      if (this.landScapeStartNotSync && this.landscapeStartFlag) {
        // multi-landscapeStart to fix windowRotation
        windowRotation = 0;
      } else {
        windowRotation = (targetRotation - screenSession.scbScreenProperty.rotation +
          RotationConstants.ROTATION_360) % RotationConstants.ROTATION_360;
      }
    }
    let propertyAfter: SCBScreenProperty = screenProperty.getRotatedScreenProperty(windowRotation);
    let propertyNotify = screenSession.scbScreenProperty.getRotatedScreenProperty(targetRotation);
    log.showInfo(`[sceneLandscapeStart] begin screen rotate policy landscape start, ` +
                 `targetRotation: ${targetRotation}, windowRotation: ${windowRotation}, ` + 
                 `currentRotation: ${this.landscapeStartDesktopRotation}, ` +
                 `scbScreenProperty.rotation: ${screenSession.scbScreenProperty.rotation}`);
    // update screenSession scbScreenProperty
    screenSession.updateScbScreenPropertyByRotation(propertyNotify.rotation);

    // notify cpp ScreenProperty
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(propertyNotify);

    let rotationWindow = this.notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN, true);
    // update SCBScenePanel
    this.updateScenePanelWhenLandscapeStart(propertyAfter);
    this.updateRotationWindow(rotationWindow);
    containerSession.updateContainerSessionWithFold(propertyAfter, SCBPropertyChangeReason.FOLD_LANDSCAPE_START);

    // update system scene
    SCBScreenSessionManager.getInstance().notifyUpdateSystemScenePropertyWithoutAnimation(propertyAfter);
    SCBSceneSessionManager.getInstance().notifySetSystemSceneRotaion(propertyAfter, false);

    this.landscapeStartFlag = true;
    this.landscapeStartRotation = targetRotation;
    this.landscapeStartSceneOrientation = containerSession.getContainerRequestOrientation();
    this.landScapeStartNotSync = true;
    this.landscapeStartBundleName = containerSession.getBundleName();
  }

  /**
   * scene landscape start sync
   *
   * @param { screenSession } screenSession
   * @param { screenProperty } screenProperty
   */
  public landscapeStartSync(containerSession: SCBSceneContainerSession, screenProperty: SCBScreenProperty): void {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (screenSession === null || screenSession === undefined || this.landscapeStartBundleName !== containerSession.getBundleName()) {
      log.showInfo('[landscapeStartSync] screenSession is null or error bundleName.');
      return;
    }
    let scenePanelState: ScenePanelState | undefined = AppStorage.get<ScenePanelState>('scenePanelState');
    log.showInfo(`[landscapeStartSync] begin screen rotate policy, ` +
                 `landscape start sync Flag: ${this.landscapeStartFlag}, ` +
                 `landscapeStartRotation: ${this.landscapeStartRotation}, ` +
                 `currentRotation: ${screenSession.scbScreenProperty.rotation}, ` +
                 `scenePanelRotation: ${screenProperty.rotation}, scenePanelState: ${scenePanelState}, ` +
                 `containerSession.isActive: ${containerSession.isActive} ${containerSession.getBundleName()}`);
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    let isPadScreenLocked: boolean = (uiType === SCBConstants.UITYPE_PAD && SCBSceneSessionManager.getInstance().isScreenLocked());
    if (this.landscapeStartFlag &&
      (isPadScreenLocked || this.isFullScreenRotatePolicy() || (screenSession.isRotateScreenPolicy() && screenProperty.rotation !== 0)) &&
      this.landscapeStartRotation === screenSession.scbScreenProperty.rotation &&
      scenePanelState === ScenePanelState.FULLSCENE && containerSession.isActive) {
      if (screenSession.isRotateScreenPolicy()) {
        screenSession.rotationChangeByScreen(this.landscapeStartRotation, 'screenRotateLandscapeStart', false, true, false);
      } else {
        this.windowRotateEntry(this.landscapeStartRotation, 'screenRotateLandscapeStart', false, true, false);
      }
      this.landScapeStartNotSync = false;
      let newRequestedOrientation = containerSession.getContainerRequestOrientation();
      if (newRequestedOrientation !== this.landscapeStartSceneOrientation) {
        log.showInfo(`[landscapeStartSync] screen rotate policy landscape start window orientation from ` +
                     `${this.landscapeStartSceneOrientation}  to  ${newRequestedOrientation}`);
        this.notifyStartSceneWithRotationIfNeed(containerSession, true, false, true);
      }
    }
    this.landscapeStartFlag = false;
    this.landscapeStartBundleName = '';
    this.landscapeStartDesktopRotation = this.landScapeStartNotSync ? this.landscapeStartDesktopRotation :
          screenSession.scbScreenProperty.rotation;
  }

  // landscape start interrupt by exit scene
  public isLandscapeStartInterrupt(): boolean {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      log.showInfo('[isLandscapeStartInterrupt] screenSession is null.');
      return false;
    }
    return (screenSession.isRotateScreenPolicy() || this.isFullScreenRotatePolicy()) && this.landScapeStartNotSync;
  }

  // scene landscape start but not sync
  public isLandscapeStartNotSync(): boolean {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      log.showInfo('[isLandscapeStartNotSync] screenSession is null.');
      return false;
    }
    return (screenSession.isRotateScreenPolicy() || this.isFullScreenRotatePolicy()) && this.landscapeStartFlag && this.landScapeStartNotSync;
  }

  public notifyRotationChange(screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason,
    isRestrictNotify: boolean = false): Array<sceneSessionManager.RotationChangeResult> | void {
    let rotationChangeType: sceneSessionManager.RotationChangeType = this.CalculateRotationChangeType(reason);
    let orientation: number = ROTATION_TO_ORIENTATION.get(screenProperty.rotation) ?? 0;

    if (orientation === undefined) {
      log.showInfo('[notifyRotationChange] rotation is undefined');
      return undefined;
    }
    log.showInfo(`[notifyRotationChange] begin, type:${rotationChangeType},` + `orientation ${orientation}`);
    let rotationChangeInfo: sceneSessionManager.RotationChangeInfo = {
      type: rotationChangeType,
      orientation: orientation,
      displayId: screenProperty.screenId,
      displayRect: {
        posX_: 0,
        posY_: 0,
        width_: screenProperty.width,
        height_: screenProperty.height
      },
    };
    return SCBSceneSessionManager.getInstance().notifyRotationChange(rotationChangeInfo, isRestrictNotify);
  }

  private CalculateRotationChangeType(reason: SCBRotateChangeReason) : sceneSessionManager.RotationChangeType {
    if (reason === SCBRotateChangeReason.ROTATE_BEGIN) {
      return sceneSessionManager.RotationChangeType.WINDOW_WILL_ROTATE;
    }
    return sceneSessionManager.RotationChangeType.WINDOW_DID_ROTATE;
  }

  public updateRotationWindow(rotationWindow: Array<sceneSessionManager.RotationChangeResult> | void): void {
    if (rotationWindow === null || rotationWindow === undefined || typeof rotationWindow !== 'object' ||
        !Array.isArray(rotationWindow)) {
      log.showInfo(`[updateRotationWindow] rotationWindow is null.`);
      return;
    }
    log.showInfo(`[updateRotationWindow] size: ${rotationWindow.length}`);
    for (let i = 0; i < rotationWindow.length; i++) {
      let rotationResult = rotationWindow[i];
      let session: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null =
        SCBSceneSessionManager.getInstance().getSessionById(rotationResult.persistentId);
      if (session === null) {
        log.showInfo(`[updateRotationWindow] session null`);
        return;
      }
      if (SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PC ||
        (session instanceof SCBSceneSession && session.isPcAppInPad)) {
        log.showInfo(`[updateRotationWindow] not support pc`);
        return;
      }
      log.showInfo(`[updateRotationWindow], rectType:${rotationResult.rectType}, ` +
                   `persistentId:${rotationResult.persistentId}, width:${rotationResult.windowRect.width_}, ` +
                   `height:${rotationResult.windowRect.height_}`);
      if (rotationResult.windowRect.width_ === 0 || rotationResult.windowRect.height_ === 0) {
        return;
      }
      if (rotationResult.rectType === sceneSessionManager.RectType.RELATIVE_TO_PARENT_WINDOW &&
          session instanceof SCBSpecificSession) {
        let parentSession = session.getParentSession();
        rotationResult.windowRect.posX_ += parentSession?.currRect.left.getPx() ?? 0;
        rotationResult.windowRect.posY_ += parentSession?.currRect.top.getPx() ?? 0;
      }
      session.currRect.setRectNum(rotationResult.windowRect.posX_, rotationResult.windowRect.posY_,
        rotationResult.windowRect.width_, rotationResult.windowRect.height_);
    }
  }
}