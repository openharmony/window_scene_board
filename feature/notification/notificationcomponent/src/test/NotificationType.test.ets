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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { NotificationType } from '../main/ets/common/NotificationType';

export function NotificationTypeTest() {
  describe('NotificationTypeTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    it('NotificationTypeTest00', 0, (): void => {
      let notificationType: NotificationType = new NotificationType();
      expect(notificationType === undefined).assertFalse();
    })

    it('NotificationTypeTest01', 0, (): void => {
      let notificationType: NotificationType = new NotificationType();
      expect(notificationType != undefined).assertFalse();
    })
  })
}
