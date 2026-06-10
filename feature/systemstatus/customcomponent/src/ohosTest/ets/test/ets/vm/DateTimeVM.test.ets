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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { DateTimeVM } from '../../../../../main/ets/vm/DateTimeVM';

const dateTimeVM = new DateTimeVM();

export function DateTimeVMTest() {
  describe('DateTimeVMTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('DateTimeVM', Level.LEVEL1, (): void => {
      expect(dateTimeVM instanceof DateTimeVM).assertTrue();
    });

    it('updateOvTimeMillis', Level.LEVEL1, (): void => {
      dateTimeVM.updateOvTimeMillis(1000);

      const timeMillis: number = (dateTimeVM as object)['timeMillis'];

      expect(timeMillis).assertEqual(1000);
    });
  });
}