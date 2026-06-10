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
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { SCBScenePanelManager } from '@ohos/windowscene';
import { SCBSceneContainerSessionArray } from '@ohos/windowscene';
import type { IExecutor } from '@ohos/launchercommon';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

const TAG: string = 'ClearRecentCards';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * 多任务清除任务卡片
 *
 * @since 2024-4-12
 */

export class ClearRecentCards implements IExecutor {

  private containerSessionList: SCBSceneContainerSessionArray =
    SCBScenePanelManager.getInstance().getSceneContainerSessionList();
  private floatContainerSessionList: SCBSceneContainerSessionArray =
    SCBScenePanelManager.getInstance().getFloatingSessionList();
  private debugAbilityName: ExtraAbilityName = {
    abilityName: ''
  };

  private registerDebugCommands(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'clearRecentCards',
        callback: (args: Array<string>): string => {
          return this.debugExecute(args);
        }
      },
    ];
    DebugCommandManager.getInstance().register(`${TAG}`, cmds);
  }

  private debugExecute(args?: Array<string>): string {
    if (args && args.length > 0) {
      this.debugAbilityName.abilityName = args[0];
    }
    const sessionLisLen = this.containerSessionList.length;
    if (sessionLisLen > 0) {
      if (this.containerSessionList[sessionLisLen - 1] &&
        !this.containerSessionList[sessionLisLen - 1].needRenderShowInRecent.showInRecent) {
        this.execute(this.debugAbilityName as object);
      }
    }
    return 'success';
  }

  async execute(extra?: object): Promise<string> {

    const abilityName = (extra as ExtraAbilityName)?.abilityName;
    this.registerDebugCommands();

    log.showInfo(`recv ClearRecentCards from RecentDeviceService, will clear all container session and float session except ${abilityName}`);
    // 1、销毁普通卡片，删除list
    for (let i = 0; i < this.containerSessionList.length; i++) {
      if (this.containerSessionList[i].primarySession?.sceneInfo.abilityName !== abilityName &&
        !this.containerSessionList[i].primarySession?.isUnclearable()) {
        this.containerSessionList[i].requestDestruction(true, false, true, true);
        this.containerSessionList.splice(i, 1);
        i--;
      }
    };

    // 2、销毁悬浮窗卡片，删除list
    for (let i = 0; i < this.floatContainerSessionList.length; i++) {
      if (this.floatContainerSessionList[i].primarySession?.sceneInfo.abilityName !== abilityName &&
      !this.floatContainerSessionList[i].primarySession?.isUnclearable()) {
        this.floatContainerSessionList[i].requestDestruction(true);
        this.floatContainerSessionList.splice(i, 1);
        i--;
      }
    }

    return Response.SUCCESS_OK;
  }
}

interface ExtraAbilityName {
  abilityName: string;
}