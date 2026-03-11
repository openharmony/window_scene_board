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

import {
  describe,
  beforeAll,
  it,
  Level,
  beforeEach,
  afterEach,
  afterAll,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenProperty } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSession,
} from '@ohos/windowscene';
import { ReflectionUtils } from '../../multiwindow/ReflectionUtils';
import {
  SCBSpecialScenePanelViewModel,
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewmodel/SCBSpecialScenePanelViewModel';

const MOCK_TAG = 'SCBSpecialScenePanelViewModel';
const mockLog = LogHelper.getLogHelper(LogDomain.WINDOW, MOCK_TAG);

export default function MaximizeSceneOnSpecialPanelTest() {
  describe('MaximizeSceneOnSpecialPanel_testSuite', (): void => {
    let mocker: MockKit;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      mocker = new MockKit();
      viewModel = new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    });

    afterEach(() => {
      viewModel.getContainerSessionList().clear();
    });

    it('test_whenMaximizeOneContainer_thenRequestBackgroundOtherFullscreenContainer', Level.LEVEL0, () => {
      let sceneInfo01 = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 111);
      let sceneInfo02 = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 222);
      sceneInfo01.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      let sceneSession01: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo01), sceneInfo01);
      let sceneSession02: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo02), sceneInfo02);
      let sceneContainerSession01: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession01, new SCBScreenProperty());
      let sceneContainerSession02: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession02, new SCBScreenProperty());
      ReflectionUtils.setProperty(sceneContainerSession01, '_isActive', true);
      ReflectionUtils.setProperty(sceneContainerSession02, '_isActive', true);
      viewModel.getContainerSessionList().push(sceneContainerSession01);
      viewModel.getContainerSessionList().push(sceneContainerSession02);

      viewModel.onMaximizeScene(222);

      expect(sceneContainerSession01.isActive).assertEqual(false);
      expect(sceneSession01.isActive).assertEqual(false);
    });
  });
}