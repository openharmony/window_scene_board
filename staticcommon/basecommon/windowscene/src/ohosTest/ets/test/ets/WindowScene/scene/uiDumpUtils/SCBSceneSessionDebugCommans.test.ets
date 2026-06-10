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
import { SCBSceneInfo, } from '../../../../../../../main/ets/scene/session/SCBSceneInfo';
import { SCBSceneSession } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import {
  SCBSceneSessionDebugCommands
} from '../../../../../../../main/ets/scene/dump/SCBSceneSessionDebugCommans';
import sceneSessionManager from '@ohos.sceneSessionManager';

export default function SCBSceneSessionDebugCommandsTest() {
  let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
  let scbSceneSession: SCBSceneSession =
    new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
  describe('SCBSceneSessionDebugCommandsTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('buildSession', 0, () => {
      let result: String = SCBSceneSessionDebugCommands.buildSession(scbSceneSession);
      expect(result)
        .assertContain('lastRect:{"left":{"value":0},"top":{"value":0},"width":{"value":0},"height":{"value":0}}');
    })
  })
}