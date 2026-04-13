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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper'

function registerTest1(args: Array<string>): string {
  return 'registerTest1';
}

export function DebugCommandTest() {
  describe('DebugCommandTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })

    it('register', 0, (): void => {
      let cmds: Array<DebugCommand> = [
        {
          cmdName: 'registerTest1',
          callback: (args: Array<string>) => {
            return registerTest1(args);
          }
        }
      ];
      DebugCommandManager.getInstance().register('registerTestModule1', cmds);
      expect(DebugCommandManager.getInstance().getAllModules() === 'registerTestModule1').assertTrue;
    })
  })
}