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
import { AodManifest } from '@ohos/aod';

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  AodStyleImageManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/manager/AodStyleImageManager';

export function AodStyleImageManagerTest() {
  describe('AodStyleImageManagerTest', () => {

    beforeAll((): void => {

    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('only_one_instance_when_call_any_times_of_getInstance', 0, () => {
      const instance0 = AodStyleImageManager.getInstance();
      const instance1 = AodStyleImageManager.getInstance();
      expect(instance0).assertDeepEquals(instance1);
    });

    it('AodStyleImageManagerTest_loadWallpaper1', 0, () => {
      const instance = AodStyleImageManager.getInstance();
      let aodManifest = new AodManifest();
      instance.loadWallpaper(aodManifest);
      expect(instance !== null).assertEqual(true);
    })

  });

}