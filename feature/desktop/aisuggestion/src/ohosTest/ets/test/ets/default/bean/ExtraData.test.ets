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
import Want from '@ohos.app.ability.Want';
import { BundleConstants, CardItemInfo, GridLayoutItemInfo } from '@ohos/launchercommon';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { AbilityFormUtil } from '../../../../../../main/ets/default/utils/AbilityFormUtil';

export function ExtraDataTest() {
  describe('ExtraDataTest', (): void => {
    const externalExtraData: ExtraData = new ExtraData();
    externalExtraData.commandId = 'commandId';
    externalExtraData.commandType = AiSuggestionUpdateConstants.CommandType.CREATE_FORM_STACK;
    externalExtraData.portfolioId = 'portfolioId';

    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testGetExtendData', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      expect(ExtraData.getExtendData(undefined)).assertNull();

      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      layoutInfo.extend1 = '';
      const mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ExtraData, ExtraData.getExtend1);
      when(mockFunc)(layoutInfo.extend1).afterReturn(externalExtraData);
      expect(ExtraData.getExtendData(layoutInfo)).assertEqual(externalExtraData);

      mocker.clear(ExtraData);
      mocker.clearAll();
    });

    it('testGetExtend1', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      expect(ExtraData.getExtend1(undefined)).assertNull();

      let want: Want = {};
      expect(ExtraData.getExtend1(JSON.stringify(want))).assertNull();

      want = { parameters: {} };
      // data字段未定义时，返回undefined
      expect(ExtraData.getExtend1(JSON.stringify(want))).assertNull();

      want = { parameters: { data: externalExtraData } };
      expect(ExtraData.getExtend1(JSON.stringify(want))?.commandId).assertEqual(externalExtraData.commandId);
    });

    it('testGetCommandId', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      expect(ExtraData.getCommandId(undefined)).assertNull();

      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      layoutInfo.extend1 = 'extend1';
      const mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ExtraData, ExtraData.getExtendData);
      when(mockFunc)(layoutInfo).afterReturnNothing();
      expect(ExtraData.getCommandId(layoutInfo)).assertUndefined();

      when(mockFunc)(layoutInfo).afterReturn(externalExtraData);
      expect(ExtraData.getCommandId(layoutInfo)).assertEqual(externalExtraData.commandId);

      mocker.clear(ExtraData);
      mocker.clearAll();
    });

    it('testGetCommandType', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {

      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      layoutInfo.extend1 = 'extend1';
      const mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ExtraData, ExtraData.getExtendData);
      when(mockFunc)(layoutInfo).afterReturnNothing();

      when(mockFunc)(layoutInfo).afterReturn(externalExtraData);

      mocker.clear(ExtraData);
      mocker.clearAll();
    });

    it('testGetPortfolioId', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      expect(ExtraData.getPortfolioId(undefined)).assertNull();

      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      layoutInfo.extend1 = 'extend1';
      const mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ExtraData, ExtraData.getExtendData);
      when(mockFunc)(layoutInfo).afterReturnNothing();
      expect(ExtraData.getPortfolioId(layoutInfo)).assertEqual('default');

      when(mockFunc)(layoutInfo).afterReturn(externalExtraData);
      expect(ExtraData.getPortfolioId(layoutInfo)).assertEqual(externalExtraData.portfolioId);

      mocker.clear(ExtraData);
      mocker.clearAll();
    });

    it('testSetPortfolioId', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      const portfolioId: string = 'portfolioId';
      ExtraData.setPortfolioId(undefined, portfolioId);

      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      ExtraData.setPortfolioId(layoutInfo, portfolioId);
      expect(ExtraData.getPortfolioId(layoutInfo)).assertEqual('default');

      layoutInfo.extend1 = JSON.stringify({
        parameters: {
          'data': {
            portfolioId: '',
          } as ExtraData
        } as Record<string, Object>
      } as Want);
      ExtraData.setPortfolioId(layoutInfo, portfolioId);
      expect(ExtraData.getPortfolioId(layoutInfo)).assertEqual(portfolioId);
    });

    it('testResetExtend1AfterAddSuccess', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      ExtraData.resetExtend1AfterAddSuccess(undefined);

      let itemInfo: CardItemInfo = new CardItemInfo();

      itemInfo.extend1 = JSON.stringify({} as Want);
      ExtraData.resetExtend1AfterAddSuccess(itemInfo);

      // extend1赋值
      itemInfo.extend1 = JSON.stringify({
        parameters: {
          'data': {
            commandType: 1
          } as ExtraData
        } as Record<string, Object>
      } as Want);

      // 测试extend1非空的分支
      ExtraData.resetExtend1AfterAddSuccess(itemInfo);
      let data: ExtraData  = JSON.parse(itemInfo.extend1 as string)?.parameters?.data as ExtraData;
      expect(data?.commandType).assertEqual(-1);
    });

    it('testUpdateVoiceCardType', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      ExtraData.updateVoiceCardType(AiSuggestionUpdateConstants.CardType.TEMP, undefined);

      let itemInfo: CardItemInfo = new CardItemInfo();
      itemInfo.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      itemInfo.abilityName = BundleConstants.AI_SUGGESTION_ABILITY;
      ExtraData.updateVoiceCardType(AiSuggestionUpdateConstants.CardType.TEMP, itemInfo);
      expect(itemInfo.extend1).assertUndefined();

      // extend1赋值
      itemInfo.extend1 = JSON.stringify({
        parameters: {
          'data': {
            cardType: AiSuggestionUpdateConstants.CardType.TEMP,
          } as ExtraData
        } as Record<string, Object>
      } as Want);

      // 测试extend1非空的分支
      ExtraData.updateVoiceCardType(AiSuggestionUpdateConstants.CardType.DEFAULT, itemInfo);
      // 成功执行updateVoiceCardType后extend1不为空
      let data: ExtraData = JSON.parse(itemInfo.extend1 as string)?.parameters?.data as ExtraData;
      expect(data.cardType).assertEqual(AiSuggestionUpdateConstants.CardType.DEFAULT);
    });

    it('testIsAddPortfolioCardToFormStack', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {
      expect(AbilityFormUtil.isAddPortfolioCardToFormStack(new ExtraData())).assertFalse();

      const data: ExtraData = new ExtraData();
      data.commandType = AiSuggestionUpdateConstants.CommandType.CREATE_FORM_STACK;
      expect(AbilityFormUtil.isAddPortfolioCardToFormStack(data)).assertTrue();

      data.commandType = AiSuggestionUpdateConstants.CommandType.ADD_CARD_TO_STACK;
      expect(AbilityFormUtil.isAddPortfolioCardToFormStack(data)).assertTrue();
    });

  });
}
