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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  SCBSpecificSceneSessionList
} from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import {
  SCBSpecificScenePanelDebugCommands
} from '../../../../../../../main/ets/scene/dump/SCBSpecificScenePanelDebugCommands';

export default function SCBSpecificScenePanelDebugCommandsTest() {
  let systemSceneList: SCBSpecificSceneSessionList
  let zIndex: number = Number.MAX_VALUE; // Index值 为防止与已有冲突 设置为最大值
  let sceneDebugCommands: SCBSpecificScenePanelDebugCommands;
  describe('SCBSpecificScenePanelDebugCommandsTest', () => {
    beforeAll(() => {
      sceneDebugCommands = new SCBSpecificScenePanelDebugCommands(systemSceneList, zIndex);
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('register', 0, (): void => {
      sceneDebugCommands.register()
      expect(true).assertTrue();
    })

    it('unregister', 0, (): void => {
      sceneDebugCommands.unregister();
      expect(true).assertTrue();
    })
  })
}