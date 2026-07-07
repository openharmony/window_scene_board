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
import { describe, it, expect } from '@ohos/hypium'

import { LocalStorageKey } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/constant/StorageKey';

export function StorageKeyTest() {
  describe('StorageKeyTest', () => {

    it('StorageKeyTest_LocalStorageKey', 0, () => {
      const pageName1 = LocalStorageKey.SCENE_TYPE;
      const pageName2 = LocalStorageKey.SESSION;
      const pageName3 = LocalStorageKey.TOP_PAGE_NAME;
      expect(pageName1 !== null).assertEqual(true);
    })

  });

}