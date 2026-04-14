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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { LiveViewData } from '../../../../../../main/ets/liveview/data/LiveViewData';

const DEFAULT = 0;

export function LiveViewDataTest() {
  describe('LiveViewDataTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })

    afterEach((): void => {

    })

    it('update', DEFAULT, (): void => {
      let data: LiveViewData = new LiveViewData();
      data.setId(0);
      let update: () => void = (): void => {
        data.update(undefined);
      };
      expect(update).not().assertFail();
    })

    it('setCreatorUid', DEFAULT, (): void => {
      let data: LiveViewData = new LiveViewData();
      let update: () => void = (): void => {
        data.setCreatorBundleName('com.ohos.commonDialog', true);
      };
      expect(update).not().assertFail();
    })
  })
}
