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
  CommonResult,
  CommonResultWrapper,
  PopSceneOutOfPanelTemplate,
  PushSceneIntoPanelTemplate,
  SCBSceneInfo,
  SCBSceneMissionType,
  SCBScenePanelMissionHandler,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBTransitionSceneOpts,
  StartSceneTemplate,
  TerminateSceneTemplate,
} from '@ohos/windowscene';
import { StartSceneOnGeneralPanel } from './StartSceneOnGeneralPanel';
import { MinimizeSceneTemplate } from '@ohos/windowscene/Index';

const TAG = '[SCBMission]StartSceneOnGeneralPanel';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * MissionHandler of GeneralScenePanel
 */
export class SCBGeneralScenePanelMissionHandler extends SCBScenePanelMissionHandler {

  constructor(screenProperty: SCBScreenProperty) {
    super(screenProperty);
  }

  protected preSetMissionTemplates(): void {
    this.addMissionTemplate(SCBSceneMissionType.START_SCENE_FROM_OTHER, new StartSceneOnGeneralPanel(this));
    this.addMissionTemplate(SCBSceneMissionType.TERMINATE_SCENE, new TerminateSceneTemplate(this));
    this.addMissionTemplate(SCBSceneMissionType.POP_SCENE_OUT, new PopSceneOutOfPanelTemplate(this));
    this.addMissionTemplate(SCBSceneMissionType.PUSH_SCENE_IN, new PushSceneIntoPanelTemplate(this));
    this.addMissionTemplate(SCBSceneMissionType.MINIMIZE_SCENE, new MinimizeSceneTemplate(this));
  }

  onStartSceneFromOther(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): CommonResult {
    let resultWrapper: CommonResultWrapper = new CommonResultWrapper(CommonResult.FAIL);
    if (this.interceptStartScene(toInfo, resultWrapper)) {
      return resultWrapper.result;
    }
    return super.onStartSceneFromOther(toInfo);
  }

  onStartSceneTransition(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo, opts?: SCBTransitionSceneOpts): CommonResult {
    let resultWrapper: CommonResultWrapper = new CommonResultWrapper(CommonResult.FAIL);
    if (this.interceptStartScene(toInfo, resultWrapper)) {
      return resultWrapper.result;
    }
    return super.onStartSceneTransition(toInfo, fromInfo, opts);
  }

  /**
   * custom start interceptions 拦截判断
   * @param sceneInfo sceneInfo target sceneInfo 目标sceneInfo
   * @param resultWrapper 用于接收启动窗口的执行结果
   * @returns true-intercepted, false not 返回是否中断标志位
   */
  public interceptStartScene(sceneInfo: SCBSceneInfo, resultWrapper?: CommonResultWrapper): boolean {
    return false;
  }
}