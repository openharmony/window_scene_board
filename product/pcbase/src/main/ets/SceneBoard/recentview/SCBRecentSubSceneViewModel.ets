/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { NeedRenderSubSceneShow, SCBSceneContainerSession, SCBSceneContainerSessionArray } from '@ohos/windowscene';

const TAG = 'SCBRecentSubSceneViewModel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentSubSceneViewModel {

  private screenID: number;

  constructor(screenID: number) {
    this.screenID = screenID;
  }

  public buildSubScenes(sceneContainerSession: SCBSceneContainerSession): void {
    log.showInfo(`show sub scene: ${sceneContainerSession.getName()}`);
    const mainSceneInCurScreen = sceneContainerSession.screenProperty.screenId === this.screenID;
    const showNum = mainSceneInCurScreen ?
    NeedRenderSubSceneShow.curScreenSubSceneShow : NeedRenderSubSceneShow.anotherScreenSubSceneShow;
    sceneContainerSession.needRenderSubSceneShow.showSubScene(showNum);
  }

  public destroySubScenes(sceneContainerSession: SCBSceneContainerSession): void {
    log.showInfo(`hide sub scene: ${sceneContainerSession.getName()}`);
    const mainSceneInCurScreen = sceneContainerSession.screenProperty.screenId === this.screenID;
    const hideNum = mainSceneInCurScreen ?
    NeedRenderSubSceneShow.curScreenSubSceneHide : NeedRenderSubSceneShow.anotherScreenSubSceneHide;
    sceneContainerSession.needRenderSubSceneShow.hideSubScene(hideNum);
  }

  public destroySubScenesBatch(containerList: SCBSceneContainerSession[]): void {
    containerList.forEach((item) => {
      this.destroySubScenes(item);
    });
  }

  public buildSubScenesBatch(containerList: SCBSceneContainerSession[] | SCBSceneContainerSessionArray): void {
    containerList.forEach((item) => {
      this.buildSubScenes(item);
    });
  }

  public updateScreenID(screenID: number): void {
    this.screenID = screenID;
  }
}