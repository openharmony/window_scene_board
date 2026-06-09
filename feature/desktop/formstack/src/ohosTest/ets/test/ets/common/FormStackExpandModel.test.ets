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
  expect, when,
  MockKit,
} from '@ohos/hypium';
import { CardItemInfo } from '@ohos/launchercommon';
import { FormStackExpandModel } from '../../../../../main/ets/common/FormStackExpandModel';
import { FormStackItemInfo } from '../../../../../main/ets/common/FormStackItemInfo';
import { FormStackTestUtil } from './FormStackTestUtil';
import { relationalStore } from '@kit.ArkData';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';

export function FormStackExpandModelTest() {
  describe('FormStackExpandModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initData', 0, () => {
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      expect(expandModel.initData({} as FormStackItemInfo)).assertFalse();

      let formStackInfo: FormStackItemInfo = FormStackTestUtil.createFormStackItemInfo(
        FormStackTestUtil.TEST_FORM_STACK_ID, 2);
      expect(expandModel.getAllCardsNum() < 1).assertTrue();
      expect(expandModel.initData(formStackInfo)).assertTrue();
      expect(expandModel.getAllCardsNum() >= 2).assertTrue();
    });

    it('resetData', 0, () => {
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      let formStackInfo: FormStackItemInfo = FormStackTestUtil.createFormStackItemInfo(
        FormStackTestUtil.TEST_FORM_STACK_ID, 2);
      expect(expandModel.initData(formStackInfo)).assertTrue();
      expandModel.resetData();
      expect(expandModel.getAllCardsNum() < 1).assertTrue();
    });

    it('getCardInfo', 0, () => {
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      let cardInfo: CardItemInfo = {
        id: 'cardId',
      } as CardItemInfo;
      expandModel.setCardInfo('123', cardInfo);
      expect(expandModel.getCardInfo('123')?.id).assertEqual('cardId');
    });

    it('setCardInfo', 0, () => {
      let idStr: string = '123456';
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      expandModel.setCardInfo('', {} as CardItemInfo);
      let cardInfo: CardItemInfo = {
        id: idStr,
      } as CardItemInfo;
      expect(expandModel.getCardInfo(idStr) === undefined).assertEqual(true);
      expandModel.setCardInfo(idStr, cardInfo);
      expect(expandModel.getCardInfo(idStr) !== undefined).assertEqual(true);
    });

    it('deleteAllCardInfo', 0, () => {
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      let cardInfo: CardItemInfo = {} as CardItemInfo;
      expandModel.setCardInfo('123456', cardInfo);
      expandModel.deleteAllCardInfo();
      expect(expandModel.getCardInfo('123456') === undefined).assertEqual(true);
    });

    it('deleteCardInfo', 0, () => {
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      expandModel.deleteCardInfo('');
      let cardInfo: CardItemInfo = {} as CardItemInfo;
      expandModel.setCardInfo('123456', cardInfo);
      expect(expandModel.getCardInfo('123456') !== undefined).assertEqual(true);
      expandModel.deleteCardInfo('123456');
      expect(expandModel.getCardInfo('123456') === undefined).assertEqual(true);
    });

    it('deleteForm', 0, () => {
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      expandModel.deleteForm('', true);
      const id: string = '123456';
      let cardInfo: CardItemInfo = FormStackTestUtil.createCardItemInfo(id);
      cardInfo.cardId = '';
      expandModel.setCardInfo(id, cardInfo);
      expandModel.deleteForm(id, true);
      expect(expandModel.getCardInfo(id)).assertEqual(undefined);
    });

    it('swapFormToTopOfFormStack', 0, () => {
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      expandModel.swapFormToTopOfFormStack('');
      const id: string = '123456';
      let cardInfo: CardItemInfo = FormStackTestUtil.createCardItemInfo(id);
      expandModel.setCardInfo(id, cardInfo);
      expandModel.swapFormToTopOfFormStack(id);
      expect(expandModel.getCardInfo(id) !== undefined).assertEqual(true);
    });

    it('getAllCards', 0, () => {
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      expandModel.setCardInfo('1234', new CardItemInfo());
      let length: number = expandModel.getAllCards().length;
      expect(length).assertEqual(1);
    });

    it('swapForm_test01', 0, () => {
      let cardInfo1: CardItemInfo = {
        id: 'a',
        container: 1,
        name: 'b',
        typeId: 0,
        cardId: 'c',
        bundleName: 'd',
        abilityName: 'e',
        moduleName: 'f',
        mainModuleName: 'g',
        cardName: 'h',
        cardDimension: 0,
        area: [1, 2, 3],
        description: 'aa',
        formConfigAbility: 'bb',
        appLabelId: 1,
        appName: 'cc',
        supportDimensions: [1, 2],
        page: 1,
        column: 1,
        row: 1,
        totleDimensionCount: 1,
        isTransparent: false,
        displayNameId: 0,
        dimension: 0,
        dragLayerWidth: 0,
        dragLayerHeight: 0,
        descriptionId: 0,
        showInCenter: false,
        renderingMode: 0,
        fromResultSet: (resultSet: relationalStore.ResultSet): CardItemInfo => {
          return new CardItemInfo();
        }
      } as CardItemInfo;
      let cardInfo2: CardItemInfo = {
        id: 'a',
        container: 1,
        name: 'b',
        typeId: 0,
        cardId: 'c',
        bundleName: 'd',
        abilityName: 'e',
        moduleName: 'f',
        mainModuleName: 'g',
        cardName: 'h',
        cardDimension: 0,
        area: [1, 2, 3],
        description: 'aa',
        formConfigAbility: 'bb',
        appLabelId: 1,
        appName: 'cc',
        supportDimensions: [1, 2],
        page: 1,
        column: 1,
        row: 1,
        totleDimensionCount: 1,
        isTransparent: false,
        displayNameId: 0,
        dimension: 0,
        dragLayerWidth: 0,
        dragLayerHeight: 0,
        descriptionId: 0,
        showInCenter: false,
        renderingMode: 0,
        fromResultSet: (resultSet: relationalStore.ResultSet): CardItemInfo => {
          return new CardItemInfo();
        }
      } as CardItemInfo;
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidCard);
      let mockFunc2 = mocker.mockFunc((expandModel as object), (expandModel as object)['getCardInfo']);
      when(mockFunc)('a').afterReturn(true);
      expandModel.swapForm('a', 'b');
      expect(expandModel).not().assertUndefined();

      when(mockFunc)('a').afterReturn(false);
      when(mockFunc)('b').afterReturn(true);
      expandModel.swapForm('a', 'b');
      expect(expandModel).not().assertUndefined();

      when(mockFunc)('a').afterReturn(false);
      when(mockFunc)('b').afterReturn(false);
      when(mockFunc2)('a').afterReturn(cardInfo1);
      when(mockFunc2)('b').afterReturn(cardInfo2);
      when(mockFunc1)(cardInfo1).afterReturn(false);
      expandModel.swapForm('a', 'b');
      expect(expandModel).not().assertUndefined();

      when(mockFunc)('a').afterReturn(false);
      when(mockFunc)('b').afterReturn(false);
      when(mockFunc2)('a').afterReturn(cardInfo1);
      when(mockFunc2)('b').afterReturn(cardInfo2);
      when(mockFunc1)(cardInfo1).afterReturn(true);
      when(mockFunc1)(cardInfo2).afterReturn(false);
      expandModel.swapForm('a', 'b');
      expect(expandModel).not().assertUndefined();

      when(mockFunc)('a').afterReturn(false);
      when(mockFunc)('b').afterReturn(false);
      when(mockFunc2)('a').afterReturn(cardInfo1);
      when(mockFunc2)('b').afterReturn(cardInfo2);
      when(mockFunc1)(cardInfo1).afterReturn(true);
      when(mockFunc1)(cardInfo2).afterReturn(true);
      expandModel.swapForm('a', 'b');
      expect(expandModel).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(FormStackUtil);
      mocker.clear((expandModel as object));
    });
  });
}