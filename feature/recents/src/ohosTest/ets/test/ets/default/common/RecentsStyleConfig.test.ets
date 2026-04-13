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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium';
import { RecentsStyleConfig } from '../../../../../../main/ets/default/common/RecentsStyleConfig';

export function RecentsStyleConfigTest() {
  describe('RecentsStyleConfigTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('RecentsStyleConfig_test', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let res = RecentsStyleConfig.getInstance();
      expect(res.missionCardWidthRatio).assertEqual(0.6);
      expect(res.mBottomMarginPercentage).assertEqual(0.2);
      expect(res.mBottomMarginPercentageForMulti).assertEqual(0.17);
      expect(res.mVerticalAppInfoLeftMargin).assertEqual(12);
      expect(res.mVerticalAppInfoRightMargin).assertEqual(12);
      expect(res.recentSpaceBetweenTitle).assertEqual(8);
      expect(res.mAppNameSize).assertEqual(16);
      expect(res.mAppIconSize).assertEqual(24);
    })

    it('RecentsStyleConfig_test_getInstance', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let res = RecentsStyleConfig.getInstance();
      expect(res).not().assertFail();
    })
  })
}