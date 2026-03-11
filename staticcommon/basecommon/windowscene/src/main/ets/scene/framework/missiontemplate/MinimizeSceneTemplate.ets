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
import {
  SCBSceneContainerSession,
  SCBSceneSession
} from '../../../TsIndex';
import { SCBMinimizeSceneOpts, SCBScenePanelMissionHandler } from '../../SceneModuleIndex';
import { BasicSceneMissionTemplate } from './BasicSceneMissionTemplate';
import { SCBSceneMissionChains } from '../missions/SCBSceneMissionChains';
import { DEFAULT_TOTAL_LIST_TAG } from '../missions/SCBScenePanelMissionHandler';

const TAG = '[SCBMission]MinimizeSceneTemplate';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class MinimizeSceneTemplate<T extends SCBScenePanelMissionHandler> extends BasicSceneMissionTemplate<T> {

  getLogTag(): string {
    return TAG;
  }

  getProcessor(): Function {
    return (persistentId?: number, containerId?: number, opts?: SCBMinimizeSceneOpts) => {
      this.onProcess(persistentId, containerId, opts);
    };
  }

  /**
   * 处理窗口的最小化流程
   *
   * @param persistentId - 窗口id
   * @param containerId - 窗口容器id
   * @param opt - 窗口最小化的可选参数
   */
  private onProcess(persistentId?: number, containerId?: number, opt?: SCBMinimizeSceneOpts): void {
    log.showInfo(`Minimize Scene with persistentId: ${persistentId} containerId: ${containerId}` +
      `shouldBackToCaller: ${opt?.shouldBackToCaller}, needBackground: ${opt?.needBackground}`);
    if (!this.preprocess(persistentId, containerId, opt)) {
      log.showInfo(`Preprocess failed persistentId: ${persistentId} containerId: ${containerId}`);
      return;
    }

    let sceneContainerSession = this.getContainerSession(persistentId, containerId, opt);
    if (!sceneContainerSession) {
      log.showError(`Failed to get scene container session. persistentId: ${persistentId} containerId: ${containerId}`);
      return;
    }

    if (!this.beforeSceneDisappear(sceneContainerSession, opt)) {
      log.showInfo(`BeforeSceneDisappear failed, persistentId: ${persistentId} containerId: ${containerId}`);
      return;
    }

    this.animate(sceneContainerSession, opt);
    this.minimizeScene(sceneContainerSession, opt);
    this.postprocess(sceneContainerSession, opt);
  }

  /**
   * 预处理
   *
   * @param persistentId - 窗口id
   * @param containerId - 窗口容器id
   * @param opt - 窗口最小化的可选参数
   * @returns
   *   - true：表示需要继续处理
   *   - false：表示无需继续处理
   */
  protected preprocess(persistentId?: number, containerId?: number, opt?: SCBMinimizeSceneOpts): boolean {
    if (persistentId === undefined && containerId === undefined) {
      log.showError('Both persistentId and containerId are undefined.');
      return false;
    }
    return true;
  }

  /**
   * 查找要最小化的窗口容器会话
   *
   * @param persistentId - 窗口id
   * @param containerId - 窗口容器id
   * @param opt - 窗口最小化的可选参数
   * @returns
   *   - SCBSceneContainerSession：查找到返回目标窗口容器会话
   *   - null：未查找到返回
   */
  protected getContainerSession(persistentId?: number, containerId?: number,
    opt?: SCBMinimizeSceneOpts): SCBSceneContainerSession | null {
    return this.missionHandler.getContainerSessionByPersistentIdOrContainerId(persistentId, containerId);
  }

  /**
   * 窗口最小化前处理
   *
   * @param sceneContainerSession - 要最小化的窗口容器会话
   * @param opt - 窗口最小化的可选参数
   * @returns
   *   - true：表示需要继续处理
   *   - false：表示无需继续处理
   */
  protected beforeSceneDisappear(sceneContainerSession: SCBSceneContainerSession, opt?: SCBMinimizeSceneOpts): boolean {
    if (!sceneContainerSession.isActive) {
      log.showWarn(`containerSession already background: ${sceneContainerSession.getName()}`);
      return false;
    }
    return true;
  }

  /**
   * 窗口动画
   *
   * @param sceneContainerSession - 要最小化的窗口容器会话
   * @param opt - 窗口最小化的可选参数
   */
  protected animate(sceneContainerSession: SCBSceneContainerSession, opt?: SCBMinimizeSceneOpts): void {
  }

  /**
   * 窗口最小化
   *
   * @param sceneContainerSession - 要最小化的窗口容器会话
   * @param opt - 窗口最小化的可选参数
   */
  protected minimizeScene(sceneContainerSession: SCBSceneContainerSession, opt?: SCBMinimizeSceneOpts): void {
    sceneContainerSession.requestBackground();
  }

  /**
   * 窗口最小化完成后的后续处理
   *
   * @param sceneContainerSession - 要最小化的窗口容器会话
   * @param opt - 窗口最小化的可选参数
   */
  protected postprocess(sceneContainerSession: SCBSceneContainerSession, opt?: SCBMinimizeSceneOpts): void {
  }
}