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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import {
  CapItemId,
} from '../../../../../../main/ets/common/constants/CapsuleLayoutStyle';

export function CapsuleLayoutStyleTest() {
  describe('CapsuleLayoutStyleTest', (): void => {
    beforeAll((): void => {

    });

    beforeEach((): void => {

    });

    afterAll((): void => {

    });

    afterEach((): void => {

    });

    it('CapItemId_ROOT_ID', Level.LEVEL1, (): void => {
      expect(CapItemId.ROOT_ID).not().assertNull();
    });

    it('CapItemId_ICON_AREA', Level.LEVEL1, (): void => {
      expect(CapItemId.ICON_AREA).not().assertNull();
    });

    it('CapItemId_LARGE_ICON', Level.LEVEL1, (): void => {
      expect(CapItemId.LARGE_ICON).not().assertNull();
    });

    it('CapItemId_EXTEND_AREA', Level.LEVEL1, (): void => {
      expect(CapItemId.EXTEND_AREA).not().assertNull();
    });

    it('CapItemId_TITLE_TEXT', Level.LEVEL1, (): void => {
      expect(CapItemId.TITLE_TEXT).not().assertNull();
    });

    it('CapItemId_CONTENT_TEXT', Level.LEVEL1, (): void => {
      expect(CapItemId.CONTENT_TEXT).not().assertNull();
    });

    it('CapItemId_ROOT_ID02', Level.LEVEL1, (): void => {
      expect(CapItemId.ROOT_ID).not().assertNull();
    });

    it('CapItemId_ICON_AREA02', Level.LEVEL1, (): void => {
      expect(CapItemId.ICON_AREA).not().assertNull();
    });

    it('CapItemId_LARGE_ICON02', Level.LEVEL1, (): void => {
      expect(CapItemId.LARGE_ICON).not().assertNull();
    });

    it('CapItemId_EXTEND_AREA02', Level.LEVEL1, (): void => {
      expect(CapItemId.EXTEND_AREA).not().assertNull();
    });

    it('CapItemId_TITLE_TEXT02', Level.LEVEL1, (): void => {
      expect(CapItemId.TITLE_TEXT).not().assertNull();
    });

    it('CapItemId_CONTENT_TEXT02', Level.LEVEL1, (): void => {
      expect(CapItemId.CONTENT_TEXT).not().assertNull();
    });
  });
}