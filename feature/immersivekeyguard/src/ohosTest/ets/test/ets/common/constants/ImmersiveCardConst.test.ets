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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {
  ImmersiveCardConst,
  ImmersiveCardBackButtonParam
} from '../../../../../../main/ets/common/constants/ImmersiveCardConst';

export function ImmersiveCardConstTest() {
  describe('ImmersiveCardConstTest', (): void => {
    beforeAll((): void => {

    });

    beforeEach((): void => {

    });

    afterAll((): void => {

    });

    afterEach((): void => {

    });

    it('ImmersiveCardConst_CARD_RADIUS', Level.LEVEL1, (): void => {
      expect(ImmersiveCardConst.CARD_RADIUS).not().assertNull();
    });

    it('ImmersiveCardConst_CARD_LR_PADDING', Level.LEVEL1, (): void => {
      expect(ImmersiveCardConst.CARD_LR_PADDING).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_BACKGROUND_DIAMETER', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.BACKGROUND_DIAMETER).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_BACKGROUND_OPACITY', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.BACKGROUND_OPACITY).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_ARROW_SIZE', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.ARROW_SIZE).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_MARGIN_TOP', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.MARGIN_TOP).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_MARGIN_BOTTOM', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.MARGIN_BOTTOM).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_MARGIN_START', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.MARGIN_START).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_MARGIN_END', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.MARGIN_END).not().assertNull();
    });

    it('ImmersiveCardConst_CARD_RADIUS02', Level.LEVEL1, (): void => {
      expect(ImmersiveCardConst.CARD_RADIUS).not().assertNull();
    });

    it('ImmersiveCardConst_CARD_LR_PADDING02', Level.LEVEL1, (): void => {
      expect(ImmersiveCardConst.CARD_LR_PADDING).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_BACKGROUND_DIAMETER02', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.BACKGROUND_DIAMETER).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_BACKGROUND_OPACITY02', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.BACKGROUND_OPACITY).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_ARROW_SIZE02', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.ARROW_SIZE).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_MARGIN_TOP02', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.MARGIN_TOP).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_MARGIN_BOTTOM02', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.MARGIN_BOTTOM).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_MARGIN_START02', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.MARGIN_START).not().assertNull();
    });

    it('ImmersiveCardBackButtonParam_MARGIN_END02', Level.LEVEL1, (): void => {
      expect(ImmersiveCardBackButtonParam.MARGIN_END).not().assertNull();
    });
  });
}