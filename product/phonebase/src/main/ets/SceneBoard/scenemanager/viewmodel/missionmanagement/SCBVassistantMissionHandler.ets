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
import { StartInterceptions } from '@ohos/windowscene/src/main/ets/scene/framework/missions/SCBSceneStartInterceptor';
import {
  SCBSceneInfo,
  SCBSceneContainerSession,
  SCBSceneSessionManager,
  SCBSceneMissionManager,
  SCBScreenSessionManager,
} from '@ohos/windowscene';

const TAG = '[SCBMission]SCBVassistantMissionHandler';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export const APP_VASSISTANT_SCREEN_NAME: string = 'VoiceView';
export const APP_VASSISTANT_ABILITY_NAME: string = 'VirtualScreenUiAbility';
export const APP_VASSISTANT_BUNDLE_NAME: string = 'com.ohos.vassistant';

/**
 * Vassistant on phone
 */
export class SCBVassistantMissionHandler {
  private static sHandler: SCBVassistantMissionHandler;
  private backExitOneStepToFull: Function = (currContainerSession: SCBSceneContainerSession, persistentId: number) => {
    log.showInfo('default start VoiceView backExitOneStepToFull');
  };
  private startSceneFromOther: Function = (info: SCBSceneInfo) => {
    log.showInfo('default start VoiceView startSceneFromOther');
  };
  public static getInstance(): SCBVassistantMissionHandler {
    if (!SCBVassistantMissionHandler.sHandler) {
      SCBVassistantMissionHandler.sHandler = new SCBVassistantMissionHandler();
    }
    return SCBVassistantMissionHandler.sHandler;
  }

  public setStartSceneFromOther(callback: (info: SCBSceneInfo) => void): void {
    this.startSceneFromOther = callback;
  }

  public setBackExitOneStepToFull(
    callback: (currContainerSession: SCBSceneContainerSession, persistentId: number) => void): void {
    this.backExitOneStepToFull = callback;
  }

  public startInterceptor(sceneInfo: SCBSceneInfo, startFrom: StartInterceptions): boolean {
    if (!sceneInfo) {
      log.showError('startInterceptor invalid params');
      return false;
    }
    if (this.isSessionOnVoiceViewScreen(sceneInfo)) {
      if (this.handleVoiceViewInOneStepSpilt()) {
        return true;
      }
      const vaSceneInfo = new SCBSceneInfo(APP_VASSISTANT_BUNDLE_NAME, '', APP_VASSISTANT_ABILITY_NAME);
      vaSceneInfo.screenId = SCBSceneSessionManager.getInstance().mainScreenId;
      vaSceneInfo.want = {
        bundleName: vaSceneInfo.bundleName,
        abilityName: vaSceneInfo.abilityName,
        moduleName: vaSceneInfo.moduleName,
        parameters: {}
      };
      this.startSceneFromOther(vaSceneInfo);
      return true;
    }
    return false;
  }

  public handleVoiceViewInOneStepSpilt(): boolean {
    let activeSession = SCBSceneSessionManager.getInstance().getContainerSessionList()?.getTopActiveSession();
    if (activeSession?.primarySession?.sceneInfo.bundleName ===
      APP_VASSISTANT_BUNDLE_NAME && activeSession?.isOneStepSplit()) {
      this.backExitOneStepToFull(activeSession, activeSession?.getPersistentId());
      return true;
    }
    return false;
  }

  public isSessionOnVoiceViewScreen(sceneInfo: SCBSceneInfo): boolean {
    const sessionTuple = SCBSceneMissionManager.getInstance().findMainSessionTupleGlobalByInfo(sceneInfo);
    if (!sessionTuple.containerSession || !sessionTuple.sceneSession) {
      return false;
    }
    if (sessionTuple.containerSession.isDisappearing || sessionTuple.containerSession.pendingRemove) {
      return false;
    }
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(sessionTuple.sceneSession.screenId);
    return screenSession.session?.name === APP_VASSISTANT_SCREEN_NAME;
  }


}