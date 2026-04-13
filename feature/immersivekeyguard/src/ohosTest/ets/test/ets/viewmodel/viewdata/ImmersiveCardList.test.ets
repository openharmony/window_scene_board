/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { ImmersiveCardList } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCardList';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';

export function ImmersiveCardListTest() {
  describe('ImmersiveCardListTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });


    it('showData', Level.LEVEL1, (): void => {
      let card = new ImmersiveCardList();
      let ntfData = new ImmersiveNtfData();
      card.setShowData(ntfData);
      card.setAnimData(ntfData);
      expect(card).not().assertNull();
    });

    it('animShowData1', Level.LEVEL1, (): void => {
      let card = new ImmersiveCardList();
      let ntfData = new ImmersiveNtfData();
      card.setAnimData(ntfData);
      expect(card).not().assertNull();
    });

    it('animShowData2', Level.LEVEL1, (): void => {
      let card = new ImmersiveCardList();
      card.setShowData();
      card.setAnimData();
      expect(card).not().assertNull();
    });

  });
}