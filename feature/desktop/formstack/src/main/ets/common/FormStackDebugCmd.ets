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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';

const TAG = 'FormStackDebugCmd';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackDebugCmd {
  private static instance: FormStackDebugCmd;
  private expandAnimateSwitch: boolean = true;

  static getInstance(): FormStackDebugCmd {
    if (FormStackDebugCmd.instance == null) {
      FormStackDebugCmd.instance = new FormStackDebugCmd();
    }
    return FormStackDebugCmd.instance;
  }

  public registerDebugCommands(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'setExpandAnimateSwitch',
        callback: (args: string[]) => {
          return this.setExpandAnimateSwitch(args);
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  public unregisterDebugCommands(): void {
    DebugCommandManager.getInstance().unregister(TAG);
  }

  public isNeedExpandAnimate(): boolean {
    return this.expandAnimateSwitch;
  }

  public setExpandAnimateSwitch(args: string[]): string {
    if (args.length === 0) {
      return 'Please input true or false';
    }
    this.expandAnimateSwitch = (args[0] === 'true');
    log.showInfo('set ExpandAnimateSwitch ' + this.expandAnimateSwitch);
    return 'set ExpandAnimateSwitch ' + this.expandAnimateSwitch + ' success';
  }
}