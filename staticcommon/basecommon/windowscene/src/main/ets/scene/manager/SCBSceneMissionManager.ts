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
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { SCBAppUseControlManager } from '../appUseControl/SCBAppUseControlManager';
import { SCBSceneMissionProcessor } from '../framework/missions/SCBSceneMissionProcessor';
import { SCBSceneContainerSession } from '../session/SCBSceneContainerSession';
import type { SCBScenePersistent } from '../session/SCBScenePersistent';
import { SCBSceneInfo, SCBSceneMode } from '../session/SCBSceneInfo';
import { SCBSceneSessionManager } from '../session/SCBSceneSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { MissionManagementTraceUtil } from '../utils/SCBSceneUtils';
import { SCBSceneRecentMissionManager } from './SCBSceneRecentMissionManager';
import {
  SCBScreenSessionArray,
  SCBScreenSessionManager,
  SCBSceneSession,
  SCBSpecificSession,
  INVALID_SCREEN_ID,
} from '../../TsIndex';
import { DEFAULT_TOTAL_LIST_TAG, SCBScenePanelMissionHandler } from '../framework/missions/SCBScenePanelMissionHandler';
import { SCBScreenMissionHandler } from '../framework/missions/SCBScreenMissionHandler';
import {
  MainSessionDestructionOpts,
  SCBMainSessionTuple,
  SCBTerminateSceneOpts,
  SCBTransferSceneOpts,
  SCBTransitionSceneOpts,
  SCBStartSceneOpts,
  SCBMinimizeSceneOpts
} from '../framework/missions/SCBSceneMissionTypes';
import { DeviceHelper, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBKioskModeManager } from '../kiosk/SCBKioskModeManager';
import { CommonResult, CommonResultCode } from '../../scene/utils/SCBSceneUtils';
import { INVALID_PERSISTENT_ID } from '../session/SCBSceneSession';
import { bundleManager } from '@kit.AbilityKit';

const TAG = '[SCBMission]SCBSceneMissionManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export const MINIMIZE_ABILITY_BEFORE_POP = 'ohos.sceneMissionMgmt.needMinimizeFirst';
//  background scene when push in after transfer
export const BACKGROUND_SCENE_WHEN_TRANSFER = 'ohos.sceneMissionMgmt.needBackground';

/**
 * scene mission management init type.
 * @description diff components in scb init or deinit.
 */
export enum SceneMissionMgmtStage {
  ON_SCB_INIT = 0,
  ON_SCREEN_INIT,
  ON_SCENE_PANEL_HANDLER_CREATE,
  ON_SCENE_PANEL_INIT,
  ON_SCENE_PANEL_RELEASE,
  ON_SCREEN_RELEASE,
  ON_SCB_RELEASE // generally will not happen
}

export interface InnerScreenStateChangeListener {
  notifyScreenStateChange(screenId: number, connected: boolean): void;
}

/**
 * Global Scene Mission Management.
 * @description start/minimize/maximize/terminate scene mission
 */
export class SCBSceneMissionManager {
  private static sInstance: SCBSceneMissionManager;
  private recentMissionMgr: SCBSceneRecentMissionManager = new SCBSceneRecentMissionManager();
  private globalSceneSessionCache: Map<number, SCBSceneSession> = new Map();
  private screenHandlers: Map<number, SCBScreenMissionHandler> = new Map();
  private productMissionProcessor: Set<SCBSceneMissionProcessor> | null = new Set();
  private scenePersistent: SCBScenePersistent = SCBSceneSessionManager.getInstance().getScenePersistent();
  private deferredStartingCache: Set<SCBSceneInfo> = new Set();
  private innerScreenStateListeners: Set<InnerScreenStateChangeListener> = new Set();

  public static getInstance(): SCBSceneMissionManager {
    if (!SCBSceneMissionManager.sInstance) {
      SCBSceneMissionManager.sInstance = new SCBSceneMissionManager();
    }
    return SCBSceneMissionManager.sInstance;
  }

  /**
   * init on diff mission management stage.
   */
  public init(initStage: SceneMissionMgmtStage, screenHandler?: SCBScreenMissionHandler,
    panelHandler?: SCBScenePanelMissionHandler): void {
    log.showInfo(`init on stage: ${initStage}`);
    switch (initStage) {
      case SceneMissionMgmtStage.ON_SCREEN_INIT:
        if (!screenHandler) {
          log.showError('invalid screen mission handler');
          return;
        }
        this.screenHandlers.set(screenHandler.screenId, screenHandler);
        break;
      case SceneMissionMgmtStage.ON_SCENE_PANEL_HANDLER_CREATE:
        if (!panelHandler) {
          log.showError('invalid panel mission handler');
          return;
        }
        this.initScreenMissionHandlerInner(panelHandler.screenId);
        this.screenHandlers.get(panelHandler.screenId)?.onPanelAttach(panelHandler);
        break;
      case SceneMissionMgmtStage.ON_SCENE_PANEL_INIT:
        SCBScreenSessionManager.getInstance().notifyScreenConnectCompletion(panelHandler?.screenId);
        this.triggerDeferringStart(panelHandler);
        return;
      default:
        break;
    }
  }

  /**
   * deinit on diff mission management stage.
   */
  public release(initStage: SceneMissionMgmtStage, missionHandler?: SCBScenePanelMissionHandler): void {
    log.showInfo(`release on stage: ${initStage}`);
    switch (initStage) {
      case SceneMissionMgmtStage.ON_SCENE_PANEL_RELEASE:
        this.screenHandlers.get(missionHandler?.screenId)?.onPanelDetach(missionHandler);
        break;
      case SceneMissionMgmtStage.ON_SCREEN_RELEASE:
        break;
      case SceneMissionMgmtStage.ON_SCB_RELEASE:
        break;
      default:
        break;
    }
  }

  public preAssignPanelId(screenId: number): number {
    let count = this.screenHandlers.get(screenId)?.panelCount ?? 0;
    return ++count;
  }

  /**
   * notify screen state change
   * @param screenId id
   * @param connected true means screen connect, false means screen disconnect
   */
  public notifyScreenStateChange(screenId: number, connected: boolean): void {
    log.showInfo(`[screen:${screenId}] connected state change to ${connected}`);
    // process specific scenes or other screen change listeners
    this.innerScreenStateListeners.forEach((listener) => {
      listener?.notifyScreenStateChange(screenId, connected);
    });
    // process main scenes
    if (connected) {
      this.initScreenMissionHandlerInner(screenId);
    } else {
      this.clearDeferredCache(screenId);
      this.deInitScreenMissionHandlerInner(screenId);
    }
  }

  /**
   * register inner screen state change listener
   */
  public registerInnerScreenStateChangeListener(listener: InnerScreenStateChangeListener): void {
    if (!listener) {
      log.showError('invalid listener registered, ignore');
      return;
    }
    this.innerScreenStateListeners.add(listener);
  }

  private initScreenMissionHandlerInner(screenId: number): void {
    if (this.screenHandlers.has(screenId)) {
      log.showInfo('init screen handler already set.');
      return;
    }
    log.showInfo(`init new screen handler of screen ${screenId}.`);
    this.screenHandlers.set(screenId, new SCBScreenMissionHandler(screenId));
  }

  private deInitScreenMissionHandlerInner(screenId: number): void {
    log.showInfo(`deInit screen handler of screen ${screenId}`);
    if (this.screenHandlers.has(screenId)) {
      this.screenHandlers.get(screenId)?.clearAllPanels();
    }
    this.screenHandlers.delete(screenId);
  }

  // ----------------------------------------------------------------------------------------------------
  // Global Session LifeCycle Management
  // ----------------------------------------------------------------------------------------------------

  /**
   * product register customized processor
   * @param processor SCBSceneMissionProcessor
   */
  public registerProductMissionProcessor(processor: SCBSceneMissionProcessor): void {
    this.productMissionProcessor?.add(processor);
  }

  /**
   * product unregister customized processor
   * @description currently just one processor for product, can be more.
   */
  public unregisterProductMissionProcessor(): void {
    this.productMissionProcessor = null;
  }

  /**
   * notify product processor handle pending activation
   * @param toInfo info of the scene will start
   * @param fromInfo caller info
   */
  public notifySessionPendingActivation(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void {
    this.productMissionProcessor?.forEach(object => {
      if (object) {
        object.onPendingSessionToStart(toInfo, fromInfo);
      }
    });
  }

  /**
   * notify product processor handle pending activation
   * @param toInfo info of the scene will start
   * @param visible visibility of scene
   * @param fromInfo caller info
   */
  public notifySessionVisibilityChange(toInfo: SCBSceneInfo, visible: boolean, fromInfo?: SCBSceneInfo): void {
    this.productMissionProcessor?.forEach(object => {
      if (object) {
        object.onHiddenSessionVisibilityChanged(toInfo, visible, fromInfo);
      }
    });
  }

  /**
   * notify product processor handle session activation
   * @param containerSession the container will be activate
   */
  public notifySessionRequestActivation(containerSession: SCBSceneContainerSession): void {
    this.productMissionProcessor?.forEach(object => {
      if (object) {
        object.onSessionWillGoForeground(containerSession);
      }
    });
    this.recentMissionMgr.updateRecentMissionIdSet(containerSession);
  }

  /**
   * notify session manager to update RecentMainSessionInfoList
   * @param persistentId the persistentId of the session which will be destructed
   */
  public notifySessionRequestDestruction(persistentId: number | undefined): void {
    if (!persistentId) {
      log.showWarn(`persistentId ${persistentId} is invalid`);
      return;
    }
    this.recentMissionMgr.removeSessionFromRecentMissionIdSet(persistentId);
  }

  /**
   * notify session manager that window mode has updated
   * @param windowMode the windowMode of corresponding SceneSession
   * @param persistentId the persistentId of the session which will be destructed
   */
  public notifyUpdateWindowMode(windowMode: SCBSceneMode, persistentId: number): void {
    SCBAppUseControlManager.getInstance().notifyUpdateWindowMode(persistentId, windowMode);
    this.recentMissionMgr.updateRecentFloatMissionSet(windowMode, persistentId);
  }

  /**
   * notify session manager when container entered split scene
   * @param containerSession the container that entered split scene
   */
  public notifyAddSceneSession(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      log.showWarn('containerSession is null');
      return;
    }
    this.recentMissionMgr.updateRecentMissionIdSet(containerSession);
  }

  public notifyAddToMidScene(persistentId: number): void {
    this.recentMissionMgr.updateRecentMissionIdSetByMidScene(persistentId);
  }

  /**
   * notify session manager when Recover is finished
   * @param recoverSessionIdList the id list of session that need to be recovered
   */
  public notifySessionRecoverFinished(recoverSessionIdList: Array<number>): void {
    this.recentMissionMgr.initRecentMissionIdSet(recoverSessionIdList);
  }

  /**
   * notify session manager when container session is recovered from persistentMap
   * @param containerSession the containerSession that recovered from persistentMap
   */
  public notifyPersistentRecoverFinished(): void {
    const recoverSessionIdList = this.scenePersistent.getAllPersistentIds();
    this.notifySessionRecoverFinished(recoverSessionIdList);
  }

  /**
   * notify when the application content is loaded when the start window is invisible.
   * @param persistentId persistentId of SCBSceneSession.
   */
  public notifyApplicationLoadedWhenStartWindowInvisible(persistentId: number): void {
    this.productMissionProcessor?.forEach(object => {
      if (object) {
        object.notifyApplicationLoadedWhenStartWindowInvisible(persistentId);
      }
    });
  }

  /**
   * requestNewSceneSession from native.
   * @param sceneInfo sceneInfo to create SCBSceneSession
   * @returns SCBSceneSession or null.
   */
  public requestNewSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    let sceneSession = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
    if (sceneSession == null) {
      log.showError('requestSceneSession failed!');
      return null;
    }
    return new SCBSceneSession(sceneSession, sceneInfo);
  }

  /**
   * request scene session
   * @param sceneInfo info of the scene will start
   */
  public requestSceneSession(sceneInfo: SCBSceneInfo,
    screenId: number, isPersistentRecover: boolean = false): sceneSessionManager.SceneSession | null {
    if (SCBKioskModeManager.getInstance().isKioskMode() &&
      !SCBKioskModeManager.getInstance().isKioskApp(sceneInfo.bundleName)) {
      log.showError(`[SCBMain]requestSceneSession failed, ${sceneInfo.bundleName} is not kiosk app.`);
      return null;
    }
    TraceUtil.startTrace(DomainName.WINDOW, MissionManagementTraceUtil.REQUEST_NEW_SESSION);
    let sceneSession: sceneSessionManager.SceneSession;
    try {
      sceneSession = sceneSessionManager.requestSceneSession({
        bundleName: sceneInfo.bundleName,
        moduleName: sceneInfo.moduleName,
        abilityName: sceneInfo.abilityName,
        appIndex: sceneInfo.appIndex,
        persistentId: sceneInfo.persistentId,
        screenId: screenId,
        isPersistentRecover: isPersistentRecover,
        fullScreenStart: sceneInfo.fullScreenStart,
        isNewAppInstance: sceneInfo.isNewAppInstance,
        appInstanceKey: sceneInfo.appInstanceKey,
        isAbilityHook: sceneInfo.isAbilityHook,
        hasPrivacyModeControl: sceneInfo.hasPrivacyModeControl,
        windowMode: sceneInfo.expectWindowMode ?? sceneInfo.windowMode, // select the value of expectWindowMode from the dock bar first
      }, sceneInfo.want);
      if (sceneSession != null) {
        log.showInfo(`[SCBMain][id:${sceneSession.persistentId}][sceneInfo:${sceneInfo.bundleName}/` +
          `${sceneInfo.moduleName}/${sceneInfo.abilityName}/${sceneInfo.appIndex}][screenId:${screenId}]requestSceneSession ` +
          `suceess, udpate persistentId from ${sceneInfo.persistentId} to ${sceneSession.persistentId}, ` +
          `udpate appInstanceKey from ${sceneInfo.appInstanceKey} to ${sceneSession.appInstanceKey}`);
        sceneInfo.persistentId = sceneSession.persistentId;
        sceneInfo.appInstanceKey = sceneSession.appInstanceKey ?? '';
        this.notifyNewSceneSessionCreate(sceneInfo);
      } else {
        log.showWarn(`[SCBMain][sceneInfo:${sceneInfo.bundleName}/${sceneInfo.moduleName}/${sceneInfo.abilityName}` +
          `/${sceneInfo.appIndex}]requestSceneSession failed, result is null.`);
      }
    } catch (err) {
      log.showError(`[SCBMain][sceneInfo:${sceneInfo.bundleName}/${sceneInfo.moduleName}/${sceneInfo.abilityName}` +
        `/${sceneInfo.appIndex}]requestSceneSession failed, with reason: ${JSON.stringify(err)}`);
    } finally {
      TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.REQUEST_NEW_SESSION);
    }
    return sceneSession;
  }

  /**
   * request scene session go to destruct
   * @param session target session
   * @param opts options when destruct
   * @returns error code
   */
  public requestSceneSessionDestruction(session: sceneSessionManager.SceneSession,
    opts: MainSessionDestructionOpts): number {
    let destructionResult = 0;
    try {
      sceneSessionManager.requestSceneSessionDestruction(session, opts.isDeletePersistentMap,
        opts.isSaveSnapshot, opts.isForceClean, opts.isUserRequestedExit);
      if (opts?.isDeletePersistentMap) {
        this.notifySessionDestruction(session.persistentId);
      }
    } catch (err) {
      log.showError('[SCBMain]requestSceneSessionDestruction failed, with reason ' + JSON.stringify(err));
      destructionResult = err.code;
    }
    return destructionResult;
  }

  /**
   * notify new scene session create
   * @param sceneInfo info of the scene will start
   */
  public notifyNewSceneSessionCreate(sceneInfo: SCBSceneInfo): void {
    this.productMissionProcessor?.forEach(object => {
      if (object) {
        object.onNewSceneSessionCreate(sceneInfo);
      }
    });
  }

  /**
   * notify session destruction
   */
  public notifySessionDestruction(id: number): void {
    log.showInfo(`deleteSceneSessionCache of ${id}`);
    let sceneSession: SCBSceneSession | null = this.findMainSessionGlobalById(id);
    try {
      this.productMissionProcessor?.forEach(object => {
        if (object && sceneSession) {
          object.onSceneSessionWillTerminate(sceneSession.getUid, sceneSession.sceneInfo);
        }
      });
    } catch (e) {
      log.showError(`onSceneSessionWillTerminate error ${e}`);
    }
    this.globalSceneSessionCache.delete(id);
  }

  // ----------------------------------------------------------------------------------------------------
  // Global Scene Mission Management
  // ----------------------------------------------------------------------------------------------------

  /**
   * check whether need to defer starting
   * @description if need to custom strategy, plz use design pattern
   * @param sceneInfo toSceneInfo
   * @returns true means need deferred, false means the opposite.
   */
  private needDeferStart(sceneInfo: SCBSceneInfo): boolean {
    let needDeferStart = true;
    this.screenHandlers.forEach((item) => {
      if (item.screenId === sceneInfo.screenId && item.panelCount !== 0) {
        needDeferStart = false;
      }
    });
    log.showInfo(`${needDeferStart ? 'need' : 'no need'} defer start`);
    return needDeferStart;
  }

  private triggerDeferringStart(missionHandler?: SCBScenePanelMissionHandler): void {
    if (!missionHandler || this.deferredStartingCache.size === 0) {
      return;
    }
    log.showInfo(`try trigger deferring start, with cache count: ${this.deferredStartingCache.size}`);
    const onlinePanel = missionHandler.screenId;
    for (let startingInfo of this.deferredStartingCache) {
      if (onlinePanel === startingInfo.screenId) {
        log.showInfo(`${missionHandler.logTag} trigger deferring start`);
        SCBSceneSessionManager.getInstance().startSceneFromOther(startingInfo);
      }
    }
    this.clearDeferredCache(missionHandler.screenId);
  }

  private clearDeferredCache(screenId: number): void {
    this.deferredStartingCache.forEach((item) => {
      if (item.screenId === screenId) {
        this.deferredStartingCache.delete(item);
      }
    });
  }

  /**
   * 归一化的StartScene接口，收编老架构冗余的启动接口
   * @param toInfo target session info
   * @param opts options
   */
  public startScene(toInfo: SCBSceneInfo, opts: SCBStartSceneOpts): void {
    if (this.needDeferStart(toInfo)) {
      this.deferredStartingCache.add(toInfo);
      return;
    }
    this.screenHandlers.get(toInfo.screenId)?.startScene(toInfo, opts);
  }

  /**
   * StartSceneTransition
   * @param toInfo target session
   * @param fromInfo from session
   * @param opts options
   */
  public startSceneTransition(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo, opts?: SCBTransitionSceneOpts): CommonResult {
    log.showInfo(`startSceneTransition, to: ${toInfo.getName()} on screen ${toInfo.screenId}, ` +
      `from: ${fromInfo.getName()} on screen: ${fromInfo.screenId}`);
    const callerScreenHandler = this.screenHandlers.get(toInfo.screenId);
    if (!callerScreenHandler) {
      log.showError('startSceneTransition failed with null screen handler to response');
      return CommonResult.FAIL;
    }
    return callerScreenHandler.startSceneTransition(toInfo, fromInfo, opts);
  }

  /**
   * StartSceneFromOther.
   *
   * @param sceneInfo The info of the scene which to be activated
   */
  public startSceneFromOther(sceneInfo: SCBSceneInfo): CommonResult {
    log.showInfo(`startSceneFromOther, to: ${sceneInfo.getName()} on screen ${sceneInfo.screenId}`);
    if (this.needDeferStart(sceneInfo) && SCBWindowSceneConfig.getInstance().isPhone()) {
      this.deferredStartingCache.add(sceneInfo);
      return CommonResult.SUCCESS;
    }
    let startResult: CommonResult = CommonResult.SUCCESS;
    this.screenHandlers.forEach(item => {
      if (item && item.screenId === sceneInfo.screenId) {
        if (item.startSceneFromOther(sceneInfo) === CommonResult.FAIL) {
          startResult = CommonResult.FAIL;
        }
      }
    });
    return startResult;
  }

  /**
   * terminate scene
   */
  public terminateScene(screenId: number, persistentId?: number, containerId?: number,
    opts?: SCBTerminateSceneOpts): void {
    this.screenHandlers.forEach(item => {
      if (item && item.screenId === screenId) {
        item.terminateScene(persistentId, containerId, opts);
      }
    });
  }

  /**
   * minimize scene
   */
  public minimizeScene(screenId: number, persistentId?: number, containerId?: number,
    opts?: SCBMinimizeSceneOpts): void {
    if (!this.screenHandlers.has(screenId)) {
      log.showError(`no missionHandler of screenId:${screenId} register minimizeScene.`);
      return;
    }
    this.screenHandlers.get(screenId)?.minimizeScene(persistentId, containerId, opts);
  }

  /**
   * move scene session background.
   * @param sceneInfo scene information.
   * @param shouldBackToCaller whether to return to the caller
   * @param record want message.
   */
  public pendingSessionToBackground(sceneInfo: sceneSessionManager.SceneInfo, shouldBackToCaller: boolean,
    record: Record<string, Object>): void {
    log.showInfo('on pendingSessionToBackground');
    this.productMissionProcessor?.forEach(object => {
      if (object) {
        object.onPendingSessionToBackground(sceneInfo, shouldBackToCaller, record);
      }
    });
  }

  /**
   * pop scene from other screen by info
   */
  public popSceneFromOtherScreenByInfo(info: SCBSceneInfo, opts: SCBTransferSceneOpts): SCBSceneSession | null {
    let targetScreenId = info.screenId;
    if (targetScreenId === INVALID_SCREEN_ID) {
      log.showWarn('invalid target session to pop, find in all');
      targetScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
    }
    const sceneSession = this.findMainSessionGlobalByInfo(info);
    if (!sceneSession) {
      log.showInfo(`popSceneFromOtherScreenByInfo not found target session`);
      return null;
    }
    if (sceneSession.screenId === targetScreenId) {
      log.showInfo(`sceneSession on targetScreen, ignored`);
      return null;
    }
    if (!this.screenHandlers.has(sceneSession.screenId)) {
      log.showError(`popSceneFromOtherScreenByInfo invalid screenId`);
      return null;
    }
    return this.screenHandlers.get(sceneSession.screenId).popSceneOut(undefined, info, opts);
  }

  public popSceneFromOtherScreenByPersistentId(persistentId: number, targetScreenId: number, opts: SCBTransferSceneOpts): SCBSceneSession | null {
    if (targetScreenId === INVALID_SCREEN_ID) {
      log.showWarn('invalid target session to pop, find in all');
      targetScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
    }
    const sceneSession = this.findMainSessionGlobalById(persistentId);
    if (!sceneSession) {
      log.showInfo(`popSceneFromOtherScreenByPersistentId not found target session`);
      return null;
    }
    if (sceneSession.screenId === targetScreenId) {
      log.showInfo(`sceneSession on targetScreen, ignored`);
      return null;
    }
    if (!this.screenHandlers.has(sceneSession.screenId)) {
      log.showError(`popSceneFromOtherScreenByPersistentId invalid screenId`);
      return null;
    }
    return this.screenHandlers.get(sceneSession.screenId).popSceneOut(persistentId, undefined, opts);
  }

  /**
   * transfer a scene to target screen
   * @param persistentId id of scene session
   * @param targetScreen id of target screen
   * @param params more params
   */
  public transferSceneToTargetScreen(persistentId: number, targetScreen: number,
    params: Record<string, Object> = {}): void {
    log.showInfo(`transferSceneToTargetScreen persistentId: ${persistentId}, targetScreen: ${targetScreen}`);
    if (persistentId === undefined || persistentId <= INVALID_PERSISTENT_ID) {
      log.showError(`invalid persistentId`);
      return;
    }
    if (!this.screenHandlers.has(targetScreen)) {
      log.showError(`invalid targetScreen`);
      this.notifySessionTransferToTargetScreenEvent(persistentId, CommonResultCode.FAIL, INVALID_SCREEN_ID, targetScreen);
      return;
    }
    const targetSession = this.findMainSessionGlobalById(persistentId);
    if (!targetSession) {
      log.showError('not find targetSession');
      this.notifySessionTransferToTargetScreenEvent(persistentId, CommonResultCode.FAIL, INVALID_SCREEN_ID, targetScreen);
      return;
    }
    const fromScreenId = targetSession.screenId;
    const transferWithAnimation: boolean = (params[MINIMIZE_ABILITY_BEFORE_POP] as boolean);
    const needBackgroundWhenTransfer: boolean = (params[BACKGROUND_SCENE_WHEN_TRANSFER] as boolean);
    log.showInfo(`transferSceneToTargetScreen ${persistentId} to screen ${targetScreen},` +
      `${transferWithAnimation ? 'with' : 'without'} animation, ` +
      `${needBackgroundWhenTransfer ? 'background' : 'not background'}`);
    this.preProcessBeforeTransfer(targetSession);

    let opts: SCBTransferSceneOpts = {
      needRefreshFocus: true, needBackground: needBackgroundWhenTransfer, needUpdateScreenId: true, params: params
    };
    if (transferWithAnimation) { // with animation when pop out
      opts.needBackground = false; // if with animation, background will cause scene detach from tree
      opts.transferFinishedCallback = (session: SCBSceneSession): void => {
        if (!session) {
          log.showError(`transferSceneToTargetScreen after pop out, null session push in`);
          return;
        }
        log.showInfo(`transferSceneToTargetScreen after pop out, will push in`);
        const result = this.screenHandlers.get(targetScreen)?.pushSceneIn(session, opts) ?? CommonResult.FAIL;
        this.notifySessionTransferToTargetScreenEvent(persistentId, result.resultCode, fromScreenId, targetScreen);
        this.postProcessAfterTransfer(targetSession);
      }
      const sceneSession = this.screenHandlers.get(fromScreenId)?.popSceneOut(persistentId, undefined, opts);
      if (!sceneSession) {
        log.showError('transferSceneToTargetScreen: Pop scene out fail');
        this.notifySessionTransferToTargetScreenEvent(persistentId, CommonResultCode.FAIL, fromScreenId, targetScreen);
        return;
      }
      return;
    }

    // without animation
    const sceneSession = this.screenHandlers.get(fromScreenId)?.popSceneOut(persistentId, undefined, opts);
    if (!sceneSession) {
      log.showError('transferSceneToTargetScreen: Pop scene out fail');
      this.notifySessionTransferToTargetScreenEvent(persistentId, CommonResultCode.FAIL, fromScreenId, targetScreen);
      return;
    }
    const result = this.screenHandlers.get(targetScreen).pushSceneIn(sceneSession, opts);
    this.notifySessionTransferToTargetScreenEvent(persistentId, result.resultCode, fromScreenId, targetScreen);
    this.postProcessAfterTransfer(targetSession);
  }

  public notifySessionTransferToTargetScreenEvent(
    persistentId: number, resultCode: CommonResultCode, fromScreenId: number, toScreenId: number): void {
    log.showInfo(`notifySessionTransferToTargetScreenEvent resultCode: ${resultCode}, ` +
      `persistentId: ${persistentId}, fromScreenId: ${fromScreenId}, toScreenId: ${toScreenId}`);
    if (persistentId === undefined || persistentId <= INVALID_PERSISTENT_ID || resultCode === undefined ||
        fromScreenId === undefined || toScreenId === undefined) {
      log.showError(`invalid params`);
      return;
    }
    try {
      sceneSessionManager.notifySessionTransferToTargetScreenEvent(persistentId, resultCode, fromScreenId, toScreenId);
    } catch(err) {
      log.showError('notifySessionTransferToTargetScreenEvent error: ' + JSON.stringify(err));
    }
  }

  // ----------------------------------------------------------------------------------------------------
  // Global Session Cache Management
  // ----------------------------------------------------------------------------------------------------

  /**
   * cache a new SCBSceneSession into global map
   * @param session SCBSceneSession instance
   */
  public cacheNewSceneSession(session: SCBSceneSession): void {
    if (session == null) {
      log.showWarn('cacheNewSceneSession, null ignored.');
      return;
    }
    log.showInfo(`cacheNewSceneSession of id: ${session.persistentId},` +
      ` exist: ${this.globalSceneSessionCache.has(session.persistentId)}.`);
    this.globalSceneSessionCache.set(session.persistentId, session);
  }

  /**
   * check and remove scbSceneSession after native session destruct.
   * @param persistentId persistentId of sceneSession which already dstruct.
   */
  public removeSceneSessionAfterDestruct(persistentId: number):void {
    if (persistentId === undefined) {
      log.showInfo(`removeSceneSessionAfterDestruct failed persistentId is undefined.`);
      return;
    }
    this.productMissionProcessor?.forEach(object => {
      if (object) {
        object.removeSceneSessionAfterDestruct(persistentId);
      } else {
        log.showWarn(`removeSceneSessionAfterDestruct productMissionProcessor is null.`);
      }
    });
  }

  /**
   * find session by id, includes main session & sub session & system sub session
   * @param id persistent id
   * @returns session
   */
  public findSessionGlobalById(id: number): SCBSceneSession | SCBSpecificSession | null {
    if (this.globalSceneSessionCache.has(id)) {
      return this.globalSceneSessionCache.get(id);
    }
    return null;
  }

  /**
   * find main session tuple by persistentId
   * @param persistentId persistentId of session
   * @returns SCBMainSessionTuple
   */
  public findMainSessionTupleGlobalByPersistentId(persistentId: number, excludePanel?: number): SCBMainSessionTuple {
    if (persistentId <= INVALID_PERSISTENT_ID) {
      log.showError('Invalid persistentId to findMainSessionTupleGlobalByPersistentId');
      return { sceneSession: null, containerSession: null };
    }
    for (let handler of this.screenHandlers.values()) {
      const sessionTuple = handler.findMainSessionTupleByPersistentId(persistentId, excludePanel);
      if (sessionTuple.sceneSession && sessionTuple.containerSession) {
        return sessionTuple;
      }
    }
    log.showInfo('Not find mainSession tuple global by persistentId');
    return { sceneSession: null, containerSession: null };
  }

  /**
   * find main session by id.
   * @param id persistent id
   * @returns session
   */
  public findMainSessionGlobalById(id: number): SCBSceneSession | null {
    if (!this.globalSceneSessionCache.has(id)) {
      log.showError('findMainSessionGlobalById error, not exist.');
      return null;
    }
    const session = this.globalSceneSessionCache.get(id);
    if (session?.session.type === sceneSessionManager.SessionType.TYPE_APP) {
      return session as SCBSceneSession;
    }
    return null;
  }

  /**
   * find main session tuple by info
   * @param info info of session
   * @returns SCBMainSessionTuple
   */
  public findMainSessionTupleGlobalByInfo(info: SCBSceneInfo, excludePanel?: number): SCBMainSessionTuple {
    if (info == null) {
      log.showError('null info to findMainContainerSessionGlobalByInfo.');
      return { sceneSession: null, containerSession: null };
    }
    for (let handler of this.screenHandlers.values()) {
      const sessionTuple = handler.findMainSessionTupleByInfo(info, excludePanel);
      if (sessionTuple.sceneSession && sessionTuple.containerSession) {
        return sessionTuple;
      }
    }
    log.showInfo('no exist container session match the info to be found.');
    return { sceneSession: null, containerSession: null };
  }

  /**
   * find main session by info
   * @param info info of session
   * @returns SCBSceneSession | null
   */
  public findMainSessionGlobalByInfo(info: SCBSceneInfo, excludePanel?: number): SCBSceneSession | null {
    return this.findMainSessionTupleGlobalByInfo(info, excludePanel).sceneSession;
  }

  /**
   * Close session if condition function return true
   * @param condition Close condition function
   */
  public closeSessionWithCondition(condition: Function): void {
    for (let scbSceneSession of this.globalSceneSessionCache.values()) {
      if (!condition(scbSceneSession)) {
        continue;
      }
      if (scbSceneSession.isInSplit()) {
        scbSceneSession.needDestructedInSplit = true;
      }
      log.showInfo(`[WMSLife][id:${scbSceneSession.persistentId}] close session with condition`);
      SCBSceneSessionManager.getInstance().close(scbSceneSession.screenId, scbSceneSession.persistentId);
    }
  }

  /**
   * get target screen top active scene session
   * @param screen id
   * @param screen name
   * @param usage
   */
  public getTargetScreenTopActiveSceneSession(screenId: number | undefined, screenName: string | undefined,
    usage: string = DEFAULT_TOTAL_LIST_TAG): SCBSceneContainerSession | null {
    if(screenId !== undefined && screenId !== null) {
      return this.screenHandlers.get(screenId)?.getTopActiveSession(usage);
    }
    for (const [screenId, handler] of this.screenHandlers.entries()) {
      if (handler.screenSession?.session.name === screenName) {
        return handler.getTopActiveSession(usage);
      }
    }
    return null;
  }

  private preProcessBeforeTransfer(sceneSession: SCBSceneSession): void {
    // no need to start PIP when transfer scene to target screen
    sceneSession.isNeedStartPiP = false;
    // mark isDisappearing when transfer, intercept start during popout & push-in
    sceneSession.sessionData.isPopoutDisappearing = true;
  }

  private postProcessAfterTransfer(sceneSession: SCBSceneSession): void {
    // mark pending remove when transfer, intercept start during popout & push-in
    sceneSession.sessionData.isPopoutDisappearing = false;
  }

  public setRequestId(info: sceneSessionManager.SceneInfo, requestId: number): void {
    if (!info) {
      log.showInfo('null info to setRequestId');
      return;
    }
    // 多实例场景下不需要setRequestId
    let queryKey = info.bundleName + info.moduleName + info.abilityName;
    let launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
    if (launchType === bundleManager.LaunchType.MULTITON) {
      return;
    }
    if (info.persistentId > INVALID_PERSISTENT_ID) {
      let sceneSession = this.findMainSessionGlobalById(info.persistentId);
      if (sceneSession) {
        sceneSession.sceneInfo.requestId = requestId;
        return;
      }
    }

    let sceneInfo = new SCBSceneInfo(info.bundleName, info.moduleName, info.abilityName, info.appIndex);
    let sceneSession = this.findMainSessionGlobalByInfo(sceneInfo);
    if (sceneSession) {
      sceneSession.sceneInfo.requestId = requestId;
    }
    return;
  }

  public resetRequestId(info: sceneSessionManager.SceneInfo): void {
    if (!info) {
      log.showInfo('null info to resetRequestId');
      return;
    }
    if (info.persistentId > INVALID_PERSISTENT_ID) {
      let sceneSession = this.findMainSessionGlobalById(info.persistentId);
      if (sceneSession) {
        sceneSession.sceneInfo.resetRequestId();
        return;
      }
    }

    let sceneInfo = new SCBSceneInfo(info.bundleName, info.moduleName, info.abilityName, info.appIndex);
    let sceneSession = this.findMainSessionGlobalByInfo(sceneInfo);
    if (sceneSession) {
      sceneSession.sceneInfo.resetRequestId();
    }
    return;
  }
}