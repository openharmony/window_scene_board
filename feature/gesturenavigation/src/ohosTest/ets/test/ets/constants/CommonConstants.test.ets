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
  Level,
  Size,
  TestType
} from '@ohos/hypium';
import { OneStepState, oneStepStateManagerInstance } from '../../../../../main/ets/constants/CommonConstants';

export function CommonConstantsTest() {
  describe('CommonConstantsTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('CommonConstantsTest_init', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      const defaultState: OneStepState = OneStepState.DEFAULT;
      const onlyShowBgState: OneStepState = OneStepState.SHOW_ONLY_BG;
      const showBgAndIconState: OneStepState = OneStepState.SHOW_BG_AND_ICON;
      const enterSplitState: OneStepState = OneStepState.ENTER_SPLIT;
      const enterFloatingState: OneStepState = OneStepState.ENTER_FLOATING;
      expect(defaultState).assertEqual(0);
      expect(onlyShowBgState).assertEqual(1);
      expect(showBgAndIconState).assertEqual(2);
      expect(enterSplitState).assertEqual(3);
      expect(enterFloatingState).assertEqual(4);
    })

    // should return true when state is ENTER_SPLIT
    it('OneStepStateManager_isEnter_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      oneStepStateManagerInstance['state_'] = OneStepState.ENTER_SPLIT;
      expect(oneStepStateManagerInstance.isEnter()).assertTrue();
    })

    // should return true when state is ENTER_FLOATING
    it('OneStepStateManager_isEnter_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      oneStepStateManagerInstance['state_'] = OneStepState.ENTER_FLOATING;
      expect(oneStepStateManagerInstance.isEnter()).assertTrue();
    })

    // should return false when state is not ENTER_SPLIT or ENTER_FLOATING
    it('OneStepStateManager_isEnter_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      oneStepStateManagerInstance['state_'] = OneStepState.SHOW_BG_AND_ICON;
      expect(oneStepStateManagerInstance.isEnter()).assertFalse();
    })
  })
}