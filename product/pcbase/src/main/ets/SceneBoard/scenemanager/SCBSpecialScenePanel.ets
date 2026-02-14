/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, SingleContext, } from '@ohos/basicutils';
import {
  ConfigurationEvent, DeviceHelper, EventManager,
  EvtBus,
} from '@ohos/frameworkwrapper';
import {
  SCBConstants,
  SceneConstants,
} from '@ohos/commonconstants';
import {
  SystemSessionInfo,
  SCBSystemSceneSession,
  SCBContainerRotationReason,
  SCBPropertyChangeReason,
  SCBSceneInfo,
  SCBScreenSessionManager,
  FocusChangeReason,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBSceneContainerSessionArray,
  SCBScreenProperty,
  SCBSceneSessionManager,
  SCBEventId,
  ScenePanelState as SCBScenePanelState,
  SCBScreenSession,
  SCBSpecificSession,
  SCBSceneSession,
  ScbNumber,
  SCBSessionRect,
  sSCBOobeManager,
  SCBSceneInfoFromScreenLock,
  SystemBarType,
  CommonResult,
  SceneInfoAdapterUtil
} from '@ohos/windowscene';
import { SCBSceneContainer } from './SCBSceneContainer';
import { StyleConstants } from '@ohos/launchercommon';
import sceneSessionManager from '@ohos.sceneSessionManager'
import { SCBDefaultZIndex } from './SCBScreen';
import display from '@ohos.display';
import {
  SCBSessionListManager,
  SCBSceneHelper,
  SCBPcScenePanelManager,
  SCBFreeWindowsViewModelManager
} from '@ohos/pcmode';
import { curves } from '@kit.ArkUI';

const TAG = 'SCBSpecialScenePanel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

// fullscene & float
export enum ScenePanelState {
  HOME,
  FULLSCENE,
  FLOAT_SCENE
}

@Component
export struct SCBSpecialScenePanel {
  @Link screenProperty: SCBScreenProperty;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProperty.screenId };
  @State specialContainerSessionList: SCBSceneContainerSessionArray =
    SCBSessionListManager.getSpecialContainerArray(this.screenProperty);
  @State scenePanelState: ScenePanelState = ScenePanelState.HOME;
  @State isExitSplit: boolean = false;
  private screenDpiDensity: number = -1;
  private getScreenDpiDensity: Function = (): number => this.onQueryScreenDensityDpi();
  getSpecialContainerSessionListCallback = (): SCBSceneContainerSessionArray => {
    return this.specialContainerSessionList;
  }
  private systemSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PANEL,
    sceneName: TAG,
    sceneZIndex: SCBDefaultZIndex.SPECIAL_SCENE_PANEL,
    isFocusable: false,
    isTouchable: true,
    isRotatable: false,
    privacyMode: false,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.PANEL_SCENE,
  };
  private sysSceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.systemSessionInfo);

  private startSceneFromOtherCallback = (sceneInfo: SCBSceneInfo) => {
    return this.onStartSceneFromOther(sceneInfo);
  }

  private getSceneContainerSessionWithPersistentId(persistentId: number | undefined): SCBSceneContainerSession | null {
    const index = this.specialContainerSessionList.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });
    if (index === -1) {
      log.showWarn('Failed to get scene containerSession with session id: ' + persistentId);
      return null;
    }
    return this.specialContainerSessionList[index];
  }

  private getSceneContainerSessionWithContainerId(containerId: number | undefined):
    SCBSceneContainerSession | undefined {
    const index = this.specialContainerSessionList.findIndex(item => {
      return item.containerId === containerId;
    });
    if (index === -1) {
      log.showWarn(`Failed to find containerSession with id:${containerId}`)
      return;
    }
    return this.specialContainerSessionList[index];
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
      } else {
        let removeResult = SCBSceneSessionManager.getInstance().removeSceneContainerSession(containerSession);
        log.showInfo('getSceneContainer from scene panel float state=' + containerSession.isFloat + '， persistentId=' +
          persistentId + 'removeResult=' + removeResult);
      }
      return containerSession;
    }
    return null;
  }

  onStartSceneFromOther(sceneInfo: SCBSceneInfo): CommonResult {
    if (!sceneInfo || sceneInfo.persistentId === undefined) {
      log.showWarn('Failed to get scene containerSession because sceneInfo or persistentId is undefined.');
      return CommonResult.FAIL;
    }
    let sceneContainerSession = SCBSceneSessionManager.getInstance().getSpecialContainerSessionList()
      .findByPersistentId(sceneInfo.persistentId);
    if (!sceneContainerSession) {
      log.showError('sceneContainerSession is null, can not start scene!');
      return CommonResult.FAIL;
    }
    log.showInfo(`startSceneFromOtherAboveKeyguardIfNeed in name: ${sceneContainerSession.getName()}}`);
    sceneContainerSession.requestActivation();
    return CommonResult.SUCCESS;
  }

  onBackgroundScene(persistentId?: number, containerId?: number, isDelegator?: boolean) {
    log.showInfo(`onBackgroundScene with persistentId:${persistentId} containerId:${containerId}`);
    const containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    if (containerSession) {
      if (isDelegator) {
        containerSession.requestBackground(isDelegator);
      } else {
        containerSession.requestBackground();
      }
    }
  }

  onDestroyScene(persistentId?: number, containerId?: number) {
    log.showInfo(`onDestroyScene with persistentId:${persistentId} containerId:${containerId}`);
    const containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    if (containerSession) {
      containerSession.requestDestruction(true);
      this.removeSpecialSceneContainerSession(containerSession);
    }
  }

  onMinimizeScene(persistentId?: number, containerId?: number) {
    log.showInfo(`onMinimizeScene with persistentId:${persistentId} containerId:${containerId}`);
    const containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
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
      containerSession.requestBackground();
    }
  }

  resetWindowEffect(containerSession: SCBSceneContainerSession) {
    if (containerSession.primarySession) {
      containerSession.primarySession.floatBorderRadius = 0;
      containerSession.primarySession.shadowConfig.radius = 0;
    }

    if (containerSession.secondarySession) {
      log.showError(`show when locked session cannot be split`);
      return;
    }
  }

  onMaximizeScene(persistentId?: number, containerId?: number) {
    log.showInfo(`onMaximizeScene with persistentId:${persistentId} containerId:${containerId}`);
    const currContainerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
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
        } else {
          currContainerSession.primarySession?.maximize();
        }
      } else {
        const windowMode = container.getContainerWindowMode();
        if (windowMode === SCBSceneMode.FULLSCREEN) {
          container.requestBackground();
        }
      }
    }
    if (SCBSceneSessionManager.getInstance()
      .isScenePanelInState(this.screenProperty.screenId, SCBScenePanelState.RECENT)) {
      return;
    }
    currContainerSession.init();

    this.resetWindowEffect(currContainerSession);
  }

  private raiseSceneToTop(sceneContainerSession: SCBSceneContainerSession) {
    log.showInfo('raiseSceneToTop.');

    // To move the sceneContainerSession to the last of list.
    this.removeSpecialSceneContainerSession(sceneContainerSession);
    this.addSpecialSceneContainerSession(sceneContainerSession);
  }

  private raisePresentSceneToTop(sceneContainerSession: SCBSceneContainerSession) {
    if (!sceneContainerSession) {
      log.showError('session is nullptr');
      return;
    }
    const index = this.specialContainerSessionList.findIndex((item) => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index === -1 || index === this.specialContainerSessionList.length - 1) {
      return;
    }
    this.raiseSceneToTop(sceneContainerSession);
  }

  onSceneRaiseToTop(persistentId?: number, containerId?: number) {
    log.showInfo(`onRaiseSceneToTop with persistentId:${persistentId} containerId:${containerId}`);
    const containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    if (!containerSession) {
      log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    this.raisePresentSceneToTop(containerSession);
  }

  onCloseScene(persistentId?: number, containerId?: number) {
    log.showInfo(`onCloseScene with persistentId:${persistentId} containerId:${containerId}`);
    const containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    if (!containerSession) {
      log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    containerSession.requestDestruction(true);
    this.removeSpecialSceneContainerSession(containerSession);
  }

  private startSceneFromScreenLockIconCallback = (sceneInfo: SCBSceneInfoFromScreenLock): void => {
    this.onStartSceneFromScreenLockIcon(sceneInfo);
  }

  private onStartSceneFromScreenLockIcon(sceneInfo: SCBSceneInfoFromScreenLock): void {
    log.showInfo(`onStartSceneFromScreenLockIcon sceneInfo: ${sceneInfo.persistentId} bundle: ${sceneInfo.bundleName}`);
    let scene = this.requestSceneSession(sceneInfo);
    if (!scene) {
      log.showError('Failed to request scene session' + '!');
      return;
    }
    scene.setTemporarilyShowWhenLocked(true);
    scene.setShowAboveKeyguard(true);
    scene.setUseStartingWindowAboveLocked(true);
    let container =
      this.getSceneContainerSessionWithPersistentIdFromLock(scene.session.persistentId);
    if (container === null) {
      container = new SCBSceneContainerSession(scene, this.screenProperty);
      log.showInfo('start scene add new session: ' + container.containerId);
    } else {
      sceneInfo.updateSceneInfo(scene.sceneInfo);
      container.primarySession?.updateSceneInfo(sceneInfo);
    }
    let info = SceneInfoAdapterUtil.getScreenLockInfo(container);
    if (info) {
      info.originIconInfo = sceneInfo.originIconInfo;
    }
    if (scene.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      this.updateMaximizeSceneRect(true, scene);
    }
    container.init();
    this.raiseSceneToTop(container);
    container.requestActivation(scene.isNewWant);
    container.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'initVisibility', container.getName());
    scene.sessionData.isNewWant = true;
    container.needRenderScale.setScaleXWithDfx(1.0, TAG, 'onSceneContainerTransitionIn', container.getName());
    container.needRenderScale.setScaleYWithDfx(1.0, TAG, 'onSceneContainerTransitionIn', container.getName());
    container.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'onSceneContainerTransitionIn', container.getName());
    SCBSceneHelper.setSceneTranslate(container, 0, 0);
    SCBSceneHelper.setSceneScale(container, 1);
    SCBSessionListManager.refreshZOrder();
    this.scenePanelState = ScenePanelState.HOME;
  }

  private getSceneSessionByPersistentId(persistentId: number): SCBSceneSession | null {
    return this.specialContainerSessionList.getSceneSessionByPersistentId(persistentId);
  }

  /**
   * 根据sceneInfo 获取对应sceneSession
   *
   * @param sceneInfo: SCBSceneInfo
   * @returns SCBSceneSession | null
   */
  private requestSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    log.showInfo('[SCBMain]requestSceneSession with sceneInfo:{persistentId: %{public}d, bundleName:%{public}s,' +
      'moduleName:%{public}s, abilityName:%{public}s, needFindOtherScreen:%{public}s}', sceneInfo.persistentId,
      sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName, sceneInfo.needFindOtherScreen);
    if (sceneInfo == null) {
      log.showError('sceneInfo null');
      return null;
    }
    if (sceneInfo.persistentId !== 0) {
      log.showInfo('[SCBMain]using exist persistentId: ' + sceneInfo.persistentId);
      let scbSceneSession = this.getSceneSessionByPersistentId(sceneInfo.persistentId);
      if (scbSceneSession == null) {
        log.showInfo('[SCBMain]not find , new a scene session');
        scbSceneSession = this.createSceneSession(sceneInfo);
      } else {
        SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      }
      return scbSceneSession;
    } else {
      const scbSceneSession = this.getSceneSession(sceneInfo);
      if (scbSceneSession == null || sceneInfo.isNewInstance || sceneInfo.isNewAppInstance) {
        log.showWarn('[SCBMain]getSceneSession is null, new scene session');
        return this.createSceneSession(sceneInfo);
      }
      if (sceneInfo.want !== null) {
        log.showInfo('update want persistentId: ' + scbSceneSession.sceneInfo.persistentId);
        sceneSessionManager.updateSceneSessionWant({
          bundleName: scbSceneSession.sceneInfo.bundleName,
          moduleName: scbSceneSession.sceneInfo.moduleName,
          abilityName: scbSceneSession.sceneInfo.abilityName,
          appIndex: scbSceneSession.sceneInfo.appIndex,
          persistentId: scbSceneSession.sceneInfo.persistentId
        }, sceneInfo.want);
      }
      return scbSceneSession;
    }
  }

  private getSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    const containerListLen = this.specialContainerSessionList.length;
    for (let i = containerListLen - 1; i >= 0; i--) {
      let primarySession = this.specialContainerSessionList[i].primarySession;
      let secondarySession = this.specialContainerSessionList[i].secondarySession;
      if (primarySession && primarySession.sceneInfo.equalTo(sceneInfo)) {
        return primarySession;
      }
      if (secondarySession && secondarySession.sceneInfo.equalTo(sceneInfo)) {
        return secondarySession;
      }
    }
    let sceneSessionTuple = SCBSceneSessionManager.getInstance()
      .getContainerSessionList()?.getSceneSessionTupleBySceneInfo(sceneInfo, true);
    if (sceneSessionTuple && sceneSessionTuple[0]) {
      log.showInfo(`get sceneSession from scenePanel name: ${sceneSessionTuple[0].getName()}`);
      return sceneSessionTuple[0];
    }
    return null;
  }

  /**
   * 创建SCBSceneSession
   *
   * @param sceneInfo
   * @returns SCBSceneSession or null
   */
  private createSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    const sceneSession = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
    if (sceneSession === null) {
      log.showWarn('createSceneSession return null');
      return null;
    }
    let scbSceneSession = new SCBSceneSession(sceneSession, sceneInfo);
    scbSceneSession.sessionData.isNewWant = false;
    this.setSystemOrSupportAppIsEnableSpecified(scbSceneSession);
    this.setSystemOrSupportAppWindowRectAutoSave(scbSceneSession);
    this.setIsWindowRectAutoSave(scbSceneSession);
    this.initSceneWhenCreateSceneSession(scbSceneSession, sceneSession);
    return scbSceneSession;
  }
  private setSystemOrSupportAppIsEnableSpecified(scbSceneSession: SCBSceneSession): void {
    let sceneInfo: SCBSceneInfo = scbSceneSession.sceneInfo;
    let key: string = sceneInfo.bundleName + sceneInfo.moduleName + sceneInfo.abilityName;
    let isEnableSpecified: boolean | undefined =
      SCBPcScenePanelManager.getInstance().getIsEnableSpecifiedRectAutoSaveMap(key);
    if (isEnableSpecified === undefined) {
      SCBPcScenePanelManager.getInstance().setIsEnableSpecifiedRectAutoSaveMap(key, false);
    }
  }

  private setSystemOrSupportAppWindowRectAutoSave(scbSceneSession: SCBSceneSession): void {
    let info: SCBSceneInfo = scbSceneSession.sceneInfo;
    let key: string = SCBPcScenePanelManager.getInstance().createIsWindowRectAutoSaveKey(info);
    let isWindowRectAutoSave: boolean | undefined =
      SCBPcScenePanelManager.getInstance().getIsWindowRectAutoSaveMap(key);
    if (isWindowRectAutoSave === undefined) {
      SCBPcScenePanelManager.getInstance().setIsWindowRectAutoSaveMap(key, true);
    }
  }

  private setIsWindowRectAutoSave(scbSceneSession: SCBSceneSession): void {
    let info: SCBSceneInfo = scbSceneSession.sceneInfo;
    let key: string = SCBPcScenePanelManager.getInstance().createIsWindowRectAutoSaveKey(info);
    let isWindowRectAutoSave: boolean | undefined =
      SCBPcScenePanelManager.getInstance().getIsWindowRectAutoSaveMap(key);
    let abilityKey: string = info.bundleName + info.moduleName + info.abilityName;
    let isSaveBySpecifiedFlag: boolean =
      SCBPcScenePanelManager.getInstance().getIsEnableSpecifiedRectAutoSaveMap(abilityKey) ?? false;
    if (isWindowRectAutoSave === undefined || !isWindowRectAutoSave) {
      SCBSceneSessionManager.getInstance().setIsWindowRectAutoSave(key, false, abilityKey, isSaveBySpecifiedFlag);
      return;
    }
    SCBSceneSessionManager.getInstance().setIsWindowRectAutoSave(key, isWindowRectAutoSave,
      abilityKey, isSaveBySpecifiedFlag);
  }

  private initSceneWhenCreateSceneSession(scene: SCBSceneSession, session: sceneSessionManager.SceneSession): void {
    if (sSCBOobeManager.isEnable()) {
      sceneSessionManager.updateWindowMode(scene.sceneInfo.persistentId, SCBSceneMode.FULLSCREEN);
    } else {
      scene.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
    }
    scene.sceneInfo.configWindowTop = session.windowTop;
    scene.sceneInfo.configWindowLeft = session.windowLeft;
    scene.sceneInfo.configWindowWidth = session.windowWidth;
    scene.sceneInfo.configWindowHeight = session.windowHeight;
    scene.sceneInfo.isMaximize = session.isMaximize;
    SCBFreeWindowsViewModelManager.getInstance().getPresenter(this.screenProperty.screenId)?.initScenePosAndSize(scene);
  }

  registerSpecialCallback(): void {
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.BACKGROUND_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onBackgroundScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.DESTROY_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onDestroyScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onMinimizeScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.MAXIMIZE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onMaximizeScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.CLOSE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onCloseScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onCloseScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.SESSION_EXCEPTION, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onCloseScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.SESSION_RAISE_TO_TOP, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onSceneRaiseToTop(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().onSpecial(SCBEventId.START_SCENE_FROM_OTHER, this.screenProperty.screenId,
      this.startSceneFromOtherCallback);
    if (DeviceHelper.is2In1DevicePcType()) {
      SCBSceneSessionManager.getInstance()
        .onSpecial(SCBEventId.START_SCENE_FROM_SCREEN_LOCK, this.screenProperty.screenId,
          this.startSceneFromScreenLockIconCallback);
    }
    return;
  }

  private unRegisterSpecialCallback(): void {
    SCBSceneSessionManager.getInstance().offSpecial(SCBEventId.BACKGROUND_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onBackgroundScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().offSpecial(SCBEventId.DESTROY_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onDestroyScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().offSpecial(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onMinimizeScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().offSpecial(SCBEventId.MAXIMIZE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onMaximizeScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().offSpecial(SCBEventId.CLOSE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onCloseScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().offSpecial(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onCloseScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().offSpecial(SCBEventId.SESSION_EXCEPTION, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onCloseScene(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().offSpecial(SCBEventId.SESSION_RAISE_TO_TOP, this.screenProperty.screenId,
      (persistentId?: number, containerId?: number) => {
        this.onSceneRaiseToTop(persistentId, containerId);
      });
    SCBSceneSessionManager.getInstance().offSpecial(SCBEventId.START_SCENE_FROM_OTHER, this.screenProperty.screenId,
      this.startSceneFromOtherCallback);
    if (DeviceHelper.is2In1DevicePcType()) {
      SCBSceneSessionManager.getInstance()
        .offSpecial(SCBEventId.START_SCENE_FROM_SCREEN_LOCK, this.screenProperty.screenId,
          this.startSceneFromScreenLockIconCallback);
    }
  }

  private addSpecialSceneContainerSession(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    const index = this.specialContainerSessionList.findIndex(item => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index === -1) {
      log.showInfo('Add special scene container session, id: ' + sceneContainerSession.containerId);
      this.specialContainerSessionList.push(sceneContainerSession);
      SCBSessionListManager.refreshZOrder();
    }
  }

  private removeSpecialSceneContainerSession(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    const index = this.specialContainerSessionList.findIndex(item => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index !== -1) {
      log.showInfo('Remove special scene container session, id: ' + sceneContainerSession.containerId);
      this.specialContainerSessionList.splice(index, 1);
      SCBSessionListManager.refreshZOrder();
    }
  }

  private addSpecialShowWhenLockedSceneContainerSession = (list_: SCBSceneContainerSessionArray): void => {
    for (let item of list_) {
      log.showInfo('Add scene container session, id: ' + item.containerId);
      item.primarySession?.setShowAboveKeyguard(true);
      if (item.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
        this.updateMaximizeSceneRect(true, item.primarySession);
      }
      this.specialContainerSessionList.push(item);
    }
    if (list_.length > 0) {
      SCBSessionListManager.refreshZOrder();
    }
    const containerSession = this.getTopActiveSceneContainerSession();
    if (containerSession) {
      if (containerSession.primarySession && containerSession.primarySession.session) {
        SCBSceneSessionManager.getInstance().requestFocus(containerSession.primarySession.session.persistentId,
          undefined,
          FocusChangeReason.MOVE_UP);
      } else if (containerSession.secondarySession && containerSession.secondarySession.session) {
        SCBSceneSessionManager.getInstance().requestFocus(containerSession.secondarySession.session.persistentId,
          undefined,
          FocusChangeReason.MOVE_UP);
      }
    }
  }
  private removeSpecialShowWhenLockedSceneContainerSession = (): SCBSceneContainerSessionArray => {
    const ret = new SCBSceneContainerSessionArray();
    for (let i = 0; i < this.specialContainerSessionList.length; ++i) {
      let specialContainerSession = this.specialContainerSessionList[i];
      specialContainerSession?.primarySession?.setTemporarilyShowWhenLocked(false);
      if (specialContainerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
        this.updateMaximizeSceneRect(false, specialContainerSession.primarySession);
      }
      ret.push(specialContainerSession);
    }
    this.specialContainerSessionList.splice(0, this.specialContainerSessionList.length);
    if (ret.length > 0) {
      SCBSessionListManager.refreshZOrder();
    }
    return ret;
  }

  private updateMaximizeSceneRect(isWillLock: boolean, sceneSession: SCBSceneSession) {
    let screenHeight = this.screenProperty.height;
    let width = this.screenProperty.width;
    let height = screenHeight;
    let posY = 0;
    const layoutFullScreen = sceneSession.layoutFullScreen;
    if (isWillLock) {
      sceneSession.currRect.setRectNum(0, posY, width, height);
    } else if (!layoutFullScreen) {
      let statusBarHeight: number = 0;
      let statusBar = SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR,
          this.screenProperty.screenId);
      if (statusBar) {
        statusBarHeight = statusBar.currRect.height.getPx();
      }
      let dockHeight = 0;
      let dock = SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, this.screenProperty.screenId);
      if (dock) {
        dockHeight = dock.currRect.height.getPx();
      } else {
        log.showError('calculateMaxRect SmartDock no exit');
      }
      posY = statusBarHeight;
      height = screenHeight - dockHeight - statusBarHeight;
      sceneSession.currRect.setRectNum(0, posY, width, height);
    }
  }

  private getTopActiveSceneContainerSession(): SCBSceneContainerSession | null {
    if (this.specialContainerSessionList.length === 0) {
      log.showError('Failed to find active scene container session with list length 0.');
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

  private onQueryScreenDensityDpi(): number {
    log.showDebug(`onQueryScreenDensityDpi screenDpiDensity is ${this.screenDpiDensity}`);
    return this.screenDpiDensity;
  }

  private getDpi(): number {
    try {
      let defaultDisplay: display.Display = display.getDefaultDisplaySync();
      return defaultDisplay.densityDPI;
    } catch (err) {
      log.showError(`get dpi error: ${err?.message}`);
      return SCBConstants.DEFAULT_DOTS_PER_INCH;
    }
  }

  private dpiChangeListener = (data: number) => {
    const screenDpi = this.getDpi();
    if (this.screenDpiDensity !== screenDpi) {
      this.screenDpiDensity = screenDpi;
      log.showInfo(`screenDpiDensity change,new dpi density is :${this.screenDpiDensity}`);
    }
  }

  /*
   * Layout all specialScenes when fold or expand
   */
  private layoutSpecialScenesToFoldOrExpend(screenProperty: SCBScreenProperty, isFold: boolean = true): void {
    animateTo({
      duration: 600,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
    }, ()=>{
      for (let specialContainerSession of this.specialContainerSessionList) {
        let sceneSession = specialContainerSession.primarySession;
        if (!specialContainerSession || !sceneSession || !specialContainerSession.primarySession) {
          log.showInfo(`layoutSpecialScenesToFold continue`);
          continue;
        }
        specialContainerSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.ROTATION);
      }
    });
  }

  buildLog(sceneContainerSession: SCBSceneContainerSession) {
    log.showInfo(`specialSceneContainerSession id: ${sceneContainerSession.containerId} isActive: ${sceneContainerSession.isActive}`);
    log.showInfo('sceneState: HOME, length: ' + this.specialContainerSessionList.length);
    return true;
  }

  aboutToAppear() {
    this.screenDpiDensity = this.getDpi();
    this.registerSpecialCallback();
    SCBSceneSessionManager.getInstance()
      .registerGetSpecialContainerSessionListCallback(this.getSpecialContainerSessionListCallback);
    SCBSceneSessionManager.getInstance()
      .registerAddSpecialContainerSessionCallback(this.addSpecialShowWhenLockedSceneContainerSession);
    SCBSceneSessionManager.getInstance()
      .registerRemoveSpecialContainerSessionCallback(this.removeSpecialShowWhenLockedSceneContainerSession);
    SCBScreenSessionManager.getInstance().registerPropertyChangeScenePanelCallback((
      screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
      log.showDebug('SpecialScenePanel screen callback is called');
    }, SCBDefaultZIndex.SPECIAL_SCENE_PANEL, this.screenProperty.screenId);
    try {
      display.on('change', this.dpiChangeListener);
    } catch (e) {
      log.showError(`display listening error ${e?.message}`)
    }
  }

  aboutToDisappear() {
    this.unRegisterSpecialCallback();
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.sysSceneSession);
    try {
      display.off('change', this.dpiChangeListener);
    } catch (e) {
      log.showError(`display unregist error ${e?.message}`)
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
        Stack({ alignContent: Alignment.TopStart }) {
          ForEach(this.specialContainerSessionList, (item: SCBSceneContainerSession, index) => {
            if (this.buildLog(item) && item.isActive) {
              SCBSceneContainer({
                sceneContainerSession: item,
                dividerParam: item.dividerParam,
                screenProperty: $screenProperty,
                singleContext: this.singleContext,
                isExitSplit: $isExitSplit,
                needRenderScale: item.needRenderScale,
                needRenderBlurRadius: item.needRenderBlurRadius,
                needRenderAlpha: item.needRenderAlpha,
                needRenderShowInRecent: item.needRenderShowInRecent,
                needRenderRecentSceneBorderRadius: item.needRenderRecentSceneBorderRadius,
                needRenderRecentDeleteScale: item.needRenderRecentDeleteScale,
                needRenderRecentDeleteTranslate: item.needRenderRecentDeleteTranslate,
                needRenderRecentClosingAnimating: item.needRenderRecentClosingAnimating,
                needRenderSplitBackgroundColor: item.needRenderSplitBackgroundColor,
                needRenderRecentMinBackgroundShow: item.needRenderRecentMinBackgroundShow,
                needRenderSubSceneShow: item.needRenderSubSceneShow,
                needRenderZIndex: item.needRenderZIndex,
                getScreenDpiDensity: this.getScreenDpiDensity,
                needRenderRecentHoverState: item.needRenderRecentHoverState,
                scenePanelState: $scenePanelState
              })
            }
          }, (item: SCBSceneContainerSession) => item.containerId.toString())
        }
        .visibility(this.scenePanelState === ScenePanelState.HOME ? Visibility.Visible : Visibility.Hidden)
        .hitTestBehavior(HitTestMode.None)
      }
      .id('SCBSpecialScenePanelTransScene')
      .size({ width: this.screenProperty.width + 'px', height: this.screenProperty.height + 'px' })
      .hitTestBehavior(HitTestMode.None)
      .zIndex(SCBDefaultZIndex.SPECIAL_SCENE_PANEL)
    }
    .id('SCBSpecialScenePanelBackground')
    .direction(Direction.Ltr)
    .position({ x: 0, y: 0 })
    .size({ width: '100%', height: '100%' })
    .hitTestBehavior(HitTestMode.None)
    .zIndex(SCBDefaultZIndex.SPECIAL_SCENE_PANEL)
  }
}
