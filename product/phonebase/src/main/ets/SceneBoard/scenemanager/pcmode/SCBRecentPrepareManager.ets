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
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScenePanelManager,
  SCBSceneSessionManager,
  SCBSceneSession
} from '@ohos/windowscene';

const TAG = 'SCBRecentPrepareManager';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentPrepareManager {
  private static instance: SCBRecentPrepareManager | null = null;
  private hideContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  private recentPreparePersistentIds: number[] = [];

  /**
   * Obtains the SCBRecentPrepareManager object.
   *
   * @return RecentFocusManager
   */
  public static getInstance(): SCBRecentPrepareManager {
    if (!SCBRecentPrepareManager.instance) {
      SCBRecentPrepareManager.instance = new SCBRecentPrepareManager();
    }
    return SCBRecentPrepareManager.instance;
  }

  public isPcAppInPadByContainer(sceneContainer: SCBSceneContainerSession): boolean {
    let result: boolean = false;
    if (!sceneContainer) {
      log.showInfo('isPcAppInPadByContainer container invalid');
      return result;
    }
    if (sceneContainer.primarySession && sceneContainer.primarySession.isPcAppInPad) {
      result = true;
    }
    if (sceneContainer.secondarySession && sceneContainer.secondarySession.isPcAppInPad) {
      result = true;
    }
    log.showInfo(`isPcAppInPadByContainer ${sceneContainer.getName()} ${result}`);
    return result;
  }

  /**
   * 预关闭，关闭persistentId的窗口
   * @param persistentId
   * @param sceneContainer
   * @param restoreBack 当预关闭接口返回true，触发该回调
   * @param closeCallBack 当预关闭返回false，触发该回调
   */
  public close(persistentId: number, sceneContainer: SCBSceneContainerSession, restoreBack: Function,
    closeCallBack: Function):void {
    if (!sceneContainer) {
      return;
    }
    try {
      const isPrepareTerminate = SCBSceneSessionManager.getInstance().prepareTerminate(persistentId);
      log.showInfo(`close isPrepareTerminate: ${isPrepareTerminate} ${sceneContainer.getName()} ${persistentId}`);
      if (isPrepareTerminate) {
        restoreBack();
      } else {
        closeCallBack();
      }
    } catch (e) {
      log.showError(`close error, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  /**
   * 预关闭异步接口，关闭persistentId的窗口
   * @param persistentId
   * @param sceneContainer
   * @param restoreBack 当预关闭接口返回true，触发该回调
   * @param closeCallBack 当预关闭返回false，触发该回调
   */
  public closeAsync(persistentId: number, sceneContainer: SCBSceneContainerSession, restoreBack: Function,
    closeCallBack: Function):void {
    if (!sceneContainer) {
      return;
    }
    try {
      const currentSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      currentSessionManager.asyncPrepareTerminate(persistentId, (err, isPrepareTerminate) => {
        log.showInfo(`closeAsync isPrepareTerminate: ${isPrepareTerminate} ${sceneContainer.getName()}`);
        if (isPrepareTerminate) {
          restoreBack();
        } else {
          closeCallBack();
        }
      });
    } catch (e) {
      log.showError(`closeAsync error, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  public addHideContainerSession(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      log.showError(`addHideContainerSession containerSession invalid`);
      return;
    }
    this.hideContainerSessionList.push(containerSession);
  }

  public isHideContainerSession(containerSession: SCBSceneContainerSession): boolean {
    if (!containerSession) {
      log.showError(`isHideContainerSession containerSession invalid`);
      return false;
    }
    const index = this.hideContainerSessionList.findIndexByContainerId(containerSession.containerId);
    return index === -1 ? false : true;
  }

  public clearHideContainerSession(): void {
    this.hideContainerSessionList.clear();
  }

  public getRecentPreparePersistentIds(): number[] {
    return this.recentPreparePersistentIds;
  }

  public addRecentPreparePersistentIds(persistentId: number | undefined): void {
    if (persistentId === undefined) {
      return;
    }
    const index = this.recentPreparePersistentIds.findIndex((id) => id === persistentId);
    if (index !== -1) {
      log.showError(`Repeatedly add ${persistentId}`);
      return;
    }
    this.recentPreparePersistentIds.push(persistentId);
  }

  public clearData(): void {
    this.recentPreparePersistentIds = [];
    this.hideContainerSessionList.clear();
  }

  // ================================ PAD 普通模式 ======================================================
  public restorePrepareContainer(): void {
    if (!this.recentPreparePersistentIds || this.recentPreparePersistentIds.length === 0) {
      log.showInfo('restorePrepareContainer empty');
      return;
    }
    log.showInfo(`restorePrepareContainer ${this.recentPreparePersistentIds.join(',')}`);
    this.recentPreparePersistentIds.forEach((persistentId) => {
      const notShowRecentList = SCBScenePanelManager.getInstance().getNotShowRecentList();
      let index = notShowRecentList.findIndex((item) => {
        return item.primarySession?.session.persistentId === persistentId ||
          item.secondarySession?.session.persistentId === persistentId;
      });
      if (index === -1) {
        return;
      }
      const container = notShowRecentList[index];
      if (this.isHideContainerSession(container)) {
        return;
      }
      log.showInfo(`restorePrepareContainer notShow to show ${container.getName()}`);
      SCBScenePanelManager.getInstance().addSceneContainerSessionAndRemoveNotShow(container);
    });
    this.clearData();
  }

  /**
   *
   * @param sceneContainerSession 预关闭窗口
   * @param isRecentStateCallBack function,判断当前状态是否是任务中心
   */
  public prepareTerminateSceneContainer(sceneContainerSession: SCBSceneContainerSession,
    isRecentStateCallBack: Function): void {
    if (!sceneContainerSession) {
      log.showError('closeSingleAppContainerSessionAsync invalid containerSession');
      return;
    }
    const persistentId = sceneContainerSession.primarySession?.session.persistentId as number;
    const panelManager = SCBScenePanelManager.getInstance();

    const prepareCallBack = () => {
      const containerSession: SCBSceneContainerSession | null =
        this.getSceneContainerSessionWithPersistentId(persistentId);
      if (!containerSession) {
        return;
      }
      if (isRecentStateCallBack()) {
        this.addRecentPreparePersistentIds(persistentId);
      } else {
        panelManager.addSceneContainerSessionAndRemoveNotShow(containerSession);
      }
    }
    const notPrepareCallBack = () => {
      const containerSession: SCBSceneContainerSession | null =
        this.getSceneContainerSessionWithPersistentId(persistentId);
      if (!containerSession) {
        return;
      }
      SCBSceneSessionManager.getInstance().close(containerSession.primarySession?.sceneInfo.screenId, persistentId);
    };
    this.closeAsync(persistentId, sceneContainerSession, prepareCallBack, notPrepareCallBack);
  }

  private getSceneContainerSessionWithPersistentId(persistentId: number): SCBSceneContainerSession | null {
    const sessionTuple: [SCBSceneContainerSession | null, SCBSceneSession | null] =
      SCBScenePanelManager.getInstance().getSceneContainerSessionAndSceneSessionByPersistentId(persistentId);
    const containerSession: SCBSceneContainerSession | null = sessionTuple[0];
    return containerSession;
  }

  // ================================ PAD 普通模式 ======================================================
}