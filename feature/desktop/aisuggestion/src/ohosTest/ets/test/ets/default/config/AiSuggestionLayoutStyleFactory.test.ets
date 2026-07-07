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
import { CommonConstants, GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AiSuggestionLayoutStyle } from '../../../../../../main/ets/default/config/AiSuggestionLayoutStyle';
import {
  AiSuggestionLayoutStyleFactory
} from '../../../../../../main/ets/default/config/AiSuggestionLayoutStyleFactory';
import {
  AiSuggestionMidLayoutStyle
} from '../../../../../../main/ets/default/config/AiSuggestionMidLayoutStyle';
import { AiSuggestionLargeLayoutStyle } from '../../../../../../main/ets/default/config/AiSuggestionLargeLayoutStyle';
import { AiSuggestionMinLayoutStyle } from '../../../../../../main/ets/default/config/AiSuggestionMinLayoutStyle';

/**
 * AiSuggestionLayoutStyleFactoryTest
 *
 * @since 2024-05-10
 */
export function AiSuggestionLayoutStyleFactoryTest() {
  describe('AiSuggestionLayoutStyleFactoryTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('testCreateLayoutStyle', 0, () => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.cardDimension = CommonConstants.CARD_DIMENSION_2x4;
      let style: AiSuggestionLayoutStyle = AiSuggestionLayoutStyleFactory.createLayoutStyle(itemInfo);
      expect(style instanceof AiSuggestionMidLayoutStyle).assertTrue();

      itemInfo.cardDimension = CommonConstants.CARD_DIMENSION_2x2;
      style = AiSuggestionLayoutStyleFactory.createLayoutStyle(itemInfo);
      expect(style instanceof AiSuggestionMinLayoutStyle).assertTrue();

      itemInfo.cardDimension = CommonConstants.CARD_DIMENSION_4x4;
      style = AiSuggestionLayoutStyleFactory.createLayoutStyle(itemInfo);
      expect(style instanceof AiSuggestionLargeLayoutStyle).assertTrue();
    });
  })
}