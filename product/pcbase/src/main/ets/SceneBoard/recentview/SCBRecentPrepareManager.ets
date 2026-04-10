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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneSessionManager,
  SCBScreenProperty
} from '@ohos/windowscene/src/main/ets/TsIndex';

const TAG = 'SCBRecentPrepareManager';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentPrepareManager {
  private screenProperty: SCBScreenProperty;
  private hideContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

  constructor(screenProperty: SCBScreenProperty) {
    this.screenProperty = screenProperty;
  }

  /**
   * 预关闭，关闭persistentId的窗口
   * @param persistentId
   * @param sceneContainer
   * @param restoreBack 当预关闭接口返回true，触发该回调
   * @param closeCallBack 当预关闭返回false，触发该回调
   */
  public close(persistentId: number, sceneContainer: SCBSceneContainerSession, restoreBack: Function,
    closeCallBack: Function):void {
    if (!sceneContainer) {
      return;
    }
    try {
      const isPrepareTerminate = SCBSceneSessionManager.getInstance().prepareTerminate(persistentId);
      log.showInfo(`close isPrepareTerminate: ${isPrepareTerminate} ${sceneContainer.getName()} ${persistentId}`);
      if (isPrepareTerminate) {
        restoreBack();
      } else {
        closeCallBack();
      }
    } catch (e) {
      log.showError(`close error, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  /**
   * 预关闭异步接口，关闭persistentId的窗口
   * @param persistentId
   * @param sceneContainer
   * @param restoreBack 当预关闭接口返回true，触发该回调
   * @param closeCallBack 当预关闭返回false，触发该回调
   */
  public closeAsync(persistentId: number, sceneContainer: SCBSceneContainerSession, restoreBack: Function,
    closeCallBack: Function):void {
    if (!sceneContainer) {
      return;
    }
    try {
      const currentSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      currentSessionManager.asyncPrepareTerminate(persistentId, (err, isPrepareTerminate) => {
        log.showInfo(`closeAsync isPrepareTerminate: ${isPrepareTerminate} ${sceneContainer.getName()}`);
        if (isPrepareTerminate) {
          restoreBack();
        } else {
          closeCallBack();
        }
      });
    } catch (e) {
      log.showError(`closeAsync error, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  public addHideContainerSession(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      log.showError(`addHideContainerSession containerSession invalid`);
      return;
    }
    this.hideContainerSessionList.push(containerSession);
  }

  public isHideContainerSession(containerSession: SCBSceneContainerSession): boolean {
    if (!containerSession) {
      log.showError(`isHideContainerSession containerSession invalid`);
      return false;
    }
    const index = this.hideContainerSessionList.findIndexByContainerId(containerSession.containerId);
    return index === -1 ? false : true;
  }

  public clearHideContainerSession(): void {
    this.hideContainerSessionList.clear();
  }

}