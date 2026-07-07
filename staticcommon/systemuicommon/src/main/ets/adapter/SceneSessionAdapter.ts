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
import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import lazy { SCBWindowSceneConfig, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import lazy {
  FocusChangeReason,
  SCBSceneSessionManager,
  SCBSceneContainerSessionArray,
  SCBSystemBarProperty,
  SCBSystemSceneSession,
  ResUtils
} from '@ohos/windowscene';
import { threadCall, ThreadCallCommRegisterIntf, ThreadCallType } from '../messageChannel/ThreadCall';
import lazy sceneSessionManager from '@ohos.sceneSessionManager';
import lazy BundleManager from '@ohos.bundle.bundleManager';
import { ArkUIAdapter } from '../utils/ArkUIAdapter';
import { curves } from '@kit.ArkUI';
import lazy { ExclusiveChecker } from '@ohos/windowscene/src/main/ets/scene/manager/ExclusiveChecker';

import { DEFAULT_BG_COLOR } from '../statusbar/enum/StatusbarConstants';
import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';

const TAG = 'SceneSessionAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface RegisterTouchOutsideCallback {
  callback: (x: number, y: number) => void;
}

interface SystemBarPropertyCallbacksIntf extends ThreadCallCommRegisterIntf {
  screenId: number;
}

interface ContextTransparentCallbackIntf extends ThreadCallCommRegisterIntf {
  persistentId: number;
}

export enum ScenePanelState {
  HOME,
  FULLSCENE,
  SPLIT,
  FLOAT_SCENE,
  RECENT,
  QUICK_SWITCH
}

export class SceneSessionAdapter {
  /**
   * 全局触摸事件session，替代banner面板外部触摸事件
   * 组件根据自身区域判断触摸事件是否在外部
   */
  private static touchOutsideSession?: SCBSystemSceneSession;

  private static onHidingAnimation: boolean = false;
  static systemBarPropertyCallbackFunction: Function;

  @threadCall()
  public static isScreenLocked(): boolean | Promise<boolean> {
    log.showInfo(`isScreenLocked`)
    return SCBSceneSessionManager.getInstance().isScreenLocked();
  }

  @threadCall()
  public static requestFocus(persistentId: number, byForeground: boolean = true,
    reason: FocusChangeReason = FocusChangeReason.DEFAULT): void {
    log.showInfo(`requestFocus persistentId ${persistentId} byForeground ${byForeground} reason ${reason}`)
    return SCBSceneSessionManager.getInstance().requestFocus(persistentId, byForeground, reason);
  }

  @threadCall()
  public static requestUnfocus(persistentId: number,
    reason: FocusChangeReason = FocusChangeReason.DEFAULT): void {
    log.showInfo(`requestUnfocus persistentId ${persistentId} reason ${reason}`)
    return SCBSceneSessionManager.getInstance().requestUnfocus(persistentId, reason);
  }

  @threadCall()
  public static requestSystemSceneSessionDestruction(systemSceneSession: SCBSystemSceneSession,
    screenId?: number): void {
    log.showInfo(`requestSystemSceneSessionDestruction systemSceneSession ${systemSceneSession} screenId ${screenId}`)
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(systemSceneSession, screenId);
  }

  @threadCall()
  public static getDesktopDefaultSystemBarProperty(): SCBSystemBarProperty | Promise<SCBSystemBarProperty> {
    log.showInfo(`getDesktopDefaultSystemBarProperty`)
    return SCBSceneSessionManager.getInstance().getDesktopDefaultSystemBarProperty();
  }

  @threadCall()
  public static getLockDefaultSystemBarProperty(): SCBSystemBarProperty | Promise<SCBSystemBarProperty> {
    log.showInfo(`SCBSystemBarProperty`)
    return SCBSceneSessionManager.getInstance().getLockDefaultSystemBarProperty();
  }

  @threadCall()
  public static updateDesktopDefaultSystemBarContentColor(contentColor: string) {
    const desktopDefaultSystemBarProperty: SCBSystemBarProperty =
      SCBSceneSessionManager.getInstance().getDesktopDefaultSystemBarProperty();
    if (desktopDefaultSystemBarProperty) {
      SCBSceneSessionManager.getInstance().setDesktopDefaultSystemBarProperty(
        new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR,
          desktopDefaultSystemBarProperty.enable, desktopDefaultSystemBarProperty.backgroundcolor,
          contentColor, true, desktopDefaultSystemBarProperty.enableLinearGradient));
    } else {
      SCBSceneSessionManager.getInstance().setDesktopDefaultSystemBarProperty(
        new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR, true,
          DEFAULT_BG_COLOR, contentColor, true, true));
    }

    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
  }

  @threadCall()
  public static updateLockDefaultSystemBarContentColor(contentColor: string) {
    const lockDefaultSystemBarProperty: SCBSystemBarProperty =
      SCBSceneSessionManager.getInstance().getLockDefaultSystemBarProperty();
    if (lockDefaultSystemBarProperty) {
      SCBSceneSessionManager.getInstance().setLockDefaultSystemBarProperty(
        new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR,
          lockDefaultSystemBarProperty.enable, lockDefaultSystemBarProperty.backgroundcolor,
          contentColor, true, lockDefaultSystemBarProperty.enableLinearGradient));
    } else {
      SCBSceneSessionManager.getInstance().setLockDefaultSystemBarProperty(
        new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR, true,
          DEFAULT_BG_COLOR, contentColor, true, true));
    }
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
  }

  @threadCall()
  public static async updateSystemBarProperty(): Promise<void> {
    log.showInfo(`updateSystemBarProperty`)
    await SCBSceneSessionManager.getInstance().updateStatusbarColor();
    return SCBSceneSessionManager.getInstance().updateSystemBarProperty();
  }

  @threadCall()
  public static clearAppOverrideSystemBarProperty(screenId: number, callModule: string): void {
    SCBSceneSessionManager.getInstance().clearAppOverrideSystemBarProperty(screenId, callModule);
  }

  @threadCall()
  public static setAppOverrideSystemBarProperty(prop: SCBSystemBarProperty, screenId: number,
    callModule: string): void {
    const parsedData = new SCBSystemBarProperty();
    SystemUICommonUtil.assign(parsedData as Object as Record<string, Object>, prop as Object as Record<string, Object>);
    SCBSceneSessionManager.getInstance().setAppOverrideSystemBarProperty(
      parsedData, screenId, callModule);
  }

  @threadCall()
  public static setDesktopDefaultSystemBarProperty(prop: SCBSystemBarProperty): void {
    log.showInfo(`setDesktopDefaultSystemBarProperty ${JSON.stringify(prop)}`);
    const parsedData = new SCBSystemBarProperty();
    SystemUICommonUtil.assign(parsedData as Object as Record<string, Object>, prop as Object as Record<string, Object>);
    return SCBSceneSessionManager.getInstance().setDesktopDefaultSystemBarProperty(parsedData);
  }

  @threadCall()
  public static setLockDefaultSystemBarProperty(prop: SCBSystemBarProperty): void {
    log.showInfo(`setLockDefaultSystemBarProperty systemBarProperty ${JSON.stringify(prop)}`);
    const parsedData = new SCBSystemBarProperty();
    SystemUICommonUtil.assign(parsedData as Object as Record<string, Object>, prop as Object as Record<string, Object>);
    SCBSceneSessionManager.getInstance().setLockDefaultSystemBarProperty(parsedData);
  }

  @threadCall()
  public static isPcMode(): boolean | Promise<boolean> {
    return SCBSceneSessionManager.getInstance().isPcMode();
  }

  @threadCall(ThreadCallType.Sync)
  public static isSupportPcMode(): boolean {
    return SCBSceneSessionManager.getInstance().isSupportPcMode();
  }

  @threadCall(ThreadCallType.Sync)
  public static isSplitScreenMode() {
    let sessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance()?.getAllContainerSessionList();
    if (sessionList === undefined || sessionList === null || sessionList.isEmpty()) {
      log.showWarn(`sessionList is null, need to start OverlayAnimate`);
      return true;
    }
    let isSplit: boolean | undefined = sessionList.getTopActiveSession()?.isSplit;
    let isMidScene: boolean | undefined = sessionList.getTopActiveSession()?.isMidScene;
    log.showInfo(`needStartOverlayAnimate isSplit=${isSplit} isMidScene=${isMidScene}`);
    if ((isSplit !== undefined && isSplit) || (isMidScene !== undefined && isMidScene)) {
      log.showWarn(`isSplit=${isSplit} isMidScene=${isMidScene}, no need to start OverlayAnimate`);
      return false;
    }
    return true;
  }

  @threadCall()
  public static getUiType(): string | Promise<string> {
    return SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
  }

  @threadCall()
  public static setIsShowStatusBarTemporary(isShowStatusBarTemporary: boolean): void {
    SCBSceneSessionManager.getInstance().setIsShowStatusBarTemporary(isShowStatusBarTemporary);
  }

  @threadCall()
  public static setStatusBarAvoidHeight(screenId: number, height: number): void {
    sceneSessionManager.setStatusBarAvoidHeight(screenId, height);
  }

  @threadCall()
  public static notifyNextAvoidRectInfo(type: sceneSessionManager.SessionType, screenId: number, portraitRect: RectInfo,
    landspaceRect: RectInfo): void {
    sceneSessionManager.notifyNextAvoidRectInfo(type, screenId, portraitRect, landspaceRect);
  }

  @threadCall(ThreadCallType.Register)
  public static registerSystemBarPropertyCallbacks(obj: SystemBarPropertyCallbacksIntf, tag: string): void {
    log.showInfo(`registerSystemBarPropertyCallbacks tag ${tag}`)
    SCBSceneSessionManager.getInstance()
      .registerSystemBarPropertyCallbacks(obj.callback, obj.screenId);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterSystemBarPropertyCallbacks(obj: SystemBarPropertyCallbacksIntf, tag: string): void {
    log.showInfo(`unRegisterSystemBarPropertyCallbacks tag ${tag}`)
    return SCBSceneSessionManager.getInstance()
      .unRegisterSystemBarPropertyCallbacks(obj.callback, obj.screenId);
  }

  @threadCall(ThreadCallType.Register)
  public static statusBarRegisterSystemBarPropertyCallbacks(obj: SystemBarPropertyCallbacksIntf, tag: string): void {
    log.showInfo(`statusBarRegisterSystemBarPropertyCallbacks tag ${tag}`)
    this.systemBarPropertyCallbackFunction = (property: SCBSystemBarProperty) => {
      const isExitRecentTask = SCBSceneSessionManager.getInstance().isInRecentOutProcess;
      obj.callback(property, isExitRecentTask);
    }
    SCBSceneSessionManager.getInstance()
      .registerSystemBarPropertyCallbacks(this.systemBarPropertyCallbackFunction, obj.screenId);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static statusBarUnRegisterSystemBarPropertyCallbacks(obj: SystemBarPropertyCallbacksIntf, tag: string): void {
    log.showInfo(`statusBarUnRegisterSystemBarPropertyCallbacks tag ${tag}`)
    return SCBSceneSessionManager.getInstance()
      .unRegisterSystemBarPropertyCallbacks(this.systemBarPropertyCallbackFunction, obj.screenId);
  }

  public systemBarPropertyCallbackFunction = (property: SCBSystemBarProperty) => {}

  @threadCall()
  public static getAppDefaultSystemBarProperty(): SCBSystemBarProperty | Promise<SCBSystemBarProperty> {
    return SCBSceneSessionManager.getInstance().getAppDefaultSystemBarProperty();
  }

  @threadCall()
  public static setAppDefaultSystemBarProperty(prop: SCBSystemBarProperty): void {
    log.showInfo(`setAppDefaultSystemBarProperty systemBarProperty ${JSON.stringify(prop)}`);
    const parsedData = new SCBSystemBarProperty();
    SystemUICommonUtil.assign(parsedData as Object as Record<string, Object>, prop as Object as Record<string, Object>);
    return SCBSceneSessionManager.getInstance().setAppDefaultSystemBarProperty(parsedData);
  }

  @threadCall(ThreadCallType.Register)
  public static registerOnNtfFloatingWindowCallback(obj: ThreadCallCommRegisterIntf, tag: string): void {
    log.showInfo(`registerOnNtfFloatingWindowCallback tag ${tag}`)
    return SCBSceneSessionManager.getInstance().registerOnNtfFloatingWindowCallback(obj.callback);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterOnNtfFloatingWindowCallback(obj: ThreadCallCommRegisterIntf, tag: string): void {
    log.showInfo(`unRegisterOnNtfFloatingWindowCallback tag ${tag}`)
    return SCBSceneSessionManager.getInstance().unregisterOnNtfFloatingWindowCallback(obj.callback);
  }

  @threadCall(ThreadCallType.Register)
  public static registerOnGetFloatingRectCallback(obj: ThreadCallCommRegisterIntf, tag: string): void {
    log.showInfo(`registerOnGetFloatingRectCallback tag ${tag}`)
    return SCBSceneSessionManager.getInstance().registerOnGetFloatingRectCallback(obj.callback);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterOnGetFloatingRectCallback(obj: ThreadCallCommRegisterIntf, tag: string): void {
    log.showInfo(`unregisterOnGetFloatingRectCallback tag ${tag}`)
    return SCBSceneSessionManager.getInstance().unregisterOnGetFloatingRectCallback(obj.callback);
  }

  @threadCall(ThreadCallType.Register)
  public static registerContextTransparentCallback(obj: ContextTransparentCallbackIntf, tag: string): void {
    log.showInfo(`registerContextTransparentCallback tag ${tag}`)
    return SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(obj.persistentId)?.registerContextTransparentCallback(obj.callback);
  }

  @threadCall()
  public static setFocusable(persistentId: number, isFocusable: boolean): void {
    log.showInfo(`setFocusable ${persistentId} ${isFocusable}`)
    SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(persistentId)?.setFocusable(isFocusable);
  }

  @threadCall()
  public static getIsMidScene(screenId?: number): boolean | Promise<boolean> {
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList(screenId);
    let curSession = containerSessionList.getTopActiveSession();
    return !!curSession?.isMidScene;
  }

  @threadCall()
  public static notifyAnimationFinishedCallback(visible: boolean) {
    log.showInfo(`notifyAnimationFinishedCallback tag`)
    SCBSceneSessionManager.getInstance().notifyAnimationFinishedCallback(visible);
  }

  @threadCall()
  public static setSystemSceneOcclusionAlpha(persistentId: number, alpha: number) {
    log.showInfo(`setSystemSceneOcclusionAlpha persistentId ${persistentId} alpha ${alpha}`)

    SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(persistentId).setSystemSceneOcclusionAlpha(alpha);
  }

  @threadCall()
  public static setWaterMarkFlag(persistentId: number, isWaterMarkAdded: boolean) {
    log.showInfo(`setSystemSceneOcclusionAlpha persistentId ${persistentId} isWaterMarkAdded ${isWaterMarkAdded}`)
    SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(persistentId).setWaterMarkFlag(isWaterMarkAdded);
  }

  @threadCall()
  public static setSkipEventAndShowOnVirtualScreen(persistentId: number, isSkip: boolean) {
    log.showInfo(`setSkipEventAndShowOnVirtualScreen persistentId ${persistentId} isSkip ${isSkip}`)
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(persistentId)?.setSkipEventAndShowOnVirtualScreen(isSkip);
  }

  @threadCall()
  public static getMinimizedBundleIndex(paramBundleName: string): number | Promise<number> {
    return SCBSceneSessionManager.getInstance().getFloatingSessionList().findIndex((floatingSession) =>
    floatingSession?.mainSession.sceneInfo.bundleName === paramBundleName &&
    floatingSession?.floatingParam.isMinimized);
  }

  @threadCall()
  public static getAbilityWindowSupportInfo(queryKey: string, bundleName?: string,
    abilityName?: string): Array<BundleManager.SupportWindowMode> | Promise<Array<BundleManager.SupportWindowMode>> {
    return SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo(queryKey, bundleName, abilityName);
  }

  @threadCall()
  public static checkIsExclusive(bundleName: string, mode: string, isToast: boolean): boolean | Promise<boolean> {
    const exclusive = ExclusiveChecker.check(bundleName, mode, isToast);
    return exclusive.result;
  }

  @threadCall(ThreadCallType.Register)
  public static registerTouchOutsideCallback(obj: RegisterTouchOutsideCallback, tag: string): void {
    // 注册窗口touchOut事件
    if (!SceneSessionAdapter.touchOutsideSession) {
      SceneSessionAdapter.touchOutsideSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession({
        systemType: sceneSessionManager.SessionType.TYPE_PANEL,
        sceneName: TAG,
        sceneZIndex: 0,
        hitTestMode: HitTestMode.Default,
      });
    }
    SceneSessionAdapter.touchOutsideSession.registerTouchOutsideCallback(obj.callback);
  }

  public static unregisterTouchOutsideCallback(): void {
    // 注销窗口touchOut事件
    if (SceneSessionAdapter.touchOutsideSession) {
      SceneSessionAdapter.requestSystemSceneSessionDestruction(SceneSessionAdapter.touchOutsideSession);
    }
  }

  @threadCall(ThreadCallType.Register)
  public static registerFullScreenTitleBarAppearCallback(obj: ThreadCallCommRegisterIntf, tag: string): void {
    SCBSceneSessionManager.getInstance().registerFullScreenTitleBarAppearCallback(obj.callback);
  }

  @threadCall(ThreadCallType.Register)
  public static registerHotRegionStateChangeCallback(obj: ThreadCallCommRegisterIntf, tag: string): void {
    SCBSceneSessionManager.getInstance().registerHotRegionStateChangeCallback(obj.callback);
  }

  @threadCall(ThreadCallType.Register)
  public static registerFullScreenMenuVisibleCallback(obj: ThreadCallCommRegisterIntf, tag: string) {
    SCBSceneSessionManager.getInstance().registerFullScreenMenuVisibleCallback(obj.callback);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterFullScreenMenuVisibleCallback(obj: ThreadCallCommRegisterIntf, tag: string): void {
    log.showInfo(`unRegisterFullScreenMenuVisibleCallback tag ${tag}`)
    return SCBSceneSessionManager.getInstance()
      .unregisterFullScreenMenuVisibleCallback(obj.callback);
  }

  @threadCall()
  public static resetLastStatusBarProperty(screenId?: number) {
    SCBSceneSessionManager.getInstance().resetLastStatusBarProperty();
  }

  @threadCall()
  public static playHidenAnimation(): void {
    SceneSessionAdapter.onHidingAnimation = true;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR);
    if (!statusBar) {
      log.showError('Failed to get systemSceneSession of the statusBar');
      return;
    }
    log.showInfo('statusbar playHidenAnimation is called.');
    ArkUIAdapter.uiContext?.animateTo({
      duration: 400,
      curve: curves.cubicBezierCurve(0.0, 0.0, 0.20, 1.0),
      onFinish: () => {
        if (SceneSessionAdapter.onHidingAnimation) {
          viewMgrPolicy.hideView(ViewType.STATUS_BAR);
          SceneSessionAdapter.onHidingAnimation = false;
          SceneSessionAdapter.resetLastStatusBarProperty();
          statusBar?.setTranslate(0, 0, 0);
        }
      }
    }, () => {
      let statusBarHeight: number = ArkUIAdapter.vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')));
      statusBar?.setTranslate(0, -statusBarHeight, 0);
    })
  }
}