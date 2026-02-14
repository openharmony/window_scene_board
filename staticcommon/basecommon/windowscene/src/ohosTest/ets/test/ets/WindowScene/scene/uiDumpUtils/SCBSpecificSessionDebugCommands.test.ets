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
import { SCBSpecificSession } from '../../../../../../../main/ets/scene/session/SCBSpecificSession';
import {
  SCBSceneSessionManager,
  SCBSpecificSceneSessionList
} from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import { SCBSceneInfo, } from '../../../../../../../main/ets/scene/session/SCBSceneInfo';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSpecificSessionDebugCommands
} from '../../../../../../../main/ets/scene/dump/SCBSpecificSessionDebugCommands';

export default function SCBSpecificSessionDebugCommandsTest() {
  let systemSceneList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
  let sceneSession: sceneSessionManager.SceneSession =
    SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
  let specificScene = new SCBSpecificSession(sceneSession, () => {
  })
  describe('SCBSpecificSessionDebugCommandsTest', () => {
    beforeAll(() => {
      systemSceneList.push(specificScene);
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('buildSpecificSessionList', 0, () => {
      let result = SCBSpecificSessionDebugCommands.buildSpecificSessionList(systemSceneList);
      expect(result).assertContain("isCustomAnimationPlaying");
    })

    it('buildSCBSpecificSession', 0, () => {
      let result = SCBSpecificSessionDebugCommands.buildSCBSpecificSession(specificScene);
      expect(result).assertContain("isCustomAnimationPlaying");
    })
  })
}