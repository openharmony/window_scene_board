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

import { curves } from '@kit.ArkUI';
// import apsManager from '@ohos.graphic.apsManager';
import transactionManager from '@ohos.transactionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { power } from '@kit.BasicServicesKit';
import {
  AnimateToScheduleUtils,
  DomainName,
  LogDomain,
  LogHelper,
  RectInfo,
  StartType,
  Trace,
  TraceUtil
} from '@ohos/basicutils';
import { ApsUtils, DeviceHelper, HiDfxEventUtil, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { viewMgrPolicy } from '@ohos/frameworkwrapper';
import {
  CloseAppManager,
  CommonConstants,
  DeviceState,
  PageDesktopModel,
  PhoneCallAnimationConstants,
  StyleConstants
} from '@ohos/launchercommon';
import { SCBDefaultZIndex } from '../SCBScreen';
import { SCBWindowRotate } from '../SCBWindowRotate';
import lazy { MattesRotateStrategy } from '@ohos/foldeffect/src/main/ets/mattesstrategy/MattesRotateStrategy';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import {
  AppData,
  FocusChangeReason,
  MoveStartingOption,
  RecentViewParam,
  SCBContainerRotationReason,
  SCBDeviceScreenConfig,
  SCBEventId,
  SCBKeyboardSession,
  SCBPropertyChangeReason,
  SCBRotateChangeReason,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneContainerState,
  SCBSceneInfo,
  SCBSceneInfoFromScreenLock,
  SCBSceneMode,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSceneUtils,
  SCBScreenProperty,
  SCBScreenSession,
  SCBScreenSessionManager,
  SCBWindowRotateController,
  SCBTransitionController,
  SCBTransitionManager,
  OccludeKeygaurdScene,
  SCBWindowRaiseReason,
  scbEventExclusiveManager,
  EventType,
  SceneProxyToScreenLock,
  SCBBaseScenePanelViewModel,
  ScbNumber,
  CommonResult,
  SceneInfoAdapterUtil
} from '@ohos/windowscene';
import { ScenePanelState } from '../SCBSpecialScenePanel';
import { RotationConstants } from '@ohos/commonconstants';
import { SCBSpecialScenePanelAnimator } from '../viewanimator/SCBSpecialScenePanelAnimator';
import { OverlayStartAnimHelper } from '@ohos/systemuicommon/Index';
import { SingleStartFrom } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import { SCBSpecialPanelMissionHandler } from './missionmanagement/SCBSpecialPanelMissionHandler';
import { scbStatusBarVM } from '../../statusbar/viewmodel/SCBStatusBarVM';
import { SCBSceneStartInterceptor, StartInterceptions } from '@ohos/windowscene/src/main/ets/scene/framework/missions/SCBSceneStartInterceptor';
import { WinLog, WinLogDomain } from '@ohos/windowscene/src/main/ets/utils/WinLog';
import systemParameter from '@ohos.systemParameterEnhance';

const TAG = 'SCBSpecialScenePanelViewModel';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Handler for view model operates view state collection.
 */
export interface SpecialScenePanelStateCollectionHandler {
  getPanelName: () => string;
  getPanelState: () => ScenePanelState;
  updatePanelState: (state: ScenePanelState) => void;
  getScreenRotationAnimCnt: () => number;

  getViewParam: () => RecentViewParam;
  updateBlackBackgroundState: (state: boolean) => void;
  getMattesLockState: () => boolean;
  getFoldStatus: () => number;
  getShowCompanionIconState: () => boolean;
  updateShowCompanionIconState: (isShowCompanionIcon:boolean) => void;
}

/**
 * ViewModel of SCBSpecialScenePanel View.
 */
export class SCBSpecialScenePanelViewModel extends SCBBaseScenePanelViewModel<SCBSpecialPanelMissionHandler> {
  public screenId: number;
  private physicalScreenProperty: SCBScreenProperty;
  private panelMgr = SCBScenePanelManager.getInstance();

  private keyboardSession: SCBKeyboardSession | null = null;
  private panelStateCollectionHandler: SpecialScenePanelStateCollectionHandler | null = null;

  private panelAnimator: SCBSpecialScenePanelAnimator;
  private specialContainerSessionList: SCBSceneContainerSessionArray;

  private shouldHideStatusBar: boolean = false;
  private rotationAnimCnt: number = 0;
  private rotateFinishTimerId: number = -1;
  private expandStartContainerSession: SCBSceneContainerSession | null = null;
  public isEnableBlur = (systemParameter.getSync('sceneboard.isEnableBlur', 'true') === 'true');

  constructor(screenProperty: SCBScreenProperty, phyScreenProperty: SCBScreenProperty) {
    super(new SCBSpecialPanelMissionHandler(screenProperty), screenProperty);
    this.screenId = screenProperty.screenId;
    this.screenProperty = screenProperty;
    this.physicalScreenProperty = phyScreenProperty;
    this.panelAnimator = new SCBSpecialScenePanelAnimator(this);
    this.specialContainerSessionList = this.missionHandler.getContainerSessionList();
  }

  public init(keyboardSession: SCBKeyboardSession, stateCallback: SpecialScenePanelStateCollectionHandler): void {
    log.showInfo('init.');
    this.keyboardSession = keyboardSession;
    this.panelStateCollectionHandler = stateCallback;
    this.registerSceneMissionManagementCallback();
    this.registerSceneRotationCallback();
    this.registerScreenPropertyChangeScenePanelCallback();
    this.registerSceneStartingInterceptorRules();
  }

  public release(): void {
    log.showInfo('release.');
    this.panelStateCollectionHandler = null;
    this.unregisterSceneMissionManagementCallback();
    this.unregisterSceneRotationCallback();
    this.unregisterSceneStartingInterceptorRules();
  }

  public getContainerSessionList(): SCBSceneContainerSessionArray {
    return this.specialContainerSessionList;
  }

  public getPanelStateCollectionHandler(): SpecialScenePanelStateCollectionHandler | null {
    return this.panelStateCollectionHandler;
  }

  public getShouldHideStatusBar(): boolean {
    return this.shouldHideStatusBar;
  }

  public setShouldHideStatusBar(value: boolean) {
    this.shouldHideStatusBar = value;
  }

  public getPanelManager(): SCBScenePanelManager {
    return this.panelMgr;
  }

  private registerSceneMissionManagementCallback(): void {
    SCBSceneSessionManager.getInstance().registerGetSpecialContainerSessionListCallback(
      (): SCBSceneContainerSessionArray => {
        return this.specialContainerSessionList;
      });
    SCBSceneSessionManager.getInstance().registerAddSpecialContainerSessionCallback(
      (sessionList: SCBSceneContainerSessionArray): void => {
        return this.onTransferSceneIn(sessionList);
      });
    SCBSceneSessionManager.getInstance().registerRemoveSpecialContainerSessionCallback(
      (): SCBSceneContainerSessionArray => {
        return this.onTransferSceneOut();
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.ORIENTATION_CHANGE, this.screenProperty.screenId,
      (persistentId: number, requestedOrientation: number) => {
        this.onContainerRequestedOrientationChange(persistentId, requestedOrientation);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.MAXIMIZE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onMaximizeScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance()
      .onSpecial(SCBEventId.START_SCENE_FROM_SCREEN_LOCK, this.screenProperty.screenId,
        (info: SCBSceneInfoFromScreenLock) => {
          this.onStartSceneFromScreenLockIcon(info);
        });
  }

  private registerSceneRotationCallback(): void {
    SCBSceneSessionManager.getInstance().registerSpecialScenePanelExitSceneWithRotationRecoverCallback(
      (currentSession?: SCBSceneContainerSession | null): void => {
        this.exitSceneWithRotationRecover(this.isVerticalExit(), currentSession);
      });
  }

  private registerScreenPropertyChangeScenePanelCallback() : void {
    SCBScreenSessionManager.getInstance().registerPropertyChangeScenePanelCallback(
      (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        log.showDebug('ScenePanel screen callback is called ');
        this.onScreenPropertyChange(screenProperty, reason);
      }, SCBDefaultZIndex.SPECIAL_SCENE_PANEL, this.screenProperty.screenId);
  }

  private unregisterSceneMissionManagementCallback(): void {
    SCBSceneSessionManager.getInstance().unregisterGetSpecialContainerSessionListCallback();
    SCBSceneSessionManager.getInstance().unregisterAddSpecialContainerSessionCallback();
    SCBSceneSessionManager.getInstance().unregisterRemoveSpecialContainerSessionCallback();
  }

  private unregisterSceneRotationCallback(): void {
    SCBSceneSessionManager.getInstance().unregisterSpecialScenePanelExitSceneWithRotationRecoverCallback();
  }

  private registerSceneStartingInterceptorRules(): void {
    SCBSceneStartInterceptor.getInstance().registerInterceptorRule(this.interceptRuleForVassistant, this.screenId, this.panelId);
  }

  private unregisterSceneStartingInterceptorRules(): void {
    SCBSceneStartInterceptor.getInstance().unregisterInterceptorRule(this.interceptRuleForVassistant, this.screenId, this.panelId);
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Start Interceptor rules
  // ----------------------------------------------------------------------------------------------------

  private interceptRuleForVassistant = (_sceneInfo: SCBSceneInfo, _startFrom: StartInterceptions) => {
    return false;
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Mission Management
  // ----------------------------------------------------------------------------------------------------

  /**
   * add ShowWhenLocked Session into SpecialPanel
   * @param sessionList SCBSceneContainerSessionArray added.
   */
  public onTransferSceneIn(sessionList: SCBSceneContainerSessionArray): void {
    log.showInfo(`onTransferSceneIn SpecialScenePanel, count: ${sessionList?.length}`);
    if (!sessionList || sessionList.isEmpty()) {
      return;
    }
    let callerId : number = 0;
    let showContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray()
    const curActiveSessionCount = this.getActiveSceneContainerSessionCount(sessionList);
    log.showInfo('specialContainerSessions count: ' + this.specialContainerSessionList.length +
      ', and active session count: ' + curActiveSessionCount);
    if (curActiveSessionCount > 0) {
      for (let item of this.specialContainerSessionList) {
        if (this.isItemShowCanBeChanged(item, false)) {
          callerId = item.primarySession?.session?.persistentId ?? 0;
          log.showInfo('will update caller id:' + callerId);
          showContainerSessionList.push(item);
          item.isDisappearing = true;
          item.requestBackground();
        }
      }
    }

    let activeContainerSession: SCBSceneContainerSession | null = null;
    for (let item of sessionList) {
      log.showInfo('addShowWhenLockedSessionToSpecialPanel, name: ' + item.getName());
      item.primarySession?.setShowAboveKeyguard(true);
      if (item.isFloat) {
        this.setFloatingSceneToDefaultState(item);
      }
      if (this.isItemShowCanBeChanged(item, false)) {
        activeContainerSession = item;
        if (item.primarySession && callerId !== 0) {
          this.updateCallerSessionIdAndToSessionId(item.primarySession, callerId);
        }
        continue;
      }
      this.specialContainerSessionList.add(item);
    }
    if (activeContainerSession) {
      log.showInfo('add top active session: ' + activeContainerSession.getName());
      this.startSceneWithRotationIfNeed(activeContainerSession);
      this.specialContainerSessionList.add(activeContainerSession);
    }

    if (sessionList.length > 0) {
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
    let containerSession = this.getTopActiveSceneContainerSession();
    if (containerSession) {
      this.updateScenePanelState(ScenePanelState.FULLSCENE, containerSession.primarySession?.sceneInfo);
      let primarySession = containerSession.primarySession;
      if (primarySession && primarySession.session) {
        SCBSceneSessionManager.getInstance()
          .requestFocus(primarySession.session.persistentId, undefined, FocusChangeReason.MOVE_UP);
        if (SCBSceneUtils.isPhoneCallScene(primarySession.sceneInfo) && power.isActive()) {
          if (!(this.panelStateCollectionHandler?.getFoldStatus() === DeviceState.FOLDED_STATE)) {
            this.panelAnimator.animateOnPhoneCall(showContainerSessionList, containerSession);
          } else {
            for (let item of showContainerSessionList) {
              log.showInfo('ContainerSession remove after animation, id:' + item.primarySession?.session?.persistentId);
              item.isDisappearing = false;
            }
          }
          return;
        }
      } else if (containerSession.secondarySession && containerSession.secondarySession.session) {
        SCBSceneSessionManager.getInstance()
          .requestFocus(containerSession.secondarySession.session.persistentId, undefined, FocusChangeReason.MOVE_UP);
      }
    }
    for (let item of showContainerSessionList) {
      log.showInfo('showContainerSessionList remove callerId:' + item.primarySession?.session?.persistentId);
      item.isDisappearing = false;
    }
  }

  /**
   * remove ShowWhenLocked Session From SpecialPanel
   * @returns ContainerSession will be removed.
   */
  public onTransferSceneOut(): SCBSceneContainerSessionArray {
    log.showInfo('onTransferSceneOut SpecialScenePanel.');
    let ret = new SCBSceneContainerSessionArray();
    if (!SCBSceneSessionManager.getInstance().isScreenLocked()) {
      for (let i = 0; i < this.specialContainerSessionList.length; ++i) {
        let containerSessionItem = this.specialContainerSessionList[i];
        containerSessionItem.primarySession?.setTemporarilyShowWhenLocked(false);
        ret.add(containerSessionItem);
      }
      this.specialContainerSessionList.splice(0, this.specialContainerSessionList.length);
    } else {
      for (let i = this.specialContainerSessionList.length; i > 0; i--) {
        let item = this.specialContainerSessionList[i - 1];
        if (this.isItemShowCanBeChanged(item, true)) {
          ret.add(item);
          this.specialContainerSessionList.splice(i - 1, 1);
          SCBSceneSessionManager.getInstance().requestUnfocus(item?.primarySession?.session?.persistentId)
          log.showInfo('removeShowWhenLockedSessionFromSpecialPanel with item: ' + item.getName());
        }
      }
    }

    if (ret.length > 0) {
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
    if (this.getActiveSceneContainerSessionCount(this.specialContainerSessionList) === 0) {
      log.showInfo('removeSpecialShowWhenLockedSceneContainerSession updateScenePanelState to 0');
      this.updateScenePanelState(ScenePanelState.HOME);
    }
    return ret;
  }

  public buildRectForTransition(sceneContainerSession: SCBSceneContainerSession): SCBTransitionController {
    let screenLockInfo = SceneInfoAdapterUtil.getScreenLockInfo(sceneContainerSession);
    let controller = SCBTransitionManager.getInstance().findTransitionController(
      sceneContainerSession.primarySession?.sceneInfo.bundleName, () => {
      return screenLockInfo ? this.getAppDataForScreenLock(screenLockInfo) :
      PageDesktopModel.getInstance().getCloseAppData(sceneContainerSession.primarySession?.sceneInfo
        .bundleName, sceneContainerSession.primarySession?.sceneInfo.abilityName,
        sceneContainerSession.companionIconInfo?.startAppType);
    });
    //刷新companion信息
    if (screenLockInfo) {
      screenLockInfo.originIconInfo = screenLockInfo.callback?.getMinimizeIcon();
      log.info(`reset screenLockInfo ${screenLockInfo.originIconInfo.position.x}
        ${screenLockInfo.originIconInfo.position.y}`);
    }
    // 需要CompanionIcon消失，所以bundleName需要置空
    if (sceneContainerSession.companionIconInfo !== null) {
      sceneContainerSession.companionIconInfo.bundleName = '';
    }
    sceneContainerSession.addTransitionCount();
    let animationNum = sceneContainerSession.getTransitionCount();
    if (!this.screenProperty.isScreenVertical()) {
      this.shouldHideStatusBar = true;
      scbStatusBarVM.onIsBarShowByOpacity(false);
    }
    return controller;
  }

  public updateCallerSessionIdAndToSessionId(session: SCBSceneSession, newCallerPersistentId: number): void {
    if (!session || !session.sceneInfo) {
      log.showWarn('set caller persistentId, but null session or scene info.');
      return;
    }
    log.showInfo('currId = ' + session.sceneInfo.persistentId + ', oldId = ' + session.sceneInfo.callerPersistentId +
      ', newId = ' + newCallerPersistentId + ', toId = ' + session.sceneInfo.toPersistentId);
    if (newCallerPersistentId !== session.sceneInfo.callerPersistentId ||
      (newCallerPersistentId === session.sceneInfo.callerPersistentId && session.sceneInfo.toPersistentId !== 0)) {
      // from get session, reused
      this.linkCallerAndToPersistentForSession(session);
    }

    let newCallerId = newCallerPersistentId;
    let newCallerSession: SCBSceneSession | null = null;
    let size = 0;
    let totalListSize = this.specialContainerSessionList.length //+ this.containerSessionListNotShowRecent.length;
    while (newCallerId > 0 && newCallerId !== session.sceneInfo.persistentId && size <= totalListSize) {
      log.showDebug('getSceneSessionByPersistentId = ' + newCallerId);
      newCallerSession = this.getSceneSessionByPersistentId(newCallerId);
      if (newCallerSession && newCallerSession.sceneInfo) {
        newCallerId = newCallerSession.sceneInfo.toPersistentId;
      } else {
        break;
      }
      size++;
    }
    // refresh new caller session
    if (newCallerSession && newCallerSession.sceneInfo) {
      newCallerSession.sceneInfo.toPersistentId = session.sceneInfo.persistentId;
      session.sceneInfo.callerPersistentId = newCallerSession.sceneInfo.persistentId;
    } else {
      session.sceneInfo.callerPersistentId = 0;
    }
    // refresh self
    session.sceneInfo.toPersistentId = 0;
  }

  public linkCallerAndToPersistentForSession(session: SCBSceneSession): void {
    if (!session || !session.sceneInfo) {
      log.showWarn('linkCallerAndToPersistentForSession, session is null or scene info is null.');
      return;
    }
    log.showInfo(`linkCallerAndToPersistentForSession, callerId=${session.sceneInfo.callerPersistentId}
      , toId=${session.sceneInfo.toPersistentId}`);
    if (session.sceneInfo.callerPersistentId && session.sceneInfo.callerPersistentId > 0) {
      let callerSession = this.getSceneSessionByPersistentId(session.sceneInfo.callerPersistentId);
      if (callerSession && callerSession.sceneInfo) {
        callerSession.sceneInfo.toPersistentId = session.sceneInfo.toPersistentId;
      }
    }
    if (session.sceneInfo.toPersistentId && session.sceneInfo.toPersistentId > 0) {
      let toSession = this.getSceneSessionByPersistentId(session.sceneInfo.toPersistentId);
      if (toSession && toSession.sceneInfo) {
        toSession.sceneInfo.callerPersistentId = session.sceneInfo.callerPersistentId;
      }
    }
    session.sceneInfo.callerPersistentId = 0;
    session.sceneInfo.toPersistentId = 0;
  }

  public isItemShowCanBeChanged(item: SCBSceneContainerSession, isRemove: boolean): boolean {
    if (item == null) {
      log.showInfo('isItemShowCanBeChanged item is undefined or null');
      return false;
    }
    log.showInfo('session in current specialPanel persistent id: ' + item.getPersistentId() +
      ', isPhoneCall:' + SCBSceneUtils.isPhoneCallScene(item.primarySession?.sceneInfo) +
      ', isShowWhenLocked:' + item.isShowWhenLocked() +
      ', isActive:' + item.primarySession?.isActive);
    if (!isRemove && item.primarySession?.sceneInfo && item.isShowWhenLocked() &&
      item.primarySession?.isActive) {
      //加到锁屏上时，确保应用isActive为true
      log.showInfo('active item add to SpecialPanel');
      return true;
    } else if (isRemove && item.primarySession?.sceneInfo && !item.isShowWhenLocked()) {
      log.showInfo('item remove from SpecialPanel');
      return true;
    }
    return false;
  }

  public getSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    let specialSceneSessionTuple = this.specialContainerSessionList.getSceneSessionTupleBySceneInfo(sceneInfo, true);
    if (specialSceneSessionTuple && specialSceneSessionTuple[0]) {
      log.showInfo(`get sceneSession from specialScenePanel name: ${specialSceneSessionTuple[0].getName()}`);
      return specialSceneSessionTuple[0];
    }
    let sceneSessionTuple = SCBSceneSessionManager.getInstance()
      .getContainerSessionList()?.getSceneSessionTupleBySceneInfo(sceneInfo, true);
    if (sceneSessionTuple && sceneSessionTuple[0]) {
      log.showInfo(`get sceneSession from scenePanel name: ${sceneSessionTuple[0].getName()}`);
      return sceneSessionTuple[0];
    }
    let sceneFloatSessionTuple = SCBSceneSessionManager.getInstance()
      .getFloatingSessionList()?.getSceneSessionTupleBySceneInfo(sceneInfo, true);
    if (sceneFloatSessionTuple && sceneFloatSessionTuple[0]) {
      log.showInfo(`get sceneSession from float  name: ${sceneFloatSessionTuple[0].getName()}`);
      return sceneFloatSessionTuple[0];
    }
    return null;
  }

  public getActiveSceneContainerSessionCount(inputSessionList?: SCBSceneContainerSessionArray): number {
    if (inputSessionList) {
      return inputSessionList.filter((item) => {
        return item.isActive;
      }).length;
    }
    return this.specialContainerSessionList.filter((item) => {
      return item.isActive;
    }).length;
  }

  public getContainerSessionByPersistentIdOrContainerId(persistentId?: number,
    containerId?: number): SCBSceneContainerSession | null {
    if (persistentId) {
      return this.getSceneContainerSessionWithPersistentId(persistentId);
    } else if (containerId) {
      return this.getSceneContainerSessionWithContainerId(containerId);
    }
    return null;
  }

  public getSceneContainerSessionWithPersistentId(persistentId: number): SCBSceneContainerSession | null {
    const index = this.specialContainerSessionList.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });
    if (index === -1) {
      log.showWarn(`Failed to get scene containerSession with session id:${persistentId} from special panel`);
      return null;
    }
    log.showInfo(`Get containerSession with id:${persistentId} from special panel`);
    return this.specialContainerSessionList[index];
  }

  public getSceneContainerSessionWithContainerId(containerId: number): SCBSceneContainerSession | null {
    const index = this.specialContainerSessionList.findIndex(item => {
      return item.containerId === containerId;
    });
    if (index === -1) {
      log.showWarn(`Failed to find containerSession with id:${containerId} from special panel`);
      return null;
    }
    log.showInfo(`Find containerSession with id:${containerId} from special panel`);
    return this.specialContainerSessionList[index];
  }

  public getSessionFromFloatingScene(persistentId: number): SCBSceneContainerSession | null {
    let floatingSceneSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
    let index = floatingSceneSessionList.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId;
    });
    if (index !== -1) {
      return floatingSceneSessionList[index];
    }
    log.showWarn('Failed to getSessionFromFloatingScene with session id: ' + persistentId);
    return null;
  }

  public getSceneSessionByPersistentId(persistentId: number): SCBSceneSession | null {
    for (let i = 0; i < this.specialContainerSessionList.length; ++i) {
      let primarySession = this.specialContainerSessionList[i].primarySession;
      let secondarySession = this.specialContainerSessionList[i].secondarySession;
      if (primarySession && primarySession.session.persistentId === persistentId) {
        return primarySession;
      }
      if (secondarySession && secondarySession.session.persistentId === persistentId) {
        return secondarySession;
      }
    }
    return null;
  }

  public getTopActiveSceneContainerSession(): SCBSceneContainerSession | null {
    if (this.specialContainerSessionList.length === 0) {
      log.showWarn('Failed to find active scene container session with list length 0.');
      return null;
    }
    for (let i = this.specialContainerSessionList.length - 1; i >= 0; i--) {
      if (this.specialContainerSessionList[i].isActive) {
        return this.specialContainerSessionList[i];
      }
    }
    log.showError('no active session');
    return null;
  }

  /**
   * 创建SCBSceneSession
   *
   * @param sceneInfo
   * @returns SCBSceneSession or null
   */
  public createSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    try {
      let sceneSession = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
      if (sceneSession === null) {
        log.showWarn('createSceneSession return null');
        return null;
      }
      let scbSceneSession = new SCBSceneSession(sceneSession, sceneInfo);
      scbSceneSession.sessionData.isNewWant = false;
      return scbSceneSession;
    } catch (error) {
      log.showError(`requestSceneSession failed ${error}`);
    }
    return null;
  }

  /**
   * 最大化窗口
   *
   * @param persistentId
   * @param containerId
   * @returns void
   */
  public onMaximizeScene(persistentId?: number, containerId?: number) {
    log.showInfo(`onMaximizeScene with persistentId:${persistentId} containerId:${containerId}`);
    let currContainerSession =
      this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (!currContainerSession) {
      log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    if (!currContainerSession.isActive) {
      log.showWarn(`containerSession is already background:${persistentId}`);
      return;
    }
    for (let container of this.specialContainerSessionList) {
      if (container.containerId === currContainerSession.containerId) {
        if (currContainerSession.isSplit) {
          log.showError(`show when locked session cannot be split`);
          return;
        }
      } else {
        let windowMode = container.getContainerWindowMode();
        if (windowMode == SCBSceneMode.FULLSCREEN) {
          container.requestBackground();
        }
      }
    }
    currContainerSession.init();

    this.resetWindowEffect(currContainerSession);
  }

  /**
   * 更新panelState
   *
   * @param state
   * @param sceneInfo
   * @returns void
   */
  public updateScenePanelState(state: ScenePanelState, sceneInfo?: SCBSceneInfo) {
    let scenePanelState = this.panelStateCollectionHandler?.getPanelState();
    log.showInfo(`updateSceneState from ${scenePanelState} to ${state}`);
    const isChanged: boolean = scenePanelState != state;
    this.panelStateCollectionHandler?.updatePanelState(state);
    if (isChanged) {
      SCBSceneSessionManager.getInstance().updateKeyguardOccludedState(OccludeKeygaurdScene.SPECIAL,
        state == ScenePanelState.FULLSCENE);
    }
    if (sceneInfo && state === ScenePanelState.FULLSCENE) {
      SCBSceneSessionManager.getInstance().updateFullSceneEnd(sceneInfo.bundleName, sceneInfo.abilityName);
    }
  }

  /**
   * 根据persistentId清空session的callerPersistentId
   *
   * @param persistentId
   * @returns void
   */
  public clearCallerPersistentIdForSession(persistentId: number | undefined): void {
    log.showInfo('clear session caller persistentId for ' + persistentId);
    if (!persistentId) {
      return;
    }
    if (persistentId > 0) {
      let session = this.getSceneSessionByPersistentId(persistentId);
      if (session && session.sceneInfo) {
        session.sceneInfo.callerPersistentId = 0;
        log.showInfo('clear session callerPersistentId = 0 for ' + persistentId);
      }
    }
  }

  /**
   * 根据persistentId清空session的toPersistentId
   *
   * @param persistentId
   * @returns void
   */
  public clearToPersistentIdForSession(persistentId: number): void {
    log.showInfo('clear session to persistentId for ' + persistentId);
    if (persistentId > 0) {
      let session = this.getSceneSessionByPersistentId(persistentId);
      if (session && session.sceneInfo) {
        session.sceneInfo.toPersistentId = 0;
        log.showInfo('clear session toPersistentId = 0 for ' + persistentId);
      }
    }
  }

  public succeedBackToCaller(containerSession: SCBSceneContainerSession, persistentId: number | undefined): boolean {
    if (!containerSession && !persistentId) {
      log.showWarn(`containerSession or persistentId is empty`);
      return false;
    }
    const sceneSession: SCBSceneSession | null = containerSession.primarySession;
    const callerPersistentId: number | undefined = sceneSession?.sceneInfo?.callerPersistentId;
    log.showInfo(`succeedBackToCaller persistentId:${persistentId} callerPersistentId:${callerPersistentId}`);
    if (callerPersistentId === undefined || callerPersistentId === 0) {
      log.showWarn(`callerPersistentId is undefined or 0`);
      return false;
    }
    let callerContainerSession: SCBSceneContainerSession | null =
      this.getSceneContainerSessionWithPersistentId(callerPersistentId);
    if (callerContainerSession === null || callerPersistentId === persistentId) {
      log.showWarn(`callerContainerSession is null or callerPersistentId = persistentId`);
      return false;
    }
    if (sceneSession?.sceneInfo?.isPhoneCall()) {
      this.raiseSceneToTop(callerContainerSession);
      callerContainerSession.requestActivation(false);
      this.startSceneWithRotationIfNeed(callerContainerSession);
      this.sceneContainerTransitionForPhoneCall(containerSession, callerContainerSession, true, false, false);
    } else {
      log.showInfo(`succeedBackToCaller callerContainerSession ${callerContainerSession.getName()}`);
      this.raiseSceneToTop(callerContainerSession);
      callerContainerSession.requestActivation(false);
      this.startSceneWithRotationIfNeed(callerContainerSession);
      this.panelAnimator.sceneContainerAppTransitionChange(containerSession, callerContainerSession, true, false);
    }
    this.clearCallerPersistentIdForSession(persistentId);
    this.clearToPersistentIdForSession(callerPersistentId);
    return true;
  }

  public onLockReceived(): void {
    log.showInfo('onLockReceived');
    if (SCBWindowRotateController.getInstance().isDesktopRotatable()) {
      return;
    }
    let activeSession = this.getTopActiveSceneContainerSession();
    // no active container session, change to physical screen
    if (!activeSession) {
      log.showInfo('no activeSession, begin rotation recover');
      this.exitSceneWithRotationRecover(this.isVerticalExit());
    }
  }

  public onUnLockReceived(): void {
  }

  public onMinimizeScene(persistentId?: number, containerId?: number) {
    log.showInfo(`onMinimizeScene with persistentId:${persistentId} containerId:${containerId}`);
    let containerSession =
      this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (!containerSession) {
      log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    if (!containerSession.isActive) {
      log.showWarn(`containerSession is already background:${persistentId}`);
      return;
    }
    if (containerSession.isSplit) {
      log.showError(`show when locked session cannot be split`);
      return;
    } else {
      if (this.succeedBackToCaller(containerSession, persistentId)) {
        log.showInfo(`succeedBackToCaller success`);
        return;
      }
      this.requestSceneContainerBackgroundWithTransition(containerSession);
      this.updateScenePanelState(ScenePanelState.HOME);
    }
  }

  public requestSceneContainerBackgroundWithTransition(sceneContainerSession: SCBSceneContainerSession,
    isMoveRollback: boolean = false) {
    sceneContainerSession.requestBackgroundWithTransitionOut();
    this.panelAnimator.sceneContainerTransitionOut(sceneContainerSession, isMoveRollback);
  }
  private getSceneContainerSessionWithPersistentIdFromLock(persistentId: number): SCBSceneContainerSession | null {
    let containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    if (containerSession) {
      return containerSession;
    }
    containerSession = SCBSceneSessionManager.getInstance().getSceneContainerSessionFromScenePanel(persistentId);
    if (containerSession) {
      if (containerSession.isSplit) {
        SCBSceneSessionManager.getInstance().exitSplitView(persistentId);
        containerSession = SCBSceneSessionManager.getInstance().getSceneContainerSessionFromScenePanel(persistentId);
        let removeResult = SCBSceneSessionManager.getInstance().removeSceneContainerSession(containerSession);
        log.showInfo('getSceneContainer from scene panel in split, persistentId=' + persistentId + '+ removeResult=' +
          removeResult);
      } else if (containerSession.isMidScene) {
        SCBSceneSessionManager.getInstance().exitMidScene(persistentId);
        containerSession = SCBSceneSessionManager.getInstance().getSceneContainerSessionFromScenePanel(persistentId);
        let removeResult = SCBSceneSessionManager.getInstance().removeSceneContainerSession(containerSession);
        log.showInfo('getSceneContainer from scene panel in midScene, persistentId=' + persistentId + '+ removeResult=' +
          removeResult);
      } else {
        let removeResult = SCBSceneSessionManager.getInstance().removeSceneContainerSession(containerSession);
        log.showInfo('getSceneContainer from scene panel float state=' + containerSession.isFloat + '， persistentId=' +
          persistentId + 'removeResult=' + removeResult);
      }
      return containerSession;
    }
    return null;
  }

  private onStartSceneFromScreenLockIcon(sceneInfo: SCBSceneInfoFromScreenLock): void {
    log.showInfo(`onStartSceneFromScreenLockIcon sceneInfo: ${sceneInfo.persistentId} bundle: ${sceneInfo.bundleName}`);
    if (SCBSceneStartInterceptor.getInstance().shouldIntercept(sceneInfo, StartInterceptions.FROM_ICON, this.screenId, this.panelId)) {
      return;
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_1);
    let sceneSession = this.requestSceneSession(sceneInfo);
    if (sceneSession == null) {
      log.showError('Failed to request scene session' + '!');
      return;
    }
    sceneSession.setTemporarilyShowWhenLocked(true);
    sceneSession.setShowAboveKeyguard(true);
    sceneSession.setUseStartingWindowAboveLocked(true);
    let sceneContainerSession =
      this.getSceneContainerSessionWithPersistentIdFromLock(sceneSession.session.persistentId);
    if (sceneContainerSession === null) {
      sceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
      log.showInfo('start scene add new session: ' + sceneContainerSession.containerId);
    } else {
      if (sceneContainerSession?.isFloat) {
        this.setFloatingSceneToDefaultState(sceneContainerSession);
      }
      sceneInfo.updateSceneInfo(sceneSession?.sceneInfo);
      sceneContainerSession.primarySession?.updateSceneInfo(sceneInfo);
    }
    let info = SceneInfoAdapterUtil.getScreenLockInfo(sceneContainerSession);
    if (info) {
      info.originIconInfo = sceneInfo.originIconInfo;
    }
    log.showInfo(`onStartSceneFromScreenLockIcon with sceneInfo: ${sceneContainerSession?.containerId} ${sceneContainerSession?.primarySession?.isTemporarilyShowWhenLocked}`);

    //动画前准备
    let transitionController = SCBTransitionManager.getInstance()
      .findTransitionController(sceneInfo.bundleName, () => {
        return this.getAppDataForScreenLock(sceneInfo);
      });

    sceneContainerSession.initCompanionIconInfo(sceneInfo, transitionController);
    //锁屏的
    this.startSceneWithRotationIfNeed(sceneContainerSession);
    this.updateScenePanelState(ScenePanelState.FULLSCENE);
    this.panelStateCollectionHandler?.updateShowCompanionIconState(true);
    if (sceneInfo.moveStartingOption) {
      SceneInfoAdapterUtil.getScreenLockInfo(sceneContainerSession)?.updateMoveStartingOption(
        sceneInfo.moveStartingOption);
      this.setProxyToScreenLock(sceneInfo, sceneContainerSession);
      sceneSession.setSessionTouchable(false);
      scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_SCREENLOCK_CAMERA, true);
    } else {
      SceneInfoAdapterUtil.getScreenLockInfo(sceneContainerSession)?.clearMoveStartingOption();
    }
    this.panelAnimator.sceneContainerTransitionIn(sceneContainerSession, transitionController, sceneSession);
  }

  public destroyScreenLockIcon(sceneContainerSession: SCBSceneContainerSession, isVerify: boolean) {
    let info = SceneInfoAdapterUtil.getScreenLockInfo(sceneContainerSession);
    if (!info) {
      return;
    }
    if (isVerify && info.moveStartingOption) {
      return;
    }
    sceneContainerSession.isScreenLockIconShow = false;
    log.showInfo('isScreenLockIconShow false');
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Rotation
  // ----------------------------------------------------------------------------------------------------

  /**
   * Handle Orientation requested change.
   * @param persistentId id of scene.
   * @param requestedOrientation target orientation
   */
  public onContainerRequestedOrientationChange(persistentId: number, requestedOrientation: number): void {
    let containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    if (!containerSession) {
      log.showError('cannot find container Session with persistentId: ' + persistentId);
      return;
    }
    if (containerSession.primarySession?.session.persistentId === persistentId) {
      containerSession.primarySession.sessionData.requestOrientation = requestedOrientation;
    } else if (containerSession.secondarySession?.session.persistentId === persistentId) {
      containerSession.secondarySession.sessionData.requestOrientation = requestedOrientation;
    } else {
      log.showError('cannot find scene Session with persistentId: ' + persistentId);
      return;
    }
    let newRequestedOrientation = containerSession.getContainerRequestOrientation();
    log.showInfo('onContainerRequestedOrientationChange Convert requested orientation from  : ' +
      containerSession.requestOrientation + ' to: ' + newRequestedOrientation);
    containerSession.sessionData.requestOrientation = newRequestedOrientation;
    if (containerSession.isActive) {
      // 10 represents the max limit of consecutive setPreferredOrientation
      if (SCBWindowRotate.getInstance().getRotateAnimationCnt() > 10 ||
        this.rotationAnimCnt > 10 || (this.panelStateCollectionHandler?.getScreenRotationAnimCnt() ?? 0) > 10) {
        log.showWarn('onContainerRequestedOrientationChange animCnt reaches the max limits, rotationAnimCnt: ' +
        this.rotationAnimCnt + ' screenRotationAnimCnt: ' +
        this.panelStateCollectionHandler?.getScreenRotationAnimCnt());
        return;
      }
      this.startSceneWithRotationIfNeed(containerSession, true, true);
    } else {
      // no need to rotation if no active session
      log.showInfo('onContainerRequestedOrientationChange no active session name: ' +
      containerSession.primarySession?.sceneInfo.bundleName +
        ' isActive: ' + containerSession.isActive + ' from: ' + containerSession.requestOrientation + ' to: ' +
        newRequestedOrientation);
    }
  }

  /**
   * Handle rotation with animation.
   * @param screenProperty screen property.
   * @param reason reason of rotation.
   */
  public notifyRotationWithAnimation(screenProperty: SCBScreenProperty, reason: SCBContainerRotationReason): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotationWithAnimation] reason: %{public}i, screenProperty: left=%{public}i,' +
      ' top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i', reason, screenProperty.left,
      screenProperty.top, screenProperty.width, screenProperty.height, screenProperty.rotation);
    this.rotationAnimationBegin(screenProperty);
    let rotationWindow =
      SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_BEGIN);
    let rotateDuration: number = 300;
    SCBSceneSessionManager.getInstance().updateRotateAnimationConfig(rotateDuration);
    let rotationStartTime = Date.now();
    transactionManager.openSyncTransaction(screenProperty.screenId);
    SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateSizeChangeReason(screenProperty,
      sceneSessionManager.SessionSizeChangeReason.ROTATION);
    let inVisibleSystemSceneCallbacks: [Function, boolean, number | null][] = [];
    this.setRotateFinishTimer(rotationStartTime, screenProperty);
    animateTo({
      duration : rotateDuration,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish:()=>{
        this.rotationAnimationFinished(rotationStartTime, screenProperty);
      }
    }, () => {
      this.updateScreenSessionWhenRotate(screenProperty, reason);
      SCBScreenSessionManager.getInstance().updateVisibleSystemRotationBeforeScenePanel(screenProperty);
      this.updateScenePanelWhenRotate(screenProperty, reason, undefined);
      // start scene need inform after start animation
      inVisibleSystemSceneCallbacks = SCBScreenSessionManager.getInstance().updateVisibleSystemRotation(screenProperty);
      SCBWindowRotateController.getInstance().updateRotationWindow(rotationWindow);
    });
    SCBScreenSessionManager.getInstance().updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks, screenProperty);
    transactionManager.closeSyncTransaction(screenProperty.screenId);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotationWithAnimation] Update Rotation screenProperty, left=%{public}i,' +
      ' top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i', this.screenProperty.left,
      this.screenProperty.top, this.screenProperty.width, this.screenProperty.height, this.screenProperty.rotation);
  }

  private rotationAnimationBegin(screenProperty: SCBScreenProperty): void {
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty,
      SCBRotateChangeReason.ROTATE_BEGIN);
    SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty,
      SCBRotateChangeReason.ROTATE_BEGIN);
    this.rotationAnimCnt++;
    if (screenProperty.rotation === 0 && this.screenProperty.rotation === RotationConstants.ROTATION_270) {
      // avoid animation 270, 240, 210 ... 30, 0, should play from 90->0
      // change current Rotation
      this.screenProperty.rotation = -RotationConstants.ROTATION_90;
    } else if (screenProperty.rotation === RotationConstants.ROTATION_270 &&
      this.screenProperty.rotation === RotationConstants.ROTATION_0) {
      // avoid animation 0, 30, 60 ... 270, should play from 360->270
      this.screenProperty.rotation = RotationConstants.ROTATION_360;
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotationAnimationBegin] scbScreenProperty before animation rotation: ' +
    this.screenProperty.rotation + ' targetRotation: ' + screenProperty.rotation +
      ' rotationAnimCnt:' + this.rotationAnimCnt);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, StyleConstants.DEFAULT_1);
    SCBSceneSessionManager.getInstance().prepareSystemSceneRotationBeforeAnimation(screenProperty.rotation);
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' screen lock need hide desktop');
      viewMgrPolicy.hideView(ViewType.DESKTOP);
    }
    this.keyboardSession?.setKeyboardRotationFlag(true);
    this.panelStateCollectionHandler?.updateBlackBackgroundState(true);
  }

  private setRotateFinishTimer(rotationStartTime: number, screenProperty: SCBScreenProperty): void {
    if (this.rotateFinishTimerId !== -1) {
      clearTimeout(this.rotateFinishTimerId);
    }
    this.rotateFinishTimerId = setTimeout(() => {
      this.rotationAnimationFinished(rotationStartTime, screenProperty, true);
      this.rotateFinishTimerId = -1;
    }, 3000);
  }

  private rotationAnimationFinished(rotationStartTime: number, screenProperty: SCBScreenProperty,
    isTimeoutCheck: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, `[rotationAnimationFinished] animCnt:${this.rotationAnimCnt} timeout:${isTimeoutCheck}`);
    SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_END);
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
    let rotationDuration = Date.now() - rotationStartTime;
    HiDfxEventUtil.reportScenePanelRotationEnd(rotationStartTime.toFixed(), this.screenProperty.screenId,
      this.panelStateCollectionHandler?.getPanelName(), rotationDuration);
    if (this.rotationAnimCnt === 0) {
      SCBScreenSessionManager.getInstance().notifyScreenRotateToCallbacks(screenProperty,
        SCBRotateChangeReason.ROTATE_END);
      SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty,
        SCBRotateChangeReason.ROTATE_END);
      SCBSceneSessionManager.getInstance().notifySystemSceneToUpdateSizeChangeReason(screenProperty,
        sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      this.panelStateCollectionHandler?.updateBlackBackgroundState(false);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.SCREEN_RORATION, StyleConstants.DEFAULT_0);
      if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, ' ROTATE_END screen lock need show desktop');
        viewMgrPolicy.showView(ViewType.DESKTOP);
      }
    }
    this.keyboardSession?.setKeyboardRotationFlag(false);
  }

  private processRotateExpand(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) {
    this.screenProperty.copy(screenProperty);
    this.panelStateCollectionHandler?.getViewParam()?.onScreenChange(this.screenProperty, reason);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[processRotateExpand] onScreenChange viewParam: ' +
      JSON.stringify(this.panelStateCollectionHandler?.getViewParam()) + ' reason: ' + reason +
      ' screenProperty: ' + JSON.stringify(screenProperty));
    for (let containerSession of this.specialContainerSessionList) {
      if (containerSession === this.expandStartContainerSession) {
        containerSession?.updateContainerSessionWithFold(this.screenProperty, reason);
        this.expandStartContainerSession = null;
        continue;
      }
      if (!containerSession?.isActive && (reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION ||
        reason === SCBPropertyChangeReason.FOLD_LANDSCAPE_START ||
        reason === SCBPropertyChangeReason.PAGE_ROTATION)) {
        continue;
      }
      containerSession?.updateContainerSessionWithFold(this.screenProperty, reason);
    }
    if (this.expandStartContainerSession !== null) {
      this.expandStartContainerSession.updateContainerSessionWithFold(this.screenProperty, reason);
      this.expandStartContainerSession = null;
    }
  }

  private processChangeMode(screenProperty: SCBScreenProperty) {
    let oldScreenProperty = new SCBScreenProperty();
    oldScreenProperty.copy(this.screenProperty);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[processChangeMode] oldScreenProperty:' + JSON.stringify(oldScreenProperty) +
                 ' newScreenProperty:' + JSON.stringify(screenProperty));
    this.screenProperty.copy(screenProperty);
    this.physicalScreenProperty.copy(this.screenProperty);

    let viewParam = this.panelStateCollectionHandler?.getViewParam();
    if (viewParam) {
      viewParam.recentW = viewParam.recentW * screenProperty.width / oldScreenProperty.width;
      viewParam.recentH = viewParam.recentH * screenProperty.height / oldScreenProperty.height;
    }

    for (let containerSession of this.specialContainerSessionList) {
      log.showInfo('Update containerSession: ' + containerSession?.containerId + ' name:' +
      containerSession?.primarySession?.sceneInfo.bundleName + ' isActive: ' + containerSession?.isActive);
      containerSession?.updateContainerSessionWithActiveMode(oldScreenProperty, screenProperty);
    }
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(this.screenProperty);
    SCBScreenSessionManager.getInstance().updateSystemActiveModeChange(oldScreenProperty, screenProperty);
  }

  public exitSceneWithRotationRecover(isVerticalExit: boolean,
    currentSession?: SCBSceneContainerSession | null): void {
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    let isExistTopActiveSession = this.getTopActiveSceneContainerSession() ||
      containerSessionList.getTopActiveSession();
    if (isExistTopActiveSession && !ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD_BOUNCER)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] no need to recover if exist top active scene!');
      return;
    }
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] notifyRotation screenSession is null');
      return;
    }
    if (SCBWindowRotateController.getInstance().isDesktopRotatable()) {
      if (!screenSession) {
        WinLog.showError(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] notifyRotation screenSession is null');
        return;
      }
      let targetRotation = screenSession.getTargetScreenRotationWhenAppExit();
      let isForce = (targetRotation !== screenSession.scbScreenProperty.rotation);
      SCBWindowRotateController.getInstance().windowRotateEntry(targetRotation, 'specialScenePanelExitScene',
        true, isForce);
      return;
    }
    let targetRotation: number = 0;
    if (isVerticalExit) {
      WinLog.showDebug(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] no need to recover with vertical Exit!');
      return;
    }
    let targetScreenProperty = this.screenProperty.getRotatedScreenProperty(0);
    if (targetScreenProperty.rotation === this.screenProperty.rotation) {
      WinLog.showDebug(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] name' +
        currentSession?.primarySession?.sceneInfo.bundleName + ' no need notify rotation targetRotation: ' +
        targetRotation + ' sensorRotation: ' + screenSession.sensorScreenProperty.rotation +
        ' currentScreenRotation: ' + this.screenProperty.rotation + ' currentRotation: ' +
        currentSession?.currentRotation);
      return;
    }
    this.notifyRotation(targetScreenProperty, true, SCBContainerRotationReason.EXIT_SCENE, currentSession);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[exitSceneWithRotationRecover] targetRotation: ' + targetRotation +
      ' sensorRotation: ' + screenSession.sensorScreenProperty.rotation + ' currentRotation: ' +
    this.screenProperty.rotation);
  }

  private notifyRotation(screenProperty: SCBScreenProperty, needUpdateSystem: boolean,
    reason: SCBContainerRotationReason, currentContainer?: SCBSceneContainerSession | null): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotation] reason: %{public}i, screenProperty: left=%{public}i,' +
      ' top=%{public}i, width=%{public}i, height=%{public}i, rotation=%{public}i', reason, screenProperty.left,
      screenProperty.top, screenProperty.width, screenProperty.height, screenProperty.rotation);
    SCBScreenSessionManager.getInstance().updateScreenRotationProperty(screenProperty,
      SCBRotateChangeReason.UNSPECIFIED);
    this.updateScreenSessionWhenRotate(screenProperty, reason);
    this.updateScenePanelWhenRotate(screenProperty, reason, currentContainer);
    if (needUpdateSystem) {
      // start scene need inform after start animation
      SCBScreenSessionManager.getInstance().updateSystemRotation(screenProperty);
    }
    SCBWindowRotateController.getInstance().notifyRotationChange(screenProperty, SCBRotateChangeReason.ROTATE_END);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[notifyRotation] Update Rotation screenProperty:[ ' + this.screenProperty.left +
      ' ' + this.screenProperty.top + ' ' + this.screenProperty.width +
      ' ' + this.screenProperty.height + '] rotation: ' + this.screenProperty.rotation);
  }

  public updateScreenSessionWhenRotate(screenProperty: SCBScreenProperty, reason: SCBContainerRotationReason) {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[updateScreenSessionWhenRotate] screenSession is null');
      return;
    }
    // screen rotation no need to change bounds in screen session
    // rotation with start/exit scene need change bounds since screen session cannot know
    if (reason !== SCBContainerRotationReason.SCREEN_ROTATION) {
      screenSession.updateVirtualProperty(screenProperty, SCBPropertyChangeReason.ROTATION, false);
    }
  }

  public updateScenePanelWhenRotate(screenProperty: SCBScreenProperty,
    reason: SCBContainerRotationReason, currentContainer?: SCBSceneContainerSession | null): void {
    this.screenProperty.copy(screenProperty);
    this.panelStateCollectionHandler?.getViewParam()?.onScreenChange(screenProperty, SCBPropertyChangeReason.ROTATION);
    if (currentContainer) {
      // start scene with exact container rotation
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateScenePanelWhenRotate] Update currentContainer: ' + currentContainer?.containerId + 
                   ' name:' + currentContainer?.primarySession?.sceneInfo.bundleName + ' isActive: ' + 
                   currentContainer.isActive + ' currScreenProperty: ' + JSON.stringify(this.screenProperty));
      currentContainer?.updateContainerSessionWithRotation(this.screenProperty, reason);
    } else {
      // rotation with whole screen
      for (let containerSession of this.specialContainerSessionList) {
        if (!containerSession.isActive) {
          // need to set inactive container not rotate
          continue;
        }
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateScenePanelWhenRotate] Update containerSession: ' + containerSession.containerId + 
                     ' name:' + containerSession.primarySession?.sceneInfo.bundleName + ' isActive: ' + 
                     containerSession.isActive);
        containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      }
    }
  }

  public isVerticalExit(): boolean {
    return this.screenProperty.rotation === RotationConstants.ROTATION_0 ||
      this.screenProperty.rotation === RotationConstants.ROTATION_360;
  }

  public needMinimizeActiveContainer(currContainer: SCBSceneContainerSession,
    activeSceneContainerSession: SCBSceneContainerSession): boolean {
    if (!activeSceneContainerSession || !currContainer) {
      return false;
    }
    if (currContainer.containerId === activeSceneContainerSession.containerId) {
      return false;
    }
    // need to consider split
    let windowMode = currContainer.getContainerWindowMode();
    let activeContainerMode = activeSceneContainerSession.getContainerWindowMode();
    if (windowMode === SCBSceneMode.FULLSCREEN && activeContainerMode === SCBSceneMode.FULLSCREEN) {
      return true;
    }
    return false;
  }

  public startSceneWithRotationIfNeed(containerSession: SCBSceneContainerSession,
    needAnimation: boolean = false, fromUser: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[startSceneWithRotationIfNeed] start scene with rotation if need');
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!this.handlePreconditions(screenSession, containerSession)) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[startSceneWithRotationIfNeed] preconditions are not met.');
      return;
    }
    let targetRotation = this.getTargetRotationWhenStartScene(containerSession, screenSession, fromUser);
    if (SCBWindowRotateController.getInstance().isDesktopRotatable()) {
      this.rotateScreenPolicy(containerSession, needAnimation, screenSession, fromUser, targetRotation);
    } else {
      this.rotateWindowPolicy(containerSession, fromUser, targetRotation, screenSession, needAnimation);
    }
  }

  private handlePreconditions(screenSession: SCBScreenSession, containerSession: SCBSceneContainerSession): boolean {
    if (!screenSession) {
      log.showError('notifyRotation screenSession is null');
      return false;
    }
    if (!containerSession) {
      log.showError('startSceneWithRotationIfNeed containerSession is null');
      return false;
    }
    return true;
  }

  // 屏幕启动旋转
  private rotateScreenPolicy(containerSession: SCBSceneContainerSession, needAnimation: boolean,
    screenSession: SCBScreenSession, fromUser: boolean, targetRotation: number): void {
    log.showInfo('SCBSpecialScenePanel startSceneWithRotationIfNeed ExpandStatus rotation:' + targetRotation);
    this.expandStartContainerSession = containerSession;
    const screenRotation = SCBScreenSessionManager.getInstance().getScreenRotation(this.screenProperty.screenId);
    // 应用当前角度不等于目标角度，或者当前屏幕角度不等于目标角度时，需要强制旋转
    let isForce: boolean = (containerSession.currentRotation !== targetRotation || targetRotation !== screenRotation);
    if (needAnimation && screenSession.isRotateScreenPolicy()) {
      containerSession.currentRotation = targetRotation;
    }
    SCBWindowRotateController.getInstance().windowRotateEntry(targetRotation, 'specialScenePanelStartScene',
      needAnimation, isForce);
    this.expandStartContainerSession = null;
  }

  private rotateWindowPolicy(containerSession: SCBSceneContainerSession, fromUser: boolean, targetRotation: number,
    screenSession: SCBScreenSession, needAnimation: boolean) {
    if (this.screenProperty.rotation === targetRotation && containerSession.currentRotation === targetRotation) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateWindowPolicy]  no need to rotate with same targetRotation: ' + targetRotation +
        ' sensorRotation: ' + screenSession.sensorScreenProperty.rotation + ' currentScreenRotation: ' +
      this.screenProperty.rotation + ' currentContainerRotation: ' + containerSession.currentRotation);
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[rotateWindowPolicy] before rotate with targetRotation: ' +
      targetRotation + ' sensorRotation: ' + screenSession.sensorScreenProperty.rotation + ' currentScreenRotation: ' +
      this.screenProperty.rotation + ' currentContainerRotation: ' + containerSession.currentRotation +
      ' name: ' + containerSession.primarySession?.sceneInfo.bundleName);

    let screenProperty: SCBScreenProperty = this.screenProperty.getRotatedScreenProperty(targetRotation);
    if (needAnimation) {
      this.notifyRotationWithAnimation(screenProperty, SCBContainerRotationReason.START_SCENE);
    } else {
      // change this.screenProperty with screenProperty
      this.notifyRotation(screenProperty, true, SCBContainerRotationReason.START_SCENE, containerSession);
    }
  }

  private getTargetRotationWhenStartScene(containerSession: SCBSceneContainerSession,
    screenSession: SCBScreenSession, fromUser: boolean): number {
    let targetRotation = containerSession.getTargetRotation(screenSession.sensorScreenProperty.rotation, fromUser);
    if (!containerSession.currentRotation) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[getTargetRotationWhenStartScene] currentRotation is 0, name=%{public}s',
        containerSession.getName());
      containerSession.currentRotation = 0;
    }
    if (!fromUser && containerSession.isRelatedToUserRotationPolicy() &&
      targetRotation !== containerSession.currentRotation) {
      targetRotation = containerSession.currentRotation;
      let rotationPolicyMap = SCBDeviceScreenConfig.getInstance().getRotationPolicyMap();
      if (!rotationPolicyMap.get(targetRotation)) {
        targetRotation = RotationConstants.ROTATION_0;
      }
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[getTargetRotationWhenStartScene] change targetRotation=%{public}i', targetRotation);
    }
    return targetRotation;
  }

  public getAppDataForScreenLock(sceneInfo: SCBSceneInfoFromScreenLock): AppData {
    let findData: AppData = {
      bundleName: sceneInfo.bundleName,
      abilityName: sceneInfo.abilityName,
      appIconId: '',
      iconRadius: 0,
      appIconNumber: 0,
      cardId: '',
      startAppType: SCBSceneSessionManager.getInstance().isScreenLocked() ? StartType.SCREEN_LOCK_TOOLS : StartType.APP,
      extraId: ''
    };
    log.info(`this is test findData ${JSON.stringify(findData)}`);
    return findData;
  }

  public createAppStartIcon(sessionContainer :SCBSceneContainerSession, isSetRadius: boolean,
    isMoveStartingIcon: boolean, movingIconOption: MoveStartingOption | null = null): void {
    let screenLockInfo = SceneInfoAdapterUtil.getScreenLockInfo(sessionContainer);
    if (!screenLockInfo) {
      return;
    }
    let iconRectInfo = this.buildRectFromScreenLock(sessionContainer, isMoveStartingIcon, movingIconOption);
    if (iconRectInfo) {
      let shortPxSize = Math.min(this.screenProperty.width, this.screenProperty.height);
      let shortWidth = px2vp(shortPxSize);
      sessionContainer.needRenderClip.setClipHeight(shortPxSize);
      sessionContainer.needRenderClip.setClipWidth(sessionContainer.needRenderClip.clipHeight);
      let newRectInfo = sessionContainer.covertWithRotation(iconRectInfo);
      let iconSize = iconRectInfo.right - iconRectInfo.left;
      sessionContainer.needRenderScale.setScaleXWithDfx(iconSize / shortWidth * screenLockInfo.originIconInfo.scale,
        TAG, 'createAppStartIcon', sessionContainer.getName());
      sessionContainer.needRenderScale.setScaleYWithDfx(iconSize / shortWidth * screenLockInfo.originIconInfo.scale,
        TAG, 'createAppStartIcon', sessionContainer.getName());
      let radius = screenLockInfo.originIconInfo.borderRadius / (iconSize / shortWidth);
      sessionContainer.companionIconInfo.iconRadius = radius;
      if (isSetRadius) {
        // sessionContainer.needRenderBorderRadius.setBorderRadiusWithDfx(radius, TAG, 'createAppStartIcon',
        //   sessionContainer.getName());
        sessionContainer.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'createAppStartIcon',
          sessionContainer.getName());
      }
      sessionContainer.needRenderTranslate.setTranslateXWithDfx(newRectInfo.left + (iconSize - shortWidth) / 2, TAG,
        'createAppStartIcon', sessionContainer.getName());
      // 2: width divider
      sessionContainer.needRenderTranslate.setTranslateYWithDfx(newRectInfo.top + (iconSize - shortWidth) / 2, TAG,
        'createAppStartIcon', sessionContainer.getName());
    }
  }

  public buildRectFromScreenLock(sessionContainer: SCBSceneContainerSession, isStartPosition: boolean,
    movingIconOption: MoveStartingOption | null = null): RectInfo {
    let iconRectInfo = new RectInfo();
    let screenLockInfo = SceneInfoAdapterUtil.getScreenLockInfo(sessionContainer);
    if (!screenLockInfo) {
      return iconRectInfo;
    }
    let iconInfo = screenLockInfo.originIconInfo;
    let movingOption = movingIconOption ? movingIconOption : screenLockInfo.moveStartingOption;
    if (isStartPosition && movingOption) {
      iconRectInfo.left = movingOption.iconPosition.x;
      iconRectInfo.top = movingOption.iconPosition.y;
      iconRectInfo.right = movingOption.iconPosition.x + iconInfo.bgWidth * movingOption.iconScale;
      iconRectInfo.bottom = movingOption.iconPosition.y + iconInfo.bgHeight * movingOption.iconScale;
    } else {
      iconRectInfo.left = iconInfo.position.x;
      iconRectInfo.top = iconInfo.position.y;
      iconRectInfo.right = iconInfo.position.x + iconInfo.bgWidth;
      iconRectInfo.bottom = iconInfo.position.y + iconInfo.bgHeight;
    }
    sessionContainer.companionIconInfo.iconRadius = iconInfo.borderRadius;
    log.info(`creat rect from screenlock left ${iconRectInfo.left} top ${iconRectInfo.top} right ${iconRectInfo.right}
      bottom${iconRectInfo.bottom} iconRadius ${sessionContainer.companionIconInfo.iconRadius}`);
    return iconRectInfo;
  }

  public sendInfoToScreenLock(screenLockInfo: SCBSceneInfoFromScreenLock): void {
    if (screenLockInfo) {
      screenLockInfo.callback?.minimizeFinish();
      log.info(`minimizeFinish. screenLockInfo ${screenLockInfo.persistentId}`);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_0);
    }
  }

  public setFloatingSceneToDefaultState(containerSession: SCBSceneContainerSession) {
    containerSession.floatingParam.needEffectComponent = true;
    containerSession.isFloat = false;
    let displayOrientation = containerSession.sessionData?.requestOrientation;
    containerSession.floatingParam.isShowTitleBar = false;
    containerSession.currentRotation = this.screenProperty.rotation;
    containerSession.screenProperty.copy(this.screenProperty);
    containerSession.width = new ScbNumber(this.screenProperty.width);
    containerSession.height = new ScbNumber(this.screenProperty.height);
    containerSession.primarySession?.updateCurRectForMultiWindowToFull(this.screenProperty);
    containerSession.changeState(SCBSceneContainerState.FULL_SCREEN);
    containerSession.sessionData.requestOrientation = displayOrientation;
    containerSession.primarySession?.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    this.updateScenePanelState(ScenePanelState.FULLSCENE);
  }

  // ----------------------------------------------------------------------------------------------------
  // Screen Property
  // ----------------------------------------------------------------------------------------------------

  /**
   * Handle ScreenProperty Change.
   * @param screenProperty target property.
   * @param reason reason.
   */
  onScreenPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    log.showInfo('onScreenPropertyChange reason:' + reason);
    if (reason === SCBPropertyChangeReason.ROTATION) {
      if (this.screenProperty.rotation === screenProperty.rotation) {
        WinLog.showWarn(WinLogDomain.WMS_ROTATION, '[onScreenPropertyChange] no need to rotation. targetRotation:' + 
                      screenProperty.rotation + ' currentScreenRotation: ' + this.screenProperty.rotation);
        return;
      }

      this.notifyRotationWithAnimation(screenProperty, SCBContainerRotationReason.SCREEN_ROTATION);
    } else if (reason === SCBPropertyChangeReason.CHANGE_MODE) {
      this.processChangeMode(screenProperty);
    } else if (reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION ||
      reason === SCBPropertyChangeReason.PAGE_ROTATION ||
      reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD ||
      reason === SCBPropertyChangeReason.FOLD_LANDSCAPE_START) {
      this.processRotateExpand(screenProperty, reason);
    }
  }

  /**
   * 根据sceneInfo 获取对应sceneSession，并更新调用链、更新want
   *
   * @param sceneInfo: SCBSceneInfo
   * @returns SCBSceneSession | null
   */
  public requestSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    if (sceneInfo && sceneInfo.persistentId && sceneInfo.persistentId != 0) {
      // start from other app
      log.showInfo('using exist persistentId: ' + sceneInfo.persistentId);
      let scbSceneSession = this.getSceneSessionByPersistentId(sceneInfo.persistentId);
      if (scbSceneSession === null) {
        log.showInfo('not find , new a scene session');
        scbSceneSession = this.createSceneSession(sceneInfo);
      } else {
        scbSceneSession.sceneInfo.requestId = sceneInfo.requestId;
      }

      log.showInfo(`update callerPersistentId1:${sceneInfo.callerPersistentId}`);
      if (scbSceneSession != null && sceneInfo.callerPersistentId) {
        this.updateCallerSessionIdAndToSessionId(scbSceneSession, sceneInfo.callerPersistentId);
      }
      return scbSceneSession;
    } else {
      if (sceneInfo && sceneInfo.callerPersistentId && sceneInfo.callerPersistentId != 0) {
        log.showInfo('new scene session');
        let scbSceneSession = this.createSceneSession(sceneInfo);
        if (scbSceneSession != null) {
          this.updateCallerSessionIdAndToSessionId(scbSceneSession, sceneInfo.callerPersistentId);
        }
        return scbSceneSession;
      } else {
        // start from launcher
        let scbSceneSession = this.getSceneSession(sceneInfo);
        if (scbSceneSession) {
          scbSceneSession.sceneInfo.requestId = sceneInfo.requestId;
        }
        if (scbSceneSession == null || sceneInfo.isNewInstance) {
          let scbSceneSession = this.createSceneSession(sceneInfo);
          if (scbSceneSession != null) {
            this.updateCallerSessionIdAndToSessionId(scbSceneSession, 0);
          }
          return scbSceneSession;
        }

        log.showInfo(`update callerPersistentId2:${sceneInfo.callerPersistentId}`);
        if (sceneInfo.want !== null) {
          log.showInfo('update want persistentId: ' + scbSceneSession.sceneInfo.persistentId);
          sceneSessionManager.updateSceneSessionWant({
            bundleName: scbSceneSession.sceneInfo.bundleName,
            moduleName: scbSceneSession.sceneInfo.moduleName,
            abilityName: scbSceneSession.sceneInfo.abilityName,
            appIndex: scbSceneSession.sceneInfo.appIndex,
            persistentId: scbSceneSession.sceneInfo.persistentId
          }, sceneInfo.want, sceneInfo.requestId);
        }
        this.updateCallerSessionIdAndToSessionId(scbSceneSession, 0);
        return scbSceneSession;
      }
    }
  }

  /**
   * 向 specialContainerSessionList 添加 SCBSceneContainerSession
   *
   * @param sceneContainerSession: SCBSceneContainerSession
   * @returns void
   */
  public addSpecialSceneContainerSession(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    const index = this.specialContainerSessionList.findIndex(item => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index === -1) {
      log.showInfo('Add special scene container session, id: (' +
      sceneContainerSession.containerId + ', ' + sceneContainerSession.primarySession?.session?.persistentId + ')');
      this.specialContainerSessionList.push(sceneContainerSession);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
  }

  /**
   * 从 specialContainerSessionList 删除 SCBSceneContainerSession
   *
   * @param sceneContainerSession: SCBSceneContainerSession | null
   * @returns void
   */
  public removeSpecialSceneContainerSession(sceneContainerSession: SCBSceneContainerSession | null): void {
    if (!sceneContainerSession) {
      return;
    }
    const index = this.specialContainerSessionList.findIndex(item => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index !== -1) {
      log.showInfo('Remove special scene container session, id: (' +
      sceneContainerSession.containerId + ', ' + sceneContainerSession.primarySession?.session?.persistentId + ')');
      this.specialContainerSessionList.splice(index, 1);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
  }

  /**
   * 销毁指定的containerSession，从specialContainerSessionList移除，如果list为空，更新panel状态为HOME,最后旋转退出
   *
   * @param persistentId?: number, containerId?: number
   * @returns void
   */
  public onDestroyScene(persistentId?: number, containerId?: number): void {
    log.showInfo(`onDestroyScene with persistentId:${persistentId} containerId:${containerId}`);
    let containerSession = this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (containerSession) {
      containerSession.requestDestruction(true);
    }
    this.removeSpecialSceneContainerSession(containerSession);
    if (this.specialContainerSessionList.length == 0) {
      this.updateScenePanelState(ScenePanelState.HOME);
    }
    this.exitSceneWithRotationRecover(this.isVerticalExit(), containerSession);
  }

  /**
   * 关闭指定的containerSession，设置IsShowBlackBackground为false，从List移除containerSession，如果list为空，更新panel状态为HOME
   *
   * @param persistentId?: number, containerId?: number
   * @returns void
   */
  public onCloseScene(persistentId?: number, containerId?: number): void {
    log.showInfo(`onCloseScene with persistentId:${persistentId} containerId:${containerId}`);
    // recover transparent background when session exception
    this.panelStateCollectionHandler?.updateBlackBackgroundState(false);
    let containerSession = this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (!containerSession) {
      log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    containerSession?.requestDestruction(true, true);
    this.removeSpecialSceneContainerSession(containerSession);
    this.exitSceneWithRotationRecover(this.isVerticalExit(), containerSession);

    if (this.getActiveSceneContainerSessionCount(this.specialContainerSessionList) === 0) {
      this.updateScenePanelState(ScenePanelState.HOME);
    }
  }

  /**
   * 缩小所有窗口，返回桌面，设置panelState为HOME
   *
   * @param persistentId?: number, containerId?: number
   * @returns void
   */
  public minimizeAllScene(): void {
    log.showInfo(`onMinimizeAllScene`);
    this.specialContainerSessionList.forEach((sceneContainerSession) => {
      if (!sceneContainerSession.isActive) {
        return;
      }
      this.panelAnimator.sceneContainerTransitionOut(sceneContainerSession);
      sceneContainerSession.requestBackgroundWithTransitionOut();
    })
    this.updateScenePanelState(ScenePanelState.HOME);
  }

  // ----------------------------------------------------------------------------------------------------
  // Window Layout
  // ----------------------------------------------------------------------------------------------------

  /**
   * 重置窗口radius属性
   *
   * @param containerSession
   * @returns void
   */
  private resetWindowEffect(containerSession: SCBSceneContainerSession) {
    if (containerSession.primarySession) {
      containerSession.primarySession.floatBorderRadius = 0;
      containerSession.primarySession.shadowConfig.radius = 0;
    }

    if (containerSession.secondarySession) {
      log.showError(`show when locked session cannot be split`);
      return;
    }
  }

  // ----------------------------------------------------------------------------------------------------
  // Phone Call
  // ----------------------------------------------------------------------------------------------------

  private sceneContainerTransitionForPhoneCall(fromContainerSession: SCBSceneContainerSession,
    toContainerSession: SCBSceneContainerSession | null,
    isBackTransition: boolean, needRemoveSession: boolean,
    needTerminate: boolean = true): void {
    if (!fromContainerSession) {
      log.showWarn(`fromContainerSession is empty`);
      return;
    }
    let duration = PhoneCallAnimationConstants.PHONE_CALL_TRANSITION_TO_DURATION;
    if (isBackTransition) {
      duration = PhoneCallAnimationConstants.BACK_TRANSITION_DURATION;
      if (needTerminate) {
        // animation not need calc icon pos with rotation, thus can clear session data before animation
        fromContainerSession?.requestDestructionWithTransitionOut(needRemoveSession, false);
      } else {
        fromContainerSession?.requestBackgroundWithTransitionOut();
      }
      // 通话页面回胶囊，采用回胶囊动效
      if (OverlayStartAnimHelper.checkStartOverlayTransitionOut({
        scenePanelManager: this.panelMgr,
        containerSession: fromContainerSession,
        needRemoveSession: needRemoveSession,
        triggerType: OverlayStartAnimHelper.TRIGGER_TYPE_APP_BACK_TO_CAPSULE
      })) {
        log.showInfo(`checkStartOverlayTransitionOut animation for callui`);
        return;
      }
    }
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(0);
    this.startPhoneCallFromAnim(fromContainerSession, duration, isBackTransition, needRemoveSession);
    this.startPhoneCallToAnim(toContainerSession, duration, isBackTransition);
  }

  /**
   * 通话页面来源session动画开启
   *
   * @param fromContainerSession 来源session
   * @param duration 动画时长
   * @param isBackTransition 是否页面返回
   * @param needRemoveSession 动效结束是否移除session
   */
  private startPhoneCallFromAnim(fromContainerSession: SCBSceneContainerSession, duration: number,
    isBackTransition: boolean, needRemoveSession: boolean): void {
    fromContainerSession.addTransitionCount();
    let fromAnimationCount = fromContainerSession.getTransitionCount();
    animateTo({
      duration: (isBackTransition ? PhoneCallAnimationConstants.BACK_TRANSITION_DELAY :
      PhoneCallAnimationConstants.PHONE_CALL_TRANSITION_DELAY) + duration,
      curve: Curve.FastOutLinearIn,
      onFinish: () => {
        if (fromAnimationCount === fromContainerSession.getTransitionCount()) {
          if (isBackTransition && fromContainerSession.pendingRemove && needRemoveSession) {
            if (this.panelStateCollectionHandler?.getPanelState() !== ScenePanelState.RECENT) {
              fromContainerSession.needRenderBorderRadius.
              setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
                TAG, 'sceneContainerTransitionForPhoneCall', fromContainerSession.getName());
            }
            this.panelMgr.removeSceneContainerSession(fromContainerSession);
          }
          fromContainerSession.transitionOutFinish();
        }
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.SPECIAL_START_PHONE_CALL_FROM_ANIM);
      }
    }, () => {
      TraceUtil.startTrace(DomainName.SCB, TraceUtil.SPECIAL_START_PHONE_CALL_FROM_ANIM);
      if (isBackTransition) {
        fromContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'sceneContainerTransitionForPhoneCall',
          fromContainerSession.getName());
      }
    })
  }

  /**
   * 通话页面目标session动画开启
   *
   * @param toContainerSession 目标session
   * @param duration 动画时长
   * @param isBackTransition 是否页面返回
   */
  private startPhoneCallToAnim(toContainerSession: SCBSceneContainerSession | null, duration: number,
    isBackTransition: boolean): void {
    if (toContainerSession) {
      // 目标界面初始化，然后从透明度0开始播放淡入动画
      toContainerSession.init();
      toContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(
        0, TAG, 'startPhoneCallToAnim', toContainerSession.getName());
      toContainerSession.addTransitionCount();
      let toAnimationCount = toContainerSession.getTransitionCount();
      animateTo({
        duration: duration,
        delay: isBackTransition ? PhoneCallAnimationConstants.BACK_TRANSITION_DELAY :
        PhoneCallAnimationConstants.PHONE_CALL_TRANSITION_DELAY,
        curve: Curve.FastOutSlowIn,
        onFinish: () => {
          if (toAnimationCount === toContainerSession.getTransitionCount()) {
            if (this.panelStateCollectionHandler?.getPanelState() !== ScenePanelState.RECENT) {
              toContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
                TAG, 'sceneContainerTransitionForPhoneCall', toContainerSession.getName());
            }
            toContainerSession.clearTransitionCount();
          }
          TraceUtil.endTrace(DomainName.SCB, TraceUtil.SPECIAL_START_PHONE_CALL_TO_ANIM);
          AnimateToScheduleUtils.raiseAnimateToSchedulePriority(1);
        }
      }, () => {
        TraceUtil.startTrace(DomainName.SCB, TraceUtil.SPECIAL_START_PHONE_CALL_TO_ANIM);
        toContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'sceneContainerTransitionForPhoneCall',
          toContainerSession.getName());
      });
    }
  }

  private isPhoneCallScene(sceneInfo: SCBSceneInfo): boolean {
    if (!sceneInfo) {
      return false;
    }

    let phoneSceneList: sceneSessionManager.SceneInfo[] = [
      { bundleName: 'com.ohos.callui', moduleName: '', abilityName: 'com.ohos.callui.MainAbility', appIndex: 0 },
      { bundleName: 'com.ohos.meetimeservice', moduleName: '', abilityName: 'CallUIKitAbility', appIndex: 0 }
    ];

    for (let item of phoneSceneList) {
      if (sceneInfo.bundleName === item.bundleName && sceneInfo.abilityName === item.abilityName) {
        return true;
      }
    }

    return false;
  }

  // ----------------------------------------------------------------------------------------------------
  // Startup Animation
  // ----------------------------------------------------------------------------------------------------


  // ----------------------------------------------------------------------------------------------------
  // Window Lifecycle
  // ----------------------------------------------------------------------------------------------------

  public onStartSceneFromOther(sceneInfo: SCBSceneInfo): CommonResult {
    log.showInfo('[SCBMain]onStartSceneFromOther with sceneInfo:' + sceneInfo?.toJsonString());
    if (SCBSceneStartInterceptor.getInstance().shouldIntercept(sceneInfo, StartInterceptions.FROM_OTHER, this.screenId, this.panelId)) {
      return CommonResult.FAIL;
    }
    let sceneSession = this.requestSceneSession(sceneInfo);
    if (sceneSession == null) {
      log.showError('Failed to request scene session!');
      return CommonResult.FAIL;
    }
    let activeSceneContainerSession = this.getTopActiveSceneContainerSession();
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      sceneSession.requestSessionActivation(sceneSession.isNewWant);
      if (sceneSession.isActive) {
        log.showInfo('onStartSceneFromOther, floating sceneSession is active!');
        return CommonResult.SUCCESS;
      }
      log.showInfo('onStartSceneFromOther, should start floating window');
      sceneSession.setVisibility(true);
      SCBSceneSessionManager.getInstance()
        .requestToTop(this.screenProperty.screenId, sceneSession.session.persistentId,
          SCBWindowRaiseReason.SCENE_START);
      return CommonResult.SUCCESS;
    }
    let sceneContainerSession =
      this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
    if (sceneContainerSession === null) {
      sceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
      this.addSpecialSceneContainerSession(sceneContainerSession);
      sceneContainerSession.primarySession?.setTemporarilyShowWhenLocked(true);
      sceneContainerSession.requestActivation()
      log.showInfo('start scene add new session: ' + sceneContainerSession.containerId);
    }
    this.startSceneWithRotationIfNeed(sceneContainerSession);
    if (CloseAppManager.getInstance().getStartAppType() !== StartType.CARD || this.isPhoneCallScene(sceneInfo) ||
      !sceneContainerSession.isActive) {
      sceneContainerSession.requestActivation(sceneSession.isNewWant);
      sceneSession.sessionData.isNewWant = true;
    }
    // whether minimize/show former scene && update scenePanelState
    if (activeSceneContainerSession &&
    this.needMinimizeActiveContainer(sceneContainerSession, activeSceneContainerSession)) {
      let activeSession = activeSceneContainerSession.primarySession;
      if (activeSession !== null && activeSession.session !== null) {
        // set caller persistentId to top active id, when press back key will jump to this top id not desktop.
        this.updateCallerSessionIdAndToSessionId(sceneSession, activeSession.session.persistentId);
      }
      if (this.isPhoneCallScene(sceneInfo) && activeSceneContainerSession !== null) {
        // for phone call, show the former scene during transition
        activeSceneContainerSession.requestBackground();
        this.raiseSceneToTop(sceneContainerSession);
        return CommonResult.SUCCESS;
      } else {
        activeSceneContainerSession?.requestBackground();
        this.raiseSceneToTop(sceneContainerSession);
        this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE, sceneContainerSession.primarySession?.sceneInfo);
        sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'startSceneFromOther', sceneContainerSession.getName());
      }
    } else {
      // don't need minimize former scene
      log.showInfo('onStartSceneFromOther do not need minimize former scene');
      this.raiseSceneToTop(sceneContainerSession);
      this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE, sceneContainerSession.primarySession?.sceneInfo);
      sceneContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG, 'startSceneFromOther2', sceneContainerSession.getName());
    }
    return CommonResult.SUCCESS;
  }

  public onSceneStartTransition(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo): void { // full to full
    log.showError(`SCBSpecialScenePanel onSceneStartTransition`);
    log.showInfo('onSceneTransition with toSceneInfo:' + toInfo?.toJsonString());
    log.showInfo('onSceneTransition with fromInfo:' + fromInfo?.toJsonString());
    if (SCBSceneStartInterceptor.getInstance().shouldIntercept(toInfo, StartInterceptions.FROM_TRANSITION, this.screenId, this.panelId)) {
      return;
    }
    if (!fromInfo) {
      log.showError('fromInfo is null');
      return;
    }
    let topActiveSceneSession = this.getTopActiveSceneContainerSession();
    let toSceneSession = this.requestSceneSession(toInfo);
    if (toSceneSession === null) {
      log.showError('toSceneSession is null');
    }
    let fromSceneSession = this.getSceneSessionByPersistentId(fromInfo.persistentId);
    if (fromSceneSession === null) {
      log.showError('fromSceneSession is null');
    }
    if (toSceneSession === null || fromSceneSession === null) {
      log.showError('Failed to get toSceneSession: ' + toInfo?.toJsonString() + ' or fromSceneSession: ' +
        fromInfo?.toJsonString());
      return;
    }

    // Floating scene should minimize
    if (fromSceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      // FULLSCREEN is foreground only refresh
      if (topActiveSceneSession && topActiveSceneSession.primarySession?.isActive &&
        topActiveSceneSession.primarySession?.session.persistentId === toSceneSession.session.persistentId) {
        topActiveSceneSession.requestActivation(topActiveSceneSession.primarySession?.isNewWant);
        return;
      }
    }
    // Start scene is floating
    if (toSceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      // foreground only refresh
      if (toSceneSession.isActive || toSceneSession.visibility) {
        toSceneSession.requestSessionActivation(toSceneSession.isNewWant);
        log.showInfo('Floating isActive, only refresh');
        return;
      }
    }

    let fromContainerSession =
      this.getSceneContainerSessionWithPersistentId(fromSceneSession.session.persistentId) ??
      this.getSessionFromFloatingScene(fromSceneSession.session.persistentId);
    let toContainerSession =
      this.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId) ??
      this.getSessionFromFloatingScene(toSceneSession.session.persistentId);
    if (fromContainerSession === null) {
      log.showError('Failed to get fromContainerSceneSession: ' + fromInfo?.toJsonString());
      return;
    }

    if (toContainerSession === null) {
      toContainerSession = new SCBSceneContainerSession(toSceneSession, this.screenProperty);
      this.addSpecialSceneContainerSession(toContainerSession);
      log.showInfo('start scene add new containerSession: ' + toContainerSession.containerId);
    }
    this.startSceneWithRotationIfNeed(toContainerSession);
    toContainerSession.requestActivation(toSceneSession.isNewWant);
    toSceneSession.sessionData.isNewWant = true;
    this.raiseSceneToTop(toContainerSession);
    this.enterFullSceneOrHomeView(ScenePanelState.FULLSCENE, toContainerSession.primarySession?.sceneInfo);
    if (toInfo.windowMode === SCBSceneMode.FLOATING) {
      log.showInfo('Do not requestBackground for floating window');
      return;
    }
    if (topActiveSceneSession && this.needMinimizeActiveContainer(toContainerSession, topActiveSceneSession)) {
      log.showInfo('topActiveSceneSession requestBackground');
      topActiveSceneSession.requestBackground();
    }
    this.panelAnimator.sceneContainerAppTransitionChange(fromContainerSession, toContainerSession, false, false);
  }

  public onTerminateScene(persistentId?: number, containerId?: number): void {
    log.showInfo(`onTerminateScene with persistentId:${persistentId} containerId:${containerId}`);
    let containerSession =
      this.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
    if (!containerSession) {
      log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    if (!containerSession.isActive) {
      containerSession.requestDestruction(true);
      this.removeSpecialSceneContainerSession(containerSession);
      return;
    }
    if (containerSession.isSplit) {
      log.showError(`show when locked session cannot be split`);
      return;
    }
    if (this.panelStateCollectionHandler?.getPanelState() === ScenePanelState.HOME) {
      log.showWarn('specialScenePanelState is HOME');
      containerSession.requestDestruction(true);
      this.removeSpecialSceneContainerSession(containerSession);
      return;
    }

    let sceneSession = persistentId ? this.getSceneSessionByPersistentId(persistentId) : null;
    let sceneInfo: SCBSceneInfo | null = sceneSession ? sceneSession.sceneInfo : null;
    log.showInfo(`sceneInfo.callerPersistentId:${sceneInfo?.callerPersistentId}`);

    //  if sceneInfo.callerPersistentId is 0, the app is not started by other app, need return to desktop
    if (sceneInfo === null || sceneInfo.callerPersistentId === 0) {
      containerSession.requestDestruction(true);
      this.removeSpecialSceneContainerSession(containerSession);
      this.updateScenePanelState(ScenePanelState.HOME);
      this.exitSceneWithRotationRecover(this.isVerticalExit(), containerSession);
      return;
    }

    if (this.succeedBackToCaller(containerSession, persistentId)) {
      SCBSceneSessionManager.getInstance()
        .requestFocus(sceneInfo.callerPersistentId, undefined, FocusChangeReason.SCB_START_APP);
    } else {
      let callerFromScenePanel =
        SCBSceneSessionManager.getInstance().getSceneContainerSessionFromScenePanel(sceneInfo.callerPersistentId);
      if (callerFromScenePanel && sceneInfo.callerPersistentId) {
        log.showDebug(`caller find in scenePanel: ${sceneInfo.callerPersistentId}`);
      }
      this.updateScenePanelState(ScenePanelState.HOME);
    }
    containerSession.requestDestruction(true);
    this.removeSpecialSceneContainerSession(containerSession);
  }

  public registerGetScenePanelStateCallback() : void {
    SCBSceneSessionManager.getInstance().registerGetScenePanelStateCallback(this.screenProperty.screenId,
      SCBDefaultZIndex.SPECIAL_SCENE_PANEL, () => {
        return this.panelStateCollectionHandler?.getPanelState();
      });
  }

  private enterFullSceneOrHomeView(state: ScenePanelState, sceneInfo?: SCBSceneInfo) {
    log.showInfo('enterFullSceneOrHomeView');
    this.initView();
    this.updateScenePanelState(state, sceneInfo);
  }

  // ----------------------------------------------------------------------------------------------------
  // Window Level
  // ----------------------------------------------------------------------------------------------------

  public raiseSceneToTop(sceneContainerSession: SCBSceneContainerSession): void {
    log.showInfo('raiseSceneToTop.');

    // To move the sceneContainerSession to the last of list.
    this.removeSpecialSceneContainerSession(sceneContainerSession);
    this.addSpecialSceneContainerSession(sceneContainerSession);
  }

  // ----------------------------------------------------------------------------------------------------
  // Common
  // ----------------------------------------------------------------------------------------------------

  private initView(): void {
    this.panelStateCollectionHandler?.getViewParam()?.initAll();
    this.specialContainerSessionList.forEach((containerSession) => {
      containerSession.init();
    });
  }

  // ----------------------------------------------------------------------------------------------------
  // Keyguard Tools
  // ----------------------------------------------------------------------------------------------------

  public onTransitionInactiveFromScreenLock(sessionSession :SCBSceneContainerSession): void {
    const screenLockInfo = SceneInfoAdapterUtil.getScreenLockInfo(sessionSession);
    let startingOption = screenLockInfo?.moveStartingOption;
    let windowScale: number = startingOption ? startingOption.windowScale : 1.0;
    let sessionSessionName = sessionSession.getName();
    sessionSession.needRenderScale.setScaleXWithDfx(windowScale, TAG, 'onTransitionInactiveFromScreenLock',
      sessionSessionName);
    sessionSession.needRenderScale.setScaleYWithDfx(windowScale, TAG, 'onTransitionInactiveFromScreenLock',
      sessionSessionName);
    sessionSession.cardScale = 1.0;
    sessionSession.needRenderClip.setClipHeight(this.screenProperty.height);
    sessionSession.needRenderClip.setClipWidth(this.screenProperty.width);
    if (startingOption) {
      sessionSession.needRenderTranslate.setTranslateXWithDfx(startingOption.windowTranslateX, TAG,
        'onTransitionInactiveFromScreenLock', sessionSessionName);
      sessionSession.needRenderTranslate.setTranslateYWithDfx(startingOption.windowTranslateY, TAG,
        'onTransitionInactiveFromScreenLock', sessionSessionName);
    } else {
      sessionSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'onTransitionInactiveFromScreenLock',
        sessionSessionName);
      sessionSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'onTransitionInactiveFromScreenLock',
        sessionSessionName);
    }

    sessionSession.needRenderTranslateIcon.translateIconX = 0;
    sessionSession.needRenderTranslateIcon.translateIconY = 0;
  }

  private setProxyToScreenLock(sceneInfo: SCBSceneInfoFromScreenLock, sessionSession: SCBSceneContainerSession): void {
    log.showInfo('setProxyToScreenLock name:' + sessionSession.getName());
    let proxy: SceneProxyToScreenLock = {
      onOverThresholdMovingWindow: (scale: number, translateXRatio: number, translateYRatio: number): void => {
        this.onOverThresholdMovingWindow(sessionSession, scale, translateXRatio, translateYRatio);
      },
      onCrossingThresholdChanged: (isOverThreshold: boolean): void => {
        this.onCrossingThresholdChanged(sessionSession, isOverThreshold);
      },
      onRollbackMovingWindow: (movingOption: MoveStartingOption): void => {
        this.onRollbackMovingWindow(sessionSession, movingOption);
      },
      onEndMoveWindow: (isOpen: boolean): void => {
        this.endMoveWindow(sessionSession, isOpen);
      }
    }
    sceneInfo.callback?.onSceneProxyReady(proxy);
  }

  private onOverThresholdMovingWindow(sessionSession: SCBSceneContainerSession, scale: number,
    translateX: number, translateY: number): void {
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_1);
    animateTo({
      curve: curves.springMotion(0.25, 1, 0),
      onFinish: () => {
        // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_0);
      }
    }, () => {
      sessionSession.addTransitionCount();
      let sessionSessionName = sessionSession.getName();
      let reason = 'overThresholdMovingWindow';
      sessionSession.needRenderScale.setScaleXWithDfx(scale, TAG, reason, sessionSessionName);
      sessionSession.needRenderScale.setScaleYWithDfx(scale, TAG, reason, sessionSessionName);
      sessionSession.needRenderTranslate.setTranslateXWithDfx(translateX, TAG, reason, sessionSessionName);
      sessionSession.needRenderTranslate.setTranslateYWithDfx(translateY, TAG, reason, sessionSessionName);
    });
  }

  private onCrossingThresholdChanged(sessionSession: SCBSceneContainerSession, isOverThreshold: boolean): void {
    let sessionSessionName = sessionSession.getName();
    log.showInfo('onCrossingThresholdChanged isOverThreshold:' + isOverThreshold + ', ' + sessionSessionName);
    if (isOverThreshold) {
      animateTo({
        curve: curves.springMotion(0.285, 1.157, 0)
      }, () => {
        sessionSession.addTransitionCount();
        this.onTransitionInactiveFromScreenLock(sessionSession);
        sessionSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
          'onCrossingThreshold', sessionSessionName);
        sessionSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'onCrossingThreshold', sessionSessionName);
        sessionSession.iconAlpha = 0.0;
      });
    } else {
      animateTo({
        curve: curves.springMotion(0.285, 1.157, 0)
      }, () => {
        sessionSession.addTransitionCount();
        this.createAppStartIcon(sessionSession, true, true);
        sessionSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG, 'onCrossingThreshold', sessionSessionName);
        sessionSession.iconAlpha = 1.0;
      });
    }
  }

  private onRollbackMovingWindow(sessionSession: SCBSceneContainerSession, movingOption: MoveStartingOption): void {
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_1);
    animateTo({
      curve: curves.springMotion(0.25, 1, 0),
      onFinish: () => {
        // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_0);
      }
    }, () => {
      sessionSession.addTransitionCount();
      this.createAppStartIcon(sessionSession, true, true, movingOption);
    });
  }

  private endMoveWindow(containerSession: SCBSceneContainerSession, isOpen: boolean): void {
    log.showInfo('endMoveWindow isOpen:' + isOpen);
    scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_SCREENLOCK_CAMERA, false);
    containerSession.primarySession?.setSessionTouchable(true);
    SceneInfoAdapterUtil.getScreenLockInfo(containerSession)?.clearMoveStartingOption();
    if (isOpen) {
      // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, StyleConstants.DEFAULT_0);
      let sceneInfo = SceneInfoAdapterUtil.getScreenLockInfo(containerSession);
      if (!sceneInfo) {
        log.showInfo('endMoveWindow sceneInfo is invalid');
        return;
      }
      let transitionController = SCBTransitionManager.getInstance()
        .findTransitionController(sceneInfo.bundleName, () => {
          return this.getAppDataForScreenLock(sceneInfo as SCBSceneInfoFromScreenLock);
        });
      transitionController?.onActive('endMoveWindow');
      containerSession.addTransitionCount();
      let animationNum = containerSession.getTransitionCount();
      animateToImmediately({
        curve: curves.springMotion(0.285, 1.157, 0),
        onFinish: () => {
          let isLastAnimation = containerSession.transitionInFinishIfNeed(animationNum);
          if (isLastAnimation) {
            this.destroyScreenLockIcon(containerSession, false);
          }
        },
      }, () => {
        this.onTransitionInactiveFromScreenLock(containerSession);
      })
    } else {
      this.requestSceneContainerBackgroundWithTransition(containerSession, true);
      const curActiveSessionCount = this.getActiveSceneContainerSessionCount(this.specialContainerSessionList);
      log.showInfo(`endMoveWindow isNotOpen curActiveSessionCount:${curActiveSessionCount}`);
      if (curActiveSessionCount <= 0) {
        this.updateScenePanelState(ScenePanelState.HOME);
      }
    }
  }
}
