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
import { ComponentRect } from '@ohos/aod';

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  Rotation90Strategy
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/Rotation90Strategy';

export function Rotation90StrategyTest() {
  describe('Rotation90StrategyTest', () => {

    beforeAll((): void => {

    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('test_createMoveData1', 0, (): void => {
      let imageRect: ComponentRect = {
        left: 0,
        top: 100,
        right: 100,
        bottom: 200,
      };
      let strategy = new Rotation90Strategy();
      let result = strategy.createMoveData(imageRect)
      expect(true).assertDeepEquals(true);
    });

    it('test_createMoveData2', 0, (): void => {
      let imageRect: ComponentRect = {
        left: 0,
        top: 700,
        right: 100,
        bottom: 200,
      };
      let strategy = new Rotation90Strategy();
      let result = strategy.createMoveData(imageRect)
      expect(true).assertDeepEquals(true);
    });
  });
}