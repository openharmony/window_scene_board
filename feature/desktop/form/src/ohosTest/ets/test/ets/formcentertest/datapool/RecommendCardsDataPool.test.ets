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
import { CardItemInfo } from '@ohos/launchercommon';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, TestType } from '@ohos/hypium';
import RecommendCardsDataPool from '../../../../../../main/ets/default/datapool/RecommendCardsDataPool';

export function RecommendCardsDataPoolTest() {
  describe('RecommendCardsDataPoolTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getFormCount', TestType.FUNCTION | Level.LEVEL0, () => {
      const pool: RecommendCardsDataPool = RecommendCardsDataPool.getInstance();
      const count: number | undefined = pool.getFormCount('test');
      expect(count).assertUndefined();
    });

    it('getRecommendForm_emptyForm', TestType.FUNCTION | Level.LEVEL0, () => {
      const pool: RecommendCardsDataPool = RecommendCardsDataPool.getInstance();
      let formItemList: CardItemInfo[] = [];
      expect(pool.getRecommendForm(formItemList) === null).assertTrue();
    });

    it('getRecommendForm_SmallForm', TestType.FUNCTION | Level.LEVEL0, () => {
      const pool: RecommendCardsDataPool = RecommendCardsDataPool.getInstance();
      let formItemList: CardItemInfo[] = [];
      let formItem: CardItemInfo = new CardItemInfo();
      formItem.cardId = '1234';
      formItem.cardDimension = 2;
      formItem.supportDimensions = [2];
      formItemList.push(formItem);
      expect(pool.getRecommendForm(formItemList).cardId === formItem.cardId).assertTrue();
      formItemList = [];
      formItem.supportDimensions = [3];
      formItemList.push(formItem);
      expect(pool.getRecommendForm(formItemList) === null).assertFalse();
    });

    it('getRecommendForm_MediumForm', TestType.FUNCTION | Level.LEVEL0, () => {
      const pool: RecommendCardsDataPool = RecommendCardsDataPool.getInstance();
      let formItemList: CardItemInfo[] = [];
      let formItem: CardItemInfo = new CardItemInfo();
      formItem.cardId = '2345';
      formItem.cardDimension = 3;
      formItem.supportDimensions = [3];
      formItemList.push(formItem);
      expect(pool.getRecommendForm(formItemList) === null).assertFalse();
    });
  })
}