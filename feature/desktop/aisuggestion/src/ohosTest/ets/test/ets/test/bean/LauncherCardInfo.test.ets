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
  it,
  describe,
  expect,
  TestType,
  Size,
  Level,
  MockKit,
  when,
} from '@ohos/hypium';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import { LauncherCardInfo } from '../../../../../../main/ets/default/bean/LauncherCardInfo';
import { AbilityFormUtil } from '../../../../../../main/ets/default/utils/AbilityFormUtil';

export function LauncherCardInfoTest() {
  describe('LauncherCardInfoTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testGetDisplayCardInfo', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      expect(LauncherCardInfo.getDisplayCardInfo(undefined)).assertUndefined();

      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      let landscapeDisplay: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      cardInfo.landscapeOrExpand = landscapeDisplay;
      expect(LauncherCardInfo.getDisplayCardInfo(cardInfo, true)).assertEqual(cardInfo.landscapeOrExpand);

      const mocker: MockKit = new MockKit();
      let mockIsExpand: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.isExpand);
      when(mockIsExpand)().afterReturn(true);
      expect(LauncherCardInfo.getDisplayCardInfo(cardInfo)).assertEqual(cardInfo.landscapeOrExpand);

      when(mockIsExpand)().afterReturn(false);
      expect(LauncherCardInfo.getDisplayCardInfo(cardInfo)).assertUndefined();

      let portraitDisplay: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      cardInfo.portrait = portraitDisplay;
      expect(LauncherCardInfo.getDisplayCardInfo(cardInfo)).assertEqual(cardInfo.portrait);

      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('testIsUpdateCard', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {

      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      cardInfo.optType = AiSuggestionUpdateConstants.OptType.UPDATE_CARD;
      expect(LauncherCardInfo.isUpdateCard(cardInfo)).assertTrue();

      cardInfo.optType = AiSuggestionUpdateConstants.OptType.UPDATE_AND_SWITCH;
      expect(LauncherCardInfo.isUpdateCard(cardInfo)).assertTrue();
    });

    it('testIsNeedToSwitch', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {

      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      cardInfo.optType = AiSuggestionUpdateConstants.OptType.SWITCH_CARD;
      expect(LauncherCardInfo.isNeedToSwitch(cardInfo)).assertTrue();

      cardInfo.optType = AiSuggestionUpdateConstants.OptType.ADD_AND_SWITCH;
      expect(LauncherCardInfo.isNeedToSwitch(cardInfo)).assertTrue();
    });

    it('LauncherCardInfoTest_isCardInfoValid_01', 0, (): void => {
      expect(LauncherCardInfo.isCardInfoValid()).assertFalse();
    });

    it('LauncherCardInfoTest_isCardInfoValid_02', 0, (): void => {
      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      cardInfo.portrait = new LauncherDisplayCardInfo();
      expect(LauncherCardInfo.isCardInfoValid(cardInfo)).assertFalse();
    });

    it('LauncherCardInfoTest_isCardInfoValid_03', 0, (): void => {
      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      cardInfo.portrait = new LauncherDisplayCardInfo();
      cardInfo.portrait.recItems = [];
      expect(LauncherCardInfo.isCardInfoValid(cardInfo)).assertFalse();
    });

    it('LauncherCardInfoTest_isCardInfoInValid_01', 0, (): void => {
      expect(LauncherCardInfo.isCardInfoInValid(undefined, undefined)).assertTrue();
    });

    it('LauncherCardInfoTest_isCardInfoInValid_02', 0, (): void => {
      let displayCardInfo: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      displayCardInfo.recItems = [];
      expect(LauncherCardInfo.isCardInfoInValid(displayCardInfo, undefined)).assertTrue();
    });

    it('LauncherCardInfoTest_isExpired_01', 0, (): void => {
      expect(LauncherCardInfo.isExpired()).assertTrue();
    });

    it('LauncherCardInfoTest_isExpired_02', 0, (): void => {
      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      expect(LauncherCardInfo.isExpired(cardInfo)).assertFalse();
    });

    it('LauncherCardInfoTest_isExpired_03', 0, (): void => {
      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      expect(LauncherCardInfo.isExpired(cardInfo)).assertFalse();
    });

    it('LauncherCardInfoTest_isExpired_04', 0, (): void => {
      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      cardInfo.portfolioInfo = new PortfolioInfo();
      expect(LauncherCardInfo.isExpired(cardInfo)).assertFalse();
    });

    it('LauncherCardInfoTest_isExpired_05', 0, (): void => {
      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      cardInfo.portfolioInfo = new PortfolioInfo();
      cardInfo.portfolioInfo.expireTime = 0;
      expect(LauncherCardInfo.isExpired(cardInfo)).assertFalse();
    });

    it('LauncherCardInfoTest_isExpired_06', 0, (): void => {
      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      cardInfo.portfolioInfo = new PortfolioInfo();
      cardInfo.portfolioInfo.expireTime = Date.now() - 1;
      expect(LauncherCardInfo.isExpired(cardInfo)).assertTrue();
    });

    it('LauncherCardInfoTest_isExpired_07', 0, (): void => {
      let cardInfo: LauncherCardInfo = new LauncherCardInfo();
      cardInfo.portfolioInfo = new PortfolioInfo();
      cardInfo.portfolioInfo.expireTime = Date.now() + 1;
      expect(LauncherCardInfo.isExpired(cardInfo)).assertFalse();
    });

  });
}