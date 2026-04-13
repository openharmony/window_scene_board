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
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import {
  SCBScreenProperty,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBEventId,
  SCBSceneSessionArray
} from '@ohos/windowscene';
import { CastScene } from './CastScene';
import screen from '@ohos.screen';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { bundleManager } from '@kit.AbilityKit';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, 'CastScenePanel');

@Component
export struct CastScenePanel {
  @State scbSceneSessionArray: SCBSceneSessionArray = new SCBSceneSessionArray();
  @Link screenProperty: SCBScreenProperty; // current screen property;
  private onStartSceneFromIcon = (sceneInfo: SCBSceneInfo): void => {
    log.info(`onStartSceneFromIcon sceneInfo: ${sceneInfo.bundleName}`);
    for (let i = this.scbSceneSessionArray.length - 1; i >= 0; i--) {
      if (sceneInfo.persistentId === this.scbSceneSessionArray[i].sceneInfo.persistentId) {
        log.info(`update sceneInfo: ${sceneInfo.persistentId}`);
        continue;
      }
      const launchType = this.findLaunchType(this.scbSceneSessionArray[i].sceneInfo);
      if (launchType === bundleManager.LaunchType.SINGLETON) {
        this.sessionBackground(this.scbSceneSessionArray[i]);
      } else {
        log.info(`terminateSession: ${launchType}`);
        this.terminateSessionByPersistentId(this.scbSceneSessionArray[i].sceneInfo.persistentId);
      }
    }
    let oldSession = this.findSceneSessionByPersistentId(sceneInfo.persistentId);
    if (oldSession) {
      log.info('onStartSceneFromIcon found session');
      oldSession.updateSceneInfo(sceneInfo);
      this.sessionActive(oldSession, false);
      return;
    }
    let sceneSession: sceneSessionManager.SceneSession = this.createSceneSession(sceneInfo);
    if (!sceneSession) {
      log.warn('Failed to request scene session!');
      return;
    }
    let scbSceneSession = new SCBSceneSession(sceneSession, sceneInfo);
    this.sessionActive(scbSceneSession);
    this.scbSceneSessionArray.push(scbSceneSession);
  }

  private findLaunchType(sceneInfo: SCBSceneInfo): bundleManager.LaunchType {
    const queryKey = `${sceneInfo.bundleName}${sceneInfo.moduleName}${sceneInfo.abilityName}`;
    return SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
  }

  private findSceneSessionIndexByPersistentId(persistentId?: number): number {
    if (!persistentId) {
      return -1;
    }
    let index = this.scbSceneSessionArray.findIndex((value: SCBSceneSession) => {
      if (value.session.persistentId && value.session.persistentId === persistentId) {
        return true;
      }
      return false;
    });
    return index;
  }

  private findSceneSessionByPersistentId(persistentId?: number): SCBSceneSession | undefined {
    let index = this.findSceneSessionIndexByPersistentId(persistentId);
    if (index >= 0) {
      return this.scbSceneSessionArray[index];
    }
    return undefined;
  }

  private sessionBackground(session: SCBSceneSession) {
    session.visibility = false;
    session.requestSessionBackground();
  }

  private sessionActive(session: SCBSceneSession, isNewActive?: boolean) {
    session.visibility = true;
    session.requestSessionActivation(isNewActive);
  }

  private createSceneSession(sceneInfo: SCBSceneInfo): sceneSessionManager.SceneSession {
    let sceneSession: sceneSessionManager.SceneSession = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo.bundleName,
      moduleName: sceneInfo.moduleName,
      abilityName: sceneInfo.abilityName,
      appIndex: sceneInfo.appIndex,
      persistentId: sceneInfo.persistentId,
      screenId: sceneInfo.screenId
    }, sceneInfo.want);
    return sceneSession;
  }

  private terminateSessionByPersistentId(persistentId?: number): void {
    let index = this.findSceneSessionIndexByPersistentId(persistentId);
    log.info(`TerminateScene ${index} ${persistentId}`);
    if (index >= 0) {
      this.scbSceneSessionArray[index]?.requestSessionDestruction(true);
      this.scbSceneSessionArray.splice(index, 1);
    }
  }

  private onTerminateScene = (persistentId?: number, containerId?: number): void => {
    log.info(`onTerminateScene persistentId: ${persistentId}`);
    this.terminateSessionByPersistentId(persistentId);
    if (this.scbSceneSessionArray.length > 0) {
      let activeIndex = this.scbSceneSessionArray.findIndex((value: SCBSceneSession) => {
        if (value.isActive && value.visibility) {
          return true;
        }
        return false;
      });
      if (activeIndex < 0) {
        this.sessionActive(this.scbSceneSessionArray[this.scbSceneSessionArray.length - 1], false);
      }
    } else {
      screen.makeMirror(0, [this.screenProperty.screenId]).then(() => {
        log.info(`MakeMirror current window count: ${this.scbSceneSessionArray.length}`);
      });
    }
  }

  private registerCallback(): void {
    SCBSceneSessionManager.getInstance()
      .registerVirtualScreenStartScene(this.onStartSceneFromIcon, this.screenProperty.screenId);
  }

  private registerSessionEvent(): void {
    SCBSceneSessionManager.getInstance().on(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId,
      this.onTerminateScene);
  }

  private unRegisterSessionEvent(): void {
    SCBSceneSessionManager.getInstance().off(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId,
      this.onTerminateScene);
  }

  aboutToAppear() {
    log.info(`aboutToAppear screenId: ${this.screenProperty.screenId}`);
    this.registerCallback();
    this.registerSessionEvent();
    SCBSceneSessionManager.getInstance().runCastTaskIfNeed();
  }

  aboutToDisappear(): void {
    log.info('aboutToDisappear onTerminateScene');
    this.scbSceneSessionArray.forEach((session: SCBSceneSession) => {
      log.info(`onTerminateScene for ${session.session.persistentId}`);
      session.requestSessionDestruction(true);
    });
    this.scbSceneSessionArray.splice(0);
    SCBSceneSessionManager.getInstance()
      .unregisterVirtualScreenStartScene(this.screenProperty.screenId);
    this.unRegisterSessionEvent();
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      ForEach(this.scbSceneSessionArray, (scbSceneSession: SCBSceneSession) => {
        CastScene({
          sceneSession: scbSceneSession
        })
      }, (scbSceneSession: SCBSceneSession) => `cast_engine_session_${scbSceneSession.session.persistentId}`)
    }
    .backgroundColor('sys.color.ohos_id_color_background')
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .hitTestBehavior(HitTestMode.None)
  }
}