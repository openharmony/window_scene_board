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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, TestType } from '@ohos/hypium';
import { BreakPointService, GridLayoutOptions } from '../../../../../../main/ets/default/service/BreakPointService';

export function BreakPointServiceTest() {
  describe('BreakPointServiceTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('rowColOptions', TestType.FUNCTION | Level.LEVEL0, () => {
      const layoutOptions: GridLayoutOptions = BreakPointService.rowColOptions();
      expect(layoutOptions.rowOption.gutter).not().assertNull();
      expect(layoutOptions.rowOption.columns).not().assertNull();
      expect(layoutOptions.rowOption.breakpoints?.value).not().assertNull();
      expect(layoutOptions.rowOption.breakpoints?.reference).not().assertNull();
      expect(layoutOptions.colOption.span).not().assertNull();
      expect(layoutOptions.colOption.offset).not().assertNull();
    });
  })
}