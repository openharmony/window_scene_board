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
  ArgumentMatchers,
} from '@ohos/hypium';
import { CardItemInfo, GridLayoutItemInfo } from '@ohos/launchercommon';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import { LauncherFormDistribution } from '../../../../../../main/ets/default/bean/LauncherFormDistribution';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';

export function LauncherFormDistributionTest() {
  describe('LauncherFormDistributionTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testConvert', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let distribution: LauncherFormDistribution　= LauncherFormDistribution.convert(layoutInfo);
      expect(distribution.cardType).assertEqual(AiSuggestionUpdateConstants.CardType.DEFAULT);
      expect(distribution.portfolioId).assertEqual(AiSuggestionConstants.PORTFOLIO_ID_DEFAULT);

      const extra: ExtraData = new ExtraData();
      extra.cardType = AiSuggestionUpdateConstants.CardType.TEMP;
      extra.portfolioId = 'portfolioId';
      const mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ExtraData, ExtraData.getExtend1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(extra);

      let formstackItemInfo: FormStackItemInfo = new FormStackItemInfo();
      distribution　= LauncherFormDistribution.convert(layoutInfo);
      expect(distribution.cardType).assertEqual(extra.cardType);
      expect(distribution.portfolioId).assertEqual(extra.portfolioId);
      expect(distribution.stackInfo).assertUndefined();

      let cardItemInfo: CardItemInfo = new CardItemInfo();
      formstackItemInfo.formStackId = 'formStackId';
      formstackItemInfo.layoutInfo = [[ cardItemInfo ]];
      distribution　= LauncherFormDistribution.convert(layoutInfo);
      expect(distribution.cardType).assertEqual(AiSuggestionUpdateConstants.CardType.TEMP);
      expect(distribution.portfolioId).assertEqual(extra.portfolioId);

      mocker.clear(ExtraData);
      mocker.clearAll();
    });
  });
}