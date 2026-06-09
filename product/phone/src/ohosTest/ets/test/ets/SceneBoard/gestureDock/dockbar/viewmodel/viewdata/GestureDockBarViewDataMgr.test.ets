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
import { RTLUtil } from '@ohos/componenthelper';
import { SCBScreenProperty } from '@ohos/windowscene';

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
import GestureDockViewEventMgr, {
  GestureDockState
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr';
import {
  GestureDockBarViewDataMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewdata/GestureDockBarViewDataMgr';

export default function GestureDockBarViewDataMgrTest() {
  describe('GestureDockBarViewDataMgrTest', () => {
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

    it('GestureDockBarViewDataMgr_getTranslation_1', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      expect(gestureDockBarViewDataMgr.getTranslation(true) !== undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewDataMgr_getTranslation_2', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      expect(gestureDockBarViewDataMgr.getTranslation(false) !== undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewDataMgr_getCutOutDistance_1', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      expect(gestureDockBarViewDataMgr.getCutOutDistance(1) !== undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewDataMgr_getCutOutDistance_2', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      expect(gestureDockBarViewDataMgr.getCutOutDistance(0) !== undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewDataMgr_getDividerPositionX_1', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      expect(gestureDockBarViewDataMgr.getDividerPositionX(1000) !== undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewDataMgr_getDividerPositionX_2', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_IN;
      expect(gestureDockBarViewDataMgr.getDividerPositionX(1000) !== undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewDataMgr_getGestureDockBarHeight_1', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      let screenProperty = new SCBScreenProperty();
      let mocker = new MockKit();
      let mockScreenInfoUtil = mocker.mockFunc(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      when(mockScreenInfoUtil)(ArgumentMatchers.any).afterReturn(true);
      expect(gestureDockBarViewDataMgr.getGestureDockBarHeight(screenProperty) !== undefined).assertTrue();
      mocker.ignoreMock(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      done();
    })

    it('GestureDockBarViewDataMgr_getGestureDockBarHeight_2', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      let screenProperty = new SCBScreenProperty();
      let mocker = new MockKit();
      let mockScreenInfoUtil = mocker.mockFunc(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      when(mockScreenInfoUtil)(ArgumentMatchers.any).afterReturn(false);
      expect(gestureDockBarViewDataMgr.getGestureDockBarHeight(screenProperty) !== undefined).assertTrue();
      mocker.ignoreMock(ScreenInfoUtil, ScreenInfoUtil.isVertical);
      done();
    })

    it('GestureDockBarViewDataMgr_getDockOffsetX_1', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(true);
      expect(gestureDockBarViewDataMgr.getDockOffsetX(1, 1000) !== undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewDataMgr_getDockOffsetX_2', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(true);
      expect(gestureDockBarViewDataMgr.getDockOffsetX(2, 1000) !== undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewDataMgr_getDockOffsetX_3', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(false);
      expect(gestureDockBarViewDataMgr.getDockOffsetX(1, 1000) !== undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewDataMgr_getDockOffsetX_4', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(false);
      expect(gestureDockBarViewDataMgr.getDockOffsetX(2, 1000) !== undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewDataMgr_getDockTranslateX_1', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(true);
      expect(gestureDockBarViewDataMgr.getDockTranslateX(1) !== undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewDataMgr_getDockTranslateX_2', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(true);
      expect(gestureDockBarViewDataMgr.getDockTranslateX(2) !== undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewDataMgr_getDockTranslateX_3', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(false);
      expect(gestureDockBarViewDataMgr.getDockTranslateX(1) !== undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewDataMgr_getDockTranslateX_1', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(false);
      expect(gestureDockBarViewDataMgr.getDockTranslateX(2) !== undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewDataMgr_getScroller_1', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      expect(gestureDockBarViewDataMgr.getScroller(true) !== undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewDataMgr_getScroller_2', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      expect(gestureDockBarViewDataMgr.getScroller(false) !== undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewDataMgr_getDockOutTranslation_1', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = 2;
      expect(gestureDockBarViewDataMgr.getDockOutTranslation(true) !== undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewDataMgr_getDockOutTranslation_2', 0, async (done: Function) => {
      let gestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockShowMode = 0;
      expect(gestureDockBarViewDataMgr.getDockOutTranslation(false) !== undefined).assertTrue();
      done();
    })
  })
}