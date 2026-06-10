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
import { MultiSelectManager } from '../../TsIndex';

/**
 * 多选拖拽 debug命令配置
 */
export class MultiSelectDebug {
  constructor() {
    const debugCommand: DebugCommand[] = [
      {
        cmdName: 'showSelectList',
        callback: (args: Array<string>): string => {
          let arr: string[] = [];
          MultiSelectManager.getInstance().multiSelectMap.forEach(item => {
            arr.push(JSON.stringify(item));
          });
          return arr.join('\n\n');
        }
      },
      {
        cmdName: 'showCheckboxList',
        callback: (args: Array<string>): string => {
          let arr: string[] = [];
          MultiSelectManager.getInstance().checkboxInfoMap.forEach(item => {
            arr.push(JSON.stringify(item));
          });
          return arr.join('\n\n');
        }
      },
      {
        cmdName: 'setEnabled',
        callback: (args: Array<string>): string => {
          let bool: Object = JSON.parse(args.join(''));
          MultiSelectManager.getInstance().debug_enabledMultiSelect = Boolean(bool);
          return `set to ${bool}`;
        }
      }
    ];
    DebugCommandManager.getInstance().register('multiSelect', debugCommand);
  };
}
