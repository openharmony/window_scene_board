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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneContainerSession } from '../session/SCBSceneContainerSession';
import type { MidSceneMap } from '../session/SCBSceneContainerSession';
import { SCBSceneMode } from '../session/SCBSceneInfo';
import sceneSessionManager from '@ohos.sceneSessionManager';

const TAG = 'SCBSceneRecentMissionManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class SCBSceneRecentMissionManager {
  private recentMissionIdSet: Set<number> = new Set();
  private recentFloatMissionSet: Set<number> = new Set();

  public updateRecentFloatMissionSet(windowMode: SCBSceneMode, persistentId: number): void {
    if (windowMode === SCBSceneMode.FLOATING) {
      if (this.recentMissionIdSet.has(persistentId)) {
        this.recentMissionIdSet.delete(persistentId);
      }
      if (this.recentFloatMissionSet.has(persistentId)) {
        this.recentFloatMissionSet.delete(persistentId);
      }
      this.recentFloatMissionSet.add(persistentId);
      log.showInfo(`add id ${persistentId} to recentFloatMissionSet`);
    } else if (windowMode === SCBSceneMode.FULLSCREEN) {
      this.recentFloatMissionSet.delete(persistentId);
      this.recentMissionIdSet.add(persistentId);
      log.showInfo(`move id ${persistentId} from recentFloatMissionSet to recentMissionIdSet`);
    }
    this.updateRecentMainSessionList();
  }

  public updateRecentMissionIdSet(containerSession: SCBSceneContainerSession): void {
    if (containerSession.isFloat) {
      this.updateRecentFloatMissionSet(SCBSceneMode.FLOATING, containerSession.getPersistentId());
      return;
    }
    if (!containerSession.isMidScene) {
      this.addToRecentMissionIdSet(containerSession.primarySession?.session.persistentId);
      if (containerSession.isSplit) {
        this.addToRecentMissionIdSet(containerSession.secondarySession?.session.persistentId);
      }
    } else {
      for (let persistentId of containerSession.midSceneMap.keys()) {
        this.addToRecentMissionIdSet(persistentId);
      }
    }
    this.updateRecentMainSessionList();
  }

  public removeSessionFromRecentMissionIdSet(persistentId: number): void {
    log.showInfo(`remove id ${persistentId} from recentMissionIdSet`);
    this.recentMissionIdSet.delete(persistentId);
    this.updateRecentMainSessionList();
  }

  public updateRecentMissionIdSetByMidScene(persistentId: number): void {
    this.addToRecentMissionIdSet(persistentId);
  }

  public initRecentMissionIdSet(recoverSessionIdList: Array<number>): void {
    this.recentMissionIdSet = new Set(recoverSessionIdList);
    this.updateRecentMainSessionList();
  }

  private addToRecentMissionIdSet(persistentId: number | undefined): void {
    if (!persistentId) {
      return;
    }
    if (this.recentMissionIdSet.has(persistentId)) {
      this.recentMissionIdSet.delete(persistentId);
    }
    this.recentFloatMissionSet.delete(persistentId);
    this.recentMissionIdSet.add(persistentId);
    log.showInfo(`add id ${persistentId} to recentMissionIdSet`);
  }

  /**
   * update recent main session list to native
   */
  private updateRecentMainSessionList(): void {
    try {
      sceneSessionManager.updateRecentMainSessionList([...this.recentMissionIdSet,
        ...this.recentFloatMissionSet].reverse());
    } catch (err) {
      log.showError('updateRecentMainSessionList failed, with reason: ' + JSON.stringify(err));
    }
  }
};