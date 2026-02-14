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

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { FoldOuterContainerSession } from '../../../../../main/ets/components/FoldOuterContainerSession';
import { SCBSceneInfo, SCBSceneSession, SCBSceneSessionManager } from '@ohos/basiccommon/src/main/ets/TsIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';

export function FoldOuterContainerSessionTest() {
  describe('FoldOuterContainerSessionTest', () => {
    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    it('FoldOuterScenePanelTest_01', 0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: sceneSessionManager.SceneSession =
        SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
      if (sceneSession) {
        let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSession, sceneInfo);
        let container: FoldOuterContainerSession = new FoldOuterContainerSession(scbSceneSession);
        expect(container.isActive).assertFalse();
        container.requestSceneSessionActivation();
        expect(container.isActive).assertTrue();
        container.requestSceneSessionBackground();
        expect(container.isActive).assertFalse();
        container.requestSceneSessionDestruction();
        expect(container.isActive).assertFalse();
      }
    });
  });
}

