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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, MockKit, when } from '@ohos/hypium';
import GestureDockViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr';
import {
  GestureDockViewParam,
  SCBGestureDockParam
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockParam';
import { RTLUtil } from '@ohos/componenthelper';
import {
  GestureDockBarViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/GestureDockBarViewModel';
import GestureDockBarViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewevent/GestureDockBarViewEventMgr';
import {
  GestureDockBarViewDataMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewdata/GestureDockBarViewDataMgr';

let gestureDockViewDataMgr: GestureDockViewDataMgr = new GestureDockViewDataMgr();
let dockBarViewModel: GestureDockBarViewModel = GestureDockBarViewModel.getInstance();
let gestureDockParam: GestureDockViewParam;
let scbGestureDockParam: SCBGestureDockParam;

export default function GestureDockViewDataMgrTest() {
  describe('GestureDockViewDataMgrTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      GestureDockBarViewModel.getInstance()
        .initViewModel(new GestureDockBarViewEventMgr(new GestureDockBarViewDataMgr()));
      gestureDockParam = new GestureDockViewParam();
      scbGestureDockParam = SCBGestureDockParam.getInstance();
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

    it('GestureDockViewDataMgr_getRecentApps_1', Level.LEVEL0, (): void => {
      gestureDockViewDataMgr.getRecentApps();
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_getDockApps_1', Level.LEVEL0, (): void => {
      gestureDockViewDataMgr.getDockApps();
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_getGestureDockDirection_1', Level.LEVEL0, (): void => {
      gestureDockViewDataMgr.getGestureDockDirection();
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_isGestureDockShow_1', Level.LEVEL0, (): void => {
      gestureDockViewDataMgr.isGestureDockShow();
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_isShowAllApps_1', Level.LEVEL0, (): void => {
      gestureDockViewDataMgr.isShowAllApps();
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_getGestureDockShowMode_1', Level.LEVEL0, (): void => {
      gestureDockViewDataMgr.getGestureDockShowMode();
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_getDividerPositionX_1', Level.LEVEL0, (): void => {
      gestureDockViewDataMgr.gestureDockParam.gestureDockDirection = 1;
      let screenPropertyWidth: number = 50;
      gestureDockViewDataMgr.getDividerPositionX(screenPropertyWidth);
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_getDividerPositionX_2', Level.LEVEL0, (): void => {
      gestureDockViewDataMgr.gestureDockParam.gestureDockDirection = 0;
      let screenPropertyWidth: number = 50;
      gestureDockViewDataMgr.getDividerPositionX(screenPropertyWidth);
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_getDockWidth_1', Level.LEVEL0, (): void => {
      gestureDockViewDataMgr.getDockWidth();
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_getAllAppsWidth_1', Level.LEVEL0, (): void => {
      let screenPropertyWidth: number = 50;
      gestureDockViewDataMgr.getAllAppsWidth(screenPropertyWidth);
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_getAllAppsWidth_2', Level.LEVEL0, (): void => {
      let screenPropertyWidth: number | undefined = undefined;
      gestureDockViewDataMgr.getAllAppsWidth(screenPropertyWidth);
      expect(gestureDockViewDataMgr).not().assertUndefined();
    })

    it('GestureDockViewDataMgr_getDockAllAppsMargin_1', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFuc)().afterReturn(true);
      gestureDockViewDataMgr.gestureDockParam.gestureDockDirection = 1;
      gestureDockViewDataMgr.getDockAllAppsMargin();
      expect(gestureDockViewDataMgr).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('GestureDockViewDataMgr_getDockAllAppsMargin_2', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFuc)().afterReturn(true);
      gestureDockViewDataMgr.gestureDockParam.gestureDockDirection = 0;
      gestureDockViewDataMgr.getDockAllAppsMargin();
      expect(gestureDockViewDataMgr).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('GestureDockViewDataMgr_getDockAllAppsMargin_3', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFuc)().afterReturn(false);
      gestureDockViewDataMgr.gestureDockParam.gestureDockDirection = 1;
      gestureDockViewDataMgr.getDockAllAppsMargin();
      expect(gestureDockViewDataMgr).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('GestureDockViewDataMgr_getDockAllAppsMargin_4', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFuc)().afterReturn(false);
      gestureDockViewDataMgr.gestureDockParam.gestureDockDirection = 0;
      gestureDockViewDataMgr.getDockAllAppsMargin();
      expect(gestureDockViewDataMgr).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('GestureDockViewDataMgr_getCutOutDistance_1', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(gestureDockViewDataMgr.dockBarViewModel, gestureDockViewDataMgr.dockBarViewModel.getViewData);
      when(mockFuc)().afterReturn(null);
      gestureDockViewDataMgr.gestureDockParam.gestureDockDirection = 0;
      gestureDockViewDataMgr.getDockAllAppsMargin();
      expect(gestureDockViewDataMgr).not().assertUndefined();
      mocker.ignoreMock(gestureDockViewDataMgr.dockBarViewModel, gestureDockViewDataMgr.dockBarViewModel.getViewData);
    })
  })
}