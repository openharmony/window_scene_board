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
  SCBSceneContainerSessionArray,
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

export default function TransferSceneOutOnSpecialPanelTest() {
  describe('TransferSceneOutOnSpecialPanel_testSuite', (): void => {
    let mocker: MockKit;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      mocker = new MockKit();
      viewModel = new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    });

    afterEach(() => {
      viewModel.getContainerSessionList().clear();
    });

    it('test_whenTransferSceneOut_thenReturnContainerSessionList', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 111);
      sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      ReflectionUtils.setProperty(sceneContainerSession, '_isActive', true);
      viewModel.getContainerSessionList().push(sceneContainerSession);
      let mockIsItemShowCanBeChanged: Function = mocker.mockFunc(viewModel, viewModel.isItemShowCanBeChanged);
      when(mockIsItemShowCanBeChanged)(ArgumentMatchers.any).afterReturn(true);

      let res: SCBSceneContainerSessionArray = viewModel.onTransferSceneOut();

      expect(res.length).assertEqual(1);
      mocker.ignoreMock(viewModel, viewModel.isItemShowCanBeChanged);
    });
  });
}