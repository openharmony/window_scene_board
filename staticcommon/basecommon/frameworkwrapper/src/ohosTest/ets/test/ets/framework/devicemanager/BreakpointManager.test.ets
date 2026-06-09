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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  TestType,
  Size,
  Level,
} from '@ohos/hypium';
import {
  default as breakpointManager,
  BreakpointManager,
  BreakpointData,
} from '../../../../../../main/ets/devicemanager/BreakpointManager';
import { ScreenState, ScreenStateMonitor } from '../../../../../../main/ets/devicemanager/ScreenStateMonitor';

export function BreakpointManagerTest() {
  describe('BreakpointManagerTest', () => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterEach((): void => {
    });
    afterAll((): void => {
    });

    it('getInstance', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(BreakpointManager.getInstance()).not().assertFail();
    });

    it('getBreakpointData', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(breakpointManager.getBreakpointData()).not().assertFail();
    });

    it('registerBreakpointDataChange', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      breakpointManager.registerBreakpointDataChange('registerBreakpointDataChange',
        (r1: BreakpointData, r2: BreakpointData) => {
          expect(r1 !== r2).assertTrue();
        });
    });

    it('updateBreakpointData_F', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let breakpointManager: BreakpointManager = BreakpointManager.getInstance();
      //F 态竖屏
      breakpointManager.updateBreakpointData(1008, 2232, true, 0);
      let isCorrectState = ScreenState.F === ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState;
      expect(isCorrectState).assertTrue();
    });

    it('updateBreakpointData_M', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let breakpointManager: BreakpointManager = BreakpointManager.getInstance();
      //M 态竖屏
      breakpointManager.updateBreakpointData(2048, 2232, true, 0);
      let isCorrectState = ScreenState.M === ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState;
      expect(isCorrectState).assertTrue();
    });

    it('updateBreakpointData_G', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let breakpointManager: BreakpointManager = BreakpointManager.getInstance();
      //G
      breakpointManager.updateBreakpointData(3184, 2232, false, 0);
      let isCorrectState = ScreenState.G === ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState;
      expect(isCorrectState).assertTrue();
    });
  })
}