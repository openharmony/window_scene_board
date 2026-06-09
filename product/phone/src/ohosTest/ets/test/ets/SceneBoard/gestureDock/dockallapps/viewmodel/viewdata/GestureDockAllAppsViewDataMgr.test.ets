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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import { ScreenInfoUtil } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/util/ScreenInfoUtil';
import {
  GestureDockViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/GestureDockViewModel';
import GestureDockViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr';
import GestureDockViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr';
import {
  AllAppsConstants
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/model/AllAppsConstants';
import GestureDockAllAppsViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewdata/GestureDockAllAppsViewDataMgr';

export default function GestureDockAllAppsViewDataMgrTest() {
  describe('GestureDockAllAppsViewDataMgrTest', () => {
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

    it('GestureDockAllAppsViewDataMgr_getSearchBoxWidth_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let viewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mockFunc: Function = mocker.mockFunc(viewDataMgr, viewDataMgr.getAllAppsContentWidth);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(100);
      const result = viewDataMgr.getSearchBoxWidth(1000);
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(viewDataMgr, viewDataMgr.getAllAppsContentWidth);
      done();
    });

    it('GestureDockAllAppsViewDataMgr_getSearchBoxWidth_2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let viewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mockFunc: Function = mocker.mockFunc(viewDataMgr, viewDataMgr.getAllAppsContentWidth);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(200);
      const result = viewDataMgr.getSearchBoxWidth(1000);
      expect(result).assertEqual(AllAppsConstants.ALL_APPS_SEARCH_BOX_WIDTH);
      mocker.ignoreMock(viewDataMgr, viewDataMgr.getAllAppsContentWidth);
      done();
    });

    it('GestureDockAllAppsViewDataMgr_getAllAppsContentWidth_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let viewModel: GestureDockViewModel = GestureDockViewModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(viewModel, viewModel.getViewData);
      when(mockFunc)().afterReturn(null);
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      const result = gestureDockAllAppsViewDataMgr.getAllAppsContentWidth(100);
      expect(result).assertEqual(0);
      mocker.ignoreMock(viewModel, viewModel.getViewData);
      done();
    });

    it('GestureDockAllAppsViewDataMgr_getAllAppsContentWidth_2', 0, async (done: Function) => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      const result = gestureDockAllAppsViewDataMgr.getAllAppsContentWidth(100);
      expect(result !== undefined).assertTrue();
      done();
    });

    // item4Width = 57 * 4 = 228
    it('GestureDockAllAppsViewDataMgr_getColumnGutter_1', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(30);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_2', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(300);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);

    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_3', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(800);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_4', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy1', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy2', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy3', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy4', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy5', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy6', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy7', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy8', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy9', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy10', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy11', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy12', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy13', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy14', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy15', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy16', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy17', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy18', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy19', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy20', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy21', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy22', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy23', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy24', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy25', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy26', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy27', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy28', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy29', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })

    it('GestureDockAllAppsViewDataMgr_getColumnGutter_copy30', 0, (): void => {
      let gestureDockAllAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      let mockIsFoldExpandedOrPad = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockIsLandscapeStatus = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockIsFoldExpandedOrPad)().afterReturn(false);
      when(mockIsLandscapeStatus)().afterReturn(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(450);
      expect(gestureDockAllAppsViewDataMgr.getColumnGutter(1) !== undefined).assertTrue();
      mocker.ignoreMock(gestureDockAllAppsViewDataMgr, gestureDockAllAppsViewDataMgr.getAllAppsContentWidth);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    })
  })
}