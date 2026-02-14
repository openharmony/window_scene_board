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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import {
  SCBSceneMissionProcessor,
  SCBSceneContainerSession,
  ContainerDataCategory,
  SCBSceneSessionManager,
  SCBSceneMissionManager,
} from '@ohos/windowscene/src/main/ets/TsIndex';
import { SCBSceneInfo, SCBSceneSession } from '@ohos/windowscene';
import lazy { OneHandModeDialogManager } from '../../../oneHandModeDialog/manager/OneHandModeDialogManager';
import {
  SCBScenePanelManager
} from '@ohos/windowscene/src/main/ets/TsIndex';
import lazy { MidSceneEvents } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';

const TAG = 'SCBPhoneSceneMissionProcessor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Phone产品任务管理处理类
 */
export class SCBPhoneSceneMissionProcessor extends SCBSceneMissionProcessor {

  /**
   * after session scheduled to go foreground
   * @description just request to activate, not foregrounded.
   * @param containerSession the container contains the scene activated
   */
  public onSessionWillGoForeground(containerSession: SCBSceneContainerSession): void {
  }

  /**
   * when received create new scene session
   * @param sceneInfo info of the scene will start
   */
  public onNewSceneSessionCreate(sceneInfo: SCBSceneInfo): void {
  }

  /**
   * check and remove scbSceneSession after native session destruct.
   * @param persistentId persistentId of sceneSession which already dstruct.
   */
  public removeSceneSessionAfterDestruct(persistentId: number): void {
    log.showInfo(`removeSceneSessionAfterDestruct, persistentId: ${persistentId}`);
    let sessionTuple: [SCBSceneContainerSession | null, SCBSceneSession | null] =
      SCBScenePanelManager.getInstance().getSceneContainerSessionAndSceneSessionByPersistentId(persistentId);
    let sceneContainerSession: SCBSceneContainerSession | null = sessionTuple[0];
    let sceneSession: SCBSceneSession | null = sessionTuple[1];
    if (sceneContainerSession === null || sceneSession === null) {
      log.showInfo(`removeSceneSessionAfterDestruct sceneContainerSession or sceneSession is null.`);
      return;
    }
    // 在悬浮窗list中找到
    if (sceneContainerSession.isFloat) {
      log.showInfo(`removeSceneSessionAfterDestruct, persistentId: ${persistentId} from floatingList.`);
      // 从侧边栏移除
      SCBScenePanelManager.getInstance().removeFloatContainerSession(sceneContainerSession);
      return;
    }

    // 从分屏移除
    if (sceneContainerSession.isSplit) {
      sceneContainerSession.removeSceneSession(sceneSession);
      log.showInfo(`removeSceneSessionAfterDestruct, persistentId: ${persistentId} from split.`);
      return;
    }

    // 从宇宙立方移除
    if (sceneContainerSession.isMidScene) {
      log.showInfo(`removeSceneSessionAfterDestruct, persistentId: ${persistentId} from midScene.`);
      sceneContainerSession.removeSceneSessionFromMidScene(sceneSession);
      sceneContainerSession.sessionData.midSceneFSM?.transfer(MidSceneEvents.EVENT_REMOVE_WINDOW,
        sceneSession.sceneInfo.persistentId);
      return;
    }

    // 全屏
    log.showInfo(`removeSceneSessionAfterDestruct, persistentId: ${persistentId} from fullScreen.`);
    SCBScenePanelManager.getInstance().removeSceneContainerSession(sceneContainerSession);

    return;
  }

  /**
   * move scene session background.
   * @param sceneInfo scene information.
   * @param shouldBackToCaller whether to return to the caller
   * @param record want message.
   */
  public onPendingSessionToBackground(sceneInfo: sceneSessionManager.SceneInfo, shouldBackToCaller: boolean,
    record: Record<string, Object>): void {
    log.showInfo(`onPendingSessionToBackground. bundleName: ${sceneInfo.bundleName}`);
    if (record && record['isFloatSceneBackgroundToSideBar'] === true) {
      return;
    }
  }
}