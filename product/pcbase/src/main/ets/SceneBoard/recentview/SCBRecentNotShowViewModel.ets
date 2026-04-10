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
import { SCBSceneContainerSession, SCBSceneInfo, SCBScreenProperty, SCBSceneSessionManager,
  SCBSceneContainerSessionArray } from '@ohos/windowscene';
import { SCBRecentCardViewModel } from './SCBRecentCardViewModel';
import { SCBRecentCover } from './SCBRecentCover';

const TAG = 'SCBRecentNotShowViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentNotShowViewModel {
  private static instances: Map<number, SCBRecentNotShowViewModel> = new Map();
  private screenID: number;

  constructor(screenID: number) {
    this.screenID = screenID;
  }

  public static getInstance(screenID: number): SCBRecentNotShowViewModel {
    let instance = SCBRecentNotShowViewModel.instances.get(screenID);
    if (instance) {
      return instance;
    }
    instance = new SCBRecentNotShowViewModel(screenID);
    SCBRecentNotShowViewModel.instances.set(screenID, instance);
    return instance;
  }

  private static isExcludeFromMissions(sceneInfo?: SCBSceneInfo): boolean {
    if (!sceneInfo) {
      return false;
    }
    return SCBSceneSessionManager.getInstance()
      .isExcludeFromSession(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName);
  }

  public static isNotShowInRecent(containerSession: SCBSceneContainerSession): boolean {
    const isPriNotShowInRecent: boolean =
      SCBRecentNotShowViewModel.isExcludeFromMissions(containerSession.primarySession?.sceneInfo);
    const isSecNotShowInRecent: boolean =
      SCBRecentNotShowViewModel.isExcludeFromMissions(containerSession.secondarySession?.sceneInfo);
    if (isPriNotShowInRecent || isSecNotShowInRecent) {
      log.showInfo(`isNotShowInRecent:${isPriNotShowInRecent}, ${isSecNotShowInRecent}, ${containerSession.getName()}`);
    }
    return isPriNotShowInRecent || isSecNotShowInRecent;
  }

  public destroyBackgroundNotShowContainer(containerSessions: SCBSceneContainerSessionArray): void {
    this.getNotShowContainerSessionList(containerSessions).forEach(containerSession => {
      if (containerSession.isBackground()) {
        containerSession.toggleHomeState = false;
      }
    });
  }

  public hideNotShowInRecentScene(screenProperty: SCBScreenProperty,
    containerSessions: SCBSceneContainerSessionArray): void {
    if (containerSessions.length === 0) {
      return;
    }
    this.hideNotShowSessions(screenProperty, this.getNotShowContainerSessionList(containerSessions));
  }

  public showNotShowInRecentScene(containerSessions: SCBSceneContainerSessionArray): void {
    if (containerSessions.length === 0) {
      return;
    }
    animateToImmediately({
      duration: 0
    }, () => {
      this.showNotShowSessions(this.getNotShowContainerSessionList(containerSessions));
    })
  }

  private getNotShowContainerSessionList(containerSessions: SCBSceneContainerSessionArray):
    SCBSceneContainerSessionArray {
    const notShowSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    containerSessions.forEach(containerSession => {
      if (containerSession.isPreSplitSession()) {
        log.showInfo(`containerSession:${containerSession.getBundleName()} is preSplitSession`);
        return;
      }
      if (containerSession.screenProperty.screenId !== this.screenID) {
        return;
      }
      if (SCBRecentNotShowViewModel.isNotShowInRecent(containerSession)) {
        notShowSessionList.add(containerSession);
      }
    })
    return notShowSessionList;
  }

  private showNotShowSessions(containerSessions: SCBSceneContainerSessionArray): void {
    containerSessions.forEach(containerSession => {
      SCBRecentCardViewModel.setSceneTranslate(containerSession, 0, 0);
      // 避免三指进任务中心，缩小窗口后未恢复
      SCBRecentCardViewModel.setSceneScale(containerSession, 1);
    })
  }

  private hideNotShowSessions(screenProperty: SCBScreenProperty,
    containerSessions: SCBSceneContainerSessionArray): void {
    containerSessions.forEach(containerSession => {
      SCBRecentCardViewModel.setSceneTranslate(containerSession, 0, -screenProperty.height * 2);
      SCBRecentCover.layoutRecentCover(containerSession, 0, -screenProperty.height * 2);
    })
  }
}