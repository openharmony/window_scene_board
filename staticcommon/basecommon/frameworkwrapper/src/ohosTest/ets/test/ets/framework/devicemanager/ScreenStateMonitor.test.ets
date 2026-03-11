/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  TestType,
  Size,
  MockKit,
  when,
  Level,
} from '@ohos/hypium';

import {
  ScreenStateMonitor, ScreenStateModel
} from '../../../../../../main/ets/devicemanager/ScreenStateMonitor';
import {
  BreakpointManager, BreakpointData, BreakpointOrientation, BreakpointState
} from '../../../../../../main/ets/devicemanager/BreakpointManager';

export function ScreenStateMonitorTest() {
  describe('ScreenStateMonitorTest', () => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterEach((): void => {
    });
    afterAll((): void => {
    });

    it('getInstance', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(ScreenStateMonitor.getInstance()).not().assertFail();
    });

    it('getCurrentScreenStateModel', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(ScreenStateMonitor.getInstance().getCurrentScreenStateModel()).not().assertFail();
    });

    it('registerScreenStateChangeListener', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      ScreenStateMonitor.getInstance().registerScreenStateChangeListener('registerScreenStateChangeListener',
        (r1: ScreenStateModel, r2: ScreenStateModel) => {
        expect(r1 !== r2).assertTrue();
      });
    });

    it('should_return_same_instance', 0, () => {
      let screenStateMonitor: ScreenStateMonitor = ScreenStateMonitor.getInstance();
      let screenStateMonitor2: ScreenStateMonitor = ScreenStateMonitor.getInstance();
      expect(screenStateMonitor).assertEqual(screenStateMonitor2);
    });

    it('should_return_correct_screen_state_model', 0, async () => {
      let screenstatemonitor: ScreenStateMonitor = ScreenStateMonitor.INSTANCE;
      let mocker: MockKit = new MockKit();
      let breakpointManager: BreakpointManager = BreakpointManager.getInstance();
      let mockGetBreakpointData: Function = mocker.mockFunc(breakpointManager, breakpointManager.getBreakpointData);
      let mockGetScreenStateModel: Function = mocker.mockFunc(screenstatemonitor, screenstatemonitor.getScreenStateModel);

      let breakpointData: BreakpointData = new BreakpointData(BreakpointState.BREAKPOINT_STATE_PORTRAIT, BreakpointOrientation.BREAKPOINT_ORIENTATION_PORTRAIT);
      when(mockGetBreakpointData)([]).afterReturn(breakpointData);

      let screenStateModel: ScreenStateModel = new ScreenStateModel();
      when(mockGetScreenStateModel)([ArgumentMatchers.any]).afterReturn(screenStateModel);

      const result = screenstatemonitor.getCurrentScreenStateModel();
      expect(result).assertDeepEquals(screenStateModel);

      mocker.ignoreMock(breakpointManager, breakpointManager.getBreakpointData);
      mocker.ignoreMock(screenstatemonitor, screenstatemonitor.getScreenStateModel);
    });
  })
}