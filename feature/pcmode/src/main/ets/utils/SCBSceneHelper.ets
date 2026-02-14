/**
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
import {
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBSceneOrientation,
  SCBSceneSessionManager,
  SCBSpecificSession,
  SCBSessionRect,
  SCBScreenProperty,
  ScbNumber,
  SCBSceneSession,
  SCBSpecificSceneSessionList
} from '@ohos/windowscene';
import { display } from '@kit.ArkUI';
import { SCBConstants } from '@ohos/commonconstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { MINI_VALUE } from '../constants/BaseConstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { systemParameterEnhance } from '@kit.BasicServicesKit';


const TAG = 'SCBSceneHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class SCBSceneHelper {
  private static readonly DEFAULT_ENABLE_ANIMATION: string = 'true';
  public static setSceneTranslate(scene: SCBSceneContainerSession | SCBSpecificSession | undefined,
    translateX: number, translateY: number): boolean {
    if (!scene) {
      return false;
    }
    log.showInfo(`SetSceneTranslate setTranX: ${translateX},setTranY: ${translateY}, extra info: ${scene.getName()}`);
    if (scene instanceof SCBSpecificSession) {
      scene.translateX = translateX;
      scene.translateY = translateY;
      return true;
    }
    if (scene instanceof SCBSceneContainerSession) {
      scene.primarySession?.setTran(translateX, translateY);
      scene.secondarySession?.setTran(translateX, translateY);
      scene.dividerParam.dividerTranslateX = translateX;
      scene.dividerParam.dividerTranslateY = translateY;
      return true;
    }
    return false;
  }

  /**
   * traverse all SubScene List.
   * @param subList
   * @param dialogSceneList
   */
  public static traverseSubList(subList: SCBSpecificSceneSessionList, dialogSceneList: SCBSpecificSession[]) {
    for (let i = 0; i < subList.length; i++) {
      let subItem = subList[i];
      if (subItem !== null) {
        dialogSceneList.push(subItem);
        let subsubSessionList = subItem.subSessionList;
        if (subsubSessionList !== null) {
          SCBSceneHelper.traverseSubList(subsubSessionList, dialogSceneList);
        }
      }
    }
  }

  /**
   * 查找containerSession的dialogSessionList和subSessionList，返回查询的结果数组
   *
   * @param { SCBSceneContainerSession } containerSession
   * @returns { SCBSpecificSession[] } list of containerSession's specificSession
   */
  public static querySubSessionOfMain(container: SCBSceneContainerSession): SCBSpecificSession[] {
    if (!container) {
      return [];
    }
    let dialogSceneList: SCBSpecificSession[] = [];
    if (container.primarySession !== null) {
      dialogSceneList.push(...container.primarySession.dialogSessionList);
      if (container.primarySession.subSessionList !== null) {
        SCBSceneHelper.traverseSubList(container.primarySession.subSessionList, dialogSceneList);
      }
    }
    if (container.isSplit && container.secondarySession !== null) {
      dialogSceneList.push(...container.secondarySession.dialogSessionList);
      if (container.secondarySession.subSessionList !== null) {
        SCBSceneHelper.traverseSubList(container.secondarySession.subSessionList, dialogSceneList);
      }
    }
    return dialogSceneList;
  }

  /**
   * 重新init container state，同步重置子窗口的缩放位移透明度
   *
   * @param { SCBSceneContainerSession } containerSession
   */
  public static resetAnimateParam(container: SCBSceneContainerSession): void {
    if (!container) {
      return;
    }
    container.primarySession?.initSceneState();
    container.secondarySession?.initSceneState();
    container.dividerParam.dividerTranslateX = 0;
    container.dividerParam.dividerTranslateY = 0;
    container.dividerParam.scaleX = 1;
    container.dividerParam.scaleY = 1;
    if (container.dividerParam.dividerOpacity !== 1) {
      container.dividerParam.dividerOpacity = 1;
    }
    // 需要让因为清屏动效退后台后没下树的窗口下树
    let dialogSceneList: SCBSpecificSession[] = SCBSceneHelper.querySubSessionOfMain(container);
    if (dialogSceneList.length <= 0) {
      return;
    }
    for (const dialogScene of dialogSceneList) {
      SCBSceneHelper.setSceneTranslate(dialogScene, 0, 0);
      SCBSceneHelper.setSceneScale(dialogScene, 1);
      SCBSceneHelper.setSceneOpacity(dialogScene, 1);
    }
    return;
  }

  public static setSceneScale(scene: SCBSceneContainerSession | SCBSpecificSession | undefined,
    scale: number): boolean {
    if (!scene) {
      return false;
    }
    if (scene instanceof SCBSpecificSession) {
      scene.scaleX = scale;
      scene.scaleY = scale;
      return true;
    }
    if (scene instanceof SCBSceneContainerSession) {
      scene.primarySession?.setScale(scale, scale);
      scene.secondarySession?.setScale(scale, scale);
      scene.dividerParam.scaleX = scale;
      scene.dividerParam.scaleY = scale;
      return true;
    }
    return false;
  }

  public static setSceneOpacity(scene: SCBSceneContainerSession | SCBSpecificSession | undefined, opacity: number) {
    if (!scene) {
      return;
    }
    if (scene instanceof SCBSpecificSession) {
      scene.opacity = opacity;
      return;
    }
    if (scene.primarySession && scene.primarySession.opacity !== opacity) {
      scene.primarySession.opacity = opacity;
    }
    if (scene.isSplit && scene.secondarySession) {
      if (scene.secondarySession.opacity !== opacity) {
        scene.secondarySession.opacity = opacity;
      }
      if (scene.dividerParam.dividerOpacity !== opacity && !scene.isSplitStyleConversion) {
        scene.dividerParam.dividerOpacity = opacity;
      }
    }
  }

  /**
   * if rect.height or rect.width of subSession is 0 in clear scene, use screenHeight and screenWidth
   *
   * @param { SCBSpecificSession } subSession
   * @param { SCBScreenProperty } screenProperty
   * @returns { SCBSessionRect } rect of subSession
   */
  public static preHandleSubSessionRectClearScene(scene: SCBSpecificSession,
    screenProperty: SCBScreenProperty): SCBSessionRect {
    let finalRect = scene.getRect();
    if (finalRect.height.getVp() !== 0 && finalRect.width.getVp() !== 0) {
      return finalRect;
    } else {
      log.showInfo(`scene: ${scene.getName()}, need set rect before clear scene.`);
      finalRect.height = new ScbNumber(screenProperty.height);
      finalRect.width = new ScbNumber(screenProperty.width);
      return finalRect;
    }
  }

  public static resetWindowPosAndScale(scene: SCBSceneSession): void {
    if (!scene) {
      log.showError(`resetWindowPosAndScale sceneSession is null`);
      return;
    }
    log.showInfo(`resetWindowPosAndScale, sceneName: ${scene.getName()}`);
    scene.updateFloatingScale(1.0);
    scene.setWindowOffset(0, 0);
  }

  public static getDpi(screenId?: number): number {
    let displayId = screenId !== undefined ? screenId : SCBSceneSessionManager.getInstance().mainScreenId;
    try {
      let defaultDisplay: display.Display = display.getDisplayByIdSync(displayId);
      return defaultDisplay.densityDPI;
    } catch (err) {
      log.showError(`get dpi error: ${err?.message}`);
      return SCBConstants.DEFAULT_DOTS_PER_INCH;
    }
  }

  public static nearEqual(a: number, b: number): boolean {
    // 0.000001: min error
    return Math.abs(a - b) < MINI_VALUE;
  }

  public static setSplitGravity(containerSession: SCBSceneContainerSession): void {
    if (containerSession.dividerParam.isSplitPrimaryMode) {
      containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
      containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
    } else {
      containerSession.primarySession?.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
      containerSession.secondarySession?.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
    }
  }

  /**
   * whether the device version is 2D version
   *
   * @return true 2D version
   */
  public static is2D(): boolean {
    if (DeviceHelper.isPC() && DeviceHelper.isEmulator()) {
      return true;
    }
    if (!SCBSceneHelper.isEnableDesktopFeatureAnimation()) {
      return true;
    }
    return false;
  }

  /**
   * check whether the session is only support portrait orientation or not
   *
   * @param scene
   * @returns true if the scene declare a portrait orientation
   */
  public static isOnlyPortrait(scene: SCBSceneSession): boolean {
    if (!scene) {
      log.showWarn(`isOnlyPortrait,null scene session`);
      return false;
    }
    const sceneInfo = scene.sceneInfo;
    const orientation = SCBSceneSessionManager.getInstance().getAbilityOrientation(
      sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
    if (orientation === SCBSceneOrientation.VERTICAL ||
      orientation === SCBSceneOrientation.REVERSE_VERTICAL ||
      orientation === SCBSceneOrientation.SENSOR_VERTICAL ||
      orientation === SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED) {
      return true;
    }
    return false;
  }

  /**
   * force update window mode
   *
   * @param {SCBSceneSession} scene
   * @param {SCBScreenProperty} screenProperty
   * @returns {void}
   */
  public static forceUpdateWindowMode(scene: SCBSceneSession, windowMode: SCBSceneMode): void {
    if (!scene || !scene.sceneInfo) {
      log.showWarn('invalid scene or sceneInfo');
      return;
    }
    log.showInfo(`force update window mode from: ${scene.sceneInfo.windowMode} to: ${windowMode}`);
    if (scene.sceneInfo.windowMode !== windowMode) {
      scene.sceneInfo.updateWindowModeAndSync(windowMode);
    } else {
      try {
        sceneSessionManager.updateWindowMode(scene.sceneInfo.persistentId, windowMode);
      } catch (e) {
        log.showWarn(`force update window mode error, err: ${e?.message}`);
      }
    }
  }

  public static updateSceneSafeRect(scene: SCBSceneSession): void {
    if (!scene) {
      log.showWarn('updateSceneSafeRect, invalid scene');
      return;
    }
    log.showInfo(`updateSceneSafeRect, lastRect: ${SCBSceneHelper.getRectLogInfo(scene.lastRect)} `);
    scene.setWindowLastSafeRect(scene.lastRect.left.getPx(), scene.lastRect.top.getPx(), scene.lastRect.width.getPx(),
      scene.lastRect.height.getPx());
    scene.setGravity(sceneSessionManager.Gravity.RESIZE);
  }

  public static getRectLogInfo(rect: SCBSessionRect): string {
    if (!rect) {
      return 'invalid rect';
    }
    return `[${rect.left.getPx()}, ${rect.top.getPx()}, ${rect.width.getPx()}, ${rect.height.getPx()}]`;
  }

  private static isEnableDesktopFeatureAnimation(): boolean {
    try {
      return systemParameterEnhance.getSync('const.pcsceneboard.enable_desktop_feature_animation',
        SCBSceneHelper.DEFAULT_ENABLE_ANIMATION) === SCBSceneHelper.DEFAULT_ENABLE_ANIMATION;
    } catch (e) {
      log.showError('Get enable desktop feature animation state failed');
      return true;
    }
  }

  /**
   * update the rect of scene session when it has been controlled
   *
   * @param {SCBSceneSession} sceneSession
   * @param {SCBScreenProperty} screenProperty
   * @param {number} statusBarHeight
   * @param {number} dockHeight
   * @returns {boolean}
   */
  public static updateRectAfterMainWindowControl(sceneSession: SCBSceneSession, screenProperty: SCBScreenProperty,
    statusBarHeight: number, dockHeight: number): void {
    let targetRect = sceneSession.currRect.copy();
    targetRect.setSizeNum(Math.min(screenProperty.width, targetRect.width.getPx()),
      Math.min(screenProperty.height - dockHeight - statusBarHeight, targetRect.height.getPx()));
    targetRect.setPosNum((screenProperty.width - targetRect.width.getPx()) / 2,
      (screenProperty.height - targetRect.height.getPx()) / 2);
    sceneSession.currRect.copyFrom(targetRect);
  }

  /**
   * check whether the rect is over the screen
   *
   * @param {SCBSceneSession} sceneSession
   * @param {SCBScreenProperty} screenProperty
   * @returns {boolean}
   */
  public static isOverScreen(sceneSession: SCBSceneSession, screenProperty: SCBScreenProperty): boolean {
    let targetRect = sceneSession.currRect.copy();
    if (targetRect.top.getPx() < 0 || targetRect.left.getPx() < 0 ||
      targetRect.left.getPx() + targetRect.width.getPx() > screenProperty.width ||
      targetRect.top.getPx() +targetRect.height.getPx() > screenProperty.height) {
      return true;
    }
    return false
  }

  /**
   * update last dpi
   *
   * @param {scene} sceneSession
   * @param {dpi} dpi
   * @returns {void}
   */
  public static updateLastDpi(scene: SCBSceneSession, dpi: number): void {
    if (!scene) {
      log.showWarn('updateLastDpi, invalid scene');
      return;
    }
    log.showInfo(`updateLastDpi from ${scene.sessionData.lastDpi} to ${dpi}`);
    if (scene.sessionData.lastDpi !== dpi) {
      scene.sessionData.lastDpi = dpi;
    }
  }
}