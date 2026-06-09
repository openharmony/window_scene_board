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
 
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  ACTIVE_STATUS_MAP,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSpecificSession
} from '@ohos/windowscene';
import MainSceneModel from '../model/MainSceneModel';
 
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, 'PadWithCarSceneViewModel');
const INVALID_INDEX: number = -1;
 
/**
 * PadWithCarSceneViewModel
 *
 * @since 2025-04-25
 */
export class PadWithCarSceneViewModel {
  private sceneModel: MainSceneModel = new MainSceneModel();
  private sceneModelChangeFunc: Function | undefined;
  private createSubSession = (sceneSession: SCBSceneSession, specificSession: sceneSessionManager.SceneSession) => {
    SCBSceneSessionManager.getInstance()
      .updateSessionDisplayId(specificSession?.persistentId, this.sceneModel.screenProperty?.screenId);
    if (this.sceneModel.sceneSession?.session?.persistentId === specificSession?.parentId) {
      const index = this.sceneModel.subSessionList?.findIndex(item => {
        return item.session.persistentId === specificSession.persistentId;
      }) ?? INVALID_INDEX;
      log.showInfo(`createSubSession: id = ${specificSession.persistentId} parentId = ${specificSession.parentId} index = ${index}`);
      if (index === INVALID_INDEX) {
        let hwSceneSession = new SCBSpecificSession(specificSession, this.subSessionStateChange,
          this.subSessionRaiseToTop, this.subSessionRaiseAboveTarget);
        this.sceneModel.subSessionList?.push(hwSceneSession);
        this.sceneModelChangeFunc?.(this.sceneModel);
      }
    }
  }
  private subSessionStateChange = (parentId: number,
    persistentId: number, state: sceneSessionManager.SessionState): void => {
    const index = this.sceneModel.subSessionList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    const isActive = ACTIVE_STATUS_MAP.get(state);
    if (index === INVALID_INDEX || isActive === undefined) {
      log.showWarn(`subSessionStateChange: not find subSession id = ${persistentId}, state = ${state}`);
      return;
    }
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      this.sceneModel.subSessionList.splice(index, 1);
      this.sceneModelChangeFunc?.(this.sceneModel);
      log.showWarn(`subSessionStateChange: remove subSession id: ${persistentId}`);
      return;
    }
    const curSession = this.sceneModel.subSessionList[index];
    if (isActive) {
      log.showInfo('subSessionStateChange: update session info');
      this.sceneModel.subSessionList.splice(index, 1, curSession);
      this.sceneModelChangeFunc?.(this.sceneModel);
    }
    curSession.isActive = isActive;
    curSession.sessionData.sessionState = state;
  }
  private subSessionRaiseToTop = (parentId: number, persistentId: number, raiseParent: boolean): void => {
    const index = this.sceneModel.subSessionList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === INVALID_INDEX) {
      log.showWarn(`subSessionRaiseToTop: can not find subSession with id ${persistentId}`);
      return;
    }
    const curSession = this.sceneModel.subSessionList[index];
    this.sceneModel.subSessionList.splice(index, 1, curSession);
    this.sceneModelChangeFunc?.(this.sceneModel);
  }
  private subSessionRaiseAboveTarget = (parentId: number, persistentId: number, targetSubWindowId: number): void => {
    if (persistentId === targetSubWindowId) {
      log.showWarn(`subSessionRaiseToTop: persistentId ${persistentId} is no change, skip!`);
      return;
    }
    const index = this.sceneModel.subSessionList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index === INVALID_INDEX) {
      log.showWarn(`subSessionRaiseToTop: can not find subSession with id ${persistentId}`);
      return;
    }
    const curSession = this.sceneModel.subSessionList[index];
    this.sceneModel.subSessionList.splice(index, 1);
    this.sceneModelChangeFunc?.(this.sceneModel);
    const targetIndex = this.sceneModel.subSessionList.findIndex(item => {
      return item.session.persistentId === targetSubWindowId;
    });
    if (targetIndex === INVALID_INDEX) {
      log.showWarn(`subSessionRaiseToTop: can not find subSession with targetSubWindowId ${persistentId}`);
    }
    this.sceneModel.subSessionList.splice(targetIndex + 1, 0, curSession);
    this.sceneModelChangeFunc?.(this.sceneModel);
  }
  private createDialogSession = (specificSession: sceneSessionManager.SceneSession) => {
    if (this.sceneModel.sceneSession) {
      this.createSubSession(this.sceneModel.sceneSession, specificSession);
    }
  }
 
  /**
   * init
   *
   * @param sceneModel scene 相关数据
   * @param modelChangeCallback 数据变化回调
   */
  public init(sceneModel: MainSceneModel, modelChangeCallback: Function): void {
    this.sceneModel = sceneModel;
    this.sceneModel.sceneSession?.registerCreateDialogCallback(this.createDialogSession);
    this.sceneModel.sceneSession?.session?.on('createSpecificSession', (specificSession) => {
      log.showInfo(`createSpecificSession: persistentId = ${specificSession?.persistentId}`);
      this.createDialogSession(specificSession);
    });
    this.sceneModelChangeFunc = modelChangeCallback;
    this.updateSubSession();
  }
 
  /**
   * deInit
   */
  public deInit(): void {
    this.unregisterSubSession();
    this.sceneModel.sceneSession?.unRegisterAll();
    this.sceneModelChangeFunc = undefined;
  }
 
  private updateSubSession(): void {
    if (this.sceneModel.sceneSession === undefined) {
      log.showWarn(`updateSubSession: sceneSession is undefined`);
      return;
    }
    this.sceneModel.subSessionList = this.sceneModel.sceneSession.subSessionList;
    log.showInfo(`updateSubSession: subSessionLength = ${this.sceneModel.subSessionList.length}`);
    this.sceneModel.subSessionList?.forEach((specificSession: SCBSpecificSession) => {
      specificSession?.registerSubSessionRaiseToTopCallback(this.subSessionRaiseToTop);
      specificSession?.registerSubSessionRaiseAboveTargetCallback(this.subSessionRaiseAboveTarget);
      specificSession?.registerStateChangeCallback(this.subSessionStateChange);
    });
    this.sceneModelChangeFunc?.(this.sceneModel);
  }
 
  private unregisterSubSession(): void {
    if (this.sceneModel.sceneSession === undefined) {
      log.showWarn(`unregisterSubSession: sceneSession is undefined`);
      return;
    }
    this.sceneModel.sceneSession.subSessionList?.forEach((specificSession: SCBSpecificSession) => {
      specificSession?.unregisterSessionStateChangeCallback(this.subSessionStateChange);
    });
  }
}