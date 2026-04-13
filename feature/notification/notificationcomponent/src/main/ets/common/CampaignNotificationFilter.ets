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
import { Singleton } from '@ohos/systemuicommon/newTsIndex';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { BitUtil, LogWithHa } from '@ohos/systemuicommon';
import { LogDomain, Logger } from '@ohos/basicutils';
import notificationManager from '@ohos.notificationManager';

const TAG = 'CampaignNotificationFilter';
const CAMPAIGN_ENABLED_KEY = 'const.systemui.campaign_notification_enabled';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

export class CampaignNotificationFilter {
  @Singleton.decorate()
  static get instance(): CampaignNotificationFilter {
    return new CampaignNotificationFilter();
  }

  private isCampaignEnabled: boolean = true;

  public init(): void {
    try {
      log.showInfo(TAG, 'Get param for campaign_notification_enabled start');
      let paramValue = systemParameterEnhance.getSync(CAMPAIGN_ENABLED_KEY, 'true');
      this.isCampaignEnabled = paramValue === 'true';
      log.showInfo(TAG, 'Get param for campaign_notification_enabled success, param %{public}s, %{public}s',
        paramValue, this.isCampaignEnabled);
    } catch (e) {
      log.showError(TAG, `Get param for campaign_notification_enabled failed code: ${e?.code}, msg: ${e?.message}`);
    }
  }

  public filter(request?: notificationManager.NotificationRequest): boolean {
    if (request && !this.isCampaignEnabled && BitUtil.getStateByIdx(request.notificationControlFlags ?? 0, 25)) {
      LogWithHa.showWarn(log, TAG, `Campaign enabled ${this.isCampaignEnabled} for ${request.hashCode}`);
      return false;
    } else {
      return true;
    }
  }
}