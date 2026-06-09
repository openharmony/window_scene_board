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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { IconResourceManager } from '@ohos/frameworkwrapper';
import {
  scbEventExclusiveManager,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  ScenePanelState,
} from '@ohos/windowscene';

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  GestureDockViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/GestureDockViewModel';
import GestureDockViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr';
import GestureDockViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr';
import GestureDockAllAppsViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewdata/GestureDockAllAppsViewDataMgr';
import GestureDockAllAppsViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewevent/GestureDockAllAppsViewEventMgr';
import {
  GestureDockItemInfo
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';
import {
  GestureDockMode
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/GestureDockConstants';
import { AppItemInfo } from '@ohos/bigfolder';
import BundleManager from '@ohos.bundle.bundleManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  GestureDockBarViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/GestureDockBarViewModel';

let eventArea: Area = {
  width: 0,
  height: 0,
  position: {
    x: 0, y: 0
  },
  globalPosition: {
    x: 0, y: 0
  }
};
let eventTarget: EventTarget = {
  area: eventArea
};
let clickEvent: ClickEvent = {
  target: eventTarget,
  timestamp: 0,
  source: 0,
  pressure: 0,
  tiltX: 0,
  tiltY: 0,
  sourceTool: 0,
  displayX: 0,
  displayY: 0,
  windowX: 0,
  windowY: 0,
  screenX: 0,
  screenY: 0,
  x: 0,
  y: 0,
  preventDefault: () => {
  }
};

let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
let primarySession: SCBSceneSession =
  new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
let screenProperty: SCBScreenProperty = new SCBScreenProperty();
let sceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);

export default function GestureDockAllAppsViewEventMgrTest() {
  describe('GestureDockAllAppsViewEventMgrTest', () => {
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


    it('GestureDockAllAppsViewEventMgr_aboutToAppear_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAllAppsViewDataMgr();
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(viewDataMgr);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      gestureDockAllAppsViewEventMgr.allAppsParam.recentAllApps =
        [new GestureDockItemInfo(), new GestureDockItemInfo(), new GestureDockItemInfo()];
      expect(gestureDockAllAppsViewEventMgr.aboutToAppear(screenProperty) === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_aboutToAppear_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAllAppsViewDataMgr();
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(viewDataMgr);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      gestureDockAllAppsViewEventMgr.allAppsParam.recentAllApps = [];
      expect(gestureDockAllAppsViewEventMgr.aboutToAppear(screenProperty) === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_aboutToAppear_3', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAllAppsViewDataMgr();
      viewDataMgr.allAppsParam.recentAllApps = [new GestureDockItemInfo(), new GestureDockItemInfo()];
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(viewDataMgr);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      expect(gestureDockAllAppsViewEventMgr.aboutToAppear(screenProperty) === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_resetAllAppsParam_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAllAppsViewDataMgr();
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(viewDataMgr);
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      expect(gestureDockAllAppsViewEventMgr.resetAllAppsParam() === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_initStyleConfig_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 1000;
      screenProperty.height = 2000;
      let mocker = new MockKit();
      let viewDataMgrMock = mocker.mockFunc(gestureDockAllAppsViewEventMgr.viewDataMgr,
        gestureDockAllAppsViewEventMgr.viewDataMgr.getAllAppsContentWidth);
      let getSearchBoxWidthMock = mocker.mockFunc(gestureDockAllAppsViewEventMgr.viewDataMgr,
        gestureDockAllAppsViewEventMgr.viewDataMgr.getSearchBoxWidth);
      when(viewDataMgrMock)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(500);
      when(getSearchBoxWidthMock)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(200);
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      expect(gestureDockAllAppsViewEventMgr.initStyleConfig(screenProperty) === undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewEventMgr.viewDataMgr,
        gestureDockAllAppsViewEventMgr.viewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(gestureDockAllAppsViewEventMgr.viewDataMgr,
        gestureDockAllAppsViewEventMgr.viewDataMgr.getSearchBoxWidth);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_initStyleConfig_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 1000;
      screenProperty.height = 2000;
      let mocker = new MockKit();
      let viewDataMgrMock = mocker.mockFunc(gestureDockAllAppsViewEventMgr.viewDataMgr,
        gestureDockAllAppsViewEventMgr.viewDataMgr.getAllAppsContentWidth);
      let getSearchBoxWidthMock = mocker.mockFunc(gestureDockAllAppsViewEventMgr.viewDataMgr,
        gestureDockAllAppsViewEventMgr.viewDataMgr.getSearchBoxWidth);
      when(viewDataMgrMock)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(1000);
      when(getSearchBoxWidthMock)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(200);
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      expect(gestureDockAllAppsViewEventMgr.initStyleConfig(screenProperty) === undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewEventMgr.viewDataMgr,
        gestureDockAllAppsViewEventMgr.viewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(gestureDockAllAppsViewEventMgr.viewDataMgr,
        gestureDockAllAppsViewEventMgr.viewDataMgr.getSearchBoxWidth);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_initStyleConfig_3', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 1000;
      screenProperty.height = 2000;
      let mocker = new MockKit();
      let dockBarViewDataMock = mocker.mockFunc(GestureDockBarViewModel.getInstance(),
        GestureDockBarViewModel.getInstance().getViewData);
      when(dockBarViewDataMock)().afterReturn(null);
      expect(gestureDockAllAppsViewEventMgr.initStyleConfig(screenProperty) === undefined).assertTrue();
      mocker.ignoreMock(GestureDockBarViewModel.getInstance(),
        GestureDockBarViewModel.getInstance().getViewData);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_releaseAllAppsBlurImage_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      gestureDockAllAppsViewEventMgr.allAppsParam.blurImage = undefined;
      expect(gestureDockAllAppsViewEventMgr.releaseAllAppsBlurImage() === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_releaseAllAppsBlurImage_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      expect(gestureDockAllAppsViewEventMgr.releaseAllAppsBlurImage() === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onSearchBoxClick_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(gestureDockAllAppsViewEventMgr.onSearchBoxClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onSearchBoxClick_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(gestureDockAllAppsViewEventMgr.onSearchBoxClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onSearchTextChange_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      gestureDockAllAppsViewEventMgr.allAppsParam.searchText = 'test';
      expect(gestureDockAllAppsViewEventMgr.onSearchTextChange('test') === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onSearchTextChange_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      gestureDockAllAppsViewEventMgr.allAppsParam.searchText = '2';
      expect(gestureDockAllAppsViewEventMgr.onSearchTextChange('1') === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_search_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      expect((gestureDockAllAppsViewEventMgr as object)['search'](null) === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_search_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      expect((gestureDockAllAppsViewEventMgr as object)['search']('test') === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onSearchResultListAppear_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
      expect(gestureDockAllAppsViewEventMgr.onSearchResultListAppear() === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onSearchResultListAppear_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
      expect(gestureDockAllAppsViewEventMgr.onSearchResultListAppear() === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onArrowLeftClick_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockScbEventExclusiveManager =
        mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockScbEventExclusiveManager)(ArgumentMatchers.any).afterReturn(true);
      expect(gestureDockAllAppsViewEventMgr.onArrowLeftClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onArrowLeftClick_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockScbEventExclusiveManager =
        mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockScbEventExclusiveManager)(ArgumentMatchers.any).afterReturn(false);
      gestureDockAllAppsViewEventMgr.allAppsParam.searchBoxFocusable = true;
      expect(gestureDockAllAppsViewEventMgr.onArrowLeftClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onArrowLeftClick_3', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockScbEventExclusiveManager =
        mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockScbEventExclusiveManager)(ArgumentMatchers.any).afterReturn(false);
      gestureDockAllAppsViewEventMgr.allAppsParam.searchBoxFocusable = false;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
      expect(gestureDockAllAppsViewEventMgr.onArrowLeftClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onArrowLeftClick_4', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockScbEventExclusiveManager =
        mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockScbEventExclusiveManager)(ArgumentMatchers.any).afterReturn(false);
      gestureDockAllAppsViewEventMgr.allAppsParam.searchBoxFocusable = false;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
      gestureDockAllAppsViewEventMgr.allAppsParam.isShowSearchResult = true;
      expect(gestureDockAllAppsViewEventMgr.onArrowLeftClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onArrowLeftClick_5', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockScbEventExclusiveManager =
        mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockScbEventExclusiveManager)(ArgumentMatchers.any).afterReturn(false);
      gestureDockAllAppsViewEventMgr.allAppsParam.searchBoxFocusable = false;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
      gestureDockAllAppsViewEventMgr.allAppsParam.isShowSearchResult = false;
      expect(gestureDockAllAppsViewEventMgr.onArrowLeftClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onArrowLeftClick_6', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockScbEventExclusiveManager =
        mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockScbEventExclusiveManager)(ArgumentMatchers.any).afterReturn(false);
      gestureDockAllAppsViewEventMgr.allAppsParam.searchBoxFocusable = false;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.INVISIBLE;
      gestureDockAllAppsViewEventMgr.allAppsParam.isShowSearchResult = false;
      expect(gestureDockAllAppsViewEventMgr.onArrowLeftClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onAppItemClick_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      expect(gestureDockAllAppsViewEventMgr.onAppItemClick(clickEvent, new GestureDockItemInfo(), 11) === undefined)
        .assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onAppItemClick_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let item = new GestureDockItemInfo();
      item.bundleName = "com.example.app";
      item.moduleName = "main";
      item.abilityName = "EntryAbility";
      let mocker: MockKit = new MockKit();
      expect(gestureDockAllAppsViewEventMgr.onAppItemClick(clickEvent, item, 11) === undefined)
        .assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onAppItemClick_3', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let item = new GestureDockItemInfo();
      item.bundleName = "com.example.app";
      item.moduleName = "main";
      item.abilityName = "EntryAbility";
      let mocker: MockKit = new MockKit();
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      expect(gestureDockAllAppsViewEventMgr.onAppItemClick(clickEvent, item, 11) === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onAppItemClick_4', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      try {
        let item = new GestureDockItemInfo();
        item.bundleName = '';
        item.moduleName = '';
        item.abilityName = '';
        let mocker: MockKit = new MockKit();
        GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
        expect(gestureDockAllAppsViewEventMgr.onAppItemClick(clickEvent, item, 11) === undefined).assertTrue();
      } catch (e) {
      }
      done();
    })

    it('GestureDockAllAppsViewEventMgr_updateWant_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockDockViewData =
        mocker.mockFunc(GestureDockViewModel.getInstance(), GestureDockViewModel.getInstance().getViewData);
      when(mockDockViewData)().afterReturn(null);
      expect((gestureDockAllAppsViewEventMgr as object)['updateWant'](new SCBSceneInfo('com.example.app', 'main',
        'EntryAbility'), 11) === undefined).assertTrue();
      mocker.ignoreMock(GestureDockViewModel.getInstance(), GestureDockViewModel.getInstance().getViewData);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_updateWant_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      expect((gestureDockAllAppsViewEventMgr as object)['updateWant'](new SCBSceneInfo('com.example.app', 'main',
        'EntryAbility'), 11) === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_updateWant_3', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let mocker: MockKit = new MockKit();
      let mockIsEmpty = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(true);
      expect((gestureDockAllAppsViewEventMgr as object)['updateWant'](new SCBSceneInfo('com.example.app', 'main',
        'EntryAbility'), 11) === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_updateWant_4', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      try {
        GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
        let mocker: MockKit = new MockKit();
        let mockIsEmpty = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(false);
        expect((gestureDockAllAppsViewEventMgr as object)['updateWant'](new SCBSceneInfo('com.example.app', 'main',
          'EntryAbility'), 11) === undefined).assertTrue();
        mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      } catch (e) {
      }
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onAllAppsShowChange_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      expect(gestureDockAllAppsViewEventMgr.onAllAppsShowChange(true) === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onAllAppsShowChange_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      expect(gestureDockAllAppsViewEventMgr.onAllAppsShowChange(false) === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onAllAppsGridAppear_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.INVISIBLE;
      expect(gestureDockAllAppsViewEventMgr.onAllAppsGridAppear() === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onAllAppsGridAppear_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
      expect(gestureDockAllAppsViewEventMgr.onAllAppsGridAppear() === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_initSupportFloatWindowList_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let appList: AppItemInfo[] = [];
      appList[0] = {
        abilityName: 'AppModel1',
        appName: 'AppModelName1',
        appIconId: 1,
        bundleName: 'com.ohos.appModel1',
        moduleName: 'moduleName1'
      };
      appList[1] = {
        abilityName: 'AppModel2',
        appName: 'AppModelName2',
        appIconId: 2,
        bundleName: 'com.ohos.appModel2',
        moduleName: 'moduleName3'
      };
      appList[2] = {
        abilityName: 'AppModel3',
        appName: 'AppModelName3',
        appIconId: 3,
        bundleName: 'com.ohos.appModel3',
        moduleName: 'moduleName3'
      };
      (gestureDockAllAppsViewEventMgr as object)['mAppModel'].setAppListAsync([appList]);
      let queryKey = appList[0].bundleName + appList[0].moduleName + appList[0].abilityName;
      let mocker: MockKit = new MockKit();
      let mockSupportModes = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo);
      when(mockSupportModes)(queryKey).afterReturn([BundleManager.SupportWindowMode.FLOATING]);
      expect((gestureDockAllAppsViewEventMgr as object)['initSupportFloatWindowList']() === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_updateAppNameFromCache_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let floatWindowAppsList: GestureDockItemInfo[] = [new GestureDockItemInfo()];
      let mocker: MockKit = new MockKit();
      let mockGetCachedIconNameSync: Function =
        mocker.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCachedIconNameSync);
      when(mockGetCachedIconNameSync)(ArgumentMatchers.any).afterReturn('CachedAppName');
      expect((gestureDockAllAppsViewEventMgr as object)['updateAppNameFromCache'](floatWindowAppsList) !== undefined)
        .assertTrue();
      mocker.ignoreMock(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCachedIconNameSync);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_updateAppNameFromCache_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let floatWindowAppsList: GestureDockItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      let mockGetCachedIconNameSync: Function =
        mocker.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCachedIconNameSync);
      when(mockGetCachedIconNameSync)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any])
        .afterReturn(null);
      expect((gestureDockAllAppsViewEventMgr as object)['updateAppNameFromCache'](floatWindowAppsList) !== undefined)
        .assertTrue();
      mocker.ignoreMock(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCachedIconNameSync);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_updateAppNameFromCache_3', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let floatWindowAppsList: GestureDockItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      let mockGetCachedIconNameSync: Function =
        mocker.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCachedIconNameSync);
      when(mockGetCachedIconNameSync)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any])
        .afterThrow('Cache update error');
      expect((gestureDockAllAppsViewEventMgr as object)['updateAppNameFromCache'](floatWindowAppsList) !== undefined)
        .assertTrue();
      mocker.ignoreMock(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCachedIconNameSync);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_isAllAppsAnimateFinish_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      gestureDockAllAppsViewEventMgr.allAppsParam.searchBoxFocusable = true;
      expect(gestureDockAllAppsViewEventMgr.isAllAppsAnimateFinish() !== undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_isAllAppsAnimateFinish_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      gestureDockAllAppsViewEventMgr.allAppsParam.searchBoxFocusable = false;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.isShowAllApps = true;
      expect(gestureDockAllAppsViewEventMgr.isAllAppsAnimateFinish() !== undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_isAllAppsAnimateFinish_3', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      gestureDockAllAppsViewEventMgr.allAppsParam.searchBoxFocusable = false;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.isShowAllApps = false;
      expect(gestureDockAllAppsViewEventMgr.isAllAppsAnimateFinish() !== undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_initRecentAllApps_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      expect((gestureDockAllAppsViewEventMgr as object)['initRecentAllApps'](10) === undefined).assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_initRecentAllApps_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(GestureDockViewModel.getInstance(), GestureDockViewModel.getInstance().getViewData);
      when(mockFunc)().afterReturn(null);
      expect((gestureDockAllAppsViewEventMgr as object)['initRecentAllApps'](10) === undefined).assertTrue();
      mocker.ignoreMock(GestureDockViewModel.getInstance(), GestureDockViewModel.getInstance().getViewData);
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onGrayAllAppsAppIconCallBack_1', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      AppStorage.set<number>('scenePanelState', ScenePanelState.RECENT);
      expect(gestureDockAllAppsViewEventMgr.onGrayAllAppsAppIconCallBack(sceneContainerSession, true) === undefined)
        .assertTrue();
      done();
    })

    it('GestureDockAllAppsViewEventMgr_onGrayAllAppsAppIconCallBack_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr());
      AppStorage.set<number>('scenePanelState', ScenePanelState.FULLSCENE);
      let item1 = new GestureDockItemInfo();
      let item2 = new GestureDockItemInfo();
      item1.bundleName = 'test';
      item1.appIndex = 0;
      gestureDockAllAppsViewEventMgr.allAppsParam.recentAllApps = [item1, item2];
      if (sceneContainerSession.primarySession) {
        sceneContainerSession.primarySession.sceneInfo.bundleName = 'test';
        sceneContainerSession.primarySession.sceneInfo.appIndex = 0;
        sceneContainerSession.primarySession.sceneInfo.persistentId = 1;
      }
      if (sceneContainerSession.secondarySession) {
        sceneContainerSession.secondarySession.sceneInfo.bundleName = 'test';
        sceneContainerSession.secondarySession.sceneInfo.appIndex = 0;
        sceneContainerSession.secondarySession.sceneInfo.persistentId = 1;
      }
      let item3 = new GestureDockItemInfo();
      let item4 = new GestureDockItemInfo();
      item3.bundleName = 'test';
      item4.appIndex = 0;
      gestureDockAllAppsViewEventMgr.allAppsParam.supportFloatWindowList = [item3, item4];
      if (sceneContainerSession.primarySession) {
        sceneContainerSession.primarySession.sceneInfo.bundleName = 'test';
        sceneContainerSession.primarySession.sceneInfo.appIndex = 0;
        sceneContainerSession.primarySession.sceneInfo.persistentId = 1;
      }
      if (sceneContainerSession.secondarySession) {
        sceneContainerSession.secondarySession.sceneInfo.bundleName = 'test';
        sceneContainerSession.secondarySession.sceneInfo.appIndex = 0;
        sceneContainerSession.secondarySession.sceneInfo.persistentId = 1;
      }
      expect(gestureDockAllAppsViewEventMgr.onGrayAllAppsAppIconCallBack(sceneContainerSession, true) === undefined)
        .assertTrue();
      done();
    })
  })
}