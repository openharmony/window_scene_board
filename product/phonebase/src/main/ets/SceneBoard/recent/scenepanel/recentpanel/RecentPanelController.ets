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

import type { RecentPanelSession } from './RecentPanelSession';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { SCBSceneContainerSessionArray } from '@ohos/windowscene';
import systemparameter from '@ohos.systemParameterEnhance';
import { FollowingFromAppCallbackBase } from '../apppanel/AppCallbacks';
import { SCBScenePanelFSM } from '../SCBScenePanelFSM';

const TAG = 'RecentPanelController';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export enum RecentMissionCardPositionInScreen {
  NONE = -1,
  LEFT = 0,
  MIDDLE = 1,
  RIGHT = 2
}

export class RecentPanelController {
  private isNewStyle: boolean = true;
  private readonly recentPanelSession: RecentPanelSession;

  constructor(session: RecentPanelSession) {
    this.recentPanelSession = session;
    this.isNewStyle = (systemparameter.getSync('sceneboard.isNewStyle', 'true') === 'true');
  }

  public get session(): RecentPanelSession {
    return this.recentPanelSession;
  }

  public get scenePanelSessionList(): SCBSceneContainerSessionArray {
    return this.recentPanelSession.sceneContainerSessionList;
  }

  public removePendingSessionIfNeed(): void {
    if (this.scenePanelSessionList.isEmpty()) {
      return;
    }
    this.scenePanelSessionList.removeDeletingSceneSessions();
  }

  /**
   * 根据条件判断是否需要进入home idle
   *
   * @param callback 回调函数
   * @param offsetX 手势的offsetX
   * @param offsetY 手势的offsetY
   * @returns true表示返回了home idle，false表示没有
   */
  public enterHomeIdleIfNeed(callback: FollowingFromAppCallbackBase, offsetX: number, offsetY: number): boolean {
    let currContainerSession = this.scenePanelSessionList.getTopActiveSession();
    if (!currContainerSession) {
      log.showWarn('current session is null');
      callback.enterHomeIdle(offsetX, offsetY);
      SCBScenePanelFSM.getInstance().setCurrentStateToHome();
      return true;
    }
    return false;
  }
}
