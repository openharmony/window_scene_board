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
import { INVALID_SCREEN_ID, SCBSceneContainerSession, SCBSceneSessionManager } from '../../../TsIndex';
import { SCBSceneInfo } from '../../session/SCBSceneInfo';
import sceneSessionManager from '@ohos.sceneSessionManager';

/**
 * Processor interface in diff mission lifecycle.
 * @description support products generalize, and customize strategy
 */
export class SCBSceneMissionProcessor {
  /**
   * fix screen id before start request
   * @param toInfo the scene will start
   * @param fromInfo the caller
   */
  protected resetSessionScreenIdBeforeStart(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void {
    if (toInfo.screenId === INVALID_SCREEN_ID) {
      toInfo.screenId = fromInfo ? fromInfo.screenId : SCBSceneSessionManager.getInstance().mainScreenId;
    }
  }

  /**
   * when received a pending to start request.
   * @param toInfo the scene will start
   * @param fromInfo the caller
   */
  public onPendingSessionToStart(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void {
    this.resetSessionScreenIdBeforeStart(toInfo, fromInfo);
  }
  /**
  * when received create new scene session 
  * @param sceneInfo info of the scene will start
  */
  public onNewSceneSessionCreate(sceneInfo: SCBSceneInfo): void {}

  /**
   * after session scheduled to go foreground
   * @description just request to activate, not foregrounded.
   * @param containerSession the container contains the scene activated
   */
  public onSessionWillGoForeground(containerSession: SCBSceneContainerSession): void {}

  /**
   * when received a visibility change request
   * @param toInfo the scene's visibility changed
   * @param fromInfo the caller
   * @param visible visibility state of scene
   */
  public onHiddenSessionVisibilityChanged(toInfo: SCBSceneInfo, visible: boolean, fromInfo?: SCBSceneInfo): void {
    this.resetSessionScreenIdBeforeStart(toInfo, fromInfo);
  }

  /**
   * check and remove scbSceneSession after native session destruct.
   * @param persistentId persistentId of sceneSession which already destruct.
   */
  public removeSceneSessionAfterDestruct(persistentId: number): void {}

  /**
   * notify when the application content is loaded when the start window is invisible.
   * @param persistentId persistentId of SCBSceneSession.
   */
  public notifyApplicationLoadedWhenStartWindowInvisible(persistentId: number): void {}

  /**
   * notify session terminate event when session destruction
   * @param uid app uid
   * @param sceneInfo scb scene info
   */
  public onSceneSessionWillTerminate(uid: number, sceneInfo?: SCBSceneInfo): void {}

  /**
   * move scene session background.
   * @param sceneInfo scene information.
   * @param shouldBackToCaller whether to return to the caller
   * @param record want message.
   */
  public onPendingSessionToBackground(sceneInfo: sceneSessionManager.SceneInfo, shouldBackToCaller: boolean,
    record: Record<string, Object>): void {}
}
