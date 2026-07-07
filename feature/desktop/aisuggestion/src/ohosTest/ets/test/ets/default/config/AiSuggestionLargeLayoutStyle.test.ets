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
import {
  LayoutComponentId,
  AiSuggestionLayoutStyle,
} from '../../../../../../main/ets/default/config/AiSuggestionLayoutStyle';
import { AiSuggestionLargeLayoutStyle } from '../../../../../../main/ets/default/config/AiSuggestionLargeLayoutStyle';
import { PortfolioInfoDisplayMode } from '../../../../../../main/ets/default/constants/PortfolioInfoDisplayMode';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';

/**
 * AiSuggestionSquareLayoutStyleTest
 *
 * @since 2024-05-10
 */
export function AiSuggestionLargeLayoutStyleTest() {
  describe('AiSuggestionLargeLayoutStyleTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('testDesc1AlignRules', 0, () => {
      let style: AiSuggestionLargeLayoutStyle = new AiSuggestionLargeLayoutStyle();
      expect(style.desc1AlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);

      let info: PortfolioInfo = new PortfolioInfo();
      let displayCardInfo: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      style.update(displayCardInfo, info);
      expect(style.desc1AlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);

      info.title = 'title';
      style.update(displayCardInfo, info);
      expect(style.desc1AlignRules().top?.anchor).assertEqual(LayoutComponentId.PORTFOLIO_TITLE);
    });

    it('testDesc2AlignRules', 0, () => {
      let style: AiSuggestionLargeLayoutStyle = new AiSuggestionLargeLayoutStyle();
      expect(style.desc2AlignRules().top?.anchor).assertEqual(LayoutComponentId.PORTFOLIO_DESC1);
      expect(style.desc2AlignRules().left?.anchor).assertEqual(LayoutComponentId.CONTAINER);
    });

    it('testBlankAlignRules', 0, () => {
      let style: AiSuggestionLargeLayoutStyle = new AiSuggestionLargeLayoutStyle();
      expect(style.blankAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);
      expect(style.blankAlignRules().left?.anchor).assertEqual(LayoutComponentId.CONTAINER);
    });

    it('testIllustrationAlignRules', 0, () => {
      let style: AiSuggestionLargeLayoutStyle = new AiSuggestionLargeLayoutStyle();
      expect(style.illustrationAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);
      expect(style.illustrationAlignRules().left?.anchor).assertEqual(LayoutComponentId.CONTAINER);
    });

    it('testDescAlignRules', 0, () => {
      let style: AiSuggestionLayoutStyle = new AiSuggestionLargeLayoutStyle();
      expect(style.descAlignRules().bottom?.anchor).assertEqual(LayoutComponentId.CONTAINER);

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
      let style: AiSuggestionLayoutStyle = new AiSuggestionLargeLayoutStyle();
      expect(style.gridAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);

      let info: PortfolioInfo = new PortfolioInfo();
      let displayCardInfo: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      style.update(displayCardInfo, info);
      expect(style.gridAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);

      info.title = 'title';
      style.update(displayCardInfo, info);
      expect(style.gridAlignRules().top?.anchor).assertEqual(LayoutComponentId.PORTFOLIO_TITLE);
    });

    it('testChip1AlignRules', 0, () => {
      let style: AiSuggestionLargeLayoutStyle = new AiSuggestionLargeLayoutStyle();
      expect(style.chip1AlignRules().top?.anchor).assertEqual(LayoutComponentId.PORTFOLIO_DESC2);
      expect(style.chip1AlignRules().left?.anchor).assertEqual(LayoutComponentId.PORTFOLIO_DESC2);
    });

    it('testChip2AlignRules', 0, () => {
      let style: AiSuggestionLargeLayoutStyle = new AiSuggestionLargeLayoutStyle();
      expect(style.chip2AlignRules().top?.anchor).assertEqual(LayoutComponentId.PORTFOLIO_DESC2);
      expect(style.chip2AlignRules().left?.anchor).assertEqual(LayoutComponentId.AGENT_CHIP1);
    });

    it('testChip2AlignRules', 0, () => {
      let style: AiSuggestionLargeLayoutStyle = new AiSuggestionLargeLayoutStyle();
      expect(style.titleAlignRules().top?.anchor).assertEqual(LayoutComponentId.CONTAINER);
      expect(style.titleAlignRules().left?.anchor).assertEqual(LayoutComponentId.CONTAINER);
    });

    it('AiSuggestionLargeLayoutStyleTest_gridAlignRules_01', 0, () => {
      let style: AiSuggestionLayoutStyle = new AiSuggestionLargeLayoutStyle();
      let info: PortfolioInfo = new PortfolioInfo();
      let displayCardInfo: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      info.desc1 = '123';
      info.portfolioId = '234';
      let mocker: MockKit = new MockKit();

      style.update(displayCardInfo, info);
      expect(style.gridAlignRules().top?.anchor).assertEqual(LayoutComponentId.BLANK);
      mocker.clearAll();
    });

    it('AiSuggestionLargeLayoutStyleTest_gridAlignRules_02', 0, () => {
      let style: AiSuggestionLayoutStyle = new AiSuggestionLargeLayoutStyle();
      let info: PortfolioInfo = new PortfolioInfo();
      let displayCardInfo: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      info.desc1 = '123';
      info.portfolioId = '234';
      info.displayMode = PortfolioInfoDisplayMode.DISPLAY_MODE_EXIST;
      let mocker: MockKit = new MockKit();

      style.update(displayCardInfo, info);
      expect(style.gridAlignRules().top?.anchor).assertEqual(LayoutComponentId.BLANK);
      mocker.clearAll();
    });

    it('AiSuggestionLargeLayoutStyleTest_getChipItemMargin_01', 0, () => {
      let style: AiSuggestionLayoutStyle = new AiSuggestionLargeLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(func)().afterReturn(true);

      expect(style.getChipItemMargin().top).assertEqual(6);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('AiSuggestionLargeLayoutStyleTest_getChipItemMargin_02', 0, () => {
      let style: AiSuggestionLayoutStyle = new AiSuggestionLargeLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(func)().afterReturn(false);

      expect(style.getChipItemMargin().top).assertEqual(8);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });
  });
}