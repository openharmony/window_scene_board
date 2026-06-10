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
  DeviceHelper,
  OperateResult,
  PairSplitResult
} from '@ohos/frameworkwrapper';
import { MultiWindowReporter } from '../../../../../../phone/src/main/ets/SceneBoard/scenemanager/multiwindow/utils/MultiWindowReporter'
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';


export function SCBMultiWindowReporterTest() {
  const CLOSE_TYPE_BY_BUTTON = 0;
  const BUNDLE_NAME = 'com.ohos.settings';

  describe('SCBMultiWindowReporterTest_001', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('getSplitDisplayMode_mock_return_FOLD_DISPLAY_MODE_FULL_001', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      const mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.getFoldDisplayMode);
      when(mockFunc1)().afterReturn(true);
      when(mockFunc2)().afterReturn(1);
      MultiWindowReporter.getSplitDisplayMode();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('getSplitDisplayMode_mock_return_false_001', 0, (): void => {
      let isCalled: Boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockFunc)(ArgumentMatchers.any).afterAction(() => {
        isCalled = true
      })
      MultiWindowReporter.getSplitDisplayMode();
      MultiWindowReporter.getDisplayMode();
      expect(DeviceHelper.isFold() === undefined).assertTrue();
      expect(isCalled).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('getSplitDisplayMode_mock_return_FOLD_DISPLAY_MODE_MAIN_001', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      const mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.getFoldDisplayMode);
      when(mockFunc1)().afterReturn(true);
      when(mockFunc2)().afterReturn(2);
      MultiWindowReporter.getSplitDisplayMode();
      MultiWindowReporter.getDisplayMode();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('getSplitDisplayMode_getForegroundFloatList_001', 0, (): void => {
      let list: string[] = MultiWindowReporter.getForegroundFloatList();
      expect(list).not().assertNull();
    })

    it('getSplitDisplayMode_mock_return_others_001', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      const mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.getFoldDisplayMode);
      when(mockFunc1)().afterReturn(true);
      when(mockFunc2)().afterReturn(3);
      MultiWindowReporter.getSplitDisplayMode();
      MultiWindowReporter.getDisplayMode();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('MultiWindowReporterTest_report002', 0, (): void => {
      MultiWindowReporter.reportStartFromRecent(1, BUNDLE_NAME);
      MultiWindowReporter.reportStartFromDocker(0, 0, BUNDLE_NAME);
      MultiWindowReporter.reportStartFromAppIcon(BUNDLE_NAME);
      MultiWindowReporter.reportStartFromOneStep(0, BUNDLE_NAME, 0);
      MultiWindowReporter.reportStartFromNotify(0, BUNDLE_NAME);
      MultiWindowReporter.reportClickMiniWindow(BUNDLE_NAME);
      MultiWindowReporter.reportDoubleClickMini(BUNDLE_NAME);
      MultiWindowReporter.reportFloatingToSplit(0, false, '', '', '', false);
      MultiWindowReporter.reportSwichFloating(0, BUNDLE_NAME);
      expect(MultiWindowReporter['mMultiWindowReportEvent']).not().assertNull();
    })

    it('MultiWindowReporterTest_report001', 0, (): void => {
      MultiWindowReporter.reportCloseFloating(CLOSE_TYPE_BY_BUTTON, BUNDLE_NAME);
      MultiWindowReporter.reportMinFloating(0, BUNDLE_NAME, 0);
      MultiWindowReporter.reportExpandSideTaskManager(0);
      MultiWindowReporter.reportDeleteFromSideTaskManager(0, BUNDLE_NAME, 0);
      MultiWindowReporter.reportSqueezedOutSideBar(BUNDLE_NAME);
      MultiWindowReporter.reportClickTitleBar('dt title');
      MultiWindowReporter.reportTouchDragFloating('touch drag');
      MultiWindowReporter.reportMaxFloating(0, BUNDLE_NAME);
      MultiWindowReporter.reportScaleFloating(0, 0, 0, BUNDLE_NAME);
      MultiWindowReporter.reportOneStepHotArea(BUNDLE_NAME);
      expect(MultiWindowReporter['mMultiWindowReportEvent']).not().assertNull();
    })

    it('MultiWindowReporterTest_report004', 0, (): void => {
      MultiWindowReporter.reportMenuSwitchPairSplitLoc('primary', 'secondary', 0, OperateResult.SUCCESS);
      MultiWindowReporter.reportExitOneStepSplit(BUNDLE_NAME, 0, 0);
      MultiWindowReporter.reportDragDividerExitPairSplit('primary', 'secondary', 0, 'exit');
      MultiWindowReporter.reportBackGestureExitPairSplit('primary', 'secondary', 0, 'exit');
      MultiWindowReporter.reportTitleBarExitPairSplit('primary', 'secondary', 0, BUNDLE_NAME, 1);
      MultiWindowReporter.reportTitleBarClick(BUNDLE_NAME);
      MultiWindowReporter.reportDividerClick();
      MultiWindowReporter.reportSplitToFloat('', '', '', false);
      MultiWindowReporter.reportTitleBarClick(BUNDLE_NAME);
      expect(MultiWindowReporter['mMultiWindowReportEvent']).not().assertNull();
    })

    it('MultiWindowReporterTest_report003', 0, (): void => {
      MultiWindowReporter.reportStartFromSideBar(0, BUNDLE_NAME, 0);
      MultiWindowReporter.reportOneStepSplitHotArea(BUNDLE_NAME, 0);
      MultiWindowReporter.reportEnterOneStepSplit(BUNDLE_NAME, 1, OperateResult.SUCCESS, 0);
      MultiWindowReporter.reportEnterPairSplitFromIcon('primary', 'secondary', PairSplitResult.PAIR_SPLIT, 0);
      MultiWindowReporter.reportEnterPairSplitFromDock('oriPrimary', 'oriSecondary', 1,
        PairSplitResult.NO_SUPPORT_SPLIT, 'curPrimary', 'curSecondary', 0, false);
      MultiWindowReporter.reportDragSwapPairSplitLoc('primary', '', 0, OperateResult.SUCCESS);
      MultiWindowReporter.reportMenuSwapPairSplitLoc('primary', 'secondary', 0, OperateResult.SUCCESS);
      MultiWindowReporter.reportMenuSwitchPairSplitLoc('primary', 'secondary', 0, OperateResult.SUCCESS);
      MultiWindowReporter.reportAdjustPairSplitRatio('oriPrimary', 'oriSecondary', 0, '', '');
      expect(MultiWindowReporter['mMultiWindowReportEvent']).not().assertNull();
    })

  })
}