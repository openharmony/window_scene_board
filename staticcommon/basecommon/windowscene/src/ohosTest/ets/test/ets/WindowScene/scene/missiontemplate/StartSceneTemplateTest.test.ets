/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  when,
} from '@ohos/hypium'
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBMainSessionTuple,
  SCBStartSceneOpts
} from '../../../../../../../main/ets/scene/framework/missions/SCBSceneMissionTypes';
import { StartSceneTemplate } from '../../../../../../../main/ets/scene/framework/missiontemplate/StartSceneTemplate';
import { SCBSceneSession } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import { SCBScreenProperty } from '../../../../../../../main/ets/screen/session/SCBScreenSession';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
} from '../../../../../../../main/ets/TsIndex';
import {
  SCBScenePanelMissionHandler
} from '../../../../../../../main/ets/scene/SceneModuleIndex' ;

const TAG = 'StartSceneTemplate';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class MockStartSceneTemplate extends StartSceneTemplate<SCBScenePanelMissionHandler> {
}

export function StartSceneTemplateTest() {
  describe('StartSceneTemplate_onProcess_testSuite', () => {
    let missionHandler: SCBScenePanelMissionHandler = new SCBScenePanelMissionHandler();
    let startTemplate: MockStartSceneTemplate = new MockStartSceneTemplate(missionHandler);
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);

    it('test_whenOnProcessNoExistContainerSession_thenNewContainerSession', Level.LEVEL0, () => {
      expect(missionHandler.getContainerSessionByPersistentIdOrContainerId(9527)).assertNull();
      const process : Function = startTemplate.getProcessor();
      process(sceneInfo);
      let containerSession: SCBSceneContainerSession | null = missionHandler.getContainerSessionByPersistentIdOrContainerId(9527);
      expect(containerSession).not().assertNull();
      if (containerSession) {
        expect(containerSession.isActive).assertTrue();
      }
    });

    it('test_whenOnProcessExistContainerSession_thenUseExistContainerSession', Level.LEVEL0, () => {
      let containerSession: SCBSceneContainerSession | null = missionHandler.getContainerSessionByPersistentIdOrContainerId(9527);
      expect(containerSession).not().assertNull();
      if (containerSession) {
        containerSession.requestSceneBackground();
      }

      containerSession = missionHandler.getContainerSessionByPersistentIdOrContainerId(9527);
      expect(containerSession).not().assertNull();
      if (containerSession) {
        expect(containerSession.isActive).assertTrue();
      }
    });
  })
}