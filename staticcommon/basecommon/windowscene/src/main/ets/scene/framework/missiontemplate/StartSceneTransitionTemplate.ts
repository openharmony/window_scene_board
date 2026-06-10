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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonResult } from '../../../scene/utils/SCBSceneUtils';
import { SCBSceneContainerSession } from '../../../TsIndex';
import { SCBMainSessionTuple, SCBTransitionSceneOpts } from '../../SceneModuleIndex';
import { SCBSceneInfo } from '../../session/SCBSceneInfo';
import { DEFAULT_TOTAL_LIST_TAG, SCBScenePanelMissionHandler } from '../missions/SCBScenePanelMissionHandler';
import { BasicSceneMissionTemplate } from './BasicSceneMissionTemplate';

const TAG = '[SCBMission]StartSceneTransitionTemplate';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class StartSceneTransitionTemplate<T extends SCBScenePanelMissionHandler> extends BasicSceneMissionTemplate<T> {
  private fromContainerSession: SCBSceneContainerSession | null = null;
  private toContainerSession: SCBSceneContainerSession | null = null;

  getLogTag(): string {
    return TAG;
  }

  getProcessor(): Function {
    return (toInfo, fromInfo, opts) => { this.onProcess(toInfo, fromInfo, opts); };
  }

  private onProcess(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo, opts: SCBTransitionSceneOpts): CommonResult {
    log.showInfo('Start scene transition, toInfo: ' + toInfo.toJsonString() + 'fromInfo: ' + fromInfo.toJsonString());
    if (!this.preprocess(toInfo)) {
      log.showError(`Preprocess failed, ignored start this time.`);
      return CommonResult.FAIL;
    }

    let sessionTuple = this.getOrCreateSceneAndContainerSession(toInfo);
    if (sessionTuple.sceneSession == null || sessionTuple.containerSession == null) {
      log.showError(`Failed to get or create session.`);
      return CommonResult.FAIL;
    }
    if (!this.beforeSceneAppear(sessionTuple, fromInfo, opts)) {
      log.showError(`BeforeSceneAppear failed. persistentId: ${toInfo?.persistentId}`);
      return CommonResult.FAIL;
    }

    this.startScene(opts);
    this.animate();
    this.postprocess(opts);
    return CommonResult.SUCCESS;
  }

  protected preprocess(toInfo: SCBSceneInfo): boolean {
    const toSession = this.missionHandler.getContainerSessionBySceneInfo(toInfo);
    if (toSession.isActive) {
      log.showWarn('target session already on top active, ignore start');
      return false;
    }
    return true;
  }

  protected beforeSceneAppear(sessionTuple: SCBMainSessionTuple, fromInfo: SCBSceneInfo,
    opts?: SCBTransitionSceneOpts): boolean {
    this.fromContainerSession = this.missionHandler.getContainerSessionBySceneInfo(fromInfo);
    this.toContainerSession = sessionTuple.containerSession;
    return true;
  }

  protected startScene(opts?: SCBTransitionSceneOpts): void {
    if (!this.toContainerSession) {
      return;
    }
    this.missionHandler.raiseSceneToTopInList(this.toContainerSession, DEFAULT_TOTAL_LIST_TAG);
    this.toContainerSession.requestActivation();
  }

  protected animate(): void {
  }

  protected postprocess(opts?: SCBTransitionSceneOpts): void {
    this.fromContainerSession?.requestBackground();
  }
}