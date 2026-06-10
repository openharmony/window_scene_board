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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import StyleManager, {
  CommonStyle,
  NavigationItemStyle,
  NoResultStyle,
  SheetFormStyle } from '../../../../../../main/ets/default/manager/StyleManager';

export default function StyleManagerTest() {
  describe('StyleManagerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    let navigationItemStyle: NavigationItemStyle = new NavigationItemStyle();
    let sheetFormStyle: SheetFormStyle = new SheetFormStyle();
    let noResultStyle: NoResultStyle = new NoResultStyle();
    let commonStyle: CommonStyle = new CommonStyle();

    it('getNavigationItemStyle_test01', 0, () => {
      (StyleManager as object)['navigationItemStyle'] = undefined;
      StyleManager.getNavigationItemStyle();
      expect(navigationItemStyle).not().assertUndefined();

      (StyleManager as object)['navigationItemStyle'] = navigationItemStyle;
      StyleManager.getNavigationItemStyle();
      expect(navigationItemStyle).not().assertUndefined();
    });

    it('getSheetFormStyle_test01', 0, () => {
      (StyleManager as object)['sheetFormStyle'] = undefined;
      StyleManager.getSheetFormStyle();
      expect(sheetFormStyle).not().assertUndefined();

      (StyleManager as object)['sheetFormStyle'] = sheetFormStyle;
      StyleManager.getSheetFormStyle();
      expect(sheetFormStyle).not().assertUndefined();
    });

    it('getNoResultStyle_test01', 0, () => {
      (StyleManager as object)['commonStyle'] = undefined;
      StyleManager.getNoResultStyle();
      expect(noResultStyle).not().assertUndefined();

      (StyleManager as object)['commonStyle'] = noResultStyle;
      StyleManager.getNoResultStyle();
      expect(noResultStyle).not().assertUndefined();
    });

    it('getCommonStyle_test01', 0, () => {
      (StyleManager as object)['commonStyle'] = undefined;
      StyleManager.getCommonStyle();
      expect(commonStyle).not().assertUndefined();

      (StyleManager as object)['commonStyle'] = commonStyle;
      StyleManager.getCommonStyle();
      expect(commonStyle).not().assertUndefined();
    });
  })
}