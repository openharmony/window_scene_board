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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { EditModeSingePageViewData } from '../../../../main/ets/default/data/EditModeSingePageViewData';

export function EditModeSingePageViewDataTest() {
  describe('EditModeSingePageViewDataTest', (): void => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getSingePageSwiperScale', 0, () => {
      const editModeSingePageViewData = new EditModeSingePageViewData();
      expect(editModeSingePageViewData.getSingePageSwiperScale()).assertEqual(1);
    })

    it('test_setSingePageSwiperScale', 0, () => {
      const editModeSingePageViewData = new EditModeSingePageViewData();
      expect(editModeSingePageViewData.setSingePageSwiperScale(2) === undefined).assertTrue();
    })

    it('test_getSingePageBackgroundOpacity', 0, () => {
      const editModeSingePageViewData = new EditModeSingePageViewData();
      expect(editModeSingePageViewData.getSingePageBackgroundOpacity()).assertEqual(0);
    })

    it('test_setSingePageBackgroundOpacity', 0, () => {
      const editModeSingePageViewData = new EditModeSingePageViewData();
      expect(editModeSingePageViewData.setSingePageBackgroundOpacity(1) === undefined).assertTrue();
    })
  })
}