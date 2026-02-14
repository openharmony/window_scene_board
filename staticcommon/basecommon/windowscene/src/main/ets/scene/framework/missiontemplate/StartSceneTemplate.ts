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
import { CommonResult } from '../../../scene/utils/SCBSceneUtils';
import {
  SCBMainSessionTuple,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBStartSceneOpts,
  SceneDataCategory,
} from '../../../TsIndex';
import { SCBSceneMissionManager } from '../../manager/SCBSceneMissionManager';
import { DEFAULT_TOTAL_LIST_TAG, SCBScenePanelMissionHandler } from '../missions/SCBScenePanelMissionHandler';
import { BasicSceneMissionTemplate } from './BasicSceneMissionTemplate';

const TAG = '[SCBMission]StartSceneTemplate';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class StartSceneTemplate<T extends SCBScenePanelMissionHandler> extends BasicSceneMissionTemplate<T> {

  getLogTag(): string {
    return TAG;
  }

  getProcessor(): Function {
    return (sceneInfo, opts) => { return this.onProcess(sceneInfo, opts); };
  }

  /**
   * 处理窗口的启动流程。
   *
   * @param sceneInfo - 窗口信息
   * @param opt - 窗口启动的可选参数
   */
  private onProcess(sceneInfo: SCBSceneInfo, opts?: SCBStartSceneOpts): CommonResult {
    log.showInfo('Start scene with sceneInfo: ' + sceneInfo?.toJsonString());
    if (!this.preprocess(sceneInfo)) {
      log.showError(`Preprocess failed, ignored start this time.`);
      return CommonResult.FAIL;
    }

    let sessionTuple = this.getOrCreateSceneAndContainerSession(sceneInfo);
    if (sessionTuple.sceneSession == null || sessionTuple.containerSession == null) {
      log.showError(`Failed to get or create session.`);
      return CommonResult.FAIL;
    }
    if (!this.beforeSceneAppear(sessionTuple)) {
      log.showError(`BeforeSceneAppear failed. persistentId: ${sceneInfo?.persistentId}`);
      return CommonResult.FAIL;
    }

    this.startScene(sessionTuple.sceneSession, sessionTuple.containerSession);
    this.animate(sessionTuple.containerSession);
    this.postprocess(sessionTuple.sceneSession, sessionTuple.containerSession);
    return CommonResult.SUCCESS;
  }

  /**
   * 预处理
   *
   * @param sceneInfo - 窗口信息
   * @param opt - 窗口启动的可选参数
   * @returns
   *   - true：表示需要继续处理
   *   - false：表示无需继续处理
   */
  protected preprocess(sceneInfo: SCBSceneInfo, opt?: SCBStartSceneOpts): boolean {
    const session = this.missionHandler.getContainerSessionBySceneInfo(sceneInfo);
    if (session?.isActive) {
      log.showInfo('current session already on top active');
      return false;
    }
    return true;
  }

  /**
   * 窗口启动前处理
   *
   * @param sessionTuple - 主窗及主窗容器
   * @param opt - 窗口启动的可选参数
   * @returns
   *   - true：表示需要继续处理
   *   - false：表示无需继续处理
   */
  protected beforeSceneAppear(sessionTuple: SCBMainSessionTuple, opt?: SCBStartSceneOpts): boolean {
    // 将前台窗口退后台
    const topContainerSession = this.missionHandler.getTopActiveSession(DEFAULT_TOTAL_LIST_TAG);
    if (topContainerSession) {
      topContainerSession.requestBackground();
    }
    return true;
  }

  /**
   * 窗口启动
   *
   * @param sceneSession - 窗口会话
   * @param sceneContainerSession - 窗口容器会话
   * @param opt - 窗口启动的可选参数
   */
  protected startScene(sceneSession: SCBSceneSession, sceneContainerSession: SCBSceneContainerSession,
    opt?: SCBStartSceneOpts): void {
    this.missionHandler.raiseSceneToTopInList(sceneContainerSession, DEFAULT_TOTAL_LIST_TAG);
    sceneContainerSession.requestActivation();
  }

  /**
   * 窗口动画
   *
   * @param sceneContainerSession - 窗口容器会话
   * @param opt - 窗口启动的可选参数
   */
  protected animate(sceneContainerSession: SCBSceneContainerSession, opt?: SCBStartSceneOpts): void {
  }

  /**
   * 窗口启动完成后的后续处理
   *
   * @param sceneSession - 窗口会话
   * @param sceneContainerSession - 窗口容器会话
   * @param opt - 窗口启动的可选参数
   */
  protected postprocess(sceneSession: SCBSceneSession, sceneContainerSession: SCBSceneContainerSession,
    opt?: SCBStartSceneOpts): void {
    let mgmtData = sceneSession?.getData(SceneDataCategory.MISSION_MANAGEMENT);
    if (mgmtData) {
      mgmtData.onWhichPanel = this.missionHandler.id;
      log.showInfo(`update session onWhichPanel: ${mgmtData.onWhichPanel}`);
    }
  }
}
