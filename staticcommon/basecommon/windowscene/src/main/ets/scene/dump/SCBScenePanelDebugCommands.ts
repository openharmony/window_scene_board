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
import { SCBSceneContainerSessionDebugCommands } from './SCBSceneContainerSessionDebugCommands';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray
} from '../session/SCBSceneContainerSession';
import { SCBScenePanelManager } from '../manager/SCBScenePanelManager';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { SCBScreenDebugCommands } from './SCBScreenDebugCommands';

const TAG = 'SCBScenePanel';

export class SCBScenePanelDebugCommands {
  private panelManager: SCBScenePanelManager;
  private containerSessionList:SCBSceneContainerSessionArray;
  private isGetContainerSessionDisabled: boolean = false;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
    this.containerSessionList = this.panelManager.getSceneContainerSessionList();
  }

  private debugGetScnPanelParam(): string {
    let responseText = 'screen property: \r\n';
    responseText += this.getScreenPropertyStr();
    responseText += '\r\n';
    responseText += 'top active container: \r\n';
    responseText += this.getTopActiveSessionStr();
    return responseText;
  }

  private getScreenPropertyStr(): string {
    try {
      return JSON.stringify(this.panelManager.getScreenProperty(), null, 2);
    } catch (error) {
      return `error:${error.message}`;
    }
  }

  private getTopActiveSessionStr(): string {
    try {
      return JSON.stringify(this.containerSessionList.getTopActiveSession(), (key, value) => {
        if (DebugCommandManager.getInstance().filterMidSceneFSM(key)) {
          return value;
        }
        return false;
      }, 2);
    } catch (error) {
      return `error:${error.message}`;
    }
  }

  private static getContainerSessionListStr(containerSessionList: SCBSceneContainerSessionArray): string {
    try {
      return JSON.stringify(containerSessionList.slice().reverse(), (key, value: SCBSceneContainerSession) => {
        if (DebugCommandManager.getInstance().filterMidSceneFSM(key)) {
          return value;
        }
        return false;
      }, 2);
    } catch (error) {
      return `error:${error.message}`;
    }
  }

  /**
   * dump containSession信息时调用获取json格式字符串
   * @param containerSessionList 数据列表
   * @param args dump命令参数
   * @returns json格式字符串
   */
  public static getContainerSession(containerSessionList: SCBSceneContainerSessionArray, args: string[]): string {
    if (args.length === 0) {
      return SCBScenePanelDebugCommands.getContainerSessionListStr(containerSessionList);
    }
    let index = Number(args[0]);
    if (index >= containerSessionList.length) {
      return 'index is out of bounds';
    }
    return SCBSceneContainerSessionDebugCommands.buildContainerAll(containerSessionList[index]);
  }

  private debugGetContainerSession(args: string[]): string {
    if (!this.isGetContainerSessionDisabled) {
      return SCBScenePanelDebugCommands.getContainerSession(this.containerSessionList, args);
    } else {
      return 'getContainerSession has been disabled.';
    }
  }

  private debugGetFloatingContainerSession(args: string[]): string {
    let floatingContainerSessionList = this.panelManager.getFloatingSessionList();
    return SCBScenePanelDebugCommands.getContainerSession(floatingContainerSessionList, args);
  }

  private debugGetViewParam(): string {
    try {
      return JSON.stringify(this.panelManager.getViewParam(), null, 2);
    } catch (error) {
      return `error:${error.message}`;
    }
  }

  private debugDisabledGetContainerSession(args: string[]): string {
    if (args.length === 0) {
      return 'Invalid parameter';
    }
    let disableValue = args[0];
    this.isGetContainerSessionDisabled = disableValue === 'true';
    return `debugDisabledGetContainerSession ${this.isGetContainerSessionDisabled}`
  }

  public register(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'getViewParam',
        callback: (): string => {
          return this.debugGetViewParam();
        }
      },
      {
        cmdName: 'GetScnPanelParam',
        callback: (): string => {
          return this.debugGetScnPanelParam();
        }
      },
      {
        cmdName: 'screenProperty',
        callback: (): string => {
          return SCBScreenDebugCommands.buildSCBScreenProperty(this.panelManager.getScreenProperty());
        }
      },
      {
        cmdName: 'disableGetContainerSession',
        callback: (args: string[]): string => {
          return this.debugDisabledGetContainerSession(args);
        }
      }
    ];
    this.dealContainerSessionCmds(cmds);
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  private dealContainerSessionCmds(cmds: DebugCommand[]): void {
    cmds.push({
      cmdName: 'getContainerSession',
      callback: (args: string[]): string => {
        return this.debugGetContainerSession(args);
      }
    });
    cmds.push({
      cmdName: 'getFloatingContainerSession',
      callback: (args: string[]): string => {
        return this.debugGetFloatingContainerSession(args);
      }
    });
    cmds.push({
      cmdName: 'containerSessionList',
      callback: (args: string[]): string => {
        return SCBSceneContainerSessionDebugCommands.dealContainerSessionList(this.containerSessionList, args);
      }
    });
    cmds.push({
      cmdName: 'containerSession',
      callback: (args: string[]): string => {
        return SCBSceneContainerSessionDebugCommands.dealContainerSessionCommands(this.containerSessionList, args);
      }
    });
  }

  public unregister(): void {
    DebugCommandManager.getInstance().unregister(TAG);
  }
}