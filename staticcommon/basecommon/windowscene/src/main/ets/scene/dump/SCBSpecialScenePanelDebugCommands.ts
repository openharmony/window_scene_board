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

import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { SCBSceneContainerSessionArray } from '../session/SCBSceneContainerSession';
import { SCBSceneContainerSessionDebugCommands } from './SCBSceneContainerSessionDebugCommands';

const TAG = 'SCBSpecialScenePanel';

export class SCBSpecialScenePanelDebugCommands {
  private readonly containerSessionList: SCBSceneContainerSessionArray;

  constructor(specialContainerSessionList: SCBSceneContainerSessionArray) {
    this.containerSessionList = specialContainerSessionList;
  }

  public register(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'specialContainerSessionList',
        callback: (args: string[]): string => {
          return SCBSceneContainerSessionDebugCommands.dealContainerSessionList(this.containerSessionList, args);
        }
      },
      {
        cmdName: 'specialContainerSession',
        callback: (args: string[]): string => {
          return SCBSceneContainerSessionDebugCommands.dealContainerSessionCommands(this.containerSessionList, args);
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  public unregister(): void {
    DebugCommandManager.getInstance().unregister(TAG);
  }
}