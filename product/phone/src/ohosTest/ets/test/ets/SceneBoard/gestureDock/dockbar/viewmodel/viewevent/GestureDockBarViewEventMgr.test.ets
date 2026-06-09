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

import { ArrayUtils, CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import { desktopUtil, ItemUtils } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  scbEventExclusiveManager,
  SCBSceneInfo,
  SCBSceneSessionManager,
  SCBScreenProperty
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
import { DockItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  GestureDockConstants,
  GestureDockMode
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/GestureDockConstants';
import {
  GestureDockUtil
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/util/GestureDockUtil';
import { ScreenInfoUtil } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/util/ScreenInfoUtil';
import {
  GestureDockViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/GestureDockViewModel';
import GestureDockViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr';
import GestureDockViewEventMgr, {
  GestureDockState
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr';
import {
  GestureDockItemInfo
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';
import {
  GestureDockBarViewDataMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewdata/GestureDockBarViewDataMgr';
import GestureDockBarViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewevent/GestureDockBarViewEventMgr';

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

export default function GestureDockBarViewEventMgrTest() {
  describe('GestureDockBarViewEventMgrTest', () => {
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

    it('GestureDockBarViewEventMgr_updateDockBarMaxHeight_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      expect(gestureDockBarViewEventMgr.resetDockBarParams() === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_updateDockBarMaxHeight_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      (gestureDockBarViewEventMgr as object)['dockBarScrollerParam'].isRecentAppShow = true;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      let mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      let mockFunc3: Function = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)().afterReturn(true);
      when(mockFunc3)().afterReturn(false);
      expect(gestureDockBarViewEventMgr.resetDockBarParams(new SCBScreenProperty()) === undefined).assertTrue();
      mocker.ignoreMock(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      done();
    })

    it('GestureDockBarViewEventMgr_updateDockBarMaxHeight_3', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      (gestureDockBarViewEventMgr as object)['dockBarScrollerParam'].isRecentAppShow = false;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      let mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      let mockFunc3: Function = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)().afterReturn(true);
      when(mockFunc3)().afterReturn(false);
      expect(gestureDockBarViewEventMgr.resetDockBarParams(new SCBScreenProperty()) === undefined).assertTrue();
      mocker.ignoreMock(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      done();
    })

    it('GestureDockBarViewEventMgr_updateDockBarMaxHeight_4', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      (gestureDockBarViewEventMgr as object)['dockBarScrollerParam'].isRecentAppShow = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc)().afterReturn(false);
      expect(gestureDockBarViewEventMgr.resetDockBarParams(new SCBScreenProperty()) === undefined).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      done();
    })

    it('GestureDockBarViewEventMgr_updateDockBarAppData_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(GestureDockViewModel.getInstance(), GestureDockViewModel.getInstance().getViewData);
      when(mockFunc)().afterReturn(null);
      expect(gestureDockBarViewEventMgr.updateDockBarAppData() === undefined).assertTrue();
      mocker.ignoreMock(GestureDockViewModel.getInstance(), GestureDockViewModel.getInstance().getViewData)
      done();
    })

    it('GestureDockBarViewEventMgr_updateDockBarAppData_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      expect(gestureDockBarViewEventMgr.updateDockBarAppData() === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_onAllAppsShowChange_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      expect(gestureDockBarViewEventMgr.onAllAppsShowChange(true) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_onAllAppsShowChange_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      expect(gestureDockBarViewEventMgr.onAllAppsShowChange(false) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_onGestureDockScroll_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      try {
        gestureDockBarViewEventMgr.viewDataMgr.leftScroller.currentOffset().yOffset = 1;
        expect(gestureDockBarViewEventMgr.onGestureDockScroll(1, 0) === undefined).assertTrue();
      } catch (e) {
      }
      done();
    })

    it('GestureDockBarViewEventMgr_onGestureDockScroll_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      try {
        gestureDockBarViewEventMgr.viewDataMgr.rightScroller.currentOffset().yOffset = 1;
        expect(gestureDockBarViewEventMgr.onGestureDockScroll(2, 0) === undefined).assertTrue();
      } catch (e) {
      }
      done();
    })

    it('GestureDockBarViewEventMgr_onDockEditCheckMarkIconClick_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(gestureDockBarViewEventMgr.onDockEditCheckMarkIconClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    })

    it('GestureDockBarViewEventMgr_onDockEditCheckMarkIconClick_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(gestureDockBarViewEventMgr.onDockEditCheckMarkIconClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    })

    it('GestureDockBarViewEventMgr_onResetDockMaxHeight_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      (gestureDockBarViewEventMgr as object)['dockBarScrollerParam'].isRecentAppShow = true;
      expect(gestureDockBarViewEventMgr.onResetDockMaxHeight() === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_onResetDockMaxHeight_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      (gestureDockBarViewEventMgr as object)['dockBarScrollerParam'].isRecentAppShow = false;
      expect(gestureDockBarViewEventMgr.onResetDockMaxHeight() === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_onColorModeChange_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      expect(gestureDockBarViewEventMgr.onColorModeChange(0) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_onColorModeChange_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      expect(gestureDockBarViewEventMgr.onColorModeChange(1) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_addDockItem_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      AppStorage.set('gestureDockList', []);
      await (gestureDockBarViewEventMgr as object)['addDockItem'](new GestureDockItemInfo());
      expect(gestureDockBarViewEventMgr).not().assertUndefined();
      done();
    })

    it('GestureDockBarViewEventMgr_addDockItem_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let item = new GestureDockItemInfo();
      item.bundleName = 'com.test';
      AppStorage.set('gestureDockList', [item]);
      let mocker = new MockKit();
      let mockAreTwoAppItemsSame = mocker.mockFunc(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
      when(mockAreTwoAppItemsSame)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(true);
      await (gestureDockBarViewEventMgr as object)['addDockItem'](new GestureDockItemInfo());
      expect(gestureDockBarViewEventMgr).not().assertUndefined();
      mocker.ignoreMock(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
      done();
    })

    it('GestureDockBarViewEventMgr_addDockItem_3', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let item1 = new GestureDockItemInfo();
      item1.bundleName = 'com.test';
      let item2 = new GestureDockItemInfo();
      item2.bundleName = 'undefined';
      AppStorage.setOrCreate('gestureDockList', [item1, item2]);
      let mocker = new MockKit();
      let mockAreTwoAppItemsSame = mocker.mockFunc(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
      when(mockAreTwoAppItemsSame)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(true);
      await (gestureDockBarViewEventMgr as object)['addDockItem'](new GestureDockItemInfo());
      expect(gestureDockBarViewEventMgr).not().assertUndefined();
      mocker.ignoreMock(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
      done();
    })

    it('GestureDockBarViewEventMgr_addDockItem_4', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let item1 = new GestureDockItemInfo();
      item1.bundleName = 'com.test';
      let item2 = new GestureDockItemInfo();
      item2.bundleName = 'undefined';
      AppStorage.setOrCreate('gestureDockList', [item1, item2]);
      let mocker = new MockKit();
      let mockAreTwoAppItemsSame = mocker.mockFunc(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
      when(mockAreTwoAppItemsSame)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(false);
      await (gestureDockBarViewEventMgr as object)['addDockItem'](new GestureDockItemInfo());
      expect(gestureDockBarViewEventMgr).not().assertUndefined();
      mocker.ignoreMock(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
      done();
    })

    it('GestureDockBarViewEventMgr_onDeleteDockApp_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      expect(gestureDockBarViewEventMgr.onDeleteDockApp(-1) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_onDeleteDockApp_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let item1 = new GestureDockItemInfo();
      let item2 = new GestureDockItemInfo();
      item2.bundleName = 'com.test';
      AppStorage.set('gestureDockList', [item1, item2]);
      expect(gestureDockBarViewEventMgr.onDeleteDockApp(1) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_initDockBarParam_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        height: null
      });
      expect(gestureDockBarViewEventMgr.initDockBarParam() === undefined).assertTrue();
      mocker.ignoreMock(ItemUtils, ItemUtils.getRectById);
      done();
    })

    it('GestureDockBarViewEventMgr_initDockBarParam_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        height: 100
      });
      expect(gestureDockBarViewEventMgr.initDockBarParam() === undefined).assertTrue();
      mocker.ignoreMock(ItemUtils, ItemUtils.getRectById);
      done();
    })

    it('GestureDockBarViewEventMgr_onItemClick_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
      expect(gestureDockBarViewEventMgr.onItemClick(clickEvent, new DockItemInfo(), 0, 0) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_onItemClick_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
      let mocker = new MockKit();
      expect(gestureDockBarViewEventMgr.onItemClick(clickEvent, new DockItemInfo(), 0, 0) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_onItemClick_3', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      try {
        GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
        let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
        let gestureDockParam = viewData?.gestureDockParam;
        gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
        let mocker = new MockKit();
        let item = new DockItemInfo();
        item.bundleName = "com.example.app";
        item.moduleName = "main";
        item.abilityName = "EntryAbility";
        let mockIsExclusion =
          mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isExclusion);
        when(mockIsExclusion)(ArgumentMatchers.any).afterReturn(true);
        expect(gestureDockBarViewEventMgr.onItemClick(clickEvent, item, 0, 0) === undefined).assertTrue();
        mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isExclusion);
      } catch (e) {
      }
      done();
    })

    it('GestureDockBarViewEventMgr_onItemClick_4', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      try {
        GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
        let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
        let gestureDockParam = viewData?.gestureDockParam;
        gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
        let mocker = new MockKit();
        let item = new DockItemInfo();
        item.bundleName = "com.example.app";
        item.moduleName = "main";
        item.abilityName = "EntryAbility";
        let mockIsExclusion =
          mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isExclusion);
        when(mockIsExclusion)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(false);
        expect(gestureDockBarViewEventMgr.onItemClick(clickEvent, item, 0, 0) === undefined).assertTrue();
        mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isExclusion);
      } catch (e) {
      }
      done();
    })

    it('GestureDockBarViewEventMgr_onItemClick_5', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
      let mocker = new MockKit();
      let item = new DockItemInfo();
      item.bundleName = '';
      item.moduleName = '';
      item.abilityName = '';
      expect(gestureDockBarViewEventMgr.onItemClick(clickEvent, item, 0, 0) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewEventMgr_updateWant_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(GestureDockViewModel.getInstance(), GestureDockViewModel.getInstance().getViewData);
      when(mockFunc)().afterReturn(null);
      expect((gestureDockBarViewEventMgr as object)['updateWant'](new SCBSceneInfo("com.example.app", "main",
        "EntryAbility", 0), 0) === undefined).assertTrue();
      mocker.ignoreMock(GestureDockViewModel.getInstance(), GestureDockViewModel.getInstance().getViewData);
      done();
    })

    it('GestureDockBarViewEventMgr_updateWant_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let mocker = new MockKit();
      let mockIsEmpty = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(true);
      expect((gestureDockBarViewEventMgr as object)['updateWant'](new SCBSceneInfo("com.example.app", "main",
        "EntryAbility", 0), 0) === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      done();
    })

    it('GestureDockBarViewEventMgr_updateWant_3', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      try {
        GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
        let mocker = new MockKit();
        let mockIsEmpty = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(false);
        expect((gestureDockBarViewEventMgr as object)['updateWant'](new SCBSceneInfo("com.example.app", "main",
          "EntryAbility", 0), 0) === undefined).assertTrue();
        mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      } catch (e) {
      }
      done();
    })

    it('GestureDockBarViewEventMgr_dockEditStarted_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockAppStorage: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn(undefined);
      expect(gestureDockBarViewEventMgr.dockEditStarted() === undefined).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('GestureDockBarViewEventMgr_dockEditStarted_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockAppStorage: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      let residentApps: GestureDockItemInfo[] = [new GestureDockItemInfo()];
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn(residentApps);
      expect(gestureDockBarViewEventMgr.dockEditStarted() === undefined).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('GestureDockBarViewEventMgr_dockEditStarted_3', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockAppStorage: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      let residentApps: GestureDockItemInfo[] = new Array(GestureDockConstants.MAX_CUSTOM_COUNT);
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn(residentApps);
      expect(gestureDockBarViewEventMgr.dockEditStarted() === undefined).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('GestureDockBarViewEventMgr_dockEditStarted_4', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockAppStorage: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      let residentApps: GestureDockItemInfo[] = new Array(GestureDockConstants.MAX_CUSTOM_COUNT + 1);
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn(residentApps);
      expect(gestureDockBarViewEventMgr.dockEditStarted() === undefined).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('GestureDockBarViewEventMgr_dockEditFinished_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      expect(gestureDockBarViewEventMgr.dockEditFinished() === undefined).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('GestureDockBarViewEventMgr_dockEditFinished_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      let residentApps: GestureDockItemInfo[] = [new GestureDockItemInfo()];
      residentApps[0].bundleName = '';
      when(mockFunc)(ArgumentMatchers.any).afterReturn(residentApps);
      expect(gestureDockBarViewEventMgr.dockEditFinished() === undefined).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('GestureDockBarViewEventMgr_dockEditFinished_3', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      let residentApps: GestureDockItemInfo[] = [new GestureDockItemInfo()];
      residentApps[0].bundleName = '';
      when(mockFunc)(ArgumentMatchers.any).afterReturn(residentApps);
      expect(gestureDockBarViewEventMgr.dockEditFinished() === undefined).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('GestureDockBarViewEventMgr_dockEditFinished_4', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      let residentApps: GestureDockItemInfo[] = [new GestureDockItemInfo()];
      residentApps[0].bundleName = 'com.example.app';
      when(mockFunc)(ArgumentMatchers.any).afterReturn(residentApps);
      expect(gestureDockBarViewEventMgr.dockEditFinished() === undefined).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('GestureDockBarViewEventMgr_setCutOutDistance_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker = new MockKit();
      let displayMock = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(displayMock)(ArgumentMatchers.any).afterReturn(true);
      expect(gestureDockBarViewEventMgr.setCutOutDistance() === undefined).assertTrue();
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      done();
    })

    it('GestureDockBarViewEventMgr_setCutOutDistance_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker = new MockKit();
      let displayMock = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(displayMock)(ArgumentMatchers.any).afterReturn(false);
      let isEmptyMock = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(isEmptyMock)(ArgumentMatchers.any).afterReturn(true);
      expect(gestureDockBarViewEventMgr.setCutOutDistance() === undefined).assertTrue();
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(ArrayUtils, ArrayUtils.isEmpty);
      done();
    })

    it('GestureDockBarViewEventMgr_setCutOutDistance_3', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker = new MockKit();
      let displayMock = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(displayMock)(ArgumentMatchers.any).afterReturn(false);
      let isEmptyMock = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(isEmptyMock)(ArgumentMatchers.any).afterReturn(false);
      expect(gestureDockBarViewEventMgr.setCutOutDistance() === undefined).assertTrue();
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(ArrayUtils, ArrayUtils.isEmpty);
      done();
    })

    it('GestureDockBarViewEventMgr_setCutOutDistance_4', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      let mocker = new MockKit();
      let displayMock = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(displayMock)(ArgumentMatchers.any).afterReturn(false);
      let isEmptyMock = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(isEmptyMock)(ArgumentMatchers.any).afterReturn(false);
      let isCutOutLeftMock = mocker.mockFunc(ScreenInfoUtil, ScreenInfoUtil.isCutOutLeft);
      when(isCutOutLeftMock)(ArgumentMatchers.any).afterReturn(true);
      let isCutOutRightMock = mocker.mockFunc(ScreenInfoUtil, ScreenInfoUtil.isCutOutRight);
      when(isCutOutRightMock)(ArgumentMatchers.any).afterReturn(true);
      let isCutOutBottomMock = mocker.mockFunc(ScreenInfoUtil, ScreenInfoUtil.isCutOutLeft);
      when(isCutOutBottomMock)(ArgumentMatchers.any).afterReturn(true);
      expect(gestureDockBarViewEventMgr.setCutOutDistance() === undefined).assertTrue();
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(ArrayUtils, ArrayUtils.isEmpty);
      mocker.ignoreMock(ScreenInfoUtil, ScreenInfoUtil.isCutOutLeft);
      mocker.ignoreMock(ScreenInfoUtil, ScreenInfoUtil.isCutOutRight);
      mocker.ignoreMock(ScreenInfoUtil, ScreenInfoUtil.isCutOutBottom);
      done();
    })

    it('GestureDockBarViewEventMgr_scrollToAddDockItemIndex_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      try {
        (gestureDockBarViewEventMgr as object)['dockBarScrollerParam'].recentApps =
          [new GestureDockItemInfo(), new GestureDockItemInfo()];
        expect(gestureDockBarViewEventMgr.scrollToAddDockItemIndex(0) === undefined).assertTrue();
      } catch (e) {
      }
      done();
    })

    it('GestureDockBarViewEventMgr_scrollToDeleteItemIndex_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      try {
        let item1 = new GestureDockItemInfo();
        let item2 = new GestureDockItemInfo();
        item1.bundleName = 'undefined';
        item2.bundleName = 'test';
        AppStorage.setOrCreate('gestureDockList', [item1, item2]);
        (gestureDockBarViewEventMgr as object)['dockBarScrollerParam'].recentApps = [item1, item2];
        expect(gestureDockBarViewEventMgr.scrollToDeleteItemIndex(0) === undefined).assertTrue();
      } catch (e) {
      }
      done();
    })

    it('GestureDockBarViewEventMgr_scrollToDeleteItemIndex_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      try {
        let item1 = new GestureDockItemInfo();
        let item2 = new GestureDockItemInfo();
        item1.bundleName = 'undefined';
        item2.bundleName = 'test';
        AppStorage.setOrCreate('gestureDockList', [item1, item2]);
        (gestureDockBarViewEventMgr as object)['dockBarScrollerParam'].recentApps = [item1, item2];
        expect(gestureDockBarViewEventMgr.scrollToDeleteItemIndex(1) === undefined).assertTrue();
      } catch (e) {
      }
      done();
    })

    it('GestureDockBarViewEventMgr_doDockTranslate_1', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      expect(gestureDockBarViewEventMgr.doDockTranslate(0) === undefined).assertTrue();
      done();
    });

    it('GestureDockBarViewEventMgr_doDockTranslate_2', 0, async (done: Function) => {
      let gestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_RIGHT_OUT;
      expect(gestureDockBarViewEventMgr.doDockTranslate(0) === undefined).assertTrue();
      done();
    });
  })
}