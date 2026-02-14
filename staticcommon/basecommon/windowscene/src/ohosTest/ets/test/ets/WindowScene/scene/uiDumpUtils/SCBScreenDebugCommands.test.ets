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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  SCBScreenSessionManager
} from '../../../../../../../main/ets/screen/session/SCBScreenSessionManager';
import { SCBScreenProperty } from '../../../../../../../main/ets/screen/session/SCBScreenSession';
import { SCBScreenDebugCommands } from '../../../../../../../main/ets/scene/dump/SCBScreenDebugCommands';

export default function SCBScreenDebugCommandsTest() {
  let screenDebugCommands: SCBScreenDebugCommands = new SCBScreenDebugCommands();
  let screenSessionList = SCBScreenSessionManager.getInstance().getScreenSessionList();
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  describe('SCBScreenDebugCommandsTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('register', 0, (): void => {
      screenDebugCommands.register()
      expect(true).assertTrue();
    })

    it('unregister', 0, (): void => {
      screenDebugCommands.unregister();
      expect(true).assertTrue();
    })

    it('buildScreenSessionList', 0, (): void => {
      expect((SCBScreenDebugCommands as object)['buildScreenSessionList'](screenSessionList))
        .assertContain("scbScreenProperty");
    })

    it('buildSCBScreenProperty', 0, (): void => {
      let result = SCBScreenDebugCommands.buildSCBScreenProperty(screenProperty);
      expect(result).assertContain("defaultScreenOrientation");
    })
  })
}