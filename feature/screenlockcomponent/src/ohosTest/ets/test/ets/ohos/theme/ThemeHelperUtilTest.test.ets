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
import  ThemeHelperUtil , {
  LockManifest
} from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
}
;

export default function ThemeHelperUtilTest() {

  describe('ThemeHelperUtilTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_isMirrorsToEnd_return', 0, (): void => {
      let result:boolean = ThemeHelperUtil.isMirrorsToEnd();
      expect(result).not().assertNull();
    })

    it('test_getLockManifest_return', 0, (): void => {
      let result:LockManifest = ThemeHelperUtil.getLockManifest();
      expect(result.clockVisible).assertEqual(true);
    })

    it('test_isStaticTheme_return', 0, (): void => {
      let result:boolean = ThemeHelperUtil.isStaticTheme();
      expect(result).not().assertNull();
    })

    it('test_isStaticTheme_isOuter_true_return', 0, (): void => {
      let result:boolean = ThemeHelperUtil.isStaticTheme(true);
      expect(result).not().assertNull();
    })

    it('test_getCurrentThemeInfo', 0, (): void => {
      ThemeHelperUtil.getCurrentThemeInfo(null);
      ThemeHelperUtil.getCurrentThemeInfo('729958');
      expect(true).assertTrue();
    })

    it('test_isStaticTheme_2', 0, () => {
      AppStorage.setOrCreate('engineThemeStatic', true);
      let result:boolean = ThemeHelperUtil.isStaticTheme();
      expect(result).assertEqual(true);
    })

    it('test_getLockManifest_2', 0, () => {
      let res:LockManifest = ThemeHelperUtil.getLockManifest(true);
      expect(res.clockVisible).assertEqual(true);
    })
  })
}