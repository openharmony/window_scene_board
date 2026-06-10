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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { GravityAnimationDebug } from '../../../../../../../../../main/ets/service/animator/gravity/algorithm/debug/GravityAnimationDebug';

/**
 * GravityAnimationDebug DT测试套
 */
export function GravityAnimationDebugTest() {
  describe('GravityAnimationDebugTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('GravityAnimationDebugTest_getCommands', Level.LEVEL0, (): void => {
      let cmds = GravityAnimationDebug.getCommands();

      let resetCmd = cmds.find((item) => item.cmdName === 'Reset');
      expect(resetCmd).not().assertNull();
      expect(resetCmd).not().assertUndefined();
      let enableCmd = cmds.find((item) => item.cmdName === 'SetEnable');
      expect(enableCmd).not().assertNull();
      expect(enableCmd).not().assertUndefined();

      enableCmd?.callback(['1']);
      resetCmd?.callback([]);
      cmds.forEach((cmd) => {
        /* reset/enable不在这里单独测试 */
        if (cmd === resetCmd || cmd === enableCmd) {
          return;
        }
        expect(cmd.cmdName.length).assertLarger(0);

        let res = cmd.callback([]);
        expect(res.length).assertLarger(0);

        let inputs: string[] = [];
        res = cmd.callback(inputs);
        expect(res.length).assertLarger(0);

        inputs.push('invalid number');
        res = cmd.callback(inputs);
        expect(res.length).assertLarger(0);

        inputs.pop();
        inputs.push('1');
        res = cmd.callback(inputs);
        expect(res.length).assertLarger(0);
      })
      /* 恢复数据，不要影响后面的用例 */
      resetCmd?.callback([]);
    })
  })
}