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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { GlobalContext } from '../../../../../../main/ets/utils/GlobalContext';
import { ThemeUtils } from '../../../../../../main/ets/utils/ThemeUtils';
import { appManager } from '@kit.AbilityKit';

export function ThemeUtilsTest() {
  describe('ThemeUtilsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_preloadThemeExtAbility_01', 0, async (): Promise<void> => {
      await ThemeUtils.preloadThemeExtAbility(getContext());
      expect(true).assertTrue();
    })

    it('test_preloadThemeExtAbility_02', 0, async (): Promise<void> => {
      const context = GlobalContext.getContext();
      await ThemeUtils.preloadThemeExtAbility(context, true);
      expect(true).assertTrue();
    })

    it('test_preloadThemeExtAbility_03', 0, async (): Promise<void> => {
      const context: Context = GlobalContext.getInstance().getObject('') as Context;
      await ThemeUtils.preloadThemeExtAbility(context, true);
      expect(true).assertTrue();
    })

    it('test_preloadThemeExtAbility_04', 0, async (): Promise<void> => {
      let mocker:MockKit = new MockKit();
      let mockerFun :Function =  mocker.mockFunc(ThemeUtils,ThemeUtils.isThemeLoaded);
      when(mockerFun)(ArgumentMatchers.any).afterReturn(true);
      const context = GlobalContext.getContext();
      await ThemeUtils.preloadThemeExtAbility(context, true);
      mocker.clear(mockerFun);
      mocker.ignoreMock(ThemeUtils, mockerFun);
      mocker.clearAll();
      expect(true).assertTrue();
    })

    it('test_isThemeLoaded_01', 0, async (): Promise<void> => {
      let result = await ThemeUtils.isThemeLoaded();
      expect(result).not().assertNull();
    })
  })
}