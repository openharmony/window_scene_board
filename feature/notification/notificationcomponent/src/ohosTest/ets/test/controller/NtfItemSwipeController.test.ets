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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { NtfItemSwipeController } from '../../../../main/ets/controller/NtfItemSwipeController'

export default function NtfItemSwipeControllerTest() {
  describe('NtfItemSwipeControllerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('ntf_item_swipe_test_head_up', 0, () => {
      const swipe: NtfItemSwipeController = new NtfItemSwipeController();
      expect((swipe as object)['isHeadsUpNtf']).assertFalse();
      swipe.setHeadsUpNtf(true);
      expect((swipe as object)['isHeadsUpNtf']).assertTrue();
    })

    it('ntf_item_swipe_test_menu_width', 0, () => {
      const swipe: NtfItemSwipeController = new NtfItemSwipeController();
      expect((swipe as object)['itemMenuWidth'] === 0).assertTrue();
      swipe.setItemMenuWidth(1);
      expect((swipe as object)['itemMenuWidth'] === 1).assertTrue();
    })

    it('ntf_item_swipe_test_item_width', 0, () => {
      const swipe: NtfItemSwipeController = new NtfItemSwipeController();
      swipe.setItemWidth(2);
      expect((swipe as object)['itemWidth'] === 2).assertTrue();
      expect((swipe as object)['itemWidth']).assertEqual(swipe.getItemWidth());

    })

    it('ntf_item_swipe_test_is_in_group', 0, () => {
      const swipe: NtfItemSwipeController = new NtfItemSwipeController();
      swipe.setIsInGroup(true);
      expect((swipe as object)['isInGroup']).assertTrue();
    })
  })
}