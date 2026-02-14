/*
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
  SCBSpecificSceneSessionList,
  ACTIVE_STATUS_MAP,
  SCBScreenProperty,
  SCBSceneSessionManager
} from '../../../TsIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSpecificScenePanelDebugCommands } from '../../dump/SCBSpecificScenePanelDebugCommands';
import { LogDomain, Logger } from '@ohos/basicutils';
import { SCBSpecificSession } from '../../session/SCBSpecificSession';
import { SCBSpecificSceneManager, SCBSpecificScenePanelHandler } from '../../manager/SCBSpecificSceneManager';

const TAG: string = 'SCBBaseSpecificScenePanelViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.WINDOW);

export abstract class SCBBaseSpecificScenePanelViewModel implements SCBSpecificScenePanelHandler {
  public screenId: number = 0;
  public zorder: number = 0;
  public screenProperty: SCBScreenProperty;
  public specificSceneSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();

  protected debugCommands: SCBSpecificScenePanelDebugCommands | null = null;

  protected createSpecificScene = (specificSession: sceneSessionManager.SceneSession): void => {
    this.onCreateSpecificScene(specificSession);
  }
  protected sessionStateChange = (parentId: number, persistentId: number,
    state: sceneSessionManager.SessionState): void => {
    this.onSessionStateChange(persistentId, state);
  };
  protected destroySpecificSceneWhenParentDestroy = (session: sceneSessionManager.SceneSession) => {
    this.onParentSessionGoDestroy(session);
  };
  protected getSpecificSessionList = (): SCBSpecificSceneSessionList => {
    return this.getSpecificSceneSessionList();
  };

  constructor(screenProperty: SCBScreenProperty) {
    this.screenId = screenProperty.screenId;
    this.screenProperty = screenProperty;
  }

  /**
   * init when view aboutToAppear
   * @param zorder must refresh zorder of specific scene panel
   */
  public init(zorder: number): void {
    this.zorder = zorder;
    this.initDebugCommands();
    this.debugCommands?.register();
    this.registerSessionManagerListeners();
    SCBSpecificSceneManager.getInstance().registerSpecificScenePanelHandler(this);
  }

  /**
   * release when view aboutToDisappear
   */
  public release(): void {
    this.debugCommands?.unregister();
    this.unregisterSessionManagerListeners();
    SCBSpecificSceneManager.getInstance().unregisterSpecificScenePanelHandler(this);
  }

  protected registerSessionManagerListeners(): void {
    SCBSceneSessionManager.getInstance().registerCreateSpecificSceneCallback(this.createSpecificScene,
      this.zorder, this.screenId);
    SCBSceneSessionManager.getInstance().registerDestroyFloatWindowCallback(this.destroySpecificSceneWhenParentDestroy,
      this.zorder, this.screenId);
    SCBSceneSessionManager.getInstance().registerGetSpecificContainerSessionListCallback(this.getSpecificSessionList,
      this.zorder, this.screenId);
  }

  protected unregisterSessionManagerListeners(): void {
    SCBSceneSessionManager.getInstance().unregisterCreateSpecificSceneCallback(this.zorder, this.screenId);
    SCBSceneSessionManager.getInstance().unregisterDestroyFloatWindowCallback(
      this.destroySpecificSceneWhenParentDestroy, this.zorder, this.screenId);
    SCBSceneSessionManager.getInstance().unregisterGetSpecificContainerSessionListCallback(this.zorder, this.screenId);
  }

  public getSpecificSceneSessionList(): SCBSpecificSceneSessionList {
    return this.specificSceneSessionList;
  }

  /**
   * must override to provide custom zIndex of SpecificScenePanel according zOrder
   * @returns zIndex
   */
  public abstract getZIndex(): number;

  /**
   * must init custom debug commands after constructor
   */
  protected initDebugCommands(): void {
    this.debugCommands = new SCBSpecificScenePanelDebugCommands(this.specificSceneSessionList, this.getZIndex());
  }

  protected onCreateSpecificScene(specificSession: sceneSessionManager.SceneSession): void {
    log.showInfo(TAG, `onCreateSpecificScene`);
    const indexInAll = this.specificSceneSessionList.findIndex(item => {
      return item.session?.persistentId === specificSession?.persistentId;
    });
    if (indexInAll === -1) {
      let hwSceneSession = new SCBSpecificSession(specificSession, this.sessionStateChange);
      this.specificSceneSessionList.push(hwSceneSession);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    } else {
      log.showInfo(TAG, `Session is already in subList, id: ${specificSession.persistentId}, index: ${indexInAll}`);
    }
  }

  protected onSessionStateChange(persistentId: number, state: sceneSessionManager.SessionState): void {
    const index = this.specificSceneSessionList.findIndex(item => {
      return item.session.persistentId === persistentId;
    });
    if (index !== -1) {
      let isActive = ACTIVE_STATUS_MAP.get(state)
      if (isActive == undefined || !this.specificSceneSessionList[index]) {
        return;
      }
      this.specificSceneSessionList[index].isActive = isActive;
      SCBSceneSessionManager.getInstance().updateHomeOccludedState(this.specificSceneSessionList, this.zorder);
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        this.specificSceneSessionList.splice(index, 1);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        return;
      }
      log.showInfo(TAG, 'onSubSessionActiveStatueChange persistentId: ' + persistentId + ', isActive: ' +
      this.specificSceneSessionList[index].isActive + ', length: ' + this.specificSceneSessionList.length + ', state:' + state);
    }
  }

  protected onParentSessionGoDestroy(sceneSession: sceneSessionManager.SceneSession): void {
    log.showInfo(TAG, `onParentSessionDestroy will destroy specific session.`);
    let index = this.specificSceneSessionList.findIndex((specificSession) => {
      return specificSession.session?.parentId === sceneSession?.persistentId;
    });
    if (index !== -1) {
      this.specificSceneSessionList.splice(index, 1);
    }
  }

  public pushInSpecificSession(sessionList: SCBSpecificSceneSessionList, fromScreenId: number): void {
    log.showInfo(TAG, `pushIn specificSceneSession: ${sessionList?.length} from screen: ${fromScreenId}`);
  }
}
