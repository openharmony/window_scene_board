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
import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  FocusChangeReason,
  SCBEventId,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSpecificSceneSessionList,
  SCBSpecificSession,
  SpecificPanelZOrder
} from '@ohos/windowscene/src/main/ets/TsIndex';
import { PadWithCarSceneManager } from '../manager/PadWithCarSceneManager';
import PanelModel from '../model/PanelModel';
import IdlCarAssistantServiceProxy from '../service/IdlCarAssistantServiceProxy';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { EventConstants, sEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, 'PadWithCarPanelViewModel');
const INVALID_INDEX = -1;

/**
 * PadWithCarSceneManager
 *
 * @since 2025-04-25
 */
export class PadWithCarPanelViewModel {
  private panelModel: PanelModel = new PanelModel();
  private panelModelChangeFunc?: Function;
  private saveMainSessionId: number = -1;
  private saveSubSessionId: number = -1;
  private missionId: number = -1;
  private projectionBundleName: string = '';
  private projectionSession?: SCBSceneContainerSession;
  private sendReadyTimeId: number = 0;
  /**
   * 监听主屏上启动的应用， 如果是当前应用则拉起壳应用
   */
  private onStartMainSceneFromIcon = (sceneInfo: SCBSceneInfo): void => {
    this.startShellWindow(sceneInfo);
  }
  /**
   * 监听主屏点击，如果是当前应用则拉起壳应用
   */
  private startSceneFromOtherCallback = (sceneInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo) => {
    this.startShellWindow(sceneInfo);
  }
  /**
   * 监听主屏从Recent区启动，如果是当前应用则拉起壳应用
   */
  private startSceneFromRecentCallback = (persistentId?: number, containerId?: number) => {
    let sceneInfo = this.projectionSession?.primarySession?.sceneInfo;
    if (sceneInfo !== undefined && sceneInfo.persistentId === persistentId) {
      this.startShellWindow(sceneInfo);
    }
  }
  /**
   * 监听虚拟屏上启动的应用
   */
  private onStartSceneFromIcon = (sceneInfo: SCBSceneInfo): void => {
    if (sceneInfo.screenId === this.panelModel.screenProperty?.screenId) {
      let curSCBSceneSession = this.panelModel.scbSceneSessionArray.find((item: SCBSceneSession) => {
        return item.sceneInfo.screenId === sceneInfo.screenId;
      });
      if (curSCBSceneSession === undefined) {
        log.showWarn(`onStartSceneFromIcon: curSCBSceneSession is undefined`);
        return;
      }
      SCBSceneSessionManager.getInstance().requestSceneSessionActivation(curSCBSceneSession.session, true);
      log.showInfo(`onStartSceneFromIcon: sendMsgToCarAssistant ACTION_START_SHELL_ABILITY`);
      PadWithCarSceneManager.getInstance().sendMsgToCarAssistant({
        action: IdlCarAssistantServiceProxy.ACTION_START_SHELL_ABILITY
      });
    }
  }
  /**
   * 接收到助手发送到sceneBoard的消息
   */
  private messageRecvCallback = (code: number, params: string): void => {
    log.showInfo(`onScreenPanelEventChange: code =  ${code}`);
    if (code === IdlCarAssistantServiceProxy.EVENT_INIT_PROJECTION_SESSION) {
      this.handleInitEvent(params);
    } else if (code === IdlCarAssistantServiceProxy.EVENT_START_MOVE_TASK_TO_VD) {
      this.popSceneToVD();
    }
  }
  /**
   * 移栈回调
   */
  private popSceneSession = (sceneInfo: SCBSceneInfo): SCBSceneSession | undefined => {
    let scbSceneSession: SCBSceneSession | undefined = this.panelModel.scbSceneSessionArray.find((item) => {
      return item.session.persistentId === sceneInfo.persistentId;
    });
    log.showInfo(`popSceneSession: persistentId of ${scbSceneSession?.session?.persistentId}`);
    if (scbSceneSession) {
      sceneSessionManager.requestFocusStatus(
        sceneInfo.persistentId, false, false, FocusChangeReason.SCB_START_APP);
    }
    return scbSceneSession;
  };
  /**
   * 根据应用查询当前应用是否正常投屏中
   */
  private getSessionById = (persistentId: number): SCBSceneSession | undefined => {
    let isSubSession = false;
    const index = this.panelModel.scbSceneSessionArray.findIndex((containerSession: SCBSceneSession) => {
      isSubSession = this.checkSubWin(containerSession?.subSessionList, persistentId) ||
        this.checkSubWin(containerSession?.dialogSessionList, persistentId);
      if (isSubSession) {
        // 如果是子窗口，需要存储下主窗口和子窗口的对应关系，因为在关闭输入法时，可能存在子窗口先销毁了从而方法遍历不到，所以需要存储
        this.saveMainSessionId = containerSession?.session?.persistentId ?? INVALID_INDEX;
        this.saveSubSessionId = persistentId;
        return true;
      }
      return containerSession?.session?.persistentId === persistentId;
    });
    log.showInfo(`index ${index}. persistentId:${persistentId}`);
    if (index === INVALID_INDEX) {
      if (persistentId === this.saveSubSessionId && this.saveSubSessionId !== this.saveMainSessionId) {
        // 在关闭输入法时，可能存在子窗口先销毁了从而方法遍历不到，此时直接根据存储的对应关系查询主窗口的id
        return this.getSessionById(this.saveMainSessionId);
      }
      return undefined;
    }
    const primarySession = this.panelModel.scbSceneSessionArray[index];
    if (primarySession?.session?.persistentId === persistentId || isSubSession) {
      log.showInfo(`primarySession ${primarySession?.session?.persistentId}`);
      return primarySession || undefined;
    }
    return undefined;
  }
  /**
   * 监听返回事件
   */
  private backGestureListener = (value: boolean): void => {
    log.showInfo(`backGestureListener: BACK_GESTURE value: ${value}`);
    PadWithCarSceneManager.getInstance().sendMsgToCarAssistant({
      action: IdlCarAssistantServiceProxy.ACTION_BACK_GESTURE
    });
  }
  private minimizeScene = (persistentId?: number, containerId?: number): void => {
    log.showInfo(`minimizeScene: screenId:${this.panelModel.screenProperty?.screenId}, persistentId:${persistentId}`);
    let scbSceneSession: SCBSceneSession | undefined = this.panelModel.scbSceneSessionArray.find((item) => {
      return item.session.persistentId === persistentId;
    });
    if (scbSceneSession) {
      log.showInfo(`minimizeScene: send minimize scene`);
      PadWithCarSceneManager.getInstance().sendMsgToCarAssistant({
        action: IdlCarAssistantServiceProxy.ACTION_MINIMIZE_SCENE
      });
    }
  }

  public init(screenProperty: SCBScreenProperty) {
    this.panelModel.screenProperty = screenProperty;
    this.clearTimer();
    this.registerEventCallback();
    PadWithCarSceneManager.getInstance().registerMessageRecvCallback(this.messageRecvCallback);
  }

  public deInit(): void {
    this.clearTimer();
    this.moveToMainScreen();
    this.unregisterEventCallback();
    PadWithCarSceneManager.getInstance().unregisterMessageRecvCallback();
    SCBSceneSessionManager.getInstance().setProjectionBundleName('', 0);
    PadWithCarSceneManager.getInstance().sendMsgToCarAssistant({
      action: IdlCarAssistantServiceProxy.ACTION_MOVE_TO_MAIN,
      extra: {
        'bundleName': this.projectionBundleName
      }
    });
  }

  private registerEventCallback(): void {
    log.showInfo(`registerCallback screenId: ${this.panelModel.screenProperty?.screenId}`);
    sEventManager.subscribe(EventConstants.BACK_GESTURE, this.backGestureListener);
    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SCENE_FROM_OTHER,
      SCBSceneSessionManager.getInstance().mainScreenId, this.startSceneFromOtherCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SCENE_FROM_ICON,
      SCBSceneSessionManager.getInstance().mainScreenId, this.onStartMainSceneFromIcon);
    SCBSceneSessionManager.getInstance().on(SCBEventId.START_SCENE_FROM_RECENT,
      SCBSceneSessionManager.getInstance().mainScreenId, this.startSceneFromRecentCallback);
    SCBSceneSessionManager.getInstance().on(SCBEventId.MINIMIZE_SCENE,
      this.panelModel.screenProperty?.screenId, this.minimizeScene);
    SCBSceneSessionManager.getInstance()
      .registerVirtualScreenStartScene(this.onStartSceneFromIcon, this.panelModel.screenProperty?.screenId);
    SCBSceneSessionManager.getInstance()
      .registerPopSceneSession(this.popSceneSession, this.panelModel.screenProperty?.screenId);
    SCBSceneSessionManager.getInstance().registerGetVirtualScreenSceneSessionFunc(
      this.getSessionById, this.panelModel.screenProperty?.screenId);
  }

  private unregisterEventCallback(): void {
    sEventManager.off(EventConstants.BACK_GESTURE, this.backGestureListener);
    SCBSceneSessionManager.getInstance().off(SCBEventId.START_SCENE_FROM_ICON,
      SCBSceneSessionManager.getInstance().mainScreenId, this.onStartMainSceneFromIcon);
    SCBSceneSessionManager.getInstance().off(SCBEventId.START_SCENE_FROM_OTHER,
      SCBSceneSessionManager.getInstance().mainScreenId, this.startSceneFromOtherCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.START_SCENE_FROM_RECENT,
      SCBSceneSessionManager.getInstance().mainScreenId, this.startSceneFromRecentCallback);
    SCBSceneSessionManager.getInstance().off(SCBEventId.MINIMIZE_SCENE,
      this.panelModel.screenProperty?.screenId, this.minimizeScene);
    SCBSceneSessionManager.getInstance()
      .unregisterVirtualScreenStartScene(this.panelModel.screenProperty?.screenId);
    SCBSceneSessionManager.getInstance().unregisterPopSceneSession(this.panelModel.screenProperty?.screenId);
    SCBSceneSessionManager.getInstance()
      .unregisterGetVirtualScreenSceneSessionFunc(this.panelModel.screenProperty?.screenId);
    log.showInfo('unRegisterCallback');
  }

  private startShellWindow(sceneInfo: SCBSceneInfo): void {
    log.showInfo(`startShellWindow sceneInfo: ${sceneInfo.bundleName},screenId: ${sceneInfo.screenId}`);
    if (sceneInfo.bundleName !== this.projectionBundleName) {
      return;
    }
    if (SCBSceneSessionManager.getInstance().isProjectionBundleName(this.projectionBundleName)) {
      PadWithCarSceneManager.getInstance().sendMsgToCarAssistant({
        action: IdlCarAssistantServiceProxy.ACTION_START_SHELL_ABILITY
      });
    }
  }

  private handleInitEvent(params: string): void {
    let jsonObj: Map<string, Object> = CommonUtils.jsonStrToMap(params);
    if (!CheckEmptyUtils.isEmpty(jsonObj) && !CheckEmptyUtils.isEmpty(jsonObj.get('bundleName')) &&
      !CheckEmptyUtils.isEmpty(jsonObj.get('missionId'))) {
      this.missionId = jsonObj.get('missionId') as number;
      this.projectionBundleName = jsonObj.get('bundleName') as string;
      log.showInfo(`handleInitEvent: projectionBundleName = ${this.projectionBundleName}`);
      if (CheckEmptyUtils.checkStrIsEmpty(this.projectionBundleName) || isNaN(this.missionId)) {
        return;
      }
      SCBSceneSessionManager.getInstance()
        .setProjectionBundleName(this.projectionBundleName, this.panelModel.screenProperty?.screenId);
      this.initProjectionSession(this.missionId, this.projectionBundleName);
    }
  }

  /**
   * initProjectionSession 初始化投屏Session
   *
   * @param missionId 投屏应用的missionId
   * @param projectionBundleName 投屏的包名
   */
  private initProjectionSession(missionId: number, projectionBundleName: string) {
    let session: SCBSceneContainerSession | null = this.getSceneSessionByPersistentId(missionId);
    if (session?.primarySession?.session?.bundleName === projectionBundleName) {
      let sceneInfo = session?.primarySession?.sceneInfo;
      log.showInfo(`initProjectionSession: sceneInfo = ${sceneInfo?.bundleName}`);
      if (CheckEmptyUtils.isEmpty(sceneInfo)) {
        return;
      }
      this.projectionSession = session;
      log.showInfo('initProjectionSession: sendCarAssistant is ready');
      PadWithCarSceneManager.getInstance().sendMsgToCarAssistant({
        action: IdlCarAssistantServiceProxy.ACTION_ABILITY_IS_READY
      });
    }
  }

  private getSceneSessionByPersistentId(persistentId: number): SCBSceneContainerSession | null {
    let sceneSession = SCBSceneSessionManager.getInstance().getContainerSessionList().findByPersistentId(persistentId);
    if (sceneSession) {
      log.showInfo(`getSceneSessionByPersistentId from containerSessionList id: ${persistentId}`);
      return sceneSession;
    }
    sceneSession = SCBSceneSessionManager.getInstance().getFloatingSessionList().findByPersistentId(persistentId);
    if (sceneSession) {
      log.showInfo(`getSceneSessionByPersistentId from floatingSessionList id: ${persistentId}`);
      return sceneSession;
    }
    sceneSession = SCBSceneSessionManager.getInstance().getSideEdgeSessionList().findByPersistentId(persistentId);
    if (sceneSession) {
      log.showInfo(`getSceneSessionByPersistentId from sideFloatingSessionList id: ${persistentId}`);
      return sceneSession;
    }
    log.showWarn('getSceneSessionByPersistentId find nothing, id ' + persistentId);
    return null;
  }

  private popSceneToVD(): void {
    if (CheckEmptyUtils.isEmpty(this.projectionSession)) {
      log.showWarn('popSceneToVD: is not init projection');
      return;
    }
    if (!CheckEmptyUtils.isEmpty(this.projectionSession?.primarySession?.sceneInfo)) {
      let sceneInfo = this.projectionSession?.primarySession?.sceneInfo as SCBSceneInfo;
      let popSceneInfo = new SCBSceneInfo(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName,
        sceneInfo.appIndex);
      popSceneInfo.screenId = this.panelModel.screenProperty?.screenId ?? 0;
      log.showInfo(`popSceneToVD: start screenId = ${popSceneInfo.screenId}; bundleName = ${sceneInfo.bundleName}`);
      let sceneSession =
        SCBSceneSessionManager.getInstance().popSceneFromOtherScreen(popSceneInfo);
      if (sceneSession) {
        this.transformScene(sceneSession, popSceneInfo);
      }
    }
  }

  /**
   * moveToMainScreen 将任务移栈回主屏
   */
  public moveToMainScreen(): void {
    log.showWarn('moveToMainScreen length = ' + this.panelModel.scbSceneSessionArray.length);
    for (let i = 0; i < this.panelModel.scbSceneSessionArray.length; i++) {
      let scbSession: SCBSceneSession = this.panelModel.scbSceneSessionArray[i];
      let sceneInfo = scbSession?.sceneInfo;
      if (CheckEmptyUtils.isEmpty(sceneInfo)) {
        log.showWarn('moveToMainScreen sessionInfo is undefined');
        return;
      }
      log.showInfo(`moveToMainScreen: session ${i} ${scbSession?.session?.bundleName}`);
      this.requestSceneSessionBackground(scbSession.session);
      sceneInfo.screenId = SCBSceneSessionManager.getInstance().mainScreenId;
      SCBSceneSessionManager.getInstance().startSceneFromVirtual(sceneInfo);
      this.updateSessionDisplayId(sceneInfo.persistentId, SCBSceneSessionManager.getInstance().mainScreenId);
      SCBSceneSessionManager.getInstance().requestSceneSessionActivation(scbSession.session, true);
    }
  }

  private transformScene(scbSceneSession: SCBSceneSession, sceneInfo: SCBSceneInfo): void {
    const sceneSession = scbSceneSession.session;
    sceneInfo.persistentId = sceneSession.persistentId;
    sceneInfo.screenId = this.panelModel.screenProperty?.screenId ?? 0;
    let sceneContainerSession: SCBSceneContainerSession | undefined =
      this.createContainerSession(sceneSession, sceneInfo);
    if (!CheckEmptyUtils.isEmpty(sceneContainerSession?.primarySession)) {
      log.showInfo(`transformScene: screenId = ${sceneInfo.screenId},
         len = ${this.panelModel.scbSceneSessionArray.length}`);
      //设置成全屏
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      scbSceneSession.updateCurRectForMultiWindowToFull(this.panelModel.screenProperty);
      // 拉到前台
      SCBSceneSessionManager.getInstance()
        .requestSceneSessionActivation(sceneContainerSession?.primarySession?.session, true);
      (sceneContainerSession?.primarySession as SCBSceneSession).subSessionList = scbSceneSession.subSessionList;
      this.handleSubWindowTransform(scbSceneSession, this.panelModel.screenProperty?.screenId ?? 0);
      this.panelModel.scbSceneSessionArray.push(scbSceneSession);
      PadWithCarSceneManager.getInstance().setSceneSessionArray(this.panelModel.scbSceneSessionArray);
      this.panelModelChangeFunc?.(this.panelModel);
    }
  }

  private createContainerSession(sceneSession: sceneSessionManager.SceneSession,
    sceneInfo: SCBSceneInfo): SCBSceneContainerSession | undefined {
    if (CheckEmptyUtils.isEmpty(this.panelModel.screenProperty)) {
      log.showWarn('createContainerSession: screenProperty is undefined');
      return undefined;
    }
    sceneInfo.persistentId = sceneSession.persistentId;
    sceneInfo.screenId = this.panelModel.screenProperty?.screenId ?? 0;
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSession, sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(scbSceneSession, this.panelModel.screenProperty as SCBScreenProperty);
    scbSceneSession.sessionData.isNewWant = false;
    if (!CheckEmptyUtils.isEmpty(sceneContainerSession.primarySession)) {
      sceneContainerSession.primarySession?.setZOrder(0);
    }
    this.panelModel.appZOrder += 1;
    this.panelModelChangeFunc?.(this.panelModel);
    return sceneContainerSession;
  }

  private handleSubWindowTransform(sceneSession: SCBSceneSession, screenId?: number): void {
    // 子窗口迁移
    if (CheckEmptyUtils.isEmptyArr(sceneSession?.subSessionList)) {
      log.showWarn('handleSubWindowTransform, subSessionList is empty');
      return;
    }
    sceneSession?.subSessionList?.forEach((item: SCBSpecificSession) => {
      this.updateSessionDisplayId(item.session?.persistentId,
        screenId ?? SCBSceneSessionManager.getInstance().mainScreenId);
    });
  }

  private updateSessionDisplayId(persistentId: number, screenId: number): void {
    log.showInfo(`updateSessionDisplayId, persistentId:${persistentId}, screenId: ${screenId}`);
    try {
      SCBSceneSessionManager.getInstance().updateSessionDisplayId(persistentId, screenId);
    } catch (err) {
      log.showError(`updateSessionDisplayId failed, with reason ${JSON.stringify(err)}`);
    }
  }

  private requestSceneSessionBackground(sceneSession: sceneSessionManager.SceneSession | undefined,
    isDelegator?: boolean): void {
    if (CheckEmptyUtils.isEmpty(sceneSession)) {
      log.showWarn('requestSceneSessionBackground, sceneSession is empty');
      return;
    }
    SCBSceneSessionManager.getInstance().requestSceneSessionBackground(sceneSession, isDelegator);
  }

  private clearTimer(): void {
    if (this.sendReadyTimeId != 0) {
      clearTimeout(this.sendReadyTimeId);
    }
    this.sendReadyTimeId = 0;
  }

  private checkSubWin(subSessionList: SCBSpecificSceneSessionList | undefined, persistentId: number): boolean {
    let isSubSession: boolean = false;
    subSessionList?.forEach((specificSession: SCBSpecificSession) => {
      if (specificSession.session?.persistentId === persistentId) {
        isSubSession = true;
      }
    });
    return isSubSession;
  }

  public registerPanelModelChange(modelChangeCallback: Function): void {
    this.panelModelChangeFunc = modelChangeCallback;
  }

  public unregisterPanelModelChange(): void {
    this.panelModelChangeFunc = undefined;
  }
}