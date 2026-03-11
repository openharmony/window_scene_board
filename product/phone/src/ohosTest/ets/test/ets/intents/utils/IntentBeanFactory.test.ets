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
import { IntentItemConstants } from '@ohos/phonebase/src/main/ets/intents/utils/IntentConstants';
import { IntentNameConstants } from '@ohos/phonebase/src/main/ets/intents/IntentCodeConstant';
import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { IntentBeanFactory } from '@ohos/phonebase/src/main/ets/intents/utils/IntentBeanFactory';
export default function IntentBeanFactoryTest() {
  describe('getDesktopSlideSwitch_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_throw_error_when_itemName_is_not_valid', 0, () => {
      let itemName: string = "invalidItem";
      try {
        IntentBeanFactory.build(itemName);
      } catch (e) {
        expect(e.message).assertEqual('item not valid: ' + itemName);
      }

    });
  });
}