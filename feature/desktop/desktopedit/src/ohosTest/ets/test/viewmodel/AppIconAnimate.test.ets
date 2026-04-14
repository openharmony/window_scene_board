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
import { describe, it, Level, beforeAll, beforeEach, afterEach, afterAll, expect } from '@ohos/hypium';
import { AppIconAnimate } from '../../../../main/ets/default/viewmodel/AppIconAnimate';
import { AppIconItemData } from '../../../../main/ets/default/viewmodel/OuterEditCenterObservedData';

export function AppIconAnimateTest() {
  describe('AppIconAnimateTest', (): void => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_initData', Level.LEVEL0, () => {
      const appIconAnimate: AppIconAnimate = new AppIconAnimate();
      let appIconItemData: AppIconItemData = new AppIconItemData();
      appIconAnimate.initData(appIconItemData);
      expect(appIconAnimate).not().assertNull();
    })

    it('test_scaleAnimate_1', Level.LEVEL0, () => {
      const appIconAnimate: AppIconAnimate = new AppIconAnimate();
      appIconAnimate.scaleAnimate(false);
      expect(appIconAnimate).not().assertNull();
    })

    it('test_scaleAnimate_2', Level.LEVEL0, () => {
      const appIconAnimate: AppIconAnimate = new AppIconAnimate();
      appIconAnimate.scaleAnimate(false);
      expect(appIconAnimate).not().assertNull();
    })

    it('test_getPressAnimParams_1', Level.LEVEL0, () => {
      const appIconAnimate: AppIconAnimate = new AppIconAnimate();
      let pressAnimParams = appIconAnimate.getPressAnimParams(false);
      expect(pressAnimParams).not().assertNull();
    })

    it('test_getPressAnimParams_2', Level.LEVEL0, () => {
      const appIconAnimate: AppIconAnimate = new AppIconAnimate();
      let pressAnimParams2 = appIconAnimate.getPressAnimParams(true);
      expect(pressAnimParams2).not().assertNull();
    })
  })
}