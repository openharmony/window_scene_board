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
import { BlurButtonVM } from '../main/ets/vm/BlurButtonVM';

export function NotificationConfigTest() {
  describe('NotificationConfigTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })
    it('BlurButtonModelVMTest01', 0, (): void => {
      let blurButtonvm: BlurButtonVM = new BlurButtonVM();
      blurButtonvm.blur({ x: 1, y: 1 });
      expect(blurButtonvm.getShouldBlur() === true).assertTrue();
      blurButtonvm.unblur();
      expect(blurButtonvm.getShouldBlur() === false).assertTrue();
    })
  })
}