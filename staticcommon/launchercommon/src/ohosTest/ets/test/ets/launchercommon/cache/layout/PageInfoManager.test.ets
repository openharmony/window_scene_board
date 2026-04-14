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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { PageInfoManager } from '../../../../../../../main/ets/cache/layout/PageInfoManager';

export default function PageInfoManagerTest() {
  describe('PageInfoManagerTest', () => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('isCurrentPageShow_indexInSwiper_0', 0, () => {
      let pageInfoManager: PageInfoManager = PageInfoManager.getInstance();
      let ret = pageInfoManager.isCurrentPageShow(0, 0);
      expect(ret).assertTrue();
    })

    it('isCurrentPageShow_disPlayCount_0', 0, () => {
      let pageInfoManager: PageInfoManager = PageInfoManager.getInstance();
      let disPlayCount = 0;
      pageInfoManager.setDisplayCount(disPlayCount);
      let ret = pageInfoManager.isCurrentPageShow(0, 1);
      expect(ret).assertFalse();
    })

    it('isCurrentPageShow_disPlayCount_1', 0, () => {
      let pageInfoManager: PageInfoManager = PageInfoManager.getInstance();
      let disPlayCount = 1;
      pageInfoManager.setDisplayCount(disPlayCount);
      let ret = pageInfoManager.isCurrentPageShow(0, 1);
      expect(ret).assertFalse();
    })

    it('isCurrentPageShow_disPlayCount_2', 0, () => {
      let pageInfoManager: PageInfoManager = PageInfoManager.getInstance();
      let disPlayCount = 2;
      pageInfoManager.setDisplayCount(disPlayCount);
      let ret = pageInfoManager.isCurrentPageShow(0, 5);
      expect(ret).assertFalse();
    })
  })
}