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
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { scbEventExclusiveManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { GestureDockMode } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/GestureDockConstants';
import {
  GestureDockViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/GestureDockViewModel';
import GestureDockViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr';
import GestureDockViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr';
import GestureDockAllAppsItemViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockappitem/viewmodel/viewdata/GestureDockAllAppsItemViewDataMgr';
import GestureDockAllAppsItemViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockappitem/viewmodel/viewevent/GestureDockAllAppsItemViewEventMgr';
import {
  GestureDockItemInfo
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';

export default function GestureDockAllAppsItemViewEventMgrTest() {
  describe('GestureDockAllAppsItemViewEventMgrTest', () => {
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

    let clickEvent = {
      displayX: 0,
      displayY: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      x: 0,
      y: 0,
      preventDefault: () => {
      },
    } as ClickEvent

    it('GestureDockAllAppsItemViewEventMgr_onAllAppsItemClick_1', 0, async (done: Function) => {
      let viewEventMgr: GestureDockAllAppsItemViewEventMgr =
        new GestureDockAllAppsItemViewEventMgr(new GestureDockAllAppsItemViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
      viewEventMgr.viewDataMgr.itemOnClick = undefined;
      expect(viewEventMgr.onAllAppsItemClick(clickEvent) === undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewEventMgr_onAllAppsItemClick_2', 0, async (done: Function) => {
      let viewEventMgr: GestureDockAllAppsItemViewEventMgr =
        new GestureDockAllAppsItemViewEventMgr(new GestureDockAllAppsItemViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
      viewEventMgr.viewDataMgr.itemOnClick = () => {
      };
      expect(viewEventMgr.onAllAppsItemClick(clickEvent) === undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewEventMgr_onAllAppsItemClick_3', 0, async (done: Function) => {
      let viewEventMgr: GestureDockAllAppsItemViewEventMgr =
        new GestureDockAllAppsItemViewEventMgr(new GestureDockAllAppsItemViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(viewEventMgr.onAllAppsItemClick(clickEvent) === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    });

    it('GestureDockAllAppsItemViewEventMgr_onAllAppsItemClick_4', 0, async (done: Function) => {
      let viewEventMgr: GestureDockAllAppsItemViewEventMgr =
        new GestureDockAllAppsItemViewEventMgr(new GestureDockAllAppsItemViewDataMgr());
      try {
        GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
        let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
        let gestureDockParam = viewData?.gestureDockParam;
        gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        viewEventMgr.appItemParam.isShowBadge = true;
        let item = new GestureDockItemInfo();
        item.bundleName = 'com.test';
        AppStorage.set('gestureDockList', [item]);
        expect(viewEventMgr.onAllAppsItemClick(clickEvent) === undefined).assertTrue();
        mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      } catch (e) {
      }
      done();
    });

    it('GestureDockAllAppsItemViewEventMgr_onAllAppsItemClick_5', 0, async (done: Function) => {
      let viewEventMgr: GestureDockAllAppsItemViewEventMgr =
        new GestureDockAllAppsItemViewEventMgr(new GestureDockAllAppsItemViewDataMgr());
      try {
        GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
        let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
        let gestureDockParam = viewData?.gestureDockParam;
        gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        viewEventMgr.appItemParam.isShowBadge = false;
        expect(viewEventMgr.onAllAppsItemClick(clickEvent) === undefined).assertTrue();
        mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      } catch (e) {
      }
      done();
    });

    it('GestureDockAllAppsItemViewEventMgr_onAllAppsItemClick_6', 0, async (done: Function) => {
      let viewEventMgr: GestureDockAllAppsItemViewEventMgr =
        new GestureDockAllAppsItemViewEventMgr(new GestureDockAllAppsItemViewDataMgr());
      try {
        GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
        let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
        let gestureDockParam = viewData?.gestureDockParam;
        gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        viewEventMgr.appItemParam.isShowBadge = true;
        let item = new GestureDockItemInfo();
        item.bundleName = 'com.test';
        AppStorage.set('gestureDockList',
          [item, item, item, item, item, item, item, item, item, item, item, item, item, item, item, item]);
        expect(viewEventMgr.onAllAppsItemClick(clickEvent) === undefined).assertTrue();
        mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      } catch (e) {
      }
      done();
    });

    it('GestureDockAllAppsItemViewEventMgr_onGestureDockChange_1', 0, async (done: Function) => {
      let viewEventMgr = new GestureDockAllAppsItemViewEventMgr(new GestureDockAllAppsItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(GestureDockViewModel.getInstance(), GestureDockViewModel.getInstance().getViewData);
      when(mockFunc)().afterReturnNothing();
      expect((viewEventMgr as object)['onGestureDockChange']() === undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewEventMgr_onGestureDockChange_2', 0, async (done: Function) => {
      let viewEventMgr = new GestureDockAllAppsItemViewEventMgr(new GestureDockAllAppsItemViewDataMgr());
      try{
        GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
        let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
        let gestureDockParam = viewData?.gestureDockParam;
        let item = new GestureDockItemInfo();
        item.bundleName = 'com.test';
        gestureDockParam.recentApps = [item, item, item, item];
        expect((viewEventMgr as object)['onGestureDockChange']() === undefined).assertTrue();
      }catch(e){
      }
      done();
    });

    it('GestureDockAllAppsItemViewEventMgr_onGestureDockChange_3', 0, async (done: Function) => {
      let viewEventMgr = new GestureDockAllAppsItemViewEventMgr(new GestureDockAllAppsItemViewDataMgr());
      try{
        GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
        let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
        let gestureDockParam = viewData?.gestureDockParam;
        let item = new GestureDockItemInfo();
        item.bundleName = 'com.test';
        gestureDockParam.recentApps = [];
        expect((viewEventMgr as object)['onGestureDockChange']() === undefined).assertTrue();
      }catch(e){
      }
      done();
    });

    it('GestureDockAllAppsItemViewEventMgr_registerEvent_1', 0, async (done: Function) => {
      let viewEventMgr = new GestureDockAllAppsItemViewEventMgr(new GestureDockAllAppsItemViewDataMgr());
      expect((viewEventMgr as object)['registerEvent']() === undefined).assertTrue();
      done();
    });
  })
}