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
import { describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when} from '@ohos/hypium';
import { DockItemInfo } from '@ohos/launchercommon';

import { ScbExtDockViewData } from '../../../../main/ets/SceneBoard/extmode/viewmodel/viewdata/ScbExtDockViewData';
import { SmartDockStyleConfig } from '@ohos/smartdock/src/main/ets/default/common/SmartDockStyleConfig';

const TAG = 'ScbExtDockViewDataTest';

export default function ScbExtDockViewDataTest() {
  describe('ScbExtDockViewDataTest', () => {
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

    it('test_ScbExtDockViewDataTest_instance', Level.LEVEL0, (): void => {
      let viewData = new ScbExtDockViewData();
      expect(viewData).not().assertNull();

      let itemInfo = new DockItemInfo();
      viewData.appCenterItem = new DockItemInfo();
      expect(viewData).not().assertNull();

      viewData.recentCenterItem = new DockItemInfo();
      expect(viewData).not().assertNull();

      viewData.fileManagerItem = new DockItemInfo();
      expect(viewData).not().assertNull();

    })

    it('test_ScbExtDockViewDataTest_updateLocalResidentList_0', Level.LEVEL0, (): void => {
      let viewData = new ScbExtDockViewData();
      let globalResidentList: DockItemInfo[] = [];
      viewData.updateLocalResidentList(globalResidentList);
      expect(viewData).not().assertNull();
    })

    it('test_ScbExtDockViewDataTest_updateLocalRecentList', Level.LEVEL0, (): void => {
      let viewData = new ScbExtDockViewData();
      let appList: DockItemInfo[] = [];
      viewData.updateLocalRecentList(appList);
      expect(viewData).not().assertNull();
    })

    it('test_ScbExtDockViewDataTest_recalculateDockLayout', Level.LEVEL0, (): void => {
      let viewData = new ScbExtDockViewData();
      let globalResidentList: DockItemInfo[] = [];
      let globalRecentList: DockItemInfo[] = [];
      let cfg: SmartDockStyleConfig = SmartDockStyleConfig.getInstance();
      viewData.recalculateDockLayout(globalResidentList, globalRecentList, cfg);
      expect(viewData).not().assertNull();
    })

  })
}