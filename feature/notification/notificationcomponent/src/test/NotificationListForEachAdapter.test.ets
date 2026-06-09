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
import { GlobalContextOne } from '../../../notificationmanagement/src/main/ets/MainAbility/GlobalContextOne';
import { NotificationListAdapter } from '../main/ets/model/NotificationListAdapter';

export function NotificationListAdapterTest() {
  describe('NotificationListAdapterTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    it('NotificationListAdapterTest00', 0, (): void => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      expect(notificationListAdapter === undefined).assertFalse();
    })

    it('NotificationListAdapterTest01', 0, (): void => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      expect(notificationListAdapter != undefined).assertFalse();
    })

    it('shouldVibrationTest01',0,  (): void => {
      GlobalContextOne.getContext().setObject("key1", "value1");
      let ret: Object = GlobalContextOne.getContext().getObject("key1")!;
      expect(ret).assertEqual("value1");
      GlobalContextOne.getContext().setObject("key2", "value2");
      let ret1: Object = GlobalContextOne.getContext().getObject("key2")!;
      expect(ret1).assertEqual("value2");
    })
  })
}