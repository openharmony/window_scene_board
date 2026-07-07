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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import {
  AodStyleListModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleListModel';
import { AodStyleModel } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleModel';

export function AodStyleListModelTest() {
  describe('AodStyleListModelTest', () => {

    beforeAll((): void => {

    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('test_AodStyleListModelTest1', 0, () => {
      let aodStyleListModel = new AodStyleListModel();
      expect(true).assertTrue();
    });

    it('test_AodStyleListModelTest2', 0, () => {
      let array: AodStyleModel[] = [new AodStyleModel()];
      let aodStyleListModel = new AodStyleListModel(array);
      expect(true).assertTrue();
    });

    it('test_AodStyleListModelTest3', 0, () => {
      let array: Array<AodStyleModel> = [new AodStyleModel()];
      let aodStyleListModel = new AodStyleListModel(array);
      expect(true).assertTrue();
    });
  });

}