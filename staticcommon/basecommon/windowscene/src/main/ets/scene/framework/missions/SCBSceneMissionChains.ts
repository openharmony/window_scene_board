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
import { LogDomain, Logger } from '@ohos/basicutils';
import { SCBSceneSession } from '../../session/SCBSceneSession';
import { SCBScenePanelMissionHandler } from './SCBScenePanelMissionHandler';

const TAG = 'SCBSceneMissionChains';
const log = Logger.getLogHelper(LogDomain.WINDOW);

/**
 * 任务链管理
 */
export class SCBSceneMissionChains {

  /**
   * 从任务链中弹出Session
   * @description 对弹出的Session，链接其CallerSession和ToSession
   * @param session target session will pop out
   * @param panelMissionHandler source panel which the target session on it
   */
  public static popOutSceneFromChain(session: SCBSceneSession | null,
    panelMissionHandler: SCBScenePanelMissionHandler): void {
    if (!session || !session.sceneInfo || !panelMissionHandler) {
      log.showWarn(TAG, 'popOutSceneFromChain invalid param.');
      return;
    }
    log.showInfo(TAG, `popOutSceneFromChain, callerId=${session.sceneInfo.callerPersistentId}` +
      `, toId=${session.sceneInfo.toPersistentId}`);
    if (session.sceneInfo.callerPersistentId && session.sceneInfo.callerPersistentId > 0) {
      let callerMainSessionTuple = panelMissionHandler.getMainSessionTupleById(session.sceneInfo.callerPersistentId);
      if (callerMainSessionTuple && callerMainSessionTuple.sceneSession &&
        callerMainSessionTuple.sceneSession.sceneInfo) {
        callerMainSessionTuple.sceneSession.sceneInfo.toPersistentId = session.sceneInfo.toPersistentId;
      }
    }
    if (session.sceneInfo.toPersistentId && session.sceneInfo.toPersistentId > 0) {
      let toMainSessionTuple = panelMissionHandler.getMainSessionTupleById(session.sceneInfo.toPersistentId);
      if (toMainSessionTuple && toMainSessionTuple.sceneSession &&
        toMainSessionTuple.sceneSession.sceneInfo) {
        toMainSessionTuple.sceneSession.sceneInfo.callerPersistentId = session.sceneInfo.callerPersistentId;
      }
    }
    session.sceneInfo.callerPersistentId = 0;
    session.sceneInfo.toPersistentId = 0;
  }
}