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
import { SCBSceneSessionManager } from '@ohos/windowscene';
import BundleManager from '@ohos.bundle.bundleManager';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  when
} from '@ohos/hypium';
import {
  GestureDockUtil
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/util/GestureDockUtil';
import {
  GestureDockItemInfo
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';
import {
  GestureDockBarViewDataMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewdata/GestureDockBarViewDataMgr';
import GestureDockAppDataHandler
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewhandler/GestureDockAppDataHandler';

export default function GestureDockAppDataHandlerTest() {
  describe('GestureDockAppDataHandlerTest', () => {
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

    it('GestureDockAppDataHandler_removeRecentItemInfosInResident_1', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      expect(gestureDockAppDataHandler.removeRecentItemInfosInResident() === undefined).assertTrue();
    })

    it('GestureDockAppDataHandler_removeRecentItemInfosInResident_2', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      (gestureDockAppDataHandler as object)['dockBarScrollerParam'].recentApps = [new GestureDockItemInfo(), new GestureDockItemInfo()];
      (gestureDockAppDataHandler as object)['dockBarScrollerParam'].recentApps[0].bundleName = 'abc';
      (gestureDockAppDataHandler as object)['dockBarScrollerParam'].recentApps[1].bundleName = 'abcd';
      expect(gestureDockAppDataHandler.removeRecentItemInfosInResident() === undefined).assertTrue();
    })

    it('GestureDockAppDataHandler_removeRecentItemInfosInResident_3', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      (gestureDockAppDataHandler as object)['dockBarScrollerParam'].recentApps = [new GestureDockItemInfo(), new GestureDockItemInfo()];
      (gestureDockAppDataHandler as object)['dockBarScrollerParam'].recentApps[0].bundleName = 'abc';
      (gestureDockAppDataHandler as object)['dockBarScrollerParam'].recentApps[1].appIndex = 1;
      (gestureDockAppDataHandler as object)['dockBarScrollerParam'].recentApps[1].bundleName = 'abcd';
      expect(gestureDockAppDataHandler.removeRecentItemInfosInResident() === undefined).assertTrue();
    })

    it('GestureDockAppDataHandler_removeRecentItemInfosInResident_4', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      viewDataMgr.dockBarScrollerParam.recentApps = [];
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      expect(gestureDockAppDataHandler.removeRecentItemInfosInResident() === undefined).assertTrue();
    })

    it('GestureDockAppDataHandler_removeRecentItemInfosInResident_5', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      viewDataMgr.dockBarScrollerParam.recentApps = [new GestureDockItemInfo(), new GestureDockItemInfo()];
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAppDataHandler, (gestureDockAppDataHandler as object)['isInResidentApps']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(gestureDockAppDataHandler.removeRecentItemInfosInResident() === undefined).assertTrue();
      mocker.ignoreMock(gestureDockAppDataHandler, (gestureDockAppDataHandler as object)['isInResidentApps']);
    })

    it('GestureDockAppDataHandler_isInResidentApps_1', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      let recentItemInfo = [new GestureDockItemInfo(), new GestureDockItemInfo()];
      AppStorage.setOrCreate('gestureDockList', [new GestureDockItemInfo(), new GestureDockItemInfo()]);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((gestureDockAppDataHandler as object)['isInResidentApps'](recentItemInfo) !== undefined).assertTrue();
      mocker.ignoreMock(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
    })

    it('GestureDockAppDataHandler_isInResidentApps_2', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      let recentItemInfo = [new GestureDockItemInfo(), new GestureDockItemInfo()];
      AppStorage.setOrCreate('gestureDockList', [new GestureDockItemInfo(), new GestureDockItemInfo()]);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect((gestureDockAppDataHandler as object)['isInResidentApps'](recentItemInfo) !== undefined).assertTrue();
      mocker.ignoreMock(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
    })

    it('SCBGestureDockViewModelTest_filterRecentItemInfosBySupportDockApps_1', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      viewDataMgr.dockBarScrollerParam.recentApps = [];
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      expect(gestureDockAppDataHandler.filterRecentItemInfosBySupportDockApps() === undefined).assertTrue();
    })

    it('SCBGestureDockViewModelTest_filterRecentItemInfosBySupportDockApps_2', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      let gestureDockItemInfo1 = new GestureDockItemInfo();
      let gestureDockItemInfo2 = new GestureDockItemInfo();
      let gestureDockItemInfo3 = new GestureDockItemInfo();
      viewDataMgr.dockBarScrollerParam.recentApps =
        [gestureDockItemInfo1, gestureDockItemInfo2, gestureDockItemInfo3];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([BundleManager.SupportWindowMode.FLOATING]);
      gestureDockItemInfo1.typeId = 5;
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      expect(gestureDockAppDataHandler.filterRecentItemInfosBySupportDockApps() === undefined).assertTrue();
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo);
    })

    it('SCBGestureDockViewModelTest_filterRecentItemInfosBySupportDockApps_3', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      let gestureDockItemInfo1 = new GestureDockItemInfo();
      let gestureDockItemInfo2 = new GestureDockItemInfo();
      let gestureDockItemInfo3 = new GestureDockItemInfo();
      viewDataMgr.dockBarScrollerParam.recentApps =
        [gestureDockItemInfo1, gestureDockItemInfo2, gestureDockItemInfo3];
      gestureDockItemInfo1.typeId = 7;
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      expect(gestureDockAppDataHandler.filterRecentItemInfosBySupportDockApps() === undefined).assertTrue();
    })

    it('SCBGestureDockViewModelTest_filterResidentItemInfosBySupportDockApps_1', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      AppStorage.setOrCreate('gestureDockList', []);
      expect(gestureDockAppDataHandler.filterResidentItemInfosBySupportDockApps() === undefined).assertTrue();
    })

    it('SCBGestureDockViewModelTest_filterResidentItemInfosBySupportDockApps_2', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      let gestureDockItemInfo1 = new GestureDockItemInfo();
      let gestureDockItemInfo2 = new GestureDockItemInfo();
      let gestureDockItemInfo3 = new GestureDockItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([BundleManager.SupportWindowMode.FLOATING]);
      gestureDockItemInfo1.typeId = 5;
      AppStorage.setOrCreate('gestureDockList', [gestureDockItemInfo1, gestureDockItemInfo2, gestureDockItemInfo3]);
      expect(gestureDockAppDataHandler.filterResidentItemInfosBySupportDockApps() === undefined).assertTrue();
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo);
    })

    it('SCBGestureDockViewModelTest_filterResidentItemInfosBySupportDockApps_3', Level.LEVEL0, (): void => {
      let viewDataMgr = new GestureDockBarViewDataMgr()
      let gestureDockAppDataHandler: GestureDockAppDataHandler = new GestureDockAppDataHandler(viewDataMgr);
      let gestureDockItemInfo1 = new GestureDockItemInfo();
      let gestureDockItemInfo2 = new GestureDockItemInfo();
      let gestureDockItemInfo3 = new GestureDockItemInfo();
      gestureDockItemInfo1.typeId = 7;
      gestureDockItemInfo2.typeId = 8;
      AppStorage.setOrCreate('gestureDockList', [gestureDockItemInfo1, gestureDockItemInfo2, gestureDockItemInfo3]);
      expect(gestureDockAppDataHandler.filterResidentItemInfosBySupportDockApps() === undefined).assertTrue();
    })
  })
}