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
import { BasicSceneMissionTemplate } from './BasicSceneMissionTemplate';
import { SCBScenePanelMissionHandler } from '../missions/SCBScenePanelMissionHandler';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneInfo } from '../../session/SCBSceneInfo';
import { SCBTransferSceneOpts } from '../missions/SCBSceneMissionTypes';
import { SCBSceneSession } from '../../session/SCBSceneSession';
import { SCBSceneMissionChains } from '../missions/SCBSceneMissionChains';
import { SCBSceneContainerSession } from '../../session/SCBSceneContainerSession';
import { FocusChangeReason, SCBSceneSessionManager } from '../../../TsIndex';

const TAG: string = '[SCBMission]PopSceneOutOfPanelTemplate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Pop a scene out of curren panel.
 */
export class PopSceneOutOfPanelTemplate<T extends SCBScenePanelMissionHandler> extends BasicSceneMissionTemplate<T> {

  getLogTag(): string {
    return TAG;
  }

  getProcessor(): Function {
    return (persistentId, info, opts): SCBSceneSession => { return this.onProcess(persistentId, info, opts); };
  }

  private onProcess(persistentId: number, info: SCBSceneInfo, opts: SCBTransferSceneOpts): SCBSceneSession | null {
    log.showInfo(`${this.missionHandler.logTag}onProcess to pop out: id: ${persistentId}, name: ${info?.getName()}`);
    let sessionTuple = this.getExistMainSession(persistentId, info);
    if (!sessionTuple.sceneSession || !sessionTuple.containerSession) {
      log.showError(`not find sceneSession or containerSession to pop out`);
      return null;
    }
    this.popOutFromPanel(sessionTuple.sceneSession, sessionTuple.containerSession, opts);
    return sessionTuple.sceneSession;
  }

  protected popOutFromPanel(session: SCBSceneSession, containerSession: SCBSceneContainerSession,
    opts: SCBTransferSceneOpts): void {
    if (opts?.needBackground) {
      log.showInfo('will background before pop out');
      containerSession.requestBackground();
    }
    if (opts?.needRefreshFocus) {
      log.showInfo('will request unFocus before pop out');
      SCBSceneSessionManager.getInstance().requestUnfocus(session?.persistentId, FocusChangeReason.BACKGROUND);
    }

    SCBSceneMissionChains.popOutSceneFromChain(session, this.missionHandler);
    this.missionHandler.removeSceneContainerSession(containerSession);
    if (opts?.transferFinishedCallback) {
      opts?.transferFinishedCallback(session);
    }
  }
}