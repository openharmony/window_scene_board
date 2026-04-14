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
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { FolderActionLifeCycleStatusManager } from '../../viewmodel/lifecycle/FolderActionLifeCycleStatusManager';
import { FolderParameterManager } from './FolderParameterManager';

const TAG = 'FolderDebug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/* 文件夹DEBUG配置参数模块 */
export class FolderDebug {
  private static instance: FolderDebug;
  public static getInstance(): FolderDebug {
    if (!FolderDebug.instance) {
      FolderDebug.instance = new FolderDebug();
    }

    return FolderDebug.instance;
  }

  private constructor() {
    DebugCommandManager.getInstance().register('Folder', this.getCommands());
  }

  private getCommands(): DebugCommand[] {
    let cmds: DebugCommand[] = [];
    cmds.push({cmdName: 'listParameter',
      callback: (args) => FolderParameterManager.getInstance().getAllParameterDesc()});
    cmds.push({cmdName: 'setParameter',
      callback: (args) => FolderParameterManager.getInstance().setParameterByDebug(args[0], args[1])});
    cmds.push({cmdName: 'getParameter',
      callback: (args) => FolderParameterManager.getInstance().getParameterByDebug(args[0])});
    cmds.push({cmdName: 'getStatusDesc', callback: (args) => this.getStatusDesc(args)});
    cmds.push({cmdName: 'getFolderDataCallbackDesc', callback: (args) => this.getFolderLifeCycleEventDesc(args)});

    return cmds;
  }

  private getStatusDesc(args: Array<string>): string {
    return FolderActionLifeCycleStatusManager.getInstance().getStatusDesc();
  }


  private getFolderLifeCycleEventDesc(args: Array<string>): string {
    return '';
  }
}