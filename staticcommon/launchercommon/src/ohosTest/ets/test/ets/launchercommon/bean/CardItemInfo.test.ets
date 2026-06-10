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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { CardItemInfo, CommonConstants } from '../../../../../../main/ets/TsIndex'
import { relationalStore } from '@kit.ArkData';

export default function CardItemInfoTest() {
  const CARD_SIZE_LENGTH = 2;
  const CARD_SIZE_MIDDLE_LENGTH = 2;
  const CARD_SIZE_SMALL_LENGTH = 1;
  const CARD_SIZE_LARGE_LENGTH = 4;
  const CARD_SIZE_LARGER_LENGTH = 6;
  const CARD_SIZE_ONE_TWO: number[] = [CARD_SIZE_MIDDLE_LENGTH, CARD_SIZE_SMALL_LENGTH];
  const CARD_SIZE_TWO_TWO: number[] = [CARD_SIZE_MIDDLE_LENGTH, CARD_SIZE_MIDDLE_LENGTH];
  const CARD_SIZE_TWO_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_MIDDLE_LENGTH];
  const CARD_SIZE_FOUR_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_LARGE_LENGTH];
  const CARD_SIZE_SIX_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_LARGER_LENGTH];
  describe('CardItemInfoTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_getCardDimension', 0, () => {
      const array: number[] = [1, 2, 3, 4, 5, 6];
      let ret: number = CardItemInfo.getCardDimension(array);
      expect(ret).assertEqual(CommonConstants.CARD_DIMENSION_2x2);

      ret = CardItemInfo.getCardDimension(null);
      expect(ret).assertEqual(CommonConstants.CARD_DIMENSION_2x2);

      let area: number[] = [2, 1];
      ret = CardItemInfo.getCardDimension(area);
      expect(ret).assertEqual(CommonConstants.CARD_DIMENSION_1x2);

      area = [2, 2];
      ret = CardItemInfo.getCardDimension(area);
      expect(ret).assertEqual(CommonConstants.CARD_DIMENSION_2x2);

      area = [4, 2];
      ret = CardItemInfo.getCardDimension(area);
      expect(ret).assertEqual(CommonConstants.CARD_DIMENSION_2x4);

      area = [4, 4];
      ret = CardItemInfo.getCardDimension(area);
      expect(ret).assertEqual(CommonConstants.CARD_DIMENSION_4x4);

      area = [4, 6];
      ret = CardItemInfo.getCardDimension(area);
      expect(ret).assertEqual(CommonConstants.CARD_DIMENSION_6x4);

      area = [99, 99];
      ret = CardItemInfo.getCardDimension(area);
      expect(ret).assertEqual(CommonConstants.CARD_DIMENSION_2x2);
    })

    it('test_getCardDimension01', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      item.id = '123456';
      item.name = 'CardDimension01';
      item.cardDimension = CommonConstants.CARD_DIMENSION_2x2;
      let a: number[] = [1, 1];
      let r: number = CardItemInfo.getCardDimension(a);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_2x2);
      item.area = a;
      let r1: number = CardItemInfo.getCardDimension(item.area);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_2x2);
    })

    it('test_getCardDimension02', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      item.id = 'CardDimension02';
      item.name = 'abc';
      item.cardDimension = CommonConstants.CARD_DIMENSION_2x2
      let a: number[] = [1, 2];
      let r: number = CardItemInfo.getCardDimension(a);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_2x2);
      item.area = a;
      let r1: number = CardItemInfo.getCardDimension(item.area);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_2x2);
    })
    it('test_getCardDimension03', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      item.id = '123456';
      item.name = 'CardDimension03';
      item.cardDimension = CommonConstants.CARD_DIMENSION_2x2
      let a: number[] = [2, 2];
      let r: number = CardItemInfo.getCardDimension(a);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_2x2);
      item.area = a;
      let r1: number = CardItemInfo.getCardDimension(item.area);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_2x2);
    })

    it('test_getCardDimension04', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      item.id = '123456';
      item.name = 'CardDimension04';
      item.cardDimension = CommonConstants.CARD_DIMENSION_2x2
      let a: number[] = [2, 1];
      let r: number = CardItemInfo.getCardDimension(a);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_1x2);
      item.area = [1, 2];
      let r1: number = CardItemInfo.getCardDimension(item.area);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_1x2);
    })
    it('test_getCardDimension05', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      item.id = '123456';
      item.name = 'CardDimension05';
      item.cardDimension = CommonConstants.CARD_DIMENSION_2x2;
      let a: number[] = [2, 4];
      let r: number = CardItemInfo.getCardDimension(a);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_2x2);
      item.area = [4, 2];
      let r1: number = CardItemInfo.getCardDimension(item.area);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_2x2);
    })
    it('test_getCardDimension06', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      item.id = '123456';
      item.name = 'CardDimension06';
      item.cardDimension = CommonConstants.CARD_DIMENSION_2x2
      let a: number[] = [4, 4];
      let r: number = CardItemInfo.getCardDimension(a);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_4x4);
      item.area = a;
      let r1: number = CardItemInfo.getCardDimension(item.area);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_4x4);
    })
    it('test_getCardDimension07', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      item.id = '123456';
      item.name = 'CardDimension07';
      item.cardDimension = CommonConstants.CARD_DIMENSION_2x2
      let a: number[] = [4, 2];
      let r: number = CardItemInfo.getCardDimension(a);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_2x4);
      item.area = [2, 4];
      let r1: number = CardItemInfo.getCardDimension(item.area);
      expect(r).assertEqual(CommonConstants.CARD_DIMENSION_2x4);
    })

    it('test_getCardSize', 0, () => {
      let ret: number[] = CardItemInfo.getCardSize(CommonConstants.CARD_DIMENSION_1x2);
      ret = CardItemInfo.getCardSize(CommonConstants.CARD_DIMENSION_2x2);
      ret = CardItemInfo.getCardSize(CommonConstants.CARD_DIMENSION_2x4);
      ret = CardItemInfo.getCardSize(CommonConstants.CARD_DIMENSION_4x4);
      ret = CardItemInfo.getCardSize(CommonConstants.CARD_DIMENSION_1x1);
      expect(ret[0]).assertEqual(CARD_SIZE_TWO_TWO[0]);
      expect(ret[1]).assertEqual(CARD_SIZE_TWO_TWO[1]);
    })

    it('test_toValuesBucket1', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      item.id = '1';
      item.name = 'getCardSize';
      item.cardDimension = CommonConstants.CARD_DIMENSION_2x2
      item.bundleName = 'bundleName';
      item.abilityName = 'abilityName'
      item.moduleName = 'moduleName';
      item.area = [2, 2];
      item.appLabelId = 123;
      const r = CardItemInfo.toValuesBucket(item);
      expect(r).not().assertNull();

      const FORM_TRANSPARENT: string = '1';
      item.isTransparent = true;
      let ret = CardItemInfo.toValuesBucket(item);
      expect(ret['extend2']).assertEqual(FORM_TRANSPARENT);
    })

    it('test_toValuesBucket2', 0, () => {
      const r = CardItemInfo.toValuesBucket(null);
      expect(r).not().assertNull();
    })

    it('test_toValuesBucket3', 0, () => {
      const r = CardItemInfo.toValuesBucket(undefined);
      expect(r).not().assertNull();
    })

    it('test_fromResultSet', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      let ret = item.fromResultSet(null);
      expect(ret).assertDeepEquals(item);
    })

    it('test_fromResultSet2', 0, async (done: Function) => {
      const item: CardItemInfo = new CardItemInfo();
      const resultSet: relationalStore.ResultSet = {
        getString: (_: number) => `{\"gameCardInfo\":\"{}\"}`,
        getColumnIndex: (_: string) => 0,
        getLong: (_: number) => 0,
      } as relationalStore.ResultSet;
      const ret = item.fromResultSet(resultSet);
      expect(ret).assertDeepEquals(item);
      done();
    })

  })
}
