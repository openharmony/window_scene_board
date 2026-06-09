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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import {
  GestureDockMode
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/GestureDockConstants';
import {
  GestureDockViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/GestureDockViewModel';
import {
  GestureDockViewParam
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockParam';
import GestureDockViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr';
import GestureDockViewEventMgr, {
  GestureDockState
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr';
import {
  GestureDockItemInfo
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';
import GestureDockBarViewAnimate
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewanimate/GestureDockBarViewAnimate';
import {
  GestureDockBarViewDataMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewdata/GestureDockBarViewDataMgr';

let gestureDockBarViewAnimate: GestureDockBarViewAnimate
let viewData: GestureDockViewDataMgr;
let gestureDockParam: GestureDockViewParam;

export default function GestureDockBarViewAnimateTest() {
  describe('GestureDockBarViewAnimateTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      gestureDockBarViewAnimate = new GestureDockBarViewAnimate(new GestureDockBarViewDataMgr());
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
      viewData = GestureDockViewModel.getInstance().getViewData() as GestureDockViewDataMgr;
      gestureDockParam = viewData?.gestureDockParam;
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

    it('GestureDockBarViewAnimate_gestureDockAppearAnimate_1', 0, (): void => {
      let animationType: number = 1;
      (gestureDockBarViewAnimate as object)['viewDataMgr'].colorShowMode = 0;
      let mocker = new MockKit();
      let mockRTLUtil = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockRTLUtil)().afterReturn(false);
      expect(gestureDockBarViewAnimate.gestureDockAppearAnimate(animationType) === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('GestureDockBarViewAnimate_gestureDockAppearAnimate_2', 0, (): void => {
      let animationType: number = 1;
      (gestureDockBarViewAnimate as object)['viewDataMgr'].colorShowMode = 1;
      let mocker = new MockKit();
      let mockRTLUtil = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockRTLUtil)().afterReturn(true);
      expect(gestureDockBarViewAnimate.gestureDockAppearAnimate(animationType) === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('GestureDockBarViewAnimate_gestureDockAppearAnimate_3', 0, (): void => {
      let animationType: number = 0;
      (gestureDockBarViewAnimate as object)['viewDataMgr'].colorShowMode = 1;
      let mocker = new MockKit();
      let mockRTLUtil = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockRTLUtil)().afterReturn(false);
      expect(gestureDockBarViewAnimate.gestureDockAppearAnimate(animationType) === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('GestureDockBarViewAnimate_gestureDockAppearAnimate_4', 0, (): void => {
      let animationType: number = 0;
      (gestureDockBarViewAnimate as object)['viewDataMgr'].colorShowMode = 0;
      let mocker = new MockKit();
      let mockRTLUtil = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockRTLUtil)().afterReturn(true);
      expect(gestureDockBarViewAnimate.gestureDockAppearAnimate(animationType) === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('GestureDockBarViewAnimate_dockBarRestPositionAnimate_1', 0, async (done: Function) => {
      expect(gestureDockBarViewAnimate.dockBarRestPositionAnimate(1, true) === undefined).assertTrue();
      done();
    });

    it('GestureDockBarViewAnimate_dockBarRestPositionAnimate_2', 0, async (done: Function) => {
      expect(gestureDockBarViewAnimate.dockBarRestPositionAnimate(0, true, () => {
      }) === undefined).assertTrue();
      done();
    });

    it('GestureDockBarViewAnimate_dockBarRestPositionAnimate_3', 0, async (done: Function) => {
      expect(gestureDockBarViewAnimate.dockBarRestPositionAnimate(1, true) === undefined).assertTrue();
      done();
    });

    it('GestureDockBarViewAnimate_dockShadowDisappearAnimate_1', 0, async (done: Function) => {
      expect((gestureDockBarViewAnimate as object)['dockShadowDisappearAnimate'](0) === undefined).assertTrue();
      done();
    });

    it('GestureDockBarViewAnimate_dockShadowDisappearAnimate_2', 0, async (done: Function) => {
      expect((gestureDockBarViewAnimate as object)['dockShadowDisappearAnimate'](1) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewAnimate_doTranslateAnimateOnAllAppsShow_1', 0, async (done: Function) => {
      gestureDockParam.isShowAllApps = true;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(true);
      expect(gestureDockBarViewAnimate.doTranslateAnimateOnAllAppsShow() === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewAnimate_doTranslateAnimateOnAllAppsShow_2', 0, async (done: Function) => {
      gestureDockParam.isShowAllApps = true;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(false);
      expect(gestureDockBarViewAnimate.doTranslateAnimateOnAllAppsShow() === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewAnimate_doTranslateAnimateOnAllAppsShow_3', 0, async (done: Function) => {
      gestureDockParam.isShowAllApps = true;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_IN;
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(false);
      expect(gestureDockBarViewAnimate.doTranslateAnimateOnAllAppsShow() === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewAnimate_doTranslateAnimateOnAllAppsShow_4', 0, async (done: Function) => {
      gestureDockParam.isShowAllApps = true;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_IN;
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(true);
      expect(gestureDockBarViewAnimate.doTranslateAnimateOnAllAppsShow() === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewAnimate_doTranslateAnimateOnAllAppsShow_5', 0, async (done: Function) => {
      gestureDockParam.isShowAllApps = false;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(true);
      expect(gestureDockBarViewAnimate.doTranslateAnimateOnAllAppsShow() === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewAnimate_doTranslateAnimateOnAllAppsShow_6', 0, async (done: Function) => {
      gestureDockParam.isShowAllApps = false;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_LEFT_OUT;
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(false);
      expect(gestureDockBarViewAnimate.doTranslateAnimateOnAllAppsShow() === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewAnimate_doTranslateAnimateOnAllAppsShow_7', 0, async (done: Function) => {
      gestureDockParam.isShowAllApps = false;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_IN;
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(true);
      expect(gestureDockBarViewAnimate.doTranslateAnimateOnAllAppsShow() === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewAnimate_doTranslateAnimateOnAllAppsShow_8', 0, async (done: Function) => {
      gestureDockParam.isShowAllApps = false;
      gestureDockParam.gestureDockDirection = GestureDockState.GESTURE_DOCK_IN;
      let mocker = new MockKit();
      let mockIsRTL = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockIsRTL)().afterReturn(false);
      expect(gestureDockBarViewAnimate.doTranslateAnimateOnAllAppsShow() === undefined).assertTrue();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('GestureDockBarViewAnimate_doDeleteAppAnimation_1', 0, async (done: Function) => {
      let gestureDockItemInfo1 = new GestureDockItemInfo();
      let gestureDockItemInfo2 = new GestureDockItemInfo();
      let gestureDockItemInfo3 = new GestureDockItemInfo();
      AppStorage.setOrCreate('gestureDockList', [gestureDockItemInfo1, gestureDockItemInfo2, gestureDockItemInfo3]);
      gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
      expect(gestureDockBarViewAnimate.doDeleteAppAnimation(0) === undefined).assertTrue();
      done();
    })

    it('GestureDockBarViewAnimate_doDeleteAppAnimation_2', 0, async (done: Function) => {
      gestureDockParam.gestureDockShowMode = GestureDockMode.INVISIBLE;
      expect(gestureDockBarViewAnimate.doDeleteAppAnimation(0) === undefined).assertTrue();
      done();
    })
  })
}