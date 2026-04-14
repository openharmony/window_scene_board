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
import { it, describe, expect } from '@ohos/hypium';
import { LunarTerm } from '@ohos/systemuiutils/src/main/ets/calendar/LunarTerm';

export function LunarTermTest() {
  describe('LunarTermTest', (): void => {
    it('test_initLunarCalendar', 0, (): void => {
      let testInstance: LunarTerm = new LunarTerm();
      expect(testInstance instanceof LunarTerm).assertTrue();
    });
    it('test_setFromStr', 0, (): void => {
      let testInstance: LunarTerm = new LunarTerm();
      testInstance.setFromStr(2024, 6, 28);
      expect(testInstance instanceof LunarTerm).assertTrue();
    });
  });
}