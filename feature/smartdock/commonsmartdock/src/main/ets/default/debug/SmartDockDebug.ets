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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { SmartDockZoomFeatureSwitch } from '@ohos/launchercommon';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import { SmartDockZoomAnimationConfig } from '../common/SmartDockZoomAnimationConfig';

const TAG = 'SmartDock_D_SmartDockDebug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/* Dock区DEBUG配置参数模块 */
export class SmartDockDebug {
  private static instance: SmartDockDebug;

  public static getInstance(): SmartDockDebug {
    if (!SmartDockDebug.instance) {
      SmartDockDebug.instance = new SmartDockDebug();
    }
    return SmartDockDebug.instance;
  }

  public unregisterDebug(): void {
    DebugCommandManager.getInstance().unregister(TAG);
  }

  public registerDebug(): void {
    DebugCommandManager.getInstance().register(TAG, this.getCommands());
  }

  private getCommands(): DebugCommand[] {
    let cmds: DebugCommand[] = [];
    cmds.push({
      cmdName: 'debugMode',
      callback: (args: Array<string>) => this.debugMode(args)
    });
    return cmds;
  }

  private debugMode(args: string[]): string {
    let ret: string = 'open debug mode';
    SmartDockZoomFeatureSwitch.setDebugMode(true);
    SmartDockZoomAnimationConfig.initial();
    SmartDockStyleConfig.updateDockListLengthConfig();
    return ret;
  }
}