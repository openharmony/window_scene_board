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
import { describe, expect, it } from '@ohos/hypium';
import { ThemeTrialCache } from '../../../../../main/ets/cache/ThemeTrialCache';

export default function ThemeTrialCacheTest() {
  describe('getInstanceTest', () => {
    it('ThemeTrialCacheTest_001', 0, () => {
      let ret: ThemeTrialCache = ThemeTrialCache.getInstance();
      expect(ret).not().assertNull();
    });

    it('ThemeTrialCacheTest_002', 0, () => {
      let ret: ThemeTrialCache = ThemeTrialCache.getInstance();
      expect(ret).not().assertNull();
    });

    it('ThemeTrialCacheTest_003', 0, () => {
      let ret: ThemeTrialCache = ThemeTrialCache.getInstance();
      let ret2: ThemeTrialCache = ThemeTrialCache.getInstance();
      expect(ret).assertEqual(ret2);
    });
  })
}