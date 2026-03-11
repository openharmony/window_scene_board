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
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { SCBSpecificSceneSessionList } from '../session/SCBSceneSessionManager';
import { SCBSpecificSessionDebugCommands } from './SCBSpecificSessionDebugCommands';

const TAG = 'SCBSpecificScenePanel';

export class SCBSpecificScenePanelDebugCommands {
  private readonly systemSceneList: SCBSpecificSceneSessionList;
  private readonly zIndex: number;

  constructor(systemSceneList: SCBSpecificSceneSessionList, zIndex: number) {
    this.systemSceneList = systemSceneList;
    this.zIndex = zIndex;
  }

  public register(): void {
    switch (this.zIndex) {
      // SCBDefaultZIndex.SPECIFIC_ABOVE_KEYGUARD
      case 3000:
        let cmds: DebugCommand[] = [
          {
            cmdName: 'sceneList',
            callback: (): string => {
              return SCBSpecificSessionDebugCommands.buildSpecificSessionList(this.systemSceneList);
            }
          }
        ];
        DebugCommandManager.getInstance().register(TAG + this.zIndex, cmds);
        break;
      default:
        break;
    }
  }

  public unregister(): void {
    switch (this.zIndex) {
      // SCBDefaultZIndex.SPECIFIC_ABOVE_KEYGUARD
      case 3000:
        DebugCommandManager.getInstance().unregister(TAG + this.zIndex);
        break;
      default:
        break;
    }
  }
}