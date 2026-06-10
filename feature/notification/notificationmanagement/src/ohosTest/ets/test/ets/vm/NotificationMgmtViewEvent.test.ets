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
import { NotificationMgmtViewData } from '../../../../../main/ets/vm/NotificationMgmtViewData';
import { NotificationMgmtViewEvent } from '../../../../../main/ets/vm/NotificationMgmtViewEvent';

export function NotificationMgmtViewEventTest() {
  const nNotificationMgmtViewEventModel: NotificationMgmtViewEvent = new NotificationMgmtViewEvent();
  describe('NotificationMgmtViewEventTest', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('NotificationMgmtViewEvent_initNavModeTest01', 0, (): void => {
      nNotificationMgmtViewEventModel.initNavMode(NavigationMode.Split);
      expect((nNotificationMgmtViewEventModel as object)['viewData']['hideBackButton']).assertTrue();
    })

    it('NotificationMgmtViewEvent_onNavModeChangedTest01', 0, (): void => {
      nNotificationMgmtViewEventModel.onNavModeChanged(NavigationMode.Split);
      expect((nNotificationMgmtViewEventModel as object)['viewData']['hideBackButton']).assertTrue();
    })
  })
}
