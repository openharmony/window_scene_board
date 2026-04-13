/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';

const TAG = 'DebugCommandsUtils';

export class DebugCommandsUtils {

  /**
   * Debug命令
   * @param imgTranslateX 箭头图片的目标X值
   * @param imgTranslateY 箭头图片的目标Y值
   */
  public static registerDebugCommands(imgTranslateX: number, imgTranslateY: number): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'getTranslate',
        callback: (args: Array<string>) => {
          return `imgTranslateX: ${imgTranslateX}, imgTranslateY: ${imgTranslateY}`;
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

}