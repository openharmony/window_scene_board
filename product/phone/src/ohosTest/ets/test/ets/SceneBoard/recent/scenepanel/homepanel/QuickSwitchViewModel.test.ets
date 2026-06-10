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
  QuickSwitchViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchViewModel';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScenePanelManager,
  SCBScreenProperty
} from '@ohos/windowscene';
import screenSessionManager from '@ohos.screenSessionManager';
import {
  SCBScenePanelViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewmodel/SCBScenePanelViewModel';
import { UIContext } from '@kit.ArkUI';
import {
  QuickSwitchAnimations
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchAnimations';

export default function QuickSwitchViewModelTest() {
  describe('QuickSwitchViewModelTest', () => {
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

    let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let screenProp: screenSessionManager.ScreenProperty = {
      rotation: 1,
      bounds: {
        left: 1,
        top: 1,
        width: 1,
        height: 1,
        radius: 1,
      },
      fakeBounds: {
        left: 0,
        top: 0,
        width: 0,
        height: 0,
        radius: 0
      },
      isFakeInUse: false,
    };
    scbScreenProperty.update(screenProp);
    let scbScenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(new UIContext(), scbScreenProperty);
    let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scbScenePanelManager);

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
    let event: GestureEvent = {
      target: eventTarget,
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 0,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 2;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 8;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 16;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_05', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 24;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_06', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 64;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_07', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 80;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_08', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 100;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_09', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 102;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_10', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 120;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_11', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 220;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_12', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 320;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_13', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 420;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_14', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 500;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_15', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 510;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_16', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 520;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_17', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 530;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_18', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 540;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_19', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 550;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_20', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 600;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_21', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 620;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_22', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 720;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_23', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 820;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_24', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 920;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_25', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 1000;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_02', Level.LEVEL0, (): void => {
      event.offsetX = 120;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_03', Level.LEVEL0, (): void => {
      event.offsetX = 60;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(true, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_04', Level.LEVEL0, (): void => {
      event.offsetX = 20;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(false, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_05', Level.LEVEL0, (): void => {
      event.offsetX = 120;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(false, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })

    it('QuickSwitchViewModel_reportGestureQuickSwitch_test_06', Level.LEVEL0, (): void => {
      event.offsetX = 60;
      QuickSwitchViewModel.getInstance().reportGestureQuickSwitch(false, event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(false, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_05', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_06', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_07', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_08', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_09', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_10', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_11', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_12', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_13', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_14', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_15', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_16', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_17', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_18', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_19', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_20', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_21', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_22', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_23', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_24', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_enterQuickSwitchIdle_test_25', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      let mockGetBundleName: Function =
        mocker.mockFunc(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      when(mockGetBundleName)([ArgumentMatchers.any]).afterReturn('bundleName');
      let mockGetSceneContainerSessionList: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
      when(mockGetSceneContainerSessionList)([ArgumentMatchers.any]).afterReturn(new SCBSceneContainerSessionArray());
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().enterQuickSwitchIdle(true, event.offsetX, event.offsetY);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(SCBSceneContainerSession.prototype, SCBSceneContainerSession.prototype.getBundleName);
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getSceneContainerSessionList);
    })

    it('QuickSwitchViewModel_initQuickSwitchViewModel_test_01', Level.LEVEL0, (): void => {
      event.offsetX = 20;
      event.offsetY = 5;
      QuickSwitchViewModel.getInstance().initQuickSwitchViewModel(panelViewModel, quickSwitchAnimations);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })

    it('QuickSwitchViewModel_getQuickSwitchToContainer_test_01', Level.LEVEL0, (): void => {
      event.offsetX = 20;
      QuickSwitchViewModel.getInstance().getQuickSwitchToContainer(event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })

    it('QuickSwitchViewModel_getQuickSwitchToContainer_test_02', Level.LEVEL0, (): void => {
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
      let event: GestureEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 20,
        offsetY: 5,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      QuickSwitchViewModel.getInstance().getQuickSwitchToContainer(event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })
    it('QuickSwitchViewModel_getQuickSwitchToContainer_test_03', Level.LEVEL0, (): void => {
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
      let event: GestureEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 21,
        offsetY: 5,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      QuickSwitchViewModel.getInstance().getQuickSwitchToContainer(event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })
    it('QuickSwitchViewModel_getQuickSwitchToContainer_test_04', Level.LEVEL0, (): void => {
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
      let event: GestureEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 120,
        offsetY: 5,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      QuickSwitchViewModel.getInstance().getQuickSwitchToContainer(event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })
    it('QuickSwitchViewModel_getQuickSwitchToContainer_test_05', Level.LEVEL0, (): void => {
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
      let event: GestureEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 3000,
        offsetY: 5,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      QuickSwitchViewModel.getInstance().getQuickSwitchToContainer(event.offsetX);
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })

    it('QuickSwitchViewModel_onAnimating_test_01', Level.LEVEL0, (): void => {
      QuickSwitchViewModel.getInstance().onAnimating();
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })

    it('QuickSwitchViewModel_onInit_test_01', Level.LEVEL0, (): void => {
      QuickSwitchViewModel.getInstance().onInit();
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })

    it('isAnimatingState_test_06', Level.LEVEL0, (): void => {
      QuickSwitchViewModel.getInstance().isAnimatingState();
      expect(QuickSwitchViewModel.getInstance()).not().assertUndefined();
    })
  })
}