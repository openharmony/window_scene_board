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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit } from '@ohos/hypium';
import { onLineThemeUtil } from '../../../../../../main/ets/utils/OnLineThemeUtil';

export function OnLineThemeUtilTest() {
  describe('OnLineThemeUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_setThemeOrigin_01', 0, (): void => {
      onLineThemeUtil.setThemeOrigin('');
      expect((onLineThemeUtil as object)['themeOrigin']).not().assertUndefined();
    })

    it('test_setThemeOrigin_02', 0, (): void => {
      const theme: string = 'theme';
      onLineThemeUtil.setThemeOrigin(theme);
      onLineThemeUtil.setThemeOrigin(theme);
      expect((onLineThemeUtil as object)['themeOrigin']).assertEqual(theme);
    })

    it('test_isOnlineTheme_01', 0, (): void => {
      const theme: string = 'theme';
      onLineThemeUtil.setThemeOrigin(theme);
      let isOnLine = onLineThemeUtil.isOnlineTheme();
      expect(isOnLine).not().assertUndefined();
    })
  })
}