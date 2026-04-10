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
import {
  SCBSceneContainerSession,
  SCBRecentSessionHelper,
  SCBRecentSessionState
} from '@ohos/windowscene';

export class SCBRecentHoverViewModel {
  public static hideRecentHover(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.tabSelected = false;
    sceneContainerSession.needRenderRecentHoverState.hoverState = false;
    if (sceneContainerSession.primarySession) {
      sceneContainerSession.primarySession.hoverState = false;
    }
    if (sceneContainerSession.secondarySession) {
      sceneContainerSession.secondarySession.hoverState = false;
    }
  }

  public static showRecentHoverByTabSelect(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.tabSelected = true;
  }

  public static showRecentHoverByHoverState(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.needRenderRecentHoverState.hoverState = true;
  }

  public static setRecentHoverState(sceneContainerSession: SCBSceneContainerSession, isHover: boolean): void {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.needRenderRecentHoverState.hoverState = isHover;
  }

  public static isCanHover(sceneContainerSession: SCBSceneContainerSession): boolean {
    if (SCBRecentSessionHelper.getState(sceneContainerSession) !== SCBRecentSessionState.ENTER_RECENT_ANIMATE_FINISH) {
      return false;
    }
    return true;
  }
}