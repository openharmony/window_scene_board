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

import { Logger, LogDomain, CommonUtils } from '@ohos/basicutils';
import { SCBSceneContainerSession, SCBSceneSession } from '@ohos/windowscene';

const TAG = 'SCBRecentUiFirst';
const log = Logger.getLogHelper(LogDomain.RECENT);

export class SCBRecentUiFirst {
  // 记录任务中心和应用中心互切动效，解决动效打断场景交互优先还原
  private groupAnimationRef: number = 0;

  public groupAnimationRefInit(): void {
    this.groupAnimationRef = 0;
    log.showInfo(TAG, 'group animation ref init');
  }

  public groupAnimationRefZero(): boolean {
    return (this.groupAnimationRef === 0);
  }

  public groupAnimationRefAdd(): void {
    this.groupAnimationRef++;
    log.showInfo(TAG, `group animation ref add: ${this.groupAnimationRef}`);
  }

  public groupAnimationRefDec(): void {
    this.groupAnimationRef--;
    log.showInfo(TAG, `group animation ref decrease: ${this.groupAnimationRef}`);
  }

  private isNeedUIFirst(sceneSession: SCBSceneSession): boolean {
    return CommonUtils.equals(sceneSession.opacity, 1);
  }

  /*
    * 如果动效过程中窗口有透明，且窗口本身有模糊，会导致图形无法下发交互优先。
    * 判断透明是否是窗口本身的，如果不是窗口本身的，是动效设置的，强制下发交互优先
  */
  private setSceneSessionUiFirst(sceneSession: SCBSceneSession | null): void {
    if (!sceneSession || !sceneSession.session) {
      log.showDebug(TAG, 'set ui first failed, session is null.');
      return;
    }
    if (this.isNeedUIFirst(sceneSession)) {
      log.showInfo(TAG, `sceneSession ${sceneSession.getName()} setUiFirst`);
      sceneSession.session.markSystemSceneUIFirst(true, true);
    }
  }

  private resetSceneSessionUiFirst(sceneSession: SCBSceneSession | null): void {
    if (!sceneSession || !sceneSession.session) {
      log.showDebug(TAG, 'reset ui first failed, session is null.');
      return;
    }
    if (this.isNeedUIFirst(sceneSession)) {
      log.showInfo(TAG, `sceneSession ${sceneSession.getName()} resetUiFirst`);
      sceneSession.session.markSystemSceneUIFirst(false, false);
    }
  }

  public setContainerSessionListUiFirst(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    sceneContainerSessionList.forEach((sceneContainerSession: SCBSceneContainerSession) => {
      if (!sceneContainerSession || !sceneContainerSession.isActive) {
        return;
      }
      this.setSceneSessionUiFirst(sceneContainerSession.primarySession);
      this.setSceneSessionUiFirst(sceneContainerSession.secondarySession);
    })
  }

  public resetContainerSessionListUiFirst(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    sceneContainerSessionList.forEach((sceneContainerSession: SCBSceneContainerSession) => {
      if (!sceneContainerSession || !sceneContainerSession.isActive) {
        return;
      }
      this.resetSceneSessionUiFirst(sceneContainerSession.primarySession);
      this.resetSceneSessionUiFirst(sceneContainerSession.secondarySession);
    })
  }

  public forceResetAllSessionUiFirst(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    this.groupAnimationRefInit();
    this.resetContainerSessionListUiFirst(sceneContainerSessionList);
  }
}