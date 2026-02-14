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
import {
SCBSceneContainerSession,
} from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';
import { SCBScenePanelManager, } from '../../../../../../../main/ets/scene/manager/SCBScenePanelManager';
import { SCBSceneInfo, } from '../../../../../../../main/ets/scene/session/SCBSceneInfo';
import { SCBSceneSession } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import { SCBScreenProperty } from '../../../../../../../main/ets/screen/session/SCBScreenSession';
import {
  SCBScenePanelDebugCommands
} from '../../../../../../../main/ets/scene/dump/SCBScenePanelDebugCommands';
import sceneSessionManager from '@ohos.sceneSessionManager';

export default function SCBScenePanelDebugCommandsTest() {
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let panelMgr: SCBScenePanelManager = SCBScenePanelManager.getInstance(screenProperty);
  let sceneDebugCommands: SCBScenePanelDebugCommands = new SCBScenePanelDebugCommands(panelMgr);
  let floatScbSceneInfo: SCBSceneInfo = new SCBSceneInfo('floatBundleName', 'floatModuleName', 'floatAbilityName');
  let floatScbSceneSession: SCBSceneSession =
    new SCBSceneSession(sceneSessionManager.requestSceneSession(floatScbSceneInfo), floatScbSceneInfo);
  let floatContainer: SCBSceneContainerSession =
    new SCBSceneContainerSession(floatScbSceneSession, new SCBScreenProperty());
  let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
  let scbSceneSession: SCBSceneSession =
    new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
  let container: SCBSceneContainerSession =
    new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
  describe('SCBScenePanelDebugCommandsTest', (): void => {
    beforeAll((): void => {
      panelMgr.addSceneContainerSession(container);
      panelMgr.addFloatContainerSession(floatContainer);
    })

    beforeEach((): void => {

    })

    afterAll((): void => {
      panelMgr.removeSceneContainerSession(container);
      panelMgr.removeFloatSceneContainerSession(floatContainer);
    })

    afterEach((): void => {

    })

    it('register', 0, (): void => {
      sceneDebugCommands.register()
      expect(true).assertTrue();
    })

    it('unregister', 0, (): void => {
      sceneDebugCommands.unregister();
      expect(true).assertTrue();
    })

    it('debugGetScnPanelParam', 0, (): void => {
      expect((sceneDebugCommands as object)['debugGetScnPanelParam']()).assertContain("top active container");
    })

    it('debugGetContainerSession', 0, (): void => {
      expect((sceneDebugCommands as object)['debugGetContainerSession'](["0"])).assertContain('primarySession');
    })

    it('debugGetViewParam', 0, (): void => {
      expect((sceneDebugCommands as object)['debugGetViewParam']()).assertContain('recentPadding');
    })
  })
}