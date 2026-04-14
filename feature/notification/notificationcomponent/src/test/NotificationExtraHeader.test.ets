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
import { NotificationExtraHeader } from '../main/ets/pages/phone/NotificationExtraHeader';

export function NotificationExtraHeaderTest() {
  describe('NotificationExtraHeaderTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {
    })
    it('NotificationExtraHeaderTest00', 0, (): void => {
      let notificationExtraHeader: NotificationExtraHeader = new NotificationExtraHeader();
      expect(notificationExtraHeader === undefined).assertFalse();
    })

    it('NotificationExtraHeaderTest01', 0, (): void => {
      let notificationExtraHeader: NotificationExtraHeader = new NotificationExtraHeader();
      expect(notificationExtraHeader != undefined).assertTrue();
    })
  })
}