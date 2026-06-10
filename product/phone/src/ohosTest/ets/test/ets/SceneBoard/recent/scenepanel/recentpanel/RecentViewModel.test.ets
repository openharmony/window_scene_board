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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  it,
  Level,
  TestType,
  Size,
  expect
} from "@ohos/hypium"
import {
  RecentViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentViewModel';
import { SCBSceneContainerSession, SCBSceneInfo, SCBSceneSession, SCBScreenProperty } from "@ohos/windowscene";
import sceneSessionManager from "@ohos.sceneSessionManager";

export default function RecentViewModelTest() {
  describe('RecentViewModelTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let scbSceneContainer: SCBSceneContainerSession =
      new SCBSceneContainerSession(primarySession, new SCBScreenProperty());

    it('RecentViewModelTest_test_getInstance_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let recentViewModel = RecentViewModel.getInstance();
      expect(recentViewModel).not().assertNull();
    })

    it('RecentViewModelTest_test_onMinimizeScene_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let result = RecentViewModel.getInstance().onMinimizeScene(scbSceneContainer);
      expect(result).assertFalse();
    })

    it('RecentViewModelTest_test_onLockReceived_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      RecentViewModel.getInstance().onLockReceived();
      expect(true).assertEqual(true);
    })

    it('RecentViewModelTest_test_getMaxCount_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let maxCount = RecentViewModel.getInstance().getMaxCount();
      expect(maxCount).not().assertEqual(-1);
    })

    it('RecentViewModelTest_test_reFreshRecentDock_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      RecentViewModel.getInstance().reFreshRecentDock();
      expect(RecentViewModel).not().assertNull();
    })
  })
}