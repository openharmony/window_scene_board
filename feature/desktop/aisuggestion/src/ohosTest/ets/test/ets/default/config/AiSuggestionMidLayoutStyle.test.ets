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
} from '@ohos/hypium';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import { LayoutComponentId } from '../../../../../../main/ets/default/config/AiSuggestionLayoutStyle';
import {
  AiSuggestionMidLayoutStyle
} from '../../../../../../main/ets/default/config/AiSuggestionMidLayoutStyle';

/**
 * AiSuggestionMidLayoutStyleTest
 *
 * @since 2024-05-10
 */
export function AiSuggestionMidLayoutStyleTest() {
  describe('AiSuggestionMidLayoutStyleTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('testDescAlignRules', 0, () => {
      let style: AiSuggestionMidLayoutStyle = new AiSuggestionMidLayoutStyle();
      expect(style.descAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);

      let info: PortfolioInfo = new PortfolioInfo();
      let displayCardInfo: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      style.update(displayCardInfo, info);
      expect(style.descAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);

      info.desc1 = 'desc1';
      style.update(displayCardInfo, info);
      expect(style.descAlignRules().top?.anchor).assertEqual(LayoutComponentId.PORTFOLIO_DESC1);

      info.desc2 = 'desc2';
      style.update(displayCardInfo, info);
      expect(style.descAlignRules().top?.anchor).assertEqual(LayoutComponentId.PORTFOLIO_DESC2);
    });

    it('testGridAlignRules', 0, () => {
      let style: AiSuggestionMidLayoutStyle = new AiSuggestionMidLayoutStyle();
      let info: PortfolioInfo = new PortfolioInfo();
      let displayCardInfo: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      style.update(displayCardInfo, info);
      expect(style.gridAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);

      info.title = 'title';
      style.update(displayCardInfo, info);
      expect(style.gridAlignRules().top?.anchor).assertEqual(LayoutComponentId.PORTFOLIO_TITLE);
    });

    it('testChip1AlignRules', 0, () => {
      let style: AiSuggestionMidLayoutStyle = new AiSuggestionMidLayoutStyle();
      expect(style.chip2AlignRules().top?.anchor).assertEqual(LayoutComponentId.AGENT_CHIP1);
    });

    it('testChip2AlignRules', 0, () => {
      let style: AiSuggestionMidLayoutStyle = new AiSuggestionMidLayoutStyle();
      expect(style.titleAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);
    });
  })
}