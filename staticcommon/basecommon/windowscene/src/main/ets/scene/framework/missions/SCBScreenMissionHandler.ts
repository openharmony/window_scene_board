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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneInfo } from '../../session/SCBSceneInfo';
import { INVALID_PERSISTENT_ID, SCBSceneSession } from '../../session/SCBSceneSession';
import { DEFAULT_TOTAL_LIST_TAG, SCBScenePanelMissionHandler } from './SCBScenePanelMissionHandler';
import { JSON } from '@kit.ArkTS';
import { 
  SCBMainSessionTuple,
  SCBStartSceneOpts,
  SCBTerminateSceneOpts, 
  SCBTransferSceneOpts,
  SCBTransitionSceneOpts,
  SCBMinimizeSceneOpts
} from './SCBSceneMissionTypes';
import { SCBSceneContainerSession, SCBScreenSession, SCBScreenSessionManager } from '../../../TsIndex';
import { CommonResult } from '../../../scene/utils/SCBSceneUtils';

const TAG = '[SCBMission]SCBScreenMissionHandler';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Scene mission management on single screen, holds multiple scene panels.
 */
export class SCBScreenMissionHandler {
  screenId: number;
  screenSession: SCBScreenSession;
  private panelHandlers: Set<SCBScenePanelMissionHandler> = new Set();

  constructor(screenId: number) {
    this.screenId = screenId;
    this.screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenId);
  }

  public get logTag(): string {
    return `[Screen:${this.screenId}]`;
  }

  // ----------------------------------------------------------------------------------------------------
  // Panels Management on screen
  // ----------------------------------------------------------------------------------------------------
  public get panelCount(): number {
    return this.panelHandlers.size;
  }

  /**
   * while SCBScenePanel appear, attached.
   * @param handler MissionHandler of panel.
   */
  public onPanelAttach(handler: SCBScenePanelMissionHandler): void {
    log.showInfo(`${handler?.logTag} online`);
    if (!handler) {
      return;
    }
    this.panelHandlers.add(handler);
  }

  /**
   * while SCBScenePanel disappear, detached
   * @param handler MissionHandler of panel.
   */
  public onPanelDetach(handler: SCBScenePanelMissionHandler): void {
    log.showInfo(`${handler?.logTag} offline`);
    handler?.onTerminateAllScene();
    this.panelHandlers.delete(handler);
  }

  /**
   * while screen disconnect, clear all panels.
   */
  public clearAllPanels(): void {
    log.showInfo('clear all panel handler');
    this.panelHandlers.forEach((item) => {
      item.onTerminateAllScene();
    });
    this.panelHandlers.clear();
  }

  // ----------------------------------------------------------------------------------------------------
  // Session Management on screen
  // ----------------------------------------------------------------------------------------------------
  /**
   * find main session tuple on this screen
   * @param info session info
   * @param excludePanel optional exclude panel
   * @returns SCBMainSessionTuple
   */
  public findMainSessionTupleByInfo(info: SCBSceneInfo, excludePanel?: number): SCBMainSessionTuple {
    for (let panelHandler of this.panelHandlers.values()) {
      if (excludePanel !== undefined && panelHandler.panelId === excludePanel) {
        log.showInfo(`panel ${excludePanel} excluded to getMainSessionTupleByInfo`);
        continue;
      }
      const sessionTuple = panelHandler.getMainSessionTupleByInfo(info);
      if (sessionTuple.sceneSession && sessionTuple.containerSession) {
        return sessionTuple;
      }
    }
    return { sceneSession: null, containerSession: null };
  }

  /**
   * find main session tuple on this screen
   * @param persistentId session persistentId
   * @param excludePanel optional exclude panel
   * @returns SCBMainSessionTuple
   */
  public findMainSessionTupleByPersistentId(persistentId: number, excludePanel?: number): SCBMainSessionTuple {
    for (let panelHandler of this.panelHandlers.values()) {
      if (excludePanel !== undefined && panelHandler.panelId === excludePanel) {
        log.showInfo(`panel ${excludePanel} excluded to getMainSessionTupleByPersistentId`);
        continue;
      }
      const sessionTuple = panelHandler.getMainSessionTupleById(persistentId);
      if (sessionTuple.sceneSession && sessionTuple.containerSession) {
        return sessionTuple;
      }
    }
    return { sceneSession: null, containerSession: null };
  }

  // ----------------------------------------------------------------------------------------------------
  // Scene Mission Management on screen
  // ----------------------------------------------------------------------------------------------------
  /**
   * StartScene
   * @param toInfo target session info
   * @param opts options
   */
  public startScene(toInfo: SCBSceneInfo, opts: SCBStartSceneOpts): void {
    this.panelHandlers.forEach((item) => {
      item.onStartScene(toInfo, opts);
    });
  }

  /**
   * start one scene to another
   * @param toInfo target session info
   * @param fromInfo from session info
   * @param opts options
   */
  public startSceneTransition(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo,
    opts?: SCBTransitionSceneOpts): CommonResult {
    let startResult: CommonResult = CommonResult.SUCCESS;
    this.panelHandlers.forEach((item) => {
      if (item) {
        if (item.onStartSceneTransition(toInfo, fromInfo, opts) === CommonResult.FAIL) {
          startResult = CommonResult.FAIL;
        }
      }
    });
    return startResult;
  }

  /**
   * start scene from other on this screen
   * @param sceneInfo target session info
   */
  public startSceneFromOther(sceneInfo: SCBSceneInfo): CommonResult {
    let startResult: CommonResult = CommonResult.SUCCESS;
    this.panelHandlers.forEach((item) => {
      if (item) {
        if (item.onStartSceneFromOther(sceneInfo) === CommonResult.FAIL) {
          startResult = CommonResult.FAIL;
        }
      }
    });
    return startResult;
  }

  /**
   * terminate scene on this screen
   * @param persistentId optional persistent id
   * @param containerId optional container id
   * @param opts options
   */
  public terminateScene(persistentId?: number, containerId?: number, opts?: SCBTerminateSceneOpts): void {
    this.panelHandlers.forEach((item) => {
      item?.onTerminateScene(persistentId, containerId, opts);
    });
  }

  /**
   * minimize scene on this screen
   * @param persistentId optional persistent id
   * @param containerId optional container id
   * @param opts options
   */
  public minimizeScene(persistentId?: number, containerId?: number, opts?: SCBMinimizeSceneOpts): void {
    this.panelHandlers.forEach((item) => {
      item?.onMinimizeScene(persistentId, containerId, opts);
    });
  }

  /**
   * pop scene out by persistentId
   * @param session target session
   * @param opts options
   * @returns SCBSceneSession
   */
  public popSceneOut(persistentId: number, sceneInfo: SCBSceneInfo,
    opts: SCBTransferSceneOpts): SCBSceneSession | null {
    if ((persistentId === undefined || persistentId <= INVALID_PERSISTENT_ID) && !sceneInfo) {
      log.showError('popSceneOut invalid params');
      return null;
    }
    log.showInfo(`${this.logTag} popSceneOut persistentId: ${persistentId} ` +
      `info: ${sceneInfo?.getName()} params: ${JSON.stringify(opts)}`);
    for (let handler of this.panelHandlers) {
      const sourceSession = handler.onPopSceneOut(persistentId, sceneInfo, opts);
      if (sourceSession != null) {
        log.showInfo(`popSceneOut from ${handler.logTag} successful`);
        return sourceSession;
      }
    }
    log.showError(`popSceneOut failed, no panel response`);
    return null;
  }

  /**
   * push scene into this screen
   * @param session target session
   * @param params options
   */
  public pushSceneIn(session: SCBSceneSession, params: SCBTransferSceneOpts): CommonResult {
    log.showInfo(`will pushSceneIn ${session.persistentId} on ${this.screenId}.`);
    for (let handler of this.panelHandlers) {
      if (handler) {
        const result = handler.onPushSceneIn(session, params);
        if (result && result.isSuccess()) {
          log.showInfo(`pushSceneIn to panel ${handler.logTag} successful.`);
          return CommonResult.SUCCESS;
        }
      }
    }
    log.showError(`pushSceneIn to screen: ${this.screenId} failed.`);
    return CommonResult.FAIL;
  }

  /**
   * get target screen top active scene session
   * @param usage
   */
  public getTopActiveSession(usage: string = DEFAULT_TOTAL_LIST_TAG): SCBSceneContainerSession | null {
    for(const handler of this.panelHandlers.values()) {
      const session = handler.getTopActiveSession(usage);
      if (session !== null && session !== undefined) {
        return session;
      }
    }
    return null;
  }
}