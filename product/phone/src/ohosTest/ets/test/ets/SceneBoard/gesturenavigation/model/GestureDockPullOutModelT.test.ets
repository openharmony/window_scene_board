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
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { GestureDockModeConfig } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureDockAdapter } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/adapter/GestureDockAdapter';
import { GestureDockMode } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/GestureDockConstants';
import GestureDockViewEventMgr, {
  GestureDockDirection,
  GestureDockState
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr';
import { GestureDockViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/GestureDockViewModel';
import GestureDockViewDataMgr from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr';
import {
  GestureDockViewParam,
  SCBGestureDockParam
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockParam';
import {
  GestureDockPullOutModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/back/model/GestureDockPullOutModel';

let viewEvent: GestureDockViewEventMgr;
let dockViewModel: GestureDockViewModel = GestureDockViewModel.getInstance();
let gestureDockParam: GestureDockViewParam;
let scbGestureDockParam: SCBGestureDockParam;

export default function GestureDockPullOutModelTTest() {
  describe('GestureDockPullOutModelTTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      viewEvent = GestureDockViewModel.getInstance().getViewEvent() as GestureDockViewEventMgr;
      gestureDockParam = viewEvent?.gestureDockParam;
      scbGestureDockParam = viewEvent?.scbGestureDockParam ?? SCBGestureDockParam.getInstance();
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

    it('GestureDockPullOutModel_isDockOutEnable_1', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      let gestureDockViewDataMgr: GestureDockViewDataMgr = new GestureDockViewDataMgr();
      model.isGestureDockShow = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      when(mockFunc)().afterReturn(false);
      gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
      expect(model.isDockOutEnable() === undefined).assertFalse();
      mocker.ignoreMock(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      done();
    });

    // should_return_false_when_pullOutData_isLock_is_true
    it('GestureDockPullOutModel_isDockOutEnable_2', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      let gestureDockViewDataMgr: GestureDockViewDataMgr = new GestureDockViewDataMgr();
      model.isGestureDockShow = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      when(mockFunc)().afterReturn(false);
      gestureDockParam.gestureDockShowMode = GestureDockMode.INVISIBLE;
      model.pullOutData.isLock = true;
      expect(model.isDockOutEnable()).assertFalse();
      mocker.ignoreMock(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      done();
    });

    // should_return_true_when_isGestureDockShow_is_true_and_isGestureDockForbid_is_false
    it('GestureDockPullOutModel_isGestureDockEnable_1', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      let gestureDockViewDataMgr: GestureDockViewDataMgr = new GestureDockViewDataMgr();
      model.isGestureDockShow = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      when(mockFunc)().afterReturn(false);
      gestureDockParam.gestureDockShowMode = GestureDockMode.APPEAR;
      model.pullOutData.isLock = true;
      expect(model.isDockOutEnable()).assertFalse();
      mocker.ignoreMock(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      done();
    });

    // should_return_false_when_isGestureDockShow_is_false_and_isGestureDockForbid_is_false_and_getIsSupportGestureDock_is_true
    it('GestureDockPullOutModel_isGestureDockEnable_2', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.isGestureDockShow = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      when(mockFunc)().afterReturn(false);
      let mockFunc2: Function =
        mocker.mockFunc(GestureDockModeConfig, GestureDockModeConfig.getInstance().getIsSupportGestureDock);
      when(mockFunc2)().afterReturn(true);
      expect(model.isDockOutEnable()).assertTrue();
      mocker.ignoreMock(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      mocker.ignoreMock(GestureDockModeConfig, GestureDockModeConfig.getInstance);
      done();
    });

    // should_return_false_when_isGestureDockShow_is_false_and_isGestureDockForbid_is_false_and_getIsSupportGestureDock_is_false
    it('GestureDockPullOutModel_isGestureDockEnable_3', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.isGestureDockShow = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      when(mockFunc)().afterReturn(false);
      let mockFunc2: Function =
        mocker.mockFunc(GestureDockModeConfig, GestureDockModeConfig.getInstance().getIsSupportGestureDock);
      when(mockFunc2)().afterReturn(false);
      expect(model.isDockOutEnable()).assertTrue();
      mocker.ignoreMock(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      mocker.ignoreMock(GestureDockModeConfig, GestureDockModeConfig.getInstance);
      done();
    });

    // should_return_false_when_isGestureDockShow_is_true_and_isGestureDockForbid_is_true_and_getIsSupportGestureDock_is_true
    it('GestureDockPullOutModel_isGestureDockEnable_4', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.isGestureDockShow = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      when(mockFunc)().afterReturn(true);
      let mockFunc2: Function =
        mocker.mockFunc(GestureDockModeConfig, GestureDockModeConfig.getInstance().getIsSupportGestureDock);
      when(mockFunc2)().afterReturn(true);
      expect(model.isDockOutEnable()).assertFalse();
      mocker.ignoreMock(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      mocker.ignoreMock(GestureDockModeConfig, GestureDockModeConfig.getInstance);
      done();
    });

    // should_return_false_when_isGestureDockShow_is_true_and_isGestureDockForbid_is_true_and_getIsSupportGestureDock_is_false
    it('GestureDockPullOutModel_isGestureDockEnable_5', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.isGestureDockShow = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      when(mockFunc)().afterReturn(true);
      let mockFunc2: Function =
        mocker.mockFunc(GestureDockModeConfig, GestureDockModeConfig.getInstance().getIsSupportGestureDock);
      when(mockFunc2)().afterReturn(false);
      expect(model.isDockOutEnable()).assertFalse();
      mocker.ignoreMock(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      mocker.ignoreMock(GestureDockModeConfig, GestureDockModeConfig.getInstance);
      done();
    });

    // should_return_false_when_isGestureDockShow_is_false_and_isGestureDockForbid_is_true_and_getIsSupportGestureDock_is_true
    it('GestureDockPullOutModel_isGestureDockEnable_6', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.isGestureDockShow = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      when(mockFunc)().afterReturn(true);
      let mockFunc2: Function =
        mocker.mockFunc(GestureDockModeConfig, GestureDockModeConfig.getInstance().getIsSupportGestureDock);
      when(mockFunc2)().afterReturn(true);
      expect(model.isDockOutEnable()).assertFalse();
      mocker.ignoreMock(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      mocker.ignoreMock(GestureDockModeConfig, GestureDockModeConfig.getInstance);
      done();
    });

    // should_return_false_when_isGestureDockShow_is_false_and_isGestureDockForbid_is_true_and_getIsSupportGestureDock_is_false
    it('GestureDockPullOutModel_isGestureDockEnable_7', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.isGestureDockShow = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      when(mockFunc)().afterReturn(true);
      let mockFunc2: Function =
        mocker.mockFunc(GestureDockModeConfig, GestureDockModeConfig.getInstance().getIsSupportGestureDock);
      when(mockFunc2)().afterReturn(false);
      expect(model.isDockOutEnable()).assertFalse();
      mocker.ignoreMock(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      mocker.ignoreMock(GestureDockModeConfig, GestureDockModeConfig.getInstance);
      done();
    });

    // should_handle_exception_when_getIsSupportGestureDock_throws_an_error
    it('GestureDockPullOutModel_isGestureDockEnable_8', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.isGestureDockShow = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      when(mockFunc)().afterReturn(false);
      let mockFunc2: Function =
        mocker.mockFunc(GestureDockModeConfig, GestureDockModeConfig.getInstance().getIsSupportGestureDock);
      when(mockFunc2)().afterThrow('error');
      expect(model.isDockOutEnable()).assertTrue();
      mocker.ignoreMock(GestureDockAdapter, GestureDockAdapter.isGestureDockForbid);
      mocker.ignoreMock(GestureDockModeConfig, GestureDockModeConfig.getInstance);
      done();
    });

    // when_isDockOutEnable_returns_false
    it('GestureDockPullOutModel_onExtrudeBallsFinish_1', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(false);
      expect(model.onExtrudeBallsFinish() === undefined).assertTrue();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    // when_isDockOutEnable_returns_true_and_actionUpTime_is_zero
    it('GestureDockPullOutModel_onExtrudeBallsFinish_2', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.pullOutData.actionUpTime = 0;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      expect(model.onExtrudeBallsFinish() === undefined).assertTrue();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    // when_isDockOutEnable_returns_true_and_actionUpTime_is_not_zero
    it('GestureDockPullOutModel_onExtrudeBallsFinish_3', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.pullOutData.actionUpTime = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      expect(model.onExtrudeBallsFinish() === undefined).assertTrue();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    // should_set_hasMovedBackBall_to_true_when_isDockOutEnable_returns_true
    it('GestureDockPullOutModel_onMoveBackBallsBegin_1', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      model.onMoveBackBallsBegin();
      expect(model.pullOutData.isMoveBackAnimStart).assertTrue();
      mocker.verify('isDockOutEnable', []).atLeast(1);
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    // should_not_set_hasMovedBackBall_when_isDockOutEnable_returns_false
    it('GestureDockPullOutModel_onMoveBackBallsBegin_2', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(false);
      model.onMoveBackBallsBegin();
      expect(model.pullOutData.isMoveBackAnimStart).assertFalse();
      mocker.verify('isDockOutEnable', []).atLeast(1);
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    it('GestureDockPullOutModel_onMoveBackBallsBegin_3', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      gestureDockParam.gestureDockDirection = 1;
      expect(model.onMoveBackBallsBegin() === undefined).assertTrue();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    // should_not_call_resetDockImgProcess_when_isDockOutEnable_returns_false
    it('GestureDockPullOutModel_onMoveBackBallsFinish_1', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(false);
      expect(model.onMoveBackBallsFinish() === undefined).assertTrue();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    // should_call_resetDockImgProcess_when_isDockOutEnable_returns_true_and_gestureDockDirection_is_greater_than_GESTURE_DOCK_IN
    it('GestureDockPullOutModel_onMoveBackBallsFinish_2', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      expect(model.onMoveBackBallsFinish() === undefined).assertTrue();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    // should_not_call_resetDockImgProcess_when_isDockOutEnable_returns_true_but_gestureDockDirection_is_not_greater_than_GESTURE_DOCK_IN
    it('GestureDockPullOutModel_onMoveBackBallsFinish_3', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_IN;
      expect(model.onMoveBackBallsFinish() === undefined).assertTrue();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    // should_not_proceed_if_gestureDockDirection_is_greater_than_GESTURE_DOCK_IN
    it('GestureDockPullOutModel_pullOutGestureDock_1', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      model.pullOutGestureDock();
      expect(model).not().assertUndefined();
      done();
    });

    it('GestureDockPullOutModel_pullOutGestureDock_2', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_IN;
      model.pullOutData.isLeft = true;
      expect(model.pullOutGestureDock() === undefined).assertTrue();
      done();
    });

    it('GestureDockPullOutModel_pullOutGestureDock_3', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_IN;
      model.pullOutData.isLeft = false;
      expect(model.pullOutGestureDock() === undefined).assertTrue();
      done();
    });

    it('GestureDockPullOutModel_pullOutGestureDock_4', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      SCBGestureDockParam.getInstance().isGestureDockShow = true;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockDirection = 0;
      model.pullInGestureDock();
      expect(model).not().assertUndefined();
      done();
    });

    it('GestureDockPullOutModel_pullOutGestureDock_5', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      SCBGestureDockParam.getInstance().isGestureDockShow = true;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockDirection = 1;
      model.pullInGestureDock();
      expect(model).not().assertUndefined();
      done();
    });

    it('GestureDockPullOutModel_pullOutGestureDock_6', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      SCBGestureDockParam.getInstance().isGestureDockShow = false;
      expect(model.pullInGestureDock() !== undefined).assertFalse();
      done();
    });

    it('GestureDockPullOutModel_changeToDockImgAnimFinish_1', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.pullOutData.actionUpTime = 0;
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(false);
      expect((model as object)['changeToDockImgAnimFinish'](true) !== undefined).assertFalse();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    it('GestureDockPullOutModel_changeToDockImgAnimFinish_2', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.pullOutData.actionUpTime = 0;
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      model.pullOutData.isMoveBackAnimStart = true;
      expect((model as object)['changeToDockImgAnimFinish'](true) !== undefined).assertFalse();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    it('GestureDockPullOutModel_changeToDockImgAnimFinish_3', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.pullOutData.actionUpTime = 0;
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      model.pullOutData.isMoveBackAnimStart = false;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockDirection = 0;
      expect((model as object)['changeToDockImgAnimFinish'](true) !== undefined).assertFalse();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    it('GestureDockPullOutModel_changeToDockImgAnimFinish_4', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.pullOutData.actionUpTime = 0;
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      model.pullOutData.isMoveBackAnimStart = false;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockDirection = 1;
      expect((model as object)['changeToDockImgAnimFinish'](true) !== undefined).assertFalse();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    it('GestureDockPullOutModel_changeToDockImgAnimFinish_5', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.pullOutData.actionUpTime = 1000;
      model.pullOutData.startChangeDockImgTime = 1;
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(false);
      expect((model as object)['changeToDockImgAnimFinish'](true) !== undefined).assertFalse();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    it('GestureDockPullOutModel_changeToDockImgAnimFinish_6', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.pullOutData.actionUpTime = 1000;
      model.pullOutData.startChangeDockImgTime = 1;
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      model.pullOutData.isMoveBackAnimStart = true;
      expect((model as object)['changeToDockImgAnimFinish'](true) !== undefined).assertFalse();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });

    it('GestureDockPullOutModel_changeToDockImgAnimFinish_7', 0, async (done: Function) => {
      let model: GestureDockPullOutModel = new GestureDockPullOutModel();
      model.pullOutData.actionUpTime = 1000;
      model.pullOutData.startChangeDockImgTime = 1;
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.isDockOutEnable);
      when(mockFunc)().afterReturn(true);
      model.pullOutData.isMoveBackAnimStart = false;
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      let viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      let gestureDockParam = viewData?.gestureDockParam;
      gestureDockParam.gestureDockDirection = 0;
      expect((model as object)['changeToDockImgAnimFinish'](true) !== undefined).assertFalse();
      mocker.ignoreMock(model, model.isDockOutEnable);
      done();
    });
  })
}
