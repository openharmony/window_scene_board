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
  INVALID_SCREEN_ID,
  SCBSceneInfo,
  SCBSceneMissionProcessor,
  SCBSceneSessionManager,
  SCBSessionRect,
  SCBScreenSessionManager,
  SCBSceneContainerSessionArray
} from '@ohos/windowscene';

const TAG = `SCBPCSceneMissionProcessor`;
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export const C_SIDE_SCREEN_ID = 999;
export const INVALID_DISPLAY_ID: string = 'INVALID_DISPLAY_INTENT';

export class SCBPCSceneMissionProcessor extends SCBSceneMissionProcessor {
  public onPendingSessionToStart(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo | undefined): void {
    if (!toInfo) {
      log.showError('onPendingSessionToStart toInfo undefined!');
      return;
    }
    toInfo.extendsInfo.set(INVALID_DISPLAY_ID, toInfo.screenId === INVALID_SCREEN_ID);
    log.showInfo('toInfo.screenId: ' + toInfo.screenId);

    let sceneSession = this.getContainerSessionList().getSceneSessionByPersistentId(toInfo.persistentId);
    if (sceneSession && sceneSession.isActive) {
      log.showInfo(`active no need follow screenID bundleName ${sceneSession.getName()}`);
      return;
    }

    // SA启动场景
    if (!fromInfo) {
      this.updateScreenIdByFocusedSession(toInfo);
      return;
    }

    this.updateScreenIdByCaller(toInfo, fromInfo);
  }

  public notifyApplicationLoadedWhenStartWindowInvisible(persistentId: number): void {
    log.showInfo(`notifyApplicationLoadedWhenStartWindowInvisible ok, persistentId: ${persistentId}.`);
  }

  private updateScreenIdByFocusedSession(toInfo: SCBSceneInfo, screenId?: number): void {
    let sceneSession = this.getContainerSessionList().getSceneSessionByPersistentId(toInfo.persistentId);
    log.showInfo('updateScreenIdByFocusedSession set screenId by focusSession screenId.');
    let originScreenId = screenId ? screenId : toInfo.screenId;
    if (originScreenId === INVALID_SCREEN_ID && (!sceneSession || !sceneSession.sessionData.isNewWant)) {
      let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
      if (focusedSession) {
        toInfo.screenId = focusedSession.session.screenId;
        SCBSceneSessionManager.getInstance().updateSessionDisplayId(toInfo.persistentId, toInfo.screenId);
      }
    }
    if (!toInfo.screenId || toInfo.screenId === INVALID_SCREEN_ID) {
      toInfo.screenId = SCBSceneSessionManager.getInstance().mainScreenId;
    }
  }

  private getContainerSessionList(): SCBSceneContainerSessionArray {
    let containerSessionList = new SCBSceneContainerSessionArray();
    let allContainerSessionList = SCBSceneSessionManager.getInstance().getAllContainerSessionList();
    containerSessionList.push(...allContainerSessionList);
    for (let screenSession of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      let screenId: ESObject = screenSession.session.screenId;
      let containerSessionListNotShowRecent = SCBSceneSessionManager.getInstance()
        .getContainerSessionListNotShowRecent(screenId);
      containerSessionList.push(...containerSessionListNotShowRecent);
    }
    return containerSessionList;
  }

  private updateScreenIdByCaller(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo | undefined): void {
    log.showInfo('updateScreenIdByCaller set screenId by caller.');
    let originScreenId = toInfo.screenId;
    if (toInfo.screenId === INVALID_SCREEN_ID) {
      toInfo.screenId = fromInfo ? fromInfo.screenId : SCBSceneSessionManager.getInstance().mainScreenId;
    }
  }
}