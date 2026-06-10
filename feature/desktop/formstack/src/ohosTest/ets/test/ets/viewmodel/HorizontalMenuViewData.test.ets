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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
} from '@ohos/hypium';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { HorizontalMenuViewData } from '../../../../../main/ets/viewmodel//HorizontalMenuViewData';

export function HorizontalMenuViewDataTest() {
  describe('HorizontalMenuViewDataTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getItemBackgroundColor', 0, () => {
      const viewData: HorizontalMenuViewData = new HorizontalMenuViewData();
      expect(viewData.getItemBackgroundColor()).assertEqual(StyleConstants.DEFAULT_TRANSPARENT_COLOR);
    });

    it('updateShortcutName_test01', 0, () => {
      let viewData: HorizontalMenuViewData = new HorizontalMenuViewData();
      viewData.mHoverState = true;
      viewData.getItemBackgroundColor();
      expect(viewData).not().assertUndefined();

      viewData.mHoverState = false;
      viewData.mPressState = true;
      viewData.getItemBackgroundColor();
      expect(viewData).not().assertUndefined();

      viewData.mHoverState = false;
      viewData.mPressState = false;
      viewData.getItemBackgroundColor();
      expect(viewData).not().assertUndefined();
    });
  });
}