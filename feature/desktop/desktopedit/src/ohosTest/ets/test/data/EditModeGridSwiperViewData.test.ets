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
import { beforeAll, beforeEach, describe, expect, it, afterEach, afterAll } from '@ohos/hypium';
import { EditModeGridSwiperViewData } from '../../../../main/ets/default/data/EditModeGridSwiperViewData';

export function EditModeGridSwiperViewDataTest() {
  describe('EditModeGridSwiperViewDataTest', (): void => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getGridSwiperScale', 0, () => {
      const editModeGridSwiperViewData = new EditModeGridSwiperViewData();
      expect(editModeGridSwiperViewData.getGridSwiperScale()).assertEqual(1);
    })

    it('test_setGridSwiperScale', 0, () => {
      const editModeGridSwiperViewData = new EditModeGridSwiperViewData();
      expect(editModeGridSwiperViewData.setGridSwiperScale(2) === undefined).assertTrue();
    })
  })
}