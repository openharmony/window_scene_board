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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry'
import NotificationListLimiter, {
  CAMPAIGN_NO_FOLDS_MAX_NUM_DEFAULT
} from '../../../../main/ets/model/NotificationListLimiter'

/**
 * NotificationListLimiter测试类
 */
export default function NotificationListLimiterTest() {
  describe('NotificationListLimiterTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_initCampaignNoFoldsMaxNum', 0, () => {
      let limiter: NotificationListLimiter = new NotificationListLimiter();
      const maxNum: number = limiter.initCampaignNoFoldsMaxNum();
      expect(maxNum).assertLargerOrEqual(CAMPAIGN_NO_FOLDS_MAX_NUM_DEFAULT);
    });

    it('test_limitNoGroupNumForCampaignNtf', 0, () => {
      let limiter: NotificationListLimiter = new NotificationListLimiter();
      let notificationMap: Map<string, NotificationEntry>[] = [];
      let uid: number = 100;
      for (let count = 0; count < 10; count++) {
        let ntf: NotificationEntry = new NotificationEntry();
        ntf.creatorUid = uid;
        ntf.groupName = String(count);
        ntf.deliveryTime = new Date().getTime();
        ntf.hashCode = String(count);
        let map: Map<string, NotificationEntry> = new Map();
        map.set(ntf.hashCode, ntf);
        notificationMap.push(map);
      }
      let listForDelete: NotificationEntry[] = limiter.limitNoGroupNumForCampaignNtf(notificationMap);
      expect(listForDelete.length).assertLargerOrEqual(0);
    });
  })
}