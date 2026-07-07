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
  when,
} from '@ohos/hypium';
import { AiSuggestionMinLayoutStyle } from '../../../../../../main/ets/default/config/AiSuggestionMinLayoutStyle';
import { LayoutComponentId } from '../../../../../../main/ets/default/config/AiSuggestionLayoutStyle';
import { RTLUtil } from '@ohos/componenthelper';

/**
 * AiSuggestionMinLayoutStyleTest
 *
 * @since 2024-08-02
 */
export function AiSuggestionMinLayoutStyleTest() {
  describe('AiSuggestionMinLayoutStyleTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('testChip1AlignRules', 0, () => {
      let style: AiSuggestionMinLayoutStyle = new AiSuggestionMinLayoutStyle();
      expect(style.chip1AlignRules().top?.anchor).assertEqual(LayoutComponentId.PORTFOLIO_DESC2);
    });

    it('testChip2AlignRules', 0, () => {
      let style: AiSuggestionMinLayoutStyle = new AiSuggestionMinLayoutStyle();
      expect(style.chip2AlignRules().top?.anchor).assertEqual(LayoutComponentId.AGENT_CHIP1);
    });

    it('testTitleAlignRules', 0, () => {
      let style: AiSuggestionMinLayoutStyle = new AiSuggestionMinLayoutStyle();
      expect(style.titleAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);
    });

    it('testChangeBallAlignRules', 0, () => {
      let style: AiSuggestionMinLayoutStyle = new AiSuggestionMinLayoutStyle();
      expect(style.changeBallAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);
    });

    it('AiSuggestionMinLayoutStyleTest_getChipItemMargin_01', 0, () => {
      let style: AiSuggestionMinLayoutStyle = new AiSuggestionMinLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(func)().afterReturn(true);
      expect(style.getChipItemMargin().right).assertEqual(12);
      mocker.clear(RTLUtil);
      mocker.clearAll();
    });

    it('AiSuggestionMinLayoutStyleTest_getChipItemMargin_02', 0, () => {
      let style: AiSuggestionMinLayoutStyle = new AiSuggestionMinLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(func)().afterReturn(false);
      expect(style.getChipItemMargin().right).assertEqual(0);
      mocker.clear(RTLUtil);
      mocker.clearAll();
    });

  });
}