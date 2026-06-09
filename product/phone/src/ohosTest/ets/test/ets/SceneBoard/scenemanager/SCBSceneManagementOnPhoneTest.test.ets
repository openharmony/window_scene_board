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

import SCBScenePanelViewModelTest from './viewmodel/SCBScenePanelViewModel.test';
import SCBSpecialScenePanelViewModelTest from './viewmodel/SCBSpecialScenePanelViewModel.test';
import { SceneStartTransitionOnSpecialPanelTest } from './it/missionmanagement/SceneStartTransitionOnSpecialPanel.test';
import { DestroySceneAndonCloseSceneOnSpecialPanelTest } from './it/missionmanagement/DestroySceneAndonCloseSceneOnSpecialPanel.test';
import SCBCommonSceneManagementTest from '@ohos/windowscene/src/ohosTest/ets/test/ets/WindowScene/scene/SCBCommonSceneManagementTest.test';
import OnMinimizeSceneOnSpecialPanelTest from './it/missionmanagement/OnMinimizeSceneOnSpecialPanel.test';
import MinimizeAllSceneOnSpecialPanelTest from './it/missionmanagement/MinimizeAllSceneOnSpecialPanel.test';
import OnTerminateSceneOnSpecialPanelTest from './it/missionmanagement/OnTerminateSceneOnSpecialPanel.test';
import { StartSceneFromOtherOnSpecialPanel } from './it/missionmanagement/StartSceneFromOtherOnSpecialPanel.test';
import { StartSceneFromRecentOnPanelTest } from './it/missionmanagement/StartSceneFromRecentOnPanel.test';
import MaximizeSceneOnSpecialPanelTest from './it/missionmanagement/MaximizeSceneOnSpecialPanel.test';
import TransferSceneInOnSpecialPanelTest from './it/missionmanagement/TransferSceneInOnSpecialPanel.test';
import TransferSceneOutOnSpecialPanelTest from './it/missionmanagement/TransferSceneOutOnSpecialPanel.test';

/**
 * Phone平台窗口管理测试套
 */
export default function SCBSceneManagementOnPhoneTest() {
  /*
   * 窗口管理基座测试套
   */
  SCBCommonSceneManagementTest();

  /*
   * Phone窗口管理测试套
   */
  SCBScenePanelViewModelTest();
  SCBSpecialScenePanelViewModelTest();

  /*
   * Phone窗口管理it测试套
   */
  SceneStartTransitionOnSpecialPanelTest();
  DestroySceneAndonCloseSceneOnSpecialPanelTest();
  OnMinimizeSceneOnSpecialPanelTest();
  MinimizeAllSceneOnSpecialPanelTest();
  OnTerminateSceneOnSpecialPanelTest();
  StartSceneFromRecentOnPanelTest();
  StartSceneFromOtherOnSpecialPanel();
  MaximizeSceneOnSpecialPanelTest();
  TransferSceneInOnSpecialPanelTest();
  TransferSceneOutOnSpecialPanelTest();
}