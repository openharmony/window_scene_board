/**
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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { ViewData } from '../../../../main/ets/default/viewmodel/OuterEditCenterObservedData';
import { OuterIconCenterViewData } from '../../../../main/ets/default/viewmodel/OuterIconCenterViewData';

export function OuterIconCenterViewDataTest() {
  describe('OuterIconCenterViewDataTest', (): void => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getInstance', Level.LEVEL0, () => {
      const instance0 = OuterIconCenterViewData.getInstance();
      const instance1 = OuterIconCenterViewData.getInstance();
      expect(instance0).assertDeepEquals(instance1);
    })

    it('test_initData', Level.LEVEL0, () => {
      const instance = OuterIconCenterViewData.getInstance();
      let viewData: ViewData = instance.getViewData();
      expect(viewData).not().assertNull();
      let viewData1: ViewData = instance.getViewData(true);
      expect(viewData1).not().assertNull();
      let viewData2: ViewData = instance.getViewData(false);
      expect(viewData2).not().assertNull();
    })

    it('test_updateViewDate', Level.LEVEL0, () => {
      const instance = OuterIconCenterViewData.getInstance();
      instance.updateViewDate();
      expect(instance).not().assertNull();
      instance.updateViewDate(true);
      expect(instance).not().assertNull();
      instance.updateViewDate(false);
      expect(instance).not().assertNull();
    })
  })
}