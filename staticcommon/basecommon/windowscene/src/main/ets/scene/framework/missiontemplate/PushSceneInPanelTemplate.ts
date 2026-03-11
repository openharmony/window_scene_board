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
import {
  SCBMainSessionTuple,
  SCBSceneContainerSession,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSpecificSession,
  SCBTransferSceneOpts,
  SceneDataCategory
} from '../../../TsIndex';
import { SCBScenePanelMissionHandler } from '../missions/SCBScenePanelMissionHandler';
import { BasicSceneMissionTemplate } from './BasicSceneMissionTemplate';
import { CommonResult } from '../../utils/SCBSceneUtils';

const TAG = '[SCBMission]PushSceneIntoPanelTemplate';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class PushSceneIntoPanelTemplate <T extends SCBScenePanelMissionHandler> extends BasicSceneMissionTemplate<T> {

  getLogTag(): string {
    return TAG;
  }

  getProcessor(): Function {
    return (session, opts) => { return this.onProcess(session, opts); };
  }

  private onProcess(session: SCBSceneSession, opts: SCBTransferSceneOpts): CommonResult {
    if (!this.preProcess(session, opts)) {
      log.showError(`Preprocess failed, ignored push in this time`);
      return CommonResult.FAIL;
    }
    let containerSession = new SCBSceneContainerSession(session, this.missionHandler.screenProperty);
    this.pushIntoPanel(session, containerSession, opts);
    this.postprocess(session, opts);
    return CommonResult.SUCCESS;
  }

  /**
   * pre-process when push into panel
   *
   * @returns true to continue push in, false neither
   */
  protected preProcess(session: SCBSceneSession, opts: SCBTransferSceneOpts): boolean {
    if (session == null) {
      log.showError('invalid session pushed in.');
      return false;
    }
    const needUpdateScreenId = this.missionHandler.screenId !== session.screenId;
    log.showInfo(`${this.missionHandler.logTag} on scene push in: ${session.persistentId}, ` +
      `needUpdateScreenId: ${needUpdateScreenId}`);
    if (!needUpdateScreenId) {
      return true;
    }
    // update main session screen id
    session.updateDisplayId(this.missionHandler.screenId);

    // update sub session screen id
    session.subSessionList.forEach((item: SCBSpecificSession) => {
      if (!item) {
        log.showWarn('[SCBMain] item of subSessionList is empty');
        return;
      }
      SCBSceneSessionManager.getInstance().updateSessionDisplayId(item.session.persistentId,
        this.missionHandler.screenId);
    });
    return true;
  }

  protected beforeSceneAppear(): void {
  }

  /**
   * push into panel, activation or background if need
   */
  protected pushIntoPanel(session: SCBSceneSession, containerSession: SCBSceneContainerSession,
    opts: SCBTransferSceneOpts): void {
    if (!opts.needBackground) {
      containerSession.requestActivation(false);
    } else {
      containerSession.requestBackground();
    }
    this.missionHandler.addSceneContainerSession(containerSession);
  }

  protected animate(): void {
  }

  /**
   * post process after pushed into panel.
   */
  protected postprocess(session: SCBSceneSession, opts: SCBTransferSceneOpts): void {
    let mgmtData = session.getData(SceneDataCategory.MISSION_MANAGEMENT);
    if (mgmtData) {
      mgmtData.onWhichPanel = this.missionHandler.id;
    }
  }
}