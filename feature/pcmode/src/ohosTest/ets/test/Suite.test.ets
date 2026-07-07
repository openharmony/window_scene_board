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
import { describe } from '@ohos/hypium';
import { SCBPCSceneMissionProcessorTest } from './ets/scenemanager/SCBPCSceneMissionProcessor.test';
import { SCBPcScenePanelManagerTest } from './ets/instance/SCBPcScenePanelManagerTest.test';
import { PcModeRSSUtilsTest } from './ets/utils/PcModeRSSUtilsTest.test';
import { SCBPcModeUtilsTest } from './ets/utils/SCBPcModeUtilsTest.test';
import { SCBSceneHelperTest } from './ets/utils/SCBSceneHelperTest.test';
import { SessionTempListOthersOneUtilsTest } from './ets/utils/SessionTempListOthersOneUtilsTest.test';
import { SessionTempListOthersUtilsTest } from './ets/utils/SessionTempListOthersUtilsTest.test';
import { SessionTempListUtilsTest } from './ets/utils/SessionTempListUtilsTest.test';
import { SCBBaseFreeWindowsViewModelTest } from './ets/viewmodel/SCBBaseFreeWindowsViewModelTest.test';
import { SCBFreeWindowsViewModelManagerTest } from './ets/viewmodel/SCBFreeWindowsViewModelManagerTest.test';
import { SCBSystemSceneUtilsTest } from './ets/utils/SCBSystemSceneUtilsTest.test';

export default function PipelineDemoSuite() {
  describe("window_scene_board", () => {
    InstanceTest();
    UtilsTest();
    ViewModelTest();
  });
}

function InstanceTest() {
  SCBPcScenePanelManagerTest();
  SCBPCSceneMissionProcessorTest();
}

function UtilsTest() {
  PcModeRSSUtilsTest();
  SCBPcModeUtilsTest();
  SessionTempListUtilsTest();
  SessionTempListOthersUtilsTest();
  SessionTempListOthersOneUtilsTest();
  SCBSceneHelperTest();
  SCBSystemSceneUtilsTest();
}

function ViewModelTest() {
  SCBFreeWindowsViewModelManagerTest();
  SCBBaseFreeWindowsViewModelTest();
}
