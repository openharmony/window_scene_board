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

import { afterAll, afterEach, beforeEach, it, describe, expect } from '@ohos/hypium';
import { NotificationAnimationParas } from '../main/ets/common/NotificationAnimationParas';

export function NotificationAnimationParasTest() {
  describe('NotificationAnimationParasTest', (): void => {
    afterAll((): void => {
    })
    afterEach((): void => {
    })
    it('NotificationAnimationParasTest01', 0, (): void => {
      let notificationAnimationParas: NotificationAnimationParas = new NotificationAnimationParas(0, 0, 1, 1, 0);
      expect(notificationAnimationParas === undefined).assertFalse();
    })
    it('NotificationAnimationParasTest02', 0, (): void => {
      let notificationAnimationParas: NotificationAnimationParas = new NotificationAnimationParas(0, 0, 1, 1, 0);

      expect(notificationAnimationParas != undefined).assertFalse();
    })
    it('NotificationAnimationParasTest04', 0, (): void => {
      let notificationAnimationParas: NotificationAnimationParas = new NotificationAnimationParas(0, 0, 1, 1, 0);
      expect(notificationAnimationParas.ntfItemTranslateX).assertEqual(0);
    })
  })
}