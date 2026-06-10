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
import {
  SCBPropertyChangeReason,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty} from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium'
import { DefaultDesktopLayoutInfo } from '@ohos/launchercommon/src/main/ets/TsIndex'
import { SCBOuterScenePanelManager } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/SCBOuterScenePanelManager'
import sceneSessionManager from '@ohos.sceneSessionManager'
import { SCBScenePanel } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/SCBScenePanel'
import { display } from '@kit.ArkUI'
import { RecentNotShow } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentNotShow'

export default function SCBOuterScenePanelManagerTest() {
  describe('SCBOuterScenePanelManagerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('test_outerScenePanel_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      globalThis.outerPhonePageDesktopLayoutConfig = null;
      let instance: SCBOuterScenePanelManager = SCBOuterScenePanelManager.getInstance();
      expect(globalThis.SCBOuterScenePanelManager).assertEqual(instance);
      expect(instance).assertEqual(SCBOuterScenePanelManager.getInstance());
    })

    it('test_outerScenePanel_updateCurrentStatus', 0, () => {
      let status: display.FoldDisplayMode = 0;
      let instance: SCBOuterScenePanelManager = SCBOuterScenePanelManager.getInstance();
      instance.updateCurrentStatus(status);
      expect(AppStorage.get<display.FoldDisplayMode>('singleDisplayPocketFoldDisplayMode')).assertEqual(status);
    })

    it('test_outerScenePanel_filterSceneContainerListForOuter', 0, () => {
      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      containerSessionList.add(scbSceneContainer);
      let instance: SCBOuterScenePanelManager = SCBOuterScenePanelManager.getInstance();
      let screenSessionIdx: number[] = [];
      screenSessionIdx.push(0, 1, 2);
      instance.filterSceneContainerListForOuter(screenSessionIdx, containerSessionList);
      expect(instance).not().assertNull();
    })
  })
}