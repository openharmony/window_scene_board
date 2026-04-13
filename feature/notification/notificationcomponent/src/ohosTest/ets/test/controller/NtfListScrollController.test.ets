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
import { NtfListScrollController } from '../../../../main/ets/controller/NtfListScrollController'

export default function NtfListScrollControllerTest() {
  describe('NtfListScrollControllerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('ntf_list_scroll_test_scroller', 0, () => {
      const scroller = new NtfListScrollController();
      expect(scroller.getScroller() === (scroller as object)['scroller']).assertTrue()
    })

    it('ntf_list_scroll_test_reach_end', 0, () => {
      const scroller = new NtfListScrollController();
      scroller.setReachEnd(true);
      expect((scroller as object)['isReachEnd']).assertTrue()
      scroller.setReachEnd(false);
      expect((scroller as object)['isReachEnd']).assertFalse()
    })
  })
}