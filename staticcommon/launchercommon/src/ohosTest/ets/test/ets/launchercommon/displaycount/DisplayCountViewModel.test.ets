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


import { DeviceState } from '../../../../../../main/ets/constants/CommonConstants';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium';
import { DisplayCountViewModel } from '../../../../../../main/ets/displaycount/DisplayCountViewModel';
import { PageInfoManager } from '../../../../../../main/ets/cache/layout/PageInfoManager';
import { ScreenState, ScreenStateMonitor } from '@ohos/frameworkwrapper';

export default function DisplayCountViewModelTest() {
  describe('DisplayCountViewModelTest', () => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('calculate_default_state', 0, async () => {
      let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
      let isPortrait: boolean = false;
      let folderStatus: DeviceState = DeviceState.DEFAULT_STATE;
      displayCountViewModel.calculate(isPortrait, folderStatus);
      expect(displayCountViewModel.getDisplayCountData().getDisplayCount()).assertEqual(1);
      expect(displayCountViewModel.getDisplayCount()).assertEqual(1);
    });

    it('calculate_folded_state_maxDisplayCount_2', 0, async () => {
      let maxDisplayCount = 2;
      PageInfoManager.getInstance().setMaxDisplayCount(maxDisplayCount);
      let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
      let isPortrait: boolean = false;
      let folderStatus: DeviceState = DeviceState.EXPAND_STATE;
      displayCountViewModel.calculate(isPortrait, folderStatus);
      expect(displayCountViewModel.getDisplayCount()).assertEqual(2);
    });

    it('calculate_folded_state_maxDisplayCount_3_landscape_G', 0, async () => {
      let maxDisplayCount = 3;
      PageInfoManager.getInstance().setMaxDisplayCount(maxDisplayCount);
      let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
      let isPortrait: boolean = false;
      let folderStatus: DeviceState = DeviceState.EXPAND_STATE;
      let mocker: MockKit = new MockKit();
      let screenStateMonitor: ScreenStateMonitor = ScreenStateMonitor.getInstance();
      let mockCurrentScreenStateModel: Function = mocker.mockFunc(screenStateMonitor, screenStateMonitor.getCurrentScreenStateModel);
      when(mockCurrentScreenStateModel)().afterReturn(ScreenState.G);
      displayCountViewModel.calculate(isPortrait, folderStatus);
      expect(displayCountViewModel.getDisplayCount()).assertLarger(1);
      mocker.clear(screenStateMonitor);
      mocker.clearAll();
    });

    it('calculate_folded_state_maxDisplayCount_3_portrait_G', 0, async () => {
      let maxDisplayCount = 3;
      PageInfoManager.getInstance().setMaxDisplayCount(maxDisplayCount);
      let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
      let isPortrait: boolean = true;
      let folderStatus: DeviceState = DeviceState.EXPAND_STATE;
      let mocker: MockKit = new MockKit();
      let screenStateMonitor: ScreenStateMonitor = ScreenStateMonitor.getInstance();
      let mockCurrentScreenStateModel: Function = mocker.mockFunc(screenStateMonitor, screenStateMonitor.getCurrentScreenStateModel);
      when(mockCurrentScreenStateModel)().afterReturn(ScreenState.G);
      displayCountViewModel.calculate(isPortrait, folderStatus);
      expect(displayCountViewModel.getDisplayCount()).assertEqual(2);
      mocker.clear(screenStateMonitor);
      mocker.clearAll();
    });

    it('calculate_folded_state_maxDisplayCount_3_landscape_F', 0, async () => {
      let maxDisplayCount = 3;
      PageInfoManager.getInstance().setMaxDisplayCount(maxDisplayCount);
      let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
      let isPortrait: boolean = false;
      let folderStatus: DeviceState = DeviceState.EXPAND_STATE;
      let mocker: MockKit = new MockKit();
      let screenStateMonitor: ScreenStateMonitor = ScreenStateMonitor.getInstance();
      let mockCurrentScreenStateModel: Function = mocker.mockFunc(screenStateMonitor, screenStateMonitor.getCurrentScreenStateModel);
      when(mockCurrentScreenStateModel)().afterReturn(ScreenState.F);
      displayCountViewModel.calculate(isPortrait, folderStatus);
      expect(displayCountViewModel.getDisplayCount()).assertEqual(2);
      mocker.clear(screenStateMonitor);
      mocker.clearAll();
    });

    it('setNextMargin', 0, async () => {
      let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
      let nextMargin = 1;
      displayCountViewModel.setNextMargin(nextMargin);
      expect(displayCountViewModel.getNextMargin()).assertEqual(nextMargin);
    });
  })
}