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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import {
  AnimStyleType
} from '../../../../../../../main/ets/model/data/anim/ImmersiveAnimStyle';

export function ImmersiveAnimStyleTest() {
  describe('ImmersiveAnimStyleTest', (): void => {
    beforeAll((): void => {

    });

    beforeEach((): void => {

    });

    afterAll((): void => {

    });

    afterEach((): void => {

    });

    it('AnimStyleType_RADIUS', Level.LEVEL1, (): void => {
      expect(AnimStyleType.RADIUS).not().assertNull();
    });

    it('AnimStyleType_PADDING_TOP', Level.LEVEL1, (): void => {
      expect(AnimStyleType.PADDING_TOP).not().assertNull();
    });

    it('AnimStyleType_PADDING_LEFT', Level.LEVEL1, (): void => {
      expect(AnimStyleType.PADDING_LEFT).not().assertNull();
    });

    it('AnimStyleType_MARGIN_TOP', Level.LEVEL1, (): void => {
      expect(AnimStyleType.MARGIN_TOP).not().assertNull();
    });

    it('AnimStyleType_MARGIN_LEFT', Level.LEVEL1, (): void => {
      expect(AnimStyleType.MARGIN_LEFT).not().assertNull();
    });

    it('AnimStyleType_MARGIN_RIGHT', Level.LEVEL1, (): void => {
      expect(AnimStyleType.MARGIN_RIGHT).not().assertNull();
    });

    it('AnimStyleType_TRAN_Y', Level.LEVEL1, (): void => {
      expect(AnimStyleType.TRAN_Y).not().assertNull();
    });

    it('AnimStyleType_ALPHA', Level.LEVEL1, (): void => {
      expect(AnimStyleType.ALPHA).not().assertNull();
    });

    it('AnimStyleType_RADIUS02', Level.LEVEL1, (): void => {
      expect(AnimStyleType.RADIUS).not().assertNull();
    });

    it('AnimStyleType_PADDING_TOP02', Level.LEVEL1, (): void => {
      expect(AnimStyleType.PADDING_TOP).not().assertNull();
    });

    it('AnimStyleType_PADDING_LEFT02', Level.LEVEL1, (): void => {
      expect(AnimStyleType.PADDING_LEFT).not().assertNull();
    });

    it('AnimStyleType_MARGIN_TOP02', Level.LEVEL1, (): void => {
      expect(AnimStyleType.MARGIN_TOP).not().assertNull();
    });

    it('AnimStyleType_MARGIN_LEFT02', Level.LEVEL1, (): void => {
      expect(AnimStyleType.MARGIN_LEFT).not().assertNull();
    });

    it('AnimStyleType_MARGIN_RIGHT02', Level.LEVEL1, (): void => {
      expect(AnimStyleType.MARGIN_RIGHT).not().assertNull();
    });

    it('AnimStyleType_TRAN_Y02', Level.LEVEL1, (): void => {
      expect(AnimStyleType.TRAN_Y).not().assertNull();
    });

    it('AnimStyleType_ALPHA02', Level.LEVEL1, (): void => {
      expect(AnimStyleType.ALPHA).not().assertNull();
    });
  });
}