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
import { afterEach, beforeEach, describe, expect, it } from '@ohos/hypium';
import notificationManager from '@ohos.notificationManager';
import { CampaignNotificationFilter } from '../../../../main/ets/common/CampaignNotificationFilter';

export default function CampaignNotificationFilterTest() {
  describe('CampaignNotificationFilterTest', () => {
    const filter = CampaignNotificationFilter.instance;
    const campNtfReq: notificationManager.NotificationRequest = {
      content: {},
      notificationControlFlags: 1 << 25
    };

    let currEnabled = false;

    beforeEach(() => {
      currEnabled = Reflect.get(filter, 'isCampaignEnabled');
    });

    afterEach(() => {
      Reflect.set(filter, 'isCampaignEnabled', currEnabled);
    });

    it('should_return_true_when_undefined_request_on_filter', 0, () => {
      const ret = filter.filter(undefined);
      expect(ret).assertTrue();
    })

    it('should_return_true_when_is_campaign_enabled_given_campaign_notification_on_filter', 0, () => {
      Reflect.set(filter, 'isCampaignEnabled', true);
      const ret = CampaignNotificationFilter.instance.filter(campNtfReq);
      expect(ret).assertTrue();
    })

    it('should_return_true_when_disable_campaign_notification_given_not_campaign_notification_on_filter', 0, () => {
      Reflect.set(filter, 'isCampaignEnabled', false);
      const ret = CampaignNotificationFilter.instance.filter({ content: {}, });
      expect(ret).assertTrue();
    })

    it('should_return_false_when_disable_campaign_notification_given_campaign_notification_on_filter', 0, () => {
      Reflect.set(filter, 'isCampaignEnabled', false);
      const ret = CampaignNotificationFilter.instance.filter(campNtfReq);
      expect(ret).assertFalse();
    })
  });
}