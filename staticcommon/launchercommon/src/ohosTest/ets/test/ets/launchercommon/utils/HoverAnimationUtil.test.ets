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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { HoverAnimationUtil } from '../../../../../../../Index';

export default function HoverAnimationUtilTest() {
  describe('HoverAnimationUtilTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('smallItemHoverScale', 0, (): void => {
      let defaultScale: number = 1;
      HoverAnimationUtil.hoverEffect(true, true, (hoverScale: number) => {
        defaultScale = hoverScale;
      });
      expect(defaultScale).not().assertEqual(1);
    })

    it('smallItemNotHoverScale', 0, (): void => {
      let defaultScale: number = 1;
      HoverAnimationUtil.hoverEffect(false, true, (hoverScale: number) => {
        defaultScale = hoverScale;
      });
      expect(defaultScale).assertEqual(1);
    })

    it('bigItemHoverScale', 0, (): void => {
      let defaultScale: number = 1;
      HoverAnimationUtil.hoverEffect(true, false, (hoverScale: number) => {
        defaultScale = hoverScale;
      });
      expect(defaultScale).not().assertEqual(1);
    })

    it('bigItemNotHoverScale', 0, (): void => {
      let defaultScale: number = 1;
      HoverAnimationUtil.hoverEffect(false, false, (hoverScale: number) => {
        defaultScale = hoverScale;
      });
      expect(defaultScale).assertEqual(1);
    })
  })
}